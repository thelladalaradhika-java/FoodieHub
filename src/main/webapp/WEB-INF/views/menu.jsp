<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.foodiehub.model.Menu" %>
<%@ page import="com.foodiehub.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FoodieHub | Restaurant Menu</title>
    
    
                 <link rel="icon" type="image/jpeg"
      href="<%= request.getContextPath() %>/images/img/Foodiefavicon.jpg">
        
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root { 
            --brand-orange: #ff6600; 
            --brand-white: #ffffff; 
            --text-dark: #1e293b; 
            --text-muted: #64748b; 
            --glass-bg: rgba(255, 255, 255, 0.55);
            --glass-border: rgba(255, 255, 255, 0.8);
            --glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.08);
        }
        
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        
        body { 
            background: linear-gradient(135deg, #dbe2ef 0%, #cbd5e1 50%, #d8e1e9 100%);
            background-attachment: fixed;
            color: var(--text-dark); 
            padding-top: 70px; 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh; 
        }
        
        .main-container { width: 100%; padding: 30px 40px; flex: 1; }

        .restaurant-header-card {
            width: 100%;
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--glass-shadow);
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .restaurant-header-img {
            width: 130px;
            height: 130px;
            border-radius: 16px;
            object-fit: cover;
            border: 2px solid var(--glass-border);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .restaurant-details h2 { font-size: 28px; font-weight: 700; margin-bottom: 6px; color: var(--text-dark); }
        .restaurant-details .cuisine { font-size: 15px; font-weight: 600; color: var(--brand-orange); margin-bottom: 10px; }
        .restaurant-details .meta-row { display: flex; align-items: center; gap: 20px; font-size: 14px; color: var(--text-muted); }

        .badge-rating {
            background: rgba(255, 255, 255, 0.9);
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 700;
            color: var(--text-dark);
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .filter-section {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 35px;
            flex-wrap: wrap;
        }

        .search-box { flex: 1; min-width: 250px; position: relative; }
        .search-box input {
            width: 100%;
            padding: 12px 20px 12px 45px;
            border-radius: 30px;
            border: 1px solid var(--glass-border);
            outline: none;
            font-size: 14px;
            background: rgba(255, 255, 255, 0.7);
            box-shadow: var(--glass-shadow);
        }
        .search-box i { position: absolute; left: 18px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }

        .sort-box select {
            padding: 12px 20px;
            border-radius: 30px;
            border: 1px solid var(--glass-border);
            outline: none;
            font-size: 14px;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.7);
            color: var(--text-dark);
        }

        .btn-filter-apply {
            background: var(--brand-orange);
            color: #fff;
            border: none;
            padding: 12px 24px;
            border-radius: 30px;
            font-weight: 600;
            cursor: pointer;
        }

        .menu-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); 
            gap: 30px; 
            margin-bottom: 60px; 
            width: 100%;
        }

        .menu-card { 
            background: var(--glass-bg); 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border); 
            border-radius: 20px; 
            overflow: hidden; 
            display: flex; 
            flex-direction: column; 
            box-shadow: var(--glass-shadow);
        }

        .card-img-wrap { height: 180px; background: rgba(226, 232, 240, 0.5); position: relative; }
        .card-img-wrap img { width: 100%; height: 100%; object-fit: cover; }

        .card-info-wrap { padding: 20px; flex: 1; display: flex; flex-direction: column; }
        .card-info-wrap h3 { font-size: 17px; margin-bottom: 6px; font-weight: 600; color: var(--text-dark); }
        .card-info-wrap .description { font-size: 13px; color: var(--text-muted); margin-bottom: 15px; line-height: 1.4; min-height: 38px; }

        .card-bottom-row { display: flex; align-items: center; justify-content: space-between; margin-top: auto; }
        .price-tag { font-size: 18px; font-weight: 700; color: var(--text-dark); }

        .btn-add-cart { 
            background: var(--brand-orange); 
            color: white; 
            border: none; 
            padding: 10px 20px; 
            border-radius: 12px; 
            font-size: 13px; 
            font-weight: 600; 
            cursor: pointer; 
        }

        .no-items-msg { color: var(--text-muted); grid-column: 1/-1; font-size: 16px; text-align: center; padding: 40px; }

        footer { background: rgba(15, 23, 42, 0.9); color: #94a3b8; padding: 50px 40px 20px; margin-top: auto; width: 100%; }
        .footer-container { width: 100%; display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 40px; }
        .footer-col h4 { color: white; font-size: 16px; margin-bottom: 15px; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 10px; }
        .footer-col ul li a { color: #94a3b8; text-decoration: none; font-size: 14px; }
        .footer-bottom { width: 100%; margin: 40px auto 0; padding-top: 20px; border-top: 1px solid #334155; text-align: center; font-size: 13px; }
    </style>
</head>
<body>

<jsp:include page="partials/navbar.jsp" />

<div class="main-container">

    <% 
        Restaurant restaurant = (Restaurant) request.getAttribute("selectedRestaurant");
        if (restaurant != null) {
            String restImg = restaurant.getImagePath();
            if (restImg != null && !restImg.startsWith("http") && !restImg.startsWith("/")) {
                restImg = request.getContextPath() + "/" + restImg;
            }
    %>
        <div class="restaurant-header-card">
            <img src="<%= restImg %>" 
                 alt="<%= restaurant.getName() %>" 
                 class="restaurant-header-img"
                 onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500';">
            
            <div class="restaurant-details">
                <h2><%= restaurant.getName() %></h2>
                <div class="cuisine"><%= restaurant.getCuisineType() %></div>
                <div class="meta-row">
                    <span class="badge-rating"><i class="fa-solid fa-star" style="color:#eab308;"></i> <%= restaurant.getRating() %></span>
                    <span><i class="fa-regular fa-clock"></i> <%= restaurant.getDeliveryTime() %> mins</span>
                    <span><i class="fa-solid fa-location-dot"></i> <%= restaurant.getAddress() %></span>
                </div>
            </div>
        </div>
    <% } %>

    <%
        String searchVal = request.getParameter("search") != null ? request.getParameter("search") : "";
        String sortVal = request.getParameter("sort") != null ? request.getParameter("sort") : "default";
        String restaurantIdVal = request.getParameter("restaurantId") != null ? request.getParameter("restaurantId") : "";
    %>
    
    <!-- PURE HTML FORM SUBMISSION (NO JAVASCRIPT) -->
    <form action="<%= request.getContextPath() %>/menu" method="get" class="filter-section">
        <input type="hidden" name="restaurantId" value="<%= restaurantIdVal %>">
        
        <div class="search-box">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="search" placeholder="Search dishes inside this menu..." value="<%= searchVal %>">
        </div>
        
        <div class="sort-box">
            <select name="sort">
                <option value="default" <%= "default".equals(sortVal) ? "selected" : "" %>>Sort by: Default</option>
                <option value="lowToHigh" <%= "lowToHigh".equals(sortVal) ? "selected" : "" %>>Price: Low to High</option>
                <option value="highToLow" <%= "highToLow".equals(sortVal) ? "selected" : "" %>>Price: High to Low</option>
            </select>
        </div>

        <button type="submit" class="btn-filter-apply">Apply Filter</button>
    </form>

    <div class="menu-grid">
        <% 
            List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
            if (menuList != null && !menuList.isEmpty()) {
                for (Menu item : menuList) {
                    String itemImg = item.getImagePath();
                    if (itemImg != null && !itemImg.startsWith("http") && !itemImg.startsWith("/")) {
                        itemImg = request.getContextPath() + "/" + itemImg;
                    }
        %>
                    <div class="menu-card">
                        <div class="card-img-wrap">
                             <img src="<%= itemImg %>" 
                                  alt="<%= item.getItemName() %>" 
                                  onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500';">
                        </div>
                        <div class="card-info-wrap">
                            <h3><%= item.getItemName() %></h3>
                            <p class="description"><%= item.getDescription() %></p>
                            
                            <div class="card-bottom-row">
                                <div class="price-tag">&#8377;<%= String.format("%.2f", item.getPrice()) %></div>
                                <form action="<%= request.getContextPath() %>/cart" method="post" style="margin: 0;">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="action" value="add">
                                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Add</button>
                                </form>
                            </div>
                        </div>
                    </div>
        <% 
                }
            } else {
        %>
                <p class="no-items-msg">No menu items match your search criteria or are currently available.</p>
        <% 
            }
        %>
    </div>

</div>

<footer>
    <div class="footer-container">
        <div class="footer-col">
            <h4 style="color: var(--brand-orange); font-size: 20px; font-weight: 700;">FoodieHub</h4>
            <p style="font-size: 13px; line-height: 1.6;">Delivering delicious happiness right to your doorstep, every single day.</p>
        </div>
        <div class="footer-col">
            <h4>Company</h4>
            <ul>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Careers</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Legal</h4>
            <ul>
                <li><a href="#">Terms & Conditions</a></li>
                <li><a href="#">Privacy Policy</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 FoodieHub Technologies Pvt. Ltd. All rights reserved.</p>
    </div>
</footer>

</body>
</html>