<%@ page import="com.svalero.domain.Favorite" %>
<%@ page import="com.svalero.dao.FavoriteDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.util.Utils" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="static com.svalero.util.Utils.formatLocalTimeNoSec" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <%
            if (sessionUserId.equals("noId")) {
                response.sendRedirect("/LudotecaZaragoza");
            }
        %>
        <main>
            <div class="container">
                <div class="container my-4">
                    <h2 class="border-bottom pb-2 m-0">Mis Favoritos</h2>
                </div>
            <%
                String sorted = request.getParameter("sorted");
                if (sorted == null || sorted.isBlank()) {
                    sorted="desc";
                }

                List<Favorite> favorites;

                String search = request.getParameter("search");
                if (search == null || search.isBlank()) {
                    search="%";
                }

                String finalSearch = search;
                favorites = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesSearch(finalSearch, sessionUserId));

                if (favorites.isEmpty()) {
            %>
            <div class="container my-4 text-center">Sin resultados.</div>
            <%
                } else {
            %>
            <div class="container py-3 px-0 bg-white rounded fine-border-light shadow-lg">
                <%
                    if (sorted.equals("desc")){
                        favorites.sort(Comparator.comparing((Favorite::getRegDateTime)));
                %>
                <div class="d-flex align-items-center border-bottom border-gray pb-2 px-4 gap-2">
                    <h6 class=" lh-1 mb-0">Ordenados por fecha:</h6>
                    <a href="?sorted=asc&search=<%= search %>" class="text-decoration-none m-0 p-0"> Descendente
                        <img src="icons/sort-down.svg" width="16" height="16" alt="Imagen descendente">
                    </a>
                </div>
                <%
                    } else if (sorted.equals("asc")) {
                        favorites.sort(Comparator.comparing(Favorite::getRegDateTime).reversed());
                %>
                <div class="d-flex align-items-center border-bottom border-gray pb-2 px-4 gap-2">
                    <h6 class=" lh-1 mb-0 ">Ordenados por fecha:</h6>
                    <a href="?sorted=desc&search=<%= search %>" class="text-decoration-none m-0 p-0"> Ascendente
                        <img src="icons/sort-up.svg" width="16" height="16" alt="Imagen ascendente">
                    </a>
                </div>
                <%
                    }
                    for (Favorite currentFavorite : favorites) {
                %>
                    <div class="media px-5 pt-3 white95" id="favItem-<%=currentFavorite.getFavoriteId()%>">

                        <div class="media-body d-flex align-items-center border-bottom border-gray" >
                            <div class="col-3 d-flex justify-content-start mb-3">
                                <a href="view-game.jsp?currentGameId=<%= currentFavorite.getGameFav().getGameId() %>">
                                    <strong>
                                        <%= currentFavorite.getGameFav().getName() %>
                                    </strong></a>
                            </div>
                            <div class="col-6 d-flex justify-content-center mx-2">
                            <%
                                String regDate = Utils.formatDateTimeToDate(currentFavorite.getRegDateTime());
                                String regTime = formatLocalTimeNoSec(currentFavorite.getRegDateTime());
                            %>
                                <p><b><%= currentFavorite.getGameFav().getGameCategory().getName() %></b> añadido a favoritos el <b><%= regDate %></b> a las <b><%= regTime %></b></p>
                            </div>
                            <div class="col-3 d-flex justify-content-end pe-3">
                                <a href="delete-favorite" class="delete-favorite-button" data-favorite-id="<%=currentFavorite.getFavoriteId()%>">
                                    <img src="icons/trash.svg" alt="Trash icon" width="30" height="24">
                                </a>
                            </div>
                        </div>
                        <div id="result-reg-<%=currentFavorite.getFavoriteId()%>"></div>
                    </div>
                <%
                    }
                %>
                </div>
            <%
                }
            %>
            </div>
        </main>
        <%@include file="includes/footer.jsp"%>

        <!-- Eliminar favoritos -->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".delete-favorite-button").click(function(event) {
                    event.preventDefault();
                    const currentFavoriteId = $(this).data("favorite-id");
                    const favItem = $("#favItem-" + currentFavoriteId);
                    $(this).prop("disabled", true);
                    $.ajax({
                        type: "POST",
                        url: "delete-favorite",
                        data: {favoriteId: currentFavoriteId},
                        success: function() {
                            favItem.animate({ opacity: 0 }, 300, function() {
                                favItem.remove();
                            });
                        },
                        error: function(response) {
                            $("#result-reg-" + currentFavoriteId).html(response).show();
                            $(this).prop("disabled", false);
                        }
                    });
                });
            });
        </script>

    </body>
</html>