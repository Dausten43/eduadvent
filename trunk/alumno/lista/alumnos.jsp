<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="alumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>

<%
	
	String escuelaId		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoPersonal");
	
	ArrayList<aca.alumno.AlumPersonal> alumnos = alumPersonalL.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID, GRADO, GRUPO, APATERNO, AMATERNO, NOMBRE");
	
%>

<div id="content">
	<h2>
		<fmt:message key="aca.Alumnos" />
	</h2>
	
	<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>	 
	<table class="table table-condensed table-bordered" id="table">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Codigo" /></th>
				<th><fmt:message key="aca.Nombre" /></th>		
				<th><fmt:message key="aca.Nivel" /></th>
				<th><fmt:message key="aca.Grado" /></th>
				<th><fmt:message key="aca.Grupo" /></th>
				<th><fmt:message key="aca.FechadeNacimiento" /></th>
				<th><fmt:message key="aca.Genero" /></th>
				<th><fmt:message key="aca.Direccion" /></th>
				<th><fmt:message key="aca.Telefono" /></th>
				<th><fmt:message key="aca.CelularTutor" /></th>
				<th><fmt:message key="aca.Tutor" /></th>
				<th><fmt:message key="aca.CIP" /></th>
			</tr>
		</thead>
		<%int cont=0; %>
		<%for(aca.alumno.AlumPersonal alumno : alumnos){ %>
			<%cont++; %>
			<tr>
				<td><%=cont %></td>
				<td><%=alumno.getCodigoId() %></td>
				<td><%=alumno.getApaterno() %> <%=alumno.getAmaterno() %> <%=alumno.getNombre() %></td>
				<td><%=alumno.getNivelId() %></td>
				<td><%=alumno.getGrado() %></td>
				<td><%=alumno.getGrupo() %></td>
				<td><%=alumno.getFNacimiento() %></td>
				<td><%=alumno.getGenero() %></td>
				<td><%=alumno.getDireccion() %></td>
				<td><%=alumno.getCelular() %></td>
				<td><%=alumno.getTelefono() %></td>
				<td><%=alumno.getTutor() %></td>
				<td><%=alumno.getCurp() %></td>
			</tr>
		<%} %>
	</table>	
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

<%@ include file="../../cierra_elias.jsp"%>