<%@ page import="com.svalero.dao.GameDao" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="com.svalero.util.Utils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.svalero.dao.GameCategoryDao" %>
<%@ page import="com.svalero.domain.GameCategory" %>
<%@ page import="com.svalero.domain.Favorite" %>
<%@ page import="com.svalero.dao.FavoriteDao" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ include file="includes/header.jsp"%>

<link href="css/custom.css" rel="stylesheet">

<!-- Desplegable Seleccion de categoria-->
<script type="text/javascript">
    $(document).ready(function() {
            $(".form-select").on('change', function() {
                var selectedCatValue = $(this).val();
                var actualUrl = window.location.href.split('?')[0];
                var searchParams = new URLSearchParams(window.location.search);
                var searchValue = searchParams.get('search') || '';
                var newUrl = actualUrl + '?catIdFilter=' + selectedCatValue + '&search=' + encodeURIComponent(searchValue);
                window.location.href = newUrl;
            });
    });
</script>

<!-- Botón Reset de busqueda y filtros-->
<script type="text/javascript">
    $(document).ready(function() {
        $("#resetSearch").on("click", function(event) {
            window.location.href = window.location.href.split('?')[0];
        });
    });
</script>

<!-- Boton Eliminacion tarjetas-->
<script type="text/javascript">
    $(document).ready(function() {
        $(".formDelete").on("submit", function(event) {
            event.preventDefault();

            var form = $(this);
            var gameId = form.find('input[name="actualGameId"]').val();
            var card = $("#tarjeta" + gameId);

            $.ajax({
                type: "POST",
                url: "delete-game",
                data: form.serialize(),
                success: function(response) {
                    card.animate({ opacity: 0 }, 250, function() {
                        card.slideUp(300, function() {
                            card.remove();
                        });
                    });
                },
                error: function() {
                    alert('Error al eliminar la tarjeta.');
                }
            });
        });
    });
</script>

<!-- Boton favorito y aparicion de estrella -->
<script type="text/javascript">
    $(document).ready(function() {
        $(".button-favorite").on("click", function(event) {
            var buttonFavorite = $(this);
            var gameId = buttonFavorite.data('gameid');
            var actualUserId = buttonFavorite.data('actualuserid');
            var favoriteIcon = $("#fav-icon-" + gameId);

            if (buttonFavorite.hasClass('boton-activo')) {
                $.ajax({
                    type: "POST",
                    url: "delete-favorite",
                    data: { gameId: gameId, actualUserId: actualUserId },
                    success: function(response) {
                        console.log('Se ha eliminado de favoritos correctamente');
                        buttonFavorite.removeClass('boton-activo').addClass('boton-desactivado');
                        favoriteIcon.fadeOut();
                    },
                    error: function() {
                        console.error('Error al eliminar de favoritos.');
                    }
                });
            } else {
                $.ajax({
                    type: "POST",
                    url: "add-favorite",
                    data: { gameId: gameId, actualUserId: actualUserId },
                    success: function(response) {
                        console.log('Se ha añadido a favoritos correctamente');
                        buttonFavorite.removeClass('boton-desactivado').addClass('boton-activo');
                        favoriteIcon.fadeIn();
                    },
                    error: function() {
                        console.error('Error al añadir a favoritos.');
                    }
                });
            }
        });
    });
</script>
<%
    String catIdFilterParam = request.getParameter("catIdFilter");
    if (catIdFilterParam == null) {catIdFilterParam = "";};
%>

<div class="container my-4">
    <div class="row align-items-center justify-content-center ">

        <form class="col">
            <select class="form-select" id="floatingSelect" aria-label="Floating label select">
                <option disabled selected>Selecciona una categoría</option>
                <option value="" <% if (catIdFilterParam.isEmpty()) { %> selected <% } %>>Todos los juegos</option>
<%
                List<GameCategory> gameCategories = Database.jdbi.withExtension(GameCategoryDao.class, dao -> dao.getAllGameCategories());
                for (GameCategory gameCategory : gameCategories) {
%>
                    <option class="backgroundcolor<%=gameCategory.getGameCategoryId()%>" value="<%=gameCategory.getGameCategoryId()%>"
                        <% if (catIdFilterParam.equals(gameCategory.getGameCategoryId())) { %> selected <% } %>
                        > Solo <%= gameCategory.getName() %>
                    </option>
                <% } %>
            </select>
        </form>

        <div class="col-3 mb-2 mb-md-0">
            <button id="resetSearch" type="button" class="btn btn-warning w-100">Eliminar búsqueda en curso</button>
        </div>

        <% if (actualUserRole.equals("admin")) { %>
        <div class="col-12 col-md-3 ">
            <a href="edit-game.jsp" class="text-decoration-none">
                <button type="button" class="btn btn-success w-100">AÑADIR JUEGO</button>
            </a>
        </div>
        <% } %>

    </div>
