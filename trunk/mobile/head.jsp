<!doctype html>
<%@page errorPage="../paginaerror.jsp"%>
<%@ include file= "../idioma.jsp" %>
<%@page buffer="8kb"%>

<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

<link rel="stylesheet" href="../../bootstrap-icons/css/bootstrap.css" />

<link rel="stylesheet" href="../../jqm/jquery.mobile-1.4.2.min.css" />
<script src="../../jqm/jquery-1.9.1.min.js"></script>
<script src="../../jqm/jquery.mobile-1.4.2.min.js"></script>

<link rel="stylesheet" href="../../css/style.css" />

<title>Sistema Escolar</title>


<%
	
	// Sube a sesión el idJsp
	if ( !idJsp.equals("0") ){
		session.setAttribute("idJsp", idJsp);		
	}
	
%>
