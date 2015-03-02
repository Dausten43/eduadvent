<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="docAlumL" scope="page" class="aca.archivo.ArchDocAlumLista" />
<jsp:useBean id="ArchImagenL" scope="page" class="aca.archivo.ArchImagenLista" />

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoAlumno");	
	String nombreAlumno 	= aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE"); 
	int cont 		= 0;
	int maxFile		= 5;
	
	ArrayList<aca.archivo.ArchDocAlum> lisDocumentos = docAlumL.getListArchDocAlum(conElias, codigoId, "ORDER BY DOCUMENTO_ID");
	
	/* HashMap de las imagnes almacenadas del alumno*/
	java.util.HashMap<String,aca.archivo.ArchImagen> mapImagen	=  ArchImagenL.mapImagenAlumno(conElias, escuelaId, codigoId, "");
	
	/* Cuenta la cantidad de imagenes almacenadas en cada documento*/
	java.util.HashMap<String,String> mapNumImagenes				=  ArchImagenL.mapNumImagenes(conElias, escuelaId, codigoId, "");
%>

<div id="content">
 
<% 	// Si no existe el alumno
	if (nombreAlumno.equals("-")){
%>	
	<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
	</div>
<%
	}else{
%>
	<h2><fmt:message key="archivo.Documentos"/> <small><%=nombreAlumno%></small></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="documento.jsp">
			<i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir"/>
		</a>
	</div>

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
		for (aca.archivo.ArchDocAlum alumno: lisDocumentos) {
			cont++;
				
			/* Si el alumno tiene imagenes en el documento no se permite borrarlo */
			boolean borrar=true;
			if (mapNumImagenes.containsKey(alumno.getDocumentoId())){
				if ( Integer.parseInt(mapNumImagenes.get(alumno.getDocumentoId()))>0) borrar = false;
			}
%>
			<tr>
				<td><%=cont%></td>
				<td>
					<a href="documento.jsp?Accion=0&CodigoPersonal=<%=codigoId%>&documentoId=<%=alumno.getDocumentoId()%>">
						<i class="icon-pencil"></i>
					</a>
					<%if (borrar){%>				
						<a href="javascript:if(confirm('<fmt:message key='js.Confirma' />'))location.href='documento.jsp?Accion=3&CodigoPersonal=<%=codigoId%>&documentoId=<%=alumno.getDocumentoId()%>';">
							<i class="icon-remove"></i>
						</a>
					<%}%>		
					<%=aca.archivo.ArchDocAlumLista.getNombreDocumento( conElias, alumno.getDocumentoId(), escuelaId)%>
				</td>
				<td><%=alumno.getComentario()%></td>
				<td><%=alumno.getUsuario()%></td>
				<td>
<%	
				for (int j=1;j<=maxFile;j++){
					if (mapImagen.containsKey(alumno.getDocumentoId()+j)){
						aca.archivo.ArchImagen archivo = (aca.archivo.ArchImagen) mapImagen.get(alumno.getDocumentoId()+j);
						
						// Extensión del archivo almacenado
						String tipo = archivo.getNombre().substring(archivo.getNombre().indexOf(".")+1)==null?"pdf":archivo.getNombre().substring(archivo.getNombre().indexOf(".")+1);
						if (tipo.equals("jpg") || tipo.equals("png") || tipo.equals("jpeg")){
%>							
							<a title="<fmt:message key='aca.VerImagen' />" href="mostrar.jsp?DocumentoId=<%=alumno.getDocumentoId() %>&Hoja=<%=j %>">
								<i class="icon-picture icon-black"></i>
							</a>
<%							
						}else{
%>
							<a title="<fmt:message key='aca.VerArchivo' />" href="mostrar.jsp?DocumentoId=<%=alumno.getDocumentoId()%>&Hoja=<%=j%>">
								<i class='icon-file icon-black'></i>
							</a>
<%							
						}						
					}else{
%>						
						<a title="<fmt:message key='aca.SubirImagen' />" href="subir.jsp?DocumentoId=<%=alumno.getDocumentoId() %>&Hoja=<%=j%>">
							<i class="icon-upload icon-black"></i>
						</a>
<%
					}			
				}
%>								
				</td>
			</tr>
<%
		}
%>
	</table>
<%	
	}	
%>	
</div>
<%@ include file="../../cierra_elias.jsp"%>