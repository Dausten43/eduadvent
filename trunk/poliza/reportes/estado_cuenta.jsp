<%@page import="aca.fin.FinMovimientos"%>
<%@page import="java.util.List"%>
<%@page import="aca.fin.FinMovimientosLista"%>
<%@page import="aca.fin.FinMovimientoLista"%>
<%@page import="aca.fin.FinCuenta"%>
<%@page import="java.util.HashMap"%>

<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@page import="aca.util.Fecha"%>
<style type="text/css" media="print">
@page {
	size: auto;
}

body {
	font-size: 8px !important;
}

table {
	border-collapse: collapse;
}

tr td {
	padding: 0px !important;
	margin: 0px !important;
}
</style>
<link rel="stylesheet" href="../../js/chosen/chosen.css" />
<style>
body {
	background: white;
}
</style>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<jsp:useBean id="FinCuentaLista" scope="page"
	class="aca.fin.FinCuentaLista" />
<html>
<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

		String escuelaId = (String) session.getAttribute("escuela");
		String fechaInicioMes = aca.util.Fecha.getInicioMes();
		String fechaHoy = aca.util.Fecha.getHoy();
		String fechaIni = request.getParameter("FechaIni") == null
				? fechaInicioMes
				: request.getParameter("FechaIni");
		String fechaFin = request.getParameter("FechaFin") == null
				? fechaHoy
				: request.getParameter("FechaFin");

		String nombre = aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
		String asociacion = aca.catalogo.CatAsociacion.getAsociacionNombre(conElias, escuelaId);
		String estado = "'T','C','A'";
		String tipo = "'C'";
		double saldo = aca.fin.FinMovimientos.saldoPolizas(conElias, escuelaId, estado, tipo, fechaIni,
				fechaFin, "C", "'R'");

		ArrayList<aca.fin.FinCuenta> lisCuenta = FinCuentaLista.getListCuentas(conElias, escuelaId,
				"ORDER BY CUENTA_nombre");
		//System.out.println("Datos:"+saldo+":"+escuelaId+":"+estado+":"+tipo+":"+fechaIni+":"+fechaFin);
%>

