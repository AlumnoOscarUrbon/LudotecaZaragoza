package com.svalero.util;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class Messages {

    public static void sendError(String message, HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().println("<div class='alert alert-danger mx-2 mb-2' role='alert'>" + message + "</div>");
        System.out.println("Error:" + message);
    }

    public static void sendMessage(String message, HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        try (PrintWriter out = response.getWriter()) {
            out.println("<div class='alert alert-success mx-2 mb-3 d-flex justify-content-between align-items-center' role='alert'>" +
                    "<span>" + message + "</span>" +
                    "<div class='spinner-border ms-auto spinner-border-sm text-primary' role='status' aria-hidden='true'></div>" +
                    "</div>");
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(message);
    }
}
