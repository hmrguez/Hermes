import org.apache.kafka.clients.consumer.{ConsumerConfig, KafkaConsumer}
import org.apache.kafka.common.serialization.StringDeserializer
import org.mongodb.scala._

import java.util.Properties
import scala.collection.JavaConverters._

object main {
  def main(args: Array[String]): Unit = {

    // Kafka consumer configuration
    val kafkaProps = new Properties()
    kafkaProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092")
    kafkaProps.put(ConsumerConfig.GROUP_ID_CONFIG, "ride_requests_group")
    kafkaProps.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, classOf[StringDeserializer].getName)
    kafkaProps.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, classOf[StringDeserializer].getName)
    kafkaProps.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest")

    // Create Kafka consumer
    val consumer = new KafkaConsumer[String, String](kafkaProps)
    consumer.subscribe(java.util.Collections.singletonList("ride_requests"))

    // MongoDB client and collection setup
    val mongoClient: MongoClient = MongoClient("mongodb://localhost:27017")
    val database: MongoDatabase = mongoClient.getDatabase("hermes")
    val collection: MongoCollection[Document] = database.getCollection("ride_requests")

    // Poll Kafka topic and insert messages into MongoDB
    while (true) {
      val records = consumer.poll(java.time.Duration.ofMillis(100))
      for (record <- records.asScala) {
        val doc: Document = Document(record.value())
        collection.insertOne(doc).subscribe(next => println(s"Inserted: $next"))
      }
    }
  }
}