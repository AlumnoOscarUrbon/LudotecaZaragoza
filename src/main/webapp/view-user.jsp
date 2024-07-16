<%@ page import="com.svalero.domain.User" %>
<%@ page import="com.svalero.dao.UserDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <main>
            <div class="container my-3">
            <%
                List<User> actualUserList = new ArrayList<>();
                boolean isFirstTime = true;

                String search = request.getParameter("search");
                if (search == null || search.isBlank()) {
                    search = "%";
                };

                if (actualUserRole.equals("admin")) {
                    %> <div class="container"><h2 class="border-bottom my-4 pb-2 ">Administrar Usuarios</h2></div> <%
                    final String searchTerm = search;
                    actualUserList = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUsersSearch(searchTerm, actualUserId));

                } else if (actualUserRole.equals("user")) {
                    %> <div class="container"><h2 class="border-bottom my-4 pb-2 ">Mis Datos</h2></div> <%
                    actualUserList = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUserById(actualUserId));

                } else {
                    %> <div class="container"><h2 class="border-bottom my-4 pb-2 ">Registrar Usuario</h2></div> <%
                    actualUserList.add(new User());
                    actualUserList.get(0).setUserId("noId");
                    actualUserList.get(0).setRole("noRole");
                }
                if (actualUserList.size() == 0) { %>
                    <div class="container my-4 text-center "> Sin resultados. </div> <%
                } else { %>
                <div class="accordion shadow-lg rounded-4" id="accordionUsers">

                    <% for (User actualUser : actualUserList) { %>

                    <div class="accordion-item white95" id="accordion-item-<%=actualUser.getUserId()%>">
                        <h2 class="accordion-header">
                            <button class="accordion-button <%if (!isFirstTime){ %> collapsed <%}%>"
                                type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=actualUser.getUserId()%>"
                                aria-expanded=<% if (isFirstTime){ %>"true"<% } else { %>"false"<% } %> aria-controls="collapse<%=actualUser.getUserId()%>">
                                <% if (!actualUser.getUserId().equals("noId")) { %> <b><%= actualUser.getUsername() %></b>
                                <% } else { %> Alta de&nbsp;<b>nuevo usuario</b> <% } %>
                            </button>
                        </h2>
                        <div id="collapse<%=actualUser.getUserId()%>" class="accordion-collapse collapse <%if (isFirstTime){ %> show <%}%>" data-bs-parent="#accordionUsers">
                            <div class="accordion-body">
                                <form class="row g-3"  id="edit-form-<%=actualUser.getUserId()%>" action="edit-user" method="post" >
                                    <div class="col-md-4">
                                        <label for="username<%=actualUser.getUserId()%>" class="form-label">Nombre</label>
                                        <input type="text" name="username" class="form-control" id="username<%=actualUser.getUserId()%>" placeholder="Tu nombre"
                                               value="<% if (!actualUser.getUserId().equals("noId")){ %><%= actualUser.getUsername() %><% } %>" >
                                    </div>
                                    <div class="col-md-4">
                                        <label for="email<%=actualUser.getUserId()%>" class="form-label">Email</label>
                                        <input type="email" name="email" class="form-control" id="email<%=actualUser.getUserId()%>" placeholder="Tu email"
                                               value="<% if (!actualUser.getUserId().equals("noId")){ %><%= actualUser.getEmail() %><% } %>" >
                                    </div>
                                    <div class="col-md-4">
                                        <label for="birthDate<%=actualUser.getUserId()%>" class="form-label">Fecha de nacimiento</label>
                                        <input type="date" name = "birthDate" class="form-control" id="birthDate<%=actualUser.getUserId()%>" placeholder="dd/mm/yyyy"
                                               value="<% if (!actualUser.getUserId().equals("noId")){ %><%= actualUser.getBirthDate() %><% } %>" >
                                    </div>
                                    <div class="col-md-4">
                                        <label for="password<%=actualUser.getUserId()%>" class="form-label">Contraseña</label>
                                        <input type="text" name="password" class="form-control" id="password<%=actualUser.getUserId()%>"
                                               placeholder="<% if (!actualUser.getUserId().equals("noId")){ %> Deja en blanco si no quieres cambiarla <% } else { %> Tu contraseña <% } %> " value="" >
                                    </div>
                                    <div class="col-md-4">
                                        <label for="userRole<%=actualUser.getUserId()%>" class="form-label">Rol</label>
                                        <select class="form-select" name ="role" id="userRole<%=actualUser.getUserId()%>">
                                            <option disabled  <% if (actualUser.getRole().equals("noRole")) { %> selected <% } %> >Selecciona</option>
                                            <option value="user" <% if (actualUser.getRole().equals("user")) { %> selected <% } %> > Usuario </option>
                                            <option value="admin" <%  if (actualUser.getRole().equals("admin")) { %> selected <% } %> > Administrador </option>
                                        </select>
                                    </div>
                                    <input type="hidden" name="userId" value="<%=actualUser.getUserId()%>">
                                    <div class="col-md-4 d-flex  justify-content-between align-items-end gap-3 ">
                                        <button class="btn submit btn-primary w-100 "  type="submit" data-user-id="<%=actualUser.getUserId()%>" id="edit-button-<%=actualUser.getUserId()%>">
                                            <% if (actualUser.getUserId().equals("noId")){ %> REGISTRAR <% } else { %> ACTUALIZAR <% } %>
                                        </button>
                                        <button class="btn btn-danger w-100 " data-bs-toggle="modal" data-bs-target="#Delete-Modal-<%=actualUser.getUserId()%>" type="button" id="delete-button-<%=actualUser.getUserId()%>"
                                                <% if (actualUser.getUserId().equals("noId")){ %> style="display:none;"<% } %>> BORRAR
                                        </button>
                                    </div>
                                </form>
                            </div>
                            <div id="result-user-<%=actualUser.getUserId()%>" class="user-message"></div>
                        </div>

                        <!-- MODAL CONFIRMACION BORRADO -->
                        <div class="modal fade" id="Delete-Modal-<%=actualUser.getUserId()%>" tabindex="-1" aria-labelledby="DeleteModalLabel-<%=actualUser.getUserId()%>" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-top-third ">
                                <div class="modal-content p-3 white95 center&cover-bg" style = "background-image: url('icons/stripes.jpg');" >
                                    <div class="modal-header d-flex justify-content-between ">
                                        <h2 class=" fs-4 mb-0" id="SignInModalLabel">Eliminar permanentemente</h2>
                                        <button type="button" class="btn-close bclose-corner " data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body mx-3 d-flex flex-column justify-content-center align-items-center">
                                        <h2 class="border-bottom mb-4"><b><%=actualUser.getUsername()%></b></h2>

                                            <button class="btn delete btn-danger w-50 text-center p-3" type="submit" data-user-id="<%=actualUser.getUserId()%>" data-current-user-id="<%=actualUserId%>" id="confirm-delete-button-<%=actualUser.getUserId()%>" data-bs-dismiss="modal"
                                                    <% if (actualUser.getUserId().equals("noId")) { %> style="display:none;" <% } %>>CONFIRMAR
                                            </button>
                                    </div>
                                </div>
                            </div>
                        </div>


                    </div>
                    <%
                            isFirstTime= false;
                        }
                    %>
                </div>
                <% } %>
            </div>
        </main>

        <%@ include file="includes/footer.jsp"%>

        <script type="text/javascript">
            $(document).ready(function () {
                $(".submit").click(function (event) {
                    event.preventDefault();
                    const userId = $(this).data("user-id");
                    const formValue = $("#edit-form-"+userId ).serialize();
                    $(this).prop("disabled", true);

                    $.ajax({
                        type: "POST",
                        url: "edit-user",
                        data: formValue,
                        success: function (response) {
                            $("#result-user-"+userId).html(response).show();
                            setTimeout(function () {
                                if (userId === "noId"){
                                    window.location.href = "index.jsp";
                                } else {
                                    location.reload();
                                }
                            }, 2500);
                        },
                        error: function (xhr) {
                            $("#result-user-"+ userId).html(xhr.responseText).show();
                            $("#edit-button-"+ userId).prop("disabled", false);
                            setTimeout(function () {
                                $("#result-user-"+ userId).slideUp();
                            }, 2500);
                        }
                    });
                });
            });
        </script>

        <script type="text/javascript">
            $(document).ready(function() {
                $(".delete").click(function(event) {
                    event.preventDefault();
                    const userId = $(this).data("user-id");
                    const currentUserId = $(this).data("current-user-id");
                    var userCard = $("#accordion-item-" + userId);
                    $(this).prop("disabled", true);
                    $.ajax({
                        type: "POST",
                        url: "delete-user",
                        data: {userId: userId},
                        success: function(response) {
                            userCard.animate({ opacity: 0 }, 250, function() {
                                userCard.slideUp(300, function() {
                                    userCard.remove();
                                });
                            });
                            //COMPROBAR SI SE HA BORRADO EL USUARIO ACTUAL
                            if (currentUserId === userId){
                                window.location.href = "logout";
                            }
                        },
                        error: function () {
                            alert('Error al eliminar la tarjeta.');
                            $("#confirm-delete-button-" + userId).prop("disabled", false);
                        }
                    });
                });
            });
        </script>
    </body>
</html>