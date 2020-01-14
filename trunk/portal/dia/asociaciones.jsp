<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="CatAsociacionLista" scope="page" class="aca.catalogo.CatAsociacionLista"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoId 		= (String)session.getAttribute("codigoId");
	String unionId			= request.getParameter("UnionId");
	int row = 0;
	
	ArrayList<aca.catalogo.CatAsociacion> lisAsociacion = CatAsociacionLista.getListUnion(conElias, unionId, "ORDER BY ASOCIACION_NOMBRE");
	
	/* HashMap que obtiene el numero de escuelas */
	java.util.HashMap<String,String> mapEscuela	= CatAsociacionLista.mapaEscuelas(conElias, unionId);
	
	/* HashMap que obtiene el numero de empleados */
	java.util.HashMap<String,String> mapEmpleado	= CatAsociacionLista.mapaEmpleados(conElias, unionId);
%>

<div id="content">
	<h2>DIA-<%=aca.catalogo.CatUnion.getNombre(conElias, unionId)%><small>Listado de Asociaciones</small></h2>
	<div class="well">
		<a href="uniones.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	<table class="table table-bordered table-striped">
	<tr>
		<th><h5>#</h5></th>		
		<th><h5>Nombre</h5></th>		
		<th style="text-align:right"><h5>Escuelas</h5></th>
		<th style="text-align:right"><h5>Empleados</h5></th>
	</tr>	
<%	
	int totEsc	= 0;
	int totEmp	= 0;
	for( aca.catalogo.CatAsociacion asociacion: lisAsociacion){
		row++;		
				
		// Buscar el numero de escuelas en la asociacion
		String escuela = "0";
		if ( mapEscuela.containsKey(asociacion.getAsociacionId()) ) escuela = mapEscuela.get(asociacion.getAsociacionId());
		totEsc += Integer.parseInt(escuela);
		
		// Buscar el numero de empleados en la asociacion
		String empleado = "0";
		if ( mapEmpleado.containsKey(asociacion.getAsociacionId()) ) empleado = mapEmpleado.get(asociacion.getAsociacionId());
		totEmp += Integer.parseInt(empleado);
%>	
	<tr>
		<td><%= row %></td>		
		<td><a href="escuelas_asociacion.jsp?asociacion=<%=asociacion.getAsociacionId()%>"><%= asociacion.getAsociacionNombre()%></a></td>		
		<td style="text-align:right"><%=escuela%></td>
		<td style="text-align:right"><%=empleado%></td>
	</tr>
<%	}%>	
	<tr>
		<th colspan="2" style="text-align:center;"> T O T A L E S</td>		
		<th style="text-align:right"><%=totEsc%></th>
		<th style="text-align:right"><%=totEmp%></th>
	</tr>
	</table>
</div>
<script>
	jQuery('.uniones').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>