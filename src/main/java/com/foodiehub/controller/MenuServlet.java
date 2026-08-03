


package com.foodiehub.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.foodiehub.dao.MenuDAO;
import com.foodiehub.dao.RestaurantDAO;
import com.foodiehub.dao.impl.MenuDAOImpl;
import com.foodiehub.dao.impl.RestaurantDAOImpl;
import com.foodiehub.model.Menu;
import com.foodiehub.model.Restaurant;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private MenuDAO menuDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        menuDAO = new MenuDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String restaurantIdParam = request.getParameter("restaurantId");
        String searchQuery = request.getParameter("search");
        String sortOption = request.getParameter("sort");

        List<Menu> menuList = null;

        if (restaurantIdParam != null && !restaurantIdParam.trim().isEmpty()) {
            try {
                int restaurantId = Integer.parseInt(restaurantIdParam);
                
                Restaurant selectedRestaurant = restaurantDAO.getRestaurantById(restaurantId);
                menuList = menuDAO.getAvailableMenuByRestaurantId(restaurantId);

                menuList = filterAndSortMenu(menuList, searchQuery, sortOption);

                request.setAttribute("selectedRestaurant", selectedRestaurant);
                request.setAttribute("menuList", menuList);
                
                request.getRequestDispatcher("/WEB-INF/views/menu.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Fallback: Fetch all menu items
        menuList = menuDAO.getAllMenuItems();
        menuList = filterAndSortMenu(menuList, searchQuery, sortOption);

        request.setAttribute("menuList", menuList);
        request.getRequestDispatcher("/WEB-INF/views/menu.jsp").forward(request, response);
    }

    // Pure Java Memory Filtering and Sorting (100% No JavaScript)
    private List<Menu> filterAndSortMenu(List<Menu> items, String query, String sort) {
        if (items == null) return new ArrayList<>();

        List<Menu> result = new ArrayList<>(items);

        // Search Filter
        if (query != null && !query.trim().isEmpty()) {
            String q = query.toLowerCase().trim();
            result = result.stream()
                .filter(item -> (item.getItemName() != null && item.getItemName().toLowerCase().contains(q)) ||
                                (item.getDescription() != null && item.getDescription().toLowerCase().contains(q)))
                .collect(Collectors.toList());
        }

        // Price Sort
        if ("lowToHigh".equalsIgnoreCase(sort)) {
            result.sort(Comparator.comparingDouble(Menu::getPrice));
        } else if ("highToLow".equalsIgnoreCase(sort)) {
            result.sort(Comparator.comparingDouble(Menu::getPrice).reversed());
        }

        return result;
    }
}