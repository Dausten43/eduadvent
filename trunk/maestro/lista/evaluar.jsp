<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.text.*" %>
<%@page import="java.util.TreeMap"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.ciclo.CicloGrupoEval"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="kardexEval" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso"/>

<head>	
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<link href="../../css/tarjeta.css" rel="STYLESHEET" type="text/css" >
</head>	
<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) request.getParameter("EmpleadoId");
	String cursoId 		= request.getParameter("cursoId");
	
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	
	String maestro		= "";
	String cursoNombre 	= "";
	String strNota		= "";
	
	empPersonal.mapeaRegId(conElias, codigoId);
	
	// Lista de alumnos
	ArrayList lisKardex 	= kardexLista.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID = '"+cursoId+"' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	
	// Lista de evaluaciones de la materia
	ArrayList lisEvaluacion = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	
	// TreeMap de las notas de las evaluaciones en la materia
	TreeMap treeNota		= kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, cursoId, "");
	
	//TreeMap de los promedios del alumno en la materia
	TreeMap treeProm 	= AlumPromLista.getTreeCurso(conElias, cicloGrupoId, cursoId,"");
		
	planCurso.mapeaRegId(conElias, cursoId);	

	maestro 	= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	cursoNombre = aca.plan.PlanCurso.getCursoNombre(conElias, cursoId);
%>
<body>
<form>
	<table width="100%">
		<tr>
		  <td align="center">
			<font size="2"><strong><%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%></strong></font><br>
			<font size="2"><strong> <%=maestro%> (<%=empPersonal.getCodigoId()%>) - <%=cursoNombre%></strong></font>
		  </td>
		</tr>		
		<tr>
			<td align="center">
				<table width="80%" class="table table-condensed">
					<tr>
						<th width="5%">#</th>
						<th width="60%">Descripci&oacute;n</th>
						<th width="10%">Fecha</th>
						<th width="5%">Valor</th>
						<th width="5%">Tipo</th>
						<th width="5%">Cálculo</th>
						<th width="15%">Estado</th>
					</tr>
<%
	for(int i = 0; i < lisEvaluacion.size(); i++){
		cicloGrupoEval = (aca.ciclo.CicloGrupoEval) lisEvaluacion.get(i);
%>
					<tr>
						<td align="center"><%=i+1 %></td>
						<td><%=cicloGrupoEval.getEvaluacionNombre()%></td>
						<td><%=cicloGrupoEval.getFecha() %></td>
						<td align="center"><%=cicloGrupoEval.getValor() %></td>
						<td align="center"><%=cicloGrupoEval.getTipo() %></td>
						<td align="center"><%=cicloGrupoEval.getCalculo().equals("V")?"Valor":"Promedio" %></td>
						<td align="center">
						<% if(cicloGrupoEval.getEstado().equals("A")){%>						
						Abierto &nbsp;&nbsp;
						<%}if(cicloGrupoEval.getEstado().equals("C")){%>
						Cerrado &nbsp;&nbsp;												
						<%}%>
						</td>
					</tr>
<%
	}
%>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="100%" class="table table-condensed">
					<tr>
						<th>#</th>
						<th>C&oacute;digo</th>
						<th>Nombre del Alumno</th>
<%
	for(int i = 0; i < lisEvaluacion.size(); i++){
		cicloGrupoEval = (aca.ciclo.CicloGrupoEval) lisEvaluacion.get(i);
%>
						<th title="<%=cicloGrupoEval.getEvaluacionNombre() %>"><%=i+1 %></th>
<%
	}
%>
						<th>Prom</th>
						<th>Extra</th>
						<th>Estado</th>						
					</tr>
<%
	DecimalFormat getformato = new DecimalFormat("##0;(##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	// Recorre la lista de Alumnos en la materia
	for(int i = 0; i < lisKardex.size(); i++){
		kardex = (KrdxCursoAct) lisKardex.get(i);
		
		double prom 	= 0.0; 
		int promedio 	= 0;
		if (treeProm.containsKey(cicloGrupoId+cursoId+kardex.getCodigoId())){
			aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId+cursoId+kardex.getCodigoId());
			prom = Double.parseDouble(alumProm.getPromedio())+Double.parseDouble(alumProm.getPuntosAjuste())+.5;
			promedio = (int) prom;
		}else{
			System.out.println("Error... "+kardex.getCodigoId());
		}
		
%>
					<tr>
						<td align="center"><%=i+1 %></td>
						<td align="center" id="<%=kardex.getCodigoId()%>"><%=kardex.getCodigoId() %></td>
						<td><%=AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO") %></td>
<%
		boolean tieneCalificacion = false;		
		for(int j = 0; j < lisEvaluacion.size(); j++){
			cicloGrupoEval = (aca.ciclo.CicloGrupoEval) lisEvaluacion.get(j);
			
			if (treeNota.containsKey(cicloGrupoId+cursoId+cicloGrupoEval.getEvaluacionId()+kardex.getCodigoId())){
				kardexEval = (KrdxAlumEval) treeNota.get(cicloGrupoId+cursoId+cicloGrupoEval.getEvaluacionId()+kardex.getCodigoId());
				if(kardexEval.getCodigoId().equals(kardex.getCodigoId()) && cicloGrupoEval.getEvaluacionId().equals(kardexEval.getEvaluacionId()) && !kardexEval.getNota().equals("0")){
					tieneCalificacion = true;
					// Elimina un decimal del formato de la nota
					strNota = kardexEval.getNota().substring(0,kardexEval.getNota().indexOf(".")+2);
%>
						<td align="center" title="<%=cicloGrupoEval.getEvaluacionNombre() %>">
							<div <%if(!kardex.getTipoCalId().equals("6")){ %>id="divnota<%=i %>-<%=cicloGrupoEval.getEvaluacionId() %>"<%} %>><%=strNota%></div>
						</td>
<%					
				}else{
					tieneCalificacion = false;
				}
			}else{
%>
						<td align="center" title="<%=cicloGrupoEval.getEvaluacionNombre() %>">
							<div <%if(!kardex.getTipoCalId().equals("6")){ %>id="divnota<%=i %>-<%=cicloGrupoEval.getEvaluacionId() %>"<%} %>>-</div>
						</td>
<%
			}
		}				
		
		if(prom > 0){
			promedio = Math.round(promedio);
			if(promedio < 6) promedio = 5;
%>
						<td align="center"><%=getformato.format(promedio).replace(',', '.') %></td>
<%
		}else{
%>
						<td align="center">-</td>
<%
		}
		if(cicloGrupoCurso.getEstado().equals("3") && promedio < 6){
			
			if(kardex.getNotaExtra() != null){
%>
						<td align="center"><%=kardex.getNotaExtra() %></td>
<%
			}
			
		}else if((cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < 6){
%>
						<td align="center"><%=kardex.getNotaExtra() %></td>
<%
		}
%>
					    <td>&nbsp;</td>
					    <td>&nbsp;</td>						
					</tr>
<%	}  %>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>