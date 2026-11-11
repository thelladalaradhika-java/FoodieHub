
package com.foodiehub.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/foodiehub_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    // Helper to retrieve user ID from session
    private Integer getUserIdFromSession(HttpSession session) {
        if (session == null) return null;
        Object idObj = session.getAttribute("userId");
        if (idObj == null) idObj = session.getAttribute("userID");
        if (idObj == null) idObj = session.getAttribute("id");

        if (idObj instanceof Integer) {
            return (Integer) idObj;
        } else if (idObj instanceof String) {
            try { return Integer.parseInt((String) idObj); } catch (Exception ignored) {}
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Integer userId = getUserIdFromSession(session);

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                
                // ONLY SELECT EXISTING COLUMNS FROM YOUR USER TABLE
                String sql = "SELECT Username, Email, PhoneNumber, Address FROM user WHERE UserID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("username", rs.getString("Username"));
                            request.setAttribute("email", rs.getString("Email"));
                            request.setAttribute("phone", rs.getString("PhoneNumber"));
                            request.setAttribute("address", rs.getString("Address"));
                        } else {
                            request.setAttribute("errorMessage", "User details not found.");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
        }

        // CHECK IF PROFILE PHOTO FILE EXISTS ON SERVER DISK
        String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "profiles";
        File imageFile = new File(uploadDir, "user_" + userId + ".jpg");

        if (imageFile.exists()) {
            // Relative URL for image rendering in JSP
            request.setAttribute("profilePicUrl", request.getContextPath() + "/uploads/profiles/user_" + userId + ".jpg");
        } else {
            request.setAttribute("profilePicUrl", null);
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Integer userId = getUserIdFromSession(session);

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "profiles";
        File imageFile = new File(uploadDir, "user_" + userId + ".jpg");

        // -------------------------------------------------------------
        // ACTION: DELETE ONLY PROFILE PHOTO (FILE DELETION)
        // -------------------------------------------------------------
        if ("removePhoto".equalsIgnoreCase(action)) {
            if (imageFile.exists()) {
                boolean deleted = imageFile.delete();
                if (deleted) {
                    request.setAttribute("successMessage", "Profile photo deleted successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete profile photo file.");
                }
            } else {
                request.setAttribute("errorMessage", "No profile photo found to delete.");
            }
        } 
        
        // -------------------------------------------------------------
        // ACTION: UPDATE DETAILS & SAVE PHOTO FILE
        // -------------------------------------------------------------
        else {
            String phone = request.getParameter("phoneNumber");
            String address = request.getParameter("address");

            phone = (phone != null) ? phone.trim() : "";
            address = (address != null) ? address.trim() : "";

            // 1. Save uploaded photo file to server disk if provided
            try {
                Part filePart = request.getPart("profileImage");
                if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().trim().isEmpty()) {
                    File dir = new File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();

                    Path destinationPath = Paths.get(imageFile.getAbsolutePath());
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, destinationPath, StandardCopyOption.REPLACE_EXISTING);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 2. Update existing MySQL user details (Phone & Address)
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                    String sql = "UPDATE user SET PhoneNumber = ?, Address = ? WHERE UserID = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, phone);
                        ps.setString(2, address);
                        ps.setInt(3, userId);
                        ps.executeUpdate();
                    }
                }
                request.setAttribute("successMessage", "Profile updated successfully!");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Failed to update profile details: " + e.getMessage());
            }
        }

        // Reload fresh data and forward back
        doGet(request, response);
    }
}
