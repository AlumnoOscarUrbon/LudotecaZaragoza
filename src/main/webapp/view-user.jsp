<%@ page import="com.svalero.domain.User" %>
<%@ page import="com.svalero.dao.UserDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
    <%@ include file="includes/header.jsp"%>
        <main>
            <div class="container my-3">
                <%
                    List<User> currentUserList = new ArrayList<>();
                    boolean isFirstTime = true;

                    String search = request.getParameter("search");
                    if (search == null || search.isBlank()) {
                        search = "%";
                    };

                    if (sessionUserRole.equals("admin")) {
                %>
                <div class="container">
                    <h2 class="border-bottom my-4 pb-2">Administrar Usuarios</h2>
                </div>
                <%
                    final String searchTerm = search;
                    currentUserList = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUsersSearch(searchTerm, sessionUserId));

                    } else if (sessionUserRole.equals("user")) {
                %>
                <div class="container">
                    <h2 class="border-bottom my-4 pb-2">Mis Datos</h2>
                </div>
                <%
                    currentUserList = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUserById(sessionUserId));

                    } else {
                %>
                <div class="container">
                    <h2 class="border-bottom my-4 pb-2">Registrar Usuario</h2>
                </div>
                <%
                        currentUserList.add(new User());
                        currentUserList.get(0).setUserId("noId");
                        currentUserList.get(0).setRole("noRole");
                    }
                    if (currentUserList.isEmpty()) {
                %>
                <div class="container my-4 text-center">Sin resultados.</div>
                <%
                    } else {
                %>
                <div class="accordion shadow-lg rounded-4" id="accordionUsers">

                    <%
                        for (User currentUser : currentUserList) {
                    %>

                    <div class="accordion-item white95" id="accordion-item-<%=currentUser.getUserId()%>">
                        <h2 class="accordion-header">
                            <button class="accordion-button <%= !isFirstTime ? "collapsed" : "" %>"
                                    type="button" data-bs-toggle="collapse"
                                    data-bs-target="#collapse<%=currentUser.getUserId()%>"
                                    aria-expanded="<%= isFirstTime ? "true" : "false" %>"
                                    aria-controls="collapse<%=currentUser.getUserId()%>">
                                <%= !currentUser.getUserId().equals("noId") ? "<b>" + currentUser.getUsername() + "</b>" : "Alta de&nbsp;<b>nuevo usuario</b>" %>
                            </button>
                        </h2>
                        <div id="collapse<%=currentUser.getUserId()%>" class="accordion-collapse collapse <%= isFirstTime ? "show" : "" %>" data-bs-parent="#accordionUsers">
                            <div class="accordion-body">
                                <form class="row g-3" id="edit-form-<%=currentUser.getUserId()%>" action="edit-user" method="post">
                                    <div class="col-md-4">
                                        <label for="username<%=currentUser.getUserId()%>" class="form-label">Nombre</label>
                                        <input type="text" name="username" class="form-control" id="username<%=currentUser.getUserId()%>" placeholder="Tu nombre"
                                               value="<%= !currentUser.getUserId().equals("noId") ? currentUser.getUsername() : "" %>">
                                    </div>
                                    <div class="col-md-4">
                                        <label for="email<%=currentUser.getUserId()%>" class="form-label">Email</label>
                                        <input type="email" name="email" class="form-control" id="email<%=currentUser.getUserId()%>" placeholder="Tu email"
                                               value="<%= !currentUser.getUserId().equals("noId") ? currentUser.getEmail() : "" %>">
                                    </div>
                                    <div class="col-md-4">
                                        <label for="birthDate<%=currentUser.getUserId()%>" class="form-label">Fecha de nacimiento</label>
                                        <input type="date" name="birthDate" class="form-control" id="birthDate<%=currentUser.getUserId()%>" placeholder="dd/mm/yyyy"
                                               value="<%= !currentUser.getUserId().equals("noId") ? currentUser.getBirthDate() : "" %>">
                                    </div>
                                    <div class="col-md-4">
                                        <label for="password<%=currentUser.getUserId()%>" class="form-label">Contraseña</label>
                                        <input type="text" name="password" class="form-control" id="password<%=currentUser.getUserId()%>"
                                               placeholder="<%= !currentUser.getUserId().equals("noId") ? "Deja en blanco si no quieres cambiarla" : "Tu contraseña" %>" value="">
                                    </div>
                                    <div class="col-md-4">
                                        <label for="userRole<%=currentUser.getUserId()%>" class="form-label">Rol</label>
                                        <select class="form-select" name="role" id="userRole<%=currentUser.getUserId()%>">
                                            <option disabled <%= currentUser.getRole().equals("noRole") ? "selected" : "" %>>Selecciona</option>
                                            <option value="user" <%= currentUser.getRole().equals("user") ? "selected" : "" %>>Usuario</option>
                                            <option value="admin" <%= currentUser.getRole().equals("admin") ? "selected" : "" %>>Administrador</option>
                                        </select>
                                    </div>
                                    <input type="hidden" name="userId" value="<%=currentUser.getUserId()%>">
                                    <div class="col-md-4 d-flex justify-content-between align-items-end gap-3">
                                        <button class="btn submit btn-primary w-100" type="submit" data-user-id="<%=currentUser.getUserId()%>" id="edit-button-<%=currentUser.getUserId()%>">
                                            <%= currentUser.getUserId().equals("noId") ? "REGISTRAR" : "ACTUALIZAR" %>
                                        </button>
                                        <button class="btn btn-danger w-100" data-bs-toggle="modal" data-bs-target="#Delete-Modal-<%=currentUser.getUserId()%>" type="button" id="delete-button-<%=currentUser.getUserId()%>"
                                                <%= currentUser.getUserId().equals("noId") ? "style='display:none;'" : "" %>>BORRAR
                                        </button>
                                    </div>
                                </form>
                            </div>
                            <div id="result-user-<%=currentUser.getUserId()%>" class="user-message"></div>
                        </div>

                        <!-- Modal confirmacion borrado -->
                        <div class="modal fade" id="Delete-Modal-<%=currentUser.getUserId()%>" tabindex="-1" aria-labelledby="DeleteModalLabel-<%=currentUser.getUserId()%>" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-top-third">
                                <div class="modal-content p-3 white95 center&cover-bg" style="background-image: url('icons/stripes.jpg');">
                                    <div class="modal-header d-flex justify-content-between">
                                        <h2 class="fs-4 mb-0" id="SignInModalLabel">Eliminar permanentemente</h2>
                                        <button type="button" class="btn-close bclose-corner" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body mx-3 d-flex flex-column justify-content-center align-items-center">
                                        <h2 class="border-bottom mb-4"><b><%=currentUser.getUsername()%></b></h2>
                                        <button class="btn delete btn-danger w-50 text-center p-3" type="submit" data-current-user-id="<%=currentUser.getUserId()%>" data-session-user-id="<%=sessionUserId%>"
                                                id="confirm-delete-button-<%=currentUser.getUserId()%>" data-bs-dismiss="modal">CONFIRMAR
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
        <!-- Envio a registro/actualización -->
        <script type="text/javascript">
            $(document).ready(function () {
                $(".submit").click(function (event) {
                    event.preventDefault();
                    const userId = $(this).data("user-id");
                    const formValue = $("#edit-form-" + userId );
                    $(this).prop("disabled", true);

                    $.ajax({
                        type: "POST",
                        url: "edit-user",
                        data: formValue.serialize(),
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

        <!-- Borrado de usuario -->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".delete").click(function(event) {
                    event.preventDefault();
                    const currentUserId = $(this).data("current-user-id");
                    const sessionUserId = $(this).data("session-user-id");
                    var userCard = $("#accordion-item-" + currentUserId);
                    $(this).prop("disabled", true);
                    $.ajax({
                        type: "POST",
                        url: "delete-user",
                        data: {userId: currentUserId},
                        success: function() {
                            userCard.animate({ opacity: 0 }, 250, function() {
                                userCard.slideUp(300, function() {
                                    userCard.remove();
                                });
                            });
                            //Comprobar si se ha borrado el session user
                            if (sessionUserId === currentUserId){
                                window.location.href = "logout";
                            }
                        },
                        error: function () {
                            alert('Error al eliminar la tarjeta.');
                            $("#confirm-delete-button-" + currentUserId).prop("disabled", false);
                        }
                    });
                });
            });
        </script>

    </body>
</html>