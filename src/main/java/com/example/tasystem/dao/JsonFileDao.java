package com.example.tasystem.dao;

import com.example.tasystem.util.JsonUtil;
import com.example.tasystem.util.StorageResolver;

import javax.servlet.ServletContext;
import java.io.Reader;
import java.io.Writer;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

public abstract class JsonFileDao<T> {
    private final ServletContext context;
    private final String fileName;
    private final Type listType;

    protected JsonFileDao(ServletContext context, String fileName, Type listType) {
        this.context = context;
        this.fileName = fileName;
        this.listType = listType;
    }

    protected synchronized List<T> readAll() {
        Path path = filePath();
        if (!Files.exists(path)) {
            return new ArrayList<>();
        }

        try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
            List<T> values = JsonUtil.gson().fromJson(reader, listType);
            return values == null ? new ArrayList<>() : new ArrayList<>(values);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    protected synchronized void writeAll(List<T> items) {
        Path path = filePath();
        try (Writer writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
            JsonUtil.gson().toJson(items, listType, writer);
        } catch (Exception e) {
            throw new IllegalStateException("Failed to write JSON file: " + path, e);
        }
    }

    public Path filePath() {
        return StorageResolver.dataDirectory(context).resolve(fileName);
    }
}
