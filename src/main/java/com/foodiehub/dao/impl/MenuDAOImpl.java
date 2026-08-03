package com.foodiehub.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodiehub.dao.MenuDAO;
import com.foodiehub.model.Menu;
import com.foodiehub.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    // SQL queries matched EXACTLY to your MySQL schema
    private static final String SELECT_MENU_BY_ID = "SELECT * FROM menu WHERE MenuID = ?";
    private static final String SELECT_MENU_BY_RESTAURANT = "SELECT * FROM menu WHERE RestaurantID = ?";
    private static final String SELECT_AVAILABLE_MENU_BY_RESTAURANT = "SELECT * FROM menu WHERE RestaurantID = ? AND IsAvailable = 1";
    private static final String SELECT_ALL_MENU_ITEMS = "SELECT * FROM menu";
    private static final String INSERT_MENU = "INSERT INTO menu (RestaurantID, ItemName, Description, Price, IsAvailable, ImagePath) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_MENU = "UPDATE menu SET RestaurantID = ?, ItemName = ?, Description = ?, Price = ?, IsAvailable = ?, ImagePath = ? WHERE MenuID = ?";
    private static final String DELETE_MENU = "DELETE FROM menu WHERE MenuID = ?";

    @Override
    public Menu getMenuItemById(int menuId) {
        Menu menu = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_MENU_BY_ID)) {
            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    menu = extractMenuFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menu;
    }

    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {
        List<Menu> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_MENU_BY_RESTAURANT)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMenuFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Menu> getAvailableMenuByRestaurantId(int restaurantId) {
        List<Menu> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_AVAILABLE_MENU_BY_RESTAURANT)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMenuFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Menu> getAllMenuItems() {
        List<Menu> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_MENU_ITEMS);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractMenuFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean addMenuItem(Menu menuItem) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_MENU)) {
            ps.setInt(1, menuItem.getRestaurantId());
            ps.setString(2, menuItem.getItemName());
            ps.setString(3, menuItem.getDescription());
            ps.setDouble(4, menuItem.getPrice());
            ps.setBoolean(5, menuItem.isAvailable());
            ps.setString(6, menuItem.getImagePath());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public boolean updateMenuItem(Menu menuItem) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_MENU)) {
            ps.setInt(1, menuItem.getRestaurantId());
            ps.setString(2, menuItem.getItemName());
            ps.setString(3, menuItem.getDescription());
            ps.setDouble(4, menuItem.getPrice());
            ps.setBoolean(5, menuItem.isAvailable());
            ps.setString(6, menuItem.getImagePath());
            ps.setInt(7, menuItem.getMenuId());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public boolean deleteMenuItem(int menuId) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_MENU)) {
            ps.setInt(1, menuId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    private Menu extractMenuFromResultSet(ResultSet rs) throws SQLException {
        Menu menu = new Menu();
        menu.setMenuId(rs.getInt("MenuID"));
        menu.setRestaurantId(rs.getInt("RestaurantID"));
        menu.setItemName(rs.getString("ItemName"));
        menu.setDescription(rs.getString("Description"));
        menu.setPrice(rs.getDouble("Price"));
        menu.setAvailable(rs.getBoolean("IsAvailable"));
        menu.setImagePath(rs.getString("ImagePath"));
        return menu;
    }
}