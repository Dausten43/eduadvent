<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../idioma.jsp" %>

<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivel"/>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovL" scope="page" class="aca.fin.FinMovimientosLista"/>

<%
	String codigoId = request.getParameter("codigoId");

	alumPersonal.mapeaRegId(conElias, codigoId);
%>

<table class="table table-condensed table-striped table-bordered" style="margin:0;">
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
	ArrayList<aca.fin.FinMovimientos> lisMovimientos = FinMovL.getMovimientosAlumno(conElias, codigoId, " and cuenta_id IN ( SELECT fin_cuenta.cuenta_id  FROM fin_cuenta WHERE fin_cuenta.cuenta_aislada = 'N')  ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD'), MOVIMIENTO_ID") ;
	for(int i = 0; i < lisMovimientos.size(); i++){
		FinMov = (aca.fin.FinMovimientos) lisMovimientos.get(i);
		if(FinMov.getNaturaleza().equals("D"))
			total -= Float.parseFloat(FinMov.getImporte());
		else
			total += Float.parseFloat(FinMov.getImporte());
%>
		<tr>
			<td style="text-align:center"><%=i+1 %></td>
			<td><%=FinMov.getDescripcion() %></td>
			<td><%=FinMov.getReferencia() %></td>
			<td><%=FinMov.getFecha() %></td>
			<td style="text-align:right"><%=FinMov.getNaturaleza().equals("D")?formato.format(Float.parseFloat(FinMov.getImporte())):"" %></td>
			<td style="text-align:right"><%=FinMov.getNaturaleza().equals("C")?formato.format(Float.parseFloat(FinMov.getImporte())):"" %></td>
			<td style="text-align:right"><%=formato.format(total) %></td>
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

<%@ include file= "../../cierra_elias.jsp" %>