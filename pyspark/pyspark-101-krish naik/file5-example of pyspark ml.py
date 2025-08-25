import findspark

findspark.init()

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Practice").getOrCreate()

training = spark.read.csv("test1.csv", header=True, inferSchema=True)
training.show()

training.printSchema()

training.columns

from pyspark.ml.feature import VectorAssembler

featureasembler = VectorAssembler(
    inputCols=["age", "Experience"], outputCol="Independent Features"
)
output = featureasembler.transform(training)
output.show()

output.columns

finalized_data = output.select("Independent Features", "Salary")
finalized_data.show()

from pyspark.ml.regression import LinearRegression

# train test split
train_data, test_data = finalized_data.randomSplit([0.75, 0.25])
regressor = LinearRegression(featuresCol="Independent Features", labelCol="Salary")
regressor = regressor.fit(train_data)

regressor.coefficients
regressor.intercept

pred_results = regressor.evaluate(test_data)

pred_results.predictions.show()

pred_results.meanAbsoluteError, pred_results.meanSquaredError
