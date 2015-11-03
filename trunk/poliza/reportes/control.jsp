<%@page import="java.util.HashMap"%>
<%@page import="aca.util.Fecha"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="FinCalculoPagoLista" scope="page" class="aca.fin.FinCalculoPagoLista"/>
<jsp:useBean id="CatNivelEscuelaLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<html>
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaIni 		= request.getParameter("FechaIni")==null?fechaHoy:request.getParameter("FechaIni");
	String fechaFin 		= request.getParameter("FechaFin")==null?fechaHoy:request.getParameter("FechaFin");
	
	String nombre			= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
	String asociacion		= aca.catalogo.CatAsociacion.getAsociacionNombre(conElias, escuelaId);
	

	ArrayList<aca.catalogo.CatNivelEscuela> listEscuelaNivel = CatNivelEscuelaLista.getListEscuela(conElias, escuelaId, "");
	java.util.HashMap <String, String> mapFinCalculoPago	 = FinCalculoPagoLista.mapNivelPago(conElias, escuelaId, fechaIni, fechaFin); 
	java.util.HashMap <String, String> mapFinCalculoPagoCaja = FinCalculoPagoLista.mapNivelPagoCaja(conElias, escuelaId, fechaIni, fechaFin, "C"); 
%>
<body>
<div id="content">
	<h1>Control de Alumno<small></small></h1>
	<form name="frmControl" id="frmControl" method="post" action="control.jsp">
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		Fecha Inicial:
		<input name="FechaIni" type="text" id="FechaIni" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="FechaFin" type="text" id="FechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		<a onclick="javascript:document.frmControl.submit();" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
	</div>
	</form>
		<h3><fmt:message key="aca.IngresosDiferidos" /></h3>
		<table class="table">
		<tr>
			<th><fmt:message key="aca.Nivel" /></th>
			<th style="text-align:right"><fmt:message key="aca.Debito" /></th>
			<th style="text-align:right"><fmt:message key="aca.Credito" /></th>
		</tr>
<% 
	float sum = 0;
	for(int x=0; x<listEscuelaNivel.size(); x++){
		if(mapFinCalculoPago.containsKey(listEscuelaNivel.get(x).getNivelId())){
			sum += Float.valueOf(mapFinCalculoPago.get(listEscuelaNivel.get(x).getNivelId()));		
		}
	}
%>	
		<tr>
				<td></td>
				<td style="text-align:right"><%=sum %></td>
				<td></td>
		</tr>		
				
<%	for(int x=0; x<listEscuelaNivel.size(); x++){%>
	<tr>
<%	if(mapFinCalculoPago.containsKey(listEscuelaNivel.get(x).getNivelId())){
			%>
			<td style="text-align:left"><%=listEscuelaNivel.get(x).getNivelNombre()%></td>
			<td style="text-align:right"></td>
			<td style="text-align:right"><%=mapFinCalculoPago.get(listEscuelaNivel.get(x).getNivelId())%></td>
<%}
%>	
	</tr>
		
<%}%>
	</table>

		<h3><fmt:message key="aca.IngresosDiferidos" /></h3>
		<table class="table">
		<tr>
			<th><fmt:message key="aca.Nivel" /></th>
			<th style="text-align:right"><fmt:message key="aca.Debito" /></th>
			<th style="text-align:right"><fmt:message key="aca.Credito" /></th>
		</tr>
<% 
	sum = 0;
	for(int x=0; x<listEscuelaNivel.size(); x++){
		if(mapFinCalculoPagoCaja.containsKey(listEscuelaNivel.get(x).getNivelId())){
		sum += Float.valueOf(mapFinCalculoPagoCaja.get(listEscuelaNivel.get(x).getNivelId()));		
	}
	}
%>	
		<tr>
				<td></td>
				<td style="text-align:right"><%=sum %></td>
				<td></td>
		</tr>		
				
<%	for(int x=0; x<listEscuelaNivel.size(); x++){%>
	<tr>
<%	if(mapFinCalculoPagoCaja.containsKey(listEscuelaNivel.get(x).getNivelId())){
			%>
			<td style="text-align:left"><%=listEscuelaNivel.get(x).getNivelNombre()%></td>
			<td style="text-align:right"></td>
			<td style="text-align:right"><%=mapFinCalculoPagoCaja.get(listEscuelaNivel.get(x).getNivelId())%></td>
<%}
%>	
	</tr>
		
<%}%>
	</table>


	
	<div class="center">
		<img src="../../imagenes/construyendo.png" />
	</div>	
</div>
</body>
</html>
<style>
	body{
		background:white;
	}
</style>

<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<script>
	jQuery('#FechaIni').datepicker();
	jQuery('#FechaFin').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>