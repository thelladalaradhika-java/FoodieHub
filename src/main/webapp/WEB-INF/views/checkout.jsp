<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - FoodieHub</title>
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
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .cart-header h2 i { color: var(--brand-orange); }

        .form-group { margin-bottom: 15px; }

        .form-group label {
            display: block;
            font-size: 0.9em;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid rgba(0,0,0,0.15);
            background: rgba(255, 255, 255, 0.9);
            font-size: 0.95em;
            outline: none;
        }

        .form-control:focus {
            border-color: var(--brand-orange);
            box-shadow: 0 0 0 2px rgba(255, 102, 0, 0.2);
        }

        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 8px;
        }

        .payment-label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95em;
            font-weight: 600;
            cursor: pointer;
            padding: 10px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(0, 0, 0, 0.08);
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
    </style>
</head>
<body>

<% String ctx = request.getContextPath(); %>

<nav class="navbar">
    <a href="<%= ctx %>/home" class="navbar-brand">Foodie<span>Hub</span></a>
    <div class="navbar-links">
        <a href="<%= ctx %>/home"><i class="fa-solid fa-house"></i> Home</a>
        <a href="<%= ctx %>/cart"><i class="fa-solid fa-basket-shopping"></i> Cart</a>
        <a href="<%= ctx %>/orderHistory"><i class="fa-solid fa-clock-rotate-left"></i> My Orders</a>
    </div>
</nav>

<div class="cart-layout">
    
    <div class="glass-card">
        <div class="cart-header">
            <h2><i class="fa-solid fa-truck-fast"></i> Delivery Details</h2>
        </div>

        <form action="<%= ctx %>/checkout" method="POST" id="checkoutForm">
            <div class="form-group">
                <label for="userName">Full Name</label>
                <input type="text" id="userName" name="userName" class="form-control" 
                       value="${userName != null ? userName : requestScope.userName}" required />
            </div>

            <div class="form-group">
                <label for="userEmail">Email Address</label>
                <input type="email" id="userEmail" name="userEmail" class="form-control" 
                       value="${userEmail != null ? userEmail : requestScope.userEmail}" required />
            </div>

            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" class="form-control" 
                       value="${userPhone != null ? userPhone : requestScope.userPhone}" required />
            </div>

            <div class="form-group">
                <label for="address">Delivery Address</label>
                <textarea id="address" name="address" class="form-control" rows="3" required>${userAddress != null ? userAddress : requestScope.userAddress}</textarea>
            </div>

            <div class="form-group" style="margin-top: 20px;">
                <label>Select Payment Option</label>
                <div class="payment-options">
                    <label class="payment-label">
                        <input type="radio" name="paymentMode" value="COD" checked />
                        <i class="fa-solid fa-money-bill-wave" style="color: #22c55e;"></i> Cash on Delivery (COD)
                    </label>
                    <label class="payment-label">
                        <input type="radio" name="paymentMode" value="UPI" />
                        <i class="fa-solid fa-qrcode" style="color: #0284c7;"></i> UPI / Online Payment
                    </label>
                </div>
            </div>
        </form>
    </div>

    <div>
        <div class="glass-card">
            <h2><i class="fa-solid fa-receipt"></i> Order Summary</h2>
            
            <div class="summary-row">
                <span>Items Subtotal</span>
                <span>&#8377;<%= request.getAttribute("subtotalAmount") != null ? String.format("%.2f", (Double)request.getAttribute("subtotalAmount")) : "0.00" %></span>
            </div>
            <div class="summary-row">
                <span>Delivery Fee & Taxes</span>
                <span>&#8377;<%= request.getAttribute("deliveryFee") != null ? String.format("%.2f", (Double)request.getAttribute("deliveryFee")) : "0.00" %></span>
            </div>
            
            <div class="summary-row total">
                <span>Grand Total</span>
                <span>&#8377;<%= request.getAttribute("grandTotal") != null ? String.format("%.2f", (Double)request.getAttribute("grandTotal")) : "0.00" %></span>
            </div>

            <button type="submit" form="checkoutForm" class="btn-checkout">
                Place Order <i class="fa-solid fa-check-circle" style="margin-left: 6px;"></i>
            </button>
        </div>
    </div>

</div>

</body>
</html>