<%@ include file="../../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@page import="aca.fin.FinMovimientos"%>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="finMovimientos" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="finMovimientosL" scope="page" class="aca.fin.FinMovimientosLista"/>

<%
	String codigoId = (String) session.getAttribute("codigoAlumno");

	alumPersonal.mapeaRegId(conElias, codigoId);
%>

<div data-role="page">
	<%@ include file="../../menu.jsp"%>
		
	<div data-role="header" style="border:0;">
		<a href="#menu" data-role="none" class="ui-btn ui-icon-bars ui-btn-icon-notext" style="background:transparent !important;"></a>
		<h1>Finanzas</h1>
	</div>

	<div data-role="content">
		
		<table data-role="table" data-mode="table" class="table-stripe ui-responsive" data-column-popup-theme="a">
			<thead>
				<tr>
					<th><fmt:message key="aca.Descripcion" /></th>
					<th><fmt:message key="aca.Saldo" /></th>
				</tr>
			</thead>
	<%
		float total = 0f;
		java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00");
		ArrayList lisMovimientos = finMovimientosL.getMovimientosAlumno(conElias, codigoId, "ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD')");
		for(int i = 0; i < lisMovimientos.size(); i++){
			finMovimientos = (FinMovimientos) lisMovimientos.get(i);
			if(finMovimientos.getNaturaleza().equals("D"))
				total -= Float.parseFloat(finMovimientos.getImporte());
			else
				total += Float.parseFloat(finMovimientos.getImporte());
	%>
						<tr>
							<td><%=finMovimientos.getDescripcion() %></td>
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
				
	
	</div>
</div>

<script>
	$('.menuPrincipal').find('a[href="finanzas.jsp"]').addClass('selected');
</script>


<%@ include file= "../../../cierra_elias.jsp" %>