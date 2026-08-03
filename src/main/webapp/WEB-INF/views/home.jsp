<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Initialize or fall back for category selection using Expression Language -->
<c:set var="activeCategory" value="${param.category != null ? param.category : 'all'}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FoodieHub | Home</title>
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
        
        .main-container { 
            width: 100%; 
            padding: 30px 40px; 
            flex: 1; 
        }
        
        /* ZOMATO-STYLE BRIGHT & CLEAR VIDEO BANNER */
        .promo-banner { 
            position: relative;
            width: 100%;
            height: 520px; 
            border-radius: 24px; 
            margin-bottom: 40px; 
            overflow: hidden;
            border: 1px solid var(--glass-border);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            background: #000; 
        }

        .promo-banner-video {
            position: absolute;
            top: 50%;
            left: 50%;
            min-width: 100%;
            min-height: 100%;
            width: auto;
            height: auto;
            transform: translate(-50%, -50%);
            object-fit: cover;
            z-index: 1;
            filter: contrast(105%) brightness(100%);
            pointer-events: none;
        }

        .promo-banner-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to bottom, rgba(0, 0, 0, 0.35) 0%, rgba(0, 0, 0, 0.25) 100%);
            z-index: 2;
        }

        .promo-banner-content {
            position: relative;
            z-index: 3;
            text-align: center;
            color: white;
            padding: 0 20px;
        }

        .promo-banner-content .brand-title {
            font-size: 58px;
            font-weight: 800;
            color: var(--brand-orange);
            letter-spacing: -1.5px;
            margin-bottom: 8px;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.9), 0 2px 4px rgba(0, 0, 0, 0.8);
        }

        .promo-banner-content h2 { 
            font-size: 38px; 
            font-weight: 700; 
            margin-bottom: 14px; 
            text-shadow: 0 4px 16px rgba(0, 0, 0, 0.9), 0 2px 4px rgba(0, 0, 0, 0.8);
        }

        .promo-banner-content p { 
            font-size: 18px; 
            color: #ffffff;
            margin-bottom: 30px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.5;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.9);
        }

        .btn-explore-now {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            background: var(--brand-orange);
            color: white;
            padding: 15px 36px;
            font-size: 17px;
            font-weight: 700;
            border-radius: 40px;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(255, 102, 0, 0.5);
        }

        .btn-explore-now:hover {
            background: #e55c00;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 102, 0, 0.7);
        }
        
        /* WHAT'S ON YOUR MIND SECTION */
        .mind-section { 
            margin-bottom: 40px; 
            width: 100%; 
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--glass-shadow);
        }
        .section-title { font-size: 22px; font-weight: 700; margin-bottom: 20px; color: var(--text-dark); }
        
        /* SLIDER CONTAINER */
        .circle-flex-grid { 
            display: flex; 
            gap: 30px; 
            overflow-x: auto; 
            padding-bottom: 15px; 
            width: 100%;
            scrollbar-width: auto;
            scroll-behavior: smooth;
        }

        .circle-flex-grid::-webkit-scrollbar {
            height: 8px;
        }
        .circle-flex-grid::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
            border-radius: 10px;
        }
        .circle-flex-grid::-webkit-scrollbar-thumb {
            background: var(--brand-orange);
            border-radius: 10px;
        }
        
        .food-circle-card { 
            text-align: center; 
            cursor: pointer; 
            min-width: 110px; 
            text-decoration: none; 
            color: inherit; 
            perspective: 800px;
            padding-bottom: 5px;
        }

        /* 3D PLATE LOOK */
        .plate-3d-wrapper {
            position: relative;
            width: 100px;
            height: 100px;
            margin: 0 auto 12px auto;
        }

        .plate-base-tray {
            position: absolute;
            bottom: -4px;
            left: 5%;
            width: 90%;
            height: 20px;
            background: rgba(0, 0, 0, 0.15);
            border-radius: 50%;
            filter: blur(5px);
            transition: all 0.3s ease;
        }

        .food-circle-card img { 
            width: 100px; 
            height: 100px; 
            object-fit: cover; 
            border-radius: 50%;
            display: block;
            position: relative;
            z-index: 2;
            border: 3px solid rgba(255, 255, 255, 0.9);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2), inset 0 0 10px rgba(0,0,0,0.15);
            transform: rotateX(15deg) translateZ(10px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            filter: drop-shadow(0px 8px 12px rgba(0,0,0,0.25));
        }
        
        .food-circle-card:hover img {
            transform: rotateX(0deg) translateY(-8px) scale(1.05);
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.25);
        }

        .food-circle-card:hover .plate-base-tray {
            transform: scale(0.85);
            opacity: 0.6;
        }
        
        .food-circle-card.active img {
            border-color: var(--brand-orange);
            transform: rotateX(0deg) translateY(-5px);
        }

        .food-circle-card span { 
            font-size: 14px; 
            font-weight: 600; 
            color: var(--text-dark); 
            display: block; 
        }

        /* SEARCH BAR */
        .search-container { 
            width: 100%; 
            max-width: 800px; 
            margin: 0 auto 50px auto; 
            display: flex; 
            gap: 12px; 
        }
        .search-container input { 
            flex: 1; 
            padding: 14px 24px; 
            border-radius: 30px; 
            border: 1px solid var(--glass-border); 
            outline: none; 
            font-size: 15px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: var(--glass-shadow);
            color: var(--text-dark);
        }
        .search-container input:focus { 
            border-color: var(--brand-orange); 
            background: rgba(255, 255, 255, 0.9);
        }
        .search-container button { 
            background: var(--brand-orange); 
            color: white; 
            border: none; 
            padding: 0 35px; 
            border-radius: 30px; 
            font-weight: 600; 
            font-size: 15px;
            cursor: pointer; 
            transition: background 0.2s;
            box-shadow: 0 4px 15px rgba(255,102,0,0.3);
        }
        .search-container button:hover { background: #e55c00; }

        /* RESTAURANT CARDS */
        .restaurant-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); 
            gap: 30px; 
            margin-bottom: 60px; 
            width: 100%;
        }
        .restaurant-card { 
            background: var(--glass-bg); 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border); 
            border-radius: 20px; 
            overflow: hidden; 
            display: flex; 
            flex-direction: column; 
            transition: transform 0.25s, box-shadow 0.25s;
            box-shadow: var(--glass-shadow);
        }
        .restaurant-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
        }
        
        .card-img { 
            height: 180px; 
            background: rgba(226, 232, 240, 0.5); 
            position: relative; 
        }
        .card-img img { 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
        }

        .rating-badge { 
            position: absolute;
            top: 12px;
            right: 12px;
            background: rgba(255, 255, 255, 0.9); 
            backdrop-filter: blur(8px);
            padding: 4px 10px; 
            border-radius: 8px; 
            font-size: 13px; 
            font-weight: 700; 
            display: flex; 
            align-items: center; 
            gap: 5px; 
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        
        .card-info { padding: 20px; flex: 1; display: flex; flex-direction: column; }
        .card-info h3 { font-size: 18px; margin-bottom: 4px; font-weight: 600; }
        .card-info .cuisine-type { font-size: 13px; font-weight: 600; color: var(--brand-orange); margin-bottom: 6px; }
        .card-info .meta-info { font-size: 13px; color: var(--text-muted); margin-bottom: 18px; }
        
        .view-menu-btn { 
            display: block; 
            text-align: center; 
            background: rgba(255, 245, 237, 0.8); 
            color: var(--brand-orange); 
            padding: 10px; 
            border-radius: 10px; 
            font-weight: 600; 
            font-size: 14px; 
            text-decoration: none; 
            margin-top: auto; 
            border: 1px solid rgba(255,102,0,0.2); 
            transition: all 0.2s;
        }
        .view-menu-btn:hover { background: var(--brand-orange); color: white; }

        .no-results-msg {
            display: none;
            color: var(--text-muted);
            grid-column: 1/-1;
            font-size: 16px;
        }

        /* FOOTER */
        footer { 
            background: rgba(15, 23, 42, 0.9); 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            color: #94a3b8; 
            padding: 50px 40px 20px; 
            margin-top: auto; 
            width: 100%; 
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        .footer-container { width: 100%; display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 40px; }
        .footer-col h4 { color: white; font-size: 16px; margin-bottom: 15px; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 10px; }
        .footer-col ul li a { color: #94a3b8; text-decoration: none; font-size: 14px; transition: color 0.2s; }
        .footer-col ul li a:hover { color: var(--brand-orange); }
        .footer-bottom { width: 100%; margin: 40px auto 0; padding-top: 20px; border-top: 1px solid #334155; text-align: center; font-size: 13px; }
    </style>
</head>
<body>

<jsp:include page="partials/navbar.jsp" />

<div class="main-container">
    
    <!-- ZOMATO-STYLE CLEAR VIDEO BANNER -->
    <div class="promo-banner">
     <video class="promo-banner-video" id="bgVideo" autoplay loop muted playsinline defaultMuted>
    <source src="${pageContext.request.contextPath}/images/img/hero_background.mp4" type="video/mp4">
    Your browser does not support video playback.
</video>

        <div class="promo-banner-overlay"></div>

        <div class="promo-banner-content">
            <h1 class="brand-title">FoodieHub</h1>
            <h2>Delicious Food & Snacks Delivered</h2>
            <p>From morning tiffins to late-night cravings, beverages & gourmet treats delivered fast!</p>
            <a href="#popular-restaurants" class="btn-explore-now">
                Explore Menu <i class="fa-solid fa-arrow-down"></i>
            </a>
        </div>
    </div>

    <!-- WHAT'S ON YOUR MIND? -->
    <div class="mind-section">
        <h3 class="section-title">What's on your mind?</h3>
        <div class="circle-flex-grid">
            <a href="home?category=all" class="food-circle-card ${activeCategory.equalsIgnoreCase('all') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/default.jpg" alt="All Foods" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>All Foods</span>
            </a>
            <a href="home?category=South Indian" class="food-circle-card ${activeCategory.equalsIgnoreCase('South Indian') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/south_indian_res.jpg" alt="South Indian" onerror="this.src='https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>South Indian</span>
            </a>
            <a href="home?category=North Indian" class="food-circle-card ${activeCategory.equalsIgnoreCase('North Indian') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/north_indian_res.jpg" alt="North Indian" onerror="this.src='https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>North Indian</span>
            </a>
            <a href="home?category=Street Food" class="food-circle-card ${activeCategory.equalsIgnoreCase('Street Food') || activeCategory.equalsIgnoreCase('Chaat') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/street_food_res.jpg" alt="Street Food" onerror="this.src='https://images.unsplash.com/photo-1601050690597-df0568f70950?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>Street Food</span>
            </a>
            <a href="home?category=Sweets" class="food-circle-card ${activeCategory.equalsIgnoreCase('Sweets') || activeCategory.equalsIgnoreCase('Desserts') || activeCategory.equalsIgnoreCase('Mithai') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/desserts_res.jpg" alt="Desserts" onerror="this.src='https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>Sweets</span>
            </a>
            <a href="home?category=Chinese" class="food-circle-card ${activeCategory.equalsIgnoreCase('Chinese') || activeCategory.equalsIgnoreCase('Indo-Chinese') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/chinese_res.jpg" alt="Chinese" onerror="this.src='https://images.unsplash.com/photo-1563245372-f21724e3856d?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>Chinese</span>
            </a>
            <a href="home?category=Fast Food" class="food-circle-card ${activeCategory.equalsIgnoreCase('Fast Food') || activeCategory.equalsIgnoreCase('American Fast Food') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="images/img/fast_food_res.jpg" alt="Fast Food" onerror="this.src='https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=200';">
                    <div class="plate-base-tray"></div>
                </div>
                <span>Fast Food</span>
            </a>
            <a href="home?category=Beverages" class="food-circle-card ${activeCategory.equalsIgnoreCase('Beverages') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=200" alt="Beverages">
                    <div class="plate-base-tray"></div>
                </div>
                <span>Beverages</span>
            </a>
            <a href="home?category=Cakes" class="food-circle-card ${activeCategory.equalsIgnoreCase('Cakes') ? 'active' : ''}">
                <div class="plate-3d-wrapper">
                    <img src="https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200" alt="Cakes">
                    <div class="plate-base-tray"></div>
                </div>
                <span>Cakes & Bakery</span>
            </a>
        </div>
    </div>

    <div class="search-container">
        <input type="text" id="globalSearchInput" placeholder="Search for your favorite restaurants or cuisines..." onkeyup="executeGlobalTextSearch()">
        <button onclick="executeGlobalTextSearch()">Search</button>
    </div>

    <!-- RESTAURANTS SECTION -->
    <h3 class="section-title" id="popular-restaurants">Popular Restaurants Near You</h3>
    <div class="restaurant-grid">
        <c:choose>
            <c:when test="${not empty restaurants}">
                <c:forEach var="rest" items="${restaurants}">
                    <div class="restaurant-card" data-category="${not empty rest.cuisineType ? rest.cuisineType.toLowerCase() : ''}">
                        <div class="card-img">
                            <img src="${not empty rest.imageUrl ? rest.imageUrl : 'images/img/default.jpg'}" alt="${not empty rest.name ? rest.name : 'Restaurant'}" onerror="this.src='images/img/default.jpg';">
                            <div class="rating-badge">
                                <i class="fa-solid fa-star" style="color:#eab308;"></i> ${not empty rest.rating ? rest.rating : '4.0'}
                            </div>
                        </div>
                        <div class="card-info">
                            <h3><c:out value="${not empty rest.name ? rest.name : 'Restaurant'}" /></h3>
                            <p class="cuisine-type"><c:out value="${not empty rest.cuisineType ? rest.cuisineType : ''}" /></p>
                            <p class="meta-info">
                                <i class="fa-regular fa-clock"></i> ${not empty rest.deliveryTime ? rest.deliveryTime : '30'} mins &nbsp;|&nbsp; <c:out value="${not empty rest.address ? rest.address : 'Location unavailable'}" />
                            </p>
                            <a href="menu?restaurantId=${not empty rest.restaurantId ? rest.restaurantId : '#'}" class="view-menu-btn">View Menu</a>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="color: var(--text-muted); grid-column: 1/-1;">No active restaurants found in your database.</p>
            </c:otherwise>
        </c:choose>

        <p id="noMatchesFound" class="no-results-msg">No restaurants found matching your search.</p>
    </div>
</div>

<!-- FOOTER SECTION -->
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
                <li><a href="#">Team</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contact Us</h4>
            <ul>
                <li><a href="#">Help & Support</a></li>
                <li><a href="#">Partner with us</a></li>
                <li><a href="#">Ride with us</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Legal</h4>
            <ul>
                <li><a href="#">Terms & Conditions</a></li>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Cookie Policy</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 FoodieHub Technologies Pvt. Ltd. All rights reserved.</p>
    </div>
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const video = document.getElementById("bgVideo");
        if (video) {
            video.muted = true;
            video.play().catch(function (error) {
                console.log("Autoplay issue handled: ", error);
            });
        }
    });

    function executeGlobalTextSearch() {
        let query = document.getElementById('globalSearchInput').value.toLowerCase().trim();
        let cards = document.querySelectorAll('.restaurant-card');
        let visibleCount = 0;

        cards.forEach(card => {
            let name = card.querySelector('h3').textContent.toLowerCase();
            let cuisine = card.querySelector('.cuisine-type').textContent.toLowerCase();
            
            if (name.includes(query) || cuisine.includes(query)) {
                card.style.display = '';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        let noMatchMsg = document.getElementById('noMatchesFound');
        if (noMatchMsg) {
            noMatchMsg.style.display = (visibleCount === 0 && cards.length > 0) ? 'block' : 'none';
        }
    }
</script>

</body>
</html>