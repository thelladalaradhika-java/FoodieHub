<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.foodiehub.controller.CartServlet.CartItemDTO" %>
<%@ page import="com.foodiehub.model.Menu" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - FoodieHub</title>
                 <link rel="icon" type="image/jpeg"
      href="<%= request.getContextPath() %>/images/img/Foodiefavicon.jpg">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { 
            --brand-orange: #ff6600; 
            --brand-orange-hover: #e55c00;
            --text-dark: #1a1a1a; 
            --text-muted: #555555; 
            --navbar-dark-bg: #1a1d20;
            --navbar-text-white: #ffffff;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: linear-gradient(135deg, #eef2f3 0%, #8e9eab 100%); 
            background-attachment: fixed;
            color: var(--text-dark); 
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar { 
            background-color: var(--navbar-dark-bg) !important; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.2); 
            padding: 14px 36px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            position: sticky; 
            top: 0; 
            z-index: 1000; 
        }

        .navbar-brand { 
            font-size: 1.6em; 
            font-weight: 800; 
            color: var(--brand-orange); 
            text-decoration: none; 
            display: flex;
            align-items: center;
        }

        .navbar-brand span { color: #ffffff; }

        .navbar-links { display: flex; gap: 24px; align-items: center; }

        .navbar-links a { 
            color: var(--navbar-text-white); 
            text-decoration: none; 
            font-weight: 600; 
            font-size: 0.95em; 
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .navbar-links a i { color: var(--brand-orange); }

        .cart-layout {
            max-width: 1050px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 30px;
            align-items: start;
            flex: 1;
            width: 100%;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.75) !important;
            backdrop-filter: blur(12px) !important;
            -webkit-backdrop-filter: blur(12px) !important;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.6);
            margin-bottom: 25px;
        }

        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid rgba(255, 102, 0, 0.2);
            padding-bottom: 12px;
            margin-bottom: 20px;
        }

        .cart-header h2 {
            font-size: 1.3em;
            color: #1a1a1a;
            margin-bottom: 0;
            border-bottom: none;
            padding-bottom: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .cart-header h2 i { color: var(--brand-orange); }

        .btn-add-more {
            background-color: transparent;
            color: var(--brand-orange);
            border: 1.5px solid var(--brand-orange);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease-in-out;
        }

        .btn-add-more:hover {
            background-color: var(--brand-orange);
            color: #ffffff;
            transform: translateY(-1px);
        }

        .cart-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            gap: 15px;
        }

        .cart-item:last-child { border-bottom: none; }

        .item-info { display: flex; align-items: center; gap: 15px; flex: 1; }

        .item-img {
            width: 75px;
            height: 75px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid rgba(255, 255, 255, 0.8);
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }

        .item-details h4 { font-size: 1.05em; color: #1a1a1a; margin-bottom: 4px; }
        .item-details p { font-size: 0.82em; color: var(--text-muted); margin-bottom: 6px; }
        .item-price { font-size: 0.95em; font-weight: 700; color: var(--brand-orange); }

        .qty-controls {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.9);
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        .btn-qty {
            background: none;
            border: none;
            color: var(--brand-orange);
            font-size: 0.9em;
            cursor: pointer;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-qty:hover { background-color: rgba(255, 102, 0, 0.15); }
        .qty-number { font-weight: 700; font-size: 0.95em; min-width: 18px; text-align: center; }

        .btn-delete-submit {
            background: rgba(220, 38, 38, 0.1);
            border: none;
            color: #dc2626;
            cursor: pointer;
            font-size: 1.1em;
            padding: 8px 12px;
            border-radius: 8px;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-delete-submit:hover {
            background-color: #dc2626;
            color: #ffffff;
            transform: scale(1.05);
        }

        .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.95em; color: var(--text-muted); }
        .summary-row.total {
            border-top: 2px dashed rgba(0, 0, 0, 0.15);
            padding-top: 15px;
            margin-top: 15px;
            font-size: 1.2em;
            font-weight: 800;
            color: #1a1a1a;
        }
        .summary-row.total span:last-child { color: var(--brand-orange); }

        .btn-checkout {
            width: 100%;
            background-color: var(--brand-orange);
            color: #ffffff;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-top: 15px;
        }

        .btn-checkout:hover { background-color: var(--brand-orange-hover); }

        .empty-cart { text-align: center; padding: 50px 20px; }
        .empty-cart i { font-size: 3.5em; color: var(--text-muted); margin-bottom: 15px; }
        .empty-cart p { font-size: 1.1em; color: var(--text-muted); margin-bottom: 20px; }
    </style>
</head>
<body>

<% 
    String ctx = request.getContextPath(); 
    
    // Extract restaurantId passed from CartServlet or session
    Object restIdAttr = request.getAttribute("restaurantId");
    if (restIdAttr == null) {
        restIdAttr = session.getAttribute("currentRestaurantId");
    }
    int currentRestId = (restIdAttr != null) ? Integer.parseInt(restIdAttr.toString()) : 0;
    
    String menuUrl = (currentRestId > 0) ? ctx + "/menu?restaurantId=" + currentRestId : ctx + "/menu";
%>

<nav class="navbar">
    <a href="<%= ctx %>/home" class="navbar-brand">Foodie<span>Hub</span></a>
    <div class="navbar-links">
        <a href="<%= ctx %>/home"><i class="fa-solid fa-house"></i> Home</a>
        <a href="<%= ctx %>/cart" style="color: var(--brand-orange);"><i class="fa-solid fa-basket-shopping"></i> Cart</a>
        <a href="<%= ctx %>/orderHistory"><i class="fa-solid fa-clock-rotate-left"></i> My Orders</a>
    </div>
</nav>

<div class="cart-layout">
    
    <div class="glass-card">
        <div class="cart-header">
            <h2><i class="fa-solid fa-basket-shopping"></i> Your Food Cart</h2>
            <a href="<%= menuUrl %>" class="btn-add-more">
                <i class="fa-solid fa-plus"></i> Add More Items
            </a>
        </div>

        <% 
            @SuppressWarnings("unchecked")
            List<CartItemDTO> cartItems = (List<CartItemDTO>) request.getAttribute("cartItems");
            Double subtotalObj = (Double) request.getAttribute("subtotalAmount");
            double subtotal = (subtotalObj != null) ? subtotalObj : 0.00;

            if (cartItems != null && !cartItems.isEmpty()) {
                for (CartItemDTO itemDTO : cartItems) {
                    Menu menu = itemDTO.getMenu();
                    int qty = itemDTO.getQuantity();
                    double itemTotal = itemDTO.getItemTotal();

                    String imgPath = menu.getImagePath();
                    if (imgPath == null || imgPath.trim().isEmpty()) {
                        imgPath = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200";
                    }
        %>
                    <div class="cart-item">
                        <div class="item-info">
                            <img src="<%= imgPath %>" alt="<%= menu.getItemName() %>" class="item-img" 
                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200';">
                            <div class="item-details">
                                <h4><%= menu.getItemName() %></h4>
                                <% if (menu.getDescription() != null && !menu.getDescription().trim().isEmpty()) { %>
                                    <p><%= menu.getDescription() %></p>
                                <% } %>
                                <div class="item-price">&#8377;<%= String.format("%.2f", itemTotal) %></div>
                            </div>
                        </div>

                        <!-- Quantity Controls -->
                        <div class="qty-controls">
                            <form action="<%= ctx %>/cart" method="post" style="display:inline;">
                                <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                <input type="hidden" name="action" value="decrease">
                                <button type="submit" class="btn-qty"><i class="fa-solid fa-minus"></i></button>
                            </form>
                            
                            <span class="qty-number"><%= qty %></span>

                            <form action="<%= ctx %>/cart" method="post" style="display:inline;">
                                <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                <input type="hidden" name="action" value="add">
                                <button type="submit" class="btn-qty"><i class="fa-solid fa-plus"></i></button>
                            </form>
                        </div>

                        <!-- Delete Item -->
                        <form action="<%= ctx %>/cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                            <button type="submit" class="btn-delete-submit" title="Delete Item">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </form>
                    </div>
        <% 
                }
            } else { 
        %>
            <div class="empty-cart">
                <i class="fa-solid fa-basket-shopping"></i>
                <p>Your cart is empty.</p>
                <a href="<%= menuUrl %>" class="btn-checkout" style="display:inline-block; width:auto; padding: 10px 24px;">Browse Menu</a>
            </div>
        <% 
            } 
        %>
    </div>

    <div>
        <div class="glass-card">
            <h2><i class="fa-solid fa-receipt"></i> Order Summary</h2>
            
            <% 
                double deliveryFee = (subtotal > 0) ? 50.00 : 0.00;
                double grandTotal = subtotal + deliveryFee;
            %>

            <div class="summary-row">
                <span>Items Subtotal</span>
                <span>&#8377;<%= String.format("%.2f", subtotal) %></span>
            </div>
            <div class="summary-row">
                <span>Delivery Fee & Taxes</span>
                <span>&#8377;<%= String.format("%.2f", deliveryFee) %></span>
            </div>
            
            <div class="summary-row total">
                <span>Grand Total</span>
                <span>&#8377;<%= String.format("%.2f", grandTotal) %></span>
            </div>

            <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <a href="<%= ctx %>/checkout" class="btn-checkout">
                    Proceed to Checkout <i class="fa-solid fa-arrow-right" style="margin-left: 6px;"></i>
                </a>
            <% } %>
        </div>
    </div>

</div>

</body>
</html>