<%@ page import="com.svalero.dao.BoardgameDao" %>
<%@ page import="com.svalero.domain.Boardgame" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>

<script type="text/javascript">
    // Listener para los clics en los enlaces de paginación
    $(document).on('click', 'a.pag-boardgames', function(e) {
        e.preventDefault();
        const url = $(this).attr('href');  // Obtiene la URL del atributo href
        loadBoardgames(url);
    });
    // Función para refrescar solo tarjetas y paginacion
    function loadBoardgames(url) {
        const $actualCardsContent = $('#custom-cards-boardgames');
        const $actualPagContent = $('#pagination-boardgames');

        $actualCardsContent.animate({ opacity: 0 }, 500, function() {
            $.ajax({
                url: url,
                success: function(response) {
                    const newCardsContent = $(response).find('#custom-cards-boardgames').html();
                    const newPagContent = $(response).find('#pagination-boardgames').html();
                    $actualCardsContent.html(newCardsContent);
                    $actualPagContent.html(newPagContent);

                    $('#custom-cards-boardgames').animate({ opacity: 1}, 400);
                },
                error: function() {
                    alert('Error al cargar los datos.');
                    $actualCardsContent.animate({opacity: 1}, 400); // Deshacer animación
                }
            });
        });
    }
</script>

<div id="boardgames-content">
    <div class="container px-4 py-5" id="custom-cards-boardgames">
        <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-5" id="card-container">
            <%
                List<Boardgame> boardgames = null;
//comprobar si hay busqueda y actuar en consecuencia
                String search;
                if (request.getParameter("search")==null){
                    search = "";
                } else {
                    search = request.getParameter("search");
                }

                if (search.isEmpty()) {
                    boardgames = Database.jdbi.withExtension(BoardgameDao.class, BoardgameDao::getAllBoardgames);
                } else {
                    boardgames = Database.jdbi.withExtension(BoardgameDao.class, dao -> dao.getFilteredBoardgames(search));
                }
//determinar total de resultados
                int sizeBoardgames;
                if (boardgames.isEmpty()){
                    sizeBoardgames = 0;
                } else {
                    sizeBoardgames = boardgames.size();
                };

//determinar en que pagina estamos
                int actualRowBoardgames;
                if (request.getParameter("actualRowBoardgames")==null){
                    actualRowBoardgames = 0;
                } else {
                    actualRowBoardgames = Integer.parseInt (request.getParameter("actualRowBoardgames"));
                }
//determinar cartas de pagina actual
                int firstOfRowBoardgame = (actualRowBoardgames * 3);
                int lastOfRowBoardgames;
                int extraBoardgames = sizeBoardgames % 3;
                if ((firstOfRowBoardgame + 3) > sizeBoardgames) {
                    lastOfRowBoardgames = firstOfRowBoardgame + extraBoardgames;
                } else {
                    lastOfRowBoardgames = firstOfRowBoardgame + 3;
                }

                List <Boardgame> packagedBoardgames = boardgames.subList(firstOfRowBoardgame, lastOfRowBoardgames);

                for (Boardgame boardgame : packagedBoardgames){
            %>
            <div class="col">
                <a href="view-boardgame.jsp?boardgameId=<%= boardgame.getBoardgameId() %>" class="text-decoration-none">
                    <div class="card card-cover  overflow-hidden text-bg-dark rounded-4 shadow-lg" id="tarjetas" style="background-image: url('pictures/<%= boardgame.getPicture() %>');">
                        <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
                            <h3 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold"><%= boardgame.getName()%></h3>
                            <ul class="d-flex list-unstyled mt-auto">
                                <li class="me-auto">
                                    <img src="https://github.com/twbs.png" alt="Icono favorito" width="32" height="32" class="rounded-circle border border-white">
                                </li>
                            </ul>
                        </div>
                    </div>
                </a>
            </div>

            <% } %>
        </div>
    </div>

    <!-- paginación Boardgames-->
    <nav aria-label="Page navigation example" id="pagination-boardgames">
        <ul class="pagination justify-content-center">

            <li class="page-item
                <% if (actualRowBoardgames <= 0) { %> disabled <% } %>">
                <a class="page-link pag-boardgames" href="index.jsp?actualRowBoardgames=<%=actualRowBoardgames-1%>">Anterior</a>
            </li>

            <%
                int totalPages = (int)Math.ceil((double)sizeBoardgames/3);
                for ( int i = 0 ; i < totalPages; i++){
            %>
            <li class="page-item <% if (actualRowBoardgames == i) { %> active <% } %>">
                <a class="page-link pag-boardgames" href="index.jsp?actualRowBoardgames=<%=i%>"><%=i+1%></a>
            </li>
            <% }; %>

            <li class="page-item
                <% if ((actualRowBoardgames + 1) >= totalPages) { %> disabled <% } %>">
                <a class="page-link pag-boardgames" href="index.jsp?actualRowBoardgames=<%=actualRowBoardgames%>">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>

