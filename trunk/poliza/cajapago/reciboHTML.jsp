<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import = "java.awt.Color" %>
<%@ page import = "java.io.FileOutputStream" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "com.itextpdf.text.*" %>
<%@ page import = "com.itextpdf.text.pdf.*" %>

<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="finML" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada"/>
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela"/>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String)session.getAttribute("ejercicioId");
	String codigoEmpleado 	= (String) session.getAttribute("codigoEmpleado");
	
	String recibo 			= request.getParameter("Recibo"); 
	String polizaId 		= request.getParameter("polizaId");
	
	String fechayHora	 	= aca.util.Fecha.getDateTime();	
	
    String logoEscuela = aca.catalogo.CatEscuela.getLogo(conElias, escuelaId);
    String rutaLogo = "../../imagenes/logos/"+logoEscuela;
    
	Escuela.mapeaRegId(conElias, escuelaId);	
	finRecibo.mapeaRegId(conElias, recibo, ejercicioId);
	
	// Lista de movimientos en el recibo
	ArrayList<aca.fin.FinMovimientos> lista 	= finML.getMovimientos(conElias,ejercicioId,polizaId,recibo," ORDER BY FECHA");
%>
<div id="content">
	<table class="tabla" style="margin: 0 auto;">
		<tr>
			<td>
				<img src="<%=rutaLogo%>" width="150">
			</td>		
			<td align="center">
				<h4><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %></h4>
				<strong>Direcci&oacute;n:</strong> <%=Escuela.getDireccion()%>, <%=Escuela.getColonia() %>
				<br>
				<strong>Tel&eacute;fono: </strong><%=Escuela.getTelefono() %>				
			</td>			
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center">
				<strong>Fecha y Hora:</strong> [ <%=fechayHora %> ] &nbsp; &nbsp; 
				<strong>No. Recibo:</strong> [ <%=finRecibo.getReciboId() %> ] &nbsp; &nbsp; 
				<strong>No. Folio:</strong>[ <%= polizaId %> ]
			</td>
		</tr>			
	</table>
	<br>
	&nbsp;<strong>Cliente:</strong> <%=finRecibo.getCliente() %>
	<br>		
	<table class="table table-condensed">
	<tr>
		<th>Descripci&oacute;n</th>
		<th>Monto Letra</th>
		<th style="text-align:right">Cantidad</th>
	</tr>
<%

	String pesos 	= "0";
	String centavos	= "00";
	
	for( int i=0; i<lista.size(); i++){
		aca.fin.FinMovimientos movimientos= (aca.fin.FinMovimientos)lista.get(i);
		
		pesos 		= movimientos.getImporte().indexOf(".")>=0?movimientos.getImporte().substring(0,movimientos.getImporte().indexOf(".")):movimientos.getImporte();
		centavos 	= movimientos.getImporte().indexOf(".")>=0?movimientos.getImporte().substring(movimientos.getImporte().indexOf(".")+1, movimientos.getImporte().length()):"00";
	
		aca.fin.FinMovimientos.getDPoliza(conElias, movimientos.getEjercicioId(), movimientos.getPolizaId());
%>
	<tr>
		<td><%=movimientos.getDescripcion() %></td>
		<td><%=aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos))+" pesos. "+centavos+" /100" %></td>
		<td style="text-align:right">$<%=formato.format(Double.parseDouble(movimientos.getImporte())) %></td>
	</tr>
<%
	}
%>	
	<tr>	
		<td><strong>Monto a Pagar: </strong> </td>
<%
		pesos 		= finRecibo.getImporte().indexOf(".")>=0?finRecibo.getImporte().substring(0,finRecibo.getImporte().indexOf(".")):finRecibo.getImporte();
		centavos 	= finRecibo.getImporte().indexOf(".")>=0?finRecibo.getImporte().substring(finRecibo.getImporte().indexOf(".")+1, finRecibo.getImporte().length()):"00";
%>
		<td><strong><%=aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos))+" pesos. "+centavos+" /100" %></strong></td>
		<td style="text-align:right">$<%=formato.format(Double.parseDouble(finRecibo.getImporte())) %></td>
	</tr>
	</table>
	<br>
	<table class="tabla" style="margin: 0 auto;">
	<tr>
		<td class="center">Firma del Cajero: ____________________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Firma del Padre: ____________________________</td>
	</tr>
	</table>	
</div>
<%@ include file= "../../cierra_elias.jsp" %>