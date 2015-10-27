<%@page import="java.util.HashMap"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<html>
<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)");

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");
	System.out.println(ejercicioId);
	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaIni 		= request.getParameter("FechaIni")==null?fechaHoy:request.getParameter("FechaIni");
	String fechaFin 		= request.getParameter("FechaFin")==null?fechaHoy:request.getParameter("FechaFin");
	
	
%>
<body>
<div id="content">
	<h2>Tipos de Becas </h2>
	<form name="forma" id="forma" method="post" action="becaTipo.jsp">
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		Fecha Inicial:
		<input name="FechaIni" type="text" id="FechaIni" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaIni%>" style="margin-top: 5px;">
		Fecha Final:
		<input name="FechaFin" type="text" id="FechaFin" size="12" maxlength="10" data-date-format="dd/mm/yyyy" onfocus="focusFecha(this);" value="<%=fechaFin%>" style="margin-top: 5px;">
		&nbsp;&nbsp;
		<a onclick="javascript:document.forma.submit();" class="btn btn-primary"><i class="icon-white icon-filter"></i> Filtrar</a>
	</div>
	</form>		
	
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