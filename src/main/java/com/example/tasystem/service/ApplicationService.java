package com.example.tasystem.service;

import com.example.tasystem.dao.ApplicantDAO;
import com.example.tasystem.dao.ApplicationDAO;
import com.example.tasystem.dao.JobDAO;
import com.example.tasystem.dao.WorkloadDAO;
import com.example.tasystem.model.Applicant;
import com.example.tasystem.model.Application;
import com.example.tasystem.model.ApplicationView;
import com.example.tasystem.model.Job;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;
import com.example.tasystem.model.Workload;
import com.example.tasystem.model.WorkloadView;
import com.example.tasystem.util.Roles;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

public class ApplicationService {
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_APPROVED = "APPROVED";
    public static final String STATUS_REJECTED = "REJECTED";
    public static final String WORKLOAD_ACTIVE = "ACTIVE";

    private final ApplicantDAO applicantDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;
    private final WorkloadDAO workloadDAO;
    private final JobService jobService;

    public ApplicationService(ApplicantDAO applicantDAO,
                              JobDAO jobDAO,
                              ApplicationDAO applicationDAO,
                              WorkloadDAO workloadDAO,
                              JobService jobService) {
        this.applicantDAO = applicantDAO;
        this.jobDAO = jobDAO;
        this.applicationDAO = applicationDAO;
        this.workloadDAO = workloadDAO;
        this.jobService = jobService;
    }

    public ServiceResult<Application> submitApplication(User applicantUser, String jobId, String personalStatement) {
        if (!Roles.isApplicant(applicantUser.getRole())) {
            return ServiceResult.failure("Only TA applicants can submit applications.");
        }

        Optional<Applicant> applicantOptional = applicantDAO.findByUserId(applicantUser.getUserId());
        if (applicantOptional.isEmpty() || !applicantOptional.get().isComplete()) {
            return ServiceResult.failure("Please complete your applicant profile before applying.");
        }

        Optional<Job> jobOptional = jobDAO.findById(jobId);
        if (jobOptional.isEmpty()) {
            return ServiceResult.failure("The selected job could not be found.");
        }

        Job job = jobService.normalizeStatus(jobOptional.get());
        if (!jobService.isOpenForApplications(job)) {
            return ServiceResult.failure("This job is no longer open for applications.");
        }

        Applicant applicant = applicantOptional.get();
        boolean exists = applicationDAO.findByApplicantId(applicant.getApplicantId()).stream()
                .anyMatch(application -> Objects.equals(application.getJobId(), jobId));
        if (exists) {
            return ServiceResult.failure("You have already applied for this job.");
        }

        String statement = personalStatement == null ? "" : personalStatement.trim();
        if (statement.isBlank()) {
            return ServiceResult.failure("Please provide a short personal statement.");
        }

        Application application = new Application();
        application.setApplicationId(applicationDAO.nextApplicationId());
        application.setApplicantId(applicant.getApplicantId());
        application.setJobId(jobId);
        application.setApplyDate(LocalDate.now().toString());
        application.setPersonalStatement(statement);
        application.setStatus(STATUS_PENDING);
        application.setReviewerComment("");
        applicationDAO.save(application);

        return ServiceResult.success("Application submitted successfully.", application);
    }

