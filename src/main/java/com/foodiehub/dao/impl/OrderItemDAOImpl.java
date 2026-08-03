package com.foodiehub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.foodiehub.dao.OrderItemDAO;
import com.foodiehub.model.OrderItem;
import com.foodiehub.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    // SQL Queries matching your database table schema
    private static final String INSERT_ORDER_ITEM = "INSERT INTO OrderItem (order_id, menu_id, quantity, item_total) VALUES (?, ?, ?, ?);";
    private static final String SELECT_ITEMS_BY_ORDER = "SELECT * FROM OrderItem WHERE order_id = ?;";

    @Override
    public boolean addOrderItems(List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            return false;
        }
        
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_ORDER_ITEM)) {
            
            // Disable auto-commit to run this as a single transaction block
            conn.setAutoCommit(false);
            
            for (OrderItem item : items) {
                ps.setInt(1, item.getOrderId());
                ps.setInt(2, item.getMenuId());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getItemTotal());
                ps.addBatch(); // Add to batch queue
            }
            
            // Execute all batched inserts together
            int[] results = ps.executeBatch();
            
            // Commit transaction
            conn.commit();
            
            // Verify if all elements were inserted successfully
            success = true;
            for (int res : results) {
                if (res == PreparedStatement.EXECUTE_FAILED) {
                    success = false;
                    break;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public List<OrderItem> getItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ITEMS_BY_ORDER)) {
            
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setMenuId(rs.getInt("menu_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setItemTotal(rs.getDouble("item_total"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}