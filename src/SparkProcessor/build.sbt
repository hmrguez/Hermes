ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "2.13.14"

lazy val root = (project in file("."))
  .settings(
    name := "SparkProcessor"
  )

fork in run := true
javaOptions ++= Seq(
  "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED"
)

libraryDependencies ++= Seq(
  "org.mongodb.spark" %% "mongo-spark-connector" % "10.3.0",
  "org.apache.spark" %% "spark-core" % "3.5.1",
  "org.apache.spark" %% "spark-sql" % "3.5.1"
)


