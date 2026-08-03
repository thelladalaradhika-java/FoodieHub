<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String defaultAvatarUrl = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=250";
    String adminName = (session.getAttribute("adminName") != null) ? (String) session.getAttribute("adminName") : "System Admin";
    String adminEmail = (session.getAttribute("adminEmail") != null) ? (String) session.getAttribute("adminEmail") : "admin@foodiehub.com";
    String adminPhone = (session.getAttribute("adminPhone") != null) ? (String) session.getAttribute("adminPhone") : "+91 9876543210";
    String adminAvatar = (session.getAttribute("adminAvatar") != null) ? (String) session.getAttribute("adminAvatar") : defaultAvatarUrl;

    boolean isCustomAvatar = !defaultAvatarUrl.equals(adminAvatar);

    String activeTab = (request.getAttribute("activeTab") != null) ? (String) request.getAttribute("activeTab") : "restaurants";
    String currentFilterId = (request.getAttribute("filterRestaurantId") != null) ? (String) request.getAttribute("filterRestaurantId") : "all";

    List<Map<String, Object>> globalRestaurantsList = (List<Map<String, Object>>) request.getAttribute("restaurants");
    List<Map<String, Object>> globalMenuList = (List<Map<String, Object>>) request.getAttribute("menus");
    List<Map<String, Object>> globalOrdersList = (List<Map<String, Object>>) request.getAttribute("orders");
    List<Map<String, Object>> globalUsersList = (List<Map<String, Object>>) request.getAttribute("users");

    if (globalRestaurantsList == null) globalRestaurantsList = new ArrayList<>();
    if (globalMenuList == null) globalMenuList = new ArrayList<>();
    if (globalOrdersList == null) globalOrdersList = new ArrayList<>();
    if (globalUsersList == null) globalUsersList = new ArrayList<>();

    Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
    double totalEarnedRevenue = (totalRevenueObj != null) ? totalRevenueObj : 0.0;

    Integer totalOrdersObj = (Integer) request.getAttribute("totalOrders");
    int totalOrdersCount = (totalOrdersObj != null) ? totalOrdersObj : 0;

    Integer totalRestaurantsObj = (Integer) request.getAttribute("totalRestaurants");
    int totalRestaurantsCount = (totalRestaurantsObj != null) ? totalRestaurantsObj : 0;

    Integer totalUsersObj = (Integer) request.getAttribute("totalUsers");
    int totalUsersCount = (totalUsersObj != null) ? totalUsersObj : 0;

    String toastMsg = (session.getAttribute("toastMsg") != null) ? (String) session.getAttribute("toastMsg") : (String) request.getAttribute("toastMsg");
    String toastType = (session.getAttribute("toastType") != null) ? (String) session.getAttribute("toastType") : (String) request.getAttribute("toastType");
    if (toastType == null) toastType = "success";

    session.removeAttribute("toastMsg");
    session.removeAttribute("toastType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FoodieHub Admin Portal</title>
         
         <link rel="icon" type="image/jpeg"
      href="<%= request.getContextPath() %>/images/img/Foodiefavicon.jpg">
         
         
         
         
         
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: linear-gradient(135deg, #a1a8b8 0%, #cbd5e1 40%, #94a3b8 100%); min-height: 100vh; color: #0f172a; display: flex; flex-direction: column; }
        
        .top-navbar { width: 100%; height: 70px; background: #1a1c1e; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; position: sticky; top: 0; z-index: 100; box-shadow: 0 4px 18px rgba(0,0,0,0.25); }
        .navbar-left { display: flex; align-items: center; gap: 18px; }
        
        #sidebar-toggle { display: none; }
        .menu-toggle-btn { background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); color: #fff; font-size: 18px; padding: 8px 14px; border-radius: 10px; cursor: pointer; }
        .menu-toggle-btn:hover { background: #f95f07; border-color: #f95f07; }
        #sidebar-toggle:checked ~ .layout-body .sidebar { display: none; }

        .navbar-brand { font-size: 24px; font-weight: 800; display: flex; align-items: center; gap: 10px; }
        .brand-orange { color: #f95f07; }
        .brand-white { color: #ffffff; }

        .navbar-profile-btn { background: #f95f07; padding: 6px 20px 6px 8px; border-radius: 30px; color: #fff; border: none; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 12px; cursor: pointer; }

        .layout-body { display: flex; flex: 1; }
        .sidebar { width: 250px; background: rgba(255, 255, 255, 0.15); backdrop-filter: blur(25px); border-right: 1px solid rgba(255, 255, 255, 0.4); padding: 30px 20px; display: flex; flex-direction: column; justify-content: space-between; }
        .nav-links { list-style: none; display: flex; flex-direction: column; gap: 14px; }
        .nav-links a { text-decoration: none; color: #0f172a; padding: 12px 20px; border-radius: 25px; font-weight: 600; display: flex; align-items: center; gap: 14px; }
        .nav-links a:hover, .nav-links a.active { background: #f95f07; color: #fff; }

        .main-content { flex: 1; padding: 35px 40px; overflow-y: auto; }
        
        .metrics-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 22px; margin-bottom: 35px; }
        .metric-card { background: rgba(255, 255, 255, 0.18); backdrop-filter: blur(25px); border: 1px solid rgba(255, 255, 255, 0.45); border-radius: 20px; padding: 22px 24px; display: flex; align-items: center; justify-content: space-between; }
        .metric-info h4 { font-size: 13px; color: #475569; text-transform: uppercase; font-weight: 700; }
        .metric-info h2 { font-size: 26px; font-weight: 800; color: #0f172a; margin-top: 4px; }
        .metric-icon { width: 52px; height: 52px; border-radius: 16px; background: rgba(249, 95, 7, 0.15); color: #f95f07; display: flex; align-items: center; justify-content: center; font-size: 22px; }

        .glass-panel { background: rgba(255, 255, 255, 0.22); backdrop-filter: blur(25px); border: 1px solid rgba(255, 255, 255, 0.45); border-radius: 20px; padding: 28px; margin-bottom: 30px; }
        .panel-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 22px; gap: 15px; flex-wrap: wrap; }

        .btn-action { padding: 10px 20px; border-radius: 12px; font-weight: 600; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; font-size: 14px; }
        .btn-green { background: #14532d; color: #fff; }
        .btn-red { background: #991b1b; color: #fff; }
        .btn-cancel { background: #e2e8f0; color: #475569; padding: 10px 20px; border-radius: 12px; font-weight: 600; text-decoration: none; display: inline-block; }

        .cards-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 22px; }
        .item-card { background: rgba(255, 255, 255, 0.3); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 16px; overflow: hidden; display: flex; flex-direction: column; }
        .item-card-img { width: 100%; height: 160px; object-fit: cover; }
        .item-card-body { padding: 16px; display: flex; flex-direction: column; flex: 1; }
        .item-card-title { font-size: 16px; font-weight: 700; }
        .item-card-desc { font-size: 13px; color: #475569; margin-bottom: 12px; flex: 1; }
        .item-card-actions { display: flex; gap: 10px; margin-top: 10px; }

        .rating-badge { background: #fef3c7; color: #b45309; padding: 4px 10px; border-radius: 20px; font-weight: 700; font-size: 12px; display: inline-flex; align-items: center; gap: 5px; border: 1px solid #fde68a; margin-top: 6px; }

        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { padding: 14px 18px; background: rgba(0,0,0,0.05); font-size: 13px; text-transform: uppercase; }
        td { padding: 14px 18px; border-bottom: 1px solid rgba(255, 255, 255, 0.3); font-size: 14px; }

        /* PURE HTML <details> MODALS */
        details.modal-details { position: relative; display: inline-block; }
        details.modal-details > summary { list-style: none; cursor: pointer; }
        details.modal-details > summary::-webkit-details-marker { display: none; }
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px); z-index: 1000; display: flex; align-items: center; justify-content: center; }
        .modal-box { background: #ffffff; border-radius: 20px; width: 90%; max-width: 500px; padding: 30px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); color: #0f172a; text-align: left; }
        .modal-header { font-size: 20px; font-weight: 700; margin-bottom: 15px; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 12px; margin-top: 18px; }
        
        .form-group { margin-bottom: 15px; text-align: left; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px; }
        .form-control { width: 100%; padding: 10px 14px; border-radius: 10px; border: 1px solid #cbd5e1; font-size: 14px; }

        .toast { position: fixed; bottom: 20px; right: 20px; padding: 14px 24px; border-radius: 12px; color: #fff; font-weight: 600; z-index: 1001; animation: toastFade 3.5s forwards; }
        .toast-success { background: #166534; }
        .toast-danger { background: #b91c1c; }
        @keyframes toastFade { 0% { opacity: 0; } 15% { opacity: 1; } 85% { opacity: 1; } 100% { opacity: 0; visibility: hidden; } }
    </style>
</head>
<body>

    <input type="checkbox" id="sidebar-toggle">

    <div class="top-navbar">
        <div class="navbar-left">
            <label for="sidebar-toggle" class="menu-toggle-btn"><i class="fa-solid fa-bars"></i></label>
            <div class="navbar-brand">
                <span class="brand-orange"><i class="fa-solid fa-utensils"></i> FoodieHub</span>
                <span class="brand-white">Admin Portal</span>
            </div>
        </div>
        <div class="navbar-right">
            <!-- ADMIN PROFILE SECTION WITH UPLOAD AND REMOVE OPTIONS -->
            <details class="modal-details">
                <summary class="navbar-profile-btn">
                    <img src="<%= adminAvatar %>" alt="Admin Avatar" style="width:38px; height:38px; border-radius:50%; object-fit:cover; border:2px solid #fff;">
                    <span><%= adminName %></span>
                </summary>
                <div class="modal-overlay">
                    <div class="modal-box">
                        <div class="modal-header"><i class="fa-solid fa-user-gear"></i> Update Admin Profile</div>
                        
                        <div style="text-align: center; margin-bottom: 20px;">
                            <img src="<%= adminAvatar %>" alt="Admin Preview" style="width:90px; height:90px; border-radius:50%; object-fit:cover; border:3px solid #f95f07;">
                            <p style="font-size: 12px; color: #64748b; margin-top: 6px;">Current Avatar</p>
                        </div>

                        <form method="post" action="AdminDashboardServlet" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="updateAdminProfile">
                            <input type="hidden" name="redirectTab" value="<%= activeTab %>">
                            <input type="hidden" name="filterRestaurantId" value="<%= currentFilterId %>">
                            
                            <div class="form-group">
                                <label>Admin Name</label>
                                <input type="text" name="adminName" value="<%= adminName %>" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="adminEmail" value="<%= adminEmail %>" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Phone Number</label>
                                <input type="text" name="adminPhone" value="<%= adminPhone %>" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Upload New Profile Image</label>
                                <input type="file" name="adminImage" class="form-control" accept="image/*">
                            </div>
                            
                            <div class="modal-footer">
                                <a href="AdminDashboardServlet?tab=<%= activeTab %>&filterRestaurantId=<%= currentFilterId %>" class="btn-cancel">Close</a>
                                <button type="submit" class="btn-action btn-green">Update Details</button>
                            </div>
                        </form>

                        <% if (isCustomAvatar) { %>
                            <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e2e8f0;">
                            <form method="post" action="AdminDashboardServlet">
                                <input type="hidden" name="action" value="removeAdminProfileImage">
                                <input type="hidden" name="redirectTab" value="<%= activeTab %>">
                                <input type="hidden" name="filterRestaurantId" value="<%= currentFilterId %>">
                                <button type="submit" class="btn-action btn-red" style="width: 100%; justify-content: center;">
                                    <i class="fa-solid fa-trash-can"></i> Remove Profile Picture
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </details>
        </div>
    </div>

    <div class="layout-body">
        <div class="sidebar">
            <ul class="nav-links">
                <li><a href="AdminDashboardServlet?tab=restaurants" class="<%= "restaurants".equals(activeTab) ? "active" : "" %>"><i class="fa-solid fa-store"></i> Restaurants</a></li>
                <li><a href="AdminDashboardServlet?tab=menus" class="<%= "menus".equals(activeTab) ? "active" : "" %>"><i class="fa-solid fa-bowl-food"></i> Menu Items</a></li>
                <li><a href="AdminDashboardServlet?tab=orders" class="<%= "orders".equals(activeTab) ? "active" : "" %>"><i class="fa-solid fa-receipt"></i> Orders</a></li>
                <li><a href="AdminDashboardServlet?tab=users" class="<%= "users".equals(activeTab) ? "active" : "" %>"><i class="fa-solid fa-users"></i> Users</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-info"><h4>Total Revenue</h4><h2>₹<%= String.format("%.2f", totalEarnedRevenue) %></h2></div>
                    <div class="metric-icon"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                </div>
                <div class="metric-card">
                    <div class="metric-info"><h4>Total Orders</h4><h2><%= totalOrdersCount %></h2></div>
                    <div class="metric-icon"><i class="fa-solid fa-cart-shopping"></i></div>
                </div>
                <div class="metric-card">
                    <div class="metric-info"><h4>Active Restaurants</h4><h2><%= totalRestaurantsCount %></h2></div>
                    <div class="metric-icon"><i class="fa-solid fa-shop"></i></div>
                </div>
                <div class="metric-card">
                    <div class="metric-info"><h4>Registered Users</h4><h2><%= totalUsersCount %></h2></div>
                    <div class="metric-icon"><i class="fa-solid fa-user-group"></i></div>
                </div>
            </div>

            <% if ("restaurants".equals(activeTab)) { %>
            <div class="glass-panel">
                <div class="panel-header">
                    <h3>Restaurant Management</h3>
                    <details class="modal-details">
                        <summary class="btn-action btn-green"><i class="fa-solid fa-plus"></i> Add Restaurant</summary>
                        <div class="modal-overlay">
                            <div class="modal-box">
                                <div class="modal-header">Add Restaurant</div>
                                <form method="post" action="AdminDashboardServlet" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="addRestaurant">
                                    <input type="hidden" name="redirectTab" value="restaurants">
                                    <div class="form-group"><label>Restaurant Name</label><input type="text" name="name" class="form-control" required></div>
                                    <div class="form-group"><label>Cuisine Type</label><input type="text" name="cuisineType" class="form-control" required></div>
                                    <div class="form-group"><label>Rating (1.0 to 5.0)</label><input type="number" step="0.1" name="rating" value="4.5" class="form-control" required></div>
                                    <div class="form-group"><label>Delivery Time (mins)</label><input type="number" name="deliveryTime" value="30" class="form-control" required></div>
                                    <div class="form-group"><label>Address</label><input type="text" name="address" class="form-control" required></div>
                                    <div class="form-group"><label>Upload Image</label><input type="file" name="restaurantImage" class="form-control" accept="image/*"></div>
                                    <div class="modal-footer">
                                        <a href="AdminDashboardServlet?tab=restaurants" class="btn-cancel">Cancel</a>
                                        <button type="submit" class="btn-action btn-green">Save Restaurant</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </details>
                </div>

                <div class="cards-grid">
                    <% for (Map<String, Object> r : globalRestaurantsList) { %>
                    <div class="item-card">
                        <img src="<%= r.get("imagePath") %>" class="item-card-img" alt="Restaurant">
                        <div class="item-card-body">
                            <div class="item-card-title"><%= r.get("name") %></div>
                            <div class="item-card-desc">
                                <%= r.get("cuisineType") %> • <%= r.get("deliveryTime") %> mins<br>
                                <span class="rating-badge">
                                    <i class="fa-solid fa-star"></i> <%= r.get("rating") %> / 5.0
                                </span>
                            </div>
                            <div class="item-card-actions">
                                <details class="modal-details">
                                    <summary class="btn-action btn-green">Edit</summary>
                                    <div class="modal-overlay">
                                        <div class="modal-box">
                                            <div class="modal-header">Edit Restaurant</div>
                                            <form method="post" action="AdminDashboardServlet" enctype="multipart/form-data">
                                                <input type="hidden" name="action" value="updateRestaurant">
                                                <input type="hidden" name="restaurantId" value="<%= r.get("id") %>">
                                                <input type="hidden" name="redirectTab" value="restaurants">
                                                <div class="form-group"><label>Restaurant Name</label><input type="text" name="name" value="<%= r.get("name") %>" class="form-control" required></div>
                                                <div class="form-group"><label>Cuisine Type</label><input type="text" name="cuisineType" value="<%= r.get("cuisineType") %>" class="form-control" required></div>
                                                <div class="form-group"><label>Rating (1.0 to 5.0)</label><input type="number" step="0.1" name="rating" value="<%= r.get("rating") %>" class="form-control" required></div>
                                                <div class="form-group"><label>Update Image</label><input type="file" name="restaurantImage" class="form-control" accept="image/*"></div>
                                                <div class="modal-footer">
                                                    <a href="AdminDashboardServlet?tab=restaurants" class="btn-cancel">Cancel</a>
                                                    <button type="submit" class="btn-action btn-green">Update</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </details>
                                <details class="modal-details">
                                    <summary class="btn-action btn-red">Delete</summary>
                                    <div class="modal-overlay">
                                        <div class="modal-box">
                                            <div class="modal-header">Confirm Deletion</div>
                                            <p style="margin-bottom: 20px;">Delete restaurant "<%= r.get("name") %>"?</p>
                                            <form method="post" action="AdminDashboardServlet">
                                                <input type="hidden" name="action" value="deleteRestaurant">
                                                <input type="hidden" name="restaurantId" value="<%= r.get("id") %>">
                                                <input type="hidden" name="redirectTab" value="restaurants">
                                                <div class="modal-footer">
                                                    <a href="AdminDashboardServlet?tab=restaurants" class="btn-cancel">Cancel</a>
                                                    <button type="submit" class="btn-action btn-red">Delete</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </details>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <% if ("menus".equals(activeTab)) { %>
            <div class="glass-panel">
                <div class="panel-header">
                    <h3>Menu Management</h3>

                    <div style="display:flex; gap:12px; align-items:center;">
                        <form method="get" action="AdminDashboardServlet" style="display:flex; gap:8px; align-items:center;">
                            <input type="hidden" name="tab" value="menus">
                            <label style="font-weight:600; font-size:13px;">Filter:</label>
                            <select name="filterRestaurantId" class="form-control" style="width:auto;">
                                <option value="all" <%= "all".equals(currentFilterId) ? "selected" : "" %>>All Restaurants</option>
                                <% for (Map<String, Object> r : globalRestaurantsList) { 
                                    String rIdStr = String.valueOf(r.get("id"));
                                %>
                                    <option value="<%= rIdStr %>" <%= rIdStr.equals(currentFilterId) ? "selected" : "" %>><%= r.get("name") %></option>
                                <% } %>
                            </select>
                            <button type="submit" class="btn-action btn-green" style="padding: 8px 14px;">Apply</button>
                        </form>

                        <details class="modal-details">
                            <summary class="btn-action btn-green"><i class="fa-solid fa-plus"></i> Add Menu Item</summary>
                            <div class="modal-overlay">
                                <div class="modal-box">
                                    <div class="modal-header">Add Menu Item</div>
                                    <form method="post" action="AdminDashboardServlet" enctype="multipart/form-data">
                                        <input type="hidden" name="action" value="addMenu">
                                        <input type="hidden" name="redirectTab" value="menus">
                                        <input type="hidden" name="filterRestaurantId" value="<%= currentFilterId %>">

                                        <% if (!"all".equals(currentFilterId)) { %>
                                            <input type="hidden" name="restaurantId" value="<%= currentFilterId %>">
                                        <% } else { %>
                                            <div class="form-group">
                                                <label>Target Restaurant</label>
                                                <select name="restaurantId" class="form-control" required>
                                                    <% for (Map<String, Object> r : globalRestaurantsList) { %>
                                                        <option value="<%= r.get("id") %>"><%= r.get("name") %></option>
                                                    <% } %>
                                                </select>
                                            </div>
                                        <% } %>

                                        <div class="form-group"><label>Item Name</label><input type="text" name="itemName" class="form-control" required></div>
                                        <div class="form-group"><label>Price (₹)</label><input type="text" name="price" class="form-control" required></div>
                                        <div class="form-group"><label>Upload Menu Image</label><input type="file" name="menuImage" class="form-control" accept="image/*"></div>
                                        
                                        <div class="modal-footer">
                                            <a href="AdminDashboardServlet?tab=menus&filterRestaurantId=<%= currentFilterId %>" class="btn-cancel">Cancel</a>
                                            <button type="submit" class="btn-action btn-green">Save Item</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </details>
                    </div>
                </div>

                <div class="cards-grid">
                    <% for (Map<String, Object> m : globalMenuList) { %>
                    <div class="item-card">
                        <img src="<%= m.get("imagePath") %>" class="item-card-img" alt="Menu Item">
                        <div class="item-card-body">
                            <div class="item-card-title"><%= m.get("itemName") %></div>
                            <div class="item-card-desc"><%= m.get("restaurantName") %> • ₹<%= m.get("price") %></div>
                            <div class="item-card-actions">
                                <details class="modal-details">
                                    <summary class="btn-action btn-green">Edit</summary>
                                    <div class="modal-overlay">
                                        <div class="modal-box">
                                            <div class="modal-header">Update Menu Item</div>
                                            <form method="post" action="AdminDashboardServlet" enctype="multipart/form-data">
                                                <input type="hidden" name="action" value="updateMenu">
                                                <input type="hidden" name="menuId" value="<%= m.get("id") %>">
                                                <input type="hidden" name="redirectTab" value="menus">
                                                <input type="hidden" name="filterRestaurantId" value="<%= currentFilterId %>">

                                                <div class="form-group">
                                                    <label>Item Name</label>
                                                    <input type="text" name="itemName" value="<%= m.get("itemName") %>" class="form-control" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Price (₹)</label>
                                                    <input type="text" name="price" value="<%= m.get("price") %>" class="form-control" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Upload New Image</label>
                                                    <input type="file" name="menuImage" class="form-control" accept="image/*">
                                                </div>

                                                <div class="modal-footer">
                                                    <a href="AdminDashboardServlet?tab=menus&filterRestaurantId=<%= currentFilterId %>" class="btn-cancel">Cancel</a>
                                                    <button type="submit" class="btn-action btn-green">Update Item</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </details>

                                <details class="modal-details">
                                    <summary class="btn-action btn-red">Delete</summary>
                                    <div class="modal-overlay">
                                        <div class="modal-box">
                                            <div class="modal-header">Confirm Deletion</div>
                                            <p style="margin-bottom:20px;">Delete "<%= m.get("itemName") %>"?</p>
                                            <form method="post" action="AdminDashboardServlet">
                                                <input type="hidden" name="action" value="deleteMenu">
                                                <input type="hidden" name="menuId" value="<%= m.get("id") %>">
                                                <input type="hidden" name="redirectTab" value="menus">
                                                <input type="hidden" name="filterRestaurantId" value="<%= currentFilterId %>">
                                                <div class="modal-footer">
                                                    <a href="AdminDashboardServlet?tab=menus&filterRestaurantId=<%= currentFilterId %>" class="btn-cancel">Cancel</a>
                                                    <button type="submit" class="btn-action btn-red">Delete</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </details>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <% if ("orders".equals(activeTab)) { %>
            <div class="glass-panel">
                <h3>Order History</h3>
                <table style="margin-top: 15px;">
                    <thead>
                        <tr><th>ID</th><th>Customer</th><th>Restaurant</th><th>Total</th><th>Status</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> o : globalOrdersList) { %>
                        <tr>
                            <td>#<%= o.get("id") %></td>
                            <td><%= o.get("customer") %></td>
                            <td><%= o.get("restaurant") %></td>
                            <td>₹<%= o.get("amount") %></td>
                            <td><strong><%= o.get("status") %></strong></td>
                            <td>
                                <form method="post" action="AdminDashboardServlet" style="display:flex; gap:8px;">
                                    <input type="hidden" name="action" value="updateOrderStatus">
                                    <input type="hidden" name="orderId" value="<%= o.get("id") %>">
                                    <input type="hidden" name="redirectTab" value="orders">
                                    <select name="status" class="form-control" style="width:auto;">
                                        <option value="PENDING" <%= "PENDING".equals(o.get("status")) ? "selected" : "" %>>PENDING</option>
                                        <option value="DELIVERED" <%= "DELIVERED".equals(o.get("status")) ? "selected" : "" %>>DELIVERED</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equals(o.get("status")) ? "selected" : "" %>>CANCELLED</option>
                                    </select>
                                    <button type="submit" class="btn-action btn-green" style="padding: 6px 12px;">Save</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>

            <% if ("users".equals(activeTab)) { %>
            <div class="glass-panel">
                <h3>Registered Users</h3>
                <table style="margin-top: 15px;">
                    <thead>
                        <tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> u : globalUsersList) { %>
                        <tr>
                            <td>#<%= u.get("id") %></td>
                            <td><%= u.get("username") %></td>
                            <td><%= u.get("email") %></td>
                            <td><span style="background: rgba(249, 95, 7, 0.15); color: #f95f07; padding: 4px 10px; border-radius: 12px; font-weight: 600; font-size: 12px;"><%= u.get("role") %></span></td>
                            <td>
                                <details class="modal-details">
                                    <summary class="btn-action btn-red" style="padding: 6px 12px; font-size: 12px;">Remove</summary>
                                    <div class="modal-overlay">
                                        <div class="modal-box">
                                            <div class="modal-header">Remove User</div>
                                            <p style="margin-bottom: 20px;">Are you sure you want to remove user "<strong><%= u.get("username") %></strong>"?</p>
                                            <form method="post" action="AdminDashboardServlet">
                                                <input type="hidden" name="action" value="deleteUser">
                                                <input type="hidden" name="id" value="<%= u.get("id") %>">
                                                <input type="hidden" name="redirectTab" value="users">
                                                <div class="modal-footer">
                                                    <a href="AdminDashboardServlet?tab=users" class="btn-cancel">Cancel</a>
                                                    <button type="submit" class="btn-action btn-red">Confirm Delete</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </details>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>

        </div>
    </div>

    <!-- LOGOUT FLOATING BUTTON -->
    <div style="position: fixed; bottom: 20px; left: 20px; width: 210px; z-index: 101;">
        <a href="<%= request.getContextPath() %>/logout" class="btn-action btn-red" style="width: 100%; justify-content: center; border-radius: 25px; box-shadow: 0 4px 12px rgba(153, 27, 27, 0.3);">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>

    <% if (toastMsg != null && !toastMsg.trim().isEmpty()) { %>
        <div class="toast toast-<%= toastType %>">
            <i class="fa-solid <%= "danger".equals(toastType) ? "fa-circle-xmark" : "fa-circle-check" %>"></i>
            <%= toastMsg %>
        </div>
    <% } %>

</body>
</html>