<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<html>
<%
String fechaHoy 		= aca.util.Fecha.getHoy();
String fechaIni 		= request.getParameter("fechaInicio")==null?fechaHoy:request.getParameter("fechaInicio");
String fechaFin 		= request.getParameter("fechaFin")==null?fechaHoy:request.getParameter("fechaFin");
	
%>
<body>
<div id="content">
	<h1>Reporte <small>Cierre de Caja Gral.</small></h1>
	<form name="frmPuestos" id="frmPuestos" method="post" action="cierre_caja.jsp">
	<div class="well">
		Fecha Inicial:
		<input name="fechaInicio" type="text" id="fechaInicio" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="fechaFin" type="text" id="fechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		<a onclick="javascript:document.frmPuestos.submit();" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
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
<script>
	jQuery('#fechaInicio').datepicker();
	jQuery('#fechaFin').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>