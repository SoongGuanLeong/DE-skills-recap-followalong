"""
Pyspark Handling Missing Values
    - Dropping columns
    - Dropping rows
    - Various Parameters in dropping functionalities
    - Hanlding missing values by Mean, Median, Mode
"""

import findspark

findspark.init()

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Practice").getOrCreate()

df_pyspark = spark.read.csv("test2.csv", header=True, inferSchema=True)
df_pyspark.show()

# Dropping columns
df_pyspark.drop("Name").show()

df_pyspark.na.drop(how="all").show()
df_pyspark.na.drop(thresh=2).show()
df_pyspark.na.drop(subset=["Age"]).show()

# Filling missing values, now need to be same data type
df_pyspark.na.fill("missing values").show()
df_pyspark.na.fill(0).show()
df_pyspark.na.fill("missing values", ["Experience", "age"]).show()
df_pyspark.na.fill(0, ["Experience", "age"]).show()

df_pyspark.show()

from pyspark.ml.feature import Imputer

imputer = Imputer(
    inputCols=["age", "Experience", "Salary"],
    outputCols=["{}_imputed".format(c) for c in ["age", "Experience", "Salary"]],
).setStrategy("mean")

imputer.fit(df_pyspark).transform(df_pyspark).show()
