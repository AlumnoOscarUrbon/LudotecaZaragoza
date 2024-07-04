package com.svalero.util;

import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class Messages {

    public static void sendError(String message, HttpServletResponse response) throws IOException {
        response.getWriter().println("<div class='alert alert-danger' role='alert'>" + message + "</div>");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }

    public static void sendMessage (String message, HttpServletResponse response) throws IOException {
        response.getWriter().println("<div class='alert alert-success m-2' role='alert'>" +  message + "</div>");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
