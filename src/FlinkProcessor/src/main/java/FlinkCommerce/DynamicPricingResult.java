package FlinkCommerce;

@lombok.Getter
@lombok.Setter
public class DynamicPricingResult {
    private String requestId;
    private double dynamicFare;

    public DynamicPricingResult(String requestId, double dynamicFare) {
        this.requestId = requestId;
        this.dynamicFare = dynamicFare;
    }

    public DynamicPricingResult() {}
}
