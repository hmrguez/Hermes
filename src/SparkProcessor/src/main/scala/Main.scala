import org.apache.spark.sql.functions.{coalesce, col, count, lit, when}

object Main {

  def main(args: Array[String]): Unit = {

    /* Create the SparkSession.
     * If config arguments are passed from the command line using --conf,
     * parse args for the values to set.
     */
    import org.apache.spark.sql.SparkSession

    val spark = SparkSession.builder()
      .master("local")
      .appName("MongoSparkConnectorIntro")
      .config("spark.mongodb.read.connection.uri", "mongodb://127.0.0.1/hermes.ride_requests")
      .config("spark.mongodb.write.connection.uri", "mongodb://127.0.0.1/hermes.cleaned_users")
      .getOrCreate()

    // Read ride_requests collection
    val rideRequestsDF = spark.read
      .format("mongo")
      .option("uri", "mongodb://127.0.0.1/hermes.ride_requests")
      .load()

    // Read users collection
    val usersDF = spark.read
      .format("mongo")
      .option("uri", "mongodb://127.0.0.1/hermes.users")
      .load()

    // Count the number of ride requests per user
    val rideCountsDF = rideRequestsDF.groupBy("riderId")
      .agg(count("*").alias("ride_count"))

    // Join users with ride counts
    val usersWithRideCountsDF = usersDF.join(rideCountsDF, usersDF("user_id") === rideCountsDF("riderId"), "left_outer")
      .withColumn("ride_count", coalesce(col("ride_count"), lit(0)))


    // Classify users based on the number of ride requests
    val classifiedUsersDF = usersWithRideCountsDF.withColumn("user_status", when(col("ride_count") >= 3, "frequent")
      .when(col("ride_count") >= 1, "infrequent")
      .otherwise("inactive"))

    // Write the transformed user data to the cleaned_users collection
    classifiedUsersDF.write
      .format("mongo")
      .option("uri", "mongodb://127.0.0.1/hermes.cleaned_users")
      .mode("overwrite")
      .save()

    spark.stop()
  }
}