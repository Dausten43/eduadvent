<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ page import="java.text.*"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="kardexLista" scope="page"	class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexEvalLista" scope="page"	class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista" />
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<head>
<style>
	.smaller{
		font-size: 8px;
	} 
	.small{
		font-size: 10px;
	}
	.medium{
		font-size: 12px;
	}
</style>
<script language="javascript">
	function cambiaBloque() {
		document.forma.submit();
	}
</script>
</head>
<%
	//Define los colores a usar en cada columna
		String[] colores = { "#FF8080", "#93C9FF", "#04C68B",
				"#FF8040", "#FFCAE4", "#BE7C7C", "#00AA55", "#C5AF65",
				"#0080FF", "#FFC891", "#C5EBDE", "#C4FCFF", "#B9C4B5",
				"#9EA2C5", "#E9ED3F", "#DF01D7", "#01DFD7", "#7D64B1",
				"#ABE17F", "#D52D0C", "#48B0F1" };

		DecimalFormat frmDecimal 	= new DecimalFormat("###,##0.0;(###,##0.0)");
		DecimalFormat frmDecimal2 	= new DecimalFormat("###,##0.0;(###,##0.0)");
		DecimalFormat frmEntero 	= new DecimalFormat("###,##0;(###,##0)");
		
		frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
		frmDecimal2.setRoundingMode(java.math.RoundingMode.DOWN);

		String escuelaId 			= (String) session.getAttribute("escuela");
		String codigoId 			= (String) session.getAttribute("codigoId");
		String cicloId 				= (String) session.getAttribute("cicloId");
		String cicloGrupoId 		= (String) request.getParameter("CicloGrupoId");
		String bloque 				= request.getParameter("bloque") == null ? "1":request.getParameter("bloque");

		String codigoAlumno 		= "";
		String strBgcolor 			= "";
		double promGral 			= 0;
		int i = 0;

		Grupo.setCicloGrupoId(cicloGrupoId);
		Grupo.mapeaRegId(conElias, cicloGrupoId);

		ArrayList lisAlum = kardexLista.getListAlumnosGrupo(conElias, cicloGrupoId);
		ArrayList lisGrupoCurso = GrupoCursoLista.getListMateriasGrupo( conElias, cicloGrupoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
		ArrayList listBloques = ciclo.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");

		// TreeMap para verificar si el alumno lleva la materia
		TreeMap treeAlumCurso = kardexLista.getTreeAlumnoCurso( conElias, cicloGrupoId, "");
		
		// TreeMap para obtener la nota de un alumno en la materia
		TreeMap treeNota = kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, "");
