<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <%@ include file="includes/head.jsp"%>
    <body>
        <%@ include file="includes/header.jsp"%>
        <%
            String search = request.getParameter("search");
            if (search == null) {search = "";};
        %>
        <main>
            <%@ include file="includes/GamesPag.jsp"%>
            <%@ include file="includes/ActivitiesPag.jsp"%>
        </main>
        <%@include file="includes/footer.jsp"%>
    </body>
</html>
