package com.group50.tasystem.profile.util

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.*;

public class JsonUtil {
    private static final Gson GSON = new GsonBuilder().setPrettyPrinting().create();
    private static final String PATH = "src/main/webapp/WEB-INF/data/";

    public static <T> T read(String fileName, Class<T> clazz) {
        try (FileReader reader = new FileReader(PATH + fileName)) {
            return GSON.fromJson(reader, clazz);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void write(String fileName, Object data) {
        new File(PATH).mkdirs();
        try (FileWriter writer = new FileWriter(PATH + fileName)) {
            GSON.toJson(data, writer);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}