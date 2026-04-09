package com.example.tasystem.util;

public final class Roles {
    public static final String APPLICANT = "TA";
    public static final String MANAGER = "MO";
    public static final String ADMIN = "ADMIN";

    private Roles() {
    }

    public static String normalize(String role) {
        if (role == null || role.isBlank()) {
            return APPLICANT;
        }

        switch (role.trim().toUpperCase()) {
            case "TA":
            case "APPLICANT":
                return APPLICANT;
            case "MO":
            case "MANAGER":
                return MANAGER;
            case "ADMIN":
                return ADMIN;
            default:
                return APPLICANT;
        }
    }

    public static boolean isApplicant(String role) {
        return APPLICANT.equalsIgnoreCase(normalize(role));
    }

    public static boolean isManager(String role) {
        return MANAGER.equalsIgnoreCase(normalize(role));
    }

    public static boolean isAdmin(String role) {
        return ADMIN.equalsIgnoreCase(normalize(role));
    }

    public static String label(String role) {
        String normalized = normalize(role);
        if (APPLICANT.equals(normalized)) {
            return "Teaching Assistant Applicant";
        }
        if (MANAGER.equals(normalized)) {
            return "Module Organiser";
        }
        return "Administrator";
    }
}