<body>
	<div class="container">
		<h2>
			Reporte de movimientos por cuenta<br>
			<small>( <%=asociacion%> - <%=nombre%> )
			</small>
		</h2>

		<form name="frmCierre" id="frmCierre" method="post"
			class="form-inline hidden-print" action="estado_cuenta.jsp">
			
				<a href="menu.jsp" class="btn btn-primary"><i
					class="icon-white icon-arrow-left"></i> Regresar</a>
			
			
				<select data-placeholder="Seleccione Cuenta..." name="cuenta"
					id="cuenta" class="chosen">
					<option></option>
					<%
						for (FinCuenta fc : lisCuenta) {
					%>
					<option data-nombre="<%=fc.getCuentaNombre()%>"
						value="<%=fc.getCuentaId()%>"
						<%=request.getParameter("cuenta") != null
							&& request.getParameter("cuenta").equals(fc.getCuentaId()) ? "selected" : ""%>><%=fc.getCuentaNombre()%></option>
					<%
						}
					%>
				</select> <label>Fecha Inicial:</label> <input name="FechaIni" type="text"
					id="FechaIni" size="15" maxlength="10"
					data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);"
					value="<%=fechaIni%>"
					style="margin-top: 5px; width: 100px; text-align: center;">
				<label>Fecha Final:</label> <input name="FechaFin" type="text"
					id="FechaFin" size="10" maxlength="10"
					data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);"
					value="<%=fechaFin%>"
					style="margin-top: 5px; width: 100px; text-align: center;">
				<a onclick="javascript:document.frmCierre.submit();"
					class="btn btn-primary"><i class="icon-white icon-search"></i> Generar</a>
		</form>

		<%
			if (request.getParameter("cuenta") != null && !request.getParameter("cuenta").equals("")) {
		%>
		<h4 id="titulo"></h4>
		<table class="table">
			<tr>
				<th>Fecha</th>
				<th>Póliza</th>
				<th>Recibo</th>
				<th>Referencia</th>
				<th>Auxiliar</th>
				<th>Descripción</th>
				<th style="text-align: right">D&eacute;bito</th>
				<th style="text-align: right">Cr&eacute;dito</th>
				<th style="text-align: right">Balance</th>
			</tr>

			<%
				BigDecimal creditos = BigDecimal.ZERO;
						BigDecimal debitos = BigDecimal.ZERO;
						BigDecimal saldoScreen = BigDecimal.ZERO;

						FinMovimientosLista fnm = new FinMovimientosLista();
						List<FinMovimientos> lsMvs = fnm.getAllMovimientosPoliza(conElias,
								" and to_date(to_char(fecha,'dd/mm/yyyy'),'dd/mm/yyyy') between to_date('"
										+ request.getParameter("FechaIni") + "','dd/mm/yyyy') and to_date('"
										+ request.getParameter("FechaFin") + "','dd/mm/yyyy') and cuenta_id='"
										+ request.getParameter("cuenta") + "' and estado<>'C' and auxiliar <>'-' order by cuenta_id");
						BigDecimal saldoCuenta = BigDecimal.ZERO; //  aca.fin.FinMovimientos.saldoPolizas(conElias,
								//request.getParameter("cuenta"), request.getParameter("FechaIni"));
						if (saldoCuenta.compareTo(BigDecimal.ZERO) >= 0) {
							debitos = debitos.add(saldoCuenta);
						} else {
							creditos = creditos.add(saldoCuenta.abs());
						}
						saldoScreen = saldoScreen.add(saldoCuenta);
			%>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>Saldo Anterior</td>
				<td style="text-align: right;"><%=saldoCuenta.compareTo(BigDecimal.ZERO) >= 0 ? saldoCuenta : ""%></td>
				<td style="text-align: right;"><%=saldoCuenta.compareTo(BigDecimal.ZERO) < 0 ? saldoCuenta.abs() : ""%></td>
				<td style="text-align: right;"><%=saldoScreen%></td>
			</tr>
			<%
				double totSaldos = 0.0;
						for (FinMovimientos movs : lsMvs) {
							String saldos = "0";
							creditos = creditos.add(
									movs.getNaturaleza().equals("C") ? new BigDecimal(movs.getImporte()) : BigDecimal.ZERO);
							debitos = debitos.add(
									movs.getNaturaleza().equals("D") ? new BigDecimal(movs.getImporte()) : BigDecimal.ZERO);

							saldoScreen = saldoScreen.add(movs.getNaturaleza().equals("D")
									? new BigDecimal(movs.getImporte())
									: new BigDecimal(movs.getImporte()).negate());
			%>
			<tr>
				<td><%=movs.getFecha().substring(0, 10)%></td>
				<td><%=movs.getPolizaId()%></td>
				<td><%=movs.getReciboId()%></td>
				<td><%=movs.getReferencia()%></td>
				<td><%=movs.getAuxiliar()%></td>
				<td><%=movs.getDescripcion()%></td>
				<td style="text-align: right;"><%=movs.getNaturaleza().equals("D") ? movs.getImporte() : ""%></td>
				<td style="text-align: right;"><%=movs.getNaturaleza().equals("C") ? movs.getImporte() : ""%></td>
				<td style="text-align: right;"><%=saldoScreen%></td>
			</tr>
			<%
				}
			%>
			<tr>
				<td colspan="6"></td>
				<td style="text-align: right;"><%=formato.format(debitos)%></td>
				<td style="text-align: right;"><%=formato.format(creditos)%></td>
				<td></td>
			</tr>
		</table>
		<%
			}
		%>
	</div>
</body>
</html>

<script type="text/javascript"
	src="../../bootstrap/datepicker/datepicker.js"></script>
<script src="../../js/chosen/chosen.jquery.js" type="text/javascript"></script>
<script>
	jQuery(".chosen").chosen({
		width : "30%"
	});

	jQuery('#FechaIni').datepicker();
	jQuery('#FechaFin').datepicker();

	$('#titulo').text(
			'Cuenta: ' + $('#cuenta option:selected').data('nombre') + ' del '
					+ $('#FechaIni').val() + ' al ' + $('#FechaFin').val());
</script>
<%@ include file="../../cierra_elias.jsp"%>