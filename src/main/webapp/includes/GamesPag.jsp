<%@ page import="com.svalero.dao.GameDao" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.domain.Game" %>
<%@ page import="com.svalero.dao.FavoriteDao" %>
<%@ page import="com.svalero.domain.Favorite" %>
<%@ page import="static com.svalero.util.Constants.HOWMANYCARDS" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<link href="css/custom.css" rel="stylesheet">

<script type="text/javascript">
    // Botones paginación
    $(document).on('click', 'a.pag-games', function(e) {
        e.preventDefault();
        const url = $(this).attr('href');  // Obtiene la URL del atributo href
        loadGames(url);
    });
    // Refrescar solo tarjetas y paginacion
    function loadGames(url) {
        const $actualCardsContent = $('#custom-cards-games');
        const $actualPagContent = $('#pagination-games');

        $actualCardsContent.animate({ opacity: 0 }, 400, function() {
            $.ajax({
                url: url,
                success: function(response) {
                    const newCardsContent = $('<div>').append($.parseHTML(response)).find('#custom-cards-games').html();
                    const newPagContent = $('<div>').append($.parseHTML(response)).find('#pagination-games').html();
                    $actualCardsContent.html(newCardsContent);
                    $actualPagContent.html(newPagContent);

                    $('#custom-cards-games').animate({ opacity: 1}, 300);
                },
                error: function() {
                    alert('Error al cargar los datos.');
                    $actualCardsContent.animate({opacity: 1}, 400); // Deshacer animación
                }
            });
        });
    }
</script>

<div class="container">
    <div class="container">
        <h2 class="border-bottom mt-4 mb-2 pb-2">Juegos</h2>
    </div>
    <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-4 " id="custom-cards-games">

<%
//comprobar si hay busqueda activa

            List<Game> games;
            if (search.isEmpty()) {
                games = Database.jdbi.withExtension(GameDao.class, GameDao::getAllGames);
            } else {
                String finalSearch = search;
                games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getFilteredGames(finalSearch));
            }
//calcular total de resultados
            int sizeGames;
            if (games.isEmpty()){
                sizeGames = 0;
            } else {
                sizeGames = games.size();
            };

//consultar en que pagina estamos
            int actualRowGames;
            if (request.getParameter("actualRowGames")==null){
                actualRowGames = 0;
            } else {
                actualRowGames = Integer.parseInt (request.getParameter("actualRowGames"));
            }
//determinar cartas de pagina actual
            int firstOfRowGame = (actualRowGames * HOWMANYCARDS);
            int lastOfRowGames;
            int extraGames = sizeGames % HOWMANYCARDS;
            if ((firstOfRowGame + HOWMANYCARDS) > sizeGames) {
                lastOfRowGames = firstOfRowGame + extraGames;
            } else {
                lastOfRowGames = firstOfRowGame + HOWMANYCARDS;
            }

            List <Game> packagedGames = games.subList(firstOfRowGame, lastOfRowGames);

            if (packagedGames.isEmpty()) {
%>
        <div class="container my-2 text-center"> <p>Sin resultados.</p> </div>
<%
            } else {
                for (Game game : packagedGames){
%>
            <div class="col">
                <a href="view-game.jsp?actualGameId=<%= game.getGameId() %>&catIdFilter=noFilterSelected" class="text-decoration-none">
                    <div class="card card-cover overflow-hidden  rounded-4 shadow-lg center&cover-bg position-relative fine-border"  style="background-image: url('pictures/<%= game.getPicture() %>');">
                        <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
                            <h3 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold text-bordered"><%= game.getName()%></h3>
                                <%
                                    Favorite favorite = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesFromUserAndGame(actualUserId, game.getGameId()));
                                    if (favorite != null){
                                %>
                                <img src="icons/favorite-star.png" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right">
                                <% } %>
                        </div>
                    </div>
                </a>
            </div>
<%
                }
            }
%>
    </div>

    <!-- paginación de juegos-->
    <nav aria-label="Page navigation example" class="mt-4" id="pagination-games">
        <ul class="pagination justify-content-center">

            <li class="page-item
                <% if (actualRowGames <= 0) { %> disabled <% } %>">
                <a class="page-link pag-games" href="index.jsp?actualRowGames=<%=actualRowGames-1%>&search=<%=search%>">Anterior</a>
            </li>

<%
                int totalGamePages = (int)Math.ceil((double) sizeGames /HOWMANYCARDS);
                for (int i = 0; i < totalGamePages; i++){
%>
            <li class="page-item <% if (actualRowGames == i) { %> active <% } %>">
                <a class="page-link pag-games" href="index.jsp?actualRowGames=<%=i%>&search=<%=search%>"><%=i+1%></a>
            </li>
            <% }; %>

            <li class="page-item
                <% if ((actualRowGames + 1) >= totalGamePages) { %> disabled <% } %>">
                <a class="page-link pag-games" href="index.jsp?actualRowGames=<%=actualRowGames+1%>&search=<%=search%>">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>

