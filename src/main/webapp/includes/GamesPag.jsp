<%@ page import="com.svalero.dao.GameDao" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.dao.FavoriteDao" %>
<%@ page import="com.svalero.domain.Favorite" %>
<%@ page import="static com.svalero.util.Constants.HOWMANYCARDS" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<link href="css/custom.css" rel="stylesheet">

<!--REFRESCAR BOTONES Y PAGINACION -->
<script type="text/javascript">
    $(document).on('click', 'a.pag-games', function(e) {
        e.preventDefault();
        const url = $(this).attr('href');
        const $currentCardsContent = $('#custom-cards-games');
        const $currentPagContent = $('#pagination-games');
        $currentCardsContent.animate({ opacity: 0 }, 400, function() {
            $.ajax({
                url: url,
                success: function(response) {
                    const newCardsContent = $('<div>').append($.parseHTML(response)).find('#custom-cards-games').html();
                    const newPagContent = $('<div>').append($.parseHTML(response)).find('#pagination-games').html();
                    $currentCardsContent.html(newCardsContent);
                    $currentPagContent.html(newPagContent);
                    $('#custom-cards-games').animate({ opacity: 1}, 300);
                },
                error: function() {
                    alert('Error al cargar los datos.');
                    $currentCardsContent.animate({opacity: 1}, 400); // Deshacer animación
                }
            });
        });
    });
</script>

<div class="container">
    <div class="container">
        <h2 class="border-bottom mt-4 mb-2 pb-2">Juegos</h2>
    </div>
    <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-4" id="custom-cards-games">

    <%
        //Seleccion de resultados
        List<Game> games;
        if (!search.isBlank()) {
            String finalSearch = search;
            games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getFilteredGames(finalSearch));
        } else {
            games = Database.jdbi.withExtension(GameDao.class, GameDao::getAllGames);
        }

        //Determinar pagina actual
        int currentRowGames;
        if (request.getParameter("currentRowGames")==null){
            currentRowGames = 0;
        } else {
            currentRowGames = Integer.parseInt (request.getParameter("currentRowGames"));
        }

        //Cartas en pagina actual
        int totalSizeGames = games.size();
        int firstOfRowGame = currentRowGames * HOWMANYCARDS;
        int extraGames = totalSizeGames % HOWMANYCARDS;

        int lastOfRowGames;
        if ((firstOfRowGame + HOWMANYCARDS) > totalSizeGames) {
            lastOfRowGames = firstOfRowGame + extraGames;
        } else {
            lastOfRowGames = firstOfRowGame + HOWMANYCARDS;
        }
        //Iterar
        List <Game> packagedGames = games.subList(firstOfRowGame, lastOfRowGames);
        if (packagedGames.isEmpty()) {
    %>
        <div class="container my-2 text-center"><p>Sin resultados.</p></div>
    <%
        } else {
            for (Game currentGame : packagedGames){
    %>
        <div class="col">
            <a href="view-game.jsp?currentGameId=<%= currentGame.getGameId() %>&catIdFilter=noFilterSelected" class="text-decoration-none">
                <div class="card card-cover overflow-hidden rounded-4 shadow-lg center&cover-bg position-relative fine-border" style="background-image: url('pictures/<%= currentGame.getPicture() %>');">
                    <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
                        <h3 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold text-bordered"><%= currentGame.getName() %></h3>
                        <%
                            Favorite favorite = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesFromUserAndGame(sessionUserId, currentGame.getGameId()));
                            if (favorite != null) {
                        %>
                        <img src="icons/favorite-star.png" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right">
                        <%
                            }
                        %>
                    </div>
                </div>
            </a>
        </div>
        <%
                }
            }
        %>
    </div>

    <!-- Paginación de juegos -->
    <nav aria-label="Page navigation example" class="mt-4" id="pagination-games">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= currentRowGames <= 0 ? "disabled" : "" %>">
                <a class="page-link pag-games" href="index.jsp?currentRowGames=<%= currentRowGames - 1 %>&search=<%= search %>">Anterior</a>
            </li>
            <%
                int totalGamePages = (int) Math.ceil((double) totalSizeGames / HOWMANYCARDS);
                for (int i = 0; i < totalGamePages; i++) {
            %>
            <li class="page-item <%= currentRowGames == i ? "active" : "" %>">
                <a class="page-link pag-games" href="index.jsp?currentRowGames=<%= i %>&search=<%= search %>"><%= i + 1 %></a>
            </li>
            <%
                }
            %>
            <li class="page-item <%= (currentRowGames + 1) >= totalGamePages ? "disabled" : "" %>">
                <a class="page-link pag-games" href="index.jsp?currentRowGames=<%= currentRowGames + 1 %>&search=<%= search %>">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>

