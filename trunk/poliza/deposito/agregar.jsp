<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada" />
<jsp:useBean id="FinDeposito" scope="page" class="aca.fin.FinDeposito" />
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
	String escuelaId 	= (String) session.getAttribute("escuela");
%>

</head>

	<div id="content">
		<h2>Depositos de caja</h2>
		<br>
		<form action="agregar.jsp" method="post" name="frmDeposito" target="_self" ">
		<fieldset style="max-width:100px; display:inline;">
			<label for="Folio"><fmt:message key="aca.Folio" /></label>
			<input name="Folio" type="text" id="Folio" size="10" maxlength="10" value="<%=FinDeposito.maxReg(conElias, escuelaId )%>" disabled>
		</fieldset>
		
		<fieldset style="max-width:100px; display:inline;">
			<label for="Folio"><fmt:message key="aca.Folio" /></label>
			<input name="Folio" type="text" id="Folio" size="10" maxlength="10" value="<%=FinDeposito.maxReg(conElias, escuelaId )%>" disabled>
		</fieldset>
		
		<fieldset style="max-width:100px; display:inline;">
			<label for="Folio"><fmt:message key="aca.Folio" /></label>
			<input name="Folio" type="text" id="Folio" size="10" maxlength="10" value="<%=FinDeposito.maxReg(conElias, escuelaId )%>" disabled>
		</fieldset>
		
		<fieldset style="max-width:100px; display:inline;">
			<label for="Folio"><fmt:message key="aca.Folio" /></label>
			<input name="Folio" type="text" id="Folio" size="10" maxlength="10" value="<%=FinDeposito.maxReg(conElias, escuelaId )%>" disabled>
		</fieldset>
		
			
		</form>

		
	
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('.datepicker').datepicker();
</script>

</body>
<%@ include file="../../cierra_elias.jsp"%>