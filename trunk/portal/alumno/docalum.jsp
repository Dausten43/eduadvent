<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ include file="menuPortal.jsp"%>

<jsp:useBean id="docAlumL" scope="page" class="aca.archivo.ArchDocAlumLista" />
<jsp:useBean id="ArchImagenL" scope="page" class="aca.archivo.ArchImagenLista" />

<%
	
	String escuelaId		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoAlumno");	
	String nombreAlumno 	= aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE"); 
	int cont 				= 0;
	int maxFile				= 5;
	
	ArrayList<aca.archivo.ArchDocAlum> lisDocumentos = docAlumL.getListArchDocAlum(conElias, codigoId, "ORDER BY DOCUMENTO_ID");
	
	/* HashMap de las imagnes almacenadas del alumno*/
	java.util.HashMap<String,aca.archivo.ArchImagen> mapImagen	=  ArchImagenL.mapImagenAlumno(conElias, escuelaId, codigoId, "");
	
%>

<div id="content">
	
	<h2><fmt:message key="archivo.Documentos"/> <small><%=nombreAlumno%></small></h2>
	
	<hr />
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="archivo.Documentos" /></th>
				<th><fmt:message key="aca.Comentario" /></th>
				<th><fmt:message key="aca.Usuario" /></th>
				<th><fmt:message key="aca.Imagenes" /></th>
			</tr>
		</thead>
		<%
			for (int i = 0; i < lisDocumentos.size(); i++) {
				cont++;
				aca.archivo.ArchDocAlum alumno = (aca.archivo.ArchDocAlum) lisDocumentos.get(i);
		%>
		<tr>
			<td align="left"><%=cont%></td>
			<td align="left">		
				<%=aca.archivo.ArchDocAlumLista.getNombreDocumento( conElias, alumno.getDocumentoId(), escuelaId)%>
			</td>
			<td align="left"><%=alumno.getComentario()%></td>
			<td align="center"><%=alumno.getUsuario()%></td>
			<td align="center">
			<%	for (int j=1;j<=maxFile;j++){
					if (mapImagen.containsKey(alumno.getDocumentoId()+j)){
						aca.archivo.ArchImagen archivo = (aca.archivo.ArchImagen) mapImagen.get(alumno.getDocumentoId()+j);
						
						// Extensión del archivo almacenado
						String tipo = archivo.getNombre().substring(archivo.getNombre().indexOf(".")+1)==null?"pdf":archivo.getNombre().substring(archivo.getNombre().indexOf(".")+1);
						if (tipo.equals("jpg")){
							out.print("<a href='mostrar.jsp?DocumentoId="+alumno.getDocumentoId()+"&Hoja="+j+"'><i class='icon-picture icon-black'></i></a>&nbsp;&nbsp;");
						}else{
							out.print("<a href='mostrar.jsp?DocumentoId="+alumno.getDocumentoId()+"&Hoja="+j+"'><i class='icon-file icon-black'></i></a>&nbsp;&nbsp;");
						}						
					}				
				}	
			%>			
								
			</td>
		</tr>
		<%
			}
		%>
	</table>
	
</div>

<script>
	jQuery('.documentos').addClass('active');
</script>

<%@ include file="../../cierra_elias.jsp"%>