package org.example;

import java.util.List;

public class GameStartPayload {
    private final String matchId;
    private final List<String> teamIds; // Assuming each team has a unique ID
    private final int duration; // Duration of the match in minutes
    private final boolean isOfficial; // Indicates whether the match is official or not

    public GameStartPayload(String matchId, List<String> teamIds, int duration, boolean isOfficial) {
        this.matchId = matchId;
        this.teamIds = teamIds;
        this.duration = duration;
        this.isOfficial = isOfficial;
    }

    // Getter methods
    public String getMatchId() {
        return matchId;
    }

    public List<String> getTeamIds() {
        return teamIds;
    }

    public int getDuration() {
        return duration;
    }

    public boolean isOfficial() {
        return isOfficial;
    }
}
