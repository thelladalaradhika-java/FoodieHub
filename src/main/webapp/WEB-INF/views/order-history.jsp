<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Order History - FoodieHub</title>
                 <link rel="icon" type="image/jpeg"
      href="<%= request.getContextPath() %>/images/img/Foodiefavicon.jpg">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { 
            --brand-orange: #ff6600; 
            --text-dark: #0f172a; 
            --text-muted: #475569; 
            --navbar-dark-bg: #1a1d20;
            --navbar-text-white: #ffffff;
            --app-bg-gradient: linear-gradient(135deg, #cfd8dc 0%, #b0bec5 50%, #90a4ae 100%);
            --glass-card-bg: rgba(255, 255, 255, 0.88);
            --glass-card-inner: rgba(255, 255, 255, 0.65);
            --glass-border: rgba(255, 255, 255, 0.9);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body { 
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
            background: var(--app-bg-gradient) fixed; 
            color: var(--text-dark); 
            min-height: 100vh;
        }

        .navbar { 
            background-color: var(--navbar-dark-bg); 
            box-shadow: 0 4px 12px rgba(0,0,0,0.2); 
            padding: 14px 36px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            position: sticky; 
            top: 0; 
            z-index: 1000; 
        }

        .navbar-brand { font-size: 1.6em; font-weight: 800; color: var(--brand-orange); text-decoration: none; }
        .navbar-brand span { color: #ffffff; }

        .navbar-links { display: flex; gap: 24px; align-items: center; }
        .navbar-links a { color: var(--navbar-text-white); text-decoration: none; font-weight: 600; font-size: 0.95em; }
        .navbar-links a.active { color: var(--brand-orange); }

        .container { max-width: 850px; margin: 35px auto; padding: 0 20px; }
        .page-header { text-align: center; margin-bottom: 30px; }
        .page-header h1 { font-size: 2.2em; font-weight: 800; color: var(--text-dark); }
        .page-header p { color: var(--text-muted); font-size: 1em; font-weight: 600; margin-top: 6px; }

        .order-card { 
            background: var(--glass-card-bg); 
            backdrop-filter: blur(14px);
            border-radius: 18px; 
            padding: 26px; 
            margin-bottom: 25px; 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08); 
            border: 1px solid var(--glass-border); 
        }
        
        .card-top { 
            display: flex; 
            justify-content: space-between; 
            align-items: flex-start; 
            border-bottom: 1px solid rgba(15, 23, 42, 0.12); 
            padding-bottom: 16px; 
            margin-bottom: 16px; 
        }

        .restaurant-name { font-size: 1.35em; font-weight: 800; color: var(--text-dark); margin: 0; }
        .restaurant-address { font-size: 0.88em; color: var(--text-muted); margin-top: 4px; font-weight: 600; }

        .order-meta { font-size: 0.88em; color: var(--text-muted); text-align: right; font-weight: 600; }
        .order-id { font-weight: 800; color: var(--text-dark); font-size: 1.05em; }

        .badge { 
            display: inline-block; 
            padding: 5px 14px; 
            border-radius: 20px; 
            font-weight: 800; 
            font-size: 0.75em; 
            text-transform: uppercase; 
            margin-top: 8px; 
        }
        .badge-pending { background-color: #fef3c7; color: #92400e; }
        .badge-delivered { background-color: #dcfce7; color: #166534; }

        .items-box { 
            background: var(--glass-card-inner); 
            border-radius: 12px; 
            border: 1px solid var(--glass-border); 
            padding: 18px; 
            margin-bottom: 18px; 
        }

        .items-header { font-size: 0.82em; font-weight: 800; color: var(--text-muted); margin-bottom: 12px; }
        
        .item-row { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 10px 0; 
            border-bottom: 1px dashed rgba(15, 23, 42, 0.12); 
            font-size: 0.95em; 
        }
        .item-row:last-child { border-bottom: none; }
        .item-name { font-weight: 700; color: var(--text-dark); }
        .item-price-unit { color: var(--text-muted); font-size: 0.88em; margin-left: 8px; font-weight: 600; }
        .item-total { font-weight: 800; color: var(--text-dark); }

        .card-bottom { display: flex; justify-content: space-between; align-items: center; }
        .total-amount { font-size: 1.35em; font-weight: 800; color: var(--brand-orange); }

        .empty-card { 
            background: var(--glass-card-bg); 
            text-align: center; 
            padding: 50px 30px; 
            border-radius: 18px; 
        }
        .btn-browse { 
            display: inline-block; 
            padding: 12px 26px; 
            background: var(--brand-orange); 
            color: white; 
            text-decoration: none; 
            border-radius: 10px; 
            font-weight: 700; 
            margin-top: 20px; 
        }
    </style>
</head>
<body>

<% String ctx = request.getContextPath(); %>

<nav class="navbar">
    <a href="<%= ctx %>/home" class="navbar-brand">Foodie<span>Hub</span></a>
    <div class="navbar-links">
        <a href="<%= ctx %>/home"><i class="fa-solid fa-house"></i> Home</a>
        <a href="<%= ctx %>/cart"><i class="fa-solid fa-basket-shopping"></i> Cart</a>
        <a href="<%= ctx %>/orderHistory" class="active"><i class="fa-solid fa-clock-rotate-left"></i> My Orders</a>
        <a href="<%= ctx %>/profile"><i class="fa-solid fa-user"></i> Profile</a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <h1>Your Order History</h1>
        <p>Review all your orders across all registered restaurants</p>
    </div>

<%
    Object rawOrderList = request.getAttribute("orderList");
    Object rawItemsMap = request.getAttribute("orderItemsMap");

    List<?> orderList = (rawOrderList instanceof List) ? (List<?>) rawOrderList : null;
    Map<?, ?> orderItemsMap = (rawItemsMap instanceof Map) ? (Map<?, ?>) rawItemsMap : null;

    if (orderList == null || orderList.isEmpty()) {
%>
        <div class="empty-card">
            <h2>No Orders Found</h2>
            <p style="color: var(--text-muted); margin-top: 8px;">You haven't placed any food orders yet.</p>
            <a href="<%= ctx %>/home" class="btn-browse"><i class="fa-solid fa-utensils"></i> Order Now</a>
        </div>
<%
    } else {
        for (Object objOrder : orderList) {
            if (!(objOrder instanceof Map)) continue;
            Map<?, ?> order = (Map<?, ?>) objOrder;
            
            Object orderIdObj = order.get("orderId");
            int orderId = (orderIdObj instanceof Number) ? ((Number) orderIdObj).intValue() : 0;
            
            String status = (order.get("status") != null) ? order.get("status").toString() : "PENDING";
            String badgeClass = "DELIVERED".equalsIgnoreCase(status) ? "badge-delivered" : "badge-pending";

            Object totalAmountObj = order.get("totalAmount");
            double totalAmount = (totalAmountObj instanceof Number) ? ((Number) totalAmountObj).doubleValue() : 0.0;
            
            String restName = (order.get("restaurantName") != null) ? order.get("restaurantName").toString() : "FoodieHub Partner";
            String restAddress = (order.get("restaurantAddress") != null) ? order.get("restaurantAddress").toString() : "Local Branch";
            String orderDateStr = (order.get("formattedDate") != null) ? order.get("formattedDate").toString() : "Recent Order";
            String paymentMethod = (order.get("paymentMethod") != null) ? order.get("paymentMethod").toString() : "COD";
%>
        <div class="order-card">
            <div class="card-top">
                <div>
                    <h3 class="restaurant-name"><i class="fa-solid fa-store" style="color: var(--brand-orange); margin-right: 6px;"></i><%= restName %></h3>
                    <div class="restaurant-address"><%= restAddress %></div>
                </div>
                <div class="order-meta">
                    <div class="order-id">Order #<%= orderId %></div>
                    <div><%= orderDateStr %></div>
                    <div><span class="badge <%= badgeClass %>"><%= status.replace("_", " ") %></span></div>
                </div>
            </div>

            <div class="items-box">
                <div class="items-header">ORDERED ITEMS</div>
                <%
                    List<?> items = null;
                    if (orderItemsMap != null) {
                        Object rawItems = orderItemsMap.get(Integer.valueOf(orderId));
                        if (rawItems instanceof List) {
                            items = (List<?>) rawItems;
                        }
                    }

                    if (items != null && !items.isEmpty()) {
                        for (Object objItem : items) {
                            if (!(objItem instanceof Map)) continue;
                            Map<?, ?> item = (Map<?, ?>) objItem;
                            
                            String itemName = (item.get("itemName") != null) ? item.get("itemName").toString() : "Food Item";
                            Object qtyObj = item.get("quantity");
                            int quantity = (qtyObj instanceof Number) ? ((Number) qtyObj).intValue() : 1;
                            
                            Object priceObj = item.get("price");
                            double price = (priceObj instanceof Number) ? ((Number) priceObj).doubleValue() : 0.0;
                            
                            Object itemTotalObj = item.get("itemTotal");
                            double itemTotal = (itemTotalObj instanceof Number) ? ((Number) itemTotalObj).doubleValue() : 0.0;
                %>
                        <div class="item-row">
                            <div>
                                <span class="item-name"><%= itemName %></span>
                                <span class="item-price-unit">(<%= quantity %> x ₹<%= String.format("%.2f", price) %>)</span>
                            </div>
                            <div class="item-total">₹<%= String.format("%.2f", itemTotal) %></div>
                        </div>
                <%
                        }
                    }
                %>
            </div>

            <div class="card-bottom">
                <div style="font-size: 0.92em; color: var(--text-muted); font-weight: 600;">
                    Payment: <strong><%= paymentMethod %></strong>
                </div>
                <div>
                    <span style="font-size: 0.9em; color: var(--text-muted); margin-right: 8px; font-weight: 600;">Total:</span>
                    <span class="total-amount">₹<%= String.format("%.2f", totalAmount) %></span>
                </div>
            </div>
        </div>
<%
        }
    }
%>
</div>

</body>
</html>