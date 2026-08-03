<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - FoodieHub</title>
                 <link rel="icon" type="image/jpeg"
      href="<%= request.getContextPath() %>/images/img/Foodiefavicon.jpg">
    
    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { 
            --brand-orange: #ff6600; 
            --text-dark: #0f172a; 
            --text-muted: #475569; 
            --navbar-dark-bg: rgba(26, 29, 32, 0.85);
            --app-bg-gradient: linear-gradient(135deg, #cfd8dc 0%, #b0bec5 50%, #90a4ae 100%);
            
            /* Glassmorphism Variables */
            --glass-card-bg: rgba(255, 255, 255, 0.45);
            --glass-card-hover: rgba(255, 255, 255, 0.65);
            --glass-border: rgba(255, 255, 255, 0.6);
            --glass-btn-bg: rgba(255, 255, 255, 0.35);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body { 
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
            background: var(--app-bg-gradient) fixed; 
            color: var(--text-dark); 
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar { 
            background-color: var(--navbar-dark-bg); 
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15); 
            padding: 16px 36px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }

        .navbar-brand { 
            font-size: 1.6em; 
            font-weight: 800; 
            color: var(--brand-orange); 
            text-decoration: none; 
        }

        .navbar-brand span { color: #ffffff; }

        .container { 
            max-width: 620px; 
            margin: 40px auto; 
            padding: 0 20px; 
            width: 100%;
        }

        /* Glassmorphism Card Container */
        .confirmation-card { 
            background: var(--glass-card-bg); 
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 20px; 
            padding: 40px 30px; 
            text-align: center;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15); 
            border: 1px solid var(--glass-border); 
        }

        .success-icon {
            font-size: 65px;
            color: #22c55e;
            margin-bottom: 20px;
            filter: drop-shadow(0 4px 6px rgba(34, 197, 94, 0.3));
        }

        h1 { font-size: 2em; font-weight: 800; margin-bottom: 8px; }
        p.subtitle { color: var(--text-muted); font-size: 1em; font-weight: 600; margin-bottom: 25px; }

        /* Order Details Box */
        .details-box {
            background: rgba(255, 255, 255, 0.35);
            backdrop-filter: blur(8px);
            border: 1px solid var(--glass-border);
            border-radius: 14px;
            padding: 20px;
            text-align: left;
            margin-bottom: 30px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed rgba(15, 23, 42, 0.12);
            font-size: 0.95em;
        }

        .detail-row:last-child { border-bottom: none; }
        .detail-label { color: var(--text-muted); font-weight: 600; }
        .detail-value { color: var(--text-dark); font-weight: 700; }

        /* Transparent Action Buttons Wrapper */
        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Transparent Glassmorphism Buttons */
        .btn-glass { 
            display: inline-flex; 
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 24px; 
            background: var(--glass-btn-bg); 
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            color: var(--text-dark); 
            text-decoration: none; 
            border-radius: 12px; 
            font-weight: 700; 
            font-size: 0.95em;
            border: 1px solid var(--glass-border);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            flex: 1;
            min-width: 180px;
        }

        .btn-glass:hover {
            background: var(--glass-card-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        /* Accent Highlight for Primary Button */
        .btn-glass-primary {
            background: rgba(255, 102, 0, 0.85);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.4);
        }

        .btn-glass-primary:hover {
            background: rgba(255, 102, 0, 1);
            color: #ffffff;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/home" class="navbar-brand">
            Foodie<span>Hub</span>
        </a>
    </nav>

    <div class="container">
        <div class="confirmation-card">
            <i class="fa-solid fa-circle-check success-icon"></i>
            <h1>Order Confirmed!</h1>
            <p class="subtitle">Thank you for your order. We are preparing your food!</p>

            <div class="details-box">
                <div class="detail-row">
                    <span class="detail-label">Order ID</span>
                    <span class="detail-value">#<%= request.getAttribute("orderId") != null ? request.getAttribute("orderId") : "ORD-1001" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Customer Name</span>
                    <span class="detail-value"><%= request.getAttribute("confirmUserName") != null ? request.getAttribute("confirmUserName") : "Customer" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Payment Mode</span>
                    <span class="detail-value"><%= request.getAttribute("paymentMethod") != null ? request.getAttribute("paymentMethod") : "COD" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Amount</span>
                    <span class="detail-value" style="color: var(--brand-orange);">₹<%= request.getAttribute("totalAmountFormatted") != null ? request.getAttribute("totalAmountFormatted") : "0.00" %></span>
                </div>
            </div>

            <!-- Transparent Navigation Buttons -->
            <div class="button-group">
                <a href="<%= request.getContextPath() %>/home" class="btn-glass">
                    <i class="fa-solid fa-house"></i> Go to Home
                </a>
                <a href="<%= request.getContextPath() %>/orderHistory" class="btn-glass btn-glass-primary">
                    <i class="fa-solid fa-clock-rotate-left"></i> My Orders
                </a>
            </div>
        </div>
    </div>

</body>
</html>