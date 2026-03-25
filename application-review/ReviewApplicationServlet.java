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
    // JSON文件的绝对路径，部署后请修改为你服务器上的真实路径
    private static final String JSON_FILE_PATH = "/your/project/path/application-review/applications.json";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 接收并校验参数
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");

        // 校验参数合法性
        if (idStr == null || newStatus == null) {
            response.sendRedirect("reviewApplications.jsp?error=参数不能为空");
            return;
        }
        // 只允许3种合法状态，和需求完全匹配
        if (!newStatus.equals("Pending") && !newStatus.equals("Approved") && !newStatus.equals("Rejected")) {
            response.sendRedirect("reviewApplications.jsp?error=非法的状态值");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("reviewApplications.jsp?error=非法的申请ID");
            return;
        }

        // 2. 读取JSON文件
        try {
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
                response.sendRedirect("reviewApplications.jsp?error=未找到对应申请");
                return;
            }

            // 4. 把修改后的内容写回JSON文件（核心回写逻辑）
            FileWriter fileWriter = new FileWriter(JSON_FILE_PATH, StandardCharsets.UTF_8);
            fileWriter.write(applicationArray.toString(4)); // 4是格式化缩进，方便查看
            fileWriter.flush();
            fileWriter.close();

            // 5. 审核完成，跳转回申请列表页，业务闭环
            response.sendRedirect("reviewApplications.jsp?success=审核成功");

        } catch (Exception e) {
            // 异常处理，避免服务器500错误
            e.printStackTrace();
            response.sendRedirect("reviewApplications.jsp?error=系统错误，请重试");
        }
    }
}
