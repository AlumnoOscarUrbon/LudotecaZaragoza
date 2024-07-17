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

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

@WebServlet("/delete-favorite")
public class DeleteFavoriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        String gameId = request.getParameter("gameId");
        String userId = request.getParameter("sessionUserId");
        String favoriteId = request.getParameter("favoriteId");
        try {
            Database.connect();
            if (favoriteId != null ) {
                Database.jdbi.useExtension(FavoriteDao.class, dao -> dao.deleteFavoriteByFavId(favoriteId));
            } else {
                Database.jdbi.useExtension(FavoriteDao.class, dao -> dao.deleteFavoriteByGameId(userId, gameId));
            }
            sendMessage("Borrado completado: favorito", response);
            Database.close();

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            sendError("Error en la BBDD.", response);
            throw new RuntimeException(e);
        }
    }
}
