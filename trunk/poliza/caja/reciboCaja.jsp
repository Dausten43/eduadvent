<%@page import="java.util.Date"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="aca.fin.FinMovimientos"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ page import="java.awt.Color"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="com.itextpdf.text.*"%>
<%@ page import="com.itextpdf.text.pdf.*"%>

<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo" />
<jsp:useBean id="finPoliza" scope="page" class="aca.fin.FinPoliza" />
<jsp:useBean id="finML" scope="page" class="aca.fin.FinMovimientosLista" />
<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada" />
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal" />
<jsp:useBean id="Cuenta" scope="page" class="aca.fin.FinCuenta" />
<style>
@page {
	margin-top: 0.3cm;
	margin-left: 0.3cm;
	margin-right: 0.3cm;
	margin-bottom: 0.3cm;
}

@media print , screen {
	.encabezado {
		border-bottom: double 0.3em;
	}
	.totalFinal {
		border-top: double 0.3em;
	}
	.headerTabla {
		border-top: solid 0.2em;
		border-bottom: solid 0.2em;
	}
}
</style>
<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	//sdf.setTimeZone(TimeZone.getTimeZone("GMT-6"));
	

		String escuelaId = (String) session.getAttribute("escuela");
		String ejercicioId = (String) session.getAttribute("ejercicioId");
		String codigoEmpleado = (String) session.getAttribute("codigoEmpleado");

		String recibo = request.getParameter("Recibo");
		String polizaId = request.getParameter("polizaId");

		String fechayHora = aca.util.Fecha.getDateTime();
		String fechaHoy = aca.util.Fecha.getHoy();
		
		

		String logoEscuela = aca.catalogo.CatEscuela.getLogo(conElias, escuelaId);
		
		
		//peticion de las escuelas del salvador que no apareciera el logo de la escuela solo en la S19
		if(escuelaId.startsWith("S") && !escuelaId.equals("S19")){
			logoEscuela= "XX";
		}
			
			
		String rutaLogo = "../../imagenes/logos/" + logoEscuela;
		String rutaLogoSEAS = "";
		
		boolean esEscuelaDelSalvador = false;
		
		if(escuelaId.contains("S")){
			esEscuelaDelSalvador = true;
			rutaLogoSEAS = "../../imagenes/logos/SEAS.png";
		}
		
		finPoliza.mapeaRegId(conElias, ejercicioId, polizaId);

		String usuarioPoliza = finPoliza.getUsuario();

		// Verifica si existe el logo
		boolean tieneLogo = false;

		String dirFoto = application.getRealPath("/imagenes/logos/" + logoEscuela);

		java.io.File foto = new java.io.File(dirFoto);

		if (foto.exists()) {
			tieneLogo = true;
		} else {
			rutaLogo = "../../imagenes/logos/logoIASD.png";
		}

		Escuela.mapeaRegId(conElias, escuelaId);
		finRecibo.mapeaRegId(conElias, recibo, ejercicioId);
		// Lista de movimientos en el recibo
		ArrayList<aca.fin.FinMovimientos> lista = finML.getMovimientos(conElias, ejercicioId, polizaId, recibo,
				" ORDER BY FECHA");
		
		if(esEscuelaDelSalvador){ 
			fechayHora = sdf.format(new Date());
		}
%>
<%
	String pesos = "0";
		String centavos = "00";

		pesos = finRecibo.getImporte().indexOf(".") >= 0
				? finRecibo.getImporte().substring(0, finRecibo.getImporte().indexOf("."))
				: finRecibo.getImporte();
		centavos = finRecibo.getImporte().indexOf(".") >= 0 ? finRecibo.getImporte()
				.substring(finRecibo.getImporte().indexOf(".") + 1, finRecibo.getImporte().length()) : "00";
		
		
		String urlNuevoRecibo = "movimientos.jsp?polizaId=" + polizaId;
