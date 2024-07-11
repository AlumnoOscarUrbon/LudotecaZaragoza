package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.GameDao;
import com.svalero.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.util.Messages.sendMessage;


@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        int userId = Integer.parseInt(request.getParameter("userId"));
        try {
            Database.connect();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        Database.jdbi.useExtension(UserDao.class, dao -> dao.deleteUserWithDependencies(userId));
        sendMessage("borrado", response);
    }}