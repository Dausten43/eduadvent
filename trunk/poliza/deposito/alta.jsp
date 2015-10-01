<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="FinDepositoLista" scope="page" class="aca.fin.FinDepositoLista" />
<jsp:useBean id="FinDeposito" scope="page" class="aca.fin.FinDeposito" />
<head>
	
<script>
	function BorrarDeposito(folio, fechaIni, fechaFin){
		if ( confirm("�Deseas borrar el registro?") ){
			document.location.href="alta.jsp?Folio="+folio+"&Accion=1"+"&FechaIni="+fechaIni+"&FechaFin="+fechaFin;
		}
	}
	
	function EditarDeposito(folio, fechaIni, fechaFin){
		document.location.href="agregar.jsp?Folio="+folio+"&Accion=3"+"&FechaIni="+fechaIni+"&FechaFin="+fechaFin;		
	}
</script>
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String fechaIni			= request.getParameter("FechaIni")==null?aca.util.Fecha.getHoy():request.getParameter("FechaIni");
	String fechaFin			= request.getParameter("FechaFin")==null?aca.util.Fecha.getHoy():request.getParameter("FechaFin");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String folio 			= request.getParameter("Folio")==null?"0":request.getParameter("Folio");
	
	if (accion.equals("1")){
		// Borrar deposito
		FinDeposito.setEscuelaId(escuelaId);
		FinDeposito.setFolio(folio);
		if (FinDeposito.existeReg(conElias)){
			if (FinDeposito.deleteReg(conElias)){
				conElias.commit();
			}			
		}else{			
		}
		
	}
	
	// Lista de depositos en el rango de fechas
	ArrayList<aca.fin.FinDeposito> lisDepositos 	= FinDepositoLista.getListEntre(conElias, fechaIni, fechaFin, escuelaId);
	
%>
</head>
<div id="content">
	<h2>Dep&oacute;sitos de caja</h2>
	<form action="alta.jsp" method="post" name="frmDeposito" target="_self" style="max-width:50%;display:inline;">
	<div class="well">		
		<fmt:message key="aca.FechaInicio" />:&nbsp;&nbsp;
		<input name="FechaIni" type="text" id="FechaIni" size="10" maxlength="10" value="<%=fechaIni%>" class="input-medium datepicker" >		
		<fmt:message key="aca.FechaFinal" />:&nbsp;&nbsp;
		<input name="FechaFin" type="text" id="FechaFin" size="10" maxlength="10" value="<%=fechaFin%>" class="input-medium datepicker">&nbsp;&nbsp;
		<button class="btn btn-primary" type=submit><i class="icon-refresh icon-white"></i> <fmt:message key="aca.Mostrar"/></button>&nbsp;&nbsp;		
		<a href="agregar.jsp?FechaIni=<%=fechaIni%>&FechaFin=<%=fechaFin%>" class="btn btn-primary" id="agregar"><i class="icon-ok icon-white"></i> <fmt:message key="aca.Agregar" /></a>
	</div>
	</form>				
	<table class="table">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Opcion" /></th>
			<th><fmt:message key="aca.Fecha" /></th>
			<th><fmt:message key="aca.Debito" /></th>
			<th><fmt:message key="aca.Credito" /></th>
			<th><fmt:message key="aca.Responsable" /></th>
		</tr>		
<%	
	double totalCaja 		= aca.fin.FinMovimientos.saldoPolizas(conElias, escuelaId, "'C','G'", "'C','T'", fechaIni, fechaFin, "D");
	double totalDeposito 	= 0;
	
	int row = 0;
	for (aca.fin.FinDeposito deposito : lisDepositos){
		totalDeposito	= Double.parseDouble( deposito.getImporte() );
		row++;
%>
		<tr>				
			<td><%=row%></td>
			<td>
				<a href="javascript:EditarDeposito('<%=deposito.getFolio()%>','<%=fechaIni%>','<%=fechaFin%>')" class="btn btn-mini btn-success">
					<i class="icon-pencil icon-white"></i>
				</a>
				<a href="javascript:BorrarDeposito('<%=deposito.getFolio()%>','<%=fechaIni%>','<%=fechaFin%>')" class="btn btn-mini btn-danger">
					<i class="icon-remove icon-white"></i>
				</a>
			</td>
			<td><%=deposito.getFechaDeposito()%></td>
			<td><%=deposito.getImporte() %></td>
			<td>&nbsp;</td>
			<td><%=deposito.getResponsable() %></td>		
		</tr>
<%	} %>
		<tr>	
			<th colspan="3">Total</th>
			<th><%=totalDeposito%></th>
			<th><%=totalCaja%></th>
			<th>&nbsp;</th>			
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