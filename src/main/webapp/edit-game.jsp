<%@ page import="com.svalero.dao.GameDao" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.domain.GameCategory" %>
<%@ page import="com.svalero.dao.GameCategoryDao" %>
<%@ include file="includes/header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#edit-button").click(function (event) {
            event.preventDefault();
            const form = $("#edit-form")[0];
            const data = new FormData(form);
            $("#edit-button").prop("disabled", true);

            $.ajax({
                type: "POST",
                enctype: "multipart/form-data",
                url: "edit-game",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                success: function (response) {
                    $("#resulta").html(response).show();
                    setTimeout(function () {
                        var gameName = $("#edit-form").find('input[name="gameName"]').val();

                        // Redirigir a view-game.jsp después de 2 segundos en caso de éxito
                        window.location.href = 'view-game.jsp?catIdFilter=noFilter&search=' + encodeURIComponent(gameName);
                    }, 2500);
                },
                error: function (xhr) {
                    $("#resulta").html(xhr.responseText).show();
                    // Re-habilitar el botón en caso de error
                    $("#edit-button").prop("disabled", false);
                    setTimeout(function () {
                        $("#resulta").slideUp();
                    }, 2000);
                }
            });
        });
    });
</script>

<%
    String gameId;
    Game game = null;

    if (request.getParameter("actualGameId") == null || request.getParameter("actualGameId").isEmpty()){
        gameId ="noId";
    } else {
        gameId = request.getParameter("actualGameId");
        List<Game> gameList = Database.jdbi.withExtension(GameDao.class, dao -> dao.getGameById(gameId));
        game = gameList.get(0);
    }
%>

<section class="py-5 container">
    <div class="row p-4 align-items-center rounded-3 border shadow-lg justify-content-between">

        <h2 class = "mb-0">
            <% if (gameId.equals("noId")){ %>
                Registrar un juego nuevo
            <% } else { %>
                Actualizar <%= game.getName()%>
            <% } %>
        </h2>

        <form class="row g-3 needs-validation"  enctype="multipart/form-data" id="edit-form" action="edit-game" >
            <div class="mb-3">
                <label for="name" class="form-label">Nombre</label>
                <input type="text" name="gameName" class="form-control" id="name" placeholder="Monopoly"
                    <% if (!gameId.equals("noId")){%> value= "<%= game.getName()%>" <% } %>>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Descripcion</label>
                <textarea rows="4" cols="50" name="gameDescription" class="form-control" id="description" placeholder="Divertido juego donde ganarás una fortuna... "><% if (!gameId.equals("noId")){ %><%= game.getDescription() %><% } %></textarea>
            </div>

            <div class="col-md-4">
                <label for="date" class="form-label">Fecha de lanzamiento</label>
                <input type="date" name = "gameRelease" class="form-control" id="date" placeholder="dd/mm/yyyy"
                    <% if (!gameId.equals("noId")){%> value="<%= game.getReleaseDate() %>"<% } %> >
            </div>

            <div class="col-md-4">
                <label for="category" class="form-label">Categoria</label>
                <select class="form-select" name ="gameCategoryId" id="category" >
                        <option disabled <% if (gameId.equals("noId")){ %> selected <% } %> >Selecciona</option>
    <%
                            List < GameCategory> categories = Database.jdbi.withExtension(GameCategoryDao.class, dao -> dao.getAllGameCategories());
                            for (GameCategory category : categories) {
    %>
                        <option value="<%= category.getGameCategoryId()%>"
                                <% if (!gameId.equals("noId")) { if (game.getGameCategoryId().equals(category.getGameCategoryId())) { %> selected <% };}; %>> <%= category.getName()%></option>
    <% } %>
                </select>
                <div class="invalid-feedback">
                    Selección no válida
                </div>
            </div>

            <div class="col-md-4">
                <label for="picture" class="form-label">Imagen</label>
                <input type="file" name="gamePicture" class="form-control" id="picture">
            </div>
            <input type="hidden" name="gameId" value="<%=gameId%>"/>
            <div class="col-12 d-flex justify-content-end mb-3 mt-4">
                <button class="btn btn-primary w-25 py-3 " type="submit" id="edit-button">
                    <% if (gameId.equals("noId")){ %> REGISTRAR <% } else { %> ACTUALIZAR <% } %>
                </button>
            </div>

        </form>
        <br>
        <div id="resulta" ></div>
    </div>
</section>
<%@include file="includes/footer.jsp"%>
