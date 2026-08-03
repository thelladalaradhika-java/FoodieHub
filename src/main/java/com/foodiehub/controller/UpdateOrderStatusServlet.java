package com.foodiehub.controller;

import com.foodiehub.dao.OrderDAO;
import com.foodiehub.dao.impl.OrderDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/updateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        this.orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        try {
            if ("DELETE".equalsIgnoreCase(action) && orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);
                orderDAO.deleteOrder(orderId);
            } else if (orderIdStr != null && request.getParameter("status") != null) {
                int orderId = Integer.parseInt(orderIdStr);
                String newStatus = request.getParameter("status");
                orderDAO.updateOrderStatus(orderId, newStatus);
            }
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminDashboard?error=true");
        }
    }
}