<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.text.*" %>
<%@page import="aca.ciclo.CicloGrupoActividad"%>

<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad"/>
<jsp:useBean id="cicloGrupoActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>

<%
	String codigoId								= (String) session.getAttribute("codigoEmpleado");
	String cicloGrupoId							= request.getParameter("cicloGrupoId");
	String cursoId								= request.getParameter("cursoId");
	String resultado							= "";
	
	
	
	DecimalFormat getformato					= new DecimalFormat("##0.00;(##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	// Mapea el registro del grupo.
	//cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	empPersonal.mapeaRegId(conElias, codigoId);
	
	
	ArrayList listEstrategias = GrupoEvalL.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	ArrayList lisActividad	  = cicloGrupoActividadL.getListGrupo(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN, ACTIVIDAD_ID");

%>
<body>
	<table width="100%">
		<tr>
			<td><a href="opcion.jsp">&lsaquo;&lsaquo; <fmt:message key="boton.Regresar" /></a></td>
		</tr>
		<tr>
			<td align="center">&nbsp;<%=resultado %></td>
		</tr>
		<tr>
			<td align="center" style="font-size:10pt"><b>
				<%=empPersonal.getNombre() %> <%=empPersonal.getApaterno() %> <%=empPersonal.getAmaterno() %> [<%=codigoId%>]<br>
				<%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %>
			</b></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<table width="70%" border="0" align="center">
	  <tr>
	    <th align="center"># <fmt:message key="aca.Eval" /></th>
	    <th align="center"><fmt:message key="aca.NombreEstrategia" /></th>
	    <th align="center"><fmt:message key="aca.Fecha" /></th>
	    <th align="center"><fmt:message key="aca.Valor" /></th>
	    <th align="center"><fmt:message key="aca.Tipo" /></th>
	    <th align="center"><fmt:message key="aca.Evaluo" /></th>
		<th align="center"><fmt:message key="aca.Prom" /></th>
	  </tr>
<%
	double sumaPromedioGrupo = 0D;
	int	numEvaluaciones = 0;
	float sumValorEvaluaciones = 0;
	for (int i=0; i<listEstrategias.size(); i++){
		aca.ciclo.CicloGrupoEval evaluacion = (aca.ciclo.CicloGrupoEval) listEstrategias.get(i);
		
%>  
		<tr>
		  <td align="center" style="background-color: #D8D8D8"><b><%= evaluacion.getEvaluacionId()%></b></td>
		  <td align="center" style="background-color: #D8D8D8"><b><%= evaluacion.getEvaluacionNombre()%></b></td>
		  <td align="center" style="background-color: #D8D8D8"><b><%= evaluacion.getFecha()%></b></td>
		  <td align="center" style="background-color: #D8D8D8"><b><%= evaluacion.getValor()%></b></td>
		  <td align="center" style="background-color: #D8D8D8"><b><%= evaluacion.getTipo() %></b></td>
		  <td width="9%" align="center" style="background-color: #D8D8D8"><strong><%=aca.kardex.KrdxAlumEval.tieneEvaluaciones(conElias, cicloGrupoId, cursoId, evaluacion.getEvaluacionId())?"Si":"No" %></strong></td>
<%
		double tmpPromedioEval = evaluacion.promedioEstrategia(conElias, cicloGrupoId, cursoId, evaluacion.getEvaluacionId());
		sumaPromedioGrupo += tmpPromedioEval;
		numEvaluaciones++;
		sumValorEvaluaciones += Float.parseFloat(evaluacion.getValor());
		
%>
		<td width="8%" align="center" style="background-color: #D8D8D8"><strong><%=getformato.format(tmpPromedioEval) %></strong></td>
		</tr>
		<tr>
			<td colspan="7" style="border-bottom: dotted 1px gray;">
				<table width="100%">
<%
		boolean entro = false;
		int sumaActividades = 0;
		for(int j = 0; j < lisActividad.size(); j++){
			cicloGrupoActividad = (CicloGrupoActividad) lisActividad.get(j);
			if(cicloGrupoActividad.getEvaluacionId().equals(evaluacion.getEvaluacionId())){
				sumaActividades += Integer.parseInt(cicloGrupoActividad.getValor());
				if(!entro){
					entro = true;
%>
					<tr>
						<td width="10%">&nbsp;</td>
						<td width="50%" style="background-color: #5FB404;font-weight: bold;" align="center"><font color="white"><fmt:message key="aca.Nombre" /></font></td>
						<td width="20%" style="background-color: #5FB404;font-weight: bold;" align="center"><font color="white"><fmt:message key="aca.Fecha" /></font></td>
						<td width="20%" style="background-color: #5FB404;font-weight: bold;" align="center"><font color="white"><fmt:message key="boton.Valor" /> (%)</font></td>
					</tr>
<%
				}
%>
					<tr>
					    <td>&nbsp;</td>
						<td><img src="../../imagenes/estrella.gif" " title="estrella" border="0" />&nbsp;&nbsp;<%=cicloGrupoActividad.getActividadNombre() %></td>
						<td align="center"><%=cicloGrupoActividad.getFecha() %></td>
						<td align="center"><%=cicloGrupoActividad.getValor() %></td>
					</tr>
<%
			}
		}
		if(sumaActividades < 100){
%>
					<tr>
						<td colspan="7" align="right"><font size="2" color="#5FB404"><b><fmt:message key="aca.SumaDeActividades" /> (<%=sumaActividades %>)</b></font></td>
					</tr>
					<tr>
				       <td>&nbsp;<td>
				    </tr>
<%
		}
%>
				</table>
			</td>
		</tr>  
<%
	}
%>
		<tr bgcolor="#CEF6F5">
			<td colspan="4" align="center"><b><i><fmt:message key="aca.TotalEstrategiasDeMateria" /> <%=numEvaluaciones %> <fmt:message key="maestros.Estrategias" />.</i></b></td>
			<td width="8%" align="center"><b><i><%=sumValorEvaluaciones %></i></b></td>
			<td width="9%" align="right">&nbsp;</td>
			<td width="8%" align="right"><b><i><%=getformato.format(sumaPromedioGrupo/numEvaluaciones) %></i></b></td>
		</tr>
	</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %>