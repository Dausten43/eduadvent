<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="FinDepositoLista" scope="page" class="aca.fin.FinDepositoLista" />
<head>
	
<script>

</script>
<%

	String fInicio 		= request.getParameter("FInicio")==null?aca.util.Fecha.getHoy():request.getParameter("FInicio");
	String fFinal 		= request.getParameter("FFinal")==null?aca.util.Fecha.getHoy():request.getParameter("FFinal");
	String escuelaId 	= (String) session.getAttribute("escuela");
	
	// Lista de depositos en el rango de fechas
	ArrayList<aca.fin.FinDeposito> lisDepositos 	= FinDepositoLista.getListEntre(conElias, fInicio, fFinal, escuelaId);
	
%>
</head>
<div id="content">
	<h2>Depositos de caja</h2>
	<form action="alta.jsp" method="post" name="frmDeposito" target="_self" style="max-width:50%;display:inline;">		
	<div class="well">		
		<fmt:message key="aca.FechaInicio" />:&nbsp;&nbsp;
		<input name="FInicio" type="text" id="FInicio" size="10" maxlength="10" value="<%=fInicio%>" class="input-medium datepicker" >		
		<fmt:message key="aca.FechaFinal" />:&nbsp;&nbsp;
		<input name="FFinal" type="text" id="FFinal" size="10" maxlength="10" value="<%=fFinal%>" class="input-medium datepicker">&nbsp;&nbsp;		
		<button class="btn btn-primary" type=submit><i class="icon-refresh icon-white"></i> <fmt:message key="aca.Mostrar"/></button>&nbsp;&nbsp;		
		<a href="agregar.jsp" class="btn btn-primary" id="agregar"><i class="icon-ok icon-white"></i> <fmt:message key="aca.Agregar" /></a>
	</div>
	</form>				
	<table class="table">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Fecha" /></th>
			<th><fmt:message key="aca.Debito" /></th>
			<th><fmt:message key="aca.Responsable" /></th>
		</tr>		
<%	
	float total = 0;
	int row = 0;
	for (aca.fin.FinDeposito deposito : lisDepositos){
		total	= Float.parseFloat( deposito.getImporte() );
		row++;
%>
		<tr>				
			<td><%=row%></td>
			<td><%=deposito.getFechaDeposito()%></td>
			<td><%=deposito.getImporte() %></td>
			<td><%=deposito.getResponsable() %></td>			
		</tr>
<%	} %>
		<tr>	
			<th colspan="2">Total</th>
			<th colspan="2"><%=total%></th>
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