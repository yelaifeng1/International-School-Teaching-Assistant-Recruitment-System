package com.group50.tasystem.profile.dao

import com.group50.model.Applicant;
import com.group50.util.JsonUtil;
import java.util.*;

public class ApplicantDAO {
    private static final String FILE = "applicants.json";

    public List<Applicant> getAll() {
        List<Applicant> list = JsonUtil.read(FILE, List.class);
        return list == null ? new ArrayList<>() : list;
    }

    public Applicant getByStudentId(String studentId) {
        for (Applicant a : getAll()) {
            if (studentId.equals(a.getStudentId())) return a;
        }
        return null;
    }

    public void save(Applicant applicant) {
        List<Applicant> list = getAll();
        list.removeIf(a -> applicant.getStudentId().equals(a.getStudentId()));
        list.add(applicant);
        JsonUtil.write(FILE, list);
    }
}