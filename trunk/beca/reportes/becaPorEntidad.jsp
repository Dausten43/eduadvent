<%@page import="java.util.HashMap"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="entidadL" scope="page" class="aca.beca.BecEntidadLista"/>
<jsp:useBean id="entidad" scope="page" class="aca.beca.BecEntidad"/>
<jsp:useBean id="becaAlumno" scope="page" class="aca.beca.BecAlumno"/>
<html>

<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	ArrayList<aca.beca.BecEntidad> listaEntidades	= entidadL.getListAll(conElias, escuelaId, "ORDER BY ENTIDAD_ID");
	
	int con 				= 1;
	float total 			= 0;
%>
<div id="content">
	<h2>Entidades</h2>
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
	</div>
	<table class="table table-striped">
		<tr>
			<th>#</th>
			<th>Entidad</th>
			<th>Total beca</th>
		</tr>
<%
	for(aca.beca.BecEntidad entidades : listaEntidades){
		entidad.mapeaRegId(conElias, entidades.getEntidadId());
		String cantidad = becaAlumno.cantidadTotalBecas(conElias, entidades.getEntidadId())==null?"0":becaAlumno.cantidadTotalBecas(conElias, entidades.getEntidadId());			
		total = total + Float.parseFloat(cantidad);
%>
		<tr>
			<td><%=con++ %></td>
			<td><%=entidad.getEntidadNombre() %></td>
			<td><%=cantidad  %></td>
		</tr>
<%	
	}
%>
		<tr>
			<td colspan="2" ><h3>Total</h3></td>
			<td><h3><%=total %></h3></td>
		</tr>
	</table>

</div>
<%@ include file= "../../cierra_elias.jsp" %>