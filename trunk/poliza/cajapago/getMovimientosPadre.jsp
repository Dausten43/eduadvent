<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../idioma.jsp" %>

<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivel"/>
<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovL" scope="page" class="aca.fin.FinMovimientosLista"/>

<%
	String codigoId = request.getParameter("padre");

	ArrayList<aca.alumno.AlumPadres> lisAlumPadres = alumPadresLista.getListTutor(conElias, codigoId, "ORDER BY 1");
	
	String hijos = "";
	for(aca.alumno.AlumPadres alum : lisAlumPadres){
		hijos += "'"+alum.getCodigoId()+"',";
	}
	if(hijos.length()>0){
		hijos = hijos.substring(0, hijos.length()-1);
	}else{
		hijos = "''";
	}
	
%>

<table class="table table-condensed table-striped table-bordered" style="margin:0;">
	<thead>
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Codigo" /></th>
			<th><fmt:message key="aca.Nombre" /></th>
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
	ArrayList<aca.fin.FinMovimientos> lisMovimientos = FinMovL.getMovimientosHijos(conElias, hijos, "ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD'), MOVIMIENTO_ID");
	for(int i = 0; i < lisMovimientos.size(); i++){
		FinMov = (aca.fin.FinMovimientos) lisMovimientos.get(i);
		if(FinMov.getNaturaleza().equals("D"))
			total -= Float.parseFloat(FinMov.getImporte());
		else
			total += Float.parseFloat(FinMov.getImporte());
%>
		<tr>
			<td align="center"><%=i+1 %></td>
			<td><%=FinMov.getAuxiliar() %></td>
			<td><%=aca.alumno.AlumPersonal.getNombre(conElias, FinMov.getAuxiliar(), "NOMBRE") %></td>
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

<%@ include file= "../../cierra_elias.jsp" %>