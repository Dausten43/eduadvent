<%@page import="java.util.HashMap"%>
<%@page import="aca.util.Fecha"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>

<html>
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaIni 		= request.getParameter("FechaIni")==null?fechaHoy:request.getParameter("FechaIni");
	String fechaFin 		= request.getParameter("FechaFin")==null?fechaHoy:request.getParameter("FechaFin");
	
	String nombre			= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
	String asociacion		= aca.catalogo.CatAsociacion.getAsociacionNombre(conElias, escuelaId);
	String estado 	= "'T','C'";
	String tipo		="'G','C','I'";
	double saldo 			= aca.fin.FinMovimientos.saldoPolizas(conElias, escuelaId, estado, tipo, fechaIni, fechaFin, "D"); 	
%>
<body>
<div id="content">
	<h1>Control de Alumno<small></small></h1>
	<form name="frmControl" id="frmControl" method="post" action="control.jsp">
	<div class="well">
		Fecha Inicial:
		<input name="FechaIni" type="text" id="FechaIni" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="FechaFin" type="text" id="FechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		<a onclick="javascript:document.frmControl.submit();" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
	</div>
	</form>	
</div>
</body>
</html>
<style>
	body{
		background:white;
	}
</style>

<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<script>
	jQuery('#FechaIni').datepicker();
	jQuery('#FechaFin').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>