public class ReviewApplicationServlet {

    public void reviewApplication(int id, String status) {
        System.out.println("Review request received.");
        System.out.println("Application ID: " + id);
        System.out.println("Updated status: " + status);

        // In the next version, this method will update applications.json
        // and save the latest review result.
    }

    public boolean isValidStatus(String status) {
        return "Approved".equals(status) || "Rejected".equals(status) || "Pending".equals(status);
    }
}
