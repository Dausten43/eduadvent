<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>

<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval" />
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxAlumEval" />
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="krdxCursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="fecha" scope="page" class="aca.util.Fecha" />
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista" />


<%
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("###,##0.0;(###,##0.0)");
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("###,##0;(###,##0)");

	String escuelaId 		= (String) session.getAttribute("escuela");
	String escuelaNom 		= (String) session.getAttribute("escuelaNombre");
	String cicloId 			= (String) session.getAttribute("cicloId");

	String cicloGrupoId 	= request.getParameter("CicloGrupoId");
	String cursoId 			= request.getParameter("CursoId");

	double[] prom = new double[10];
	double promTmp = 0;
	double promGral = 0;

	Escuela.mapeaRegId(conElias, escuelaId);
	cicloGrupo.mapeaRegId(conElias, cicloGrupoId);
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	String nivelId 			= aca.plan.Plan.getNivel(conElias,cicloGrupo.getPlanId());

	String estadoNombre = aca.catalogo.CatEstado.getEstado(conElias, Escuela.getPaisId(), Escuela.getEstadoId());
	String ciudadNombre = aca.catalogo.CatCiudad.getCiudad(conElias, Escuela.getPaisId(), Escuela.getEstadoId(), Escuela.getCiudadId());
	String notaAC = aca.plan.PlanCurso.getNotaAC(conElias, cursoId);
	
	// Array para la lista de evaluaciones
	ArrayList<aca.ciclo.CicloBloque> listBloques = ciclo.getListCiclo(conElias, cicloId,"ORDER BY BLOQUE_ID");
	
	// Map para el numero de actividades por evaluacion
	java.util.HashMap<String, String> mapActividades = aca.ciclo.CicloGrupoActividadLista.getMapActividadesPorEvaluacion(conElias, cicloGrupoId, cursoId);
	
	// Map promedio de actividades por evaluacion
	java.util.HashMap<String, String> mapNotaActividades = aca.ciclo.CicloGrupoActividadLista.getMapNotaActividad(conElias, cicloGrupoId, cursoId);

	// TreeMap para verificar si el alumno lleva la materia
	java.util.TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso = krdxCursoActLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");

	// TreeMap para obtener la nota de un alumno en la materia
	java.util.TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexLista.getTreeMateria(conElias, cicloGrupoId, "");
	
%>

<link rel="stylesheet" href="../../css/print.css" media="print">

<div id="content">	
	
	<h3>Acta de rendimiento</h3>
	
	<table class="table table-condensed table-bordered">
		<tr>
			<td colspan="2"><%=aca.plan.Plan.getNombrePlan(conElias, cicloGrupo.getPlanId())%></td>
		</tr>
		<tr>
			<td><div><fmt:message key="aca.Nivel"/>:</div></td>
			<td><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId) %></td>
		</tr>
		<tr>
			<td><div><fmt:message key="aca.Materia"/>:</div></td>
			<td><%=aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId())%></td>
		</tr>
		<tr>
			<td><fmt:message key="aca.Grado"/>:</td>
			<td><%=cicloGrupo.getGrado()%>º</td>
		</tr>
		<tr>
			<td><fmt:message key="aca.Grupo"/>:</td>
			<td><%=cicloGrupo.getGrupo()%></td>
		</tr>
	</table>	
	
			
	<table class="table table-condensed table-bordered">
		<thead>
			<tr>
				<th rowspan="2" style="text-align:center;">#</th>
				<th rowspan="2" style="text-align:center;"><fmt:message key="aca.Codigo"/></th>
				<th rowspan="2" style="border-right: 1px solid #BDBDBD;"><fmt:message key="aca.NombreDelAlumno"/></th>
				<%for (aca.ciclo.CicloBloque bloq : listBloques) { %>
					<%
						/* === ACTIVIDADES === */
						int size = 0;
						if( mapActividades.containsKey(bloq.getBloqueId()) ){
							size = mapActividades.get(bloq.getBloqueId()).split("@").length;
						}
					%>
					<th colspan="<%=size+1 %>" style="text-align: center; border-right: 1px solid #BDBDBD;"><%=bloq.getBloqueNombre() %></th>
				<%}%>
			</tr>
			<tr>
				<%for (aca.ciclo.CicloBloque bloq : listBloques) { %>
					<%
						/* === ACTIVIDADES === */
						String [] arr = {};
						if(mapActividades.containsKey(bloq.getBloqueId())){
							arr = mapActividades.get(bloq.getBloqueId()).split("@");
						}
						
						for(String actividadId : arr){
					%>
							<th style="text-align: center;"><%=actividadId %></th>
					<%					
						}
					%>
						<th style="text-align: center; border-right: 1px solid #BDBDBD;">Prom</th>
				<%}%>
			</tr>
		</thead>
		<%
			ArrayList<String> lisAlumnos 				= krdxCursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);

			int cont = 0;
			for (String codigoAlumno : lisAlumnos) {
				cont++;
		%>
		<tr>
			<td style="text-align: center;"><%=cont%></td>
			<td style="text-align: center;"><%=codigoAlumno%></td>
			<td style="border-right: 1px solid #BDBDBD;"><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></td>
		<%
				for (aca.ciclo.CicloBloque bloq : listBloques) {

					String strNotaEvaluacion = "0";
					// Verifica si el alumno tiene dada de alta la materia
					if (treeAlumCurso.containsKey(cicloGrupoId + cursoId + codigoAlumno)) {
						if (treeNota.containsKey(cicloGrupoId + cursoId + bloq.getBloqueId() + codigoAlumno)) {
							aca.kardex.KrdxAlumEval krdxEval = treeNota.get(cicloGrupoId + cursoId + bloq.getBloqueId() + codigoAlumno);
							if (aca.plan.PlanCurso.getPunto(conElias, cursoId).equals("S")) {
								strNotaEvaluacion = frmDecimal.format(Double.parseDouble(krdxEval.getNota()));
							} else {
								strNotaEvaluacion = frmEntero.format(Double.parseDouble(krdxEval.getNota()));
							}
							if (strNotaEvaluacion.equals("") || strNotaEvaluacion.equals(null)){
								strNotaEvaluacion = "0";	
							}
						} else {
							strNotaEvaluacion = "-";
						}
					} else {
						strNotaEvaluacion = "X";
					}
					
					/* === ACTIVIDADES === */
					String [] arr = {};
					if(mapActividades.containsKey(bloq.getBloqueId())){
						arr = mapActividades.get(bloq.getBloqueId()).split("@");
					}
					
					for(String actividadId : arr){
						String notaAct = "-";
						if( mapNotaActividades.containsKey(codigoAlumno+"@"+bloq.getBloqueId()+"@"+(actividadId) ) ){
							notaAct = mapNotaActividades.get(codigoAlumno+"@"+bloq.getBloqueId()+"@"+(actividadId) );
						}
		%>
						<td style="text-align:center;"><%=notaAct %></td>
		<%					
					}
		%>
					<td style="text-align: center; border-right: 1px solid #BDBDBD;"><%=strNotaEvaluacion%></td>
		<%
				}
			}
		%>
	</table>
						

</div>

<%@ include file="../../cierra_elias.jsp"%>