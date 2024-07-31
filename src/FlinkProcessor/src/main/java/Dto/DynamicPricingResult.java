package Dto;

public class DynamicPricingResult {
    private String requestId;
    private double dynamicFare;

    public DynamicPricingResult() {
    }

    public DynamicPricingResult(String requestId, double dynamicFare) {
        this.requestId = requestId;
        this.dynamicFare = dynamicFare;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public double getDynamicFare() {
        return dynamicFare;
    }

    public void setDynamicFare(double dynamicFare) {
        this.dynamicFare = dynamicFare;
    }
}