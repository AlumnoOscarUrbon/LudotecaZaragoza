package com.svalero.servlet;

import com.svalero.dao.Database;
import com.svalero.dao.GameDao;
import com.svalero.util.Utils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.commons.lang3.time.DateUtils;
import org.jdbi.v3.core.statement.UnableToExecuteStatementException;

import java.sql.Date;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.text.ParseException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

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
                Date gameRelease = Utils.parseDate(request.getParameter("gameRelease"));
                Part picturePart = request.getPart("gamePicture");

                String imagePath = request.getServletContext().getInitParameter("image-path");
                String absolutePath = getServletContext().getRealPath("/") + imagePath;
                String fileName = null;
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
                    Database.jdbi.withExtension(GameDao.class, dao -> dao.updateGame(gameName, gameCategoryId, gameDescription, gameRelease, finalFileName, gameId));
                    sendMessage("Actualización satisfactoria", response);
                }
            }
        } catch (UnableToExecuteStatementException e){
            e.printStackTrace();
            sendError("Ya existe un juego con el mismo nombre.", response);
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
            Utils.parseDate(request.getParameter("gameRelease"));
        } catch (ParseException pe) {
            sendError("Formato de la fecha incorrecto", response);
            hasErrors=false;
        }
        return hasErrors;
    }

}