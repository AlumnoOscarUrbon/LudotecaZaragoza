package com.svalero.util;

import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class Messages {

    public static void sendError(String message, HttpServletResponse response) throws IOException {
        response.getWriter().println("<div class='alert alert-danger  mx-2 mb-2' role='alert'>" + message + "</div>");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }

    public static void sendMessage(String message, HttpServletResponse response) throws IOException {
        response.getWriter().println(
                "<div class='alert alert-success mx-2 mb-3 d-flex justify-content-between align-items-center' role='alert'>" +
                        "<span>" + message + "</span>" +
                        "<div class='spinner-border ms-auto spinner-border-sm text-primary' role='status' aria-hidden='true'></div>" +
                        "</div>"
        );
        response.setStatus(HttpServletResponse.SC_OK);
    }
}