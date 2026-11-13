package com.carsystem.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Database URL: car_system_db
    private static final String URL = "jdbc:mysql://localhost:3306/car_system_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "120704"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.out.println("Database Connection Failed: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}