package com.example.tasystem.util;

import com.example.tasystem.model.FlashMessage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class FlashUtil {
    private static final String FLASH_KEY = "flashMessage";

    private FlashUtil() {
    }

    public static void success(HttpServletRequest request, String message) {
        put(request, new FlashMessage("success", message));
    }

    public static void error(HttpServletRequest request, String message) {
        put(request, new FlashMessage("error", message));
    }

    public static FlashMessage consume(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object message = session.getAttribute(FLASH_KEY);
        session.removeAttribute(FLASH_KEY);
        return message instanceof FlashMessage ? (FlashMessage) message : null;
    }

    private static void put(HttpServletRequest request, FlashMessage message) {
        request.getSession(true).setAttribute(FLASH_KEY, message);
    }
}
