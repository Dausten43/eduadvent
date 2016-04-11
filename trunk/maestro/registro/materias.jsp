<%@page import="aca.catalogo.CatEscuelaLista"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ page import= "java.util.* "%>

<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>

<head>
<script>
	function materia(cicloGrupoId,cursoId){
		document.location.href="materia.jsp?CicloGrupoId="+cicloGrupoId+"&CursoId="+cursoId;
	}
	function promMeses(cicloGrupoId,cursoId){
		document.location.href="promediarMeses.jsp?CicloGrupoId="+cicloGrupoId+"&CursoId="+cursoId;
	}
</script>
<%	
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	ArrayList lisGrupoCurso	= GrupoCursoLista.getListMateriasGrupo(conElias, cicloGrupoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	String idEscuela		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	
	String strBgcolor		= "";
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias,cicloGrupoId);
%>
</head>
<body>
<div id="content">
<h2><fmt:message key="maestros.MateriasPorGrupo" /></h2>
<div class="well">
<a href="grupo.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
</div>
<h4><fmt:message key="aca.Maestro" />( <fmt:message key="maestros.ConsejeroDeGrupo" /> ): [ <%=Grupo.getEmpleadoId()%> ] - <%=aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(),"NOMBRE")%></h4>
	<table align="center" class="table table-condensed table-nohover" width="80%">
	<tr>
		<th align="center" width="4%">#</th>
		<th align="center" width="25%"><fmt:message key="aca.Materias" /></th>
		<th align="center" width="25%"><fmt:message key="aca.Maestro" /></th>
		<th align="center" width="8%"><fmt:message key="aca.Evaluaciones" /></th>
		<th align="center" width="8%"><fmt:message key="aca.PromMeses" /></th>
	</tr>
	<% 
	for (int j=0;j<lisGrupoCurso.size();j++){
		aca.ciclo.CicloGrupoCurso grupoCurso = (aca.ciclo.CicloGrupoCurso) lisGrupoCurso.get(j);
		if ((j % 2) == 0 ) strBgcolor = "bgcolor = '#E6E6E6'"; else strBgcolor = "";

		ArrayList listEstrategias 	= GrupoEvalL.getArrayList(conElias, cicloGrupoId, grupoCurso.getCursoId(), "ORDER BY ORDEN");
%>
	<tr >
		<td align="center"><b><%=j+1%></b></td>
    	<td align="left" style="cursor:pointer;cursor:hand;" class="well" onclick="materia('<%=cicloGrupoId%>','<%=grupoCurso.getCursoId()%>');"><strong>&nbsp;&nbsp;<%=aca.plan.PlanCurso.getCursoNombre(conElias,grupoCurso.getCursoId())%></strong></td>
    	<td align="left"><strong>&nbsp;&nbsp;[ <%=grupoCurso.getEmpleadoId()%> ] - <%= aca.empleado.EmpPersonal.getNombre(conElias, grupoCurso.getEmpleadoId(), "NOMBRE") %></strong></td>
    	<td align="center"><b><%=listEstrategias.size() %></b></td>
    	<%
    	if(aca.ciclo.Ciclo.getModulos(conElias, cicloId)==10){%>
    		<td style="text-align:center; cursor:pointer;" onclick="promMeses('<%=cicloGrupoId%>','<%=grupoCurso.getCursoId()%>');" onmouseover="this.style.backgroundColor='#F2F2F2';" onmouseout="this.style.backgroundColor='';"><img src="../../imagenes/ir.png" width="28px" height="22px"/></td>
    	<%} %>
        
    <tr>
<%    
    }%>
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 