package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.FavoriteDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.util.Messages.sendMessage;

@WebServlet("/delete-favorite")
public class DeleteFavoriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        String gameId = request.getParameter("gameId");
        String actualUserId = request.getParameter("actualUserId");

        try {
            Database.connect();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        Database.jdbi.useExtension(FavoriteDao.class, dao -> dao.deleteFavoriteByGameId(actualUserId, gameId));
        sendMessage("conseguido", response);

    }
}
