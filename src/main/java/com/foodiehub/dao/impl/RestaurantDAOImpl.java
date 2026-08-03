
package com.foodiehub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.foodiehub.dao.RestaurantDAO;
import com.foodiehub.model.Restaurant;
import com.foodiehub.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String SELECT_RESTAURANT_BY_ID = "SELECT * FROM restaurant WHERE RestaurantID = ?";
    private static final String SELECT_ALL_ACTIVE_RESTAURANTS = "SELECT * FROM restaurant WHERE IsActive = 1";
    private static final String SELECT_ALL_RESTAURANTS = "SELECT * FROM restaurant ORDER BY RestaurantID DESC";
    private static final String SELECT_RESTAURANTS_BY_CUISINE = "SELECT * FROM restaurant WHERE CuisineType = ? AND IsActive = 1";
    private static final String INSERT_RESTAURANT = "INSERT INTO restaurant (Name, CuisineType, DeliveryTime, Address, Rating, IsActive, ImagePath) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_RESTAURANT = "UPDATE restaurant SET Name = ?, CuisineType = ?, DeliveryTime = ?, Address = ?, Rating = ?, IsActive = ?, ImagePath = ? WHERE RestaurantID = ?";
    private static final String DELETE_RESTAURANT = "DELETE FROM restaurant WHERE RestaurantID = ?";

    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        Restaurant restaurant = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_RESTAURANT_BY_ID)) {
            
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    restaurant = extractRestaurantFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return restaurant;
    }

    @Override
    public List<Restaurant> getAllActiveRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_ACTIVE_RESTAURANTS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(extractRestaurantFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_RESTAURANTS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(extractRestaurantFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Restaurant> searchRestaurantsByCuisine(String cuisineType) {
        List<Restaurant> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_RESTAURANTS_BY_CUISINE)) {
            
            ps.setString(1, cuisineType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractRestaurantFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean addRestaurant(Restaurant restaurant) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_RESTAURANT)) {
            
            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setInt(6, restaurant.isActive() ? 1 : 0);
            ps.setString(7, restaurant.getImagePath());

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_RESTAURANT)) {
            
            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setInt(6, restaurant.isActive() ? 1 : 0);
            ps.setString(7, restaurant.getImagePath());
            ps.setInt(8, restaurant.getRestaurantId());

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_RESTAURANT)) {
            
            ps.setInt(1, restaurantId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    private Restaurant extractRestaurantFromResultSet(ResultSet rs) throws SQLException {
        Restaurant restaurant = new Restaurant();
        restaurant.setRestaurantId(rs.getInt("RestaurantID"));
        restaurant.setName(rs.getString("Name"));
        restaurant.setCuisineType(rs.getString("CuisineType"));
        restaurant.setDeliveryTime(rs.getInt("DeliveryTime"));
        restaurant.setAddress(rs.getString("Address"));
        restaurant.setRating(rs.getDouble("Rating"));
        restaurant.setActive(rs.getInt("IsActive") == 1);
        restaurant.setImagePath(rs.getString("ImagePath"));
        return restaurant;
    }
}