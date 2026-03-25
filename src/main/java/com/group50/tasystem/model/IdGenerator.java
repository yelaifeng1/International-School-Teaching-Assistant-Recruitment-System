package com.group50.tasystem.util;

public class IdGenerator {

    public static String generateId(String prefix, int number) {
        return String.format("%s%03d", prefix, number);
    }
}
