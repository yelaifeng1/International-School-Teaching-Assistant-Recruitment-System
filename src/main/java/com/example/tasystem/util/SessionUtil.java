package com.example.tasystem.util;

import com.example.tasystem.model.User;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public final class SessionUtil {
    public static final String CURRENT_USER_ID = "currentUserId";
    public static final String CURRENT_ROLE = "currentRole";
    public static final String CURRENT_DISPLAY_NAME = "currentDisplayName";
    public static final String REMEMBERED_USERNAME_COOKIE = "rememberedUsername";

    private SessionUtil() {
    }

    public static void signIn(HttpServletRequest request, HttpServletResponse response, User user, boolean rememberUsername) {
        HttpSession session = request.getSession(true);
        session.setAttribute(CURRENT_USER_ID, user.getUserId());
        session.setAttribute(CURRENT_ROLE, user.getRole());
        session.setAttribute(CURRENT_DISPLAY_NAME, user.getEffectiveDisplayName());
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());
        session.setAttribute("name", user.getEffectiveDisplayName());
        session.setAttribute("email", user.getEmail());

        Cookie cookie = new Cookie(REMEMBERED_USERNAME_COOKIE, rememberUsername ? user.getUsername() : "");
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setMaxAge(rememberUsername ? 7 * 24 * 60 * 60 : 0);
        response.addCookie(cookie);
    }

    public static void signOut(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Cookie cookie = new Cookie(REMEMBERED_USERNAME_COOKIE, "");
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

    public static String currentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(CURRENT_USER_ID);
        return value == null ? null : value.toString();
    }

    public static String rememberedUsername(HttpServletRequest request) {
        if (request.getCookies() == null) {
            return "";
        }

        for (Cookie cookie : request.getCookies()) {
            if (REMEMBERED_USERNAME_COOKIE.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return "";
    }
}
