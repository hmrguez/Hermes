package FlinkCommerce;

import Dto.DriverLocation;
import Dto.EnrichedRideRequest;
import Dto.RideRequest;
import Dto.TrafficData;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.flink.api.common.functions.JoinFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.sink.SinkFunction;
import org.apache.flink.streaming.api.windowing.assigners.TumblingProcessingTimeWindows;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaProducer;

import java.util.Properties;

public class DataStreamJob {

    public static void main(String[] args) throws Exception {
        // Set up the streaming execution environment
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // Configure Kafka consumer properties
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        properties.setProperty("group.id", "flink-consumer-group");

        // Create Kafka consumers
        FlinkKafkaConsumer<String> rideRequestConsumer = new FlinkKafkaConsumer<>("ride_requests", new SimpleStringSchema(), properties);
        FlinkKafkaConsumer<String> driverLocationConsumer = new FlinkKafkaConsumer<>("driver_locations", new SimpleStringSchema(), properties);

        // Read streams from Kafka
        DataStream<String> rideRequestStream = env.addSource(rideRequestConsumer);
        DataStream<String> driverLocationStream = env.addSource(driverLocationConsumer);

        // Parse ride requests
        DataStream<RideRequest> parsedRideRequests = rideRequestStream.map(new MapFunction<String, RideRequest>() {
            @Override
            public RideRequest map(String value) {
                // Parse the JSON string into a RideRequest object
                return parseRideRequest(value);
            }
        });

        // Parse driver locations
        DataStream<DriverLocation> parsedDriverLocations = driverLocationStream.map(new MapFunction<String, DriverLocation>() {
            @Override
            public DriverLocation map(String value) {
                // Parse the JSON string into a DriverLocation object
                return parseDriverLocation(value);
            }
        });

        // Add sink to print pickupLocation from parsedRideRequests
        parsedRideRequests.addSink(new SinkFunction<RideRequest>() {
            @Override
            public void invoke(RideRequest value, Context context) {
                System.out.println("RideRequest pickupLocation: " + value.getPickupLocation());
            }
        });

        // Add sink to print currentLocation from parsedDriverLocations
        parsedDriverLocations.addSink(new SinkFunction<DriverLocation>() {
            @Override
            public void invoke(DriverLocation value, Context context) {
                System.out.println("DriverLocation currentLocation: " + value.getCurrentLocation());
            }
        });

        DataStream<EnrichedRideRequest> enrichedRideRequests = parsedRideRequests
                .join(parsedDriverLocations)
                .where(RideRequest::getPickupLocation)
                .equalTo(DriverLocation::getCurrentLocation)
                .window(TumblingProcessingTimeWindows.of(Time.seconds(30)))
                .apply(new JoinFunction<RideRequest, DriverLocation, EnrichedRideRequest>() {
                    @Override
                    public EnrichedRideRequest join(RideRequest rideRequest, DriverLocation driverLocation) {
                        return new EnrichedRideRequest(rideRequest, driverLocation);
                    }
                });

//        // Add intermediate print after first join
//        enrichedRideRequests.addSink(new SinkFunction<EnrichedRideRequest>() {
//            @Override
//            public void invoke(EnrichedRideRequest value, Context context) {
//                System.out.println("After first join - RideRequest ID: " + value.getRideRequest().getRequestId()
//                        + ", Driver Location: " + value.getDriverLocation().getCurrentLocation() +
//                        "Pickup Location: " + value.getRideRequest().getPickupLocation());
//            }
//        });


        // Calculate dynamic pricing
        DataStream<DynamicPricingResult> dynamicPricingStream = enrichedRideRequests.map(new RichMapFunction<EnrichedRideRequest, DynamicPricingResult>() {
            private transient int currentDemand;
            private transient int maxCapacity;

            @Override
            public void open(Configuration parameters) {
                // Initialize state
                currentDemand = 0;
                maxCapacity = 100;  // Example value, this can be dynamic
            }

            @Override
            public DynamicPricingResult map(EnrichedRideRequest value) {
                currentDemand++;  // Example logic, this should be dynamic based on actual demand

                double baseFare = 5.0;
                double demandFactor = 1 + ((double) currentDemand / maxCapacity);
                double dynamicFare = baseFare * demandFactor;

                return new DynamicPricingResult(value.getRideRequest().getRequestId(), dynamicFare);
            }
        });

//        // Add sink to print dynamic pricing results
//        dynamicPricingStream.addSink(new SinkFunction<DynamicPricingResult>() {
//            @Override
//            public void invoke(DynamicPricingResult value, Context context) {
//                System.out.println("Dynamic Pricing - Request ID: " + value.getRequestId() + ", Dynamic Fare: " + value.getDynamicFare());
//            }
//        });

        // Write dynamic pricing results back to Kafka
        dynamicPricingStream.addSink(new FlinkKafkaProducer<>(
                "dynamic_pricing",
                new DynamicPricingResultSchema(),
                properties
        ));


        // Execute the Flink job
        env.execute("Flink CEP Job");
    }


    private static RideRequest parseRideRequest(String json) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.readValue(json, RideRequest.class);
        } catch (Exception e) {
            e.printStackTrace();
            return new RideRequest();
        }
    }

    private static DriverLocation parseDriverLocation(String json) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.readValue(json, DriverLocation.class);
        } catch (Exception e) {
            e.printStackTrace();
            return new DriverLocation();
        }
    }

    private static TrafficData parseTrafficData(String json) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.readValue(json, TrafficData.class);
        } catch (Exception e) {
            e.printStackTrace();
            return new TrafficData();
        }
    }
}

