package com.example.tasystem.service;

import com.example.tasystem.dao.ApplicantDAO;
import com.example.tasystem.dao.ApplicationDAO;
import com.example.tasystem.dao.JobDAO;
import com.example.tasystem.dao.UserDAO;
import com.example.tasystem.dao.WorkloadDAO;
import com.example.tasystem.model.Applicant;
import com.example.tasystem.model.Application;
import com.example.tasystem.model.Job;
import com.example.tasystem.model.User;
import com.example.tasystem.util.Roles;
import com.example.tasystem.util.StorageResolver;
import com.google.gson.JsonParser;

import javax.servlet.ServletContext;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;

public class SeedDataService {
    private final ServletContext context;
    private final UserDAO userDAO;
    private final ApplicantDAO applicantDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;
    private final WorkloadDAO workloadDAO;

    public SeedDataService(ServletContext context,
                           UserDAO userDAO,
                           ApplicantDAO applicantDAO,
                           JobDAO jobDAO,
                           ApplicationDAO applicationDAO,
                           WorkloadDAO workloadDAO) {
        this.context = context;
        this.userDAO = userDAO;
        this.applicantDAO = applicantDAO;
        this.jobDAO = jobDAO;
        this.applicationDAO = applicationDAO;
        this.workloadDAO = workloadDAO;
    }

    public void initialize() {
        ensureUsers();
        ensureApplicants();
        ensureJobs();
        ensureApplications();
        ensureWorkload();
    }

    private void ensureUsers() {
        if (needsSeed("users.json")) {
            userDAO.save(new User("U001", "ta", "ta123456", Roles.APPLICANT, "ta@example.com", "Alice Applicant", LocalDate.now().toString()));
            userDAO.save(new User("U002", "mo", "mo123456", Roles.MANAGER, "mo@example.com", "Mason Organiser", LocalDate.now().toString()));
            userDAO.save(new User("U003", "admin", "admin123456", Roles.ADMIN, "admin@example.com", "Admin Team", LocalDate.now().toString()));
        }
    }

    private void ensureApplicants() {
        if (needsSeed("applicants.json")) {
            Applicant applicant = new Applicant();
            applicant.setApplicantId("AP001");
            applicant.setUserId("U001");
            applicant.setFullName("Alice Applicant");
            applicant.setStudentId("S1001");
            applicant.setEmail("ta@example.com");
            applicant.setPhone("+44 7000 000001");
            applicant.setSkills("Java, tutoring, communication");
            applicant.setAvailability("Mon-Wed afternoons");
            applicant.setCvPath("CV ready on request");
            applicantDAO.save(applicant);
        }
    }

    private void ensureJobs() {
        if (needsSeed("jobs.json")) {
            Job job1 = new Job();
            job1.setJobId("J001");
            job1.setCourseCode("COMP1010");
            job1.setCourseName("Programming Foundations");
            job1.setLecturerName("Mason Organiser");
            job1.setRequirements("Support lab sessions, answer student questions, and mark formative exercises.");
            job1.setDeadline(LocalDate.now().plusDays(10).toString());
            job1.setStatus(JobService.STATUS_OPEN);
            job1.setCreatedByUserId("U002");
            job1.setCreatedAt(LocalDate.now().toString());
            jobDAO.save(job1);

            Job job2 = new Job();
            job2.setJobId("J002");
            job2.setCourseCode("COMP2020");
            job2.setCourseName("Database Systems");
            job2.setLecturerName("Mason Organiser");
            job2.setRequirements("Assist with SQL labs, prepare tutorial material, and support office hours.");
            job2.setDeadline(LocalDate.now().plusDays(14).toString());
            job2.setStatus(JobService.STATUS_OPEN);
            job2.setCreatedByUserId("U002");
            job2.setCreatedAt(LocalDate.now().toString());
            jobDAO.save(job2);
        }
    }

    private void ensureApplications() {
        if (needsSeed("applications.json")) {
            Application application = new Application();
            application.setApplicationId("APP001");
            application.setApplicantId("AP001");
            application.setJobId("J001");
            application.setApplyDate(LocalDate.now().minusDays(1).toString());
            application.setPersonalStatement("I have prior tutoring experience and can support introductory programming labs.");
            application.setStatus(ApplicationService.STATUS_PENDING);
            application.setReviewerComment("");
            applicationDAO.save(application);
        }
    }

    private void ensureWorkload() {
        if (needsSeed("workload.json")) {
            writeEmptyArray(StorageResolver.dataDirectory(context).resolve("workload.json"));
        }
    }

    private boolean needsSeed(String fileName) {
        Path path = StorageResolver.dataDirectory(context).resolve(fileName);
        if (!Files.exists(path)) {
            return true;
        }

        try {
            String content = Files.readString(path, StandardCharsets.UTF_8).trim();
            if (content.isEmpty()) {
                return true;
            }
            return !JsonParser.parseString(content).isJsonArray();
        } catch (Exception e) {
            return true;
        }
    }

    private void writeEmptyArray(Path path) {
        try {
            Files.writeString(path, "[]", StandardCharsets.UTF_8);
        } catch (Exception e) {
            throw new IllegalStateException("Failed to initialize workload data.", e);
        }
    }
}
