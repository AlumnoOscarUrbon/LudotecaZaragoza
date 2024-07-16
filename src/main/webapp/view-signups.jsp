<%@ page import="com.svalero.domain.Favorite" %>
<%@ page import="com.svalero.dao.FavoriteDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.util.Utils" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="com.svalero.domain.SignUp" %>
<%@ page import="com.svalero.dao.SignUpDao" %>
<%@ page import="static com.svalero.util.Utils.formatDateTimeToDate" %>
<%@ page import="java.util.Collections" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <main>
            <div class="container">
                <div class="container my-4"><h2 class="border-bottom pb-2 m-0">Mis inscripciones</h2></div>
            <%
                String sorted = request.getParameter("sorted");
                if (sorted == null || sorted.isBlank()) {
                    sorted="desc";
                }

                List<SignUp> signUps;

                String search = request.getParameter("search");
                if (search == null || search.isBlank()) {
                    search="";
                }

                if (!search.isBlank()){
                    String finalSearch = search;
                    signUps = Database.jdbi.withExtension(SignUpDao.class, dao -> dao.getSignUpsSearch(finalSearch, actualUserId));
                } else {
                    signUps = Database.jdbi.withExtension(SignUpDao.class, dao -> dao.getSignUpsByUserId(actualUserId));
                }
                if (signUps.isEmpty()) { %>
                <div class="container my-4 text-center "> Sin resultados. </div> <%
                } else { %>
                <div class="container py-3 px-0 bg-white rounded fine-border-light shadow-lg">

                <%
                    if (sorted.equals("desc")){
                        signUps.sort(Comparator.comparing(signUp -> signUp.getActivityFav().getActivityDateTime()));
                %>
                        <div class="d-flex align-items-center border-bottom border-gray pb-2 px-4 gap-2">
                            <h6 class="lh-1 mb-0 ">Ordenados por fecha de inicio:</h6>
                            <a href="?sorted=asc&search=<%=search%>" class="text-decoration-none m-0 p-0"> Descendente
                                <img src="icons/sort-down.svg" width="16" height="16" class=" " alt="">
                            </a>
                        </div>
                <%
                    } else if (sorted.equals("asc")) {
                        signUps.sort(Comparator.comparing(signUp -> signUp.getActivityFav().getActivityDateTime()));
                        Collections.reverse(signUps);
                %>
                    <div class="d-flex align-items-center border-bottom border-gray pb-2 px-4 gap-2">
                        <h6 class="lh-1 mb-0 ">Ordenados por fecha de inicio:</h6>
                        <a href="?sorted=desc&search=<%=search%>" class="text-decoration-none m-0 p-0"> Ascendente
                            <img src="icons/sort-up.svg" width="16" height="16" class=" " alt="">
                        </a>
                    </div>
                <%
                    }
                        for (SignUp signUp : signUps) {
                    %>
                    <div class="media px-5 pt-3 white95 " id="signUpItem-<%=signUp.getSignUpId()%>">

                        <div class="media-body d-flex align-items-center border-bottom border-gray" >
                            <div class="col-3 d-flex justify-content-start mb-3">
                                <a href="view-activity.jsp?actualActivityId=<%= signUp.getActivityFav().getActivityId() %>"><strong><%= signUp.getActivityFav().getName() %></strong></a>
                            </div>
                            <div class="col-6 d-flex justify-content-center mx-2">
                                <p>Actividad de <b><%= signUp.getActivityFav().getActivityCategory().getName() %></b> que comenzará el <b><%= formatDateTimeToDate(signUp.getActivityFav().getActivityDateTime()) %></b></p>
                            </div>
                            <div class="col-3 d-flex justify-content-end pe-3">
                                <a href="delete-sign-up" class="delete-signup-button" data-signup-id="<%=signUp.getSignUpId()%>"><img src="icons/trash.svg" alt="Trash icon" width="30" height="24" class=""></a>
                            </div>
                        </div>
                        <div id="result-reg-<%=signUp.getSignUpId()%>"></div>

                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </main>
        <%@include file="includes/footer.jsp"%>

        <!-- Eliminar favoritos -->
        <script type="text/javascript">
            $(document).ready(function() {
                $(".delete-signup-button").click(function(event) {
                    event.preventDefault();
                    const signUpId = $(this).data("signup-id");
                    const signUpItem = $("#signUpItem-" + signUpId);
                    $(this).prop("disabled", true);
                    $.ajax({
                        type: "POST",
                        url: "delete-sign-up",
                        data: {signUpId: signUpId},
                        success: function() {
                            signUpItem.animate({ opacity: 0 }, 600, function() {
                                signUpItem.remove();
                            });
                        },
                        error: function(response) {
                            $("#result-reg-" + signUpId).html(response).show();
                            $(this).prop("disabled", false);
                        }
                    });
                });
            });
        </script>

    </body>
</html>