<%@ page import="java.util.List" %>
<%@ page import="static com.svalero.util.Constants.HOWMANYCARDS" %>
<%@ page import="com.svalero.domain.Activity" %>
<%@ page import="com.svalero.dao.SignUpDao" %>
<%@ page import="com.svalero.dao.ActivityDao" %>
<%@ page import="com.svalero.domain.SignUp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<link href="css/custom.css" rel="stylesheet">

<!--Refrescargar cartas y paginacion -->
<script type="text/javascript">
    $(document).on('click', 'a.pag-activities', function(e) {
        e.preventDefault();
        const url = $(this).attr('href');
        const $currentCardsContent = $('#custom-cards-activities');
        const $currentPagContent = $('#pagination-activities');
        $currentCardsContent.animate({ opacity: 0 }, 400, function() {
            $.ajax({
                url: url,
                success: function(response) {
                    const newCardsContent = $('<div>').append($.parseHTML(response)).find('#custom-cards-activities').html();
                    const newPagContent = $('<div>').append($.parseHTML(response)).find('#pagination-activities').html();
                    $currentCardsContent.html(newCardsContent);
                    $currentPagContent.html(newPagContent);
                    $('#custom-cards-activities').animate({opacity: 1}, 300);
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
        <h2 class="border-bottom mt-4 mb-2 pb-2">Actividades</h2>
    </div>
    <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-4" id="custom-cards-activities">

    <%
        //Seleccion de resultados
        List<Activity> activities;
        if (!search.isBlank()) {
            String finalSearch = search;
            activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getFilteredActivities(finalSearch));
        } else {
            activities = Database.jdbi.withExtension(ActivityDao.class, ActivityDao::getAllActivities);
        }

        //Determinar pagina actual
        int currentRowActivities;
        if (request.getParameter("currentRowActivities")==null){
            currentRowActivities = 0;
        } else {
            currentRowActivities = Integer.parseInt (request.getParameter("currentRowActivities"));
        }

        //Cartas en pagina actual
        int totalSizeActivities = activities.size();
        int firstOfRowActivities = currentRowActivities * HOWMANYCARDS;
        int extraActivities = totalSizeActivities % HOWMANYCARDS;

        int lastOfRowActivities;
        if ((firstOfRowActivities + HOWMANYCARDS) > totalSizeActivities) {
            lastOfRowActivities = firstOfRowActivities + extraActivities;
        } else {
            lastOfRowActivities = firstOfRowActivities + HOWMANYCARDS;
        }
        //Iterar
        List <Activity> packagedActivities = activities.subList(firstOfRowActivities, lastOfRowActivities);
        if (packagedActivities.isEmpty()) {
    %>
        <div class="container my-2 text-center"><p>Sin resultados.</p></div>
    <%
        } else {
            for (Activity currentActivity : packagedActivities){
    %>
        <div class="col">
            <a href="view-activity.jsp?currentActivityId=<%= currentActivity.getActivityId() %>&catIdFilter=noFilterSelected" class="text-decoration-none">
                <div class="card card-cover overflow-hidden  rounded-4 shadow-lg center&cover-bg position-relative fine-border"  style="background-image: url('pictures/<%= currentActivity.getPicture() %>');">
                    <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
                        <h3 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold text-bordered"><%= currentActivity.getName()%></h3>
                        <%
                            SignUp signUp = Database.jdbi.withExtension(SignUpDao.class, dao -> dao.getSignUpsFromUserAndActivity(sessionUserId, currentActivity.getActivityId()));
                            if (signUp != null){
                        %>
                        <img src="icons/sign-up-check.png" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right">
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

    <!-- paginación de actividades-->
    <nav aria-label="Page navigation example" class="mt-4" id="pagination-activities">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= currentRowActivities <= 0 ? "disabled" : "" %>">
                <a class="page-link pag-activities" href="index.jsp?currentRowActivities=<%=currentRowActivities - 1%>&search=<%= search %>">Anterior</a>
            </li>
            <%
                int totalActivityPages = (int)Math.ceil((double) totalSizeActivities /HOWMANYCARDS);
                for (int i = 0; i < totalActivityPages; i++){
            %>
            <li class="page-item <%= currentRowActivities == i ? "active" : "" %>">
                <a class="page-link pag-activities" href="index.jsp?currentRowActivities=<%=i%>&search=<%= search %>"><%= i + 1 %></a>
            </li>
            <%
                }
            %>
            <li class="page-item <%= (currentRowActivities + 1) >= totalActivityPages ? "disabled" : "" %>">
                <a class="page-link pag-activities" href="index.jsp?currentRowActivities=<%=currentRowActivities + 1 %>&search=<%= search %>">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>

