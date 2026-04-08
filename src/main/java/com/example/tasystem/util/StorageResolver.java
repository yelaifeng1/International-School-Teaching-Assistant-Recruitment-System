package com.example.tasystem.util;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public final class StorageResolver {
    private StorageResolver() {
    }

    public static Path dataDirectory(ServletContext context) {
        return resolveDirectory(context, "ta.data.dir", "data", "/WEB-INF/data");
    }

    public static Path uploadDirectory(ServletContext context) {
        return resolveDirectory(context, "ta.upload.dir", "uploads", "/uploads");
    }

    private static Path resolveDirectory(ServletContext context, String propertyName, String projectFolder, String webFolder) {
        String override = System.getProperty(propertyName);
        if (override != null && !override.isBlank()) {
            return ensureDirectory(Paths.get(override));
        }

        Path workingDirectory = Paths.get(System.getProperty("user.dir", "."));
        if (Files.exists(workingDirectory.resolve("pom.xml"))) {
            return ensureDirectory(workingDirectory.resolve(projectFolder));
        }

        if (context != null) {
            String realPath = context.getRealPath(webFolder);
            if (realPath != null && !realPath.isBlank()) {
                return ensureDirectory(Paths.get(realPath));
            }
        }

        return ensureDirectory(workingDirectory.resolve(projectFolder));
    }

    private static Path ensureDirectory(Path path) {
        try {
            Files.createDirectories(path);
            return path;
        } catch (IOException e) {
            throw new IllegalStateException("Failed to create storage directory: " + path, e);
        }
    }
}
