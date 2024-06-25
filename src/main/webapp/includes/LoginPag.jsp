<%@ page contentType="text/html;charset=UTF-8" %>

<script type="text/javascript">
    $(document).ready(function() {
        $("#form1").on("submit", function(event) {
            event.preventDefault();
            const formValue = $(this).serialize();
            $.ajax("login1", {
                type: "POST",
                data: formValue,
                statusCode: {
                    200: function(response) {
                        if (response === "ok") {
                            window.location.href = "/LudotecaZaragoza";
                        } else {
                            $("#result").html(response);
                        }
                    }
                }
            });
        });
    });
</script>

<!-- Modal - Inicio sesion -->
<div class="modal fade" id="Sign-In-Modal" tabindex="-1" aria-labelledby="SignInModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header d-flex justify-content-between">
                <div><h2 class="modal-title fs-5" id="SignInModalLabel">¡Bienvenido!</h2></div>
                <div><button type="button" class="btn-close " data-bs-dismiss="modal" aria-label="Close"></button></div>
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

                    <button class="btn btn-primary w-100 py-2 my-3" type="submit">Iniciar sesión</button>
                </form>
                <div id="result"></div>
            </div>
        </div>
    </div>
</div>