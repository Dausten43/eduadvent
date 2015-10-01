<%@page import="java.util.HashMap"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>
<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<html>
<%
String fechaHoy 		= aca.util.Fecha.getHoy();
String fechaIni 		= request.getParameter("fechaInicio")==null?fechaHoy:request.getParameter("fechaInicio");
String fechaFin 		= request.getParameter("fechaFin")==null?fechaHoy:request.getParameter("fechaFin");
String escuelaId 		= (String) session.getAttribute("escuela");
String nombre			= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
String asociacion		= aca.catalogo.CatAsociacion.getAsociacionNombre(conElias, escuelaId);
String estado 	= "'T','C'";
String tipo		="'G','C','I'";
double saldo 			= aca.fin.FinMovimientos.saldoPolizas(conElias, escuelaId, estado, tipo, fechaIni, fechaFin, "D"); 
	
%>
<body>
<div id="content">
	<h1>Reporte <small>Cierre de Caja Gral.</small></h1>
	<form name="frmPuestos" id="frmPuestos" method="post" action="cierre_caja.jsp">
	<div class="well">
		Fecha Inicial:
		<input name="fechaInicio" type="text" id="fechaInicio" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="fechaFin" type="text" id="fechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		<a onclick="javascript:document.frmPuestos.submit();" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
	</div>
	</form>
	
	<h2 style="text-align: center;">
		<%=asociacion %>
	</h2>
	<h3 style="text-align: center;"><%=nombre %> <br> Cierre de caja General</h3>
	<table class="table  table-bordered">
		<tr>
			<th></th>
			<th style="text-align:center">D&eacute;bito</th>
			<th style="text-align:center">Cr&eacute;dito</th>
		</tr>
		<tr>
			<td>CAJA GENERAL</td>
			<td><%=saldo %></td>
			<td></td>
		</tr>
<%
	ArrayList<aca.fin.FinCuenta> lisCuenta = FinCuentaLista.getListCuentas(conElias, escuelaId, "ORDER BY CUENTA_ID");
	HashMap<String, String> mapSaldos = aca.fin.FinMovimientosLista.saldoPolizasPorCuentas(conElias, escuelaId, estado, tipo, fechaIni, fechaFin, "D");
	double totSaldos = 0.0;
	for(aca.fin.FinCuenta cuentas : lisCuenta){
		String saldos = "";
		if(mapSaldos.containsKey(cuentas.getCuentaId())){
			saldos = mapSaldos.get(cuentas.getCuentaId());
			totSaldos += Double.parseDouble(saldos);
		}
%>
	<tr>
		<td><%=cuentas.getCuentaNombre() %></td>
		<td></td>
		<td><%=saldos %></td>
	</tr>
<%} %>
	<tr>
		<td>Totales</td>
		<td><%=saldo %></td>
		<td><%=totSaldos %></td>
	</tr>
	</table>
</div>
</body>
</html>
<style>
	body{
		background:white;
	}
</style>
<script>
	jQuery('#fechaInicio').datepicker();
	jQuery('#fechaFin').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>