
<%@ page import="com.svalero.dao.BoardgameDao" %>
<%@ page import="com.svalero.domain.Boardgame" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.svalero.domain.User" %>
<%@ page import="com.svalero.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ include file="includes/header.jsp"%>

<main>
<div class="b-example-divider"></div>

    <h2 class="pb-2 border-bottom py-5 p-5 g-4 align-items-stretch">Juegos de Mesa</h2>



<%@ include file="includes/BoardgamesPag.jsp"%>

<%@include file="includes/footer.jsp"%>
