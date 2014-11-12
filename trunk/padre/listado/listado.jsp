<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empleado" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="empleadoU" scope="page" class="aca.empleado.EmpPersonalLista"/>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	int cont				= 0;	
	
	ArrayList<aca.empleado.EmpPersonal> lisEmp 		= new ArrayList<aca.empleado.EmpPersonal>();
	lisEmp = empleadoU.getListEscuela(conElias, escuelaId," AND SUBSTR(CODIGO_ID,4,1)='P' ORDER BY SUBSTR(CODIGO_ID,1,3),APATERNO,AMATERNO,NOMBRE");
%>
<html>
<head>
<link rel="stylesheet" href="../../css/style.css" />

</head>
<body>
<div id="content">
<h2><fmt:message key="maestros.ListadodePadres" /></h2>
<hr>
<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>	 
<table class="table  table-striped" id="table">
		     <thead>
			  <tr>
				<th width="3%">#</th>
				<th width="10%"><fmt:message key="aca.Codigo" /></th>
				<th width="30%"><fmt:message key="aca.Nombre" /></th>
				<th width="30%"><fmt:message key="aca.Direccion" /></th>		
				<th width="15%"><fmt:message key="aca.Telefono" /></th>
				<th width="15%"><fmt:message key="aca.Correo" />1</th>
				<th width="15%"><fmt:message key="aca.Correo" />2</th>
			  </tr>
			  </thead>
		  
<%
	if(lisEmp.size() > 0){
				for (int i=0; i< lisEmp.size(); i++){
					aca.empleado.EmpPersonal emp = (aca.empleado.EmpPersonal) lisEmp.get(i);					
%>
			  <tr>
				<td align="center"><%=cont+1%></td>
				<td align="center"><%=emp.getCodigoId()%></td>
				<td><%=emp.getApaterno()%> <%=emp.getAmaterno()%>, <%=emp.getNombre()%> </td>
				<td><%=emp.getDireccion()==null?"-":emp.getDireccion()%> <b><fmt:message key="aca.Col" /> <%=emp.getColonia()==null?"-":emp.getColonia()%></b></td>
				<td><%=emp.getTelefono()==null?"-":emp.getTelefono()%></td>
				<td><%= emp.getEmail()==null?"-":emp.getEmail()%></td>
				<td><%= aca.alumno.AlumPadres.getCorreo(conElias, emp.getCodigoId()) %></td>
			  </tr>
			<%cont++; 
				} //fin del for%>
</table>

<%}else{%>
	<div  class='alert alert-error'>
		<h2 align="center"><fmt:message key="aca.NoPadresRegistrados" /></h2>
	</div>
<%	} %>	
</div>
</body>
<script src="../../js/search.js"></script>
<script>
	$('#buscar').search({table:$("#table")});
</script>
</html>
<%@ include file= "../../cierra_elias.jsp" %>