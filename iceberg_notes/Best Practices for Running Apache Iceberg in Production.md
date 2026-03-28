# Best Practices for Running Apache Iceberg in Production
[Video Link](https://youtu.be/HdyW0yBUQvQ?si=5Wxw30yf-pkeS_D1)

1. [Architecture & Deployment Strategy](#1️⃣-architecture--deployment-strategy)
2. [Schema & Partition Design](#2️⃣-schema--partition-design)
3. [Data Ingestion & File Management](#3️⃣-data-ingestion--file-management)
4. [Query Optimization](#4️⃣-query-optimization)
5. [Maintenance & Table Management](#5️⃣-maintenance--table-management)
6. [Time Travel and Auditing](#6️⃣-time-travel-and-auditing)
7. [Monitoring, Observability and Lineage](#7️⃣-monitoring-observability-and-lineage)

---

## 1️⃣ Architecture & Deployment Strategy

* Decouple storage and compute
* Store tables in cloud object storage:

  * Amazon S3
  * Azure Data Lake Storage
  * Google Cloud Storage
* Use external compute engines:

  * Apache Spark
  * Trino
  * Apache Flink
  * Snowflake
* Use a catalog layer:

  * Hive catalog
  * AWS Glue
  * AWS Lake Formation
  * Project Nessie
  * Project Arctic
  * REST catalog
* Build modular architecture

---

## 2️⃣ Schema & Partition Design
- [Use safe schema evolution](#use-safe-schema-evolution)
- [Avoid immediate column drops (use deprecation phase)](#avoid-immediate-column-drops-use-deprecation-phase)
- [Use column comments and metadata properties](#use-column-comments-and-metadata-properties)
- [Track schema changes with versioning](#track-schema-changes-with-versioning)
- [Use hidden partitioning](#use-hidden-partitioning)

### Use safe schema evolution

**"Safe"** means Iceberg uses **Unique Column IDs** instead of names or positions to track data. This allows you to change the table structure without breaking existing data or rewriting files.

#### ✅ Safe Operations (Metadata-only changes)

* **Add Column:** Assigns a new ID; old rows return `null`.
* **Rename Column:** Changes the "label" for an ID; data stays linked to the ID.
* **Reorder Columns:** Moves columns around without affecting data mapping.
* **Type Promotion:** Widening a type (e.g., `INT` → `LONG` or `FLOAT` → `DOUBLE`).

#### ❌ Unsafe Operations (Potential data loss)

* **Narrowing Types:** Changing `DOUBLE` → `FLOAT` or `LONG` → `INT` (causes overflow/precision loss).
* **Dropping Columns:** While supported, you lose the ability to collect that data moving forward.
* **Logical Renames:** Renaming `price_usd` to `price_eur` without converting the actual numbers.

**Key Takeaway:** Because Iceberg tracks IDs, the physical data files never need to be modified for these schema changes, making them instant and risk-free for your existing datasets.

### Avoid immediate column drops (use deprecation phase)

**Step 1** — Mark as deprecated (metadata flag)
```SQL
ALTER TABLE prod.catalog.sales
ALTER COLUMN old_column
SET COMMENT 'DEPRECATED: to be removed after 2026-01';
```
**Step 2** — Stop using in pipelines
(Handled in code, not SQL) - make sure whole pipeline is not using the column at all.

**Step 3** — Drop later
```SQL
ALTER TABLE prod.catalog.sales
DROP COLUMN old_column;
```

### Use column comments and metadata properties
- Column comment at creation
```SQL
CREATE TABLE prod.catalog.sales (
    id BIGINT COMMENT 'Primary key',
    amount DOUBLE COMMENT 'Transaction amount in USD',
    created_at TIMESTAMP COMMENT 'Event creation timestamp'
)
USING iceberg;
```
- Table properties
```SQL
ALTER TABLE prod.catalog.sales
SET TBLPROPERTIES (
    'owner' = 'data-platform',
    'data_retention_days' = '365'
);
```

### Track schema changes with versioning
- Inspect schema history
```SQL
SELECT * FROM prod.catalog.sales.snapshots;
```
- Describe table history
```SQL
DESCRIBE HISTORY prod.catalog.sales;
```

### Use hidden partitioning
- Partition logic defined at table level.
```SQL
CREATE TABLE prod.catalog.events (
    user_id BIGINT,
    event_type STRING,
    event_time TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(event_time));
```
- User does NOT query partition column directly:
```SQL
SELECT *
FROM prod.catalog.events
WHERE event_time >= '2026-01-01';
```
- Partition pruning happens automatically.


---

## 3️⃣ Data Ingestion & File Management

* [Prefer append-only ingestion patterns (bronze, silver)](https://blog.dataexpert.io/p/the-data-warehouse-setup-no-one-taught)
* [Enable multi-threaded concurrent writes](#enable-multi-threaded-concurrent-writes)
* [Target optimal Parquet file size: **64–500 MB**](#target-optimal-parquet-file-size-64500-mb)
* [Run compaction jobs post-ingestion](#run-compaction-jobs-post-ingestion)
* [Enable write isolation](#enable-write-isolation)
* [Use optimistic concurrency](#use-optimistic-concurrency)
* [Use lock managers or branching for conflict resolution](#use-lock-managers-or-branching-for-conflict-resolution)

### Enable multi-threaded concurrent writes
- Iceberg supports concurrent writers automatically.
- Best practice: increase Spark parallelism.

$$
\text{Target Partition Size} \approx 64\text{MB to }512\text{MB}
$$

$$
\text{Shuffle Partitions} = \frac{\text{Input Data Size (Daily)}}{\text{Target Partition Size}}
$$
```python
spark.conf.set("spark.sql.shuffle.partitions", 200)
```

### Target optimal Parquet file size: **64–500 MB**
| Daily Data Size             | Suggested Partition Size | Why?                                                 |
|-----------------------|--------------------------|------------------------------------------------------|
| Small (< 10GB)        | 64MB - 128MB             | Keeps overhead low.                                  |
| Medium (10GB - 100GB) | 128MB - 200MB            | The industry standard for balance.                   |
| Large (> 100GB)       | 200MB - 512MB            | Prevents having millions of tiny, inefficient tasks. |

```SQL
ALTER TABLE prod.catalog.events
SET TBLPROPERTIES (
  'write.target-file-size-bytes' = '268435456'  -- 256MB
);
```
### Run compaction jobs post-ingestion
- run as a scheduled job 
```SQL
CALL prod.catalog.system.rewrite_data_files(
  table => 'events',
  options => map(
    'min-input-files', '5',
    'target-file-size-bytes', '268435456'
  )
);
```
### Enable write isolation
Iceberg uses snapshot isolation by default.
```SQL
ALTER TABLE prod.catalog.events
SET TBLPROPERTIES (
  'write.delete.mode'='merge-on-read',
  'write.update.mode'='merge-on-read'
);
```
| Layer  | Write Mode  | Isolation Level | Result                             |
|--------|-------------|-----------------|------------------------------------|
| Bronze | Append Only | Snapshot        | Fastest ingestion, zero conflicts. |
| Silver | MOR         | Snapshot        | Fast updates, very rare conflicts. |
| Gold   | COW         | Serializable    | Best query speed, strict accuracy. |

| Operation Type | Property Key                 | Valid Values           |
|----------------|------------------------------|------------------------|
| Deletes        | write.delete.isolation-level | serializable, snapshot |
| Updates        | write.update.isolation-level | serializable, snapshot |
| Merges         | write.merge.isolation-level  | serializable, snapshot |

### Use optimistic concurrency
- built in feature
- can configure retries
```python
spark.conf.set("spark.sql.catalog.prod.commit-retry-num-retries", 5)
```
### Use lock managers or branching for conflict resolution
Lock Manager
- depend on the catalog you choose
- REST catalogs (like Polaris) do not need lock (atomic)
```python
# Commit retry config
spark.conf.set("spark.sql.catalog.polaris.commit-retry-num-retries", 8)
spark.conf.set("spark.sql.catalog.polaris.commit-retry-min-wait-ms", 100)
spark.conf.set("spark.sql.catalog.polaris.commit-retry-max-wait-ms", 5000)
```
- Branching works if Polaris supports Iceberg branching (v2+).
  - Create branch:
  ```SQL
  ALTER TABLE polaris.db.events
  CREATE BRANCH dev_branch;
  ```
  - Write to branch:
  ```SQL
  INSERT INTO polaris.db.events VERSION AS OF 'dev_branch'
  SELECT * FROM staging.events;
  ```
  Query branch:
  ```SQL
  SELECT *
  FROM polaris.db.events VERSION AS OF 'dev_branch';
  ```
  Merge branch:
  ```SQL
  CALL polaris.system.merge_branch(
    table => 'db.events',
    branch => 'dev_branch'
  );
  ```
---

## 4️⃣ Query Optimization

* [Use Iceberg metadata tables](#use-iceberg-metadata-tables)
* [Ensure partition pruning and predicate pushdown supported](#ensure-partition-pruning-and-predicate-pushdown-supported)
* [Use latest engine versions](#use-latest-engine-versions)
* [Consider Z-order clustering](#consider-z-order-clustering)

### Use Iceberg metadata tables
| Metadata Table       | Purpose                                              | When to use it                                                    |
|----------------------|------------------------------------------------------|-------------------------------------------------------------------|
| files                | Lists all active data and delete files.              | To find ""Small File"" problems or check file formats.            |
| snapshots            | Shows every commit (snapshot) in history.            | To find a specific snapshot_id for Time Travel.                   |
| manifests            | Shows the index files for the current snapshot.      | To see how many files/rows are in each partition.                 |
| history              | A timeline of which snapshots became ""current.""    | To track the linear progression of the table.                     |
| partitions           | Summarizes data at the partition level.              | To see which partitions are the largest or have the most deletes. |
| refs                 | Lists all Branches and Tags.                         | To manage Write-Audit-Publish (WAP) workflows.                    |
| all_data_files       | Lists files across all snapshots (not just current). | Useful for deep debugging of orphaned files.                      |
| all_manifests        | Lists manifests across all snapshots.                | Auditing historical metadata usage.                               |
| metadata_log_entries | Shows the history of metadata.json files.            | To audit table configuration or schema changes over time.         |

### Ensure partition pruning and predicate pushdown supported
- Query:
  ```SQL
  EXPLAIN
  SELECT *
  FROM polaris.db.events
  WHERE event_time >= '2026-01-01';
  ```
- Look for:
  ```
  PartitionFilters: ...
  PushedFilters: ...
  ```
- spark config
```python
spark.conf.set("spark.sql.parquet.filterPushdown", "true")
spark.conf.set("spark.sql.optimizer.dynamicPartitionPruning.enabled", "true")
```

### Use latest engine versions
```python
spark.version
```
- make sure to find and use the correct jar
  ```xml
  <!-- https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-4.0_2.13/1.10.1/iceberg-spark-runtime-4.0_2.13-1.10.1.pom -->
  <dependency>
    <groupId>org.apache.iceberg</groupId>
    <artifactId>iceberg-spark-runtime-4.0_2.13</artifactId>
    <version>1.10.1</version>
  </dependency>
  ```

### Consider Z-order clustering
- Z-order helps **multi-column** filtering.
  ```SQL
  CALL polaris.system.rewrite_data_files(
    table => 'db.events',
    strategy => 'sort',
    sort_order => 'zorder(user_id, event_time)'
  );
  ```
---

## 5️⃣ Maintenance & Table Management
* [Schedule regular maintenance](#schedule-regular-maintenance)
* [Define snapshot retention policy](#define-snapshot-retention-policy)
* [Remove orphan files](#remove-orphan-files)
* [Prevent metadata bloat](#prevent-metadata-bloat)
* [Clean up failed-write leftovers](#clean-up-failed-write-leftovers)

### Schedule regular maintenance
Not strictly 100% follow this but should have some kind of planning based on your data to put into scheduled jobs.
| Task                | Frequency    | Purpose                                             |
|---------------------|--------------|-----------------------------------------------------|
| expire_snapshots    | Daily        | Deletes old versions of data to save storage costs. |
| rewrite_manifests   | Weekly       | Slims down the ""Index"" so queries start faster.   |
| rewrite_data_files  | Daily/Weekly | Merges tiny files into 100-500MB files.             |
| delete_orphan_files | Monthly      | Deletes files that aren't tracked by any metadata.  |


### Define snapshot retention policy
```SQL
CALL polaris.system.expire_snapshots(
  table => 'db.events',
  -- Dynamically calculates "7 days ago" every time it runs
  older_than => current_timestamp() - INTERVAL 7 DAYS,
  retain_last => 10
);
```
### Remove orphan files
```SQL
CALL polaris.system.remove_orphan_files(
  table => 'db.events',
  older_than => current_timestamp() - INTERVAL 2 DAYS
);
```
### Prevent metadata bloat
Check snapshot count:
```SQL
SELECT COUNT(*)
FROM polaris.db.events.snapshots;
```
### Clean up failed-write leftovers
- After failed jobs:
  ```SQL
  CALL polaris.system.remove_orphan_files(
    table => 'db.events'
  );
  ```
- Then rewrite manifests:
  ```SQL
  CALL polaris.system.rewrite_manifests(
    table => 'db.events'
  );
  ```
---

## 6️⃣ Time Travel and Auditing
 
* [Query historical versions](#query-historical-versions)
* [Rollback to previous stable snapshot](#rollback-to-previous-stable-snapshot)
* Define snapshot frequency and retention count
* Align retention policy with business needs

### Query historical versions
- Query by Snapshot ID
  ```SQL
  SELECT *
  FROM polaris.db.events
  VERSION AS OF 382947239847293;
  ```
- Query by Timestamp
  ```SQL
  SELECT *
  FROM polaris.db.events
  TIMESTAMP AS OF TIMESTAMP '2026-03-01 00:00:00';
  ```

### Rollback to previous stable snapshot
```SQL
CALL polaris.system.rollback_to_snapshot(
  table => 'db.events',
  snapshot_id => 382947239847293
);
```
---

## 7️⃣ Monitoring, Observability and Lineage

* Monitor:

  * Snapshot count
  * File count
  * File size
  * Query latency
  * Metadata growth
* Integrate with monitoring systems:

  * Prometheus
  * Grafana
  * Amazon CloudWatch
* Integrate data lineage (if multi tools):
  * OpenLineage
* Track column-level lineage
---
