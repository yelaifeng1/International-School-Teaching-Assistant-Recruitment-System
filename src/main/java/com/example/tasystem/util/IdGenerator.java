package com.example.tasystem.util;

import java.util.Collection;

public final class IdGenerator {
    private IdGenerator() {
    }

    public static String nextId(String prefix, Collection<String> existingIds) {
        int max = 0;
        for (String existingId : existingIds) {
            if (existingId == null || !existingId.startsWith(prefix)) {
                continue;
            }
            String suffix = existingId.substring(prefix.length()).replaceAll("[^0-9]", "");
            if (!suffix.isEmpty()) {
                max = Math.max(max, Integer.parseInt(suffix));
            }
        }
        return String.format("%s%03d", prefix, max + 1);
    }
}
