# Iceberg 101

## What it is and why it matters
[Video Link](https://youtu.be/p24GiqQaA1U?si=z3uHlgD9M8jV8s-U)
- what is data lake
- what is a table format? how does it work
- benefits of this approach
  - Time travel
  - Schema Evolution
  - ACID
- What is Apache Iceberg?
- improved performance
- partition evolution
- hidden partitioning

## The Problem and the solution to the story
[Video Link](https://youtu.be/cI9zu5Rk_bQ?si=cWT9UJJV-pytpZ-A)
- What is a table format
- Hive table format, Pros and Cons
- We need a new table format
- what iceberg is and isn't
- Design benefits
- Key to unlock data lake

## Iceberg and the data lakehouse
[Video Link](https://youtu.be/Sguvhvwn8m4?si=CqISDlQojlYdLRRI)
- Status quo
- lakehouse architecture
- components of data lakehouse
- Open data lakehouse architecture
  
## Overview of Architecture
[Video Link](https://youtu.be/tZ3C_CAALfE?si=S0--dgHIm1LqxQr9)
- catalog
- metadata
- Manifest List
- Manifest file

## Iceberg Transactions Step by Step
[Video Link](https://youtu.be/IU6D4gXa7oA?si=Bv5yWra3Z3OXXSbM)

## Copy-on-Write and Merge-on-Read
[Video Link](https://youtu.be/Vlw1R0HSHr0?si=-X071wHiZavT4Ng3)
- definition
- types of delete files
- TBLPROPERTIES
  - write.delete.mode
  - write.update.mode
  - write.merge.mode
- when to use COW or MOR

## Iceberg Catalogs
[Video Link](https://youtu.be/YeVnasnJ2Ts?si=bhbWIMY6vbzieDeC)
- What can be used as Iceberg Catalog
  - Nessie, Hive, Glue, HDFS, JDBC, REST
  - registerTable method

## Table Tuning with TBLPROPERTIES
[Video Link](https://youtu.be/MoNGRaeJj_s?si=Imgvn0VEH8AG7hKc)
- syntax
- parquet vectorization
- write format and write delete format
- compression format
- clean up metadata files
- column metrics tracking
- object storage compatibility

## Migrating to Iceberg
[Video Link](https://youtu.be/pvAl8cOh4j4?si=ZD96ncd8PLNsMAbS)
- existing parquet files that are part of a Hive table
- parquet files not part of a Hive table
- Migrating by restating the data (CTAS)
- when to use each approach

## Time Travel
[Video Link](https://youtu.be/pktDzTPbimo?si=mjeSO6v6OPe0SlIr)
- what is it? why use it? limitations?
- syntax

## Maintaining Iceberg Tables
- Expiring snapshots
- Rewriting data files and manifests (compaction)
- Deleting orphan files

## Hard Deletion for GDPR
- hard delete for a table using copy-on-write
- hard delete for a table using merge-on-read
- encrytion based deletion

