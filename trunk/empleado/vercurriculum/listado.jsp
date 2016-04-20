<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empCurriculum" class="aca.empleado.EmpCurriculum" scope="page"/>
<jsp:useBean id="empCurriculumU" class="aca.empleado.EmpCurriculumLista" scope="page"/>

<%
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");		
		
	ArrayList<aca.empleado.EmpCurriculum> listCurriculum = empCurriculumU.getListAll(conElias, "ORDER BY EMP_NOMBRE(ID_EMPLEADO)");	
%>
<body>
<div id="content">
<h2><fmt:message key="empleados.ProfesoresconCurriculum" /></h2>
	<table width="50%" align="center" class="table table-striped">
		<tr>
			<th width="30px">#</th>
			<th width="80px"><fmt:message key="aca.Nomina" /></th>
			<th><fmt:message key="aca.Nombre" /></th>
		</tr>
<%
	for(int i = 0; i < listCurriculum.size(); i++){
		empCurriculum = (aca.empleado.EmpCurriculum) listCurriculum.get(i);
		
		if(((String)session.getAttribute("escuela")).equals(empCurriculum.getIdEmpleado().substring(1,3))){		
%>
		<tr class="button" onclick="location.href='vitaePdf.jsp?codigoPersonal=<%=empCurriculum.getIdEmpleado() %>';">
			<td width="30px" align="center"><%=i+1 %></td>
			<td width="80px" align="center"><%=empCurriculum.getIdEmpleado() %></td>
			<td><%= aca.empleado.EmpPersonal.getNombre(conElias, empCurriculum.getIdEmpleado(), "NOMBRE") %></td>
		</tr>
<%		}
	}
%>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
	</table>
</div>
</body>
<script src="../../js/search.js"></script>
<%@ include file= "../../cierra_elias.jsp" %>