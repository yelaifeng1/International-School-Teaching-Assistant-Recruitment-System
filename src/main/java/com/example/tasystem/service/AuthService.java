package com.example.tasystem.service;

import com.example.tasystem.dao.UserDAO;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;
import com.example.tasystem.util.Roles;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class AuthService {
    private final UserDAO userDAO;

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public Optional<User> authenticate(String username, String password) {
        if (username == null || password == null) {
            return Optional.empty();
        }

        return userDAO.findByUsername(username.trim())
                .filter(user -> password.equals(user.getPassword()));
    }

    public Optional<User> findById(String userId) {
        return userDAO.findById(userId);
    }

    public List<User> findAllUsers() {
        return userDAO.findAll();
    }

    public ServiceResult<User> register(String username, String email, String password, String role) {
        String trimmedUsername = username == null ? "" : username.trim();
        String normalizedEmail = email == null ? "" : email.trim();
        String normalizedRole = Roles.normalize(role);

        if (trimmedUsername.length() < 3 || trimmedUsername.length() > 20) {
            return ServiceResult.failure("Username must be between 3 and 20 characters.");
        }

        if (trimmedUsername.contains(" ")) {
            return ServiceResult.failure("Username cannot contain spaces.");
        }

        if (userDAO.usernameExists(trimmedUsername)) {
            return ServiceResult.failure("Username already exists.");
        }

        if (normalizedEmail.isBlank() || !normalizedEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return ServiceResult.failure("Please provide a valid email address.");
        }

        if (userDAO.emailExists(normalizedEmail)) {
            return ServiceResult.failure("Email already exists.");
        }

        if (password == null || password.length() < 8) {
            return ServiceResult.failure("Password must be at least 8 characters.");
        }

        if (!password.matches(".*[A-Za-z].*") || !password.matches(".*\\d.*")) {
            return ServiceResult.failure("Password must contain both letters and numbers.");
        }

        User user = new User();
        user.setUserId(userDAO.nextUserId());
        user.setUsername(trimmedUsername);
        user.setPassword(password);
        user.setRole(normalizedRole);
        user.setEmail(normalizedEmail);
        user.setDisplayName(trimmedUsername);
        user.setCreatedAt(LocalDate.now().toString());
        userDAO.save(user);

        return ServiceResult.success("Registration successful.", user);
    }
}
