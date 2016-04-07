<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>

<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String constanciaId         = request.getParameter("constanciaId");
	String salto				= "X";
	if(constanciaId == null){
		salto = "documento.jsp";
	}

	AlumConstancia.mapeaRegId(conElias, constanciaId, escuelaId);
%>

<link rel="stylesheet" href="../../js-plugins/ckeditor/contents.css"></link>


<div id="content">
	
	<%=AlumConstancia.getConstancia() %>
	
</div>	


<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>