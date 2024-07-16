<%@ page import="java.util.List" %>
<%@ page import="static com.svalero.util.Constants.HOWMANYCARDS" %>
<%@ page import="com.svalero.domain.Activity" %>
<%@ page import="com.svalero.domain.*" %>
<%@ page import="com.svalero.dao.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<link href="css/custom.css" rel="stylesheet">

<script type="text/javascript">
    // Botones paginación
    $(document).on('click', 'a.pag-activities', function(e) {
        e.preventDefault();
        const url = $(this).attr('href');  // Obtiene la URL del atributo href
        loadActivities(url);
    });
    // Refrescar solo tarjetas y paginacion
    function loadActivities(url) {
        const $actualCardsContent = $('#custom-cards-activities');
        const $actualPagContent = $('#pagination-activities');

        $actualCardsContent.animate({ opacity: 0 }, 400, function() {
            $.ajax({
                url: url,
                success: function(response) {
                    const newCardsContent = $('<div>').append($.parseHTML(response)).find('#custom-cards-activities').html();
                    const newPagContent = $('<div>').append($.parseHTML(response)).find('#pagination-activities').html();
                    $actualCardsContent.html(newCardsContent);
                    $actualPagContent.html(newPagContent);

                    $('#custom-cards-activities').animate({ opacity: 1}, 300);
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
        <h2 class="border-bottom mt-4 mb-2 pb-2">Actividades</h2>
    </div>
    <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-4 " id="custom-cards-activities">

<%
//comprobar si hay busqueda activa
            List<Activity> activities;
            if (search.isEmpty()) {
                activities = Database.jdbi.withExtension(ActivityDao.class, ActivityDao::getAllActivities);
            } else {
                String finalSearch = search;
                activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getFilteredActivities(finalSearch));
            }

//calcular total de resultados
            int sizeActivities;
            if (activities.isEmpty()){
                sizeActivities = 0;
            } else {
                sizeActivities = activities.size();
            };

//determinar en que pagina estamos
            int actualRowActivities;
            if (request.getParameter("actualRowActivities")==null){
                actualRowActivities = 0;
            } else {
                actualRowActivities = Integer.parseInt (request.getParameter("actualRowActivities"));
            }

//determinar cartas de pagina actual
            int firstOfRowActivities = (actualRowActivities * HOWMANYCARDS);
            int lastOfRowActivities;
            int extraActivities = sizeActivities % HOWMANYCARDS;
            if ((firstOfRowActivities + HOWMANYCARDS) > sizeActivities) {
                lastOfRowActivities = firstOfRowActivities + extraActivities;
            } else {
                lastOfRowActivities = firstOfRowActivities + HOWMANYCARDS;
            }

            List <Activity> packagedActivities = activities.subList(firstOfRowActivities, lastOfRowActivities);

            if (packagedActivities.isEmpty()) {
%>
                <div class="container my-2 text-center"> <p>Sin resultados.</p> </div>
<%
            } else {
                for (Activity activity : packagedActivities){
%>
                    <div class="col">
                        <a href="view-activity.jsp?actualActivityId=<%= activity.getActivityId() %>&catIdFilter=noFilterSelected" class="text-decoration-none">
                            <div class="card card-cover overflow-hidden  rounded-4 shadow-lg center&cover-bg position-relative fine-border"  style="background-image: url('pictures/<%= activity.getPicture() %>');">
                                <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
                                    <h3 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold text-bordered"><%= activity.getName()%></h3>
<%
                                            SignUp signUp = Database.jdbi.withExtension(SignUpDao.class, dao -> dao.getSignUpsFromUserAndActivity(actualUserId, activity.getActivityId()));
                                            if (signUp != null){
%>
                                        <img src="icons/sign-up-check.png" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right">
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
    <nav aria-label="Page navigation example" class="mt-4" id="pagination-activities">
        <ul class="pagination justify-content-center">

            <li class="page-item
                <% if (actualRowActivities <= 0) { %> disabled <% } %>">
                <a class="page-link pag-activities" href="index.jsp?actualRowActivities=<%=actualRowActivities-1%>&search=<%=search%>">Anterior</a>
            </li>

<%
                int totalFavoritePages = (int)Math.ceil((double) sizeActivities /HOWMANYCARDS);
                for (int i = 0; i < totalFavoritePages; i++){
%>
            <li class="page-item <% if (actualRowActivities == i) { %> active <% } %>">
                <a class="page-link pag-activities" href="index.jsp?actualRowActivities=<%=i%>&search=<%=search%>"><%=i+1%></a>
            </li>
            <% }; %>

            <li class="page-item
                <% if ((actualRowActivities + 1) >= totalFavoritePages) { %> disabled <% } %>">
                <a class="page-link pag-activities" href="index.jsp?actualRowActivities=<%=actualRowActivities+1%>&search=<%=search%>">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>

