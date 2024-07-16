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
        String activityId = request.getParameter("activityId");
        String actualUserId = request.getParameter("actualUserId");
        String signUpId = request.getParameter("signUpId");
        try {
            Database.connect();
            if (signUpId != null ) {
                Database.jdbi.useExtension(SignUpDao.class, dao -> dao.deleteSignUpBySignUpId(signUpId));
            } else {
                Database.jdbi.useExtension(SignUpDao.class, dao -> dao.deleteSignUpByActivityId(actualUserId, activityId));
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
