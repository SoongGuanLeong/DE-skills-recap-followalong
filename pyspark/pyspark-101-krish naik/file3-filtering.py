"""
pyspark dataframe
&, |, ==
~
"""

import findspark

findspark.init()

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Practice").getOrCreate()

df_pyspark = spark.read.csv("test1.csv", header=True, inferSchema=True)
df_pyspark.show()

# salary of people less than or equal to 20000
df_pyspark.filter("salary <= 20000").show()

df_pyspark.filter("salary <= 20000").select(["Name", "age"]).show()

df_pyspark.filter(
    (df_pyspark["salary"] <= 20000) | (df_pyspark["salary"] >= 15000)
).show()

df_pyspark.filter(~(df_pyspark["salary"] <= 20000)).show()
