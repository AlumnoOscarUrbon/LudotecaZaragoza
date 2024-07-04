<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.svalero.dao.Database" %>
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ludoteca Zaragoza</title>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" integrity="sha384-dpuaG1suU0eT09tx5plTaGMLBsfDLzUCCUXOY2j/LSvXYuG6Bqs43ALlhIqAJVRb" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>


    <link href="css/custom.css" rel="stylesheet">
</head>

<%--<!-- Auto-marcar barra de busqueda -->--%>
<%--<script>--%>
<%--    $(document).ready(function(){--%>
<%--        $("#search-input").focus();--%>
<%--    });--%>
<%--</script>--%>


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
    String actualUserName;
    String actualUserRole;

    if (currentSession.getAttribute("id") != null) {
        actualUserId = currentSession.getAttribute("id").toString();
        actualUserName= currentSession.getAttribute("username").toString();
        actualUserRole= currentSession.getAttribute("role").toString();
    } else {
        actualUserId = "0";
        actualUserName = "anonymous";
        actualUserRole = "anonymous";
    }
%>



<header class="p-3 text-bg-dark">
    <div class="container">
        <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
            <a href="index.jsp" class="d-flex align-items-center mb-2 mb-lg-0 text-white text-decoration-none">
                <img src="icons/logo_zdm_ph.jpg" height = "50" width="200" alt="imagen del logotipo"/>
            </a>

            <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-lg-0 ">
                <li><a href="view-game.jsp" class="nav-link px-2 text-white">Juegos</a></li>
                <li><a href="#" class="nav-link px-2 text-white">Actividades</a></li>
            </ul>

            <form class="col-12 col-lg-auto mb-3 mb-lg-0 me-lg-3 d-flex" role="search" id="search-form" method="GET">
                <input type="text" class="form-control form-control-dark me-2" aria-label="Search" name="search"  id="search-input"
                    placeholder="<% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()){ %>&quot;<%= request.getParameter("search") %>&quot;<% }
                    else { %>Buscar... <% } %>" >
                <button type="submit" class="btn btn-outline-light me-2" id="search-button">Buscar</button>
            </form>

            <div class="text-end">
                <% if (actualUserId.equals("0")) { %>
                    <button type="button" class="btn btn-warning  me-2" data-bs-toggle="modal" data-bs-target="#Sign-In-Modal">Login</button>
                <% } else { %>

                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                            Area Personal
                        </button>
                        <ul class="dropdown-menu ">
                            <li><a class="dropdown-item" href="my-user.jsp">Mis datos</a></li>
                            <% if (actualUserRole.equals("admin")) { %>
                                <li><a class="dropdown-item" href="users-list.jsp">Admin. usuarios</a></li>
                            <% } %>
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