<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .custom-navbar {
        background-color: #1a1d20;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 70px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        z-index: 1000;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
    }

    .brand-logo {
        color: #ff6600;
        font-size: 24px;
        font-weight: 700;
        text-decoration: none;
    }

    .brand-logo span {
        color: #ffffff;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 25px;
    }

    .nav-link {
        color: #ffffff;
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: color 0.2s ease;
    }

    .nav-link i {
        color: #ff6600;
    }

    .nav-link:hover {
        color: #ff6600;
    }

    .profile-container {
        position: relative;
        padding-bottom: 10px; /* Bridge gap for smooth hover transition */
        margin-bottom: -10px;
    }

    .profile-btn {
        background-color: #ff6600;
        color: #ffffff;
        border: none;
        padding: 8px 18px;
        border-radius: 25px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        font-family: 'Poppins', sans-serif;
    }

    .profile-dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        top: 100%;
        background-color: #ffffff;
        min-width: 160px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        padding: 8px 0;
        list-style: none;
        margin: 0;
        z-index: 1001;
    }

    /* PURE CSS HOVER: Replaces JavaScript toggle logic entirely */
    .profile-container:hover .profile-dropdown-menu {
        display: block;
    }

    .dropdown-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 16px;
        color: #1a1d20;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
    }

    .dropdown-item:hover {
        background-color: #f8fafc;
    }

    .dropdown-item.danger {
        color: #dc3545;
    }

    .dropdown-divider {
        height: 1px;
        background-color: #e2e8f0;
        margin: 6px 0;
    }
</style>

<nav class="custom-navbar">
    <!-- Brand Logo -->
    <a href="home" class="brand-logo">Foodie<span>Hub</span></a>

    <!-- Nav Links -->
    <div class="nav-links">
        <a href="home" class="nav-link">
            <i class="fa-solid fa-house"></i> Home
        </a>
        <a href="cart?action=view" class="nav-link">
            <i class="fa-solid fa-basket-shopping"></i> Cart
        </a>
        <a href="order-history" class="nav-link">
            <i class="fa-solid fa-clock-rotate-left"></i> My Orders
        </a>

        <!-- Profile Dropdown (Hover Enabled) -->
        <div class="profile-container">
            <button class="profile-btn" type="button">
                <i class="fa-solid fa-user-circle"></i> 
                <% 
                    String displayName = "Customer";
                    if (session != null && session.getAttribute("username") != null) {
                        displayName = (String) session.getAttribute("username");
                    }
                %>
                <%= displayName %> ▾
            </button>
            
            <ul class="profile-dropdown-menu">
                <li>
                    <a href="profile" class="dropdown-item">
                        <i class="fa-solid fa-id-card" style="color: #ff6600;"></i> View Profile
                    </a>
                </li>
                <div class="dropdown-divider"></div>
                <li>
                    <a href="logout" class="dropdown-item danger">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>