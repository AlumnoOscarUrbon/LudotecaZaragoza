package com.svalero.servlet;

import com.svalero.dao.Database;
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

@WebServlet("/delete-sign-up")
public class DeleteSignUpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        int activityId = Integer.parseInt(request.getParameter("activityId"));
        int userId = Integer.parseInt(request.getParameter("sessionUserId"));
        String signUpId = request.getParameter("signUpId");
        try {
            Database.connect();
            if (signUpId != null ) {
                int signUpIdInt = Integer.parseInt(signUpId);
                Database.jdbi.useExtension(SignUpDao.class, dao -> dao.deleteSignUpBySignUpId(signUpIdInt));
            } else {
                Database.jdbi.useExtension(SignUpDao.class, dao -> dao.deleteSignUpByActivityId(userId, activityId));
            }
            sendMessage("Borrado completado: sign up", response);
            Database.close();

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            sendError("Error en la BBDD.", response);
            throw new RuntimeException(e);
        }
    }
}
