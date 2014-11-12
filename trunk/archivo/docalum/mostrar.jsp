<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Archivo" scope="page" class="aca.archivo.ArchImagen" />

<script>
	function Borrar(DocumentoId, Hoja){
		if (confirm("Deseas eliminar el archivo")){
			document.location.href="borrar.jsp?DocumentoId="+DocumentoId+"&Hoja="+Hoja;
		}
	}
</script>

<%
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String escuelaId 		= (String) session.getAttribute("escuela");
	String documentoId		= request.getParameter("DocumentoId");
	String hoja				= request.getParameter("Hoja")==null?"0":request.getParameter("Hoja");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	Archivo.mapeaRegId(conElias, codigoId, escuelaId, documentoId, hoja);
	String tipo = Archivo.getNombre().substring(Archivo.getNombre().indexOf(".")+1)==null?"pdf":Archivo.getNombre().substring(Archivo.getNombre().indexOf(".")+1);	
%>

<div id="content">
	<h2>Datos del archivo
		<small><%= aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE")%></small>
	</h2>
	<div class="well">
		<a href="docalum.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	<form name="frmMostrar" id="frmMostrar" action="mostrar.jsp?DocumentoId=<%=documentoId%>&Hoja=<%=hoja%>" method="post">
		<input name="Accion" type="hidden">
		<table class="table table-bordered">
			<tr>
				<th>
				<%= aca.archivo.ArchDocumento.getNombreDoc(conElias, documentoId, escuelaId)%> ( No. <%=hoja%> )&nbsp;&nbsp;
				Archivo: <strong><%=Archivo.getNombre()%></strong> &nbsp;&nbsp;
				<a href="bajarArchivo.jsp?DocumentoId=<%=documentoId%>&Hoja=<%=hoja%>"><i class="icon-download-alt"></i></a>&nbsp;&nbsp;
				<a href="javascript:Borrar('<%=documentoId%>','<%=hoja%>')"><i class='icon-remove'></i></a>
				</th>
			</tr>
<%
			if (tipo.equals("jpg")){
				out.println("<tr><td><img name='imagen' src='fotoArchivo.jsp?DocumentoId="+documentoId+"&Hoja="+hoja+"' width='730' nosave></td></tr>");
			}
%>			
		</table>
	</form>
</div>
<%@ include file="../../cierra_elias.jsp" %>