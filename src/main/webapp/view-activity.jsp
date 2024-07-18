<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.svalero.dao.*" %>
<%@ page import="com.svalero.domain.*" %>
<%@ page import="static com.svalero.util.Utils.formatDateTimeToDate" %>
<%@ page import="static com.svalero.util.Utils.*" %>
<%@ page import="java.time.Duration" %>
<%@ page import="java.time.LocalDateTime" %>

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
                <div class="row align-items-center justify-content-center">
                    <form class="col">
                        <select class="form-select border border-dark-gray" id="floatingSelect" aria-label="Floating label select">
                            <option disabled <%= catIdFilterParam.equals("noFilterSelected") ? "selected" : "" %>>Selecciona una categoría</option>
                            <option value="" <%= catIdFilterParam.isEmpty() ? "selected" : "" %>>Todas las actividades</option>
                            <%
                                List<ActivityCategory> activityCategories = Database.jdbi.withExtension(ActivityCategoryDao.class, ActivityCategoryDao::getAllActivityCategories);
                                for (ActivityCategory currentActivityCategory : activityCategories) {
                            %>
                            <option value="<%= currentActivityCategory.getActivityCategoryId() %>"
                                    <%= catIdFilterParam.equals(currentActivityCategory.getActivityCategoryId()) ? "selected" : "" %>>
                                Solo <%= currentActivityCategory.getName() %>
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
                    <div class="col-12 col-md-3">
                        <a href="edit-activity.jsp" class="text-decoration-none">
                            <button type="button" class="btn btn-success w-100">AÑADIR ACTIVIDAD</button>
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

                String activityId = request.getParameter("currentActivityId");
                if (activityId == null) {
                    activityId = "";
                };

                List<Activity> activities;

                //Seleccion de sentencia SQL
                if (!search.isBlank()) {
                    String finalSearch = search;
                    activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getFilteredActivities(finalSearch));
                } else if (!activityId.isEmpty()) {
                    String finalActivityId = activityId;
                    activities = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getActivityById(finalActivityId));
                } else {
                    activities = Database.jdbi.withExtension(ActivityDao.class, ActivityDao::getAllActivities);
                }

                //Filtrado por categoria
                List<Activity> finalActivityList = new ArrayList<>();
                if (!catIdFilterParam.isEmpty() && !catIdFilterParam.equals("noFilterSelected")) {
                    for (Activity currentActivity : activities) {
                        if (currentActivity.getActivityCategoryId().equals(catIdFilterParam)) {
                            finalActivityList.add(currentActivity);
                        }
                    }
                } else {
                    finalActivityList = activities;
                }
                //Iterar
                if (finalActivityList.isEmpty()) {
            %>
            <div class="container my-4 text-center "><p>Sin resultados.</p></div>
            <%
                } else {
                    for (Activity currentActivity : finalActivityList) {
            %>
            <div class="container w-100 mb-4" id="card<%= currentActivity.getActivityId() %>">
                <div class="d-flex flex-lg-row flex-column p-4 align-items-center rounded-3 border shadow-lg white95">
                    <div class="p-3 p-lg-4 d-flex flex-column flex1">
                        <h1 class="display-5 fw-bold lh-0 text-body-emphasis m-0 p-0" id="titulo"><%= currentActivity.getName() %></h1>
                        <p class="lead m-3 lineasmax4"><%= currentActivity.getDescription() %></p>
                        <hr>
                        <%
                           String activityDate = formatDateTimeToDate(currentActivity.getActivityDateTime());
                           String activityTime = formatLocalTimeNoSec(currentActivity.getActivityDateTime());
                           Duration duration = Duration.between(LocalDateTime.now(), currentActivity.getActivityDateTime());
                           if (duration.isPositive()){
                        %>
                        <p class="lead my-2 mx-3">Esta actividad de <b><%= currentActivity.getActivityCategory().getName() %></b> comenzará el <b><%= activityDate %></b> a las <b><%= activityTime %></b></p>
                        <%
                            } else {
                        %>
                        <p class="lead my-2 mx-3">Esta actividad ya ha <b>terminado</b>.</p>
                        <%
                            }
                        %>
                        <hr>
                        <div class="d-grid gap-2 d-md-flex justify-content-md-start mt-auto" >
                            <%
                                if (sessionUserRole.equals("admin")) {
                            %>
                            <a href="edit-activity.jsp?currentActivityId=<%= currentActivity.getActivityId() %>">
                                <button type="button" class="btn btn-primary btn-lg px-4 w-100 w-md-auto fw-bold">Editar</button>
                            </a>
                            <button type="button" class="btn btn-danger btn-lg px-4 w-100 w-md-auto fw-bold" data-bs-toggle="modal" data-bs-target="#Delete-Modal-<%=currentActivity.getActivityId()%>">Eliminar</button>
                            <%
                                }
                            %>
                            <button type="button" data-current-activity-id="<%= currentActivity.getActivityId() %>" data-session-user-id="<%= sessionUserId %>"
                                    class="btn button-sign-up btn-lg px-4 w-100 w-md-auto
                                    <%  SignUp signUp = Database.jdbi.withExtension(SignUpDao.class, dao -> dao.getSignUpsFromUserAndActivity(sessionUserId, currentActivity.getActivityId())); %>
                                    <%= signUp != null ? "btn-active-green" : "btn-inactive" %>"
                                    <%= sessionUserId.equals("noId") ? "disabled >Favorito (Solo usuarios registrados)" : ">Inscrito" %>
                            </button>
                        </div>
                    </div>
                    <div class="d-flex py-0 px-3 m-0 align-items-center overflow-hidden flex1 w-100 h-100">
                        <div class="position-relative w-100 h-100">
                            <img class="rounded rounded-4 object-fit-cover h350 w-100 fine-border" src="pictures/<%= currentActivity.getPicture() %>" alt="imagen de actividad">
                            <img src="icons/sign-up-check.png" id="sign-up-icon-<%= currentActivity.getActivityId() %>" class="size-star-icon position-absolute corner-bottom-right" <%= signUp == null ? "style='display:none;'" : "" %> alt="Icono favorito">
                        </div>
                    </div>
                </div>
                <!-- Modal confirmacion borrado -->
                <div class="modal fade" id="Delete-Modal-<%= currentActivity.getActivityId() %>" tabindex="-1" aria-labelledby="DeleteModalLabel-<%= currentActivity.getActivityId() %>" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-top-third">
                        <div class="modal-content p-3 white95 center&cover-bg" style="background-image: url('icons/stripes.jpg');">
                            <div class="modal-header d-flex justify-content-between">
                                <h2 class="fs-4 mb-0" id="SignInModalLabel">Eliminar permanentemente</h2>
                                <button type="button" class="btn-close bclose-corner" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body mx-3 d-flex flex-column justify-content-center align-items-center">
                                <h2 class="border-bottom mb-4"><b><%= currentActivity.getName() %></b></h2>
                                <button class="btn btn-delete btn-danger w-50 text-center p-3" type="submit" data-current-activity-id="<%= currentActivity.getActivityId() %>"
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
                $(".btn-delete").on("click", function(event) {
                    event.preventDefault();
                    var currentActivityId = $(this).data('current-activity-id');
                    var card = $("#card" + currentActivityId);

                    $.ajax({
                        type: "POST",
                        url: "delete-activity",
                        data: {activityId : currentActivityId},
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
                $(".button-sign-up").on("click", function() {
                    var buttonSignUp= $(this);
                    var currentActivityId = buttonSignUp.data('current-activity-id');
                    var sessionUserId = buttonSignUp.data('session-user-id');
                    var signUpIcon = $("#sign-up-icon-" + currentActivityId);

                    if (buttonSignUp.hasClass('btn-active-green')) {
                        $.ajax({
                            type: "POST",
                            url: "delete-sign-up",
                            data: { activityId: currentActivityId, sessionUserId: sessionUserId },
                            success: function() {
                                console.log('Se ha eliminado de apuntados correctamente');
                                buttonSignUp.removeClass('btn-active-green').addClass('btn-inactive');
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
                            data: { activityId: currentActivityId, sessionUserId: sessionUserId },
                            success: function() {
                                console.log('Se ha añadido a apuntados correctamente');
                                buttonSignUp.removeClass('btn-inactive').addClass('btn-active-green');
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
