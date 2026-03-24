import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/reviewApplication")
public class ReviewApplicationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String status = request.getParameter("status");

        System.out.println("ID: " + id);
        System.out.println("Status: " + status);

        response.getWriter().println("Updated!");
    }
}
