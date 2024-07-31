package Dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class RideRequest {
    private String pickupLocation;
    private String requestId;

    public RideRequest() {
    }

    public RideRequest(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

}