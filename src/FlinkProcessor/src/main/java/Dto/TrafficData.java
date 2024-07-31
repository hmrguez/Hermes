package Dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class TrafficData {
    private String location;
    private Double trafficLevel;

    public TrafficData() {
    }

    public TrafficData(String location) {
        this.location = location;
    }

}