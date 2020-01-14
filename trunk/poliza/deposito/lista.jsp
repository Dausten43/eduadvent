<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="FinDepositoLista" scope="page" class="aca.fin.FinDepositoLista" />
<jsp:useBean id="FinDeposito" scope="page" class="aca.fin.FinDeposito" />
<jsp:useBean id="FinPolizaLista" scope="page" class="aca.fin.FinPolizaLista" />

<head>
	
<script>
	function BorrarDeposito(folio, fechaIni, fechaFin){
		if ( confirm("¿Deseas borrar el registro?") ){
			document.location.href="alta.jsp?Folio="+folio+"&Accion=1"+"&FechaIni="+fechaIni+"&FechaFin="+fechaFin;
		}
	}
	
	function EditarDeposito(folio, fechaIni, fechaFin, responsable){
		document.location.href="agregar.jsp?Folio="+folio+"&Accion=3"+"&FechaIni="+fechaIni+"&FechaFin="+fechaFin+"&Responsable="+responsable;		
	}
</script>
</head>
<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");
	String fechaIni			= request.getParameter("FechaIni")==null?aca.util.Fecha.getHoy():request.getParameter("FechaIni");
	String fechaFin			= request.getParameter("FechaFin")==null?aca.util.Fecha.getHoy():request.getParameter("FechaFin");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String folio 			= request.getParameter("Folio")==null?"0":request.getParameter("Folio");	
	
	// Lista de depositos en el rango de fechas
	ArrayList<aca.fin.FinDeposito> lisDepositos 	= FinDepositoLista.getListEntre(conElias, fechaIni, fechaFin, escuelaId);
	
	// Lista de depositos en el rango de fechas
	ArrayList<aca.fin.FinPoliza> lisPolizas 		= FinPolizaLista.getPolizas(conElias, ejercicioId, escuelaId, "'T','A'", "'C','G'", fechaIni, fechaFin, " ORDER BY FECHA");
		
%>

<div id="content">
	<h2>Dep&oacute;sitos de caja <small>(<%= aca.catalogo.CatEscuela.getNombre(conElias,escuelaId)%>)</small></h2>
	<form action="lista.jsp" method="post" name="frmDeposito" target="_self" style="max-width:50%;display:inline;">
	<div class="well">	
		<a class="btn btn-primary" href="alta.jsp?FechaIni=<%=fechaIni%>&FechaFin=<%=fechaFin%>">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>	
		<fmt:message key="aca.FechaInicio" />:&nbsp;&nbsp;
		<input name="FechaIni" type="text" id="FechaIni" size="10" maxlength="10" value="<%=fechaIni%>" class="input-medium datepicker" >		
		<fmt:message key="aca.FechaFinal" />:&nbsp;&nbsp;
		<input name="FechaFin" type="text" id="FechaFin" size="10" maxlength="10" value="<%=fechaFin%>" class="input-medium datepicker">&nbsp;&nbsp;
		<button class="btn btn-primary" type=submit><i class="icon-refresh icon-white"></i> <fmt:message key="aca.Mostrar"/></button>&nbsp;&nbsp;		
	</div>
	</form>				
	<table class="table">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Ejercicio" /></th>
			<th><fmt:message key="aca.Poliza" /></th>
			<th><fmt:message key="aca.Fecha" /></th>
			<th><fmt:message key="aca.Descripcion" /></th>
			<th><fmt:message key="aca.Usuario" /></th>
			<th style="text-align:right;"><fmt:message key="aca.Cantidad" /></th>
		</tr>		
<%	
	int row = 0;
	double totalCaja = 0;
	for (aca.fin.FinPoliza poliza : lisPolizas){
		double importe = Double.parseDouble(aca.fin.FinPoliza.importePolizaMovimientosDeCaja(conElias, poliza.getEjercicioId(), poliza.getPolizaId(), "C", "'R','A'")); 
		totalCaja += importe;
%>
		<tr>				
			<td><%=++row%></td>
			<td><%=poliza.getEjercicioId()%></td>
			<td><%=poliza.getPolizaId()%></td>
			<td><%=poliza.getFecha()%></td>
			<td><%=poliza.getDescripcion()%></td>
			<td><%=aca.vista.UsuariosLista.getNombreCorto(conElias, poliza.getUsuario())%></td>
			<td style="text-align:right;"><%=formato.format( importe )%></td>	
		</tr>
<%	} %>	

		<tr>	
			<th colspan="5"></th>
			<th>T O T A L  &nbsp; </th>
			<th style="text-align:right"><%=formato.format(totalCaja)%></th>
		</tr>	
	</table>
</div>
	
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('.datepicker').datepicker();
</script>

<script type="text/javascript">
    document.getElementById("agregar").onclick = function () {
        location.href = "agregar.jsp";
    };
</script>
</body>
<%@ include file="../../cierra_elias.jsp"%>