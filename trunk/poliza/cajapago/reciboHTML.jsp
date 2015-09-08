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
	String codigoEmpleado 	= (String) session.getAttribute("codigoEmpleado");
	String recibo 			= request.getParameter("Recibo");	
	String ejercicioId 		= (String)session.getAttribute("EjercicioId");	
	String escuelaId 	= (String) session.getAttribute("escuela"); 
	String polizaId 		= request.getParameter("polizaId");	
	String day				= "";
	String month			= "";
	String year				= "";
	Coordenada.mapeaRegId(conElias, codigoEmpleado, "R");
	String fechaHoy 	= aca.util.Fecha.getHoy();
	
	String jpg = "";
    String logoEscuela = aca.catalogo.CatEscuela.getLogo(conElias, escuelaId);
    
    String dirFoto = application.getRealPath("/imagenes/")+"/logos/"+ logoEscuela;
	java.io.File foto = new java.io.File(dirFoto);
	if (foto.exists()){
		jpg = application.getRealPath("/imagenes/")+"/logos/"+ logoEscuela;
	}else{
		jpg = application.getRealPath("/imagenes/")+"/logos/logoIASD.png";
	}
	Escuela.mapeaRegId(conElias, escuelaId);
	
	finRecibo.mapeaRegId(conElias, recibo, ejercicioId);
%>
<div id="content">
	<div class="row">
		<div class="span4">
			<img src="<%=jpg%>">
			<br>&nbsp;
		</div>
		<div class="span4" style="text-align:center;">
				<%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %>
				<br>
				<strong>Direcci&oacute;n:</strong> <%=Escuela.getDireccion()%>, <%=Escuela.getColonia() %>, <%=aca.catalogo.CatCiudad.getCiudad(conElias, Escuela.getPaisId(), Escuela.getEstadoId(), Escuela.getCiudadId()) %>
				<br>
				<strong>Tel&eacute;fono: </strong><%=Escuela.getTelefono() %>
				<br>&nbsp;
		</div>
		<div class="span4">
			Fecha: <%=fechaHoy %>
			<br> 
			No. Recibo:
			<%=finRecibo.getReciboId() %>
			<br>
			No. Folio
			<br>&nbsp;
		</div>
	</div>
	<br>
	&nbsp;<strong>Cliente:</strong> <%=finRecibo.getCliente() %>
	<br>
	<div style="text-align:center;">
		
		<table class="table table-condensed">
			<tr>
				<th>Descripci&oacute;n</th>
				<th>Monto Letra</th>
				<th style="text-align:right">Cantidad</th>
			</tr>
<%
ArrayList lista = finML.getMovimientos(conElias,ejercicioId,polizaId,recibo,"");
String pesos 	= "0";
String centavos	= "00"; 
for( int i=0; i<lista.size(); i++){
	aca.fin.FinMovimientos movimientos= (aca.fin.FinMovimientos)lista.get(i);
	pesos 		= movimientos.getImporte().indexOf(".")>=0?movimientos.getImporte().substring(0,movimientos.getImporte().indexOf(".")):movimientos.getImporte();
	centavos 	= movimientos.getImporte().indexOf(".")>=0?movimientos.getImporte().substring(movimientos.getImporte().indexOf(".")+1, movimientos.getImporte().length()):"00";
	
	movimientos.getDPoliza(conElias, movimientos.getPolizaId());
%>
			<tr>
				<td><%=movimientos.getDescripcion() %></td>
				<td><%=aca.util.NumberToLetter.convertirLetras(Integer.parseInt(pesos))+" pesos. "+centavos+" /100 M.N." %></td>
				<td style="text-align:right">$<%=movimientos.getImporte() %></td>
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
				<td style="text-align:right">$<%=finRecibo.getImporte() %></td>
			</tr>
		</table>
	</div>
</div>
<%@ include file= "../../cierra_elias.jsp" %>