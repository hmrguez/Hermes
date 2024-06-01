package org.example;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

public class Main {
    public static void main(String[] args) {




//        System.out.print("Hello and welcome!\n");
//
//        // Define properties for the Kafka producer
//        Properties props = new Properties();
//        props.put("bootstrap.servers", "localhost:9092");
//        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
//        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
//
//        // Create a Kafka producer
//        Producer<String, String> producer = new KafkaProducer<>(props);
//
//        for (int i = 1; i <= 5; i++) {
//            System.out.println("i = " + i);
//
//            // Create a ProducerRecord with the message
//            ProducerRecord<String, String> record = new ProducerRecord<>("my-topic", "message " + i);
//
//            // Send the message
//            producer.send(record);
//        }
//
//        // Close the producer
//        producer.close();
    }
}