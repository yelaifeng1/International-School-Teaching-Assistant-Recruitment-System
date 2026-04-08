package com.example.tasystem.dao;

import com.example.tasystem.model.User;
import com.example.tasystem.util.IdGenerator;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

public class UserDAO extends JsonFileDao<User> {
    public UserDAO(ServletContext context) {
        super(context, "users.json", new TypeToken<List<User>>() {
        }.getType());
    }

    public List<User> findAll() {
        return readAll();
    }

    public Optional<User> findById(String userId) {
        return findAll().stream()
                .filter(user -> Objects.equals(user.getUserId(), userId))
                .findFirst();
    }

    public Optional<User> findByUsername(String username) {
        return findAll().stream()
                .filter(user -> user.getUsername() != null && user.getUsername().equalsIgnoreCase(username))
                .findFirst();
    }

    public boolean usernameExists(String username) {
        return findByUsername(username).isPresent();
    }

    public User save(User user) {
        List<User> users = findAll();
        users.removeIf(existing -> Objects.equals(existing.getUserId(), user.getUserId()));
        users.add(user);
        users.sort(Comparator.comparing(User::getUserId));
        writeAll(users);
        return user;
    }

    public String nextUserId() {
        return IdGenerator.nextId("U", findAll().stream().map(User::getUserId).collect(Collectors.toList()));
    }
}
