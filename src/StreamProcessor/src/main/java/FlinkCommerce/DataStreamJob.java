/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package FlinkCommerce;

import Dto.Transaction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.api.common.state.ListState;
import org.apache.flink.api.common.state.ListStateDescriptor;
import org.apache.flink.api.common.state.ValueState;
import org.apache.flink.api.common.state.ValueStateDescriptor;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.shaded.jackson2.com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.KeyedProcessFunction;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.flink.util.Collector;

import java.util.Properties;

/**
 * Skeleton for a Flink DataStream Job.
 *
 * <p>For a tutorial how to write a Flink application, check the
 * tutorials and examples on the <a href="https://flink.apache.org">Flink Website</a>.
 *
 * <p>To package your application into a JAR file for execution, run
 * 'mvn clean package' on the command line.
 *
 * <p>If you change the name of the main class (with the public static void main(String[] args))
 * method, change the respective entry in the POM.xml file (simply search for 'mainClass').
 */
public class DataStreamJob {

    public static void main(String[] args) throws Exception {
        // Sets up the execution environment, which is the main entry point
        // to building Flink applications.
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // Configure Kafka consumer properties
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        properties.setProperty("group.id", "flink-consumer-group");

        String topic = "financial_transactions";

        // Create a Kafka consumer
        FlinkKafkaConsumer<String> kafkaConsumer = new FlinkKafkaConsumer<>(
                "financial_transactions", // topic
                new SimpleStringSchema(),
                properties);

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

        // Key the stream by a dummy key (we use a constant value "key" for all elements)
        transactions.keyBy(transaction -> "key")
                .process(new KeyedProcessFunction<String, Transaction, String>() {
                    private transient ListState<Transaction> transactionState;
                    private transient ValueState<Integer> countState;

                    @Override
                    public void open(Configuration parameters) throws Exception {
                        ListStateDescriptor<Transaction> transactionDescriptor = new ListStateDescriptor<>("transactions", Transaction.class);
                        transactionState = getRuntimeContext().getListState(transactionDescriptor);

                        ValueStateDescriptor<Integer> countDescriptor = new ValueStateDescriptor<>("count", Integer.class, 0);
                        countState = getRuntimeContext().getState(countDescriptor);
                    }

                    @Override
                    public void processElement(Transaction transaction, Context context, Collector<String> out) throws Exception {
                        transactionState.add(transaction);
                        int count = countState.value();
                        count++;
                        countState.update(count);

                        if (count >= 3) {
                            double sum = 0.0;
                            int totalCount = 0;
                            for (Transaction t : transactionState.get()) {
                                sum += t.getAmount();
                                totalCount++;
                            }
                            double average = sum / totalCount;
                            out.collect("Average amount for last 3 transactions: " + average);
                            transactionState.clear();
                            countState.clear();
                        }
                    }
                }).print();

        // Execute program, beginning computation.
        env.execute("Flink Stream Processor");
    }
}
