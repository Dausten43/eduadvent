<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada" />
<jsp:useBean id="FinDepositoLista" scope="page" class="aca.fin.FinDepositoLista" />
<head>
	
<script>
	function Mostrar(){
		document.frmDeposito.Accion.value="1";
		document.frmDeposito.submit();
	}
</script>
<%

	String fInicio = request.getParameter("FInicio")==null?aca.util.Fecha.getHoy():request.getParameter("FInicio");
	String fFinal = request.getParameter("FFinal")==null?aca.util.Fecha.getHoy():request.getParameter("FFinal");
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	ArrayList <aca.fin.FinDeposito> depositoLista = FinDepositoLista.getListEntre(conElias, fInicio, fFinal);
	int total = 0;
	



%>

</head>

	<div id="content">
		<h2>Depositos de caja</h2>
		<br>
		<div class="well">
		<form action="alta.jsp" method="post" name="frmDeposito" target="_self" style="max-width:50%;display:inline;">
		<fieldset style="max-width:100px; display:inline;">
			<label for="FInicio"><fmt:message key="aca.FechaInicio" /></label>
			<input name="FInicio" type="text" id="FInicio" size="10" maxlength="10" value="<%=fInicio%>" class="input-medium datepicker" >
		</fieldset>
		
		<fieldset style="max-width:100px; display:inline;">
			<label for="FFinal"><fmt:message key="aca.FechaFinal" /></label>
			<input name="FFinal" type="text" id="FFinal" size="10" maxlength="10" value="<%=fFinal%>" class="input-medium datepicker">
		</fieldset>
		
		<button class="btn btn-primary" onclick="javascript:Mostrar()"><i class="icon-ok icon-white"></i> <fmt:message key="aca.Mostrar"/></button>
		</form>
		<button class="btn btn-primary" id="agregar"><i class="icon-ok icon-white"></i> <fmt:message key="aca.Agregar" /></button>
			
		</div>
		
		<table class="table">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Debito" /></th>
				<th><fmt:message key="aca.Responsable" /></th>
			</tr>
		
		
<%	for (int x=0; x<depositoLista.size(); x++){
		total= Integer.parseInt(total+depositoLista.get(x).getImporte());
	%>
	
			<tr>
				
					<td><%=x%></td>
					<td><%=depositoLista.get(x).getFecha_deposito()%></td>
					<td><%=depositoLista.get(x).getImporte() %></td>
					<td><%=depositoLista.get(x).getResponsable() %></td>
				
			</tr>
<%	
} %>
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