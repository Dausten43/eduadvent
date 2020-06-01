<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file="../../menu.jsp"%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="ArchivosEnviadosLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista"/>
<jsp:useBean id="RevisarArchivos" scope="page" class="aca.kardex.KrdxAlumActiv"/>

<script type="text/javascript">
	function guardar(){
		document.frmTareas.Accion.value="1";
		document.frmTareas.submit();
	}
</script>

<%
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String cursoId 		= (String) session.getAttribute("cursoId");
	String evaluacionId	= request.getParameter("evaluacionId");
	String actividadId	= request.getParameter("actividadId");
	
	String fechaEntrega	= request.getParameter("fechaEntrega");
	
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion"); 
	
	boolean grabo 		= false;
	
	//ArrayList<aca.kardex.KrdxAlumArchivo> archivosEnviados = ArchivosEnviadosLista.getListArchivosEnviados(conElias, cicloGrupoId, cursoId, evaluacionId, actividadId, " ORDER BY CODIGO_ID, FECHA");
	ArrayList<String> archivosEnviados = ArchivosEnviadosLista.getListCodigoSinRepetir(conElias, cicloGrupoId, cursoId, evaluacionId, actividadId, " ORDER BY CODIGO_ID");
	TreeMap<String, aca.kardex.KrdxAlumActiv> actividadesPorAlumno = new aca.kardex.KrdxAlumActivLista().getTreeActividades(conElias, cicloGrupoId, cursoId, evaluacionId, "");
	
	
	if(accion.equals("1")){
		
		RevisarArchivos.setCicloGrupoId(cicloGrupoId);
		RevisarArchivos.setCursoId(cursoId);
		RevisarArchivos.setEvaluacionId(evaluacionId);
		RevisarArchivos.setActividadId(actividadId);
		
		for(int i=0; i<archivosEnviados.size(); i++){
			RevisarArchivos.setCodigoId(archivosEnviados.get(i));
			
			// Asigna la nota 
			String nota = request.getParameter("nota-"+archivosEnviados.get(i)).trim();
			if(nota.equals("")) nota = "0";
			RevisarArchivos.setNota(nota);			
			//System.out.println("Datos:"+i+":"+archivosEnviados.get(i)+":"+cicloGrupoId+":"+cursoId+":"+evaluacionId+":"+actividadId+":"+nota);
			
			// Inserta si no existe y update para actualizar
			if (RevisarArchivos.existeReg(conElias)){
				if(RevisarArchivos.updateReg(conElias)){
					grabo = true;
				}else{
					grabo = false;
				}	
			}else{
				if(RevisarArchivos.insertReg(conElias)){
					grabo = true;
				}else{
					grabo = false;
				}
			}			
		}
	}
	
%>

<div id="content">

	<h2><fmt:message key="aca.ArchivosEnviados"/></h2>
	
	<div class="alert alert-info">
		<fmt:message key="aca.FechaEntrega"/>: <%=fechaEntrega%>	
	</div>
	
	<div class="well">
		<a href="metodo.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>

	<form id="frmTareas" name="frmTareas" action="calificarTareas.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId<%=cursoId%>&evaluacionId=<%=evaluacionId%>&actividadId=<%=actividadId%>&fechaEntrega=<%=fechaEntrega%>" method="post">
	<input name="Accion" type="hidden">
	
	<table class="table table-condensed table-bordered">
		<tr>
			<th><fmt:message key="aca.NombreDelArchivo"/></th>
			<th><fmt:message key="aca.UltimaFechaDeEnvio"/></th>
			<th><fmt:message key="aca.NombreDelAlumno"/></th>
			<th><fmt:message key="aca.Evaluar"/></th>
		</tr>
		
		<%
		String tmpCodigoId = "";
		for(int i=0; i<archivosEnviados.size(); i++){
			
			ArrayList<aca.kardex.KrdxAlumArchivo> archivosEnviadosAlum = ArchivosEnviadosLista.getListEvaluacionAlumno(conElias, archivosEnviados.get(i), cicloGrupoId, cursoId, evaluacionId, actividadId, " ORDER BY CODIGO_ID, FECHA");
			String codigoIdAlum = archivosEnviados.get(i);
			
			String folio 			= "";			
			String nombreArchivo 	= "";
			
			String fechaEnvio 		= "";
			%>
			<tr>			
				<td>
			<%
				for(int j=0; j<archivosEnviadosAlum.size(); j++){
					aca.kardex.KrdxAlumArchivo archivo = archivosEnviadosAlum.get(j);
					
					folio 			= archivo.getFolio();			
					nombreArchivo 	= archivo.getArchivo();
					
					String arrExt [] = nombreArchivo.split("\\.");			
					String ext 				= arrExt[arrExt.length-1];
					
					fechaEnvio 		= archivo.getFecha();
					
					aca.kardex.KrdxAlumArchivo archivoAlum = archivosEnviadosAlum.get(j);
					
				%>
					<a href="../../portal/alumno/descargar.jsp?Ruta=<%=application.getRealPath("/WEB-INF/archivos")+"/"+String.valueOf(session.getAttribute("escuela"))+"/"+codigoIdAlum+"/"+codigoIdAlum+"-"+folio+"."+ext%>&nombreArchivo=<%=codigoIdAlum+"-"+folio+"."+ext%>">
						<i class="icon-download-alt"></i>
						<%=nombreArchivo%>
					</a>
					<br>
				<%
				}%>
				</td>
				<%
				String nota = actividadesPorAlumno.getOrDefault(cicloGrupoId + cursoId + evaluacionId + actividadId + codigoIdAlum, new aca.kardex.KrdxAlumActiv()).getNota();
				%>
		
				<td><%=fechaEnvio%></td>
				<td><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoIdAlum, "NOMBRE")%></td>			
				<td>
					<input type="text" id="nota-<%=codigoIdAlum%>" name="nota-<%=codigoIdAlum%>" size="3" maxlength="3" value="<%=nota%>"/>
				</td>
			</tr>
		<%					
		}
		%>
	</table>

	<div class="well">
		<button class="btn btn-primary btn-large" onclick="javascript:guardar()">
			<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/>
		</button>
	</div>
</form>

<% if (accion.equals("1") && grabo){%>
	<div class="alert alert-info">
		<fmt:message key="aca.Grabado"/>
	</div>
	<meta http-equiv="refresh" content="1;url=metodo.jsp" />
<%}else if(accion.equals("1") && !grabo){%>
	<div class="alert alert-danger">
		<fmt:message key="aca.NoGrabo"/>
	</div>
<%}%>

</div>

<%@ include file= "../../cierra_elias.jsp" %>