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

@WebServlet("/applicationStatus")
public class ApplicationStatusServlet extends HttpServlet {
    private String getDataPath(HttpServletRequest request, String filename) {
        // 使用 target/classes/data 目录存储数据
        return System.getProperty("user.dir") + "/target/classes/data/" + filename;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String APPLICATIONS_FILE = getDataPath(request, "applications.json");
        String applicantId = request.getParameter("applicantId");
        
        try {
            String jsonContent = new String(Files.readAllBytes(Paths.get(APPLICATIONS_FILE)), StandardCharsets.UTF_8);
            JSONArray allApplications = new JSONArray(jsonContent);
            
            // Filter applications for the current applicant
            JSONArray myApplications = new JSONArray();
            if (applicantId != null) {
                int id = Integer.parseInt(applicantId);
                for (int i = 0; i < allApplications.length(); i++) {
                    JSONObject app = allApplications.getJSONObject(i);
                    if (app.getInt("applicantId") == id) {
                        myApplications.put(app);
                    }
                }
            } else {
                // Return all if no applicant specified
                myApplications = allApplications;
            }
            
            request.setAttribute("applications", myApplications);
            request.getRequestDispatcher("/ta-applicant/status.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/ta-applicant/status.jsp?error=Failed to load applications");
        }
    }
}
