<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>

<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String cicloGrupoId	 	= request.getParameter("CicloGrupoId");
	String cursoId 			= request.getParameter("CursoId");
	String planId 			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String cursoNombre 		= aca.plan.PlanCurso.getCursoNombre(conElias, cursoId);

	//Lista de alumnos
	ArrayList<aca.kardex.KrdxCursoAct> lisKardex = kardexLista.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");

%>

<div id="content">
	
	<br />
		
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<th colspan="3">
					<h2><%=cursoNombre %></h2>
					<h4>
						<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%>
					</h4>
					<small><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></small>
				</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
			</tr>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Codigo" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
			</tr>
		</thead>
		<tbody>
	<%
		int cont = 0;
		for(aca.kardex.KrdxCursoAct alumno: lisKardex){
			if(alumno.getTipoCalId().equals("6")){/* Ignorar alumnos dados de baja */
				continue;
			}
			
			cont++;
	%>
			<tr>
				<td><%=cont %></td>
				<td><%=alumno.getCodigoId() %></td>
				<td><%=aca.alumno.AlumPersonal.getNombre(conElias, alumno.getCodigoId(), "NOMBRE") %></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
	<%
		}
	%>
		</tbody>
	</table>

</div>



<%@ include file="../../cierra_elias.jsp"%>