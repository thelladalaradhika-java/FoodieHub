<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Join the Hunt - Foodie Hub</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        body {
            background: #08090b;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 24px;
            position: relative;
            overflow-x: hidden;
        }

        /* AMBIENT GLOW BACKGROUND ELEMENTS */
        body::before {
            content: '';
            position: absolute;
            width: 550px;
            height: 550px;
            background: radial-gradient(circle, rgba(255, 102, 0, 0.3) 0%, rgba(0, 0, 0, 0) 70%);
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
            background: radial-gradient(circle, rgba(255, 85, 0, 0.2) 0%, rgba(0, 0, 0, 0) 70%);
            bottom: -180px;
            right: -180px;
            z-index: 0;
            filter: blur(70px);
        }

        .auth-card {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 440px;
            background: rgba(18, 22, 29, 0.45);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.14);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.6), 
                        inset 0 1px 0 rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }
        .header-section {
            text-align: center;
            margin-bottom: 8px;
        }
        .header-section h1 {
            font-size: 26px;
            font-weight: 700;
            letter-spacing: -0.5px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.8);
        }
        .auth-redirect {
            text-align: center;
            margin-bottom: 28px;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.85);
        }
        .auth-redirect a {
            color: #ff6600;
            text-decoration: none;
            font-weight: 600;
            margin-left: 4px;
        }
        .auth-redirect a:hover {
            color: #ff8800;
            text-decoration: underline;
        }
        .input-group-container {
            display: flex;
            flex-direction: column;
            gap: 18px;
            margin-bottom: 28px;
        }
        .input-box {
            position: relative;
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(255, 255, 255, 0.14);
            padding: 10px 16px;
            border-radius: 10px;
            transition: all 0.25s ease;
        }
        .input-box:focus-within {
            background: rgba(255, 255, 255, 0.12);
            border-color: #ff6600;
            box-shadow: 0 0 0 3px rgba(255, 102, 0, 0.25);
        }

        /* EXTRA THICK, HIGH-CONTRAST LABELS */
        .input-box label {
            display: block;
            font-size: 11px;
            color: #ffffff; /* Solid White */
            font-weight: 800; /* Thick & Bold */
            text-transform: uppercase;
            letter-spacing: 0.8px;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.9);
            margin-bottom: 4px;
        }
        .input-box input, .input-box select {
            width: 100%;
            border: none;
            background: transparent;
            font-size: 15px;
            color: #ffffff;
            font-weight: 500;
            outline: none;
        }
        .input-box select option {
            background: #12161d;
            color: #ffffff;
        }
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #ff6600, #ff8800);
            color: #ffffff;
            border: none;
            padding: 15px;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(255, 102, 0, 0.4);
            transition: all 0.25s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(255, 102, 0, 0.55);
        }
        .btn-submit:active {
            transform: translateY(0px);
        }
        .alert-error {
            background: rgba(231, 76, 60, 0.25);
            border: 1px solid #e74c3c;
            color: #ffffff;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="auth-card">

    <% 
        Object errorObj = request.getAttribute("errorMessage");
        if(errorObj != null) { 
            String errorMsg = errorObj.toString();
            if(!errorMsg.isEmpty()) {
    %>
        <div class="alert-error"><%= errorMsg %></div>
    <% 
            }
        } 
    %>

    <div class="header-section">
        <h1>Create Account</h1>
    </div>

    <div class="auth-redirect">
        Already hunting? <a href="login">Login here</a>
    </div>

    <form action="register" method="post">
        <div class="input-group-container">
            
            <div class="input-box">
                <label>Username</label>
                <input type="text" name="username" required autocomplete="off">
            </div>

            <div class="input-box">
                <label>Email Address</label>
                <input type="email" name="email" required autocomplete="off">
            </div>

            <div class="input-box">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>

            <div class="input-box">
                <label>Phone Number</label>
                <input type="tel" name="phoneNumber" required autocomplete="off">
            </div>

            <div class="input-box">
                <label>Delivery Address</label>
                <input type="text" name="address" required autocomplete="off">
            </div>

            <div class="input-box">
                <label>Application Role</label>
                <select name="role" required>
                    <option value="CUSTOMER">Customer</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
            
        </div>

        <button type="submit" class="btn-submit">Register Account</button>
    </form>
</div>

</body>
</html>