package Dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class EnrichedRideRequest {
    private RideRequest rideRequest;
    private DriverLocation driverLocation;

    public EnrichedRideRequest() {
    }

    public EnrichedRideRequest(RideRequest rideRequest, DriverLocation driverLocation) {
        this.rideRequest = rideRequest;
        this.driverLocation = driverLocation;
    }

    public String getPickupLocation() {
        return rideRequest.getPickupLocation();
    }
}