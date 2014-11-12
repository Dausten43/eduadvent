<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>

<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String constanciaId         = request.getParameter("constanciaId");
	if(constanciaId == null){
		response.sendRedirect("documento.jsp");
	}

	AlumConstancia.mapeaRegId(conElias, constanciaId, escuelaId);
%>

<link rel="stylesheet" href="../../js-plugins/ckeditor/contents.css"></link>


<div id="content">
	
	<%=AlumConstancia.getConstancia() %>
	
</div>	



<%@ include file="../../cierra_elias.jsp" %>