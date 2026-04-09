package com.example.tasystem.service;

import com.example.tasystem.dao.JobDAO;
import com.example.tasystem.model.Job;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

public class JobService {
    public static final String STATUS_OPEN = "OPEN";
    public static final String STATUS_CLOSED = "CLOSED";
    public static final String STATUS_FILLED = "FILLED";

    private final JobDAO jobDAO;

    public JobService(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public List<Job> listOpenJobs() {
        return jobDAO.findAll().stream()
                .map(this::normalizeStatus)
                .filter(this::isOpenForApplications)
                .sorted(Comparator.comparing(Job::getDeadline))
                .collect(Collectors.toList());
    }

    public List<Job> listAllJobs() {
        return jobDAO.findAll().stream()
                .map(this::normalizeStatus)
                .sorted(Comparator.comparing(Job::getDeadline))
                .collect(Collectors.toList());
    }

    public List<Job> listJobsForManager(User manager) {
        return jobDAO.findByCreator(manager.getUserId()).stream()
                .map(this::normalizeStatus)
                .collect(Collectors.toList());
    }

    public Optional<Job> findById(String jobId) {
        return jobDAO.findById(jobId).map(this::normalizeStatus);
    }

    public ServiceResult<Job> createJob(User manager,
                                        String courseCode,
                                        String courseName,
                                        String requirements,
                                        String deadline) {
        String normalizedCourseCode = normalize(courseCode).toUpperCase(Locale.ROOT);
        String normalizedCourseName = normalize(courseName);
        String normalizedRequirements = normalize(requirements);
        String normalizedDeadline = normalize(deadline);

        if (normalizedCourseCode.isBlank() || normalizedCourseName.isBlank() || normalizedRequirements.isBlank()) {
            return ServiceResult.failure("Course code, course name and requirements are required.");
        }

        LocalDate parsedDeadline;
        try {
            parsedDeadline = LocalDate.parse(normalizedDeadline);
        } catch (Exception e) {
            return ServiceResult.failure("Please choose a valid application deadline.");
        }

        if (parsedDeadline.isBefore(LocalDate.now())) {
            return ServiceResult.failure("Application deadline cannot be in the past.");
        }

        Job job = new Job();
        job.setJobId(jobDAO.nextJobId());
        job.setCourseCode(normalizedCourseCode);
        job.setCourseName(normalizedCourseName);
        job.setLecturerName(manager.getEffectiveDisplayName());
        job.setRequirements(normalizedRequirements);
        job.setDeadline(parsedDeadline.toString());
        job.setStatus(STATUS_OPEN);
        job.setCreatedByUserId(manager.getUserId());
        job.setCreatedAt(LocalDate.now().toString());
        jobDAO.save(job);

        return ServiceResult.success("Job posted successfully.", job);
    }

    public ServiceResult<Job> updateStatus(User manager, String jobId, String requestedStatus) {
        Optional<Job> existing = jobDAO.findById(jobId);
        if (existing.isEmpty()) {
            return ServiceResult.failure("Job not found.");
        }

        Job job = normalizeStatus(existing.get());
        if (!manager.getUserId().equals(job.getCreatedByUserId())) {
            return ServiceResult.failure("You can only manage jobs created by your own account.");
        }

        String status = normalizeStatusValue(requestedStatus);
        if (status == null) {
            return ServiceResult.failure("Unsupported job status.");
        }

        job.setStatus(status);
        jobDAO.save(job);
        return ServiceResult.success("Job status updated.", job);
    }

    public boolean isOpenForApplications(Job job) {
        if (!STATUS_OPEN.equals(job.getStatus())) {
            return false;
        }

        try {
            return !LocalDate.parse(job.getDeadline()).isBefore(LocalDate.now());
        } catch (Exception e) {
            return false;
        }
    }

    public String statusForReopenedJob(Job job) {
        try {
            return LocalDate.parse(job.getDeadline()).isBefore(LocalDate.now()) ? STATUS_CLOSED : STATUS_OPEN;
        } catch (Exception e) {
            return STATUS_CLOSED;
        }
    }

    public Job save(Job job) {
        return jobDAO.save(job);
    }

    public Job normalizeStatus(Job job) {
        String normalized = normalizeStatusValue(job.getStatus());
        job.setStatus(normalized == null ? STATUS_OPEN : normalized);
        return job;
    }

    public String normalizeStatusValue(String status) {
        if (status == null || status.isBlank()) {
            return null;
        }

        switch (status.trim().toUpperCase(Locale.ROOT)) {
            case STATUS_OPEN:
                return STATUS_OPEN;
            case STATUS_CLOSED:
                return STATUS_CLOSED;
            case STATUS_FILLED:
                return STATUS_FILLED;
            default:
                return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
