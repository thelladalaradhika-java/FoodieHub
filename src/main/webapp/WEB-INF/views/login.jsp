<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/images/img/Foodiefavicon.jpg">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | FoodieHub</title>
    
    
    
             <link rel="icon" type="image/jpeg"
      href="<%= request.getContextPath() %>/images/img/Foodiefavicon.jpg">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: #08090b;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-x: hidden;
            position: relative;
        }

        /* VIBRANT AMBIENT BACKGROUND GLOWS */
        body::before {
            content: '';
            position: absolute;
            width: 550px;
            height: 550px;
            background: radial-gradient(circle, rgba(255, 102, 0, 0.35) 0%, rgba(0, 0, 0, 0) 70%);
            top: -120px;
            left: -120px;
            z-index: 0;
            filter: blur(60px);
        }

        body::after {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(255, 85, 0, 0.25) 0%, rgba(0, 0, 0, 0) 70%);
            bottom: -180px;
            right: -180px;
            z-index: 0;
            filter: blur(70px);
        }

        /* MAIN GLASS-TRANSPARENT FLOATING CONTAINER */
        .auth-wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 1050px;
            min-height: 600px;
            background: rgba(18, 22, 29, 0.35);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 28px;
            display: flex;
            align-items: stretch;
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.6), 
                        inset 0 1px 0 rgba(255, 255, 255, 0.15);
            overflow: hidden;
        }

        /* LEFT SIDE: ARTWORK & IMPRESSIVE TEXT DISPLAY */
        .art-side {
            flex: 1.1;
            position: relative;
            background: rgba(255, 102, 0, 0.03);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 40px 35px;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
        }

        .brand-header {
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 2;
        }

        .brand-logo-icon {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #ff6600, #ff8800);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 20px;
            box-shadow: 0 8px 24px rgba(255, 102, 0, 0.5);
        }

        .brand-title {
            font-size: 24px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.5px;
        }

        .brand-title span {
            color: #ff6600;
        }

        .art-graphic-container {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 15px 0;
            z-index: 2;
            width: 100%;
        }

        .floating-art {
            width: 100%;
            max-width: 380px;
            max-height: 300px;
            height: auto;
            object-fit: contain;
            border-radius: 16px;
            filter: drop-shadow(0 20px 30px rgba(0, 0, 0, 0.7));
            animation: floatAnim 6s ease-in-out infinite;
        }

        @keyframes floatAnim {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-8px); }
        }

        .art-footer-text h1 {
            font-size: 30px;
            font-weight: 900;
            line-height: 1.25;
            margin-bottom: 10px;
            z-index: 2;
            position: relative;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #ffffff 30%, #ff8800 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 10px 20px rgba(255, 102, 0, 0.2);
        }

        .art-footer-text p {
            font-size: 14px;
            color: #cbd5e1;
            line-height: 1.6;
            font-weight: 400;
            z-index: 2;
            position: relative;
        }

        /* RIGHT SIDE: TRANSPARENT FORM CONTAINER */
        .form-side {
            flex: 1;
            padding: 40px 45px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            background: rgba(0, 0, 0, 0.15);
        }

        .login-header {
            margin-bottom: 24px;
        }

        .login-header h2 {
            font-size: 28px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 6px;
            letter-spacing: -0.5px;
        }

        .login-header p {
            font-size: 14px;
            color: #94a3b8;
        }

        .login-header a {
            color: #ff6600;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
        }

        .login-header a:hover {
            text-decoration: underline;
            color: #ff8800;
        }

        /* HIDDEN RADIO INPUTS FOR PURE CSS ROLE TOGGLE */
        .role-radio-input {
            display: none;
        }

        .role-selector {
            display: flex;
            background: rgba(0, 0, 0, 0.4);
            padding: 5px;
            border-radius: 14px;
            margin-bottom: 22px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .role-option {
            flex: 1;
            text-align: center;
            padding: 10px 0;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: #94a3b8;
            cursor: pointer;
            border-radius: 10px;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* PURE CSS ACTIVE STATES */
        #roleCustomer:checked ~ .auth-wrapper .form-side .role-selector label[for="roleCustomer"] {
            background: linear-gradient(135deg, #ff6600, #ff8800);
            color: #ffffff;
            box-shadow: 0 4px 18px rgba(255, 102, 0, 0.4);
        }

        #roleAdmin:checked ~ .auth-wrapper .form-side .role-selector label[for="roleAdmin"] {
            background: linear-gradient(135deg, #ff6600, #ff8800);
            color: #ffffff;
            box-shadow: 0 4px 18px rgba(255, 102, 0, 0.4);
        }

        /* PURE CSS DYNAMIC TEXT & ICON TOGGLES */
        .customer-label, .admin-label,
        .customer-icon, .admin-icon,
        .customer-btn-text, .admin-btn-text {
            display: none;
        }

        #roleCustomer:checked ~ .auth-wrapper .form-side .customer-label { display: block; }
        #roleCustomer:checked ~ .auth-wrapper .form-side .customer-icon { display: inline-block; }
        #roleCustomer:checked ~ .auth-wrapper .form-side .customer-btn-text { display: inline; }

        #roleAdmin:checked ~ .auth-wrapper .form-side .admin-label { display: block; }
        #roleAdmin:checked ~ .auth-wrapper .form-side .admin-icon { display: inline-block; }
        #roleAdmin:checked ~ .auth-wrapper .form-side .admin-btn-text { display: inline; }

        .input-group {
            margin-bottom: 18px;
        }

        .input-group label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #cbd5e1;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            color: #94a3b8;
            font-size: 15px;
        }

        .input-wrapper input {
            width: 100%;
            padding: 13px 16px 13px 45px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            font-size: 14px;
            color: #ffffff;
            font-weight: 500;
            outline: none;
            transition: all 0.25s ease;
        }

        .input-wrapper input::placeholder {
            color: #64748b;
        }

        .input-wrapper input:focus {
            background: rgba(255, 255, 255, 0.14);
            border-color: #ff6600;
            box-shadow: 0 0 0 3px rgba(255, 102, 0, 0.25);
        }

        .error-message {
            background: rgba(220, 38, 38, 0.25);
            border: 1px solid rgba(220, 38, 38, 0.5);
            color: #fca5a5;
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .submit-btn {
            width: 100%;
            background: linear-gradient(135deg, #ff6600, #ff8800);
            color: #ffffff;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 6px;
            box-shadow: 0 8px 25px rgba(255, 102, 0, 0.4);
            transition: all 0.25s ease;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(255, 102, 0, 0.55);
        }

        /* RESPONSIVE LAYOUT */
        @media (max-width: 900px) {
            .auth-wrapper {
                flex-direction: column;
                max-width: 480px;
            }
            .art-side {
                display: none;
            }
            .form-side {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>

    <!-- HIDDEN RADIO INPUTS FOR PURE CSS STATE SELECTION -->
    <input type="radio" name="role" id="roleCustomer" value="CUSTOMER" class="role-radio-input" checked form="loginForm">
    <input type="radio" name="role" id="roleAdmin" value="ADMIN" class="role-radio-input" form="loginForm">

    <div class="auth-wrapper">
        
        <!-- LEFT HALF: BRAND & LOCAL ARTWORK DISPLAY -->
        <div class="art-side">
            <div class="brand-header">
                <div class="brand-logo-icon">
                    <i class="fa-solid fa-utensils"></i>
                </div>
                <div class="brand-title">Foodie<span>Hub</span></div>
            </div>

            <!-- LOCAL DELIVERY SCOOTER IMAGE -->
            <div class="art-graphic-container">
                <img src="${pageContext.request.contextPath}/images/img/delivery.jpg" alt="Food Delivery Rider" class="floating-art" />
            </div>
            <div class="art-footer-text">
                <h1>Craving Something<br/>Delicious?</h1>
                <p>Order from your favorite restaurants and get hot meals delivered right to your door in minutes.</p>
            </div>
        </div>

        <!-- RIGHT HALF: FORM CONTAINER -->
        <div class="form-side">
            <div class="login-header">
                <h2>Welcome Back</h2>
                <p>Don't have an account? <a href="register">Register Now</a></p>
            </div>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="login" method="post" id="loginForm">
                
                <!-- PURE CSS ROLE SELECTOR TOGGLE -->
                <div class="role-selector">
                    <label for="roleCustomer" class="role-option">
                        <i class="fa-solid fa-user"></i> CUSTOMER
                    </label>
                    <label for="roleAdmin" class="role-option">
                        <i class="fa-solid fa-user-shield"></i> ADMIN
                    </label>
                </div>

                <div class="input-group">
                    <label class="customer-label">EMAIL ADDRESS</label>
                    <label class="admin-label">ADMIN USERNAME / EMAIL</label>
                    
                    <div class="input-wrapper">
                        <i class="fa-regular fa-envelope customer-icon"></i>
                        <i class="fa-solid fa-user-gear admin-icon"></i>
                        <input type="text" id="email" name="email" placeholder="Enter your credentials" required autofocus>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password">PASSWORD</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Enter your password" required>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <span class="customer-btn-text">Sign In as Customer</span>
                    <span class="admin-btn-text">Sign In as Admin</span>
                </button>
            </form>
        </div>

    </div>

</body>
</html>