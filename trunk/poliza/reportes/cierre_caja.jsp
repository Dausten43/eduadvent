<%@page import="java.util.HashMap"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<html>
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaIni 		= request.getParameter("FechaIni")==null?fechaHoy:request.getParameter("FechaIni");
	String fechaFin 		= request.getParameter("FechaFin")==null?fechaHoy:request.getParameter("FechaFin");
	
	String nombre			= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
	String asociacion		= aca.catalogo.CatAsociacion.getAsociacionNombre(conElias, escuelaId);
	String estado 			= "'T','C','A'";
	String tipo				= "'G','C','I'";
	double saldo 			= aca.fin.FinMovimientos.saldoPolizas(conElias, escuelaId, estado, tipo, fechaIni, fechaFin, "D"); 	
%>
<body>
<div id="content">
	<h2>Cierre de Caja ( <small><%=asociacion %> - <%=nombre%></small> )</h2>
	<form name="frmCierre" id="frmCierre" method="post" action="cierre_caja.jsp">
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		Fecha Inicial:
		<input name="FechaIni" type="text" id="FechaIni" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="FechaFin" type="text" id="FechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		<a onclick="javascript:document.frmCierre.submit();" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
	</div>
	</form>		
	<table class="table  table-bordered">
		<tr>
			<th>&nbsp;</th>
			<th style="text-align:right">D&eacute;bito</th>
			<th style="text-align:right">Cr&eacute;dito</th>
		</tr>
		<tr>
			<td>CAJA GENERAL</td>
			<td style="text-align:right"><%=saldo %></td>
			<td style="text-align:right"></td>
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
		<td style="text-align:right">&nbsp;</td>
		<td style="text-align:right"><%=saldos %></td>
	</tr>
<%} %>
	<tr>
		<td>Totales</td>
		<td style="text-align:right"><%=saldo %></td>
		<td style="text-align:right"><%=totSaldos %></td>
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
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<script>
	jQuery('#FechaIni').datepicker();
	jQuery('#FechaFin').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>