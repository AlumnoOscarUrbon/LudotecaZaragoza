<%@ page import="com.svalero.dao.BoardgameDao" %>
<%@ page import="com.svalero.domain.Boardgame" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ include file="includes/header.jsp"%>

<%

    String boardgameId = request.getParameter("boardgameId");
    Boardgame boardgame = Database.jdbi.withExtension(BoardgameDao.class, dao -> dao.getdBoardgameById(boardgameId));


%>
<div class="container my-5">
    <div class="row p-4 pb-0 pe-lg-0 pt-lg-4 align-items-center rounded-3 border shadow-lg justify-content-between">
        <div class="col-lg-6 p-3 p-lg-5 pt-lg-3 align-items-stretch">
            <h1 class="display-4 fw-bold lh-1 text-body-emphasis m-2"><%=boardgame.getName()%></h1>
            <p class="lead m-4 " ><%= boardgame.getDescription() %></p>
            <hr>
            <p class="lead m-4 " >Lanzado el <b><%= boardgame.getDate() %> </b> por <%=boardgame.getBrandId() %> </p>
            <hr>
            <div class="d-grid gap-2 d-md-flex justify-content-md-start ">
                <% if (role.equals("admin")) { %> <button type="button" class="btn btn-primary btn-lg px-4 me-md-2 fw-bold">Editar</button> <%}%>
                <button type="button" class="btn btn-outline-secondary btn-lg px-4">Favorito</button>
            </div>
        </div>
        <div class="col-lg-6 p-0 overflow-hidden d-flex align-items-center">
            <img class="img-responsive d-block rounded rounded-4 h-100 m-4" src="pictures/<%= boardgame.getPicture() %>" alt="">
        </div>
    </div>
</div>





<%@include file="includes/footer.jsp"%>
