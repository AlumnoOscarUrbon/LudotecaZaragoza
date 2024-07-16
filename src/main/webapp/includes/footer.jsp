<%@ page contentType="text/html;charset=UTF-8" %>


<footer class="d-flex flex-wrap justify-content-between align-items-center py-3 mt-4 border-top text-bg-dark mt-auto text-white">
    <div class="container">
        <div class="col-md-4 d-flex align-items-center">
            <a href="/" class="mb-3 me-2 mb-md-0 text-white text-decoration-none lh-1">
                <svg class="bi" width="30" height="24"><use xlink:href="#bootstrap"/></svg>
            </a>
            <span class="mb-3 mb-md-0 text-white">&copy; 2024 Óscar Urbón Risueño, 1º DAM</span>
        </div>

        <ul class="nav col-md-4 justify-content-end list-unstyled d-flex">
            <li class="ms-3"><a class="text-white" href="#"><svg class="bi" width="24" height="24"><use xlink:href="#twitter"/></svg></a></li>
            <li class="ms-3"><a class="text-white" href="#"><svg class="bi" width="24" height="24"><use xlink:href="#instagram"/></svg></a></li>
            <li class="ms-3"><a class="text-white" href="#"><svg class="bi" width="24" height="24"><use xlink:href="#facebook"/></svg></a></li>
        </ul>
    </div>
</footer>


<% try {
    Database.close();
} catch (SQLException e) {
    System.out.println("Error cerrando conexion con BBDD");
    throw new RuntimeException(e);
} %>