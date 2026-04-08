package com.example.tasystem.model;

import java.io.Serializable;

public class FlashMessage implements Serializable {
    private final String type;
    private final String text;

    public FlashMessage(String type, String text) {
        this.type = type;
        this.text = text;
    }

    public String getType() {
        return type;
    }

    public String getText() {
        return text;
    }
}
