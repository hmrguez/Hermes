package FlinkCommerce;

import Dto.Transaction;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.cep.CEP;
import org.apache.flink.cep.PatternSelectFunction;
import org.apache.flink.cep.PatternStream;
import org.apache.flink.cep.pattern.Pattern;
import org.apache.flink.cep.pattern.conditions.IterativeCondition;
import org.apache.flink.cep.pattern.conditions.SimpleCondition;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;

import java.util.List;
import java.util.Map;
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

        // Define the pattern
        Pattern<Transaction, ?> pattern = Pattern.<Transaction>begin("start")
                .where(new SimpleCondition<Transaction>() {
                    @Override
                    public boolean filter(Transaction start) {
                        return true; // Placeholder, always true as we just need a starting point
                    }
                })
                .next("middle").where(new IterativeCondition<Transaction>() {
                    @Override
                    public boolean filter(Transaction middle, Context<Transaction> ctx) throws Exception {
                        Transaction start = ctx.getEventsForPattern("start").iterator().next();
                        // Log
                        System.out.println("Start: " + start.getAmount() + ", Middle: " + middle.getAmount());
                        return middle.getAmount() > start.getAmount();
                    }
                })
                .next("end").where(new IterativeCondition<Transaction>() {
                    @Override
                    public boolean filter(Transaction end, Context<Transaction> ctx) throws Exception {
                        Transaction middle = ctx.getEventsForPattern("middle").iterator().next();
                        System.out.println("Start: " + middle.getAmount() + ", Middle: " + middle.getAmount());
                        return end.getAmount() > middle.getAmount();
                    }
                });

        // Apply the pattern to a stream of transactions
        PatternStream<Transaction> patternStream = CEP.pattern(
                transactions.keyBy(transaction -> transaction.getSender()),
                pattern);

        // Define a select function to process the matched patterns
        DataStream<String> alerts = patternStream.select(new PatternSelectFunction<Transaction, String>() {
            @Override
            public String select(Map<String, List<Transaction>> pattern) throws Exception {
                Transaction start = pattern.get("start").get(0);
                Transaction middle = pattern.get("middle").get(0);
                Transaction end = pattern.get("end").get(0);
                return "Detected pattern: Start(" + start.getAmount() + "), Middle(" + middle.getAmount() + "), End(" + end.getAmount() + ")";
            }
        });

        // Print the detected patterns
        alerts.print();

        // Execute the Flink job
        env.execute("Flink CEP Job");
    }
}