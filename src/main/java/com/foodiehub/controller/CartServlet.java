





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
import jakarta.servlet.http.HttpSession;

import com.foodiehub.dao.MenuDAO;
import com.foodiehub.dao.impl.MenuDAOImpl;
import com.foodiehub.model.Menu;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private MenuDAO menuDAO = new MenuDAOImpl();

    // Helper DTO class to pass structured cart items to the JSP
    public static class CartItemDTO {
        private Menu menu;
        private int quantity;
        private double itemTotal;

        public CartItemDTO(Menu menu, int quantity, double itemTotal) {
            this.menu = menu;
            this.quantity = quantity;
            this.itemTotal = itemTotal;
        }

        public Menu getMenu() { return menu; }
        public int getQuantity() { return quantity; }
        public double getItemTotal() { return itemTotal; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        Object cartObj = session.getAttribute("cart");
        Map<Integer, Integer> cart = new HashMap<>();

        if (cartObj instanceof Map) {
            for (Map.Entry<?, ?> entry : ((Map<?, ?>) cartObj).entrySet()) {
                int key = parseInteger(entry.getKey());
                int val = parseInteger(entry.getValue());
                if (key > 0 && val > 0) {
                    cart.put(key, val);
                }
            }
        }

        session.setAttribute("cart", cart);

        List<CartItemDTO> cartItemList = new ArrayList<>();
        double subtotal = 0.0;
        int currentRestaurantId = 0;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int menuId = entry.getKey();
            int qty = entry.getValue();

            Menu item = menuDAO.getMenuItemById(menuId);
            if (item != null) {
                double itemTotal = item.getPrice() * qty;
                subtotal += itemTotal;
                cartItemList.add(new CartItemDTO(item, qty, itemTotal));

                // Capture the restaurant ID from the items in the cart
                if (currentRestaurantId == 0) {
                    currentRestaurantId = item.getRestaurantId();
                }
            }
        }

        // Save restaurant ID in session so "Add More Items" always knows where to return
        if (currentRestaurantId > 0) {
            session.setAttribute("currentRestaurantId", currentRestaurantId);
        } else if (session.getAttribute("currentRestaurantId") != null) {
            currentRestaurantId = (Integer) session.getAttribute("currentRestaurantId");
        }

        request.setAttribute("cartItems", cartItemList);
        request.setAttribute("subtotalAmount", subtotal);
        request.setAttribute("restaurantId", currentRestaurantId);

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        Object cartObj = session.getAttribute("cart");
        Map<Integer, Integer> cart = new HashMap<>();

        if (cartObj instanceof Map) {
            for (Map.Entry<?, ?> entry : ((Map<?, ?>) cartObj).entrySet()) {
                int key = parseInteger(entry.getKey());
                int val = parseInteger(entry.getValue());
                if (key > 0 && val > 0) {
                    cart.put(key, val);
                }
            }
        }
        
        String action = request.getParameter("action");
        int menuId = parseInteger(request.getParameter("menuId"));

        if (menuId > 0) {
            if ("delete".equalsIgnoreCase(action) || "remove".equalsIgnoreCase(action)) {
                cart.remove(menuId);
            } else if ("add".equalsIgnoreCase(action)) {
                cart.put(menuId, cart.getOrDefault(menuId, 0) + 1);
            } else if ("decrease".equalsIgnoreCase(action)) {
                int currentQty = cart.getOrDefault(menuId, 1);
                if (currentQty > 1) {
                    cart.put(menuId, currentQty - 1);
                } else {
                    cart.remove(menuId);
                }
            }
            
            session.setAttribute("cart", cart);

            // Also store restaurant ID when adding an item via POST
            Menu item = menuDAO.getMenuItemById(menuId);
            if (item != null && item.getRestaurantId() > 0) {
                session.setAttribute("currentRestaurantId", item.getRestaurantId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private int parseInteger(Object obj) {
        if (obj == null) return 0;
        if (obj instanceof Integer) return (Integer) obj;
        try {
            return Integer.parseInt(obj.toString().trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}