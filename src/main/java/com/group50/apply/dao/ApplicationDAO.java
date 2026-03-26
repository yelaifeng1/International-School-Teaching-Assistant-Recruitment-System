package com.group50.apply.dao;

import com.group50.apply.model.Application;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DAO 层 - 申请数据访问对象
 * 负责从 data/applications.json 文件读取和操作申请数据
 */
public class ApplicationDAO {

    private static final String APPLICATIONS_JSON_PATH = "data/applications.json";
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    /**
     * 从 applications.json 读取所有申请
     * 如果文件不存在或为空，返回空列表
     */
    public static List<Application> getAllApplications() throws IOException {
        Path path = Paths.get(APPLICATIONS_JSON_PATH);
        if (!Files.exists(path)) {
            return new ArrayList<>();
        }
        String jsonContent = Files.readString(path);
        if (jsonContent == null || jsonContent.isBlank()) {
            return new ArrayList<>();
        }
        List<Application> list = gson.fromJson(jsonContent,
                new TypeToken<List<Application>>(){}.getType());
        return list != null ? list : new ArrayList<>();
    }

    /**
     * 根据申请人 ID 查找所有申请
     */
    public static List<Application> getByApplicantId(String applicantId) {
        try {
            return getAllApplications().stream()
                    .filter(app -> app.getApplicantId().equals(applicantId))
                    .collect(Collectors.toList());
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 根据申请 ID 查找单个申请
     */
    public static Application getByApplicationId(String applicationId) {
        try {
            return getAllApplications().stream()
                    .filter(app -> app.getApplicationId().equals(applicationId))
                    .findFirst()
                    .orElse(null);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 添加一条新申请并写入 applications.json
     */
    public static void save(Application application) throws IOException {
        List<Application> apps = getAllApplications();
        apps.add(application);
        writeAll(apps);
    }

    /**
     * 更新一条申请（按 applicationId 匹配替换）
     */
    public static boolean update(Application updated) throws IOException {
        List<Application> apps = getAllApplications();
        boolean found = false;
        for (int i = 0; i < apps.size(); i++) {
            if (apps.get(i).getApplicationId().equals(updated.getApplicationId())) {
                apps.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) {
            writeAll(apps);
        }
        return found;
    }

    /**
     * 根据申请 ID 删除一条申请
     */
    public static boolean delete(String applicationId) throws IOException {
        List<Application> apps = getAllApplications();
        boolean removed = apps.removeIf(
                app -> app.getApplicationId().equals(applicationId));
        if (removed) {
            writeAll(apps);
        }
        return removed;
    }

    /**
     * 将完整列表写回 JSON 文件
     */
    private static void writeAll(List<Application> apps) throws IOException {
        Path path = Paths.get(APPLICATIONS_JSON_PATH);
        // 确保父目录存在
        if (path.getParent() != null && !Files.exists(path.getParent())) {
            Files.createDirectories(path.getParent());
        }
        Files.writeString(path, gson.toJson(apps));
    }
}