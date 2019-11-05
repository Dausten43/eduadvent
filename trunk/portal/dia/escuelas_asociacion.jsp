<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="escuelaL" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="empleadoL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="alumInscritoL" scope="page" class="aca.vista.AlumInscritoLista"/>
<jsp:useBean id="CatAsociacion" scope="page" class="aca.catalogo.CatAsociacion"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)");

	String codigoId 		= (String)session.getAttribute("codigoId");
	String asociacion		= request.getParameter("asociacion")==null?"1":request.getParameter("asociacion");
	CatAsociacion.mapeaRegId(conElias, asociacion);
	int row = 0;
	
	ArrayList<aca.catalogo.CatEscuela> lisEscuelas = escuelaL.getListAsociacion(conElias, asociacion, "ORDER BY ESCUELA_ID");
	
	/* HashMap que obtiene el numero de empleados */
	java.util.HashMap<String,String> mapEmpleado	= empleadoL.mapaEmpleadosPorEscuela(conElias, asociacion);
	
	/* HashMap que obtiene el numero de empleados */
	java.util.HashMap<String,String> mapAlumnos	= alumInscritoL.mapaAlumnosPorEscuela(conElias, asociacion);
%>

<div id="content">
	<h2>DIA-<%=aca.catalogo.CatAsociacion.getNombre(conElias, asociacion)%><small>Listado de Escuelas </small></h2>
	<div class="well">
		<a href="asociaciones.jsp?UnionId=<%=CatAsociacion.getUnionId()%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	<table class="table table-bordered table-striped">
	<tr>
		<th><h5>#</h5></th>		
		<th><h5>Nombre</h5></th>		
		<th style="text-align:right"><h5>Alumnos</h5></th>
		<th style="text-align:right"><h5>Empleados</h5></th>
	</tr>	
<%	
	int totAlm	= 0;
	int totEmp	= 0;
	for( aca.catalogo.CatEscuela escuelas: lisEscuelas){
		row++;		
				
		// Buscar el numero de escuelas en la asociacion
		String alumnos = "0";
		if ( mapAlumnos.containsKey(escuelas.getEscuelaId()) ) alumnos = mapAlumnos.get(escuelas.getEscuelaId());
		totAlm += Integer.parseInt(alumnos);
		
		// Buscar el numero de empleados en la asociacion
		String empleado = "0";
		if ( mapEmpleado.containsKey(escuelas.getEscuelaId()) ) empleado = mapEmpleado.get(escuelas.getEscuelaId());
		totEmp += Integer.parseInt(empleado);
%>	
	<tr>
		<td><%= row %></td>		
		<td><%= escuelas.getEscuelaNombre()%></td>		
		<td style="text-align:right"><%=alumnos%></td>
		<td style="text-align:right"><%=empleado%></td>
	</tr>
<%	}%>	
	<tr>
		<th colspan="2" style="text-align:center;"> T O T A L E S</td>		
		<th style="text-align:right"><%=totAlm%></th>
		<th style="text-align:right"><%=totEmp%></th>
	</tr>
	</table>
</div>
<script>
	jQuery('.uniones').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>