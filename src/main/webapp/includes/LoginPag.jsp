<%@ page contentType="text/html;charset=UTF-8" %>

<script type="text/javascript">
    $(document).ready(function() {
        $("#form1").on("submit", function(event) {
            event.preventDefault();
            const formValue = $(this).serialize();
            $.ajax("login1", {
                type: "POST",
                data: formValue,
                success: function () {
                    location.reload();
                },
                error: function (xhr) {
                    $("#result-login").html(xhr.responseText).show();
                    setTimeout(function () {
                        $("#result-login").slideUp();
                    }, 2500);
                }
            })
        });
    });
</script>

<!-- Modal - Inicio sesion -->
<div class="modal fade" id="Sign-In-Modal" tabindex="-1" aria-labelledby="SignInModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-top-third">
        <div class="modal-content">
            <div class="modal-header d-flex justify-content-between mx-3 pb-2">
                <div><h2 class="modal-title fs-3" id="SignInModalLabel">¡Bienvenido!</h2></div>
                <div><button type="button" class="btn-close bclose-signin" data-bs-dismiss="modal" aria-label="Close"></button></div>
            </div>
            <div class="modal-body mx-3">
                <form id="form1" method="post">
                    <div class="form-floating">
                        <input type="text" class="form-control my-3" id="floatingInput" name="username" placeholder="Usuario" >
                        <label for="floatingInput">Usuario</label>
                    </div>
                    <div class="form-floating">
                        <input type="password" class="form-control  my-3" id="floatingPassword" name="password" placeholder="Contraseña">
                        <label for="floatingPassword">Contraseña</label>
                    </div>
                    <button class="btn btn-warning w-100 py-2 my-3" type="submit">Iniciar sesión</button>
                    <hr class="my-2">
                    <small class="text-body-secondary fs-6"> Si no tienes cuenta  <a href="${pageContext.request.contextPath}/view-user.jsp" class="fs-5">registrate aquí.</a> </small>
                </form>
                <hr>
                <div id="result-login"></div>
            </div>
        </div>
    </div>
</div>