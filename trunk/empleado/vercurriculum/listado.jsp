<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empCurriculumU" class="aca.empleado.EmpCurriculumLista" scope="page"/>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");		
		
	ArrayList<aca.empleado.EmpCurriculum> listCurriculum = empCurriculumU.lisEmpleados(conElias, escuelaId, " ORDER BY EMP_NOMBRE(ID_EMPLEADO)");	
%>
<body>
<div id="content">
<h2><fmt:message key="empleados.ProfesoresconCurriculum" /></h2>
	<table width="50%" align="center" class="table table-striped">
		<tr>
			<th width="30px">#</th>
			<th width="80px"><fmt:message key="aca.Nomina" /></th>
			<th><fmt:message key="aca.Nombre" /></th>
			<th>PDF</th>
		</tr>
<%
	for(int i = 0; i < listCurriculum.size(); i++){
		aca.empleado.EmpCurriculum vitae = (aca.empleado.EmpCurriculum) listCurriculum.get(i);			
%>
		<tr>
			<td width="30px" align="center"><%=i+1 %></td>
			<td width="80px" align="center"><%=vitae.getIdEmpleado() %></td>
			<td><%= aca.empleado.EmpPersonal.getNombre(conElias, vitae.getIdEmpleado(), "NOMBRE") %></td>
			<td><a href="vitaePdf.jsp?codigoPersonal=<%=vitae.getIdEmpleado()%>">Ver</a></td>
		</tr>
<%	
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