package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.GameDao;
import com.svalero.dao.UserDao;
import com.svalero.domain.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

@WebServlet("/delete-game")
public class DeleteGameServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        int gameId = Integer.parseInt(request.getParameter("actualGameId"));
        try {
            Database.connect();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        Database.jdbi.useExtension(GameDao.class, dao -> dao.deleteGameWithDependencies(gameId));
        sendMessage("conseguido", response);
    }
}


