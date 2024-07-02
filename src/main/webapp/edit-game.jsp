<%@ page import="com.svalero.dao.GameDao" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="java.util.List" %>
<%@ include file="includes/header.jsp"%>

<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        $("#edit-button").click(function (event) {--%>
<%--            event.preventDefault();--%>
<%--            const form = $("#edit-form")[0];--%>
<%--            const data = new FormData(form);--%>

<%--            $("#edit-button").prop("disabled", true);--%>

<%--            $.ajax({--%>
<%--                type: "POST",--%>
<%--                enctype: "multipart/form-data",--%>
<%--                url: "edit-game",--%>
<%--                data: data,--%>
<%--                processData: false,--%>
<%--                contentType: false,--%>
<%--                cache: false,--%>
<%--                timeout: 600000,--%>
<%--                success: function (data) {--%>
<%--                    $("#result").html(data);--%>
<%--                    $("#edit-button").prop("disabled", false);--%>
<%--                },--%>
<%--                error: function (error) {--%>
<%--                    $("#result").html(error.responseText);--%>
<%--                    $("#edit-button").prop("disabled", false);--%>
<%--                }--%>
<%--            });--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>

<%
    String gameId;
    Game game = null;

    if (request.getParameter("actualGameId") == null){
        gameId ="0";
    } else {
        gameId = request.getParameter("actualGameId");
        List<Game> gameList = Database.jdbi.withExtension(GameDao.class, dao -> dao.getGameById(gameId));
        game = gameList.get(0);
    }
%>
<section class="py-5 container">
    <div class="row p-4 align-items-center rounded-3 border shadow-lg justify-content-between">
        <% if (gameId.equals("0")){ %>
        <h2 class = "mb-0"> Registrar nuevo juego </h2>
        <% } else { %>
        <h1 class = "mb-0"> Actualizar juego </h1>
        <% } %>

        <form class="row g-3 needs-validation"  enctype="multipart/form-data" id="edit-form" action="edit-game" method="post">
            <div class="mb-3">
                <label for="name" class="form-label " >Nombre</label>
                <input type="text" name="gameName" class="form-control" id="name" placeholder="Ejemplo: Monopoly"
                    <% if (!gameId.equals("0")){%> value= "<%= game.getName()%>" <%} else {}%>>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Descripcion</label>
                <textarea rows="4" cols="50" name="gameDescription" class="form-control" id="description" placeholder="Ejemplo: Divertido juego donde ganarás una fortuna... "><% if (!gameId.equals("0")){%><%=game.getDescription()%><%}%></textarea>
            </div>

            <div class="col-md-4">
                <label for="date" class="form-label">Fecha de lanzamiento</label>
                <input type="date" name = "gameRelease" class="form-control" id="date" placeholder="dd/mm/yyyy"
                    <% if (!gameId.equals("0")){%> value="<%=game.getReleaseDate()%>"<%}%> required>
            </div>

            <div class="col-md-4">
                <label for="category" class="form-label">Categoria</label>
                <select class="form-select" name ="gameCategory" id="category" required>
                        <option value="">Selecciona</option>
                        <option value="1">Juego de mesa</option>
                        <option value="2">Videojuego</option>
                </select>
                <div class="invalid-feedback">
                    Selección no válida
                </div>
            </div>

            <div class="col-md-4">
                <label for="picture" class="form-label">Imagen</label>
                <input type="file" name="gamePicture" class="form-control" id="picture">
            </div>

            <div class="col-12 d-flex justify-content-end mb-2 mt-4">
                <button class="btn btn-primary w-25 py-3 " type="submit" value="enviar" id="edit-button">ACTUALIZAR</button>
            </div>
            <input type="hidden" name="gameId" value="<%= gameId %>"/>
        </form>
        <br>
        <div id="result" ></div>
    </div>
</section>

<%@include file="includes/footer.jsp"%>
