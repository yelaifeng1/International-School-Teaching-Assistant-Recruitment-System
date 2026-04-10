package com.example.tasystem;

import com.example.tasystem.util.StorageResolver;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/reviewApplication")
public class ReviewApplicationServlet extends HttpServlet {
    private Path getDataPath(HttpServletRequest request) {
        // 使用 StorageResolver 获取数据目录
        return StorageResolver.dataDirectory(getServletContext()).resolve("applications.json");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Path jsonFilePath = getDataPath(request);
        // 1. 接收并校验参数
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");

        // Validate parameters
        if (idStr == null || newStatus == null) {
            response.sendRedirect("/mo/review-applications?error=Parameters cannot be empty");
            return;
        }
        // Only allow 3 valid statuses
        if (!newStatus.equals("Pending") && !newStatus.equals("Approved") && !newStatus.equals("Rejected")) {
            response.sendRedirect("/mo/review-applications?error=Invalid status value");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("/mo/review-applications?error=Invalid application ID");
            return;
        }

        // 2. 读取JSON文件
        try {
            // 确保文件存在
            if (!Files.exists(jsonFilePath)) {
                Files.createDirectories(jsonFilePath.getParent());
                Files.write(jsonFilePath, "[]".getBytes(StandardCharsets.UTF_8));
            }
            
            String jsonContent = new String(Files.readAllBytes(jsonFilePath), StandardCharsets.UTF_8);
            JSONArray applicationArray = new JSONArray(jsonContent);

            // 3. 找到对应ID的申请，修改状态
            boolean isUpdated = false;
            for (int i = 0; i < applicationArray.length(); i++) {
                JSONObject application = applicationArray.getJSONObject(i);
                if (application.getInt("id") == targetId) {
                    application.put("status", newStatus);
                    isUpdated = true;
                    break;
                }
            }

            if (!isUpdated) {
                response.sendRedirect("/mo/review-applications?error=Application not found");
                return;
            }

            // 4. Write updated content back to JSON file
            FileWriter fileWriter = new FileWriter(jsonFilePath.toFile(), StandardCharsets.UTF_8);
            fileWriter.write(applicationArray.toString(4)); // 4 is for formatted indentation
            fileWriter.flush();
            fileWriter.close();

            // 5. Redirect back to application list
            response.sendRedirect("/mo/review-applications?success=Review completed successfully");

        } catch (Exception e) {
            // Exception handling to avoid server 500 error
            e.printStackTrace();
            response.sendRedirect("/mo/review-applications?error=System error: " + e.getMessage());
        }
    }
}
