package Dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class Transaction {
    private String transaction_id;
    private String product_id;
    private String product_name;
    private String product_category;
    private double product_price;
    private int quantity;
    private String brand;
    private String currency;
    private String customer_id;
    private String payment_method;
}