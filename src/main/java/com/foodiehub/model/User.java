
package com.foodiehub.model;

import java.time.LocalDateTime;

public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String phoneNumber; // Added field
    private String address;
    private String role; // CUSTOMER or ADMIN
    private LocalDateTime createdDate;
    private LocalDateTime lastLoginDate;

    // Default Constructor
    public User() {}

    // Parameterized Constructor
    public User(int userId, String username, String password, String email, String phoneNumber, String address, String role, LocalDateTime createdDate, LocalDateTime lastLoginDate) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phoneNumber = phoneNumber; // Added here
        this.address = address;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNumber() { return phoneNumber; } // Added getter
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; } // Added setter

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }

    public LocalDateTime getLastLoginDate() { return lastLoginDate; }
    public void setLastLoginDate(LocalDateTime lastLoginDate) { this.lastLoginDate = lastLoginDate; }
}