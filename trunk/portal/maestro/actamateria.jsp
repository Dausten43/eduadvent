<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.util.Fecha"%>
<%@page import="aca.empleado.EmpPersonal"%>
<%@page import="aca.ciclo.CicloGrupoEval"%>
<%@page import="java.text.*"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
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
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista" />
<%
	DecimalFormat frmDecimal = new DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	DecimalFormat frmEntero = new DecimalFormat("###,##0;(###,##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoId");
	String escuelaNom 		= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
	String cicloId 			= (String) session.getAttribute("cicloId");

	String cicloGrupoId = request.getParameter("CicloGrupoId");
	String cursoId = request.getParameter("Curso");

	double[] prom = new double[10];
	double promTmp = 0;
	double promGral = 0;

	Escuela.mapeaRegId(conElias, escuelaId);
	empPersonal.mapeaRegId(conElias, codigoId);
	cicloGrupo.mapeaRegId(conElias, cicloGrupoId);
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);

	String estadoNombre = aca.catalogo.CatEstado.getEstado(conElias, Escuela.getPaisId(), Escuela.getEstadoId());
	String ciudadNombre = aca.catalogo.CatCiudad.getCiudad(conElias, Escuela.getPaisId(), Escuela.getEstadoId(), Escuela.getCiudadId());
	String notaAC = aca.plan.PlanCurso.getNotaAC(conElias, cursoId);

	ArrayList<aca.ciclo.CicloBloque> listBloques = ciclo.getListCiclo(conElias, cicloId,"ORDER BY BLOQUE_ID");

	// TreeMap para verificar si el alumno lleva la materia
	TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso = krdxCursoActLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");

	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexLista.getTreeMateria(conElias, cicloGrupoId, "");
	
	java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
	String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
%>

<link rel="stylesheet" href="../../css/print.css" media="print">

