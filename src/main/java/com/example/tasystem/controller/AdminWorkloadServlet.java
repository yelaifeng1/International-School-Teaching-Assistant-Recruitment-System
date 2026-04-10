package com.example.tasystem.controller;

import com.example.tasystem.model.User;
import com.example.tasystem.model.WorkloadView;
import com.example.tasystem.util.Roles;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/admin/workload")
public class AdminWorkloadServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = services().getAuthService().findAllUsers();
        List<User> applicantUsers = users.stream()
                .filter(user -> Roles.isApplicant(user.getRole()))
                .collect(Collectors.toList());

        String requestedTaUserId = trimToNull(request.getParameter("taUserId"));
        Optional<User> selectedTaOptional = applicantUsers.stream()
                .filter(user -> requestedTaUserId != null && requestedTaUserId.equals(user.getUserId()))
                .findFirst();

        String selectedTaUserId = requestedTaUserId;
        if (selectedTaOptional.isEmpty() && requestedTaUserId == null && !applicantUsers.isEmpty()) {
            User defaultTa = applicantUsers.get(0);
            selectedTaOptional = Optional.of(defaultTa);
            selectedTaUserId = defaultTa.getUserId();
        }

        List<WorkloadView> selectedTaAssignments = selectedTaOptional
                .map(taUser -> services().getApplicationService().listApplicantAssignments(taUser))
                .orElseGet(List::of);

        request.setAttribute("applicantUsers", applicantUsers);
        request.setAttribute("selectedTaUser", selectedTaOptional.orElse(null));
        request.setAttribute("selectedTaUserId", selectedTaUserId);
        request.setAttribute("selectedTaAssignments", selectedTaAssignments);
        render("admin/workload.jsp", request, response);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}