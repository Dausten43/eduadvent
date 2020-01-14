<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="kardexLista" scope="page"	class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexEvalLista" scope="page"	class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista" />
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>

<%@ page import="java.text.*"%>
<%@page import="java.util.TreeMap"%>

<script>
	function cambiaBloque() {
		document.forma.submit();
	}
</script>
<style>
	.table td, .table th{
		font-size: 10px;
	}
</style>
<%
	//Define los colores a usar en cada columna
	String[] colores = { "#FF8080", "#93C9FF", "#04C68B",
			"#FF8040", "#FFCAE4", "#BE7C7C", "#00AA55", "#C5AF65",
			"#0080FF", "#FFC891", "#C5EBDE", "#C4FCFF", "#B9C4B5",
			"#9EA2C5", "#E9ED3F", "#DF01D7", "#01DFD7", "#7D64B1",
			"#ABE17F", "#D52D0C", "#48B0F1" };

	DecimalFormat frmDecimal 	= new DecimalFormat("###,##0.0;(###,##0.0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	DecimalFormat frmEntero 	= new DecimalFormat("###,##0;(###,##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String escuelaId 			= (String) session.getAttribute("escuela");
	String codigoId 			= (String) session.getAttribute("codigoId");
	String cicloId 				= (String) session.getAttribute("cicloId");
	String cicloGrupoId 		= (String) request.getParameter("CicloGrupoId");
	
	String promedioId			= request.getParameter("Promedio")==null?"vacio":request.getParameter("Promedio");
	String bloque 				= request.getParameter("bloque")==null?"0":request.getParameter("bloque");
	String bloque2 				= request.getParameter("bloque2")==null?"0":request.getParameter("bloque2");
	String strBgcolor 			= "";

	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	// Lista de alumnos en el grupo
	ArrayList<String> lisAlum 							= kardexLista.getListAlumnosGrupo(conElias, cicloGrupoId);
	
	// Lista de materias en el grupo
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso 	= GrupoCursoLista.getListMateriasGrupo( conElias, cicloGrupoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	
	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
	
	if(promedioId.equals("vacio")){
		if(lisPromedio.size() > 0){
			aca.ciclo.CicloPromedio prom = (aca.ciclo.CicloPromedio) lisPromedio.get(0);
			promedioId = prom.getPromedioId();
		}else
			promedioId="1"; //Solo como default, pero si lisPromedio viene vacío, entonces la pagina deberia fallar
	}
	// Lista de bloques o evaluaciones
	ArrayList<aca.ciclo.CicloBloque> listBloques 		= ciclo.getListCiclo(conElias, cicloId, promedioId, "ORDER BY BLOQUE_ID");

	// TreeMap para verificar si el alumno lleva la materia
	TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso 	= kardexLista.getTreeAlumnoCurso( conElias, cicloGrupoId, "");
	
	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap<String, aca.kardex.KrdxAlumEval> treeNota 		= kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, "");
	
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);
%>

