<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<%@page import="aca.fin.FinMovimiento"%>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovL" scope="page" class="aca.fin.FinMovimientosLista"/>

<%
	String codigoId = (String) session.getAttribute("codigoAlumno");

	alumPersonal.mapeaRegId(conElias, codigoId);
%>
<head>
</head>

<body onload="muestraPagina();">
<div id="content">
	<h2><fmt:message key="aca.EstadoDeCuenta" /> <small><%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %> <%=alumPersonal.getNombre() %></small></h2>
	
	<hr />
	
	<form id="forma" name="forma">
	
		<table class="table table-condensed table-striped">
			<thead>
				<tr>
					<th>#</th>
					<th><fmt:message key="aca.Descripcion" /></th>
					<th><fmt:message key="aca.Referencia" /></th>
					<th><fmt:message key="aca.Fecha" /></th>
					<th><fmt:message key="aca.Cargo" /></th>
					<th><fmt:message key="aca.Credito" /></th>
					<th><fmt:message key="aca.Saldo" /></th>
				</tr>
			</thead>
<%
	float total = 0f;
	java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	ArrayList<aca.fin.FinMovimientos> lisMovimientos = FinMovL.getMovimientosAlumno(conElias, codigoId, "ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD'), MOVIMIENTO_ID");
	for(int i = 0; i < lisMovimientos.size(); i++){
		FinMov = (aca.fin.FinMovimientos) lisMovimientos.get(i);
		if(FinMov.getNaturaleza().equals("D"))
			total -= Float.parseFloat(FinMov.getImporte());
		else
			total += Float.parseFloat(FinMov.getImporte());
%>
			<tr>
				<td align="center"><%=i+1 %></td>
				<td><%=FinMov.getDescripcion() %></td>
				<td><%=FinMov.getReferencia() %></td>
				<td><%=FinMov.getFecha() %></td>
				<td align="right"><%=FinMov.getNaturaleza().equals("D")?formato.format(Float.parseFloat(FinMov.getImporte())):"" %></td>
				<td align="right"><%=FinMov.getNaturaleza().equals("C")?formato.format(Float.parseFloat(FinMov.getImporte())):"" %></td>
				<td align="right"><%=formato.format(total) %></td>
			</tr>
<%
	}
	if(lisMovimientos.size() == 0){
%>
			<tr>
				<td colspan="7" align="center">No existen movimientos para este alumno</td>
			</tr>
<%
	}
%>
		</table>			
	</form>
</div>
</body>
<script>
	jQuery('.finanzas').addClass('active');
</script>
<%@ include file= "../../cierra_elias.jsp" %>