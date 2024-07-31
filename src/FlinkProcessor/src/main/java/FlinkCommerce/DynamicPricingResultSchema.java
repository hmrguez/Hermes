package FlinkCommerce;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.flink.api.common.serialization.DeserializationSchema;
import org.apache.flink.api.common.serialization.SerializationSchema;
import org.apache.flink.api.common.typeinfo.TypeInformation;

public class DynamicPricingResultSchema implements SerializationSchema<DynamicPricingResult>, DeserializationSchema<DynamicPricingResult> {
    @Override
    public byte[] serialize(DynamicPricingResult element) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.writeValueAsBytes(element);
        } catch (Exception e) {
            e.printStackTrace();
            return new byte[0];
        }
    }

    @Override
    public DynamicPricingResult deserialize(byte[] message) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.readValue(message, DynamicPricingResult.class);
        } catch (Exception e) {
            e.printStackTrace();
            return new DynamicPricingResult();
        }
    }

    @Override
    public boolean isEndOfStream(DynamicPricingResult nextElement) {
        return false;
    }

    @Override
    public TypeInformation<DynamicPricingResult> getProducedType() {
        return TypeInformation.of(DynamicPricingResult.class);
    }
}
