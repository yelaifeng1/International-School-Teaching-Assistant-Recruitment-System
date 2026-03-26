package com.group50.apply.service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.group50.tasystem.model.User;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

public class ApplyService {
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
        try (InputStream input = ApplyService.class.getClassLoader().getResourceAsStream(USER_FILE)) {
            if (input == null) {
                throw new IllegalStateException("users.json not found in classpath.");
            }
            Gson gson = new Gson();
            Type listType = new TypeToken<List<User>>() {}.getType();
            return gson.fromJson(new InputStreamReader(input, StandardCharsets.UTF_8), listType);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}