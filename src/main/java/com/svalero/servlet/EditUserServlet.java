package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.UserDao;
import com.svalero.domain.User;
import com.svalero.util.Utils;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.jdbi.v3.core.statement.UnableToExecuteStatementException;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.Period;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

@WebServlet("/edit-user")
@MultipartConfig
public class EditUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            if (validate ( request, response)) {
                String userId = request.getParameter("userId");
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                Date birthDate = Utils.parseDate(request.getParameter("birthDate"));
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                HttpSession session = request.getSession();

                Database.connect();

                System.out.println("Conexion abierta");
                if (userId.equals("noId")) {
                    if (validatePassword(request, response)) {
                        Database.jdbi.withExtension(UserDao.class, dao -> dao.registerUser(username, email, birthDate, password, role));

                        User userForLogin = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUser(username, password));

                        session.setAttribute("username", userForLogin.getUsername());
                        session.setAttribute("role", userForLogin.getRole());
                        session.setAttribute("id", userForLogin.getUserId());
                        sendMessage("Registro satisfactorio", response);
                    }

                } else {
                    if (password.isBlank()) {
                        Database.jdbi.withExtension(UserDao.class, dao -> dao.updateUserWOPassword(username, email, birthDate, role, userId));

                        if (session.getAttribute("id").equals(userId)) {
                            session.setAttribute("username", username);
                            session.setAttribute("role", role );
                            session.setAttribute("id", userId);
                        }
                        sendMessage("Datos actualizados correctamente. La contraseña no ha cambiado.", response);

                    } else {
                            Database.jdbi.withExtension(UserDao.class, dao -> dao.updateUserWithPassword(username, email, birthDate, password, role, userId));

                        if (session.getAttribute("id").equals(userId)) {
                            session.setAttribute("username", username);
                            session.setAttribute("role", role );
                            session.setAttribute("id", userId);
                        }
                        sendMessage("Datos actualizados correctamente.", response);
                    }
                }
                Database.close();
            }
        } catch (UnableToExecuteStatementException e){
            e.printStackTrace();
            sendError("Error de ejecución en la BBDD.", response);
        } catch (SQLException sqle){
            sqle.printStackTrace();
            sendError("Error conectando a la base de datos", response);
        } catch(ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            sendError("Error: clase no encontrada", response);
        } catch ( ParseException e) {
            e.printStackTrace();
            sendError("Error interno del servidor", response);
        }
    }

    private boolean validate (HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
        boolean hasErrors = true;

        if (request.getParameter("username").isBlank()) {
            sendError("Debe ingresar un nombre.",response);
            hasErrors=false;
        }

        if (request.getParameter("role") == null) {
            sendError("Debe seleccionar un rol.",response);
            hasErrors=false;
        }
        try {
            Date birthDate = Utils.parseDate(request.getParameter("birthDate"));
            LocalDate localBirthDate = birthDate.toLocalDate();
            LocalDate actualDate= LocalDate.now();
            Period period = Period.between(localBirthDate, actualDate);
            if (period.getYears() < 18) {
                sendError("Debes ser mayor de 18 años.",response);
                hasErrors=false;
            }
        } catch (ParseException pe) {
            sendError("Formato de la fecha incorrecto.", response);
            hasErrors=false;
        }
        return hasErrors;
    }

    private boolean validatePassword (HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean isPasswordValid = true;
        if (request.getParameter("password").isEmpty()) {
            sendError("Debe ingresar un password.",response);
            isPasswordValid = false;
        } else if (request.getParameter("password").isBlank()) {
            sendError("Debe ingresar un password válido.",response);
            isPasswordValid = false;
        }
    return isPasswordValid;
    }

}