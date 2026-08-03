




package com.foodiehub.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.foodiehub.dao.RestaurantDAO;
import com.foodiehub.dao.impl.RestaurantDAOImpl;
import com.foodiehub.model.Restaurant;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        this.restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        List<Restaurant> rawList;

        if (category != null && !category.trim().isEmpty() && !"all".equalsIgnoreCase(category)) {
            rawList = restaurantDAO.searchRestaurantsByCuisine(category.trim());
        } else {
            rawList = restaurantDAO.getAllRestaurants();
        }

        List<Map<String, Object>> mappedRestaurants = new ArrayList<>();

        if (rawList != null) {
            for (Restaurant r : rawList) {
                Map<String, Object> map = new HashMap<>();
                map.put("restaurantId", r.getRestaurantId());
                map.put("name", r.getName());
                map.put("cuisineType", r.getCuisineType());
                map.put("rating", r.getRating());
                map.put("address", r.getAddress());
                
                // Read exact delivery time from database model instead of hardcoded 30
                map.put("deliveryTime", r.getDeliveryTime() > 0 ? r.getDeliveryTime() : 30);

                // Directly pass database imagePath
                String dbImg = r.getImagePath();
                if (dbImg == null || dbImg.trim().isEmpty()) {
                    dbImg = "images/img/default.jpg";
                }
                map.put("imageUrl", dbImg);

                mappedRestaurants.add(map);
            }
        }

        request.setAttribute("restaurants", mappedRestaurants);
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}