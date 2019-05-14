<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="alumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="EmpPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="AlumPadres" scope="page" class="aca.alumno.AlumPadres"/>

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
			<%
				cont++;
				boolean tutorConUsuario = false;
				AlumPadres.setCodigoId(alumno.getCodigoId());
				if(AlumPadres.existeReg(conElias)){
					AlumPadres.mapeaRegId(conElias, alumno.getCodigoId());
					tutorConUsuario = true;
					if(!AlumPadres.getCodigoTutor().equals("") || !AlumPadres.getCodigoTutor().equals("-"))
						EmpPersonal.mapeaRegId(conElias, AlumPadres.getCodigoTutor());
					if(!AlumPadres.getCodigoMadre().equals("") || !AlumPadres.getCodigoMadre().equals("-"))
						EmpPersonal.mapeaRegId(conElias, AlumPadres.getCodigoMadre());
					if(!AlumPadres.getCodigoPadre().equals("") || !AlumPadres.getCodigoPadre().equals("-"))
						EmpPersonal.mapeaRegId(conElias, AlumPadres.getCodigoPadre());
				}
			%>
			<tr>
				<td><%=cont %></td>
				<td><%=alumno.getCodigoId() %></td>
				<td><%=alumno.getApaterno() %> <%=alumno.getAmaterno() %> <%=alumno.getNombre() %></td>
				<td><%=alumno.getNivelId() %></td>
				<td><%=alumno.getGrado() %></td>
				<td><%=alumno.getGrupo() %></td>
				<td><%=alumno.getFNacimiento() %></td>
				<td><%=alumno.getGenero() %></td>
				<td><%=EmpPersonal.getCodigoId().equals("")? alumno.getDireccion() == null ? "-" : alumno.getDireccion() : EmpPersonal.getDireccion() %></td>
				<td><%=EmpPersonal.getCodigoId().equals("")? alumno.getTelefono()  == null ? "-" : alumno.getTelefono()  : EmpPersonal.getTelefono() %></td>
				<td><%=alumno.getCelular() == null ? "-" : alumno.getCelular() %></td>
				<td><%=tutorConUsuario?EmpPersonal.getNombre()+" "+EmpPersonal.getApaterno()+" "+EmpPersonal.getAmaterno() : alumno.getTutor() == null? "-" : alumno.getTutor()%></td>
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