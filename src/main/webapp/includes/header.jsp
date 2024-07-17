<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.svalero.dao.Database" %>
<%@ page import="java.sql.SQLException" %>

<%
    try {
        Database.connect();
    } catch (SQLException | ClassNotFoundException e) {
        System.out.println("Error estableciendo conexion con BBDD");
        e.printStackTrace();
        throw new RuntimeException(e);
    }

//  Reconocimiento usuario
    HttpSession currentSession = request.getSession();
    String sessionUserId;
    String sessionUserRole;

    if (currentSession.getAttribute("id") != null) {
        sessionUserId = currentSession.getAttribute("id").toString();
        sessionUserRole = currentSession.getAttribute("role").toString();
    } else {
        sessionUserId = "noId";
        sessionUserRole = "noRole";
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
                    <input type="text" class="form-control form-control-dark me-2" aria-label="Search" name="search" id="search-input"
                    <%
                       // Obtener nombre del jsp actual
                       String uri = request.getRequestURI();
                       String fileName = uri.substring(uri.lastIndexOf('/') + 1);
                       //Deshabilitar buscador en paginas especificas
                       if (fileName.equals("edit-game.jsp") || fileName.equals("edit-activity.jsp") || (fileName.equals("view-user.jsp") && !sessionUserRole.equals("admin"))) {
                    %>
                            disabled placeholder="No disponible aquí"
                   <%  } else { %>
                            placeholder="<% if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()){ %> &quot;<%= request.getParameter("search") %>&quot;
                    <% } else { %>Buscar... <% } } %>" >
                    <button type="submit" class="btn btn-outline-light" id="search-button">Buscar</button>
                </form>

                <div class="text-end ">
                    <% if (sessionUserId.equals("noId")) { %>
                        <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#Sign-In-Modal">Login</button>
                    <% } else { %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Area Personal</button>
                            <ul class="dropdown-menu ">
                                <li><a class="dropdown-item" href="view-user.jsp"> <%= sessionUserRole.equals("admin") ? "Usuarios" : "Mis datos" %></a></li>
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

<!-- Auto seleccion campo busqueda -->
<script>
    $(document).ready(function(){
        $("#search-input").focus();
    });
</script>