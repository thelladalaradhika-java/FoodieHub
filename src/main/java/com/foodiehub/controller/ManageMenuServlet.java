package com.foodiehub.controller;

import com.foodiehub.dao.MenuDAO;
import com.foodiehub.dao.impl.MenuDAOImpl;
import com.foodiehub.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/manageMenu")
public class ManageMenuServlet extends HttpServlet {

    private MenuDAO menuDAO;

    @Override
    public void init() throws ServletException {
        this.menuDAO = new MenuDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            if ("ADD".equalsIgnoreCase(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                boolean isAvailable = "1".equals(request.getParameter("isAvailable")) || "true".equalsIgnoreCase(request.getParameter("isAvailable"));
                String imagePath = request.getParameter("imagePath");

                Menu menu = new Menu(0, restaurantId, itemName, description, price, isAvailable, imagePath);
                menuDAO.addMenuItem(menu);

            } else if ("UPDATE".equalsIgnoreCase(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                boolean isAvailable = "1".equals(request.getParameter("isAvailable")) || "true".equalsIgnoreCase(request.getParameter("isAvailable"));
                String imagePath = request.getParameter("imagePath");

                Menu menu = new Menu(menuId, restaurantId, itemName, description, price, isAvailable, imagePath);
                menuDAO.updateMenuItem(menu);

            } else if ("DELETE".equalsIgnoreCase(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                menuDAO.deleteMenuItem(menuId);
            }
            
            // Redirect back to Admin Dashboard page
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminDashboard?error=true");
        }
    }
}