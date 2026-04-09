package com.example.tasystem.util;

import org.junit.jupiter.api.Test;

import javax.servlet.ServletContext;
import java.lang.reflect.Proxy;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class StorageResolverTest {
    @Test
    void dataDirectoryUsesProjectRootWhenDiscoveredFromExplodedWebapp() throws Exception {
        Path workspace = Files.createTempDirectory("storage-resolver-workspace");
        Path project = workspace.resolve("demo-project");
        Files.createDirectories(project);
        Files.writeString(project.resolve("pom.xml"), "<project/>");

        Path webRoot = project.resolve("target/cargo/configurations/tomcat9x/webapps/ta-recruitment-system");
        Files.createDirectories(webRoot.resolve("WEB-INF"));

        String originalUserDir = System.getProperty("user.dir");
        try {
            System.setProperty("user.dir", workspace.toString());

            Path dataDirectory = StorageResolver.dataDirectory(contextFor(webRoot));

            assertEquals(project.resolve("data").toAbsolutePath().normalize(), dataDirectory);
            assertTrue(Files.isDirectory(dataDirectory));
        } finally {
            if (originalUserDir == null) {
                System.clearProperty("user.dir");
            } else {
                System.setProperty("user.dir", originalUserDir);
            }
        }
    }

    @Test
    void prepareProjectStorageCopiesNewerLegacyDataIntoProjectRoot() throws Exception {
        Path workspace = Files.createTempDirectory("storage-resolver-migration");
        Path project = workspace.resolve("demo-project");
        Files.createDirectories(project.resolve("data"));
        Files.writeString(project.resolve("pom.xml"), "<project/>");

        Path webRoot = project.resolve("target/cargo/configurations/tomcat9x/webapps/ta-recruitment-system");
        Path legacyDataDirectory = Files.createDirectories(webRoot.resolve("WEB-INF/data"));
        Path projectDataFile = project.resolve("data/applications.json");
        Path legacyDataFile = legacyDataDirectory.resolve("applications.json");

        Files.writeString(projectDataFile, "[{\"applicationId\":\"APP001\"}]");
        Files.writeString(legacyDataFile, "[{\"applicationId\":\"APP001\"},{\"applicationId\":\"APP002\"}]");
        Files.setLastModifiedTime(projectDataFile, FileTime.from(Instant.parse("2026-04-09T00:00:00Z")));
        Files.setLastModifiedTime(legacyDataFile, FileTime.from(Instant.parse("2026-04-09T01:00:00Z")));

        String originalUserDir = System.getProperty("user.dir");
        try {
            System.setProperty("user.dir", workspace.toString());

            StorageResolver.prepareProjectStorage(contextFor(webRoot));

            assertEquals(Files.readString(legacyDataFile), Files.readString(projectDataFile));
        } finally {
            if (originalUserDir == null) {
                System.clearProperty("user.dir");
            } else {
                System.setProperty("user.dir", originalUserDir);
            }
        }
    }

    private ServletContext contextFor(Path webRoot) {
        return (ServletContext) Proxy.newProxyInstance(
                ServletContext.class.getClassLoader(),
                new Class<?>[]{ServletContext.class},
                (proxy, method, args) -> {
                    if ("getRealPath".equals(method.getName()) && args != null && args.length == 1) {
                        String requestedPath = (String) args[0];
                        if (requestedPath == null || requestedPath.isBlank() || "/".equals(requestedPath)) {
                            return webRoot.toString();
                        }

                        String relativePath = requestedPath.startsWith("/") ? requestedPath.substring(1) : requestedPath;
                        return webRoot.resolve(relativePath).toString();
                    }
                    return null;
                }
        );
    }
}
