package com.group50.apply.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.group50.apply.model.Application;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ApplicationService {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final String DATA_FILE = "applications.json";

    /**
     * 获取 applications.json 的可写 File 对象。
     *
     * 优先策略：写入 src/main/resources/applications.json（源文件）。
     *   - user.dir 在 mvn 运行时指向项目根目录。
     *   - 这样 mvn package 打包时会把最新数据一并打入 WAR，实现真正的持久化。
     *
     * 回退策略：classpath 中的展开路径（打包后部署到外部容器时使用）。
     */
    private File getDataFile() {
        // 优先：开发环境下直接写 src/main/resources/
        File srcFile = new File(System.getProperty("user.dir"),
                "src/main/resources/" + DATA_FILE);
        if (srcFile.exists()) {
            return srcFile;
        }
        // 回退：classpath 中的路径（外部容器部署等情况）
        try {
            URL url = ApplicationService.class.getClassLoader().getResource(DATA_FILE);
            if (url == null) {
                throw new IllegalStateException("applications.json not found in classpath");
            }
            return new File(url.toURI());
        } catch (Exception e) {
            throw new RuntimeException("Cannot locate applications.json", e);
        }
    }

    /** 读取全部申请记录 */
    public List<Application> getAll() {
        try {
            File f = getDataFile();
            if (f.length() == 0) {
                return new ArrayList<>();
            }
            return MAPPER.readValue(f, new TypeReference<List<Application>>() {});
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /** 按 applicantId 筛选该 TA 的申请 */
    public List<Application> getByApplicantId(String applicantId) {
        return getAll().stream()
                .filter(a -> applicantId != null && applicantId.equals(a.getApplicantId()))
                .collect(Collectors.toList());
    }

    /** 新增一条申请并持久化 */
    public synchronized void save(Application app) {
        List<Application> all = getAll();
        all.add(app);
        try {
            MAPPER.writerWithDefaultPrettyPrinter().writeValue(getDataFile(), all);
        } catch (Exception e) {
            throw new RuntimeException("Failed to write applications.json", e);
        }
    }

    /**
     * Admin 全字段覆盖更新一条申请（按 applicationId 定位），返回是否找到
     */
    public synchronized boolean updateApplication(Application updated) {
        List<Application> all = getAll();
        for (int i = 0; i < all.size(); i++) {
            if (updated.getApplicationId().equals(all.get(i).getApplicationId())) {
                all.set(i, updated);
                try {
                    MAPPER.writerWithDefaultPrettyPrinter().writeValue(getDataFile(), all);
                } catch (Exception e) {
                    throw new RuntimeException("Failed to write applications.json", e);
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Admin 删除一条申请，返回是否找到并删除
     */
    public synchronized boolean deleteApplication(String applicationId) {
        List<Application> all = getAll();
        boolean removed = all.removeIf(a -> applicationId != null && applicationId.equals(a.getApplicationId()));
        if (!removed) return false;
        try {
            MAPPER.writerWithDefaultPrettyPrinter().writeValue(getDataFile(), all);
        } catch (Exception e) {
            throw new RuntimeException("Failed to write applications.json", e);
        }
        return true;
    }

    /**
     * 更新指定申请的审核状态，返回是否找到并修改成功
     * @param applicationId 要修改的申请 ID
     * @param newStatus     新状态（APPROVED / REJECTED / PENDING）
     */
    public synchronized boolean updateStatus(String applicationId, String newStatus) {
        List<Application> all = getAll();
        boolean found = false;
        for (Application a : all) {
            if (applicationId != null && applicationId.equals(a.getApplicationId())) {
                a.setStatus(newStatus);
                found = true;
                break;
            }
        }
        if (!found) return false;
        try {
            MAPPER.writerWithDefaultPrettyPrinter().writeValue(getDataFile(), all);
            return true;
        } catch (Exception e) {
            throw new RuntimeException("Failed to write applications.json", e);
        }
    }
}
