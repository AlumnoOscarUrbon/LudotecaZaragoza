<%@ page import="com.svalero.domain.Game" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.domain.GameCategory" %>
<%@ page import="com.svalero.domain.Activity" %>
<%@ page import="com.svalero.domain.ActivityCategory" %>
<%@ page import="com.svalero.dao.*" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <main>
            <%
                String activityId;
                Activity activity = null;

                if (request.getParameter("actualActivityId") == null || request.getParameter("actualActivityId").isEmpty()){
                    activityId ="noId";
                } else {
                    activityId = request.getParameter("actualActivityId");
                    List<Activity> activityList = Database.jdbi.withExtension(ActivityDao.class, dao -> dao.getActivityById(activityId));
                    activity = activityList.get(0);
                }
            %>
            <section class="py-5 container">
                <div class="row p-4 align-items-center rounded-3 border shadow-lg justify-content-between bg-white">

                    <h2 class = "mb-0">
                        <% if (activityId.equals("noId")){ %>
                            Registrar una actividad nueva
                        <% } else { %>
                            Actualizar <%= activity.getName()%>
                        <% } %>
                    </h2>

                    <form class="row g-3 needs-validation"  enctype="multipart/form-data" id="edit-form" action="edit-activity" >
                        <div class="mb-3">
                            <label for="name" class="form-label">Nombre</label>
                            <input type="text" name="activityName" class="form-control" id="name" placeholder="Tenis de mesa"
                                <% if (!activityId.equals("noId")){%> value= "<%= activity.getName()%>" <% } %>>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Descripcion</label>
                            <textarea rows="4" cols="50" name="activityDescription" class="form-control" id="description" placeholder="Preparate para unas espectaculares partidas de este milenario deporte asiatico... "
                            ><% if (!activityId.equals("noId")){ %><%= activity.getDescription() %><% } %></textarea>
                        </div>

                        <div class="col-md-4">
                            <label for="date" class="form-label">Fecha de celebración</label>
                            <input type="date" name = "activityRelease" class="form-control" id="date" placeholder="dd/mm/yyyy"
                                <% if (!activityId.equals("noId")){%> value="<%= activity.getActivityDateTime() %>"<% } %> >
                        </div>

                        <div class="col-md-4">
                            <label for="category" class="form-label">Categoria</label>
                            <select class="form-select" name ="activityCategoryId" id="category" >
                                    <option disabled <% if (activityId.equals("noId")){ %> selected <% } %> >Selecciona</option>
                                    <%
                                        List <ActivityCategory> categories = Database.jdbi.withExtension(ActivityCategoryDao.class, dao -> dao.getAllActivityCategories());
                                        for (ActivityCategory category : categories) {
                                    %>
                                            <option value="<%= category.getActivityCategoryId()%>"
                                            <%
                                                if (!activityId.equals("noId")) {
                                                    if (activity.getActivityCategoryId().equals(category.getActivityCategoryId())) {
                                            %>
                                                        selected
                                            <%
                                                    };
                                                };
                                            %>
                                                ><%= category.getName() %>
                                            </option>
                                    <% } %>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label for="picture" class="form-label">Imagen</label>
                            <input type="file" name="activityPicture" class="form-control" id="picture">
                        </div>
                        <input type="hidden" name="activityId" value="<%=activityId%>"/>
                        <div class="col-12 d-flex justify-content-end mb-3 mt-4">
                            <button class="btn btn-primary w-25 py-3 " type="submit" id="edit-button">
                                <% if (activityId.equals("noId")){ %> REGISTRAR <% } else { %> ACTUALIZAR <% } %>
                            </button>
                        </div>
                    </form>
                    <br>
                    <div id="result-reg" ></div>
                </div>
            </section>
        </main>
        <%@include file="includes/footer.jsp"%>

        <!-- PROCESAR FORMULARIO -->
        <script type="text/javascript">
            $(document).ready(function () {
                $("#edit-button").click(function (event) {
                    event.preventDefault();
                    const form = $("#edit-form")[0];
                    const data = new FormData(form);
                    $("#edit-button").prop("disabled", true);

                    $.ajax({
                        type: "POST",
                        enctype: "multipart/form-data",
                        url: "edit-activity",
                        data: data,
                        processData: false,
                        contentType: false,
                        cache: false,
                        timeout: 600000,
                        success: function (response) {
                            $("#result-reg").html(response).show();
                            setTimeout(function () {
                                var activityName = $("#edit-form").find('input[name="activityName"]').val();
                                // Redirigir a view-game.jsp después de 2 segundos en caso de éxito
                                window.location.href = 'view-activity.jsp?catIdFilter=noFilterSelected&search=' + encodeURIComponent(activityName);
                            }, 2500);
                        },
                        error: function (xhr) {
                            $("#result-reg").html(xhr.responseText).show();
                            $("#edit-button").prop("disabled", false);
                            setTimeout(function () {
                                $("#result-reg").slideUp();
                            }, 2000);
                        }
                    });
                });
            });
        </script>
    </body>
</html>