<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="GrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<%	
	String cicloId			= request.getParameter("cicloId");
	String empleadoId		= (String) request.getParameter("EmpleadoId");
	String nivelId			= (String) request.getParameter("NivelId");	
	session.setAttribute("lvlId", nivelId);
	session.setAttribute("clId", cicloId);
	String strBgcolor		= "";
	session.setAttribute("codigoEmpleado", empleadoId);
	
	ArrayList lisMaterias		= GrupoCursoLista.getListMateriasEmpleadoxNivel(conElias, cicloId, empleadoId,nivelId, " ORDER BY ORDEN_NGG(CICLO_GRUPO_ID)");
	
	int i=0,numAlumnos=0;
%>
<body>
<div id="content">
<table width="90%" border="0" align="center">
  <tr><td align=center colspan="13"><font size="3"><strong>Maestro: <%=aca.empleado.EmpPersonal.getNombre(conElias,empleadoId, "APELLIDO")%></strong><font></td></tr>
  <tr><td align="center" colspan="13"><strong><%=aca.ciclo.Ciclo.nombreCiclo(conElias,cicloId)%></strong></td></tr>
  <tr>
  </table><br><div class="well">
<a href="maestro.jsp?ciclo=<%=session.getAttribute("clId") %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> Regresar</a>
</div>
    <table width="80%"  align="center" class="table table-condensed">
  <tr>
   
    <th width="5%" align="center">Gdo.</th>
    <th width="5%" align="center">Gpo.</th>
    <th width="30%" align="center">Materia</th>
    <th width="7%" align="center"># Alum.</th>
    <th width="5%">Portal</th>
  </tr>
<%
	for (i=0;i<lisMaterias.size();i++){
		aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
		CicloGrupo.mapeaRegId(conElias, grupoCurso.getCicloGrupoId());
		numAlumnos 	= Integer.parseInt(aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId()));
%> 
  <tr >
    <td align="center"><%=CicloGrupo.getGrado()%></td>
    <td align="center"><%=CicloGrupo.getGrupo()%></td>
    <td align="left"><strong>
       <a href="evaluar.jsp?EmpleadoId=<%=empleadoId%>&cursoId=<%=grupoCurso.getCursoId()%>&cicloGrupoId=<%=grupoCurso.getCicloGrupoId()%>">
    	<%= aca.plan.PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId())%>
       </a></strong></td>
    <td align="center"><%=numAlumnos%></td>
    <td><a href="../../maestro/evaluar/evaluar.jsp?admin=1&cursoId=<%=grupoCurso.getCursoId() %>&cicloGrupoId=<%=grupoCurso.getCicloGrupoId()%>"><i class="icon-chevron-right"></i></a></td>
  </tr>
<% 		

	}//FIN DE FOR 
%>  
   </table>
   </tr>
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 