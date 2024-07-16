package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.FavoriteDao;
import com.svalero.dao.SignUpDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

@WebServlet("/add-sign-up")
public class AddSignUpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        String activityId = request.getParameter("activityId");
        String actualUserId = request.getParameter("actualUserId");

        try {
            Database.connect();
            Database.jdbi.useExtension(SignUpDao.class, dao -> dao.addSignUp(actualUserId, activityId));
            sendMessage("Añadido: apuntarse", response);
            Database.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            sendError("Error en la BBDD.", response);
            throw new RuntimeException(e);

        }
    }
}
