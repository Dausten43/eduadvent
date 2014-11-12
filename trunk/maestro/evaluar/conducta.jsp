<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="cicloGrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="krdxAlumConductaL" scope="page" class="aca.kardex.KrdxAlumConductaLista"/>
<%
	//FORMATOS ---------------------------->
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0");

	String escuelaId 	= (String) session.getAttribute("escuela");
	String cursoId 		= request.getParameter("CursoId");
	String cicloGrupoId	= request.getParameter("CicloGrupoId");
	String evaluacionId = request.getParameter("EvaluacionId");
	
	String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
	
	ArrayList<aca.kardex.KrdxCursoAct> lisAlumnos		= krdxCursoActL.getListAll(conElias, escuelaId, "AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID = '"+cursoId+"' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	ArrayList<aca.ciclo.CicloGrupoCurso> lisMaterias 	= cicloGrupoCursoL.getListMateriasGrupo(conElias, cicloGrupoId, "AND CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CONDUCTA = 'S') ORDER BY CURSO_NOMBRE(CURSO_ID)");
	ArrayList<aca.kardex.KrdxAlumConducta> lisEvals		= krdxAlumConductaL.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND EVALUACION_ID = "+evaluacionId);
		
%>


<div id="content">
	
	<h2><fmt:message key="aca.ReporteConducta"/> <small><fmt:message key="aca.Evaluacionn"/> <%=evaluacionId %></small></h2>
	
	<div class="alert alert-info">
		<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId) %> | <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %>
	</div>
	
	<div class="well">
		<a href="evaluar.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>
	
	<table class="table table-condensed table-bordered ">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Codigo"/></th>
			<th><fmt:message key="aca.NombreDelAlumno"/></th>
			<%
				int cont = 0;
				for(aca.ciclo.CicloGrupoCurso cicloGrupoCurso : lisMaterias){
					cont++;
			%>
					<th class="text-center" style="width:3%;">
						<a href="" title="<%=aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId()) %>">
							<%=cont %>
						</a>
					</th>
			<%
				}
			%>
			<th class="text-center"><fmt:message key="aca.Promedio"/></th>
		</tr>
		<%
			cont = 0;	
			for(aca.kardex.KrdxCursoAct krdxCursoAct : lisAlumnos){	
		%>
				<tr>
					<td><%=cont %></td>
					<td><%=krdxCursoAct.getCodigoId() %></td>
					<td><%=aca.alumno.AlumPersonal.getNombre(conElias, krdxCursoAct.getCodigoId(), "APELLIDO") %></td>
		<%
				int suma = 0;
				int numMaterias = 0;
				cont = 0;
				for(aca.ciclo.CicloGrupoCurso cicloGrupoCurso: lisMaterias){
					cont++;
					String conducta = "-";
					
					for(aca.kardex.KrdxAlumConducta krdxAlumConducta: lisEvals){
						if(cicloGrupoCurso.getCursoId().equals(krdxAlumConducta.getCursoId()) && krdxCursoAct.getCodigoId().equals(krdxAlumConducta.getCodigoId())){
							if(Float.parseFloat(krdxAlumConducta.getConducta()) > 0){
								suma += Float.parseFloat(krdxAlumConducta.getConducta());
								numMaterias++;
								
								if (evaluaConPunto.equals("S")) {
									conducta = frmDecimal.format(Double.parseDouble(krdxAlumConducta.getConducta())).replaceAll(",", ".");
								} else {
									conducta = frmEntero.format(Double.parseDouble(krdxAlumConducta.getConducta())).replaceAll(",", ".");
								}
							}
						}
					}
		%>
					<td class="text-center"><%=conducta %></td>
		<%						
					
				}
				
				String total = "-";
				if (evaluaConPunto.equals("S")) {
					total = frmDecimal.format(suma/((float)numMaterias)).replaceAll(",", ".");
				} else {
					total = frmEntero.format(suma/((float)numMaterias)).replaceAll(",", ".");
				}
		%>
					<td class="text-center"><%=total %></td>
				</tr>
		<%
					cont++;
				}
		%>
	</table>
	
	<h3><fmt:message key="aca.Materias"/></h3>
	
	<table class="table table-condensed">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Materia" /></th>
			<th><fmt:message key="aca.Maestro" /></th>
		</tr>
		<%
			cont = 0;
			for(aca.ciclo.CicloGrupoCurso cicloGrupoCurso: lisMaterias){
				cont++;
		%>
				<tr>
					<td><%=cont %></td>
					<td><%=aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId()) %></td>
					<td><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(), "NOMBRE") %></td>
				</tr>
		<%
			}
		%>
	</table>
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>