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
	String cicloGrupoId 	= (String) request.getParameter("CicloGrupoId");
	String cicloId 			= (String) session.getAttribute("cicloId");	
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	ArrayList<String> lisAlum 	= CursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
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
		<a class="btn btn-primary" href="grupo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
		
	<table class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%" align="center">Orden</th>
				<th width="15%" align="center"><fmt:message key="aca.Matricula" /></th>
				<th width="60%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
			</tr>
		</thead>
		
<%
		int cont = 0;
		for (String codigoAlumno : lisAlum) {
			cont++;				
%>
			<tr>
				<td><%=cont%></td>
				<td><%=codigoAlumno%></td>
<%				
			if (metodo.equals("N")){
%>						
				<td>
					<a href="javascript:notas('<%=cicloGrupoId%>','<%=codigoAlumno%>');"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></a>
				</td>
<%			}else{%>
				<td>
					<a href="javascript:notasMetodo('<%=cicloGrupoId%>','<%=codigoAlumno%>');"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></a>
				</td>				
<%			}%>		
				<td>
					<a href="javascript:boletaAlumno('<%=cicloGrupoId%>','<%=codigoAlumno%>');">Boleta</a>
				</td>			
			</tr>			
<%			  	
		} //fin de for
%>
	</table>

</div>

<%@ include file="../../cierra_elias.jsp"%>
