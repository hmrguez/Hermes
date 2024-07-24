package FlinkCommerce;

import Dto.Transaction;
import io.github.cdimascio.dotenv.Dotenv;
import org.apache.flink.streaming.api.functions.sink.SinkFunction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class PostgreSQLSink implements SinkFunction<Transaction> {
    private static final String JDBC_URL = "jdbc:postgresql://localhost:5432/hermes";
    private static final Dotenv dotenv = Dotenv.load();
    private static final String USER = dotenv.get("DB_USER");
    private static final String PASSWORD = dotenv.get("DB_PASSWORD");

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load PostgreSQL JDBC driver", e);
        }
    }

    @Override
    public void invoke(Transaction transaction, Context context) throws Exception {
        Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
        String sql = "INSERT INTO transactions (transaction_id, timestamp, amount, currency, sender, receiver, location) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, transaction.getTransactionId());
        statement.setLong(2, transaction.getTimestamp());
        statement.setDouble(3, transaction.getAmount());
        statement.setString(4, transaction.getCurrency());
        statement.setString(5, transaction.getSender());
        statement.setString(6, transaction.getReceiver());
        statement.setString(7, transaction.getLocation());
        statement.executeUpdate();
        statement.close();
        connection.close();
    }
}