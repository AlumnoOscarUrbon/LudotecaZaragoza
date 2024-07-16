<%@ page import="com.svalero.util.Utils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.svalero.dao.*" %>
<%@ page import="com.svalero.domain.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="static com.svalero.util.Utils.formatDate" %>
<%@ page import="static com.svalero.util.Utils.formatDateTimeToDate" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="static com.svalero.util.Utils.*" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <main>
            <%
                String catIdFilterParam = request.getParameter("catIdFilter");
                if (catIdFilterParam == null) {catIdFilterParam = "";};
            %>
            <div class="container my-4">
                <div class="row align-items-center justify-content-center ">
                    <form class="col ">
                        <select class="form-select border border-dark-gray" id="floatingSelect" aria-label="Floating label select">
                            <option disabled <% if (catIdFilterParam.equals("noFilterSelected")) {%>selected <% } %>>Selecciona una categoría</option>
                            <option value="" <% if (catIdFilterParam.isEmpty()) { %> selected <% } %>>Todas las actividades</option>
                            <%
                                List<ActivityCategory> activityCategories = Database.jdbi.withExtension(ActivityCategoryDao.class, dao -> dao.getAllActivityCategories());
                                for (ActivityCategory activityCategory : activityCategories) {
                            %>
                            <option class="" value="<%=activityCategory.getActivityCategoryId()%>"
                                    <% if (catIdFilterParam.equals(activityCategory.getActivityCategoryId())) { %> selected <% } %>
                            > Solo <%= activityCategory.getName() %>
                            </option>
                            <% } %>
                        </select>
                    </form>

                    <div class="col-3 mb-2 mb-md-0">
                        <button id="resetSearch" type="button" class="btn btn-warning w-100">Eliminar búsqueda en curso</button>
                    </div>

                    <% if (actualUserRole.equals("admin")) { %>
                    <div class="col-12 col-md-3 ">
                        <a href="edit-activity.jsp" class="text-decoration-none">
                            <button type="button" class="btn btn-success w-100">AÑADIR ACTIVIDAD</button>
                        </a>
                    </div>
                    <% } %>

                </div>
            </div>


            <%
                String search = request.getParameter("search");
                if (search == null) {search = "";};
                String activityId = request.getParameter("actualActivityId");
                if (activityId == null) {activityId = "";};
                List<Activity> activities;

            //FILTRADO BUSQUEDA
                if (!search.isEmpty()) {
                    String finalSearch = search;
                    activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getFilteredActivities(finalSearch));
                } else if (!activityId.isEmpty()) {
                    String finalActivityId = activityId;
                    activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getActivityById(finalActivityId));
                } else {
                    activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getAllActivities());
                }

            //FILTRADO POR CATEGORIA
                List<Activity> finalActivityList = new ArrayList<>();

                if (!catIdFilterParam.isEmpty() && !catIdFilterParam.equals("noFilterSelected")) {
                    for (Activity activity : activities) {
                        if (activity.getActivityCategoryId().equals(catIdFilterParam)) {
                            finalActivityList.add(activity);
                        }
                    }
                } else {
                    finalActivityList = activities;
                }

                if (finalActivityList.isEmpty()) {
            %>
            <div class="container my-4 text-center "> Sin resultados. </div>
            <%
            } else {
                for (Activity activity : finalActivityList) {
            %>
            <div class=" container  w-100 mb-4 " id="tarjeta<%= activity.getActivityId() %>">
                <div class="d-flex flex-lg-row flex-column p-4 align-items-center rounded-3 border shadow-lg white95">
                    <div class="p-3 p-lg-4 d-flex flex-column flex1">
                        <h1 class="display-5 fw-bold lh-0 text-body-emphasis m-0 p-0" id="titulo"><%= activity.getName() %></h1>
                        <p class="lead m-3 lineasmax4"><%= activity.getDescription() %></p>
                        <hr>
                        <%
                           String activityDate = formatDateTimeToDate(activity.getActivityDateTime());
                           String activityTime = formatLocalTimeNoSec(activity.getActivityDateTime());
                        %>
                        <p class="lead my-2 mx-3">Esta actividad de <b><%= activity.getActivityCategory().getName() %></b> comenzará el <b><%= activityDate %></b> a las <b><%=activityTime%></b> </p>
                        <hr>
                        <div class="d-grid gap-2 d-md-flex justify-content-md-start mt-auto" >
                            <% if (actualUserRole.equals("admin")) { %>
                            <a href="edit-activity.jsp?actualActivityId=<%= activity.getActivityId() %>">
                                <button type="button" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Editar</button>
                            </a>
                            <form class="formDelete" action="delete-activity" method="post">
                                <input type="hidden" name="actualActivityId" value="<%= activity.getActivityId() %>">
                                <button type="submit" class="btn btn-danger btn-lg px-4 w-100 w-md-auto fw-bold">Eliminar</button>
                            </form>
                            <% } %>
                            <button type="button" data-activityid="<%= activity.getActivityId() %>" data-actualuserid="<%= actualUserId %>"
                                    class="btn button-sign-up btn-lg px-4 w-100 w-md-auto
                                    <%
                                        SignUp signUp = Database.jdbi.withExtension(SignUpDao.class, dao -> dao.getSignUpsFromUserAndActivity(actualUserId, activity.getActivityId()));
                                        if (signUp != null){ %> boton-activo-verde <% } else { %> boton-desactivado <% } %> "
                                    <% if (actualUserId.equals("noId")){ %> disabled > Inscribirse (Solo usuarios registrados)<% } else { %>> Inscrito <% } %>
                            </button>
                        </div>
                    </div>
                    <div class="d-flex py-0 px-3 m-0 align-items-center overflow-hidden flex1 w-100 h-100">
                        <div class="position-relative w-100 h-100">
                            <img class="rounded rounded-4 object-fit-cover h350 w-100 fine-border" src="pictures/<%= activity.getPicture() %>" alt="">
                            <img src="icons/sign-up-check.png" id="sign-up-icon-<%= activity.getActivityId() %>" alt="Icono favorito" class="size-star-icon position-absolute corner-bottom-right" <% if (signUp == null){ %> style="display:none;" <% } %>>
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
                    var newUrl = actualUrl + '?catIdFilter=' + selectedCatValue + '&search=' + encodeURIComponent(searchValue);
                    window.location.href = newUrl;
                });
            });
        </script>

        <!-- Botón Reset de busqueda y filtros-->
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
                    var activityId = form.find('input[name="actualActivityId"]').val();
                    var card = $("#tarjeta" + activityId);

                    $.ajax({
                        type: "POST",
                        url: "delete-activity",
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

        <!-- Boton favorito y aparicion de estrella -->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".button-sign-up").on("click", function(event) {
                    var buttonSignUp= $(this);
                    var activityId = buttonSignUp.data('activityid');
                    var actualUserId = buttonSignUp.data('actualuserid');
                    var signUpIcon = $("#sign-up-icon-" + activityId);

                    if (buttonSignUp.hasClass('boton-activo-verde')) {
                        $.ajax({
                            type: "POST",
                            url: "delete-sign-up",
                            data: { activityId: activityId, actualUserId: actualUserId },
                            success: function(response) {
                                console.log('Se ha eliminado de apuntados correctamente');
                                buttonSignUp.removeClass('boton-activo-verde').addClass('boton-desactivado');
                                signUpIcon.fadeOut();
                            },
                            error: function() {
                                console.error('Error al eliminar de apuntados.');
                            }
                        });
                    } else {
                        $.ajax({
                            type: "POST",
                            url: "add-sign-up",
                            data: { activityId: activityId, actualUserId: actualUserId },
                            success: function(response) {
                                console.log('Se ha añadido a apuntados correctamente');
                                buttonSignUp.removeClass('boton-desactivado').addClass('boton-activo-verde');
                                signUpIcon.fadeIn();
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
