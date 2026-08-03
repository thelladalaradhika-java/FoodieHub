



package com.foodiehub.dao;

import java.util.List;
import com.foodiehub.model.Restaurant;

public interface RestaurantDAO {
    // Customer Methods
    Restaurant getRestaurantById(int restaurantId);
    List<Restaurant> getAllActiveRestaurants();
    List<Restaurant> searchRestaurantsByCuisine(String cuisineType);

    // Admin Methods
    List<Restaurant> getAllRestaurants(); // <-- ADDED FOR ADMIN
    boolean addRestaurant(Restaurant restaurant);
    boolean updateRestaurant(Restaurant restaurant);
    boolean deleteRestaurant(int restaurantId);
}