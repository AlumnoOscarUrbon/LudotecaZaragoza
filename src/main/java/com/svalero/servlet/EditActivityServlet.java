package com.svalero.servlet;

import com.svalero.dao.ActivityDao;
import com.svalero.dao.Database;

import com.svalero.util.Utils;
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
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.UUID;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

@WebServlet("/edit-activity")
@MultipartConfig
public class EditActivityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        try {
            if (validate(request, response)) {
                String activityId = request.getParameter("activityId");
                String activityName = request.getParameter("activityName");
                int activityCategoryId = Integer.parseInt(request.getParameter("activityCategoryId"));
                String activityDescription = request.getParameter("activityDescription");
                Date activityRelease = Utils.parseDate(request.getParameter("activityRelease"));
                Part picturePart = request.getPart("activityPicture");

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
                if (activityId.equals("noId")) {
                    Database.jdbi.withExtension(ActivityDao.class, dao -> dao.registerActivity(activityName, activityCategoryId, activityDescription, activityRelease, finalFileName));
                    sendMessage("Registro satisfactorio", response);

                } else {
                    if (picturePart.getSize() != 0) {
                        Database.jdbi.withExtension(ActivityDao.class, dao -> dao.updateAllActivity(activityName, activityCategoryId, activityDescription, activityRelease, finalFileName, activityId));
                        sendMessage("Actualización satisfactoria", response);
                    } else {
                        Database.jdbi.withExtension(ActivityDao.class, dao -> dao.updateActivityNoImage(activityName, activityCategoryId, activityDescription, activityRelease, activityId));
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

        if (request.getParameter("activityName").isBlank()) {
            sendError("Debe ingresar un nombre",response);
            hasErrors=false;
        }

        if (request.getParameter("activityCategoryId") == null) {
            sendError("Debe ingresar una categoria",response);
            hasErrors=false;
        }
        try {
            Utils.parseDate(request.getParameter("activityRelease"));
        } catch (ParseException pe) {
            sendError("Formato de la fecha incorrecto", response);
            hasErrors=false;
        }
        return hasErrors;
    }

}