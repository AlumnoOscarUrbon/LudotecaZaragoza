
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
                    // Animamos la opacidad
                    $('#custom-cards-boardgames').animate({ opacity: 1}, 400);
                }
            });
        });
    }
</script>

<div id="boardgames-content">
    <div class="container px-4 py-5" id="custom-cards-boardgames">
        <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-5" id="card-container">
            <%

                int sizeBoardgames = Database.jdbi.withExtension(BoardgameDao.class, dao -> dao.getAllBoardgames()).size();

                //determinar en la página en la que estamos
                int actualRowBoardgames;
                if (request.getParameter("actualRowBoardgames")==null){
                    actualRowBoardgames = 1;
                } else {
                    actualRowBoardgames = Integer.parseInt (request.getParameter("actualRowBoardgames"));
                }
                int firstOfRowBoardgame = (actualRowBoardgames * 3) - 3;

                List<Boardgame> boardgames = null;
                boardgames = Database.jdbi.withExtension(BoardgameDao.class, dao -> dao.getPaginatedBoardgames(firstOfRowBoardgame,3));
                for (Boardgame boardgame : boardgames){
            %>
            <div class="col">
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
            </div>
            <% } %>
        </div>
    </div>

    <!-- paginación Boardgames-->
    <nav aria-label="Page navigation example" id="pagination-boardgames">
        <ul class="pagination justify-content-center">

            <li class="page-item
                <% if (actualRowBoardgames <= 1) { %> disabled <%}%>">
                <a class="page-link pag-boardgames" href="index.jsp?actualRowBoardgames=<%=actualRowBoardgames-1%>">Anterior</a>
            </li>

            <% for ( int i = 1 ; i <= (int)Math.ceil((double)sizeBoardgames/3); i++){ %>
            <li class="page-item <% if (actualRowBoardgames == i) { %> active <%}%>">
                <a class="page-link pag-boardgames" href="index.jsp?actualRowBoardgames=<%=i%>"><%=i%></a>
            </li>
            <% }; %>

            <li class="page-item
                <% if (actualRowBoardgames >= (int)Math.ceil((double)sizeBoardgames/3)) { %> disabled <%}%>">
                <a class="page-link pag-boardgames" href="index.jsp?actualRowBoardgames=<%=actualRowBoardgames+1%>">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>