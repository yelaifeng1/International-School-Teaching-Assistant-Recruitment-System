package com.example.tasystem.dao;

import com.example.tasystem.model.Job;
import com.example.tasystem.util.IdGenerator;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

public class JobDAO extends JsonFileDao<Job> {
    public JobDAO(ServletContext context) {
        super(context, "jobs.json", new TypeToken<List<Job>>() {
        }.getType());
    }

    public List<Job> findAll() {
        return readAll();
    }

    public Optional<Job> findById(String jobId) {
        return findAll().stream()
                .filter(job -> Objects.equals(job.getJobId(), jobId))
                .findFirst();
    }

    public List<Job> findByCreator(String creatorId) {
        return findAll().stream()
                .filter(job -> Objects.equals(job.getCreatedByUserId(), creatorId))
                .sorted(Comparator.comparing(Job::getDeadline).reversed())
                .collect(Collectors.toList());
    }

    public Job save(Job job) {
        List<Job> jobs = findAll();
        jobs.removeIf(existing -> Objects.equals(existing.getJobId(), job.getJobId()));
        jobs.add(job);
        jobs.sort(Comparator.comparing(Job::getJobId));
        writeAll(jobs);
        return job;
    }

    public String nextJobId() {
        return IdGenerator.nextId("J", findAll().stream().map(Job::getJobId).collect(Collectors.toList()));
    }
}
