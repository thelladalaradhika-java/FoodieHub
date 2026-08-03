package com.foodiehub.dao;

import java.util.List;
import com.foodiehub.model.OrderItem;

public interface OrderItemDAO {
    // Checkout batch processing
    boolean addOrderItems(List<OrderItem> items);
    
    // Receipt fetching
    List<OrderItem> getItemsByOrderId(int orderId);
}