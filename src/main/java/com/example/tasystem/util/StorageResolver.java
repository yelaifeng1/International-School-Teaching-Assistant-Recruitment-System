package com.example.tasystem.util;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.FileTime;
import java.util.stream.Stream;

public final class StorageResolver {
    private StorageResolver() {
    }

    public static Path dataDirectory(ServletContext context) {
        return resolveDirectory(context, "ta.data.dir", "data", "/WEB-INF/data");
    }

    public static Path uploadDirectory(ServletContext context) {
        return resolveDirectory(context, "ta.upload.dir", "uploads", "/uploads");
    }

    public static void prepareProjectStorage(ServletContext context) {
        Path projectDirectory = projectDirectory(context);
        if (projectDirectory == null || context == null) {
            return;
        }

        syncLegacyDirectory(context, projectDirectory.resolve("data"), "/WEB-INF/data");
        syncLegacyDirectory(context, projectDirectory.resolve("uploads"), "/uploads");
    }

    private static Path resolveDirectory(ServletContext context, String propertyName, String projectFolder, String webFolder) {
        String override = System.getProperty(propertyName);
        if (override != null && !override.isBlank()) {
            return ensureDirectory(Paths.get(override));
        }

        Path workingDirectory = Paths.get(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();

        Path projectDirectory = projectDirectory(context);
        if (projectDirectory != null) {
            return ensureDirectory(projectDirectory.resolve(projectFolder));
        }

        if (context != null) {
            String realPath = context.getRealPath(webFolder);
            if (realPath != null && !realPath.isBlank()) {
                return ensureDirectory(Paths.get(realPath));
            }
        }

        return ensureDirectory(workingDirectory.resolve(projectFolder));
    }

    static Path projectDirectory(ServletContext context) {
        Path workingDirectory = Paths.get(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();
        Path fromWorkingDirectory = findProjectDirectory(workingDirectory);
        if (fromWorkingDirectory != null) {
            return fromWorkingDirectory;
        }

        if (context == null) {
            return null;
        }

        Path realPathRoot = toPath(context.getRealPath("/"));
        Path fromWebRoot = findProjectDirectory(realPathRoot);
        if (fromWebRoot != null) {
            return fromWebRoot;
        }

        return findProjectDirectory(toPath(context.getRealPath("/WEB-INF")));
    }

    static Path findProjectDirectory(Path start) {
        Path current = start;
        while (current != null) {
            if (Files.exists(current.resolve("pom.xml"))) {
                return current;
            }
            current = current.getParent();
        }
        return null;
    }

    private static Path toPath(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return Paths.get(value).toAbsolutePath().normalize();
    }

    private static void syncLegacyDirectory(ServletContext context, Path targetDirectory, String legacyWebPath) {
        Path legacyDirectory = toPath(context.getRealPath(legacyWebPath));
        if (legacyDirectory == null || !Files.isDirectory(legacyDirectory)) {
            return;
        }

        Path normalizedTargetDirectory = targetDirectory.toAbsolutePath().normalize();
        if (normalizedTargetDirectory.equals(legacyDirectory)) {
            return;
        }

        ensureDirectory(normalizedTargetDirectory);
        try (Stream<Path> files = Files.list(legacyDirectory)) {
            files.filter(Files::isRegularFile)
                    .forEach(legacyFile -> copyIfLegacyIsPreferred(legacyFile, normalizedTargetDirectory.resolve(legacyFile.getFileName())));
        } catch (IOException e) {
            throw new IllegalStateException("Failed to synchronize legacy storage from: " + legacyDirectory, e);
        }
    }

    private static void copyIfLegacyIsPreferred(Path legacyFile, Path targetFile) {
        try {
            if (!Files.exists(targetFile) || isLegacyNewer(legacyFile, targetFile)) {
                Files.copy(legacyFile, targetFile, StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Failed to copy legacy storage file: " + legacyFile, e);
        }
    }

    private static boolean isLegacyNewer(Path legacyFile, Path targetFile) throws IOException {
        if (!Files.exists(targetFile)) {
            return true;
        }

        FileTime legacyModified = Files.getLastModifiedTime(legacyFile);
        FileTime targetModified = Files.getLastModifiedTime(targetFile);
        return legacyModified.compareTo(targetModified) > 0;
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
