<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexFaltaLista" scope="page" class="aca.kardex.KrdxAlumFaltaLista" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista" />
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />


<script>
	function cambiaBloque() {
		document.forma.submit();
	}
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoId");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String cicloGrupoId 	= (String) request.getParameter("CicloGrupoId");
	String bloque 			= request.getParameter("bloque") == null ? "1": request.getParameter("bloque");

	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);

	ArrayList<String> lisAlum 							= CursoActLista.getListAlumnosGrupo(conElias,cicloGrupoId);
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso 	= GrupoCursoLista.getListMateriasGrupo(conElias, cicloGrupoId,"ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	ArrayList<aca.ciclo.CicloBloque> listBloques 		= ciclo.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");

	// TreeMap para verificar si el alumno lleva la materia
	java.util.TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso 	= kardexLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");

	// TreeMap para obtener la nota de un alumno en la materia
	java.util.TreeMap<String,aca.kardex.KrdxAlumFalta> treeFalta 		= kardexFaltaLista.getTreeFalta(conElias,cicloGrupoId, "");
%>

<div id="content">
	<h2>
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%>
		|
		<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> "<%=Grupo.getGrupo()%>"
	</h2>
	
	<div class="alert alert-info">
		<%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> <br>
		<fmt:message key="maestros.ConsejeroDeGrupo" />: <%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%>
	</div>
	
	<form name="forma" action="evaluaciones.jsp?CicloGrupoId=<%=cicloGrupoId%>" method="post">
	
		<div class="well">
			<a href="grupo.jsp" class="btn btn-primary btn-mobile">
				<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
			</a>
	
			<select name="bloque" id="bloque" onchange='javascript:cambiaBloque()'>
			<%
				for (aca.ciclo.CicloBloque bloq : listBloques) {
			%>
					<option value="<%=bloq.getBloqueId() %>" <%if(bloq.getBloqueId().equals(bloque)){out.print("selected");} %>><%=bloq.getBloqueNombre() %></option>	
			<%
				}
			%>
			</select> 
		</div>

		
		<table class="table table-bordered table-condensed table-nohover">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Matricula" /></th>
				<th><fmt:message key="aca.NombreDelAlumno" /></th>
				<%
					for (int j = 0; j < lisGrupoCurso.size(); j++) {
				%>
						<th class="text-center" style="width:3%;" ><%=j + 1%></th>
				<%
					}
				%>
				<th class="text-center alert"><fmt:message key="aca.Total" /></th>
			</tr>
			<%
				// Arreglos para calcular el promedio de la materia
				int[] promedio = new int[30];

				// Inicializa los arreglos
				for (int i = 0; i < promedio.length; i++) {
					promedio[i] = 0;
				}


				for (int i = 0; i < lisAlum.size(); i++) {
					String codigoAlumno = (String) lisAlum.get(i);
					int promedioAlumno = 0;
			%>
					<tr>
						<td class="text-center"><%=i + 1%></td>
						<td class="text-center"><%=codigoAlumno%></td>
						<td><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></td>
						<%
							for (int j = 0; j < lisGrupoCurso.size(); j++) {
								aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);
								
								String punto = aca.plan.PlanCurso.getPunto(conElias,grupoCurso.getCursoId());
								String falta = "0";
								// Verifica si el alumno tiene dada de alta la materia
								if (treeAlumCurso.containsKey(cicloGrupoId + grupoCurso.getCursoId() + codigoAlumno)) {
									if (treeFalta.containsKey(cicloGrupoId + grupoCurso.getCursoId() + bloque + codigoAlumno)) {
										falta = treeFalta.get(cicloGrupoId + grupoCurso.getCursoId() + bloque + codigoAlumno).getFalta();

										int faltaNum = Integer.parseInt(falta);
										if (faltaNum > 0) {
											promedio[j] = promedio[j] + faltaNum;
											promedioAlumno = promedioAlumno + (int) faltaNum;
										}

									} else {
										falta = "-";
									}
								} else {
									falta = "X";
								}
						%>
								<td class="text-center"><%=falta%></td>
						<%
							}
						%>
						<td class="text-center alert"><%=promedioAlumno%></td>
					</tr>
			<%
					promedioAlumno = 0;
				} //fin de for
			%>
			<tr>
				<th class="alert" colspan="3"><fmt:message key="aca.Total" /></th>
				<%
					for (int j = 0; j < lisGrupoCurso.size(); j++) {
						int total = promedio[j];
				%>
						<th class="alert text-center"><%=total%></th>
				<%
					}
				%>
				<th class="alert"></th>
			</tr>
		</table>
		
		<table class="table table-condensed table-bordered table-striped">
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Materias" /></th>
					<th><fmt:message key="aca.Maestro" /></th>
					<th><fmt:message key="aca.Evaluaciones" /></th>
				</tr>
			</thead>
			<%
				for (int j = 0; j < lisGrupoCurso.size(); j++) {
					aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);

					ArrayList<aca.ciclo.CicloGrupoEval> listEstrategias = GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");
			%>
					<tr>
						<td><%=j + 1%></td>
						<td><%=aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId())%></td>
						<td><%=grupoCurso.getEmpleadoId()%> | <%=aca.empleado.EmpPersonal.getNombre(conElias, grupoCurso.getEmpleadoId(), "NOMBRE")%></td>
						<td><%=listEstrategias.size()%></td>
					</tr>
			<%
				}
			%>
		</table>
		
	</form>
	
</div>

<%@ include file="../../cierra_elias.jsp"%>
