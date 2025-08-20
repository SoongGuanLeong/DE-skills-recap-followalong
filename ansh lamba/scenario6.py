"""
A retail company processes daily sales transactions from multiple store locations. The data arrives in different formats and needs to be cleaned, validated and aggregated for business reporting. Using a Delta Live Tables (DLT) pipeline, the raw data is ingested from cloud storage, transformed with quality checks and stored in Delta tables for analytics dashboards, ensuring accuracy and reliability near real-time.
"""
import dlt
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.window import Window

@dlt.table(
    name = 'customers_raw'
)
def customers_raw():
  return spark.readStream.table("pyspark_cata.source.customers")

@dlt.table(
    name = 'customers_enr'
)
def customers_enr():
    df = spark.readStream.table("customers_raw")
    df = df.withColumn("dedup", row_number().over(Window.partitionBy('id').orderBy(desc('modifiedDate'))))
    return df.where(col('dedup')==1).drop('dedup')

dlt.create_streaming_table(
    name = 'customers_dim'
)

dlt.create_auto_cdc_flow(
  target = "customers_dim",
  source = "customers_enr",
  keys = ["id"],
  sequence_by = "modifiedDate",
  stored_as_scd_type = 2
)
