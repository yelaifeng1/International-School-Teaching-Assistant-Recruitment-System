package com.example.tasystem.dao;

import com.example.tasystem.model.Applicant;
import com.example.tasystem.util.IdGenerator;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletContext;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

public class ApplicantDAO extends JsonFileDao<Applicant> {
    public ApplicantDAO(ServletContext context) {
        super(context, "applicants.json", new TypeToken<List<Applicant>>() {
        }.getType());
    }

    public List<Applicant> findAll() {
        return readAll();
    }

    public Optional<Applicant> findByApplicantId(String applicantId) {
        return findAll().stream()
                .filter(applicant -> Objects.equals(applicant.getApplicantId(), applicantId))
                .findFirst();
    }

    public Optional<Applicant> findByUserId(String userId) {
        return findAll().stream()
                .filter(applicant -> Objects.equals(applicant.getUserId(), userId))
                .findFirst();
    }

    public Applicant save(Applicant applicant) {
        List<Applicant> applicants = findAll();
        applicants.removeIf(existing -> Objects.equals(existing.getApplicantId(), applicant.getApplicantId()));
        applicants.add(applicant);
        applicants.sort(Comparator.comparing(Applicant::getApplicantId));
        writeAll(applicants);
        return applicant;
    }

    public String nextApplicantId() {
        return IdGenerator.nextId("AP", findAll().stream().map(Applicant::getApplicantId).collect(Collectors.toList()));
    }
}
