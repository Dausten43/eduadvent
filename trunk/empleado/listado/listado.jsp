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
	String sBgcolor			= "";
	ArrayList<aca.empleado.EmpPersonal> lisEmp 	= empleadoU.getListEscuela(conElias, escuelaId," AND SUBSTR(CODIGO_ID,4,1)='E' ORDER BY SUBSTR(CODIGO_ID,1,3),APATERNO,AMATERNO,NOMBRE");
%>

<div id="content">
<h2><fmt:message key="empleados.ListadodeEmpleados" /></h2>
	<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>	 
	<table class="table table-condensed table-bordered" id="table">
		     <thead>
				  <tr>
					<th width="3%">#</th>
					<th width="10%"><fmt:message key="aca.Codigo" /></th>
					<th width="24%"><fmt:message key="aca.Nombre" /></th>
					<th width="24%"><fmt:message key="aca.Direccion" /></th>		
					<th width="12%"><fmt:message key="aca.Telefono" /></th>					
					<th width="13%"><fmt:message key="aca.Estado" /></th>	
					<th width="17%"><fmt:message key="aca.Iglesia" /></th>				
				  </tr>
			 </thead>
<%	if(lisEmp.size() > 0){
	
				for (int i=0; i< lisEmp.size(); i++){
					aca.empleado.EmpPersonal emp = (aca.empleado.EmpPersonal) lisEmp.get(i);
					
					if ((cont % 2) == 0){
						sBgcolor = "";
					}else{ 
						sBgcolor = ""; 
					}
			%>
			  <tr <%=sBgcolor%>>
				<td align="center"><%=cont+1%></td>
				<td align="center"><%=emp.getCodigoId()%></td>
				<td><%=emp.getApaterno()%> <%=emp.getAmaterno()%>, <%=emp.getNombre()%> </td>
				<td><%=emp.getDireccion()==null?"-":emp.getDireccion()%> <b><fmt:message key="aca.Col" /> <%=emp.getColonia()==null?"-":emp.getColonia() %></b></td>
				<td><%=emp.getTelefono()==null?"-":emp.getTelefono()%></td>				
				<td><%=emp.getEstado().equals("A")?"Activo":"Inactivo"%></td>	
				<td><%=emp.getIglesia()==null?"-":emp.getIglesia()%></td>						
			  </tr>
			<%cont++; 
				} //fin del for%>
		  </table>
<%}else{%>
	<div  class='alert alert-error'>
		<h2 align="center"><fmt:message key="aca.NoHayEmpleados" /></h2>
	</div>
<%	} %>
</div>


<link rel="stylesheet" href="../../js-plugins/tablesorter/themes/blue/style.css" />
<script src="../../js-plugins/tablesorter/jquery.tablesorter.js"></script>


<script src="../../js/search.js"></script>

<script>
	$('#table').tablesorter();

	$('#buscar').search({
		table:$("#table")}
	);
</script>

<%@ include file= "../../cierra_elias.jsp" %>