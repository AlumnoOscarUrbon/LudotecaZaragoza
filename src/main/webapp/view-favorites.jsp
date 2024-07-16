<%@ page import="com.svalero.domain.Favorite" %>
<%@ page import="com.svalero.dao.FavoriteDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.util.Utils" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <main>
            <div class="container">
                <div class="container my-4"><h2 class="border-bottom pb-2 m-0">Mis Favoritos</h2></div>
            <%
                String sorted = request.getParameter("sorted");
                if (sorted == null || sorted.isBlank()) {
                    sorted="desc";
                }

                List<Favorite> favorites;

                String search = request.getParameter("search");
                if (search == null || search.isBlank()) {
                    search="";
                }

                if (!search.isBlank()){
                    String finalSearch = search;
                    favorites = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesSearch(finalSearch, actualUserId));
                } else {
                    favorites = Database.jdbi.withExtension(FavoriteDao.class, dao -> dao.getFavoritesByUserId(actualUserId));
                }
            %>
                <div class="container py-3 px-0 bg-white rounded fine-border-light shadow-lg">

                <%
                    if (sorted.equals("desc")){
                        favorites.sort(Comparator.comparing((Favorite::getRegDateTime)));
                %>
                        <div class="d-flex align-items-center border-bottom border-gray pb-2 px-4 gap-2">
                            <h7 class="mb-0 pb-0 ">Ordenados por fecha:</h7>
                            <a href="?sorted=asc&search=<%=search%>" class="text-decoration-none m-0 p-0"> Descendente
                                <img src="icons/sort-down.svg" width="16" height="16" class=" " alt="">
                            </a>
                        </div>
                <%
                    } else if (sorted.equals("asc")) {
                        favorites.sort(Comparator.comparing(Favorite::getRegDateTime).reversed());
                %>
                    <div class="d-flex align-items-center border-bottom border-gray pb-2 px-4 gap-2">
                        <h7 class="mb-0 pb-0 ">Ordenados por fecha:</h7>
                        <a href="?sorted=desc&search=<%=search%>" class="text-decoration-none m-0 p-0"> Ascendente
                            <img src="icons/sort-up.svg" width="16" height="16" class=" " alt="">
                        </a>
                    </div>
                <%
                    }
                        for (Favorite favorite : favorites) {
                    %>
                    <div class="media px-5 pt-3" id="favItem-<%=favorite.getFavoriteId()%>">

                        <div class="media-body d-flex align-items-center border-bottom border-gray" >
                            <div class="col-3 d-flex justify-content-start mb-3">
                                <a href="view-game.jsp?actualGameId=<%= favorite.getGameFav().getGameId() %>"><strong><%= favorite.getGameFav().getName() %></strong></a>
                            </div>
                            <div class="col-6 d-flex justify-content-center mx-2">
                                <p><b><%= favorite.getGameFav().getGameCategory().getName() %></b> añadido el <b><%= Utils.formatLocalDateTime(favorite.getRegDateTime()) %></b></p>
                            </div>
                            <div class="col-3 d-flex justify-content-end pe-3">
                                <a href="delete-favorite" class="delete-favorite-button" data-favorite-id="<%=favorite.getFavoriteId()%>"><img src="icons/trash.svg" alt="Trash icon" width="30" height="24" class=""></a>
                            </div>
                        </div>
                        <div id="result-reg-<%=favorite.getFavoriteId()%>"></div>

                    </div>
                    <% } %>
                </div>
            </div>
        </main>
        <%@include file="includes/footer.jsp"%>

        <!-- Eliminar favoritos -->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".delete-favorite-button").click(function(event) {
                    event.preventDefault();
                    const favoriteId = $(this).data("favorite-id");
                    const favItem = $("#favItem-" + favoriteId);
                    $(this).prop("disabled", true);
                    $.ajax({
                        type: "POST",
                        url: "delete-favorite",
                        data: {favoriteId: favoriteId},
                        success: function() {
                            favItem.animate({ opacity: 0 }, 600, function() {
                                favItem.remove();
                            });
                        },
                        error: function(response) {
                            $("#result-reg-" + favoriteId).html(response).show();
                            $(this).prop("disabled", false);
                        }
                    });
                });
            });
        </script>

    </body>
</html>