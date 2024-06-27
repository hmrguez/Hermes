package Dto;

import java.sql.Timestamp;

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
    private Timestamp transaction_date;
    private String payment_method;
}