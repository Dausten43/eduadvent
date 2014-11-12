<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>

<%@ page import="java.text.*"%>
<%@page import="java.util.TreeMap"%>

<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.util.Fecha"%>
<%@page import="aca.empleado.EmpPersonal"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexEval" scope="page" class="aca.kardex.KrdxAlumEval" />
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista" />


<link rel="stylesheet" href="../../css/print.css" media="print">

<style>
	.table th{
		font-size: 10px;
	}
	.table td{
		font-size: 12px;
	}
</style>

<%
	DecimalFormat frmDecimal = new DecimalFormat("###,##0.0;(###,##0.0)");
	DecimalFormat frmDecimal2 = new DecimalFormat("###,##0.00;(###,##0.00)");
	DecimalFormat frmEntero = new DecimalFormat("###,##0;(###,##0)");

	String codigoId = (String) session.getAttribute("codigoEmpleado");
	String evaluacion = request.getParameter("Evaluacion");
	String cicloId = request.getParameter("Ciclo");
	double promGral = 0;

	empPersonal.mapeaRegId(conElias, codigoId);
	Grupo.mapeaRegId(conElias, codigoId, cicloId);

	ArrayList<aca.ciclo.CicloGrupoCurso> lisMaterias = cicloGrupoCursoLista.getListMateriasGrupo(conElias, cicloId, Grupo.getNivelId(), Grupo.getGrado(), Grupo.getGrupo(), "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	ArrayList<String> lisAlumnos = kardexLista.getListAlumnosGrupo(conElias, Grupo.getCicloGrupoId());

	// TreeMap para verificar si el alumno lleva la materia
	TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso = kardexLista.getTreeAlumnoCurso(conElias, Grupo.getCicloGrupoId(), "");

	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexEvalLista.getTreeMateria(conElias, Grupo.getCicloGrupoId(), "");
%>

<div id="content">	
	
		<table class="table table-condensed table-bordered">
			<tr>
				<td colspan="3" width="50%"> <h5> <fmt:message key="aca.Evaluacionn"/> # <%=evaluacion%> </h5> </td>
			</tr>
			<tr>
				<td colspan="2"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%></td>
				<td rowspan="6" style="text-align: center;">
					<br> <br> _______________________________________<br>
					<b><fmt:message key="aca.SecretarioAcademico"/></b>
					<br> <br> _______________________________________<br> 
					<b><fmt:message key="aca.Profesor"/>:</b>
					<%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%>
					
				</td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Grado"/>: </td>
				<td><%=Grupo.getGrado()%>º</td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Grupo"/>: </td>
				<td><%=Grupo.getGrupo()%></td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Profesor"/>:</td>
				<td><%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%></td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Fecha"/>:</td>
				<td><%=Fecha.getHoy()%></td>
			</tr>
		</table>

		
		<table class="table table-condensed table-bordered">
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Alumno"/></th>
					<%
						for (int i = 0; i < lisMaterias.size(); i++) {
								aca.ciclo.CicloGrupoCurso grupoCurso = (CicloGrupoCurso) lisMaterias.get(i);
								String estado = aca.ciclo.CicloGrupoEval.getEstado(conElias, Grupo.getCicloGrupoId(), grupoCurso.getCursoId(), Integer.parseInt(evaluacion));
								
								String borde = estado.equals("C") ? "none" : "border-top:1px solid red;border-bottom:1px solid red;";
					%>
							<th style="text-align:center;<%=borde %>" title="<%=grupoCurso.getEmpleadoId()%>()" >
								<%=PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId())%>
							</th>
					<%
						}
					%>
					<th style="text-align:center;"><fmt:message key="aca.Prom"/></th>
				</tr>
			</thead>
			<%
				// Arreglos para calcular el promedio de la materia		
					double[] promedio = new double[30];
					int[] numAlum = new int[30];

					// Inicializa los arreglos
					for (int i = 0; i < 30; i++) {
						promedio[i] = 0;
						numAlum[i] = 0;
					}

					for (int i = 0; i < lisAlumnos.size(); i++) {
						String matricula = (String) lisAlumnos.get(i);

						// Calcula el promedio del alumno
						double promAlum = 0;
						int numMaterias = 0;
			%>
			<tr>
				<td><%=i + 1%></td>
				<td><%=AlumPersonal.getNombre(conElias, matricula, "APELLIDO")%></td>
				<%
					for (int j = 0; j < lisMaterias.size(); j++) {
								aca.ciclo.CicloGrupoCurso grupoCurso = (CicloGrupoCurso) lisMaterias.get(j);

								String punto = aca.plan.PlanCurso.getPunto(conElias, grupoCurso.getCursoId());
								String strNota = "0";

								if (treeAlumCurso.containsKey(Grupo.getCicloGrupoId() + grupoCurso.getCursoId() + matricula)) {
									if (treeNota.containsKey(Grupo.getCicloGrupoId() + grupoCurso.getCursoId() + evaluacion + matricula)) {
										aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(Grupo.getCicloGrupoId() + grupoCurso.getCursoId() + evaluacion + matricula);
										if (punto.equals("S")) {
											strNota = frmDecimal.format(Double.parseDouble(krdxEval.getNota()));
										} else {
											strNota = frmEntero.format(Double.parseDouble(krdxEval.getNota()));
										}
										if (strNota.equals("") || strNota.equals(null))
											strNota = "0";

										if (Double.parseDouble(krdxEval.getNota()) > 0) {
											promedio[j] = promedio[j] + Double.parseDouble(krdxEval.getNota());
											numAlum[j] = numAlum[j] + 1;
										}

										// Calcula el promedio del alumno
										promAlum += Double.parseDouble(krdxEval.getNota());
										numMaterias++;

									} else {
										strNota = "-";
									}
								} else {
									strNota = "X";
								}
				%>
				<td style="text-align:center;"><%=strNota%></td>
				<%
					}
							promAlum = promAlum / numMaterias;
				%>
				<td style="text-align:center;"><%=frmDecimal.format(promAlum)%></td>
			</tr>
			<%
				}
			%>
			<tr>
				<th colspan="2" ><fmt:message key="aca.Promedio"/></th>
				<%
					for (int j = 0; j < lisMaterias.size(); j++) {
							double prom = promedio[j] / numAlum[j];
							promGral += prom;
				%>
				<th style="text-align:center;"><%=frmDecimal2.format(prom)%></th>
				<%
					}
						promGral = promGral / lisMaterias.size();
				%>
				<th style="text-align:center;"><%=frmDecimal2.format(promGral)%></th>
		</table>
						
	
</div>
	
<%@ include file="../../cierra_elias.jsp"%>