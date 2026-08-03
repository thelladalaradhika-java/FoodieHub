package com.foodiehub.dao;

import java.util.List;
import com.foodiehub.model.Menu;

public interface MenuDAO {
    Menu getMenuItemById(int menuId);
    List<Menu> getMenuByRestaurantId(int restaurantId);
    List<Menu> getAvailableMenuByRestaurantId(int restaurantId);
    List<Menu> getAllMenuItems();
    boolean addMenuItem(Menu menuItem);
    boolean updateMenuItem(Menu menuItem);
    boolean deleteMenuItem(int menuId);
}