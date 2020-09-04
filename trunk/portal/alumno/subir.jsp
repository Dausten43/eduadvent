<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.io.File"%>

<jsp:useBean id="archivoLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista"/>
<jsp:useBean id="archivo" scope="page" class="aca.kardex.KrdxAlumArchivo"/>

<%
	String codigoId			= (String) session.getAttribute("codigoAlumno");
	String cicloGrupoId		= request.getParameter("cicloGrupoId");
	String cursoId			= request.getParameter("cursoId");
	String evaluacionId		= request.getParameter("evaluacionId");
	String actividadId 		= request.getParameter("actividadId");
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String nombreArchivo	= request.getParameter("nombreArchivo")==null ? "" : request.getParameter("nombreArchivo");
	String folio			= request.getParameter("Folio")==null ? "" : request.getParameter("Folio");
	
	boolean eligio			= false;

	if(accion.equals("2")){				
		archivo.setCodigoId(codigoId);
		archivo.setFolio(folio);
		archivo.deleteReg(conElias);
		String dirArchivo = application.getRealPath("/WEB-INF/archivos")+"/"+String.valueOf(session.getAttribute("escuela"))+"/"+codigoId+"/"+nombreArchivo;
		new File(dirArchivo).delete();
	}
%>

<script>

	function borrar(Folio, nombreArchivo, cicloGrupoId, cursoId, evaluacionId, actividadId, fechaTarea, Regresar){
		if(confirm("<fmt:message key="js.Confirma"/>")){
			document.location.href = "subir.jsp?Accion=2&Folio="+Folio+"&nombreArchivo="+nombreArchivo+"&cicloGrupoId="+cicloGrupoId+"&cursoId="+cursoId+"&evaluacionId="+evaluacionId+"&actividadId="+actividadId+"&fechaTarea="+fechaTarea+"&Regresar="+Regresar;
		}
	}

	function guardar(){
		if(document.formaEnviar.archivo.value != ""){
			eligio = true;
			document.formaEnviar.btnGuardar.disabled = true;
			document.formaEnviar.btnGuardar.value = "<fmt:message key="aca.Guardando"/>";
			document.formaEnviar.submit();
		}else
			alert("<fmt:message key="aca.SeleccionaArchivo"/>");
	}
</script>

<div id="content">
	<h2><fmt:message key="aca.SubirArchivo"/></h2>
	
	<div class="well">
	<%	
		String Regresar = request.getParameter("Regresar") == null?"":request.getParameter("Regresar");
		if(Regresar.equals("1")){
	%>
			<a class="btn btn-primary" href="tareas_new.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	<%	}else if(Regresar.equals("0")){
	%>
			<a class="btn btn-primary" href="materias.jsp?Accion=3"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	<% 	}%>
	</div>
	
	<form name="formaEnviar" id="formaEnviar" enctype="multipart/form-data" action="guardar.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId=<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaTarea=<%=request.getParameter("fechaTarea")%>&Regresar=<%=request.getParameter("Regresar")%>" method="post">
			
		<div class="well">
			<input type="file" id="archivo" name="archivo" />
		</div>
		
		<div class="well">
			<button  class="btn btn-primary btn-large" id="btnGuardar"  value="Guardar" onclick="guardar();"><i class="icon-arrow-up icon-white"/></i> <fmt:message key="boton.Enviar"/></button>
		</div>
		<br>
		
		
		<h2>Archivos Enviados</h2>
				
		<%
			ArrayList<aca.kardex.KrdxAlumArchivo> lista = archivoLista.getListEvaluacionAlumno(conElias, codigoId, cicloGrupoId, cursoId, evaluacionId, actividadId, "ORDER BY FECHA");
		%>
		<table width="70%" border="0" align="center" class="table table-condensed" > 
			<tr>
				<th width="10%"><fmt:message key="aca.Operacion"/></th>
				<th width="20%"><fmt:message key="aca.FechaEnvio"/></th>
				<th width="80%"><fmt:message key="aca.NombreDelArchivo"/></th>
			</tr>
		<%	if(lista.size()>0){
				for(int i=0; i<lista.size(); i++){
					aca.kardex.KrdxAlumArchivo tarea = lista.get(i);
					
					String arrExt [] = tarea.getArchivo().split("\\.");
					String ext = arrExt[arrExt.length-1];
					String [] arrFecha = tarea.getFecha().split(" ");
			%>
					<tr>
						<td align="center" width="20">
						     <a href="descargar.jsp?Ruta=<%=application.getRealPath("/WEB-INF/archivos")+"/"+String.valueOf(session.getAttribute("escuela"))+"/"+codigoId+"/"+codigoId+"-"+tarea.getFolio()+"."+ext%>&nombreArchivo=<%=codigoId+"-"+tarea.getFolio()+"."+ext%>">
								<i class="icon-download-alt"></i>
							</a>
						     
		   					 <i class="icon-remove" onclick="borrar('<%=tarea.getFolio()%>','<%=codigoId+"-"+tarea.getFolio()+"."+ext%>','<%=cicloGrupoId%>','<%=cursoId%>','<%=evaluacionId%>','<%=actividadId%>','<%=request.getParameter("fechaTarea")%>','<%=request.getParameter("Regresar")%>');" style="cursor:pointer;"></i>
				   		</td>
				   		<td align="center"><%=arrFecha[0]%><br><%=arrFecha[1]%></td>
				   		<td>&nbsp;&nbsp;<%=codigoId+"-"+tarea.getFolio()+"."+ext+"   ("+tarea.getArchivo()+")"%></td>
					</tr>
			<%	}
			}%>
		</table>
	</form>
</div>

<%@ include file="../../cierra_elias.jsp" %>