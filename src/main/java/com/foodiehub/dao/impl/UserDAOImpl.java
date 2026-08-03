
package com.foodiehub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodiehub.dao.UserDAO;
import com.foodiehub.model.User;
import com.foodiehub.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    // SQL Queries
    private static final String INSERT_USER_SQL = "INSERT INTO user (Username, Password, Email, PhoneNumber, Address, Role, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?);";
    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM user WHERE Email = ?;";
    private static final String SELECT_USER_BY_ID = "SELECT * FROM user WHERE UserID = ?;";
    private static final String UPDATE_USER_PROFILE = "UPDATE user SET Username = ?, Email = ?, PhoneNumber = ?, Address = ? WHERE UserID = ?;";
    private static final String SELECT_ALL_USERS = "SELECT * FROM user ORDER BY UserID DESC;";
    private static final String UPDATE_USER_ROLE = "UPDATE user SET Role = ? WHERE UserID = ?;";
    private static final String UPDATE_LAST_LOGIN = "UPDATE user SET LastLoginDate = ? WHERE UserID = ?;";

    @Override
    public boolean registerUser(User user) {
        boolean rowInserted = false;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER_SQL)) {
            
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword()); 
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getPhoneNumber());
            preparedStatement.setString(5, user.getAddress());
            preparedStatement.setString(6, user.getRole() != null ? user.getRole() : "CUSTOMER");
            preparedStatement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));

            rowInserted = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    @Override
    public User loginUser(String email, String password) {
        User user = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_EMAIL)) {
            
            preparedStatement.setString(1, email);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    if (rs.getString("Password").equals(password)) {
                        user = extractUserFromResultSet(rs);
                        // Update last login timestamp in DB
                        updateLastLoginDate(connection, user.getUserId());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public User getUserById(int userId) {
        User user = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID)) {
            
            preparedStatement.setInt(1, userId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public boolean updateUserProfile(User user) {
        boolean rowUpdated = false;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USER_PROFILE)) {
            
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPhoneNumber());
            preparedStatement.setString(4, user.getAddress());
            preparedStatement.setInt(5, user.getUserId());

            rowUpdated = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = preparedStatement.executeQuery()) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean updateUserRole(int userId, String newRole) {
        boolean rowUpdated = false;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USER_ROLE)) {
            
            preparedStatement.setString(1, newRole);
            preparedStatement.setInt(2, userId);

            rowUpdated = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    // Helper method to record login timestamps
    private void updateLastLoginDate(Connection conn, int userId) {
        try (PreparedStatement ps = conn.prepareStatement(UPDATE_LAST_LOGIN)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Helper method to convert ResultSet row to User Object
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setPassword(rs.getString("Password")); // Added mapping
        user.setEmail(rs.getString("Email"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setAddress(rs.getString("Address"));
        user.setRole(rs.getString("Role"));
        
        if (rs.getTimestamp("CreatedDate") != null) {
            user.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        }
        if (rs.getTimestamp("LastLoginDate") != null) {
            user.setLastLoginDate(rs.getTimestamp("LastLoginDate").toLocalDateTime());
        }
        return user;
    }
}