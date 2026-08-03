package com.foodiehub.util;

import java.sql.Connection;
import java.sql.SQLException;

public class test {
	// Temporary main method to test the database connection
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("=========================================");
                System.out.println(" SUCCESS: Connected to foodiehub_db!");
                System.out.println("=========================================");
            }
        } catch (SQLException e) {
            System.err.println("=========================================");
            System.err.println(" FAILURE: Connection failed!");
            System.err.println("=========================================");
            e.printStackTrace();
        }
    }

}
