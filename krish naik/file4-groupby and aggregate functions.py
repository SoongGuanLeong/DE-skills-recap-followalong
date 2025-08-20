import findspark

findspark.init()

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Practice").getOrCreate()

df_pyspark = spark.read.csv("test3.csv", header=True, inferSchema=True)
df_pyspark.show()

df_pyspark.printSchema()

## groupby
df_pyspark.groupBy("Name").sum("salary").show()

df_pyspark.groupBy("Name").max("salary").show()

df_pyspark.groupBy("Name").min("salary").show()

df_pyspark.groupBy("Departments").sum("salary").show()

df_pyspark.groupBy("Departments").mean("salary").show()

df_pyspark.groupBy("Departments").count().show()

df_pyspark.agg({"salary": "sum"}).show()
