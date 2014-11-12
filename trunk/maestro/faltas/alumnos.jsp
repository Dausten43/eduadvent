<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />

<script>
	function faltas(cicloGrupoId, codigoAlumno) {
		document.location.href = "faltas.jsp?CicloGrupoId=" + cicloGrupoId + "&CodigoAlumno=" + codigoAlumno;
	}
</script>

<%
	String codigoId 		= (String) session.getAttribute("codigoId");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String cicloGrupoId 	= (String) request.getParameter("CicloGrupoId");
	
	ArrayList<String> lisAlum = CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);

	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
%>

<div id="content">
	<h2>
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%>
		|
		<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> "<%=Grupo.getGrupo()%>"
	</h2>
	
	<div class="alert alert-info">
		<%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> <br>
		<fmt:message key="aca.Maestro" />: <%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%>
	</div>
	
	<div class="well" style="overflow: hidden;">
		<a class="btn btn-primary" href="grupo.jsp">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>

	
	<table class="table table-condensed table-striped table-striped table-bordered">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Matricula" /></th>
				<th><fmt:message key="aca.NombreDelAlumno" /></th>
				<th class="text-center"><fmt:message key="aca.Faltas" /></th>
			</tr>
		</thead>
		<%
			for (int i = 0; i < lisAlum.size(); i++) {
				String codigoAlumno = (String) lisAlum.get(i);
		%>
				<tr>
					<td><%=i + 1%></td>
					<td><%=codigoAlumno%></td>
					<td>
						<a href="javascript:faltas('<%=cicloGrupoId%>','<%=codigoAlumno%>');">
							<%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%>
						</a>
					</td>
					<td class="text-center">
						<%=aca.kardex.KrdxAlumFalta.totalfaltas(conElias, codigoAlumno, cicloGrupoId) == null ? "0": aca.kardex.KrdxAlumFalta.totalfaltas(conElias,codigoAlumno, cicloGrupoId)%>
					</td>
				</tr>
		<%
			} //fin de for
		%>
	</table>
	
</div>

<%@ include file="../../cierra_elias.jsp"%>
