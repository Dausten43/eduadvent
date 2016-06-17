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
<style>
@media print , screen {
	


	.encabezado {
		border-bottom: double 0.3em;
	}	
    .totalFinal {
    	border-top: double 0.3em;
    }
    
    .headerTabla {
    font-size: 12px;
    border-top: solid 0.2em;
    border-bottom: solid 0.2em;
    }
	
}
</style>
<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;(###,##0.00)");

		String escuelaId = (String) session.getAttribute("escuela");
		String ejercicioId = (String) session.getAttribute("ejercicioId");
		String codigoEmpleado = (String) session.getAttribute("codigoEmpleado");

		String recibo = request.getParameter("Recibo");
		String polizaId = request.getParameter("polizaId");
		
		
		String fechayHora = aca.util.Fecha.getDateTime();
		String fechaHoy = aca.util.Fecha.getHoy();

		String logoEscuela = aca.catalogo.CatEscuela.getLogo(conElias, escuelaId);
		String rutaLogo = "../../imagenes/logos/" + logoEscuela;

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
%>
<%
	String pesos = "0";
		String centavos = "00";


		pesos = finRecibo.getImporte().indexOf(".") >= 0
				? finRecibo.getImporte().substring(0, finRecibo.getImporte().indexOf("."))
				: finRecibo.getImporte();
		centavos = finRecibo.getImporte().indexOf(".") >= 0 ? finRecibo.getImporte()
				.substring(finRecibo.getImporte().indexOf(".") + 1, finRecibo.getImporte().length()) : "00";
%>
<div id="content">
	<table class="tabla" style="margin: 0 auto; width: 95%">
		<tr class="encabezado">
			<td style="width: 20%; text-align: center;"><img
				src="<%=rutaLogo%>" width="50%"></td>
			<td style="width: 50%; text-align: center;">
				<h2><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></h2>
				<strong>Direcci&oacute;n:</strong> <%=Escuela.getDireccion()%>, <%=Escuela.getColonia()%>
				<br> <strong>Tel&eacute;fono: </strong><%=Escuela.getTelefono()%>
			</td>
			<td style="width: 30%; text-align: right;">
				<h4>
					No. Recibo<br> [
					<%=finRecibo.getReciboId()%>
					]
				</h4> <span style="font-size: 11px;"></span><strong>Póliza:</strong>[ <%=polizaId%>
				]</span><br> <span style="font-size: 11px;"><strong>Fecha
						y Hora:</strong> [ <%=fechayHora%> ]</span><br> <span
				style="text-align: right; font-size: 16px"><strong>Por:
						<%=formato.format(Double.parseDouble(finRecibo.getImporte()))%></strong></span><br>
				<span style="font-size: 11px;"><strong>Tipo Pago: </strong><%= finRecibo.getTipoPag(finRecibo.getTipoPag()) %></span>
			</td>
		</tr>
		<tr>
		<tr>
			<td colspan="3"
				style="font-size: 14px; text-align: left; padding-top: 10px; padding-bottom: 10px;''"><strong>Recibimos
					de :<%=finRecibo.getCliente()%> <br>La cantidad de:</strong>
				<strong><%=aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos)).toUpperCase() + " BALBOAS. "
						+ centavos + " /100"%></strong></td>

		</tr>

	</table>

	<table class="table table-fullcondensed"  style="margin: 0 auto; width: 95%">
		<tr class="headerTabla">
			<th>Cuenta</th>
			<th>Descripcion</th>
			<th style="text-align: right;">Saldo</th>
			<th style="text-align: right;">Monto</th>
			<th style="text-align: right;">Saldo final</th>
			
		</tr>
		<%
		
		String complTipoPago = "";
		if(finRecibo.getTipoPag()!=null && finRecibo.getTipoPag().equals("2")){
			complTipoPago = "CHEQUE " + finRecibo.getCheque();
		}
		if(finRecibo.getTipoPag()!=null && finRecibo.getTipoPag().equals("3")){
			complTipoPago = "BANCO " + finRecibo.getBanco();
		}
		
			for (FinMovimientos movimientos : lista) {
				
				String saldoStr = aca.fin.FinMovimientos.getSaldoAnterior(conElias, movimientos.getAuxiliar(), movimientos.getFecha().substring(0,10));

					//for( int i=0; i<lista.size(); i++){
					//aca.fin.FinMovimientos movimientos= (aca.fin.FinMovimientos)lista.get(i);

					pesos = movimientos.getImporte().indexOf(".") >= 0
							? movimientos.getImporte().substring(0, movimientos.getImporte().indexOf("."))
							: movimientos.getImporte();
					centavos = movimientos.getImporte().indexOf(".") >= 0 ? movimientos.getImporte().substring(
							movimientos.getImporte().indexOf(".") + 1, movimientos.getImporte().length()) : "00";

					aca.fin.FinMovimientos.getDPoliza(conElias, movimientos.getEjercicioId(),
							movimientos.getPolizaId());
		%>
		<tr style="font-size: 11px">
			<td><%=movimientos.getAuxiliar()%></td>
			<td><%=Alumno.getNombre(conElias, movimientos.getAuxiliar(), "NOMBRE")%>
				<%=movimientos.getDescripcion()%></td>
			<td style="text-align: right"><%=formato.format(Double.parseDouble(saldoStr))%></td>
			<td style="text-align: right"><%=formato.format(Double.parseDouble(movimientos.getImporte()))%></td>
			<td style="text-align: right"><%= formato.format(new BigDecimal(movimientos.getImporte()).add(new BigDecimal(saldoStr))) %></td>
		</tr>
		<%
			}
		%>
		<tr class="totalFinal">
			<td colspan="2" ><%= complTipoPago %> </td>
			<td style="text-align: right;"> <strong>Total Pagado: </strong></td>
			<td style="text-align: right"><%=formato.format(Double.parseDouble(finRecibo.getImporte()))%></td>
			<td></td>
		</tr>
	</table>
	<br>
	<table class="tabla" style="margin: 0 auto;">
	
		<tr>
			<td style="text-align: center;">
				____________________________
				<p ><%= aca.vista.UsuariosLista.getNombreCorto(conElias, usuarioPoliza) %></p></td>
		</tr>
		<tr>
			<td style="font-style: italic; text-align: center; font-size: 12px;">Nulo sin sello y firma del cajero</td>
		</tr>
		<tr>
			<td style="font-style: italic; text-align: center; font-size: 14px;">G R A C I A S</td>
		</tr>
	</table>
</div>
<%@ include file="../../cierra_elias.jsp"%>