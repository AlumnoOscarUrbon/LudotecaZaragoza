<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.svalero.dao.Database" %>
<%@ page import="java.sql.SQLException" %>

<%

    try {
        Database.connect();
    } catch (SQLException | ClassNotFoundException e) {
        System.out.println("Error estableciendo conexion con BBDD");
        throw new RuntimeException(e);
    }

//  RECONOCIMIENTO DE USUARIO

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

    <header class="p-3 text-bg-dark">
        <div class="container">
            <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start gap-2 gap-lg-3">

                <a href="index.jsp" class="mb-0">
                    <img src="icons/ludotecaZaragoza -logo.png" class="logo-size" alt="imagen del logotipo"/>
                </a>

                <ul class="nav col-12 col-lg-auto ms-lg-auto justify-content-center ">
                    <li><a href="view-game.jsp" class="nav-link px-2 text-white ">Juegos</a></li>
                    <li><a href="view-activity.jsp" class="nav-link px-2 text-white ">Actividades</a></li>
                </ul>

                <form class="d-flex align-items-center" role="search" id="search-form" method="GET">
                    <%
                        if (request.getParameter("catIdFilter") != null){
                            if (!request.getParameter("catIdFilter").isBlank()){
                    %>
                            <input type="hidden" name="catIdFilter" value="<%= request.getParameter("catIdFilter") %>">
                    <%
                            }
                        }
                    %>
                    <input type="text" class="form-control form-control-dark me-2" aria-label="Search" name="search"  id="search-input"
                       <%
                           // OBTENER NOMBRE DEL ARCHIVO JSP ACTUAL
                           String uri = request.getRequestURI();
                           String fileName = uri.substring(uri.lastIndexOf('/') + 1);
                           //DESHABILITAR BUSCADOR EN PAGINAS CONCRETOS.
                           if (fileName.equals("edit-game.jsp") || fileName.equals("edit-activity.jsp") || (fileName.equals("view-user.jsp") && !actualUserRole.equals("admin"))) {
                       %>
                                disabled placeholder="No disponible aquí"
                       <%  } else { %>
                                placeholder="<% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()){ %> &quot;<%= request.getParameter("search") %>&quot;
                            <% } else { %>Buscar... <% } } %>" >
                    <button type="submit" class="btn btn-outline-light" id="search-button">Buscar</button>
                </form>

                <div class="text-end ">
                    <% if (actualUserId.equals("noId")) { %>
                        <button type="button" class="btn btn-warning " data-bs-toggle="modal" data-bs-target="#Sign-In-Modal">Login</button>
                    <% } else { %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Area Personal</button>
                            <ul class="dropdown-menu ">
                                <li><a class="dropdown-item" href="view-user.jsp"> <% if (actualUserRole.equals("admin")) { %> Usuarios <% } else { %> Mis datos <% } %></a></li>
                                <li><a class="dropdown-item" href="view-favorites.jsp"> Mis favoritos </a></li>
                                <li><a class="dropdown-item" href="view-signups.jsp"> Mis Inscripciones </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="logout">Cerrar sesión</a></li>
                            </ul>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </header>

<%@ include file="LoginPag.jsp"%>

<!-- AUTO-SELECCIONAR INPUT BUSQUEDA -->
<script>
    $(document).ready(function(){
        $("#search-input").focus();
    });
</script>