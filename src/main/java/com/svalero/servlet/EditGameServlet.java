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

import java.sql.Date;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.UUID;

import static com.svalero.util.Messages.sendError;
import static com.svalero.util.Messages.sendMessage;

@WebServlet("/edit-game")
@MultipartConfig
public class EditGameServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        try {
                String gameId = request.getParameter("gameId");
                String gameName = request.getParameter("gameName");
                int gameCategory = Integer.parseInt(request.getParameter("gameCategory"));
                String gameDescription = request.getParameter("gameDescription");
                Date gameRelease = Utils.parseDate(request.getParameter("gameRelease"));
                Part picturePart = request.getPart("gamePicture");

            // NOMBRAR Y GUARDAR IMAGENES EN CARPETA DENTRO DE TOMCAT
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

               Database.jdbi.withExtension(GameDao.class, dao -> dao.registerGame(gameName, gameCategory, gameDescription, gameRelease, finalFileName, gameId ));
            sendMessage("Registro satisfactorio", response);

//                if (!gameId.equals("0")){
//                    sendMessage("Registro satisfactorio", response);
//                }


        } catch(
        SQLException sqle){
            sqle.printStackTrace();
            sendError("Error conectando a la base de datos", response);
        } catch(ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            sendError("Error interno del servidor", response);
        } catch (ServletException e) {
            throw new RuntimeException(e);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}