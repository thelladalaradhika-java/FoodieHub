
package com.foodiehub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import com.foodiehub.dao.OrderDAO;
import com.foodiehub.model.Order;
import com.foodiehub.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    private static final String INSERT_ORDER = "INSERT INTO ordertable (UserID, RestaurantID, OrderDate, TotalAmount, Status, PaymentMethod) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM ordertable WHERE OrderID = ?";
    private static final String SELECT_ORDERS_BY_USER = "SELECT * FROM ordertable WHERE UserID = ? ORDER BY OrderDate DESC";
    private static final String SELECT_ALL_ORDERS = "SELECT * FROM ordertable ORDER BY OrderDate DESC";
    private static final String UPDATE_ORDER_STATUS = "UPDATE ordertable SET Status = ? WHERE OrderID = ?";
    private static final String DELETE_ORDER = "DELETE FROM ordertable WHERE OrderID = ?";

    @Override
    public int createOrder(Order order) {
        int generatedId = -1;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setTimestamp(3, Timestamp.valueOf(order.getOrderDate() != null ? order.getOrderDate() : java.time.LocalDateTime.now()));
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getStatus() != null ? order.getStatus() : "PENDING");
            ps.setString(6, order.getPaymentMethod());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedId = generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    @Override
    public Order getOrderById(int orderId) {
        Order order = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ORDER_BY_ID)) {
            
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = extractOrderFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ORDERS_BY_USER)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            
            ps.setString(1, status);
            ps.setInt(2, orderId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public boolean deleteOrder(int orderId) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_ORDER)) {
            
            ps.setInt(1, orderId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("OrderID"));
        order.setUserId(rs.getInt("UserID"));
        order.setRestaurantId(rs.getInt("RestaurantID"));
        if (rs.getTimestamp("OrderDate") != null) {
            order.setOrderDate(rs.getTimestamp("OrderDate").toLocalDateTime());
        }
        order.setTotalAmount(rs.getDouble("TotalAmount"));
        order.setStatus(rs.getString("Status"));
        order.setPaymentMethod(rs.getString("PaymentMethod"));
        return order;
    }
}