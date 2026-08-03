package com.foodiehub.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBTestRunner {

    public static void main(String[] args) {
        System.out.println("=== STARTING FOODIEHUB DATABASE SELECTION TEST ===");
        
        // 1. Verify basic connection establishment
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database Connection Successful!");
                
                // 2. Test Reading from 'user' Table
                testUserSelection(conn);
                
                // 3. Test Reading from 'restaurant' Table
                testRestaurantSelection(conn);
                
                // 4. Test Joined Query (Simulating a real checkout fetch)
                testOrderSummarySelection(conn);
                
            } else {
                System.out.println("❌ Connection was null or closed.");
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection or execution failed!");
            e.printStackTrace();
        }
        
        System.out.println("=== TEST RUN COMPLETE ===");
    }

    private static void testUserSelection(Connection conn) throws SQLException {
        System.out.println("\n--- Testing User Selection ---");
        String sql = "SELECT UserID, Username, Email, Role FROM user;";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                System.out.printf("User ID: %d | Name: %s | Email: %s | Role: %s%n",
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        rs.getString("Email"),
                        rs.getString("Role"));
            }
        }
    }

    private static void testRestaurantSelection(Connection conn) throws SQLException {
        System.out.println("\n--- Testing Restaurant Selection ---");
        String sql = "SELECT RestaurantID, Name, CuisineType, Rating FROM restaurant;";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                System.out.printf("Rest ID: %d | Name: %s | Cuisine: %s | Rating: %.2f%n",
                        rs.getInt("RestaurantID"),
                        rs.getString("Name"),
                        rs.getString("CuisineType"),
                        rs.getDouble("Rating"));
            }
        }
    }

    private static void testOrderSummarySelection(Connection conn) throws SQLException {
        System.out.println("\n--- Testing Historical Order Join Query ---");
        String sql = "SELECT o.OrderID, u.Username, r.Name AS RestaurantName, o.TotalAmount, o.Status " +
                     "FROM ordertable o " +
                     "JOIN user u ON o.UserID = u.UserID " +
                     "JOIN restaurant r ON o.RestaurantID = r.RestaurantID;";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                System.out.printf("Order ID: %d | Customer: %s | From: %s | Total: %.2f | Status: %s%n",
                        rs.getInt("OrderID"),
                        rs.getString("Username"),
                        rs.getString("RestaurantName"),
                        rs.getDouble("TotalAmount"),
                        rs.getString("Status"));
            } else {
                System.out.println("⚠️ No orders found matching the join criteria.");
            }
        }
    }
}