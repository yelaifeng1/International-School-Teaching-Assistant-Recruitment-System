package com.example.tasystem;

import com.example.tasystem.util.StorageResolver;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.jupiter.api.*;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * ReviewApplicationServlet 测试类
 * 测试 MO 审核申请模块的核心功能
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ReviewApplicationServletTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private ServletContext servletContext;

    @Mock
    private ServletConfig servletConfig;

    private ReviewApplicationServlet servlet;
    private Path testDataPath;
    private AutoCloseable closeable;

    @BeforeEach
    void setUp() throws Exception {
        closeable = MockitoAnnotations.openMocks(this);
        servlet = new ReviewApplicationServlet();
        
        // 创建临时测试数据目录
        testDataPath = Paths.get("target/test-data");
        Files.createDirectories(testDataPath);
        
        // 设置 mock 行为
        when(servletConfig.getServletContext()).thenReturn(servletContext);
        when(request.getServletContext()).thenReturn(servletContext);
        when(request.getContextPath()).thenReturn("/ta-recruitment-system");
        
        // 初始化 servlet
        servlet.init(servletConfig);
    }

    @AfterEach
    void tearDown() throws Exception {
        closeable.close();
        // 清理测试数据
        if (Files.exists(testDataPath)) {
            Files.walk(testDataPath)
                .sorted((a, b) -> b.compareTo(a))
                .forEach(path -> {
                    try {
                        Files.deleteIfExists(path);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                });
        }
    }

    /**
     * 创建测试用的 applications.json 数据
     */
    private Path createTestApplicationsJson() throws IOException {
        Path jsonFile = testDataPath.resolve("applications.json");
        
        JSONArray applications = new JSONArray();
        
        JSONObject app1 = new JSONObject();
        app1.put("id", 1);
        app1.put("jobId", 1);
        app1.put("applicantId", 1);
        app1.put("name", "Test User 1");
        app1.put("jobTitle", "Java TA");
        app1.put("reason", "I love Java programming");
        app1.put("status", "Pending");
        app1.put("applyDate", "2026-05-01");
        
        JSONObject app2 = new JSONObject();
        app2.put("id", 2);
        app2.put("jobId", 2);
        app2.put("applicantId", 2);
        app2.put("name", "Test User 2");
        app2.put("jobTitle", "Database TA");
        app2.put("reason", "SQL expert");
        app2.put("status", "Approved");
        app2.put("applyDate", "2026-05-02");
        
        applications.put(app1);
        applications.put(app2);
        
        Files.write(jsonFile, applications.toString(4).getBytes(StandardCharsets.UTF_8));
        return jsonFile;
    }

    @Test
    @Order(1)
    @DisplayName("测试1: 成功更新申请状态为 Approved")
    void testUpdateApplicationStatusToApproved() throws Exception {
        // Arrange
        Path jsonFile = createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("1");
            when(request.getParameter("status")).thenReturn("Approved");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?success=Review completed successfully");
            
            // 验证 JSON 文件更新
            String updatedContent = new String(Files.readAllBytes(jsonFile), StandardCharsets.UTF_8);
            JSONArray updatedArray = new JSONArray(updatedContent);
            JSONObject updatedApp = updatedArray.getJSONObject(0);
            assertEquals("Approved", updatedApp.getString("status"));
            assertEquals(1, updatedApp.getInt("id"));
        }
    }

    @Test
    @Order(2)
    @DisplayName("测试2: 成功更新申请状态为 Rejected")
    void testUpdateApplicationStatusToRejected() throws Exception {
        // Arrange
        Path jsonFile = createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("1");
            when(request.getParameter("status")).thenReturn("Rejected");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?success=Review completed successfully");
            
            // 验证 JSON 文件更新
            String updatedContent = new String(Files.readAllBytes(jsonFile), StandardCharsets.UTF_8);
            JSONArray updatedArray = new JSONArray(updatedContent);
            JSONObject updatedApp = updatedArray.getJSONObject(0);
            assertEquals("Rejected", updatedApp.getString("status"));
        }
    }

    @Test
    @Order(3)
    @DisplayName("测试3: 重置申请状态为 Pending")
    void testResetApplicationStatusToPending() throws Exception {
        // Arrange
        Path jsonFile = createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("2");
            when(request.getParameter("status")).thenReturn("Pending");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?success=Review completed successfully");
            
            // 验证 JSON 文件更新
            String updatedContent = new String(Files.readAllBytes(jsonFile), StandardCharsets.UTF_8);
            JSONArray updatedArray = new JSONArray(updatedContent);
            JSONObject updatedApp = updatedArray.getJSONObject(1);
            assertEquals("Pending", updatedApp.getString("status"));
        }
    }

    @Test
    @Order(4)
    @DisplayName("测试4: 参数为空时返回错误")
    void testMissingParameters() throws Exception {
        // Arrange
        createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn(null);
            when(request.getParameter("status")).thenReturn("Approved");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?error=Parameters cannot be empty");
        }
    }

    @Test
    @Order(5)
    @DisplayName("测试5: 无效的状态值")
    void testInvalidStatusValue() throws Exception {
        // Arrange
        createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("1");
            when(request.getParameter("status")).thenReturn("InvalidStatus");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?error=Invalid status value");
        }
    }

    @Test
    @Order(6)
    @DisplayName("测试6: 无效的申请 ID (非数字)")
    void testInvalidApplicationId() throws Exception {
        // Arrange
        createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("abc");
            when(request.getParameter("status")).thenReturn("Approved");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?error=Invalid application ID");
        }
    }

    @Test
    @Order(7)
    @DisplayName("测试7: 申请 ID 不存在")
    void testApplicationNotFound() throws Exception {
        // Arrange
        createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("999");
            when(request.getParameter("status")).thenReturn("Approved");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            verify(response).sendRedirect("/ta-recruitment-system/mo/review-applications?error=Application not found");
        }
    }

    @Test
    @Order(8)
    @DisplayName("测试8: JSON 文件不存在时自动创建")
    void testAutoCreateJsonFileIfNotExists() throws Exception {
        // Arrange
        Path jsonFile = testDataPath.resolve("applications.json");
        Files.deleteIfExists(jsonFile);
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("1");
            when(request.getParameter("status")).thenReturn("Approved");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            assertTrue(Files.exists(jsonFile), "JSON 文件应该被自动创建");
            String content = new String(Files.readAllBytes(jsonFile), StandardCharsets.UTF_8);
            JSONArray array = new JSONArray(content);
            assertEquals(0, array.length(), "空文件应该包含空数组");
        }
    }

    @Test
    @Order(9)
    @DisplayName("测试9: 验证 UTF-8 编码支持中文字符")
    void testUtf8ChineseCharacters() throws Exception {
        // Arrange
        Path jsonFile = testDataPath.resolve("applications.json");
        JSONArray applications = new JSONArray();
        
        JSONObject app = new JSONObject();
        app.put("id", 1);
        app.put("jobId", 1);
        app.put("applicantId", 1);
        app.put("name", "测试用户");
        app.put("jobTitle", "软件工程助教");
        app.put("reason", "我热爱编程，有丰富的Java开发经验");
        app.put("status", "Pending");
        app.put("applyDate", "2026-05-20");
        
        applications.put(app);
        Files.write(jsonFile, applications.toString(4).getBytes(StandardCharsets.UTF_8));
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            when(request.getParameter("id")).thenReturn("1");
            when(request.getParameter("status")).thenReturn("Approved");
            
            // Act
            servlet.doPost(request, response);
            
            // Assert
            String updatedContent = new String(Files.readAllBytes(jsonFile), StandardCharsets.UTF_8);
            JSONArray updatedArray = new JSONArray(updatedContent);
            JSONObject updatedApp = updatedArray.getJSONObject(0);
            
            assertEquals("测试用户", updatedApp.getString("name"));
            assertEquals("软件工程助教", updatedApp.getString("jobTitle"));
            assertEquals("我热爱编程，有丰富的Java开发经验", updatedApp.getString("reason"));
            assertEquals("Approved", updatedApp.getString("status"));
        }
    }

    @Test
    @Order(10)
    @DisplayName("测试10: 批量操作 - 连续更新多个申请")
    void testBatchUpdate() throws Exception {
        // Arrange
        Path jsonFile = createTestApplicationsJson();
        
        try (MockedStatic<StorageResolver> mockedResolver = mockStatic(StorageResolver.class)) {
            mockedResolver.when(() -> StorageResolver.dataDirectory(any())).thenReturn(testDataPath);
            
            // 第一次更新：Approve ID 1
            when(request.getParameter("id")).thenReturn("1");
            when(request.getParameter("status")).thenReturn("Approved");
            servlet.doPost(request, response);
            
            // 第二次更新：Reject ID 2
            reset(request, response);
            when(request.getServletContext()).thenReturn(servletContext);
            when(request.getContextPath()).thenReturn("/ta-recruitment-system");
            when(request.getParameter("id")).thenReturn("2");
            when(request.getParameter("status")).thenReturn("Rejected");
            servlet.doPost(request, response);
            
            // Assert
            String updatedContent = new String(Files.readAllBytes(jsonFile), StandardCharsets.UTF_8);
            JSONArray updatedArray = new JSONArray(updatedContent);
            
            assertEquals("Approved", updatedArray.getJSONObject(0).getString("status"));
            assertEquals("Rejected", updatedArray.getJSONObject(1).getString("status"));
        }
    }
}
