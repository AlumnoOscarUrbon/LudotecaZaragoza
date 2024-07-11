<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.svalero.dao.Database" %>
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ludoteca Zaragoza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>


    <link href="css/custom.css" rel="stylesheet">

</head>

<!-- Auto-marcar barra de busqueda -->
<script>
    $(document).ready(function(){
        $("#search-input").focus();
    });
</script>


<%
    try {
        Database.connect();
        System.out.println("Conexion abierta");
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
    };

//  DIFERENCIAR AL USUARIO
    HttpSession currentSession = request.getSession();
    String actualUserId;
    String actualUsername;
    String actualUserRole;

    if (currentSession.getAttribute("id") != null) {
        actualUserId = currentSession.getAttribute("id").toString();
        actualUsername= currentSession.getAttribute("username").toString();
        actualUserRole= currentSession.getAttribute("role").toString();
    } else {
        actualUserId = "noId";
        actualUsername = "noUsername";
        actualUserRole = "noRole";
    }
%>

<link href="css/custom.css" rel="stylesheet">
<header class="p-3 text-bg-dark">
    <div class="container">

        <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start gap-2 gap-lg-3">
            <a href="index.jsp" class=" mb-0 ">
                <img src="icons/ludotecaZaragoza -logo.png"  class="logo-size"  alt="imagen del logotipo"/>
            </a>

            <ul class="nav col-12 col-lg-auto ms-lg-auto justify-content-center ">
                <li><a href="view-game.jsp" class="nav-link px-2 text-white ">Juegos</a></li>
                <li><a href="#" class="nav-link px-2 text-white ">Actividades</a></li>
            </ul>

            <form class="d-flex align-items-center  " role="search" id="search-form" method="GET">
                <input type="text" class="form-control form-control-dark me-2" aria-label="Search" name="search"  id="search-input"
                    placeholder="<% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()){ %>&quot;<%= request.getParameter("search") %>&quot;<% }
                    else { %>Buscar... <% } %>" >
                <button type="submit" class="btn btn-outline-light" id="search-button">Buscar</button>
            </form>

            <div class="text-end ">
                <% if (actualUserId.equals("noId")) { %>
                    <button type="button" class="btn btn-warning " data-bs-toggle="modal" data-bs-target="#Sign-In-Modal">Login</button>
                <% } else { %>

                    <div class="btn-group ">
                        <button type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                            Area Personal
                        </button>
                        <ul class="dropdown-menu ">
                            <li><a class="dropdown-item" href="view-user.jsp"> <% if (actualUserRole.equals("admin")) { %> Usuarios <% } else { %> Mis datos <% } %></a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout">Cerrar sesión</a></li>
                        </ul>
                    </div>
                <%}%>
            </div>
        </div>
    </div>

</header>


<%@ include file="LoginPag.jsp"%>

<body>