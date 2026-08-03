
package com.foodiehub.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/AdminDashboardServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DEFAULT_RESTAURANT_IMG = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500";
    private static final String DEFAULT_MENU_IMG = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500";
    private static final String DEFAULT_ADMIN_IMG = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=250";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        
        if (session.getAttribute("role") == null) {
            session.setAttribute("role", "ADMIN");
        }
        if (session.getAttribute("adminName") == null) {
            session.setAttribute("adminName", "System Admin");
        }
        if (session.getAttribute("adminEmail") == null) {
            session.setAttribute("adminEmail", "admin@foodiehub.com");
        }
        if (session.getAttribute("adminPhone") == null) {
            session.setAttribute("adminPhone", "+91 9876543210");
        }
        if (session.getAttribute("adminAvatar") == null) {
            session.setAttribute("adminAvatar", DEFAULT_ADMIN_IMG);
        }

        String activeTab = request.getParameter("tab");
        if (activeTab == null || activeTab.trim().isEmpty()) {
            activeTab = "restaurants";
        }
        request.setAttribute("activeTab", activeTab);

        String selectedRestaurantFilter = request.getParameter("filterRestaurantId");
        if (selectedRestaurantFilter == null) {
            selectedRestaurantFilter = "all";
        }
        request.setAttribute("filterRestaurantId", selectedRestaurantFilter);

        List<Map<String, Object>> restaurants = new ArrayList<>();
        List<Map<String, Object>> menus = new ArrayList<>();
        List<Map<String, Object>> orders = new ArrayList<>();
        List<Map<String, Object>> users = new ArrayList<>();

        double totalRevenue = 0.00;
        int totalOrders = 0;
        int totalRestaurants = 0;
        int totalUsers = 0;

        try {
            Class<?> dbClass = Class.forName("com.foodiehub.util.DBConnection");
            Connection conn = (Connection) dbClass.getMethod("getConnection").invoke(null);

            if (conn != null) {
                totalRevenue = getSingleDouble(conn, "SELECT COALESCE(SUM(TotalAmount), 0.0) FROM ordertable WHERE Status = 'DELIVERED'");
                totalOrders = getSingleInt(conn, "SELECT COUNT(*) FROM ordertable");
                totalRestaurants = getSingleInt(conn, "SELECT COUNT(*) FROM restaurant");
                totalUsers = getSingleInt(conn, "SELECT COUNT(*) FROM user");

                restaurants = getRestaurants(conn);
                menus = getMenus(conn, selectedRestaurantFilter);
                orders = getOrders(conn);
                users = getUsers(conn);
                conn.close();
            }
        } catch (Exception e) {
            restaurants = getMockRestaurants();
            menus = getMockMenus(selectedRestaurantFilter);
            orders = getMockOrders();
            users = getMockUsers();
        }

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRestaurants", totalRestaurants);
        request.setAttribute("totalUsers", totalUsers);

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("menus", menus);
        request.setAttribute("orders", orders);
        request.setAttribute("users", users);

        request.getRequestDispatcher("/WEB-INF/views/adminDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");
        if (action == null) action = "";

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        try {
            Class<?> dbClass = Class.forName("com.foodiehub.util.DBConnection");
            Connection conn = (Connection) dbClass.getMethod("getConnection").invoke(null);

            switch (action) {
                case "updateAdminProfile": {
                    String newName = request.getParameter("adminName");
                    String newEmail = request.getParameter("adminEmail");
                    String newPhone = request.getParameter("adminPhone");
                    Part adminImagePart = request.getPart("adminImage");
                    String adminImgPath = handleFileUpload(adminImagePart, uploadPath, request.getContextPath());

                    if (newName != null && !newName.trim().isEmpty()) session.setAttribute("adminName", newName.trim());
                    if (newEmail != null && !newEmail.trim().isEmpty()) session.setAttribute("adminEmail", newEmail.trim());
                    if (newPhone != null && !newPhone.trim().isEmpty()) session.setAttribute("adminPhone", newPhone.trim());
                    if (adminImgPath != null) session.setAttribute("adminAvatar", adminImgPath);

                    session.setAttribute("toastMsg", "Admin Profile updated successfully!");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "removeAdminProfileImage": {
                    session.setAttribute("adminAvatar", DEFAULT_ADMIN_IMG);
                    session.setAttribute("toastMsg", "Profile image removed! Reverted to default.");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "addRestaurant": {
                    String name = request.getParameter("name");
                    String cuisineType = request.getParameter("cuisineType");
                    int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
                    String address = request.getParameter("address");
                    double rating = 4.5;
                    if (request.getParameter("rating") != null && !request.getParameter("rating").trim().isEmpty()) {
                        rating = Double.parseDouble(request.getParameter("rating"));
                    }
                    
                    Part restImagePart = request.getPart("restaurantImage");
                    String imgPath = handleFileUpload(restImagePart, uploadPath, request.getContextPath());
                    if (imgPath == null) imgPath = DEFAULT_RESTAURANT_IMG;

                    if (conn != null) {
                        String sql = "INSERT INTO restaurant (Name, CuisineType, DeliveryTime, Address, Rating, ImagePath) VALUES (?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setString(1, name);
                            ps.setString(2, cuisineType);
                            ps.setInt(3, deliveryTime);
                            ps.setString(4, address);
                            ps.setDouble(5, rating);
                            ps.setString(6, imgPath);
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Restaurant added successfully!");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "updateRestaurant": {
                    int id = Integer.parseInt(request.getParameter("restaurantId"));
                    String name = request.getParameter("name");
                    String cuisineType = request.getParameter("cuisineType");
                    double rating = Double.parseDouble(request.getParameter("rating"));
                    Part restImagePart = request.getPart("restaurantImage");
                    String imgPath = handleFileUpload(restImagePart, uploadPath, request.getContextPath());

                    if (conn != null) {
                        String sql = (imgPath != null) 
                            ? "UPDATE restaurant SET Name = ?, CuisineType = ?, Rating = ?, ImagePath = ? WHERE RestaurantID = ?"
                            : "UPDATE restaurant SET Name = ?, CuisineType = ?, Rating = ? WHERE RestaurantID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setString(1, name);
                            ps.setString(2, cuisineType);
                            ps.setDouble(3, rating);
                            if (imgPath != null) {
                                ps.setString(4, imgPath);
                                ps.setInt(5, id);
                            } else {
                                ps.setInt(4, id);
                            }
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Restaurant updated successfully!");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "deleteRestaurant": {
                    int id = Integer.parseInt(request.getParameter("restaurantId"));
                    if (conn != null) {
                        String sql = "DELETE FROM restaurant WHERE RestaurantID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, id);
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Restaurant deleted!");
                    session.setAttribute("toastType", "danger");
                    break;
                }

                case "addMenu": {
                    int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                    String itemName = request.getParameter("itemName");
                    double price = Double.parseDouble(request.getParameter("price"));

                    Part menuImagePart = request.getPart("menuImage");
                    String imgPath = handleFileUpload(menuImagePart, uploadPath, request.getContextPath());
                    if (imgPath == null) imgPath = DEFAULT_MENU_IMG;

                    if (conn != null) {
                        String sql = "INSERT INTO menu (RestaurantID, ItemName, Description, Price, ImagePath) VALUES (?, ?, 'Delicious fresh meal', ?, ?)";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, restaurantId);
                            ps.setString(2, itemName);
                            ps.setDouble(3, price);
                            ps.setString(4, imgPath);
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Menu item added successfully!");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "updateMenu": {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    String itemName = request.getParameter("itemName");
                    double price = Double.parseDouble(request.getParameter("price"));
                    Part menuImagePart = request.getPart("menuImage");
                    String imgPath = handleFileUpload(menuImagePart, uploadPath, request.getContextPath());

                    if (conn != null) {
                        String sql = (imgPath != null) 
                            ? "UPDATE menu SET ItemName = ?, Price = ?, ImagePath = ? WHERE MenuID = ?"
                            : "UPDATE menu SET ItemName = ?, Price = ? WHERE MenuID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setString(1, itemName);
                            ps.setDouble(2, price);
                            if (imgPath != null) {
                                ps.setString(3, imgPath);
                                ps.setInt(4, menuId);
                            } else {
                                ps.setInt(3, menuId);
                            }
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Menu item updated successfully!");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "deleteMenu": {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    if (conn != null) {
                        String sql = "DELETE FROM menu WHERE MenuID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, menuId);
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Menu item removed!");
                    session.setAttribute("toastType", "danger");
                    break;
                }

                case "updateOrderStatus": {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String newStatus = request.getParameter("status");
                    if (conn != null) {
                        String sql = "UPDATE ordertable SET Status = ? WHERE OrderID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setString(1, newStatus);
                            ps.setInt(2, orderId);
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "Order status updated!");
                    session.setAttribute("toastType", "success");
                    break;
                }

                case "deleteUser": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    if (conn != null) {
                        String sql = "DELETE FROM user WHERE UserID = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, id);
                            ps.executeUpdate();
                        }
                    }
                    session.setAttribute("toastMsg", "User removed!");
                    session.setAttribute("toastType", "danger");
                    break;
                }
            }
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        String tab = request.getParameter("redirectTab");
        String filterParam = request.getParameter("filterRestaurantId");
        
        String redirectUrl = request.getContextPath() + "/AdminDashboardServlet?tab=" + (tab != null ? tab : "restaurants");
        if (filterParam != null && !filterParam.trim().isEmpty()) {
            redirectUrl += "&filterRestaurantId=" + filterParam;
        }

        response.sendRedirect(redirectUrl);
    }

    private String handleFileUpload(Part filePart, String uploadPath, String contextPath) {
        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }
        
        String fileName = extractFileName(filePart);
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("\\s+", "_");
        try {
            filePart.write(uploadPath + File.separator + fileName);
            return contextPath + "/uploads/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private String extractFileName(Part part) {
        if (part == null) return null;
        
        String submittedName = part.getSubmittedFileName();
        if (submittedName != null && !submittedName.trim().isEmpty()) {
            return Paths.get(submittedName).getFileName().toString();
        }

        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String s : contentDisp.split(";")) {
                if (s.trim().startsWith("filename")) {
                    String name = s.substring(s.indexOf("=") + 2, s.length() - 1);
                    return Paths.get(name).getFileName().toString();
                }
            }
        }
        return null;
    }

    private double getSingleDouble(Connection conn, String sql) throws SQLException {
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    private int getSingleInt(Connection conn, String sql) throws SQLException {
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Map<String, Object>> getRestaurants(Connection conn) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM restaurant ORDER BY RestaurantID DESC")) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("RestaurantID"));
                map.put("name", rs.getString("Name"));
                map.put("cuisineType", rs.getString("CuisineType"));
                map.put("deliveryTime", rs.getInt("DeliveryTime"));
                map.put("address", rs.getString("Address"));
                map.put("rating", rs.getBigDecimal("Rating"));
                map.put("imagePath", sanitizeImgPath(rs.getString("ImagePath"), DEFAULT_RESTAURANT_IMG));
                list.add(map);
            }
        }
        return list;
    }

    private List<Map<String, Object>> getMenus(Connection conn, String restaurantFilterId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT m.*, COALESCE(r.Name, 'General') AS RestaurantName FROM menu m LEFT JOIN restaurant r ON m.RestaurantID = r.RestaurantID";
        
        if (restaurantFilterId != null && !restaurantFilterId.trim().isEmpty() && !restaurantFilterId.equals("all")) {
            sql += " WHERE m.RestaurantID = " + Integer.parseInt(restaurantFilterId);
        }
        sql += " ORDER BY m.MenuID DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("MenuID"));
                map.put("restaurantId", rs.getInt("RestaurantID"));
                map.put("restaurantName", rs.getString("RestaurantName"));
                map.put("itemName", rs.getString("ItemName"));
                map.put("description", rs.getString("Description"));
                map.put("price", rs.getBigDecimal("Price"));
                map.put("imagePath", sanitizeImgPath(rs.getString("ImagePath"), DEFAULT_MENU_IMG));
                list.add(map);
            }
        }
        return list;
    }

    private List<Map<String, Object>> getOrders(Connection conn) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.*, COALESCE(u.Username, 'Guest') AS Username, COALESCE(r.Name, 'FoodieHub') AS RestaurantName FROM ordertable o LEFT JOIN user u ON o.UserID = u.UserID LEFT JOIN restaurant r ON o.RestaurantID = r.RestaurantID ORDER BY o.OrderID DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("OrderID"));
                map.put("customer", rs.getString("Username"));
                map.put("restaurant", rs.getString("RestaurantName"));
                map.put("amount", rs.getBigDecimal("TotalAmount"));
                map.put("status", rs.getString("Status"));
                list.add(map);
            }
        }
        return list;
    }

    private List<Map<String, Object>> getUsers(Connection conn) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT * FROM user ORDER BY UserID DESC")) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("UserID"));
                map.put("username", rs.getString("Username"));
                map.put("email", rs.getString("Email"));
                map.put("role", rs.getString("Role"));
                list.add(map);
            }
        }
        return list;
    }

    private String sanitizeImgPath(String path, String defaultUrl) {
        if (path == null || path.trim().isEmpty()) {
            return defaultUrl;
        }
        return path.trim();
    }

    private List<Map<String, Object>> getMockRestaurants() {
        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> r1 = new HashMap<>();
        r1.put("id", 1); r1.put("name", "Burger Bistro"); r1.put("cuisineType", "American"); r1.put("deliveryTime", 25); r1.put("address", "123 MG Road"); r1.put("rating", new BigDecimal("4.8")); r1.put("imagePath", DEFAULT_RESTAURANT_IMG);
        list.add(r1);

        Map<String, Object> r2 = new HashMap<>();
        r2.put("id", 2); r2.put("name", "Royal Spice"); r2.put("cuisineType", "Indian"); r2.put("deliveryTime", 30); r2.put("address", "45 Park Street"); r2.put("rating", new BigDecimal("4.6")); r2.put("imagePath", DEFAULT_RESTAURANT_IMG);
        list.add(r2);
        return list;
    }

    private List<Map<String, Object>> getMockMenus(String filterId) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (filterId == null || filterId.equals("all") || filterId.equals("1")) {
            Map<String, Object> m1 = new HashMap<>();
            m1.put("id", 1); m1.put("restaurantId", 1); m1.put("restaurantName", "Burger Bistro"); m1.put("itemName", "Cheeseburger Deluxe"); m1.put("description", "Juicy grilled beef patty with cheese"); m1.put("price", new BigDecimal("250.00")); m1.put("imagePath", DEFAULT_MENU_IMG);
            list.add(m1);
        }
        if (filterId == null || filterId.equals("all") || filterId.equals("2")) {
            Map<String, Object> m2 = new HashMap<>();
            m2.put("id", 2); m2.put("restaurantId", 2); m2.put("restaurantName", "Royal Spice"); m2.put("itemName", "Paneer Butter Masala"); m2.put("description", "Creamy tomato gravy with cottage cheese"); m2.put("price", new BigDecimal("320.00")); m2.put("imagePath", DEFAULT_MENU_IMG);
            list.add(m2);
        }
        return list;
    }

    private List<Map<String, Object>> getMockOrders() {
        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> o1 = new HashMap<>();
        o1.put("id", 101); o1.put("customer", "John Doe"); o1.put("restaurant", "Burger Bistro"); o1.put("amount", new BigDecimal("250.00")); o1.put("status", "PENDING");
        list.add(o1);
        return list;
    }

    private List<Map<String, Object>> getMockUsers() {
        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> u1 = new HashMap<>();
        u1.put("id", 1); u1.put("username", "John Doe"); u1.put("email", "john@example.com"); u1.put("role", "CUSTOMER");
        list.add(u1);
        return list;
    }
}
