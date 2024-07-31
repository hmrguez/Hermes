package Dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DriverLocation {
    private String currentLocation;

    public DriverLocation() {
    }

    public DriverLocation(String currentLocation) {
        this.currentLocation = currentLocation;
    }

}