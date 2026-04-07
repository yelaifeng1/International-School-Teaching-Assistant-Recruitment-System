package com.example.dao;

import com.example.model.Job;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class JobRepository {
    private static final String FILE_NAME = "jobs.json";
    private final ServletContext context;
    private final Gson gson;

    public JobRepository(ServletContext context) {
        this.context = context;
        this.gson = new GsonBuilder().setPrettyPrinting().create();
    }

    private String getFilePath() {
        String dataDir = context.getRealPath("/WEB-INF/data");
        File dir = new File(dataDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return dataDir + File.separator + FILE_NAME;
    }

    public List<Job> findAll() {
        String filePath = getFilePath();
        File file = new File(filePath);
        if (!file.exists()) {
            return new ArrayList<>();
        }
        try (Reader reader = new FileReader(file)) {
            Type listType = new TypeToken<List<Job>>(){}.getType();
            List<Job> jobs = gson.fromJson(reader, listType);
            return jobs == null ? new ArrayList<>() : jobs;
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void saveAll(List<Job> jobs) {
        String filePath = getFilePath();
        try (Writer writer = new FileWriter(filePath)) {
            gson.toJson(jobs, writer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void add(Job job) {
        List<Job> jobs = findAll();
        jobs.add(job);
        saveAll(jobs);
    }

    public Job findById(String jobId) {
        return findAll().stream()
                .filter(job -> job.getJobId().equals(jobId))
                .findFirst()
                .orElse(null);
    }
}