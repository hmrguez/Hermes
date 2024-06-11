package org.example;

import com.google.gson.Gson;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

public class Main {

    public static void main(String[] args) {
        // Define Kafka producer properties
        Properties props = new Properties();
        props.put("bootstrap.servers", "localhost:9092"); // Replace with your Kafka server address
        props.put("key.serializer", StringSerializer.class.getName());
        props.put("value.serializer", StringSerializer.class.getName());

        // Create a Kafka producer
        try (KafkaProducer<String, String> producer = new KafkaProducer<>(props)) {
            // Generate sample data
            String gameId = UUID.randomUUID().toString(); // Unique game ID
            long timestamp = Instant.now().toEpochMilli(); // Current timestamp
            List<String> teamIds = Arrays.asList("teamA", "teamB");
            int duration = 60; // Match duration in minutes
            boolean isOfficial = true;

            // Create and serialize the event and payload
            GameStartedEvent gameStartedEvent = new GameStartedEvent(gameId, timestamp);
            GameStartPayload gameStartPayload = new GameStartPayload(gameId, teamIds, duration, isOfficial);
            String eventJson = new Gson().toJson(gameStartedEvent); // Using Gson for serialization
            String payloadJson = new Gson().toJson(gameStartPayload);

            // Send the event and payload to the Kafka topic
            producer.send(new ProducerRecord<>("game-start-events", eventJson));
            producer.send(new ProducerRecord<>("game-start-events", payloadJson));

            System.out.println("Sent game start event and payload successfully.");
        } catch (Exception e) {
            System.err.println("Error sending message: " + e.getMessage());
        }
    }
}