    public List<ApplicationView> listApplicantApplications(User applicantUser) {
        Optional<Applicant> applicantOptional = applicantDAO.findByUserId(applicantUser.getUserId());
        if (applicantOptional.isEmpty()) {
            return List.of();
        }

        Applicant applicant = applicantOptional.get();
        return applicationDAO.findByApplicantId(applicant.getApplicantId()).stream()
                .map(application -> toApplicationView(application, applicant, jobDAO.findById(application.getJobId()).orElse(null)))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(ApplicationView::getApplyDate).reversed())
                .collect(Collectors.toList());
    }

    public List<ApplicationView> listManagerApplications(User manager) {
        Set<String> managerJobIds = jobDAO.findByCreator(manager.getUserId()).stream()
                .map(Job::getJobId)
                .collect(Collectors.toSet());

        return applicationDAO.findAll().stream()
                .filter(application -> managerJobIds.contains(application.getJobId()))
                .map(application -> toApplicationView(
                        application,
                        applicantDAO.findByApplicantId(application.getApplicantId()).orElse(null),
                        jobDAO.findById(application.getJobId()).orElse(null)
                ))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(ApplicationView::getApplyDate).reversed())
                .collect(Collectors.toList());
    }

    public List<ApplicationView> listAllApplications() {
        return applicationDAO.findAll().stream()
                .map(application -> toApplicationView(
                        application,
                        applicantDAO.findByApplicantId(application.getApplicantId()).orElse(null),
                        jobDAO.findById(application.getJobId()).orElse(null)
                ))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(ApplicationView::getApplyDate).reversed())
                .collect(Collectors.toList());
    }

    public List<WorkloadView> listApplicantAssignments(User applicantUser) {
        Optional<Applicant> applicantOptional = applicantDAO.findByUserId(applicantUser.getUserId());
        if (applicantOptional.isEmpty()) {
            return List.of();
        }

        return workloadDAO.findByApplicantId(applicantOptional.get().getApplicantId()).stream()
                .map(this::toWorkloadView)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public List<WorkloadView> listManagerAssignments(User manager) {
        Set<String> managerJobIds = jobDAO.findByCreator(manager.getUserId()).stream()
                .map(Job::getJobId)
                .collect(Collectors.toSet());

        return workloadDAO.findAll().stream()
                .filter(workload -> managerJobIds.contains(workload.getJobId()))
                .map(this::toWorkloadView)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public ServiceResult<Application> reviewApplication(User manager, String applicationId, String targetStatus, String comment) {
        Optional<Application> applicationOptional = applicationDAO.findById(applicationId);
        if (applicationOptional.isEmpty()) {
            return ServiceResult.failure("Application not found.");
        }

        Application application = applicationOptional.get();
        Optional<Job> jobOptional = jobDAO.findById(application.getJobId());
        if (jobOptional.isEmpty()) {
            return ServiceResult.failure("The related job could not be found.");
        }

        Job job = jobService.normalizeStatus(jobOptional.get());
        if (!Objects.equals(job.getCreatedByUserId(), manager.getUserId())) {
            return ServiceResult.failure("You can only review applications for your own jobs.");
        }

        String normalizedStatus = normalizeStatus(targetStatus);
        if (normalizedStatus == null) {
            return ServiceResult.failure("Unsupported review status.");
        }

        if (STATUS_APPROVED.equals(normalizedStatus)) {
            boolean anotherApproved = applicationDAO.findByJobId(job.getJobId()).stream()
                    .anyMatch(existing -> !Objects.equals(existing.getApplicationId(), applicationId)
                            && STATUS_APPROVED.equalsIgnoreCase(normalizeStatus(existing.getStatus())));
            if (anotherApproved) {
                return ServiceResult.failure("This job already has an approved applicant.");
            }
        }

        application.setStatus(normalizedStatus);
        application.setReviewerComment(comment == null ? "" : comment.trim());
        applicationDAO.save(application);

        if (STATUS_APPROVED.equals(normalizedStatus)) {
            Workload workload = workloadDAO.findByApplicationId(application.getApplicationId()).orElseGet(Workload::new);
            if (workload.getAssignmentId() == null || workload.getAssignmentId().isBlank()) {
                workload.setAssignmentId(workloadDAO.nextAssignmentId());
            }
            workload.setApplicationId(application.getApplicationId());
            workload.setApplicantId(application.getApplicantId());
            workload.setJobId(application.getJobId());
            workload.setAssignedAt(LocalDate.now().toString());
            workload.setStatus(WORKLOAD_ACTIVE);
            workloadDAO.save(workload);

            job.setStatus(JobService.STATUS_FILLED);
            jobDAO.save(job);

            List<Application> allApplications = applicationDAO.findAll();
            for (Application sibling : allApplications) {
                if (Objects.equals(sibling.getJobId(), application.getJobId())
                        && !Objects.equals(sibling.getApplicationId(), application.getApplicationId())) {
                    sibling.setStatus(STATUS_REJECTED);
                    if (sibling.getReviewerComment() == null || sibling.getReviewerComment().isBlank()) {
                        sibling.setReviewerComment("Position filled by another applicant.");
                    }
                }
            }
            applicationDAO.saveAll(allApplications);
        } else {
            workloadDAO.deleteByApplicationId(application.getApplicationId());
            boolean hasApproved = applicationDAO.findByJobId(job.getJobId()).stream()
                    .anyMatch(existing -> STATUS_APPROVED.equalsIgnoreCase(normalizeStatus(existing.getStatus())));
            if (!hasApproved) {
                job.setStatus(jobService.statusForReopenedJob(job));
                jobDAO.save(job);
            }
        }

        return ServiceResult.success("Application status updated.", application);
    }

    public int countPendingForManager(User manager) {
        return (int) listManagerApplications(manager).stream()
                .filter(view -> STATUS_PENDING.equals(view.getStatus()))
                .count();
    }

    public boolean hasApplied(User applicantUser, String jobId) {
        Optional<Applicant> applicantOptional = applicantDAO.findByUserId(applicantUser.getUserId());
        if (applicantOptional.isEmpty()) {
            return false;
        }

        return applicationDAO.findByApplicantId(applicantOptional.get().getApplicantId()).stream()
                .anyMatch(application -> Objects.equals(application.getJobId(), jobId));
    }

    private ApplicationView toApplicationView(Application application, Applicant applicant, Job job) {
        if (job == null) {
            return null;
        }

        ApplicationView view = new ApplicationView();
        view.setApplicationId(application.getApplicationId());
        view.setApplicantId(application.getApplicantId());
        view.setApplicantName(applicant == null || applicant.getFullName() == null || applicant.getFullName().isBlank()
                ? "Unknown Applicant"
                : applicant.getFullName());
        view.setStudentId(applicant == null ? "" : applicant.getStudentId());
        view.setJobId(job.getJobId());
        view.setCourseCode(job.getCourseCode());
        view.setCourseName(job.getCourseName());
        view.setLecturerName(job.getLecturerName());
        view.setApplyDate(application.getApplyDate());
        view.setPersonalStatement(application.getPersonalStatement());
        view.setStatus(normalizeStatus(application.getStatus()));
        view.setReviewerComment(application.getReviewerComment());
        return view;
    }

    private WorkloadView toWorkloadView(Workload workload) {
        Optional<Job> jobOptional = jobDAO.findById(workload.getJobId());
        if (jobOptional.isEmpty()) {
            return null;
        }

        Job job = jobOptional.get();
        WorkloadView view = new WorkloadView();
        view.setAssignmentId(workload.getAssignmentId());
        view.setJobId(job.getJobId());
        view.setCourseCode(job.getCourseCode());
        view.setCourseName(job.getCourseName());
        view.setLecturerName(job.getLecturerName());
        view.setAssignedAt(workload.getAssignedAt());
        view.setStatus(workload.getStatus());
        return view;
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return STATUS_PENDING;
        }

        switch (status.trim().toUpperCase(Locale.ROOT)) {
            case STATUS_PENDING:
                return STATUS_PENDING;
            case STATUS_APPROVED:
                return STATUS_APPROVED;
            case STATUS_REJECTED:
                return STATUS_REJECTED;
            default:
                return null;
        }
    }
}