%>
<div id="content">
	<table class="tabla" style="margin: 0 auto; width: 95%">
		<tr>
			<td style="width: 10%; text-align: center;"><a href="caja.jsp">
			<a href="<%= urlNuevoRecibo %>">
				<%if(esEscuelaDelSalvador){ %>
					<img src="<%=rutaLogoSEAS%>" style="vertical-align:super; max-width:50%; min-width:100px">
				<%}else{ %>
					<img src="<%=rutaLogo%>" style="vertical-align:super; max-width:50%; min-width:100px">
				<%} %></a>
				</a>
			</td>
			<td style="width:<%out.print(tieneLogo&&esEscuelaDelSalvador?"55%":"65%");%>; text-align: center; vertical-align: text-top;">
				<%if(!esEscuelaDelSalvador){ %>
				<p style="text-align: center; font-family: sans-serif; font-size: 14px; font-weight: bold;">
					<%=aca.catalogo.CatAsociacion.getNombre(conElias, aca.catalogo.CatEscuela.getAsociacionId(conElias, escuelaId))%>
				</p>
				<%} %>
				<p style="text-align: center; font-family: sans-serif; font-size: 1.6em; font-weight: bold;">
					<%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%>
				</p>
				<div style="font-size: 12px; line-height: 1.5;">
					<%if(esEscuelaDelSalvador){ %>
					<strong>Direcci&oacute;n:</strong>
					<%} else{%>
					<strong>R.U.C.:</strong>
					<%=aca.catalogo.CatEscuela.getNombreCorto(conElias, escuelaId)%>
					<br>
					<%} %>
					<%=Escuela.getDireccion()%>,
					<%=Escuela.getColonia()%>.
					<%if(esEscuelaDelSalvador){ %>
					<br> 
					<strong>Tel&eacute;fono:</strong>
					<%}else{out.println("&nbsp;");} %>
					<%=Escuela.getTelefono()%>
					<br> 
					<strong>P&oacute;liza: </strong>
					[ <%=polizaId%> ]
					<%if(esEscuelaDelSalvador){ %>
					<br>
					<%}else{out.println("&nbsp;");} %>
					<strong>Fecha :</strong>
					[ <%=finRecibo.getFecha().length()>10 ? finRecibo.getFecha().substring(0,10) : finRecibo.getFecha() %> ]
				</div>

			</td>
			<td style="width: 10%; text-align: center; vertical-align: super;">
				<h4>
					Recibo </span><br>[<%=finRecibo.getReciboId()%>]
				</h4> <span style="text-align: right; font-size: 14px"><strong>Por: <%=formato.format(Double.parseDouble(finRecibo.getImporte()))%></strong></span><br>
				<span style="font-size: 11px;"><strong>Tipo Pago: </strong><%=finRecibo.getTipoPag(finRecibo.getTipoPag())%></span>
			</td>
		<%if(tieneLogo && esEscuelaDelSalvador){ %>
			<td style="width: 10%; text-align: center;">
				<img src="<%=rutaLogo%>" style="vertical-align:super; max-width:50%; min-width:100px">
			</td>
		<%}%>
		</tr>
		<tr class="encabezado"><td colspan="<%out.print(tieneLogo&&esEscuelaDelSalvador?"4":"3");%>" style="height:5px;"></td></tr>
		<tr>
			<td colspan="<%out.print(tieneLogo==esEscuelaDelSalvador?"4":"3");%>" style="font-size: 12px;padding-bottom: 0.6em">
				<table style="padding: 0px; width: 100%;">
					<tr>
						<td><div style="text-align: left;">
								Recibimos de: <%=finRecibo.getCliente()%></div></td>
						<td><div style="text-align: right;">
								La cantidad de: <strong><%=aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos)).toUpperCase() + (esEscuelaDelSalvador?" DÓLARES CON ":" BALBOAS. ")
						+ centavos + " /100"%></strong>
							</div></td>
					</tr>
				</table>


			</td>

		</tr>

	</table>

	<table class="table table-fullcondensed"
		style="margin: 0 auto; width: 95%">
		<tr class="headerTabla" style="font-size: 11px;">

			<th>Descripción</th>
			<th style="text-align: right;">Saldo</th>
			<th style="text-align: right;">Monto</th>
			<th style="text-align: right;">Saldo final</th>

		</tr>
		<%
			String complTipoPago = "";
				if (finRecibo.getTipoPag() != null && finRecibo.getTipoPag().equals("2")) {
					complTipoPago = "CHEQUE " + finRecibo.getCheque();
				}
				if (finRecibo.getTipoPag() != null && finRecibo.getTipoPag().equals("3")) {
					complTipoPago = "BANCO " + finRecibo.getBanco();
				}
				
				BigDecimal saldoAcumulado = BigDecimal.ZERO;
				boolean saldoIni = false;
				Map<String,BigDecimal> mapSaldo = new HashMap();

				for (FinMovimientos movimientos : lista) {

					String saldoStr = "0";
					String saldoFormat = "-";

					Cuenta.mapeaRegId(conElias, movimientos.getCuentaId());

					
					
					if (Cuenta.getMuestraSaldoRecibo().equals("S")) {
						saldoStr = aca.fin.FinMovimientos.getSaldoAnterior(conElias, movimientos.getAuxiliar(),
								movimientos.getFecha());
						
						mapSaldo.put(movimientos.getAuxiliar(), new BigDecimal(saldoStr));
						
						if(!saldoIni){
							saldoAcumulado = saldoAcumulado.add(new BigDecimal(saldoStr));
							mapSaldo.put(movimientos.getAuxiliar(), new BigDecimal(saldoStr));
						}
						
						saldoIni = true;
						
						
						
						saldoFormat = formato.format(Double.parseDouble(saldoStr));
					}
					
					if(!saldoIni){
						saldoAcumulado = saldoAcumulado.add(new BigDecimal(saldoStr));
						mapSaldo.put(movimientos.getAuxiliar(), new BigDecimal(saldoStr));
					}

					//for( int i=0; i<lista.size(); i++){
					//aca.fin.FinMovimientos movimientos= (aca.fin.FinMovimientos)lista.get(i);

					pesos = movimientos.getImporte().indexOf(".") >= 0
							? movimientos.getImporte().substring(0, movimientos.getImporte().indexOf("."))
							: movimientos.getImporte();
					centavos = movimientos.getImporte().indexOf(".") >= 0 ? movimientos.getImporte().substring(
							movimientos.getImporte().indexOf(".") + 1, movimientos.getImporte().length()) : "00";
					
					aca.fin.FinMovimientos.getDPoliza(conElias, movimientos.getEjercicioId(),
							movimientos.getPolizaId());
					
					BigDecimal saldoBgDc = BigDecimal.ZERO;
					saldoBgDc = saldoBgDc.add(mapSaldo.containsKey(movimientos.getAuxiliar()) ? mapSaldo.get(movimientos.getAuxiliar()) : BigDecimal.ZERO);
		%>
		<tr style="font-size: 10px">

			<td><%=movimientos.getAuxiliar()%>-<%=Alumno.getNombre(conElias, movimientos.getAuxiliar(), "NOMBRE")%>-<%=Cuenta.getCuentaNombre()%>
				<%=movimientos.getDescripcion()%></td>
			<td style="text-align: right"><%= saldoBgDc %></td>
			<td style="text-align: right"><%=formato.format(Double.parseDouble(movimientos.getImporte()))%></td>
<%-- 			<td style="text-align: right"><%=formato.format(new BigDecimal(saldoStr).subtract(new BigDecimal(movimientos.getImporte())) )%></td> --%>
			<td style="text-align: right"><%=formato.format(saldoBgDc.subtract(new BigDecimal(movimientos.getImporte())) )%></td>
		</tr>
		<%
				if (Cuenta.getMuestraSaldoRecibo().equals("S")) {
						saldoAcumulado = saldoAcumulado.subtract(new BigDecimal(movimientos.getImporte()));
				}
			}
		%>
		<tr class="totalFinal">
			<td colspan="1"><%=complTipoPago%></td>
			<td style="text-align: right; font-size: 11px;"><strong>Total
					Pagado: </strong></td>
			<td style="text-align: right"><%=formato.format(Double.parseDouble(finRecibo.getImporte()))%></td>
			<td></td>
		</tr>
	</table>
	<br>
	<table class="tabla" style="margin: 0 auto;">

		<tr>
			<td style="text-align: center; line-height: 1.1;">
				____________________________
				<p>
					<strong><%=aca.vista.UsuariosLista.getNombreCorto(conElias, usuarioPoliza)%></strong>
				</p> <span
				style="font-style: italic; text-align: center; font-size: 12px;">Nulo
					sin sello y firma del cajero<br> G R A C I A S
			</span>
			</td>
		</tr>
	</table>
</div>
<%@ include file="../../cierra_elias.jsp"%>