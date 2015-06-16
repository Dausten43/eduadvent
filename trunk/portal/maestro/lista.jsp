<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />

<script>
	function notas(cicloGrupoId, codigoAlumno) {
		document.location.href = "notas.jsp?CicloGrupoId=" + cicloGrupoId+ "&CodigoAlumno=" + codigoAlumno + "&EvaluacionId=0";
	}	
</script>

<%
	String cicloId 			= (String) session.getAttribute("cicloId");
	String cicloGrupoId 	= (String) request.getParameter("CicloGrupoId");
	String cursoId 			= (String) request.getParameter("CursoId");	
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	ArrayList<aca.kardex.KrdxCursoAct> lisAlum 	= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId, cursoId, " ORDER BY ORDEN");
%>

<div id="content">
	<h2><fmt:message key="aca.Alumnos" /></h2>
	
	<div class="alert alert-info">
		<h4>
			<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%> |
			<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> <%=Grupo.getGrupo()%>
		</h4> 
		<strong><fmt:message key="aca.Maestro" />:</strong> <%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%>
	</div>
	
	<div class="well"> 
		<a class="btn btn-primary" href="cursos.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
		
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%" align="center"><fmt:message key="aca.Orden" /></th>				
				<th width="15%" align="center"><fmt:message key="aca.Matricula" /></th>
				<th width="50%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
				<th width="10%" align="center"><fmt:message key="aca.Orden" /></th>
			</tr>
		</thead>
		
<%
		int cont = 0;
		for (aca.kardex.KrdxCursoAct kca : lisAlum){
			cont++;
%>
		<tr>
			<td><%=cont%></td>
			<td><%=kca.getCodigoId()%></td>					
			<td>
				<%=aca.alumno.AlumPersonal.getNombre(conElias, kca.getCodigoId(), "APELLIDO")%>
			</td>
			<td><%=kca.getOrden()%></td>
		</tr>			
<%			  	
		} //fin de for
%>
	</table>
</div>
<%@ include file="../../cierra_elias.jsp"%>