</div>


    <%
        String search = request.getParameter("search");
        if (search == null) {search = "";};
        String gameId = request.getParameter("actualGameId");
        if (gameId == null) {gameId = "";};
        List<Game> games;

//FILTRADO BUSQUEDA
        if (!search.isEmpty()) {
            String finalSearch = search;
            games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getFilteredGames(finalSearch));
        } else if (!gameId.isEmpty()) {
            String finalGameId = gameId;
            games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getGameById(finalGameId));
        } else {
            games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getAllGames());
        }

//FILTRADO POR CATEGORIA
        List<Game> filtraditos = new ArrayList<>();

        if (!catIdFilterParam.isEmpty() && !catIdFilterParam.equals("noFilter")) {
            for (Game game : games) {
                if (game.getGameCategoryId().equals(catIdFilterParam)) {
                    filtraditos.add(game);
                }
            }
        } else {
            filtraditos = games;
        }

        if (filtraditos.isEmpty()) {
    %>
    <div class="container my-4 "> Sin resultados. </div>
    <%
    } else {
        for (Game game : filtraditos) {
    %>
    <div class=" container  w-100 mb-4 " id="tarjeta<%= game.getGameId() %>">
        <div class="d-flex flex-lg-row flex-column p-4 align-items-center rounded-3 border shadow-lg backgroundcolor<%= game.getGameCategoryId() %>">
            <div class="p-3 p-lg-4 d-flex flex-column flex1">
                <h1 class="display-5 fw-bold lh-0 text-body-emphasis m-0 p-0" id="titulo"><%= game.getName() %></h1>
                <p class="lead m-3 lineasmax4"><%= game.getDescription() %></p>
                <hr>
                <%
                    String gameRelease = Utils.formatDate(game.getReleaseDate());
                    String gameCategoryId = game.getGameCategoryId();
                    GameCategory gameCategoryObject = Database.jdbi.withExtension(GameCategoryDao.class, dao -> dao.getGameCategoryById(gameCategoryId));
                %>
                <p class="lead my-2 mx-3">Este <b><%= gameCategoryObject.getName() %></b> fue lanzado el <b><%= gameRelease %></b></p>
                <hr>
                <div class="d-grid gap-2 d-md-flex justify-content-md-start mt-auto" >
                    <% if (actualUserRole.equals("admin")) { %>
                    <a href="edit-game.jsp?actualGameId=<%= game.getGameId() %>">
                        <button type="button" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Editar</button>
                    </a>
                    <form class="formDelete" action="delete-game" method="post">
                        <input type="hidden" name="actualGameId" value="<%= game.getGameId() %>">
                        <button type="submit" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Eliminar</button>
                    </form>
                    <% } %>
                    <button type="button" class="btn button-favorite btn-lg px-4 w-100 w-md-auto
                        <%
                            Favorite favorite = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesFromUserAndGame(actualUserId, game.getGameId()));
                            if (favorite != null){
                        %>
                                boton-activo
                            <% } else { %>
                                boton-desactivado
                            <% } %>
                    " data-gameid="<%= game.getGameId() %>" data-actualuserid="<%= actualUserId %>"
                            <% if (actualUserId.equals("noId")){ %>
                                disabled > Favorito (Solo usuarios registrados)
                            <% } else { %>
                                > Favorito
                            <% } %>
                    </button>
                </div>
            </div>
            <div class="d-flex py-0 px-3 m-0 align-items-center overflow-hidden flex1 w-100 h-100">
                <div class="position-relative w-100 h-100">
                    <img class="rounded rounded-4 object-fit-cover h350 w-100 fine-border" src="pictures/<%= game.getPicture() %>" alt="">
                    <img src="icons/favorite-star.png" id="fav-icon-<%= game.getGameId() %>" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right" <% if (favorite == null){ %> style="display:none;" <% } %>>
                </div>
            </div>
        </div>
    </div>
    <%
            }
        }
    %>

<%@ include file="includes/footer.jsp"%>

