package FlinkCommerce;

import Dto.Transaction;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;

import java.util.Properties;

public class DataStreamJob {

    public static void main(String[] args) throws Exception {
        // Set up the streaming execution environment
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // Configure Kafka consumer properties
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        properties.setProperty("group.id", "flink-consumer-group");

        // Create a Kafka consumer
        FlinkKafkaConsumer<String> kafkaConsumer = new FlinkKafkaConsumer<>(
                "financial_transactions", // topic
                new SimpleStringSchema(),
                properties);

        // Add the consumer to the data stream
        DataStream<String> stream = env.addSource(kafkaConsumer);

        // Deserialize JSON to Transaction objects
        DataStream<Transaction> transactions = stream.map(new MapFunction<String, Transaction>() {
            private static final long serialVersionUID = 1L;
            private ObjectMapper mapper = new ObjectMapper();

            @Override
            public Transaction map(String value) throws Exception {
                return mapper.readValue(value, Transaction.class);
            }
        });

        transactions.addSink(new PostgreSQLSink());

        // Execute the Flink job
        env.execute("Flink CEP Job");
    }
}