<div id="content">	
	
		<table class="table table-condensed table-bordered">
			<tr>
				<td colspan="2" width="50%"> <h5> <fmt:message key="aca.DocOficialParaEvaluaciones"/> </h5> </td>
				<td width="50%" style="text-align: right;"> <h5> N°: <%=cicloGrupo.getCicloGrupoId()%> </h5> </td>
			</tr>
			<tr>
				<td colspan="2"><%= escuelaNom %></td>
				<td rowspan="6" style="text-align: center;">
					<b><fmt:message key="aca.Observaciones"/>:</b>
					<fmt:message key="aca.NotaMinimaAprobatoria"/> <%=notaAC%>.<br> 
					<%=ciudadNombre%>, <%=estadoNombre%>
					. <fmt:message key="aca.ALaFecha"/> <%=fecha.getFechaTexto(aca.util.Fecha.getHoy())%>
					<br> <br> _______________________________________<br>
					<b><fmt:message key="aca.SecretarioAcademico"/></b>
					<br> <br> _______________________________________<br> 
					<b><fmt:message key="aca.Profesor"/>:</b>
					<%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%>
					
				</td>
			</tr>
			<tr>
				<td colspan="2"><%=aca.plan.Plan.getNombrePlan(conElias, cicloGrupo.getPlanId())%></td>
			</tr>
			<tr>
				<td><div><fmt:message key="aca.Materia"/>:</div></td>
				<td><%=PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId())%></td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Grado"/>:</td>
				<td><%=cicloGrupo.getGrado()%>º</td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Grupo"/>:</td>
				<td><%=cicloGrupo.getGrupo()%></td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Profesor"/>:</td>
				<td><%=empPersonal.getNombre()%>&nbsp;<%=empPersonal.getApaterno()%>&nbsp;<%=empPersonal.getAmaterno()%></td>
			</tr>
		</table>
				
				
		<table class="table table-condensed table-bordered">
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<%
					ArrayList<aca.ciclo.CicloGrupoEval> lisEval = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
						for (int i = 0; i < lisEval.size(); i++) {
							cicloGrupoEval = (CicloGrupoEval) lisEval.get(i);
				%>
				<td style="text-align: center;">
					<%
						if (cicloGrupoEval.getEstado().equals("C")) {
					%> 
						<i class="icon-ok"></i>
					<%
						} else {
					%> 
						<i class="icon-folder-open"></i>
					<%
						}
					%>
				</td>
				<%
					}
				%>
			</tr>
			<tr>
				<th style="text-align:center;">#</th>
				<th style="text-align:center;"><fmt:message key="aca.Codigo"/></th>
				<th><fmt:message key="aca.NombreDelAlumno"/></th>
				<%
					for (int i = 0; i < lisEval.size(); i++) {
						cicloGrupoEval = (CicloGrupoEval) lisEval.get(i);
				%>
						<th style="text-align:center;" title="<%=cicloGrupoEval.getEvaluacionNombre()%>"><%=cicloGrupoEval.getEvaluacionId()%></th>
				<%
					}
				%>
				
				<th style="text-align:center;"><fmt:message key="aca.Promedio"/></th>
				
			</tr>
			<%
				ArrayList<String> lisAlumnos 				= krdxCursoActLista.getListAlumnosGrupo(conElias, cicloGrupoId);
				ArrayList<aca.kardex.KrdxAlumEval> lisNotas = kardexLista.getListAll(conElias,
																							"WHERE CICLO_GRUPO_ID = '"
																									+ cicloGrupoId
																									+ "' AND CURSO_ID = '"
																									+ cursoId
																									+ "' ORDER BY ALUM_APELLIDO(CODIGO_ID), EVALUACION_ID");
				
				
				for (int i = 0; i < lisAlumnos.size(); i++) {
					String codigoAlumno = (String) lisAlumnos.get(i);
					
					double promedio = 0.0;
					if (treeProm.containsKey(cicloGrupoId + cursoId + codigoAlumno)) {
						aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId + cursoId + codigoAlumno);
						promedio = Double.parseDouble(alumProm.getPromedio()) + Double.parseDouble(alumProm.getPuntosAjuste());
					} else {
						System.out.println("No encontro el promedio de:" + codigoAlumno);
					}
			%>
			<tr>
				<td style="text-align: center;"><%=i + 1%></td>
				<td style="text-align: center;"><%=codigoAlumno%></td>
				<td><%=AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></td>
				<%
					for (int j = 0; j < listBloques.size(); j++) {
								aca.ciclo.CicloBloque bloq = (aca.ciclo.CicloBloque) listBloques.get(j);
	
								String punto = aca.plan.PlanCurso.getPunto(conElias, cursoId);
								String strNota = "0";
								// Verifica si el alumno tiene dada de alta la materia
								if (treeAlumCurso.containsKey(cicloGrupoId + cursoId + codigoAlumno)) {
									if (treeNota.containsKey(cicloGrupoId + cursoId + bloq.getBloqueId() + codigoAlumno)) {
										aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + cursoId + bloq.getBloqueId() + codigoAlumno);
										if (punto.equals("S")) {
											strNota = frmDecimal.format(Double.parseDouble(krdxEval.getNota()));
										} else {
											strNota = frmEntero.format(Double.parseDouble(krdxEval.getNota()));
										}
										if (strNota.equals("") || strNota.equals(null))
											strNota = "0";
	
									} else {
										strNota = "-";
									}
								} else {
									strNota = "X";
								}
				%>
				<td style="text-align: center;"><%=strNota%></td>
				<%
					}
				String strPromedio = "-";
				if (promedio > 0) {
					if (evaluaConPunto.equals("S")) {
						strPromedio = frmDecimal.format(promedio).replaceAll(",", ".");
					} else {
						strPromedio = frmEntero.format(promedio).replaceAll(",", ".");
					}
				}
				
				%>
				<td style="text-align: center;"><%=strPromedio%></td>
				<%
				}
				%>
			
			
			<tr>
				<td colspan="30" style="text-align: center;">
					<i class="icon-ok"></i> <fmt:message key="aca.Cerrado"/>&nbsp;&nbsp; 
					<i class="icon-folder-open"></i> <fmt:message key="aca.Abierto"/>
				</td>
			</tr>
		</table>
						

</div>

<%@ include file="../../cierra_elias.jsp"%>