%>
<body>
	<div id="content">
		<h2><fmt:message key="aca.Evaluaciones" /></h2>
		<form name="forma"
			action="bimestre.jsp?CicloGrupoId=<%=cicloGrupoId%>" method="post">
			<div class="well">
				<a href="grupo.jsp" class="btn btn-primary"> <i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
				<select name="bloque" id="bloque" onchange='javascript:cambiaBloque()'>
					<%
						for (int j = 0; j < listBloques.size(); j++) {
								aca.ciclo.CicloBloque bloq = (aca.ciclo.CicloBloque) listBloques.get(j);

								if (bloq.getBloqueId().equals(bloque)) {
									out.print(" <option value='" + bloq.getBloqueId() + "' Selected>" + bloq.getBloqueNombre()	+ "</option>");
								} else {
									out.print(" <option value='" + bloq.getBloqueId() + "'>" + bloq.getBloqueNombre() + "</option>");
								}
							}
					%>
				</select>
				
			</div>
		</form>
		<h5>
			<fmt:message key="aca.Maestro" />( <fmt:message key="maestros.ConsejeroDeGrupo" /> ): [
			<%=Grupo.getEmpleadoId()%>
			] -
			<%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%></h5>

		
			<table width="99%" class="table table-fullcondensed">
				<tr>
					<th width="5%" align="center" class="small">#</th>
					<th width="8%" align="center" class="small"><fmt:message key="aca.Matricula" /></th>
					<th width="25%" align="center" class="small"><fmt:message key="aca.NombreDelAlumno" /></th>
					<%
						for (int j = 0; j < lisGrupoCurso.size(); j++) {
					%>
					<th style="text-align: center;" class="small"><strong><%=j + 1%></strong></th>
					<%
						}
					%>
					<th style="text-align: center;" class="small"><fmt:message key="aca.Prom" /></th>
				</tr>
				<%
					// Arreglos para calcular el promedio de la materia		
						double[] promedio = new double[30];
						int[] numAlum = new int[30];

						// Inicializa los arreglos
						for (i = 0; i < 20; i++) {
							promedio[i] = 0;
							numAlum[i] = 0;
						}

						String strNota = "";
						for (i = 0; i < lisAlum.size(); i++) {
							codigoAlumno = (String) lisAlum.get(i);

							// Calcula el promedio del alumno
							double promAlum = 0;
							int numMaterias = 0;
				%>
				<tr>
					<td align="center" class="small"><strong><%=i + 1%></strong></td>
					<td align="center" class="small"><%=codigoAlumno%></td>
					<td align="left" class="small"><strong><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></strong></td>
					<%
						for (int j = 0; j < lisGrupoCurso.size(); j++) {
							aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);
							
							String punto = aca.plan.PlanCurso.getPunto(conElias, grupoCurso.getCursoId());
							strNota = "0";
							// Verifica si el alumno tiene dada de alta la materia
							if (treeAlumCurso.containsKey(cicloGrupoId + grupoCurso.getCursoId() + codigoAlumno)) {
								if (treeNota.containsKey(cicloGrupoId + grupoCurso.getCursoId() + bloque + codigoAlumno)) {
									aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + grupoCurso.getCursoId() + bloque + codigoAlumno);
									if (punto.equals("S")) {
										strNota = frmDecimal.format(Double.parseDouble(krdxEval.getNota()));
									} else {
										strNota = frmEntero.format(Double.parseDouble(krdxEval.getNota()));
									}
									if (strNota.equals("") || strNota.equals(null)){
										strNota = "0";	
									}

									// Calcula el promedio de las materias
									float nota = Float.parseFloat(strNota.replaceAll(",", "."));
									
									if (nota > 0) {
										promedio[j] = promedio[j] + nota;
										numAlum[j] = numAlum[j] + 1;
									}

									// Calcula el promedio del alumno
									promAlum += nota;
									numMaterias++;

								} else {
									strNota = "-";
								}
							} else {
								strNota = "X";
							}
					%>
							<td align="center" style="text-align:center;background:<%=colores[j]%>;" class="small"><%=strNota%></td>
					<%
						}
								promAlum = promAlum / numMaterias;
					%>
					<td style="text-align: center;" class="small"><b><%=frmDecimal.format(promAlum)%></b></td>
				</tr>
				<%
					} //fin de for
				%>
				<tr>
					<td class="well small" colspan="3" height="26%" valign="middle"><b><fmt:message key="maestros.PromediosPorMateria" />:</b></td>
					<%
						for (int j = 0; j < lisGrupoCurso.size(); j++) {
								double prom = promedio[j] / numAlum[j];
								promGral += prom;
					%>
					<td class="well small" style="text-align: center;" valign="middle"><strong><%=frmDecimal2.format(prom)%></strong></td>
					<%
						}
							promGral = promGral / lisGrupoCurso.size();
					%>
					<td class="well small" style="text-align: center;" valign="middle"><strong><%=frmDecimal2.format(promGral)%></strong></td>
				</tr>
			</table>
		<br>
		<table align="center" class="table table-fullcondensed table-nohover" width="68%">
			<tr>
				<th align="center" width="4%" class="medium">#</th>
				<th align="center" width="25%" class="medium"><fmt:message key="aca.Materias" /></th>
				<th align="center" width="25%" class="medium"><fmt:message key="aca.Maestro" /></th>
				<th align="center" width="8%" class="medium"><fmt:message key="aca.Evaluaciones" /></th>
			</tr>
			<%
				for (int j = 0; j < lisGrupoCurso.size(); j++) {
						aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);

						ArrayList listEstrategias = GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");
			%>
			<tr style="background:<%=colores[j]%>;">
				<td align="center" class="small"><b><%=j + 1%></b></td>
				<td align="left" class="small"><strong>&nbsp;&nbsp;<%=aca.plan.PlanCurso.getCursoNombre(conElias,	grupoCurso.getCursoId())%></strong></td>
				<td align="left" class="small"><strong>&nbsp;&nbsp;[ <%=grupoCurso.getEmpleadoId()%>
						] - <%=aca.empleado.EmpPersonal.getNombre(conElias, grupoCurso.getEmpleadoId(), "NOMBRE")%></strong></td>
				<td align="center" class="small"><b><%=listEstrategias.size()%></b></td>
			<tr>
				<%
					}
				%>
			
		</table>
		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>