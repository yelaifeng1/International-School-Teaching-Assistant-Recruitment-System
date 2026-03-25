package com.group50.tasystem.dao;

import com.group50.tasystem.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;

/**
 * DAO 层 - 用户数据访问对象
 * 负责从 users.json 文件读取和操作用户数据
 */
public class UserDAO {
    private static final String USERS_JSON_PATH = "data/users.json";
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    /**
     * 从 users.json 文件读取所有用户
     */
    public static List<User> getAllUsers() throws IOException {
        String jsonContent = Files.readString(Paths.get(USERS_JSON_PATH));
        return gson.fromJson(jsonContent, new TypeToken<List<User>>(){}.getType());
    }

    /**
     * 根据用户名和密码验证登录
     * @param username 用户名
     * @param password 密码
     * @return 如果验证成功，返回用户对象；否则返回空
     */
    public static Optional<User> validateLogin(String username, String password) {
        try {
            List<User> users = getAllUsers();
            return users.stream()
                    .filter(user -> user.getUsername().equals(username) 
                            && user.getPassword().equals(password))
                    .findFirst();
        } catch (IOException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    /**
     * 根据用户名查找用户
     */
    public static Optional<User> getUserByUsername(String username) {
        try {
            List<User> users = getAllUsers();
            return users.stream()
                    .filter(user -> user.getUsername().equals(username))
                    .findFirst();
        } catch (IOException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    /**
     * 根据用户 ID 查找用户
     */
    public static Optional<User> getUserById(String userId) {
        try {
            List<User> users = getAllUsers();
            return users.stream()
                    .filter(user -> user.getUserId().equals(userId))
                    .findFirst();
        } catch (IOException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }

    /**
     * 检查用户名是否已存在
     */
    public static boolean isUsernameExists(String username) {
        return getUserByUsername(username).isPresent();
    }

    /**
     * 生成新的用户 ID
     */
    private static String generateUserId() throws IOException {
        List<User> users = getAllUsers();
        int maxId = users.stream()
                .map(user -> {
                    try {
                        return Integer.parseInt(user.getUserId().substring(1));
                    } catch (Exception e) {
                        return 0;
                    }
                })
                .max(Integer::compare)
                .orElse(0);
        return "U" + String.format("%03d", maxId + 1);
    }

    /**
     * 添加新用户到 users.json
     * @param fullname 用户的真实姓名
     * @param email 用户的电子邮箱
     * @param username 用户名
     * @param password 密码
     * @param role 用户角色
     * @return 如果成功添加返回新用户对象，否则返回 Optional.empty()
     */
    public static Optional<User> addUser(String fullname, String email, String username, String password, String role) {
        try {
            // 检查用户名是否已存在
            if (isUsernameExists(username)) {
                return Optional.empty();
            }

            // 读取现有用户
            List<User> users = getAllUsers();

            // 生成新用户 ID
            String newUserId = generateUserId();

            // 创建新用户对象
            User newUser = new User(newUserId, username, password, role, email);
            
            // 添加到用户列表
            users.add(newUser);

            // 写入到 JSON 文件
            String jsonContent = gson.toJson(users);
            Files.writeString(Paths.get(USERS_JSON_PATH), jsonContent);

            return Optional.of(newUser);
        } catch (IOException e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
}
