<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:useBean id="FinDeposito" scope="page" class="aca.fin.FinDeposito" />
<head>
	
<script>
	function Grabar(){
		document.frmDeposito.Accion.value="1";
		document.frmDeposito.submit();
	}
</script>
<%

	String fInicio 		= request.getParameter("FInicio")==null?aca.util.Fecha.getHoy():request.getParameter("FInicio");
	String fFinal 		= request.getParameter("FFinal")==null?aca.util.Fecha.getHoy():request.getParameter("FFinal");
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String escuelaId 	= (String) session.getAttribute("escuela");
	String folio 		= FinDeposito.maxReg(conElias, escuelaId );

	if( accion.equals("1")){ // Nuevo
		System.out.println("Entro");
		FinDeposito.setEscuelaId(escuelaId);
		FinDeposito.setFolio(folio);
		FinDeposito.setFecha(aca.util.Fecha.getHoy());
		FinDeposito.setFechaDeposito(request.getParameter("FechaDeposito"));
		FinDeposito.setImporte(request.getParameter("Importe"));
		FinDeposito.setResponsable(request.getParameter("Responsable"));
		
		if(FinDeposito.insertReg(conElias)){
			folio = FinDeposito.maxReg(conElias, escuelaId );
		}
	}

%>

</head>

<div id="content">
	<h2>Depositos de caja</h2>
	<br>
	<div class="well">
		<a class="btn btn-primary" href="alta.jsp">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/>
		</a></div>
	
	<form action="agregar.jsp" method="post" name="frmDeposito" target="_self" >
	<input type="hidden" name="Accion">
	<fieldset style="max-width:100px; display:inline;">
		<label for="Folio"><fmt:message key="aca.Folio" /></label>
		<input name="Folio" type="text" id="Folio" size="10" maxlength="10" value="<%=folio%>" disabled>
	</fieldset>

	<fieldset>
		<label for="FechaDeposito"><fmt:message key="aca.Fecha" /></label>
		<input name="FechaDeposito" type="text" id="FechaDeposito" size="10" maxlength="10" class="datepicker" value="" required>
	</fieldset>		

	<fieldset>
		<label for="Importe"><fmt:message key="aca.Importe" /></label>
		<input name="Importe" type="text" id="Importe" size="10" maxlength="10" value="" required>
	</fieldset>		
	
	<fieldset>
		<label for="Responsable"><fmt:message key="aca.Responsable" /></label>
		<input name="Responsable" type="text" id="Responsable" size="10" maxlength="10" value=""  required>
	</fieldset>
	
	<div class="well">
		<button class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Anadir" /></button>
	</div>

	</form>
</div>
		
	
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('.datepicker').datepicker();
</script>

</body>
<%@ include file="../../cierra_elias.jsp"%>