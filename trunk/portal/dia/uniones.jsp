<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="CatUnionLista" scope="page" class="aca.catalogo.CatUnionLista"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoId 		= (String)session.getAttribute("codigoId");
	int row = 0;
	
	ArrayList<aca.catalogo.CatUnion> lisUnion = CatUnionLista.getListAll(conElias, "ORDER BY LETRA");
	
	/* HashMap que obtiene el numero de asociaciones */
	java.util.HashMap<String,String> mapAsociacion	= CatUnionLista.mapaAsociaciones(conElias);
	
	/* HashMap que obtiene el numero de escuelas */
	java.util.HashMap<String,String> mapEscuela	= CatUnionLista.mapaEscuelas(conElias);
	
	/* HashMap que obtiene el numero de empleados */
	java.util.HashMap<String,String> mapEmpleado	= CatUnionLista.mapaEmpleados(conElias);
%>

<div id="content">
	<h2>División Interamericana <small>Listado de Uniones</small></h2>

	<table class="table table-bordered table-striped">
	<tr>
		<th><h5>#</h5></th>
		<th><h5>Clave</h5></th>
		<th><h5>Nombre</h5></th>
		<th style="text-align:right"><h5>Asociaciones</h5></th>
		<th style="text-align:right"><h5>Escuelas</h5></th>
		<th style="text-align:right"><h5>Empleados</h5></th>
	</tr>	
<%
	int totAso	= 0;
	int totEsc	= 0;
	int totEmp	= 0;

	for( aca.catalogo.CatUnion union: lisUnion){
		row++;
		
		// Buscar el numero de asociacione en la union
		String asociacion = "0";
		if ( mapAsociacion.containsKey(union.getUnionId()) ) asociacion = mapAsociacion.get(union.getUnionId());
		totAso += Integer.parseInt(asociacion);
		
		// Buscar el numero de asociacione en la union
		String escuela = "0";
		if ( mapEscuela.containsKey(union.getUnionId()) ) escuela = mapEscuela.get(union.getUnionId());
		totEsc += Integer.parseInt(escuela);
		
		// Buscar el numero de asociacione en la union
		String empleado = "0";
		if ( mapEmpleado.containsKey(union.getUnionId()) ) empleado = mapEmpleado.get(union.getUnionId());
		totEmp += Integer.parseInt(empleado);
%>	
	<tr>
		<td><%= row %></td>
		<td><%= union.getLetra() %></td>
		<td><a href="asociaciones.jsp?UnionId=<%=union.getUnionId()%>"><%= union.getUnionNombre()%></a></td>
		<td style="text-align:right"><%=asociacion%></td>
		<td style="text-align:right"><%=escuela%></td>
		<td style="text-align:right"><%=empleado%></td>
	</tr>
<%	}%>	
	<tr>
		<th colspan="3" style="text-align:center;"> T O T A L E S</td>
		<th style="text-align:right"><%=totAso%></th>
		<th style="text-align:right"><%=totEsc%></th>
		<th style="text-align:right"><%=totEmp%></th>
	</tr>
	</table>
</div>
<script>
	jQuery('.uniones').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>