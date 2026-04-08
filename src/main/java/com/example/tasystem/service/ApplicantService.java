package com.example.tasystem.service;

import com.example.tasystem.dao.ApplicantDAO;
import com.example.tasystem.dao.UserDAO;
import com.example.tasystem.model.Applicant;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;

public class ApplicantService {
    private final ApplicantDAO applicantDAO;
    private final UserDAO userDAO;

    public ApplicantService(ApplicantDAO applicantDAO, UserDAO userDAO) {
        this.applicantDAO = applicantDAO;
        this.userDAO = userDAO;
    }

    public Applicant getOrCreateProfile(User user) {
        return applicantDAO.findByUserId(user.getUserId()).orElseGet(() -> {
            Applicant applicant = new Applicant();
            applicant.setUserId(user.getUserId());
            applicant.setEmail(user.getEmail());
            applicant.setFullName(user.getEffectiveDisplayName());
            return applicant;
        });
    }

    public ServiceResult<Applicant> saveProfile(User user,
                                                String fullName,
                                                String studentId,
                                                String email,
                                                String phone,
                                                String skills,
                                                String availability,
                                                String cvPath) {
        String normalizedName = normalize(fullName);
        String normalizedStudentId = normalize(studentId);
        String normalizedEmail = normalize(email);

        if (normalizedName.isBlank()) {
            return ServiceResult.failure("Full name is required.");
        }

        if (normalizedStudentId.isBlank()) {
            return ServiceResult.failure("Student ID is required.");
        }

        if (normalizedEmail.isBlank() || !normalizedEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return ServiceResult.failure("Please provide a valid email address.");
        }

        Applicant applicant = applicantDAO.findByUserId(user.getUserId()).orElseGet(Applicant::new);
        if (applicant.getApplicantId() == null || applicant.getApplicantId().isBlank()) {
            applicant.setApplicantId(applicantDAO.nextApplicantId());
        }

        applicant.setUserId(user.getUserId());
        applicant.setFullName(normalizedName);
        applicant.setStudentId(normalizedStudentId);
        applicant.setEmail(normalizedEmail);
        applicant.setPhone(normalize(phone));
        applicant.setSkills(normalize(skills));
        applicant.setAvailability(normalize(availability));
        applicant.setCvPath(normalize(cvPath));
        applicantDAO.save(applicant);

        user.setEmail(normalizedEmail);
        user.setDisplayName(normalizedName);
        userDAO.save(user);

        return ServiceResult.success("Profile saved successfully.", applicant);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
