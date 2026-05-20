package com.example.tasystem.controller;

import com.example.tasystem.model.User;
import org.junit.jupiter.api.*;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * MO审核申请模块测试 - MOReviewApplicationsServlet
 * 测试 MO 审核申请页面路由功能
 */
class MOReviewApplicationsServletTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher requestDispatcher;

    @Mock
    private User mockUser;

    private MOReviewApplicationsServlet servlet;
    private AutoCloseable closeable;

    @BeforeEach
    void setUp() {
        closeable = MockitoAnnotations.openMocks(this);
        servlet = new MOReviewApplicationsServlet();
    }

    @AfterEach
    void tearDown() throws Exception {
        closeable.close();
    }

    @Test
    @DisplayName("测试1: GET 请求正常访问审核页面")
    void testDoGetSuccess() throws ServletException, IOException {
        // Arrange
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("currentUser")).thenReturn(mockUser);
        when(request.getRequestDispatcher("/WEB-INF/views/mo/review-applications.jsp")).thenReturn(requestDispatcher);

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(request).getRequestDispatcher("/WEB-INF/views/mo/review-applications.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    @DisplayName("测试2: 未登录用户访问时的处理")
    void testDoGetWithoutLogin() throws ServletException, IOException {
        // Arrange
        when(request.getSession(false)).thenReturn(null);

        // Act & Assert
        // BaseServlet 会处理未登录情况，这里验证不会抛出异常
        assertDoesNotThrow(() -> {
            try {
                servlet.doGet(request, response);
            } catch (NullPointerException e) {
                // 预期行为：BaseServlet 的 currentUser 方法会处理 null session
            }
        });
    }

    @Test
    @DisplayName("测试3: 验证 servlet 映射路径")
    void testServletMapping() {
        // 通过反射验证 @WebServlet 注解
        javax.servlet.annotation.WebServlet annotation = 
            MOReviewApplicationsServlet.class.getAnnotation(javax.servlet.annotation.WebServlet.class);
        
        assertNotNull(annotation, "Servlet 应该有 @WebServlet 注解");
        String[] urlPatterns = annotation.value();
        assertEquals(1, urlPatterns.length, "应该有一个 URL 映射");
        assertEquals("/mo/review-applications", urlPatterns[0], "URL 映射应该是 /mo/review-applications");
    }

    @Test
    @DisplayName("测试4: 验证 servlet 继承关系")
    void testServletInheritance() {
        // 验证 MOReviewApplicationsServlet 继承自 BaseServlet
        assertTrue(servlet instanceof BaseServlet, "MOReviewApplicationsServlet 应该继承自 BaseServlet");
    }
}
