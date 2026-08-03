


package com.foodiehub.dao;

import java.util.List;
import com.foodiehub.model.Order;

public interface OrderDAO {
    // Checkout Method
    int createOrder(Order order);
    
    // Customer Methods
    Order getOrderById(int orderId);
    List<Order> getOrdersByUserId(int userId);

    // Admin / Management Methods
    List<Order> getAllOrders();
    boolean updateOrderStatus(int orderId, String status);
    boolean deleteOrder(int orderId); // <-- ADDED FOR ADMIN
}