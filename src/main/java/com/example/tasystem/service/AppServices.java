package com.example.tasystem.service;

import com.example.tasystem.dao.ApplicantDAO;
import com.example.tasystem.dao.ApplicationDAO;
import com.example.tasystem.dao.JobDAO;
import com.example.tasystem.dao.UserDAO;
import com.example.tasystem.dao.WorkloadDAO;

import javax.servlet.ServletContext;

public class AppServices {
    public static final String ATTRIBUTE = "appServices";

    private final UserDAO userDAO;
    private final ApplicantDAO applicantDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;
    private final WorkloadDAO workloadDAO;
    private final AuthService authService;
    private final ApplicantService applicantService;
    private final JobService jobService;
    private final ApplicationService applicationService;
    private final SeedDataService seedDataService;

    public AppServices(ServletContext context) {
        this.userDAO = new UserDAO(context);
        this.applicantDAO = new ApplicantDAO(context);
        this.jobDAO = new JobDAO(context);
        this.applicationDAO = new ApplicationDAO(context);
        this.workloadDAO = new WorkloadDAO(context);
        this.jobService = new JobService(jobDAO);
        this.authService = new AuthService(userDAO);
        this.applicantService = new ApplicantService(applicantDAO, userDAO);
        this.applicationService = new ApplicationService(applicantDAO, jobDAO, applicationDAO, workloadDAO, jobService);
        this.seedDataService = new SeedDataService(context, userDAO, applicantDAO, jobDAO, applicationDAO, workloadDAO);
    }

    public void initialize() {
        seedDataService.initialize();
    }

    public UserDAO getUserDAO() {
        return userDAO;
    }

    public ApplicantDAO getApplicantDAO() {
        return applicantDAO;
    }

    public JobDAO getJobDAO() {
        return jobDAO;
    }

    public ApplicationDAO getApplicationDAO() {
        return applicationDAO;
    }

    public WorkloadDAO getWorkloadDAO() {
        return workloadDAO;
    }

    public AuthService getAuthService() {
        return authService;
    }

    public ApplicantService getApplicantService() {
        return applicantService;
    }

    public JobService getJobService() {
        return jobService;
    }

    public ApplicationService getApplicationService() {
        return applicationService;
    }
}
