<%@page import="java.util.HashMap"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>

<jsp:useBean id="movimientosL" scope="page" class="aca.fin.FinMovimientosLista"/>
<html>
<script type="text/javascript">
	function filtrar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaIni 		= request.getParameter("FechaIni")==null?fechaHoy:request.getParameter("FechaIni");
	String fechaFin 		= request.getParameter("FechaFin")==null?fechaHoy:request.getParameter("FechaFin");
	
	ArrayList<aca.fin.FinMovimientos> listaBecas		= movimientosL.getMovimientosBecaFecha(conElias, ejercicioId, fechaIni, fechaFin, " AND descripcion like 'BECA DE COBRO%' ORDER BY FECHA");	
	
%>
<body>
<div id="content">
	<h2>Becas Otorgadas</h2>
	<form name="forma" id="forma" method="post" action="becaTipo.jsp">
	<input type="hidden" name="Accion" />
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		Fecha Inicial:
		<input name="FechaIni" type="text" id="FechaIni" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="FechaFin" type="text" id="FechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		&nbsp;&nbsp;
		<a href="javascript:filtrar()" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
	</div>
	</form>		
<%
	if(accion.equals("1")){
%>
	<table class="table table-striped">
		<tr>
			<th>#</th>
			<th>Ejercicio Id</th>
			<th>Poliza Id</th>
			<th>Mov Id</th>
			<th>Fecha</th>
			<th>Cuenta Id</th>
			<th>Auxiliar</th>
			<th>Descripcion</th>
			<th>Naturaleza</th>
			<th>Referencia</th>
			<th>Estado</th>
			<th style="text-align:right">Importe</th>
		</tr>
<%	
	int cont = 1;
    BigDecimal suma = BigDecimal.ZERO;
    DecimalFormat dcf = new DecimalFormat("#,##0.00");
	for(aca.fin.FinMovimientos becas : listaBecas){
%>
	<tr>
		<td><%=cont %></td>
		<td><%=becas.getEjercicioId() %></td>
		<td><%=becas.getPolizaId() %></td>
		<td><%=becas.getMovimientoId() %></td>
		<td><%=becas.getFecha() %></td>
		<td><%=becas.getCuentaId() %></td>
		<td><%=becas.getAuxiliar() %></td>
		<td><%=becas.getDescripcion() %></td>
		<td><%=becas.getNaturaleza() %></td>
		<td><%=becas.getReferencia() %></td>
		<td><%=becas.getEstado() %></td>
		<td style="text-align:right"><%=becas.getImporte() %></td>
	</tr>
<%		
		suma = suma.add(new BigDecimal(becas.getImporte()));
		cont++;
	} 
%>
	<tr>
		<td  colspan=11></td>
		<td style="text-align: right;"><%= dcf.format(suma) %></td>
	<tr>
	
	</table>
<%
		
	}else
	out.print("<h3>Elija las fechas y filtre para obtener resultado</h3>");
%>
</div>
</body>
</html>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<script>
	jQuery('#FechaIni').datepicker();
	jQuery('#FechaFin').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>