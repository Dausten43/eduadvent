<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoCurso"%>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="Empleado" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="EmpleadoLista" scope="page" class="aca.empleado.EmpPersonalLista"/>
<head>
	<script>
	
		function materias(empleadoId,cicloId){
			document.location.href="materias.jsp?EmpleadoId="+empleadoId+"&CicloId="+cicloId;
		}
			
	</script>
</head>
<%
	String codigoId			= (String) session.getAttribute("codigoId");
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String strBgcolor		= "";
	
	ArrayList lisMaestro		= new ArrayList();
	lisMaestro 				= EmpleadoLista.getListMaestrosCiclo(conElias, escuelaId, cicloId, " ORDER BY EMP_APELLIDO(CODIGO_ID)");
	int i=0, numMat=0;
	int bim1=0,bim2=0,bim3=0,bim4=0,bim5=0, suma=0;
	double avance = 0;
%>
<body>
<table width="70%" border="0" align="center">
  <tr><td align=center colspan="9"><font size="3"><strong><fmt:message key="maestros.AvanceNotas" /></strong><font></td></tr>
  <tr><td align="center" colspan="9"><strong><%=aca.ciclo.Ciclo.nombreCiclo(conElias,cicloId)%></strong></td></tr>
  <tr><td align="left" colspan="9">&nbsp;</td></tr>
  <tr>
    <td align="center" colspan="3">&nbsp;</td>
    <td align="center" colspan="5"><strong><fmt:message key="maestros.EvaluadasEnBimestre" /></strong></td>
    <td>&nbsp;</td>
  </tr>  
  <tr bgcolor="#C8D4A3">
    <th width="5%" align="center">#</th>
    <th width="40%" align="center"><fmt:message key="aca.Maestro" /></th>
    <th width="8%" align="center"># <fmt:message key="aca.Mat" /></th>
	<th width="8%" align="center">1° <fmt:message key="aca.Bim" /></th>
	<th width="8%" align="center">2° <fmt:message key="aca.Bim" /></th>
	<th width="8%" align="center">3° <fmt:message key="aca.Bim" /></th>
	<th width="8%" align="center">4° <fmt:message key="aca.Bim" /></th>
	<th width="8%" align="center">5° <fmt:message key="maestros.Bim" /></th>
	<th width="7%" align="center">%</th>
  </tr>
<%
	for (i=0;i<lisMaestro.size();i++){
		aca.empleado.EmpPersonal emp = (aca.empleado.EmpPersonal) lisMaestro.get(i);
		 if ((i % 2) == 0 ) strBgcolor = strColor; else strBgcolor = "";
		 bim1=0; bim2=0; bim3=0; bim4=0; bim5=0;
		 
		 numMat = aca.ciclo.CicloGrupoCurso.numCursosMaestro(conElias, cicloId, emp.getCodigoId());
		 
		 bim1 = aca.ciclo.CicloGrupoCurso.numCursosEvaluados(conElias, cicloId, emp.getCodigoId(),1);
		 bim2 = aca.ciclo.CicloGrupoCurso.numCursosEvaluados(conElias, cicloId, emp.getCodigoId(),2);
		 bim3 = aca.ciclo.CicloGrupoCurso.numCursosEvaluados(conElias, cicloId, emp.getCodigoId(),3);
		 bim4 = aca.ciclo.CicloGrupoCurso.numCursosEvaluados(conElias, cicloId, emp.getCodigoId(),4);
		 bim5 = aca.ciclo.CicloGrupoCurso.numCursosEvaluados(conElias, cicloId, emp.getCodigoId(),5);
		 
		 suma = bim1+bim2+bim3+bim4+bim5;
		 avance = (double) (suma*100) / (numMat*5);
%>    
  <tr <%=strBgcolor%> onclick="materias('<%=emp.getCodigoId()%>','<%=cicloId%>');" style="cursor:pointer;" onmouseover="this.style.backgroundColor='#CCE8FF';" onmouseout="this.style.backgroundColor='';">
    <td align="left"><strong><%=i+1%></strong></td>
    <td align="left">
	  <strong><%=emp.getApaterno()%> <%=emp.getAmaterno()%>, <%=emp.getNombre()%></strong>
    </td>
    <td align="center"><%=numMat%></td>
    <td align="center"><%=bim1%></td>
    <td align="center"><%=bim2%></td>
    <td align="center"><%=bim3%></td>
    <td align="center"><%=bim4%></td>
    <td align="center"><%=bim5%></td> 
    <td align="center"><%=String.valueOf(avance).substring(0,String.valueOf(avance).indexOf(".")+2)%></td>
  </tr>
<% 
	} //fin de for
%>  
</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 