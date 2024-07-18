package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.GameDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.jdbi.v3.core.statement.UnableToExecuteStatementException;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.UUID;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;
import static com.svalero.util.Utils.parseLocalDate;

@WebServlet("/edit-game")
@MultipartConfig
public class EditGameServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        try {
            if (validate(request, response)) {
                String gameId = request.getParameter("gameId");
                String gameName = request.getParameter("gameName");
                int gameCategoryId = Integer.parseInt(request.getParameter("gameCategoryId"));
                String gameDescription = request.getParameter("gameDescription");
                LocalDate gameRelease = parseLocalDate(request.getParameter("gameRelease"));

                //Carga y nombrado de imagen
                Part picturePart = request.getPart("gamePicture");
                String imagePath = request.getServletContext().getInitParameter("image-path");
                String absolutePath = getServletContext().getRealPath("/") + imagePath;
                String fileName;
                if (picturePart.getSize() == 0) {
                    fileName = "picture_default.jpg";
                } else {
                    fileName = UUID.randomUUID() + ".jpg";
                    InputStream fileStream = picturePart.getInputStream();
                    Files.copy(fileStream, Path.of(absolutePath + File.separator + fileName));
                }
                final String finalFileName = fileName;

                Database.connect();
                if (gameId.equals("noId")) {
                    Database.jdbi.withExtension(GameDao.class, dao -> dao.registerGame(gameName, gameCategoryId, gameDescription, gameRelease, finalFileName));
                    sendMessage("Registro satisfactorio", response);

                } else {
                    int gameIdInt = Integer.parseInt(gameId);
                    if (picturePart.getSize() != 0) {
                        Database.jdbi.withExtension(GameDao.class, dao -> dao.updateAllGame(gameName, gameCategoryId, gameDescription, gameRelease, finalFileName, gameIdInt));
                        sendMessage("Actualización satisfactoria", response);
                    } else {
                        Database.jdbi.withExtension(GameDao.class, dao -> dao.updateGameNoImage(gameName, gameCategoryId, gameDescription, gameRelease, gameIdInt));
                        sendMessage("Actualización satisfactoria. La imagen no ha cambiado", response);
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
        } catch (ServletException | ParseException e) {
            e.printStackTrace();
            sendError("Error interno del servidor", response);
        }
    }

    private boolean validate (HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
        boolean hasErrors = true;

        if (request.getParameter("gameName").isBlank()) {
            sendError("Debe ingresar un nombre",response);
            hasErrors=false;
        }

        if (request.getParameter("gameCategoryId") == null) {
            sendError("Debe ingresar una categoria",response);
            hasErrors=false;
        }
        try {
            parseLocalDate(request.getParameter("gameRelease"));
        } catch (DateTimeParseException pe) {
            sendError("Formato de la fecha incorrecto", response);
            hasErrors=false;
        }
        return hasErrors;
    }

}