package com.example.tasystem.dao;

import com.example.tasystem.model.Application;
import com.example.tasystem.util.IdGenerator;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

public class ApplicationDAO extends JsonFileDao<Application> {
    public ApplicationDAO(ServletContext context) {
        super(context, "applications.json", new TypeToken<List<Application>>() {
        }.getType());
    }

    public List<Application> findAll() {
        return readAll();
    }

    public Optional<Application> findById(String applicationId) {
        return findAll().stream()
                .filter(application -> Objects.equals(application.getApplicationId(), applicationId))
                .findFirst();
    }

    public List<Application> findByApplicantId(String applicantId) {
        return findAll().stream()
                .filter(application -> Objects.equals(application.getApplicantId(), applicantId))
                .sorted(Comparator.comparing(Application::getApplyDate).reversed())
                .collect(Collectors.toList());
    }

    public List<Application> findByJobId(String jobId) {
        return findAll().stream()
                .filter(application -> Objects.equals(application.getJobId(), jobId))
                .sorted(Comparator.comparing(Application::getApplyDate).reversed())
                .collect(Collectors.toList());
    }

    public Application save(Application application) {
        List<Application> applications = findAll();
        applications.removeIf(existing -> Objects.equals(existing.getApplicationId(), application.getApplicationId()));
        applications.add(application);
        applications.sort(Comparator.comparing(Application::getApplicationId));
        writeAll(applications);
        return application;
    }

    public void saveAll(List<Application> applications) {
        writeAll(applications);
    }

    public String nextApplicationId() {
        return IdGenerator.nextId("APP", findAll().stream().map(Application::getApplicationId).collect(Collectors.toList()));
    }
}
