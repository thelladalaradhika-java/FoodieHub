<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | FoodieHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root { 
            --brand-orange: #ff6600; 
            --brand-orange-hover: #e55c00;
            --text-dark: #0f172a; 
            --text-muted: #475569; 

            --app-bg-gradient: linear-gradient(135deg, #cfd8dc 0%, #b0bec5 50%, #90a4ae 100%);
            --glass-card-bg: rgba(255, 255, 255, 0.55);
            --glass-border: rgba(255, 255, 255, 0.65);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        
        body { 
            background: var(--app-bg-gradient) fixed; 
            color: var(--text-dark); 
            min-height: 100vh; 
            padding-bottom: 50px;
        }
        
        .profile-container {
            max-width: 580px;
            margin: 40px auto 50px auto;
            padding: 0 20px;
        }

        .profile-card {
            background: var(--glass-card-bg) !important;
            backdrop-filter: blur(16px) !important;
            -webkit-backdrop-filter: blur(16px) !important;
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            padding: 36px 32px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        .profile-card h2 {
            font-size: 22px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 20px;
            border-bottom: 2px solid rgba(255, 102, 0, 0.2);
            padding-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .avatar-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 24px;
        }

        .avatar-wrapper {
            position: relative;
            width: 110px;
            height: 110px;
            border-radius: 50%;
            border: 3px solid var(--brand-orange);
            background: rgba(255, 255, 255, 0.8);
            box-shadow: 0 6px 16px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .avatar-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .avatar-icon-fallback {
            font-size: 55px;
            color: var(--brand-orange);
        }

        .file-upload-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
        }

        .file-upload-input {
            font-size: 13px;
            color: var(--text-dark);
            background: rgba(255, 255, 255, 0.6);
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px dashed var(--brand-orange);
            cursor: pointer;
        }

        .alert-msg {
            padding: 14px 18px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success { 
            background-color: rgba(209, 250, 229, 0.9); 
            color: #065f46; 
            border: 1px solid #a7f3d0; 
        }
        .alert-danger { 
            background-color: rgba(254, 226, 226, 0.9); 
            color: #991b1b; 
            border: 1px solid #fecaca; 
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            font-size: 14px;
            border: 1px solid rgba(0, 0, 0, 0.15);
            border-radius: 10px;
            outline: none;
            transition: all 0.2s ease;
            color: var(--text-dark);
            background: rgba(255, 255, 255, 0.75);
            font-weight: 500;
        }

        .form-control:focus {
            border-color: var(--brand-orange);
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(255, 102, 0, 0.15);
        }

        .form-control:disabled {
            background-color: rgba(241, 245, 249, 0.6);
            color: #64748b;
            cursor: not-allowed;
            border-color: transparent;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 90px;
        }

        .btn-update {
            width: 100%;
            background-color: var(--brand-orange);
            color: #ffffff;
            border: none;
            padding: 14px;
            font-size: 15px;
            font-weight: 700;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.2s ease;
            margin-top: 10px;
            box-shadow: 0 4px 12px rgba(255, 102, 0, 0.25);
        }

        .btn-update:hover {
            background-color: var(--brand-orange-hover);
        }

        .btn-delete-photo {
            width: 100%;
            background-color: rgba(239, 68, 68, 0.1);
            color: #dc2626;
            border: 1px solid #fca5a5;
            padding: 10px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-delete-photo:hover {
            background-color: #dc2626;
            color: #ffffff;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="profile-container">
    <div class="profile-card">
        <h2><i class="fa-solid fa-id-card" style="color: var(--brand-orange);"></i>My Profile</h2>

        <!-- Alert Notification Box -->
        <% 
            String successMsg = (String) request.getAttribute("successMessage");
            if (successMsg != null && !successMsg.isEmpty()) {
        %>
            <div class="alert-msg alert-success"><i class="fa-solid fa-circle-check"></i><%= successMsg %></div>
        <% } %>

        <% 
            String errorMsg = (String) request.getAttribute("errorMessage");
            if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
            <div class="alert-msg alert-danger"><i class="fa-solid fa-circle-exclamation"></i><%= errorMsg %></div>
        <% } %>

        <!-- MAIN UPDATE FORM -->
        <form action="profile" method="post" enctype="multipart/form-data">

            <div class="avatar-container">
                <div class="avatar-wrapper">
                    <% 
                        String profilePicUrl = (String) request.getAttribute("profilePicUrl");
                        if (profilePicUrl != null) { 
                    %>
                        <img src="<%= profilePicUrl %>" alt="User Avatar" class="avatar-img">
                    <% } else { %>
                        <i class="fa-solid fa-user avatar-icon-fallback"></i>
                    <% } %>
                </div>

                <div class="file-upload-box">
                    <label style="font-size: 12px; font-weight: 600; color: var(--text-muted);">Upload or Change Profile Photo:</label>
                    <input type="file" name="profileImage" accept="image/*" class="file-upload-input">
                </div>
            </div>

            <div class="form-group">
                <label>Username</label>
                <input type="text" class="form-control" 
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" disabled>
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" class="form-control" 
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" disabled>
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" class="form-control" name="phoneNumber" 
                       value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" 
                       placeholder="Enter phone number">
            </div>

            <div class="form-group">
                <label>Delivery Address</label>
                <textarea class="form-control" name="address" 
                          placeholder="Enter delivery address"><%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %></textarea>
            </div>

            <button type="submit" class="btn-update">Update Profile Details</button>
        </form>

        <!-- DELETE PROFILE PHOTO FORM (ONLY SHOWN IF PHOTO FILE EXISTS) -->
        <% if (profilePicUrl != null) { %>
            <form action="profile" method="post">
                <input type="hidden" name="action" value="removePhoto">
                <button type="submit" class="btn-delete-photo">
                    <i class="fa-solid fa-trash-can"></i> Delete Profile Photo
                </button>
            </form>
        <% } %>

    </div>
</div>

</body>
</html>