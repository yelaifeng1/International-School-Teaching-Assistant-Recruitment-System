package com.group50.tasystem;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/reviewApplication")
public class ReviewApplicationServlet extends HttpServlet {
    private String getDataPath(HttpServletRequest request) {
        // 使用 target/classes/data 目录存储数据
        return System.getProperty("user.dir") + "/target/classes/data/applications.json";
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String JSON_FILE_PATH = getDataPath(request);
        // 1. 接收并校验参数
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");

        // Validate parameters
        if (idStr == null || newStatus == null) {
            response.sendRedirect("/application-review/reviewApplications.jsp?error=Parameters cannot be empty");
            return;
        }
        // Only allow 3 valid statuses
        if (!newStatus.equals("Pending") && !newStatus.equals("Approved") && !newStatus.equals("Rejected")) {
            response.sendRedirect("/application-review/reviewApplications.jsp?error=Invalid status value");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("/application-review/reviewApplications.jsp?error=Invalid application ID");
            return;
        }

        // 2. 读取JSON文件
        try {
            // 确保文件存在
            File file = new File(JSON_FILE_PATH);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                Files.write(Paths.get(JSON_FILE_PATH), "[]".getBytes(StandardCharsets.UTF_8));
            }
            
            String jsonContent = new String(Files.readAllBytes(Paths.get(JSON_FILE_PATH)), StandardCharsets.UTF_8);
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
                response.sendRedirect("/application-review/reviewApplications.jsp?error=Application not found");
                return;
            }

            // 4. Write updated content back to JSON file
            FileWriter fileWriter = new FileWriter(JSON_FILE_PATH, StandardCharsets.UTF_8);
            fileWriter.write(applicationArray.toString(4)); // 4 is for formatted indentation
            fileWriter.flush();
            fileWriter.close();

            // 5. Redirect back to application list
            response.sendRedirect("/application-review/reviewApplications.jsp?success=Review completed successfully");

        } catch (Exception e) {
            // Exception handling to avoid server 500 error
            e.printStackTrace();
            response.sendRedirect("/application-review/reviewApplications.jsp?error=System error: " + e.getMessage());
        }
    }
}
