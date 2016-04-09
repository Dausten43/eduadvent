<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<%	
	String cicloId			= (String) request.getParameter("CicloId");
	String empleadoId		= (String) request.getParameter("EmpleadoId");
	String strBgcolor		= "";
	
	ArrayList lisMaterias		= new ArrayList();
	lisMaterias				= GrupoCursoLista.getListMateriasEmpleado(conElias, cicloId, empleadoId, " ORDER BY ORDEN_NGG(CICLO_GRUPO_ID)");
	
	int i=0, numAlumnos		=0;
	String bim1="",bim2="",bim3="",bim4="",bim5="";
%>
<body>
<table width="90%" border="0" align="center">
  <tr><td align=center colspan="12"><font size="3"><strong>Maestro: <%=aca.empleado.EmpPersonal.getNombre(conElias,empleadoId, "APELLIDO")%></strong><font></td></tr>
  <tr><td align="center" colspan="12"><strong><%=aca.ciclo.Ciclo.nombreCiclo(conElias,cicloId)%></strong></td></tr>
  <tr><td align="left" colspan="12">&nbsp;</td></tr>
  <tr bgcolor="#C8D4A3">
    <th width="5%" align="center">#</th>
    <th width="15%" align="center"><fmt:message key="aca.Nivel" /></th>
    <th width="5%" align="center"><fmt:message key="aca.Gdo" /></th>
    <th width="5%" align="center"><fmt:message key="aca.Gpo" /></th>
    <th width="30%" align="center"><fmt:message key="aca.Materia" /></th>
    <th width="7%" align="center"># <fmt:message key="aca.AbreviaAlum" /></th>
	<th width="7%" align="center">1° <fmt:message key="aca.Bim" /></th>
	<th width="7%" align="center">2° <fmt:message key="aca.Bim" /></th>
	<th width="7%" align="center">3° <fmt:message key="aca.Bim" /></th>
	<th width="7%" align="center">4° <fmt:message key="aca.Bim" /></th>
	<th width="7%" align="center">5° <fmt:message key="aca.Bim" /></th>
  </tr>
<%
	for (i=0;i<lisMaterias.size();i++){
		aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
		CicloGrupo.mapeaRegId(conElias, grupoCurso.getCicloGrupoId());
		
	 
		numAlumnos 	= Integer.parseInt(aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId()));
		
		if ( aca.ciclo.CicloGrupoEval.getEstado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),1).equals("C") )
			bim1="Listo";
		else if (aca.ciclo.CicloGrupoCurso.esCursosEvaluado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),1))
			bim1="Evalua";
		else
			bim1="Guion";
		
		if ( aca.ciclo.CicloGrupoEval.getEstado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),2).equals("C") )
			bim2="Listo";
		else if (aca.ciclo.CicloGrupoCurso.esCursosEvaluado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),2))
			bim2="Evalua";
		else
			bim2="Guion";
		
		if ( aca.ciclo.CicloGrupoEval.getEstado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),3).equals("C") )
			bim3="Listo";
		else if (aca.ciclo.CicloGrupoCurso.esCursosEvaluado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),3))
			bim3="Evalua";
		else
			bim3="Guion";
		
		if ( aca.ciclo.CicloGrupoEval.getEstado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),4).equals("C") )
			bim4="Listo";
		else if (aca.ciclo.CicloGrupoCurso.esCursosEvaluado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),4))
			bim4="Evalua";
		else
			bim4="Guion";
		
		if ( aca.ciclo.CicloGrupoEval.getEstado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),5).equals("C") )
			bim5="Listo";
		else if (aca.ciclo.CicloGrupoCurso.esCursosEvaluado(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(),5))
			bim5="Evalua";
		else
			bim5="Guion";
		
		pageContext.setAttribute("bim1",bim1);
		pageContext.setAttribute("bim2",bim2);
		pageContext.setAttribute("bim3",bim3);
		pageContext.setAttribute("bim4",bim4);
		pageContext.setAttribute("bim5",bim5);
%>    
  <tr <%=strBgcolor%> >
    <td align="left"><strong><%=i+1%></strong></td>    
    <td align="center"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), CicloGrupo.getNivelId())%></td>
    <td align="center"><%=CicloGrupo.getGrado()%></td>
    <td align="center"><%=CicloGrupo.getGrupo()%></td>
    <td align="left">
	  <strong><%= aca.plan.PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId())%></strong>
    </td>
    <td align="center"><%=numAlumnos%></td>
    <td align="center"><fmt:message key="aca.${bim1}" /></td>
    <td align="center"><fmt:message key="aca.${bim2}" /></td>
    <td align="center"><fmt:message key="aca.${bim3}" /></td>
    <td align="center"><fmt:message key="aca.${bim4}" /></td>
    <td align="center"><fmt:message key="aca.${bim5}" /></td>
  </tr>
<% 
	} //fin de for
%>  
</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 