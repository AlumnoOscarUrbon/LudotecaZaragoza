<%@ page contentType="text/html;charset=UTF-8" %>


<footer class="d-flex flex-wrap justify-content-between align-items-center py-3 mt-4 border-top text-bg-dark mt-auto text-white">
    <div class="container">
        <div class="d-flex w-100 justify-content-between align-items-center">
            <span class="text-white">&copy; 2024 Óscar Urbón Risueño, 1º DAM</span>
            <a href="https://github.com/AlumnoOscarUrbon/LudotecaZaragoza" class="text-white text-decoration-none lh-1 ms-auto">
                <span class="mx-2 ">Repositorio del proyecto</span>
                <img src="icons/github-icon.png" class="bi" width="32" height="32" alt="GitHub Icon">
            </a>
        </div>
    </div>
</footer>



<%
    try {
        Database.close();
    } catch (SQLException e) {
        System.out.println("Error cerrando conexion con BBDD");
        e.printStackTrace();
        throw new RuntimeException(e);
    }
%>