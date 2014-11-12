<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.TreeMap"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="AlumProm" scope="page" class="aca.vista.AlumnoProm"/>
<% 
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String codigoAlumno		= (String) request.getParameter("CodigoAlumno");
	String cicloId			= (String) session.getAttribute("cicloId");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)){
		Grupo.mapeaRegId(conElias,cicloGrupoId);
	}
	
	ArrayList listEstrategias = null;
	ArrayList lisGrupoCurso	  = null;
	lisGrupoCurso			  = GrupoCursoLista.getListMateriasGrupo(conElias,cicloGrupoId," ORDER BY ORDEN_CURSO_ID(CURSO_ID), TIPO_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");

	int numEval =0;
%>
<body>
<form name="frmNotas" action="notasMetodo.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>" method="post">
  <input type="hidden" name="Accion">
  <input type="hidden" name="CicloGrupoId" value="<%=cicloGrupoId%>">
  <input type="hidden" name="CodigoAlumno" value="<%=codigoAlumno%>">
<table width="70%" border="0" align="center" class="tabla">
  <tr><td align="center" colspan="8"><font size="3"><strong><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></strong></font></td></tr>
  <tr><td align="center" colspan="8"><font size="2"><strong><%=aca.ciclo.Ciclo.nombreCiclo(conElias,cicloId)%></strong></font></td></tr>
  <tr><td align="center" colspan="8"><strong>
  	<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Grupo.getNivelId())%> - 
  	<%=aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(Grupo.getGrado()))%> "<%=Grupo.getGrupo()%>" - 
  	<fmt:message key="aca.Consejero" />: <%=aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(),"NOMBRE")%> 
	</strong></td></tr>   
	<tr><td align="center" colspan="8"><a href="alumnos.jsp?CicloGrupoId=<%=cicloGrupoId%>"><fmt:message key="boton.ElegirAlumno" /></a></td></tr>
  <tr>
    <td align="left" colspan="8">      
      <strong><fmt:message key="aca.Alumno" />: <%=aca.alumno.AlumPersonal.getNombre(conElias,codigoAlumno,"NOMBRE")%></strong>
    </td>
  </tr>
  <tr>
    <th align="center" width="5%">#</th>
    <th align="center" width="8%" ><fmt:message key="aca.Clave" /></th>
    <th align="center" width="15%" ><fmt:message key="aca.Materia" /></th>
<% for (int z=0; z<aca.ciclo.CicloGrupoEval.getNumEval(conElias, cicloGrupoId,((aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(0)).getCursoId()); z++){%>    
	<th align="center" width="3%"><%= z+1 %></th>
<% }%>	
    <th align="center" width="5%" ><fmt:message key="aca.PromFinal" /></th>
  </tr>
<% 
	for (int i=0;i<lisGrupoCurso.size();i++){
		aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(i);
		//listEstrategias = GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");
		numEval = aca.ciclo.CicloGrupoEval.getNumEval(conElias, cicloGrupoId, grupoCurso.getCursoId());
%>
  <tr class="tr2">
    <td align="center"><strong><%=i+1%></strong></td>
    <td align="left">&nbsp;<%=grupoCurso.getCursoId()%></td>
    <td align="left"><strong><%=aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId())%></strong></td>
<% 		
		numEval = aca.ciclo.CicloGrupoEval.getNumEval(conElias, cicloGrupoId, grupoCurso.getCursoId());
		for(int j=1; j<=numEval; j++){
			if (aca.ciclo.CicloGrupoCurso.esCursosEvaluado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),j)){%>	
			<td align="center"><%=aca.kardex.KrdxAlumEval.alumNotaEvalPuntoDecimal(conElias, codigoAlumno, cicloGrupoId, grupoCurso.getCursoId(), j+"")%></td>			
<% 			}else{
%>	
			<td align="center">-</td>
<%          }
							
	    }
	   AlumProm.mapeaRegId(conElias,codigoAlumno,cicloGrupoId,grupoCurso.getCursoId());
	   
%> 
		<td align="center"><%= AlumProm.getPromedio() %></td>
		
<% }%>
  </tr>    
</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 