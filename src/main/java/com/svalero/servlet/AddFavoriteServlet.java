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

@WebServlet("/add-favorite")
public class AddFavoriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        int gameId = Integer.parseInt(request.getParameter("gameId"));
        int userId = Integer.parseInt(request.getParameter("sessionUserId"));

        try {
            Database.connect();
            Database.jdbi.useExtension(FavoriteDao.class, dao -> dao.addFavorite(userId, gameId));
            sendMessage("Añadido completado: favorito", response);
            Database.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            sendError("Error en la BBDD.", response);
            throw new RuntimeException(e);

        }
    }
}
