package com.example.tasystem.listener;

import com.example.tasystem.service.AppServices;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppBootstrapListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        AppServices services = new AppServices(sce.getServletContext());
        services.initialize();
        sce.getServletContext().setAttribute(AppServices.ATTRIBUTE, services);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // No-op. JSON persistence is flushed eagerly on each write.
    }
}
