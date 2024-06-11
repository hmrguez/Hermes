package org.example;

public class GameStartedEvent {
    private final String gameId;
    private final long timestamp;

    public GameStartedEvent(String gameId, long timestamp) {
        this.gameId = gameId;
        this.timestamp = timestamp;
    }

    // Getter methods
    public String getGameId() {
        return gameId;
    }

    public long getTimestamp() {
        return timestamp;
    }
}
