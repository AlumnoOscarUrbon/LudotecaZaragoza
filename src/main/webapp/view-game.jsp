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

<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <main>
            <%
                String catIdFilterParam = request.getParameter("catIdFilter");
                if (catIdFilterParam == null) {
                    catIdFilterParam = "";
                };
            %>
            <div class="container my-4">
                <div class="row align-items-center justify-content-center ">
                    <form class="col ">
                        <select class="form-select border border-dark-gray" id="floatingSelect" aria-label="Floating label select">
                            <option disabled <%= catIdFilterParam.equals("noFilterSelected") ? "selected" : "" %>>Selecciona una categoría</option>
                            <option value="" <%= catIdFilterParam.isEmpty() ? "selected" : "" %>>Todos los juegos</option>
                            <%
                                List<GameCategory> gameCategories = Database.jdbi.withExtension(GameCategoryDao.class, GameCategoryDao::getAllGameCategories);
                                for (GameCategory currentGameCategory : gameCategories) {
                            %>
                            <option class="" value="<%=currentGameCategory.getGameCategoryId()%>"
                                    <%= catIdFilterParam.equals(currentGameCategory.getGameCategoryId()) ? "selected" : "" %>>
                                Solo <%= currentGameCategory.getName() %>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </form>

                    <div class="col-3 mb-2 mb-md-0">
                        <button id="resetSearch" type="button" class="btn btn-warning w-100">Eliminar búsqueda en curso</button>
                    </div>

                    <% if (sessionUserRole.equals("admin")) { %>
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
                if (search == null) {
                    search = "";
                };
                String gameId = request.getParameter("currentGameId");
                if (gameId == null) {
                    gameId = "";
                };

                List<Game> games;

                //Seleccion de sentencia SQL
                if (!search.isEmpty()) {
                    String finalSearch = search;
                    games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getFilteredGames(finalSearch));
                } else if (!gameId.isEmpty()) {
                    String finalGameId = gameId;
                    games = Database.jdbi.withExtension(GameDao.class, dao -> dao.getGameById(finalGameId));
                } else {
                    games = Database.jdbi.withExtension(GameDao.class, GameDao::getAllGames);
                }

                //Filtrado por categoria
                List<Game> finalGameList = new ArrayList<>();
                if (!catIdFilterParam.isEmpty() && !catIdFilterParam.equals("noFilterSelected")) {
                    for (Game currentGame : games) {
                        if (currentGame.getGameCategoryId().equals(catIdFilterParam)) {
                            finalGameList.add(currentGame);
                        }
                    }
                } else {
                    finalGameList = games;
                }
                //Iterar
                if (finalGameList.isEmpty()) {
            %>
            <div class="container my-4 text-center"> Sin resultados. </div>
            <%
            } else {
                for (Game currentGame : finalGameList) {
            %>
            <div class="container w-100 mb-4 " id="card<%= currentGame.getGameId() %>">
                <div class="d-flex flex-lg-row flex-column p-4 align-items-center rounded-3 border shadow-lg white95">
                    <div class="p-3 p-lg-4 d-flex flex-column flex1">
                        <h1 class="display-5 fw-bold lh-0 text-body-emphasis m-0 p-0" id="titulo"><%= currentGame.getName() %></h1>
                        <p class="lead m-3 lineasmax4"><%= currentGame.getDescription() %></p>
                        <hr>
                        <p class="lead my-2 mx-3">Este <b><%= currentGame.getGameCategory().getName() %></b> fue lanzado el <b><%= Utils.formatDateTimeToDate(currentGame.getReleaseDateTime()) %></b></p>
                        <hr>
                        <div class="d-grid gap-2 d-md-flex justify-content-md-start mt-auto" >
                            <%
                                if (sessionUserRole.equals("admin")) {
                            %>
                            <a href="edit-game.jsp?currentGameId=<%= currentGame.getGameId() %>">
                                <button type="button" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Editar</button>
                            </a>
                            <button type="button" class="btn btn-danger btn-lg px-4 w-100 w-md-auto fw-bold" data-bs-toggle="modal" data-bs-target="#Delete-Modal-<%=currentGame.getGameId()%>">Eliminar</button>
                            <%
                                }
                            %>
                            <button type="button" data-current-game-id="<%= currentGame.getGameId() %>" data-session-user-id="<%= sessionUserId %>"
                                    class="btn button-favorite btn-lg px-4 w-100 w-md-auto
                                    <%  Favorite favorite = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesFromUserAndGame(sessionUserId, currentGame.getGameId())); %>
                                    <%= favorite != null ? "btn-active-yellow" : "btn-inactive" %>"
                                    <%= sessionUserId.equals("noId") ? "disabled >Inscribirse (Solo usuarios registrados)" : ">Favorito" %>
                            </button>
                        </div>
                    </div>
                    <div class="d-flex py-0 px-3 m-0 align-items-center overflow-hidden flex1 w-100 h-100">
                        <div class="position-relative w-100 h-100">
                            <img class="rounded rounded-4 object-fit-cover h350 w-100 fine-border" src="pictures/<%= currentGame.getPicture() %>" alt="imagen de juego">
                            <img src="icons/favorite-star.png" id="fav-icon-<%= currentGame.getGameId() %>" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right" <% if (favorite == null){ %> style="display:none;" <% } %>>
                        </div>
                    </div>
                </div>
                <!-- Modal confirmacion borrado -->
                <div class="modal fade" id="Delete-Modal-<%= currentGame.getGameId() %>" tabindex="-1" aria-labelledby="DeleteModalLabel-<%= currentGame.getGameId() %>" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-top-third">
                        <div class="modal-content p-3 white95 center&cover-bg" style="background-image: url('icons/stripes.jpg');">
                            <div class="modal-header d-flex justify-content-between">
                                <h2 class="fs-4 mb-0" id="SignInModalLabel">Eliminar permanentemente</h2>
                                <button type="button" class="btn-close bclose-corner" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body mx-3 d-flex flex-column justify-content-center align-items-center">
                                <h2 class="border-bottom mb-4"><b><%= currentGame.getName() %></b></h2>
                                <button class="btn btn-delete btn-danger w-50 text-center p-3" type="submit" data-current-game-id="<%= currentGame.getGameId() %>"
                                    data-bs-dismiss="modal">CONFIRMAR
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </main>
        <%@ include file="includes/footer.jsp"%>

        <!-- Desplegable Seleccion de categoria-->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".form-select").on('change', function() {
                    var selectedCatValue = $(this).val();
                    var actualUrl = window.location.href.split('?')[0];
                    var searchParams = new URLSearchParams(window.location.search);
                    var searchValue = searchParams.get('search') || '';
                    window.location.href = actualUrl + '?catIdFilter=' + selectedCatValue + '&search=' + encodeURIComponent(searchValue);
                });
            });
        </script>

        <!-- Botón Reset de busqueda y filtros-->
        <script type="text/javascript">
            $(document).ready(function() {
                $("#resetSearch").on("click", function() {
                    window.location.href = window.location.href.split('?')[0];
                });
            });
        </script>

        <!-- Eliminacion tarjetas-->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".btn-delete").on("click", function() {
                    var currentGameId = $(this).data('current-game-id');
                    var card = $("#card" + currentGameId);

                    $.ajax({
                        type: "POST",
                        url: "delete-game",
                        data: {gameId : currentGameId},
                        success: function() {
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
                $(".button-favorite").on("click", function() {
                    var buttonFavorite = $(this);
                    var currentGameId = buttonFavorite.data('current-game-id');
                    var sessionUserId = buttonFavorite.data('session-user-id');
                    var favoriteIcon = $("#fav-icon-" + currentGameId);

                    if (buttonFavorite.hasClass('btn-active-yellow')) {
                        $.ajax({
                            type: "POST",
                            url: "delete-favorite",
                            data: { gameId: currentGameId, sessionUserId: sessionUserId },
                            success: function() {
                                console.log('Se ha eliminado de favoritos correctamente');
                                buttonFavorite.removeClass('btn-active-yellow').addClass('btn-inactive');
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
                            data: { gameId: currentGameId, sessionUserId: sessionUserId },
                            success: function() {
                                console.log('Se ha añadido a favoritos correctamente');
                                buttonFavorite.removeClass('btn-inactive').addClass('btn-active-yellow');
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

    </body>
</html>
