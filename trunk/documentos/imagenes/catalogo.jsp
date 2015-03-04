<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<head>
<%
	String escuela = (String)session.getAttribute("escuela");

%>
</head>
<body>
<div id="content">
	<h2>Catálogo de imágenes <small><%=aca.catalogo.CatEscuela.getNombre(conElias, escuela) %></small></h2>

	<div class="well" style="overflow:hidden;">
 		<a class="btn btn-primary" href="subir.jsp"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	</div>
	
	<table class="table table-condensed table-bordered table-striped table-fontsmall">
		<tr>
			<th width="4%"><fmt:message key="aca.AbreviaNum" /></th>			
			<th>Imagen</th>
			<th>Ruta</th>		
		</tr>
	</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
