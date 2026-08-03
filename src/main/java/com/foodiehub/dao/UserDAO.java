
package com.foodiehub.dao;

import java.util.List;
import com.foodiehub.model.User;

public interface UserDAO {
    // Authentication & Onboarding
    boolean registerUser(User user);
    User loginUser(String email, String password);
    
    // Profile Management
    User getUserById(int userId);
    boolean updateUserProfile(User user);
    
    // Admin Management Methods
    List<User> getAllUsers();
    boolean updateUserRole(int userId, String newRole);
}