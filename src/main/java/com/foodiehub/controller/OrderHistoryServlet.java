package com.foodiehub.controller;

import com.foodiehub.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/orderHistory", "/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        // Fetch UserID from session key variants or fallback to User ID 7 (Active Account)
        Integer userId = null;
        if (session != null) {
            Object[] keys = {"userId", "user_id", "id", "UserID", "USER_ID"};
            for (Object key : keys) {
                Object uObj = session.getAttribute(key.toString());
                if (uObj instanceof Number) {
                    userId = ((Number) uObj).intValue();
                    break;
                } else if (uObj instanceof String) {
                    try { 
                        userId = Integer.parseInt((String) uObj); 
                        break;
                    } catch (Exception ignored) {}
                }
            }
        }

        // Hard fallback to Account #7 if session is unauthenticated
        if (userId == null || userId <= 0) {
            userId = 7;
        }

        List<Map<String, Object>> orderList = new ArrayList<>();
        Map<Integer, List<Map<String, Object>>> orderItemsMap = new HashMap<>();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

        try (Connection conn = DBConnection.getConnection()) {

            // SQL Query: Pulls dynamic Restaurant Name and Address via LEFT JOINs
            String sql = "SELECT DISTINCT o.OrderID, o.OrderDate, o.TotalAmount, o.Status, o.PaymentMethod, " +
                         "COALESCE(r_direct.Name, r_item.Name, 'FoodieHub Partner') AS RestaurantName, " +
                         "COALESCE(r_direct.Address, r_item.Address, 'City Center Branch') AS RestaurantAddress " +
                         "FROM ordertable o " +
                         "LEFT JOIN restaurant r_direct ON o.RestaurantID = r_direct.RestaurantID " +
                         "LEFT JOIN orderitem oi ON o.OrderID = oi.OrderID " +
                         "LEFT JOIN menu m ON oi.MenuID = m.MenuID " +
                         "LEFT JOIN restaurant r_item ON m.RestaurantID = r_item.RestaurantID " +
                         "WHERE o.UserID = ? " +
                         "ORDER BY o.OrderID DESC";

            try (PreparedStatement psOrder = conn.prepareStatement(sql)) {
                psOrder.setInt(1, userId);

                try (ResultSet rsOrder = psOrder.executeQuery()) {
                    while (rsOrder.next()) {
                        Map<String, Object> orderMap = new HashMap<>();
                        int orderId = rsOrder.getInt("OrderID");
                        
                        orderMap.put("orderId", orderId);
                        orderMap.put("restaurantName", rsOrder.getString("RestaurantName"));
                        orderMap.put("restaurantAddress", rsOrder.getString("RestaurantAddress"));
                        orderMap.put("totalAmount", rsOrder.getDouble("TotalAmount"));
                        orderMap.put("status", rsOrder.getString("Status"));
                        orderMap.put("paymentMethod", rsOrder.getString("PaymentMethod"));

                        Timestamp ts = rsOrder.getTimestamp("OrderDate");
                        orderMap.put("formattedDate", ts != null ? ts.toLocalDateTime().format(dateFormatter) : "Recent Order");

                        orderList.add(orderMap);

                        // Fetch individual items associated with this specific OrderID
                        String itemSql = "SELECT oi.Quantity, oi.ItemTotal, " +
                                         "COALESCE(m.ItemName, 'Special Item') AS ItemName, " +
                                         "COALESCE(m.Price, CASE WHEN oi.Quantity > 0 THEN oi.ItemTotal / oi.Quantity ELSE oi.ItemTotal END) AS Price " +
                                         "FROM orderitem oi " +
                                         "LEFT JOIN menu m ON oi.MenuID = m.MenuID " +
                                         "WHERE oi.OrderID = ?";

                        try (PreparedStatement psItems = conn.prepareStatement(itemSql)) {
                            psItems.setInt(1, orderId);
                            try (ResultSet rsItems = psItems.executeQuery()) {
                                List<Map<String, Object>> itemList = new ArrayList<>();
                                while (rsItems.next()) {
                                    Map<String, Object> itemMap = new HashMap<>();
                                    itemMap.put("itemName", rsItems.getString("ItemName"));
                                    itemMap.put("quantity", rsItems.getInt("Quantity"));
                                    itemMap.put("price", rsItems.getDouble("Price"));
                                    itemMap.put("itemTotal", rsItems.getDouble("ItemTotal"));
                                    itemList.add(itemMap);
                                }
                                orderItemsMap.put(orderId, itemList);
                            }
                        }
                    }
                }
            }

            request.setAttribute("orderList", orderList);
            request.setAttribute("orderItemsMap", orderItemsMap);
            forwardToJsp(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            forwardToJsp(request, response);
        }
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (getServletContext().getResource("/WEB-INF/views/order-history.jsp") != null) {
            request.getRequestDispatcher("/WEB-INF/views/order-history.jsp").forward(request, response);
        } else if (getServletContext().getResource("/WEB-INF/views/orderHistory.jsp") != null) {
            request.getRequestDispatcher("/WEB-INF/views/orderHistory.jsp").forward(request, response);
        } else if (getServletContext().getResource("/orderHistory.jsp") != null) {
            request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/order-history.jsp").forward(request, response);
        }
    }
}