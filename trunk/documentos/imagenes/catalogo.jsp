<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<head>
<%
	String escuela 		= (String)session.getAttribute("escuela");
	String dir 			= application.getRealPath("/WEB-INF/"+escuela);

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
<%	
	java.io.File file = new java.io.File(dir);
	if (file.exists()){
		java.io.File[] lisArchivos = file.listFiles();
		for (int x=0;x<lisArchivos.length;x++){
%>
		<tr>
			<td width="4%"><%=x+1%></td>			
			<td><img src="imagen.jsp?NombreArchivo=<%=lisArchivos[x].getName()%>&id=<%=new java.util.Date().getTime()%>" width="300px;"></td>
			<td><%=dir+"/"+lisArchivos[x].getName()%></td>
		</tr>
<%
		}	
	}else{
		out.print("<tr><td colspan='3'>¡ No tiene imagenes !</td></tr>");
	}
%>		
	</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
