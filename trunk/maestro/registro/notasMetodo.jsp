<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.util.TreeMap"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.text.*"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista" />
<jsp:useBean id="AlumProm" scope="page" class="aca.vista.AlumnoProm" />
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoAct" />

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloGrupoId = (String) request.getParameter("CicloGrupoId");
	String codigoAlumno = (String) request.getParameter("CodigoAlumno");
	String cicloId 		= (String) session.getAttribute("cicloId");
	
	DecimalFormat frmDecimal = new DecimalFormat("###,##0.0;(###,##0.0)");
	DecimalFormat frmEntero = new DecimalFormat("###,##0;(###,##0)");
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	if(accion.equals("1")){
		AlumProm.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, request.getParameter("CursoId"));
		double promedio = Double.parseDouble(AlumProm.getPromedio().replaceAll(",",".")) + Double.parseDouble(AlumProm.getPuntosAjuste().replaceAll(",",".")); 
		
		kardex.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, request.getParameter("CursoId"));
		kardex.setNota(frmDecimal.format(promedio));
		if(kardex.updateReg(conElias)){
			msj = "Modificado";
		}else{
			msj = "NoModifico"; 
		}
		
	}
	
	pageContext.setAttribute("resultado", msj);

	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)) {
		Grupo.mapeaRegId(conElias, cicloGrupoId);
	}

	double promTotal = 0;

	// TreeMap para verificar si el alumno lleva la materia
	TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso = kardexLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");

	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, "");

	// Materias del grupo que inscribió el alumno 
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso = GrupoCursoLista.getListMateriasGrupo(conElias, codigoAlumno, cicloGrupoId, " ORDER BY ORDEN_CURSO_ID(CURSO_ID), TIPO_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");

	//Get Notas alumno para obtener el promedio
	HashMap<String, aca.vista.AlumnoCurso> mapNotas = aca.vista.AlumnoCursoLista.getMapNotas(conElias, codigoAlumno, cicloGrupoId);

	//TreeMap de los promedios del alumno en la materia
	TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeAlumno(conElias,codigoAlumno, "");
	
%>

<div id="content">
	<h2><fmt:message key="aca.Promedio" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
  	<div class="alert alert-info">
		<h4><%=aca.alumno.AlumPersonal.getNombre(conElias,codigoAlumno, "NOMBRE")%></h4> 
		<strong><fmt:message key="aca.Maestro" />:</strong> <%=aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(), "NOMBRE")%> 
  	</div>
  	
  	<div class="well">
			<a class="btn btn-primary" href="alumnos.jsp?CicloGrupoId=<%=cicloGrupoId%>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<form name="frmNotas" action="notasMetodo.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>" method="post">
		<input type="hidden" name="Accion"> 
		<input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>"> 
		<input type="hidden" name="CodigoAlumno" value="<%=codigoAlumno%>">
			
				
		<table class="table table-condensed table-striped table-bordered">
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Clave" /></th>
					<th><fmt:message key="aca.Materia" /></th>
					<%
						for (int z = 0; z < aca.ciclo.CicloGrupoEval.getNumEval(conElias, cicloGrupoId,((aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(0)).getCursoId()); z++) {
					%>
						<th style="width:3%;" class="text-center"><%=z+1%></th>
					<%
						}
					%>
					<th class="text-center"><fmt:message key="aca.Promedio" /></th>
					<th style="width:2%;"><fmt:message key="aca.Actualizar" /></th>
				</tr>
			</thead>

		<%
			HashMap<Integer, String> arrPromedio = new HashMap<Integer, String>();

			int cont = 0;
			for (aca.ciclo.CicloGrupoCurso grupoCurso: lisGrupoCurso) {
				cont++;
				ArrayList<aca.ciclo.CicloGrupoEval> listEstrategias = GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");
	    %>
			<tr>
				<td><%=cont%></td>
				<td><%=grupoCurso.getCursoId()%></td>
				<td><%=aca.plan.PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId())%></td>
				<%
					String punto = aca.plan.PlanCurso.getPunto(conElias, grupoCurso.getCursoId());
					int numEvaluaciones 	= 0;
					int cont2       		= 0;
					double promedio 		= 0;
					for (aca.ciclo.CicloGrupoEval eval: listEstrategias) {
						String nota = "-";
						if (treeNota.containsKey(cicloGrupoId + grupoCurso.getCursoId() + eval.getEvaluacionId() + codigoAlumno)) {
							aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + grupoCurso.getCursoId() + eval.getEvaluacionId() + codigoAlumno);
							if (punto.equals("S")) {
								nota = frmDecimal.format(Double.parseDouble(krdxEval.getNota())).replaceAll(",", ".");
							} else {
								nota = frmEntero.format(Double.parseDouble(krdxEval.getNota())).replaceAll(",", ".");
							}
						}
					
						if (!nota.equals("-")){
							numEvaluaciones++;	
						}
						arrPromedio.put( cont2 + 1, (arrPromedio.get(cont2 + 1) != null) ? arrPromedio.get(cont2 + 1) + "," + nota : nota);
						promedio += !nota.equals("-") ? Double.parseDouble(nota) : 0;

				%>
						<td title="<%=eval.getValor()%>%" class="text-center">
							<a href="evalEstrategias.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>&evaluacionId=<%=eval.getEvaluacionId()%>&materia=<%=eval.getCursoId()%>">
								<%=nota%>
							</a>
						</td>
				<%
						cont2++;
					}

					
					String strProm = mapNotas.get(grupoCurso.getCursoId()).getNota();
					if (strProm == null || strProm.equals("")) {
						strProm = "0";
						
						aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId + grupoCurso.getCursoId() + codigoAlumno);
						strProm = Double.parseDouble(alumProm.getPromedio()) + Double.parseDouble(alumProm.getPuntosAjuste()) + "";
					}

					promedio = Double.parseDouble(strProm);

					promTotal += promedio;
							
				%>
				<td class="text-center">
					<%=frmDecimal.format(promedio)%> 
				</td>
				<td>
					<a href="notasMetodo.jsp?Accion=1&CursoId=<%=grupoCurso.getCursoId()%>&CicloGrupoId=<%=cicloGrupoId %>&CodigoAlumno=<%=codigoAlumno %>&EvaluacionId=0" class="btn btn-primary btn-mini">
						<i class="icon-refresh icon-white"></i>
					</a>
				</td>
			</tr>
		<%
			}
		%>
			<tr>
				<td colspan="3"><fmt:message key="aca.Total" /></td>
				<%
					promTotal = 0;
					for (int i = 1; i <= arrPromedio.size(); i++) {
						double promedio = 0;
						String[] calificaciones = arrPromedio.get(i).split(",");
						int numEval = 0;
						
						for (String x : calificaciones) {
							if (!x.equals("-")) {
								promedio += Double.parseDouble(x);
								numEval++;
							}
						}
				%>
				<td class="text-center">
					<%=frmDecimal.format(promedio /= numEval)%>
				</td>
				<%
					if (!(promedio + "").equals("NaN"))
						promTotal += promedio;
					}
				%>
				<td class="text-center">
					<%=frmDecimal.format(promTotal / arrPromedio.size())%>
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</form>


</div>

<%@ include file="../../cierra_elias.jsp"%>
