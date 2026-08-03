# 🍕 FoodieHub - Full Stack Java Web Application

FoodieHub is an enterprise-grade Online Food Ordering System developed using **Java EE (Servlets)**, **JSP**, **JDBC**, and **MySQL**. Designed around the **Model-View-Controller (MVC)** and **Data Access Object (DAO)** architectural patterns, it provides robust dynamic content rendering, session-based authentication, and dynamic role-based features for both Customers and Admins.

---

## 🌟 Architecture & Key Features

### 🏗️ Design Patterns
* **MVC Pattern:** Controllers handle incoming HTTP requests (`Servlets`), Data Models store business entities (`POJOs`), and Views render UI (`JSPs`).
* **DAO Pattern (Interface & Implementation):** Decoupled persistence logic through DAO interfaces (`UserDAO`, `MenuDAO`, `OrderDAO`, `RestaurantDAO`) and their concrete implementations (`*Impl.java`).
* **Session Lifecycle:** Managed HTTP Sessions for user tracking, active role validation, and dynamic UI state rendering across request cycles.

### 👤 Customer Operations
* **Authentication:** Secure user login and account registration (`LoginServlet`, `RegisterServlet`).
* **Menu Browsing:** Interactive dynamic restaurant menu listing (`HomeServlet`, `MenuServlet`).
* **Shopping Cart:** Real-time cart calculations and session updates (`CartServlet`).
* **Checkout & Tracking:** Order creation and customer order history lookup (`CheckoutServlet`, `OrderConfirmationServlet`, `OrderHistoryServlet`).
* **Profile View:** Dynamic user profile inspection (`ProfileServlet`).

### 🛡️ Admin Operations
* **Admin Dashboard:** Central operational interface (`AdminDashboardServlet`).
* **Menu Management:** Complete CRUD workflows for dishes and pricing (`ManageMenuServlet`).
* **Order Status Updating:** Real-time status modification for active customer orders (`UpdateOrderStatusServlet`).

---

## 🛠️ Tech Stack & Dependencies

* **Language & Runtime:** Java SE 21, Dynamic Web Module 5.0 (Jakarta EE)
* **Backend:** Java Servlets, JavaServer Pages (JSP), JSTL, JDBC
* **Database:** MySQL
* **Frontend:** HTML5, CSS3 (`admin.css`, `cart.css`, `checkout.css`, `confirmation.css`, `home.css`, `menu.css`)
* **Build & Dependency Management:** Maven
* **Server Target:** Apache Tomcat 10.1+

---

## 📁 Directory Structure

```text
FoodieHub/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── foodiehub/
│       │           ├── controller/           # Servlets (Controllers)
│       │           │   ├── AdminDashboardServlet.java
│       │           │   ├── CartServlet.java
│       │           │   ├── CheckoutServlet.java
│       │           │   ├── HomeServlet.java
│       │           │   ├── LoginServlet.java
│       │           │   ├── LogoutServlet.java
│       │           │   ├── ManageMenuServlet.java
│       │           │   ├── MenuServlet.java
│       │           │   ├── OrderConfirmationServlet.java
│       │           │   ├── OrderHistoryServlet.java
│       │           │   ├── ProfileServlet.java
│       │           │   ├── RegisterServlet.java
│       │           │   └── UpdateOrderStatusServlet.java
│       │           ├── dao/                  # DAO Interfaces
│       │           │   ├── MenuDAO.java
│       │           │   ├── OrderDAO.java
│       │           │   ├── OrderItemDAO.java
│       │           │   ├── RestaurantDAO.java
│       │           │   └── UserDAO.java
│       │           ├── dao/impl/             # DAO Implementations
│       │           │   ├── MenuDAOImpl.java
│       │           │   ├── OrderDAOImpl.java
│       │           │   ├── OrderItemDAOImpl.java
│       │           │   ├── RestaurantDAOImpl.java
│       │           │   └── UserDAOImpl.java
│       │           ├── model/                # Data Transfer Objects / POJOs
│       │           │   ├── Menu.java
│       │           │   ├── Order.java
│       │           │   ├── OrderItem.java
│       │           │   ├── Restaurant.java
│       │           │   └── User.java
│       │           └── util/                 # Utilities
│       │               ├── DBConnection.java
│       │               ├── DBTestRunner.java
│       │               └── test.java
│       └── webapp/
│           ├── assets/                       # Static Assets
│           │   ├── css/                      # Custom CSS Stylesheets
│           │   └── images/img/               # Media & Favicons
│           └── WEB-INF/
│               ├── views/                    # JSP View Pages
│               │   ├── partials/             # Reusable Components (navbar, footer)
│               │   ├── adminDashboard.jsp
│               │   ├── cart.jsp
│               │   ├── checkout.jsp
│               │   ├── home.jsp
│               │   ├── login.jsp
│               │   ├── menu.jsp
│               │   ├── orderConfirmation.jsp
│               │   ├── order-history.jsp
│               │   ├── profile.jsp
│               │   └── register.jsp
│               └── web.xml                   # Deployment Descriptor
├── pom.xml                                   # Maven Dependencies
└── README.md                                 # Project Documentation