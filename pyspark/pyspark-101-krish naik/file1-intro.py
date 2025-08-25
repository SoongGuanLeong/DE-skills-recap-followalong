"""
topics covered:
    - pyspark dataframe
    - reading the dataset
    - checking datatypes of the columns(schema)
    - selecting columns and indexing
    - check describe option similar to pandas
    - adding columns
    - dropping columns
    - renaming columns
"""

import findspark

findspark.init()

import pyspark
import pandas as pd
from pyspark.sql import SparkSession

pd.read_csv("test1.csv")

spark = SparkSession.builder.appName("Practice").getOrCreate()

df_pyspark = spark.read.csv("test1.csv")
df_pyspark.show()

df_pyspark = spark.read.csv("test1.csv", header=True)
df_pyspark.show()

type(df_pyspark)

df_pyspark.head()

df_pyspark.printSchema()

df_pyspark = spark.read.csv("test1.csv", header=True, inferSchema=True)
df_pyspark.printSchema()

df_pyspark.columns

df_pyspark.select("Name")

df_pyspark.select(["Name", "Experience"]).show()

df_pyspark.dtypes

df_pyspark.describe().show()

df_pyspark = df_pyspark.withColumn(
    "Experience after 2 years", df_pyspark["Experience"] + 2
)
df_pyspark.show()

df_pyspark = df_pyspark.drop("Experience after 2 years")

df_pyspark.withColumnRenamed("Name", "New Name").show()
