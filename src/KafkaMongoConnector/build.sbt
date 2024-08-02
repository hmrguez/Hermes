// build.sbt
name := "KafkaMongoConnector"

version := "0.1"

scalaVersion := "2.13.14"

libraryDependencies ++= Seq(
  "org.apache.kafka" %% "kafka" % "3.8.0",
  "org.mongodb.scala" %% "mongo-scala-driver" % "5.1.1"
)

resolvers ++= Seq(
  "Confluent" at "https://packages.confluent.io/maven/",
  "Maven Central" at "https://repo1.maven.org/maven2/"
)