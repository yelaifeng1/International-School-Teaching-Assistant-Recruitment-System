package com.group50.auth.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.group50.auth.model.User;

import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

public class UserService {
    private static final String USER_FILE = "users.json";
    private static final List<User> USERS = loadUsers();

    public Optional<User> authenticate(String username, String password) {
        if (username == null || password == null) {
            return Optional.empty();
        }

        return USERS.stream()
                .filter(u -> username.equals(u.getUsername()) && password.equals(u.getPassword()))
                .findFirst();
    }

    private static List<User> loadUsers() {
        try (InputStream input = UserService.class.getClassLoader().getResourceAsStream(USER_FILE)) {
            if (input == null) {
                throw new IllegalStateException("users.json not found in classpath.");
            }
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(input, new TypeReference<List<User>>() {
            });
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
