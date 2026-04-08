package com.example.tasystem.dao;

import com.example.tasystem.model.Workload;
import com.example.tasystem.util.IdGenerator;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

public class WorkloadDAO extends JsonFileDao<Workload> {
    public WorkloadDAO(ServletContext context) {
        super(context, "workload.json", new TypeToken<List<Workload>>() {
        }.getType());
    }

    public List<Workload> findAll() {
        return readAll();
    }

    public Optional<Workload> findByApplicationId(String applicationId) {
        return findAll().stream()
                .filter(workload -> Objects.equals(workload.getApplicationId(), applicationId))
                .findFirst();
    }

    public List<Workload> findByApplicantId(String applicantId) {
        return findAll().stream()
                .filter(workload -> Objects.equals(workload.getApplicantId(), applicantId))
                .sorted(Comparator.comparing(Workload::getAssignedAt).reversed())
                .collect(Collectors.toList());
    }

    public Workload save(Workload workload) {
        List<Workload> workloads = findAll();
        workloads.removeIf(existing -> Objects.equals(existing.getAssignmentId(), workload.getAssignmentId()));
        workloads.add(workload);
        workloads.sort(Comparator.comparing(Workload::getAssignmentId));
        writeAll(workloads);
        return workload;
    }

    public void deleteByApplicationId(String applicationId) {
        List<Workload> workloads = findAll();
        workloads.removeIf(workload -> Objects.equals(workload.getApplicationId(), applicationId));
        writeAll(workloads);
    }

    public String nextAssignmentId() {
        return IdGenerator.nextId("WL", findAll().stream().map(Workload::getAssignmentId).collect(Collectors.toList()));
    }
}
