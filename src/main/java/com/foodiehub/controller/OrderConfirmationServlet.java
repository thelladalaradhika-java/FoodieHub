package com.foodiehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        // Fetch Order Details
        String orderId = (String) request.getAttribute("orderId");
        if (orderId == null) orderId = (String) session.getAttribute("orderId");

        String totalAmount = (String) request.getAttribute("totalAmountFormatted");
        if (totalAmount == null) totalAmount = (String) session.getAttribute("totalAmountFormatted");

        String paymentMethod = (String) request.getAttribute("paymentMethod");
        if (paymentMethod == null) paymentMethod = (String) session.getAttribute("paymentMethod");

        request.setAttribute("orderId", orderId != null ? orderId : "ORD-" + System.currentTimeMillis());
        request.setAttribute("totalAmountFormatted", totalAmount != null ? totalAmount : "0.00");
        request.setAttribute("paymentMethod", paymentMethod != null ? paymentMethod : "COD");

        // Forward directly to the JSP page
        if (getServletContext().getResource("/WEB-INF/views/orderConfirmation.jsp") != null) {
            request.getRequestDispatcher("/WEB-INF/views/orderConfirmation.jsp").forward(request, response);
        } else if (getServletContext().getResource("/WEB-INF/views/order-confirmation.jsp") != null) {
            request.getRequestDispatcher("/WEB-INF/views/order-confirmation.jsp").forward(request, response);
        } else if (getServletContext().getResource("/orderConfirmation.jsp") != null) {
            request.getRequestDispatcher("/orderConfirmation.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/order-confirmation.jsp").forward(request, response);
        }
    }
}