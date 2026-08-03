package com.foodiehub.controller;

import com.foodiehub.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String emailOrUsername = request.getParameter("email");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role"); // ADMIN or CUSTOMER

        if (selectedRole == null || selectedRole.trim().isEmpty()) {
            selectedRole = "CUSTOMER";
        }

        if (emailOrUsername == null || password == null || emailOrUsername.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both Email/Username and Password.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        emailOrUsername = emailOrUsername.trim();

        // SQL verifies the credentials AND ensures the account role matches the selected toggle
        String sql = "SELECT UserID, Username, Email, Password, Role, Address, PhoneNumber FROM user WHERE (Email = ? OR Username = ?) AND UPPER(Role) = UPPER(?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, emailOrUsername);
            ps.setString(2, emailOrUsername);
            ps.setString(3, selectedRole);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPassword = rs.getString("Password");

                    // Direct password check
                    if (dbPassword != null && dbPassword.equals(password)) {
                        
                        HttpSession session = request.getSession(true);
                        int userId = rs.getInt("UserID");
                        String username = rs.getString("Username");
                        String email = rs.getString("Email");
                        String role = rs.getString("Role");
                        String address = rs.getString("Address");
                        String phone = rs.getString("PhoneNumber");

                        // Store session attributes
                        session.setAttribute("userId", userId);
                        session.setAttribute("username", username);
                        session.setAttribute("user", username);
                        session.setAttribute("email", email);
                        session.setAttribute("role", role);
                        session.setAttribute("adminName", username);
                        session.setAttribute("adminEmail", email);
                        
                        if (address != null) session.setAttribute("userAddress", address);
                        if (phone != null) session.setAttribute("userPhone", phone);

                        // STRICT ROLE REDIRECT
                        if ("ADMIN".equalsIgnoreCase(role)) {
                            // Redirects straight to the Admin Servlet
                            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
                        } else {
                            // Redirects straight to Customer Home
                            response.sendRedirect(request.getContextPath() + "/home");
                        }
                        return;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Invalid credentials or wrong role selected
        request.setAttribute("errorMessage", "Invalid " + selectedRole.toLowerCase() + " credentials or account does not exist.");
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
}