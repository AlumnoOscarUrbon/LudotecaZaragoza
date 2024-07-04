<%@ page import="com.svalero.dao.GameDao" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="com.svalero.util.Utils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.svalero.dao.GameCategoryDao" %>
<%@ page import="com.svalero.domain.GameCategory" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ include file="includes/header.jsp"%>

<!-- Seleccion de categoria-->
<script type="text/javascript">
    $(document).ready(function() {
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
    });
</script>

<!-- Reset de busqueda y filtros-->
<script type="text/javascript">
    $(document).ready(function() {
        $("#resetSearch").on("click", function(event) {
            window.location.href = window.location.href.split('?')[0];
        });
    });
</script>

<!-- Eliminacion tarjetas-->
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

<%
    String catIdFilterParam = request.getParameter("catIdFilter");
    if (catIdFilterParam == null) {catIdFilterParam = "";};
%>
<div class="container align-items-center">
    <form class="row gx-3 align-items-start align-items-center">
        <div class="col-12 col-md-9">
            <select class="form-select w-100 mt-4 " id="floatingSelect" aria-label="Floating label select example">
                <option disabled selected >Selecciona una categoría</option>
                <option value="" <% if (catIdFilterParam.isEmpty()) { %> selected <% } %>>Todos los juegos</option>
<%
                    List < GameCategory> gameCategories = Database.jdbi.withExtension(GameCategoryDao.class, dao -> dao.getAllGameCategories());
                    for (GameCategory gameCategory : gameCategories) {
%>
                        <option class=" backgroundcolor<%=gameCategory.getGameCategoryId()%> " value="<%=gameCategory.getGameCategoryId()%>"
                                <% if (catIdFilterParam.equals(gameCategory.getGameCategoryId())) { %>
                                    selected
                                <% } %>
                                > Solo <%= gameCategory.getName() %>
                        </option>

                    <% } %>
            </select>
        </div>
        <div class="col-12 col-md-3 d-grid">
            <button id="resetSearch" type="button" class="btn btn-warning w-100 mt-4" >Eliminar búsqueda en curso</button>
        </div>
    </form>

    <% if (actualUserRole.equals("admin")) { %>
    <div class="row justify-content-center mt-4">
        <div class="col-12 col-lg-6 text-center">
            <a href="edit-game.jsp" class="w-100">
                <button type="button" class="btn btn-success btn-lg py-3 px-4 rounded-3">AÑADIR NUEVO JUEGO</button>
            </a>
        </div>
    </div>
    <% } %>
</div>



<div id="custom-cards-games" class="container my-2">
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
//FILTRADO POSTERIOR POR CATEGORIA
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
    <div class="container my-4"> Sin resultados. Prueba con otra búsqueda. </div>
    <%
    } else {
        for (Game game : filtraditos) {
    %>
    <div class="container my-5 " id="tarjeta<%= game.getGameId() %>">
        <div class="row p-4 align-items-center rounded-3 border shadow-lg justify-content-between backgroundcolor<%=game.getGameCategoryId()%>">
            <div class="col-lg-6 p-3 p-lg-4 align-items-stretch">
                <h1 class="display-4 fw-bold lh-1 text-body-emphasis m-2"><%= game.getName() %></h1>
                <p class="lead m-4"><%= game.getDescription() %></p>
                <hr>
                <% String gameRelease = Utils.formatDate(game.getReleaseDate()); %>
<%
                    String gameCategoryId = game.getGameCategoryId();
                    GameCategory gameCategoryObject = Database.jdbi.withExtension(GameCategoryDao.class, dao -> dao.getGameCategoryById(gameCategoryId));
%>
                <p class="lead m-4">Este <b> <%= gameCategoryObject.getName() %></b> fue lanzado el <b><%= gameRelease %> </b></p>
                <hr>
                <div class="d-grid gap-2 d-md-flex justify-content-md-start" id="buttons">
                    <% if (actualUserName.equals("admin")) { %>
                    <a href="edit-game.jsp?actualGameId=<%= game.getGameId() %>">
                        <button type="button" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Editar</button>
                    </a>
                    <form class="formDelete" action="delete-game" method="post">
                        <input type="hidden" name="actualGameId" value="<%= game.getGameId() %>">
                        <button type="submit" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Eliminar</button>
                    </form>
                    <% } %>
                    <button type="button" class="btn btn-outline-secondary btn-lg px-4 w-100 w-md-auto">Favorito</button>
                </div>
            </div>
            <div class="col-lg-6 p-0 overflow-hidden d-flex align-items-center">
                <img class="img-responsive d-block rounded rounded-4 h-100 m-2" src="pictures/<%= game.getPicture() %>" alt="">
            </div>
        </div>
    </div>
    <%
            }
        }
    %>
</div>


<%@ include file="includes/footer.jsp"%>

