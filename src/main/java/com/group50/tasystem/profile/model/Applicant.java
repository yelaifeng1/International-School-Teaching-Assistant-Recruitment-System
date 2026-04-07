 package com.group50.tasystem.profile.model

public class Applicant {
    private String name;
    private String studentId;
    private String email;
    private String phone;
    private String skills;
    private String availability;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }
    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }
}