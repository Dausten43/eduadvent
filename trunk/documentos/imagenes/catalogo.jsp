<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<head>
<%
	String escuela 		= (String)session.getAttribute("escuela");
	String dir 			= application.getRealPath("/WEB-INF/"+escuela);
	String codigoId		= session.getAttribute("codigoId").toString()==null?"-":session.getAttribute("codigoId").toString();
%>
</head>
<body>
<div id="content">
	<h2>Catálogo de imágenes <small>( <%=aca.catalogo.CatEscuela.getNombre(conElias, escuela) %> )</small></h2>

	<div class="well" style="overflow:hidden;">
 		<a class="btn btn-primary" href="subir.jsp"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	</div>
	
	<table class="table table-condensed table-bordered table-striped table-fontsmall">
		<tr>
			<th width="4%"><fmt:message key="aca.AbreviaNum" /></th>
			<th width="4%">Op.</th>			
			<th>Imagen <small>Dar click sobre la imagen para obtener liga</small></th>
		</tr>
<%	
	java.io.File file = new java.io.File(dir);
	if (file.exists()){
		java.io.File[] lisArchivos = file.listFiles();
		for (int x=0;x<lisArchivos.length;x++){
		dir = "http://academico.um.edu.mx/escuela/documentos/imagenes/imagen.jsp?NombreArchivo="+lisArchivos[x];
%>
		<tr>
			<td width="4%"><%=x+1%></td>			
			<td width="4%"><a href="javascript: borrar('<%=lisArchivos[x].getName()%>');"><i class="icon icon-remove"></i></a></td>
			<td><img src="imagen.jsp?NombreArchivo=<%=lisArchivos[x].getName()%>&id=<%=new java.util.Date().getTime()%>" onclick="clicked(this,<%=x %>);"  width="300px;"></td>
		</tr>
<%
		}	
	}else{
		out.print("<tr><td colspan='3'>¡ No tiene imagenes !</td></tr>");
	}
%>		
	</table>
</div>
<script>
	function borrar(nombre){
		if( confirm("<fmt:message key="js.Confirma" />") ){
			location.href="borrar.jsp?nombreArchivo="+nombre;
		}
	}
</script>

<script type="text/javascript">
function clicked(address, id) {
	var youtubeimgsrc = address.src;
	window.prompt("Copiar al portapapeles: Ctrl+C, Enter", youtubeimgsrc);
    //document.execCommand("copy");


}
</script>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
