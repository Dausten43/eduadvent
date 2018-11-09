<%@page import="aca.fin.FinSaldoAlumno"%>
<%@page import="java.util.Map"%>
<%@page import="aca.fin.FinMovimientosLista"%>
<%@ include file="../../con_elias.jsp"%>

<%


FinMovimientosLista fml = new FinMovimientosLista();

if(request.getParameter("cta")!=null){
	Map<String,FinSaldoAlumno> mapSaldos = fml.getMapSaldosCta(conElias, request.getParameter("cta"),request.getParameter("escuela"), request.getParameter("fechai"),request.getParameter("fechaf"));
	
	%>
	
	<table class="table table-bordered ">
		<tr>
			<th>Codígo</th>
			<th>Nombre</th>
			<th>Saldo</th>
			<th></th>
		</tr>
		<% 
		BigDecimal suma = BigDecimal.ZERO;
		for(String al : mapSaldos.keySet()){ 
				FinSaldoAlumno sa = mapSaldos.get(al);
				suma = suma.add(sa.getSaldo());
		%>
				
		<tr>
			<td><%= al %></td>
			<td><%= sa.getNombre() %> <%= sa.getApaterno() %> <%= sa.getAmaterno() %></td>
			<td style="text-align: right;"><%= sa.getSaldo().setScale(2) %></td>
			<td></td>
		</tr>
		<% } %>
		<tr>
			<td></td>
			<td style="text-align: right;">Total</td>
			<td style="text-align: right;"><%= suma.setScale(2) %></td>
			<td></td>
		</tr>
	</table>
	
	<%
	
}

%>



<%@ include file="../../cierra_elias.jsp"%>