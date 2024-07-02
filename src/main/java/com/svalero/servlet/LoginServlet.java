package com.svalero.servlet;

import com.svalero.dao.Database;
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

@WebServlet("/login1")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Database.connect();
            User user = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUser(username,password));

            if (user != null) {

//                response.getWriter().println("<div class ='alert alert-success' role='alert'> Hola " + user.getName() + ", tu rol es el de : " +
//                        user.getRole() + "</div>");

                HttpSession session = request.getSession();

                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("id", user.getUserId());




               response.getWriter().print("ok");
            } else {
                sendError("usuario no existe", response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            sendError("excepción del SQL",response);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            sendError("excepcion en tiempo de ejecucion", response);
        } catch (NullPointerException e){
            e.printStackTrace();
        }
    }
}