<div id="content">
	
	<h2><fmt:message key="aca.Evaluaciones" /></h2>
	
	<form name="forma" action="bimestre.jsp?CicloGrupoId=<%=cicloGrupoId%>" method="post">
		<div class="well">
			<a href="grupo.jsp" class="btn btn-primary"> 
				<i class="icon-arrow-left icon-white"></i> 
				<fmt:message key="boton.Regresar" />
			</a>&nbsp;&nbsp;
			Nivel 1:
			<select name="Promedio" id="Promedio" onchange='javascript:cambiaBloque()'>
				<%for (aca.ciclo.CicloPromedio prom : lisPromedio){%>
					<option value="<%=prom.getPromedioId() %>" <%if(prom.getPromedioId().equals(promedioId)){out.print("selected");} %>><%=prom.getNombre() %></option>
				<%}%>
			</select>&nbsp;&nbsp;
			Nivel 2:			
			<select name="bloque" id="bloque" onchange='javascript:cambiaBloque()'>
				<option value="0"><fmt:message key="boton.Todos" /></option>
				<%for (aca.ciclo.CicloBloque bloq : listBloques){%>
					<option value="<%=bloq.getBloqueId() %>" <%if(bloq.getBloqueId().equals(bloque)){out.print("selected");} %>><%=bloq.getBloqueNombre() %></option>
				<%}%>
			</select>
			
			<select name="bloque2" id="bloque2" onchange='javascript:cambiaBloque()'>
				<option value="0"><fmt:message key="boton.Todos" /></option>
				<%for (aca.ciclo.CicloBloque bloq : listBloques){%>
					<option value="<%=bloq.getBloqueId() %>" <%if(bloq.getBloqueId().equals(bloque2)){out.print("selected");} %>><%=bloq.getBloqueNombre() %></option>
				<%}%>
			</select>
			
		</div>
	</form>
	
	<div class="alert">
		<fmt:message key="maestros.ConsejeroDeGrupo" />: <%=Grupo.getEmpleadoId()%> | <%=aca.empleado.EmpPersonal.getNombre(conElias, Grupo.getEmpleadoId(), "NOMBRE")%>
	</div>
	<div class="well" style="text-align:center;">
		<a href="javascript:tableToExcel('table', 'Movimientos')" style="float:center;" class="btn btn-success"><i class="icon-white icon-arrow-down"></i> Bajar Lista a Excel</a>
	</div>
	<table class="table table-bordered table-condensed" id="table">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Matricula" /></th>
			<th><fmt:message key="aca.NombreDelAlumno" /></th>
			<%
			for (int j = 0; j < lisGrupoCurso.size(); j++) {
				aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);
			%>
				<th class="text-center" title='<%= aca.plan.PlanCurso.getCursoNombre(conElias,	grupoCurso.getCursoId()) %>'><%=j + 1%></th>
			<%}%>
			<th class="text-center"><fmt:message key="aca.Promedio" /></th>
		</tr>
		<%
			
			int cantidad = 30;
		
			// Arreglos para calcular el promedio de la materia		
			double[] promedio 	= new double[cantidad];
			int[] numAlum 		= new int[cantidad];

			// Inicializa los arreglos
			for (int i = 0; i < cantidad; i++) {
				promedio[i] 	= 0;
				numAlum[i] 		= 0;
			}

			for (int i = 0; i < lisAlum.size(); i++) {
				String codigoAlumno 	= (String) lisAlum.get(i);
				String strNota 			= "-";

				// Calcula el promedio del alumno
				double promAlum = 0;
				int numMaterias = 0;
		%>
				<tr>
					<td><%=i + 1%></td>
					<td><%=codigoAlumno%></td>
					<td><%=aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "APELLIDO")%></td>
		<%
					for (int j = 0; j < lisGrupoCurso.size(); j++) {
						aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);
						
						String punto = aca.plan.PlanCurso.getPunto(conElias, grupoCurso.getCursoId());

						// Verifica si el alumno tiene dada de alta la materia
						if (treeAlumCurso.containsKey(cicloGrupoId + grupoCurso.getCursoId() + codigoAlumno)) {
							
							float nota 		= 0;
							strNota 		= "-";
							
							if(bloque.equals("0")&&bloque2.equals("0")){								
								if(mapPromAlumno.containsKey(codigoAlumno+grupoCurso.getCursoId()+promedioId)){	
									strNota = mapPromAlumno.get(codigoAlumno+grupoCurso.getCursoId()+promedioId).getNota();
									nota 	= new BigDecimal(strNota).floatValue(); 
								}
							}else{
								String nota1 		= "-";
								String nota2 		= "-";
								
								/* ==== OBTENER NOTA1 ==== */
								if (treeNota.containsKey(cicloGrupoId + grupoCurso.getCursoId() + bloque + codigoAlumno)) {
									aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + grupoCurso.getCursoId() + bloque + codigoAlumno);
									
									if(punto.equals("S")) {
										nota1 = new BigDecimal(krdxEval.getNota())+"";
									}else{
										nota1 = new BigDecimal(krdxEval.getNota()).setScale(0,BigDecimal.ROUND_DOWN)+"";
									}
								}
								/* ==== OBTENER NOTA2 ==== */
								if (treeNota.containsKey(cicloGrupoId + grupoCurso.getCursoId() + bloque2 + codigoAlumno)) {
									aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + grupoCurso.getCursoId() + bloque2 + codigoAlumno);
									
									if(punto.equals("S")) {
										nota2 = new BigDecimal(krdxEval.getNota())+"";
									}else{
										nota2 = new BigDecimal(krdxEval.getNota()).setScale(0,BigDecimal.ROUND_DOWN)+"";
									}
								}
								
								if(!bloque2.equals("0")){// Tiene doble filtro
									if(!nota1.equals("-") || !nota2.equals("-")){
										if(nota1.equals("-"))nota1="0";
										if(nota2.equals("-"))nota2="0";
										nota = new BigDecimal(nota1).add(new BigDecimal(nota2)).divide(new BigDecimal("2"), 1, RoundingMode.DOWN).floatValue();
										strNota = nota+"";
									}
								}else{// El filtro normal (uno)
									if(!nota1.equals("-")){
										nota = new BigDecimal(nota1).floatValue();
										strNota = nota+"";
									}
								}
							}						
							
							if (nota>0) {
								promedio[j] = promedio[j] + nota;
								numAlum[j] = numAlum[j] + 1;
							}
							
							
							// Calcula el promedio del alumno
							promAlum += nota;
														
							
						} else {
							strNota = "-";
						}
						
						if(!strNota.equals("-")){
							numMaterias++;
						}
						if(strNota.equals("-")){
		%>
						<td class="text-center"><%=strNota%></td>
		<%				}else{%>
						<td class="text-center"><%=frmDecimal.format(Double.parseDouble(strNota))%></td>
		<%
						 }	
					}
					
					if(numMaterias!=0){
					promAlum = promAlum / numMaterias;
					promAlum = new BigDecimal(promAlum).setScale(2,RoundingMode.HALF_DOWN).doubleValue();

					}
		%>
					<td class="text-center"><%=(numMaterias!=0)?frmDecimal.format(promAlum):"-"%></td>
				</tr>
		<%
			} //fin de for
		%>
 		<tr> 
 			<th colspan="3"><fmt:message key="maestros.PromediosPorMateria" /></th> 
 			<% 
 				double promGral = 0;
 				for (int j = 0; j < lisGrupoCurso.size(); j++) {
 					double prom = promedio[j] / numAlum[j];
 					promGral += prom;
 			%> 
 					<th class="text-center"><%=frmDecimal.format(prom)%></th> 
 			<% 
 				}
 				promGral = promGral / lisGrupoCurso.size();
 			%> 
 			<th class="text-center"><%=frmDecimal.format(promGral)%></th> 
 		</tr> 
	</table>
	
	<br>
	<div class="well" style="text-align:center;">
		<a href="javascript:tableToExcel('table', 'Promedios')" style="float:center;" class="btn btn-success"><i class="icon-white icon-arrow-down"></i> Bajar Lista a Excel</a>
	</div>
	<table class="table table-bordered table-condensed" id="table">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Materias" /></th>
			<th><fmt:message key="aca.Maestro" /></th>
			<th><fmt:message key="aca.Evaluaciones" /></th>
		</tr>
		<%
			for (int j = 0; j < lisGrupoCurso.size(); j++) {
				aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);

				ArrayList<aca.ciclo.CicloGrupoEval> listEstrategias = GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");
		%>
			<tr>
				<td><%=j + 1%></td>
				<td><%=aca.plan.PlanCurso.getCursoNombre(conElias,	grupoCurso.getCursoId())%></td>
				<td><%=grupoCurso.getEmpleadoId()%> | <%=aca.empleado.EmpPersonal.getNombre(conElias, grupoCurso.getEmpleadoId(), "NOMBRE")%></td>
				<td><%=listEstrategias.size()%></td>
			<tr>
		<%
			}
		%>
	</table>
	
</div>
<script src="../../js-plugins/tableToExcel/tableToExcel.js"></script>
<%@ include file="../../cierra_elias.jsp"%>