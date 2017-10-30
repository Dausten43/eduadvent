
<%@page import="aca.fin.FinEdoCtaReporte"%>
<%@page import="java.util.List"%>
<%@page import="aca.fin.FinAlumSaldos"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%

String escuelaId = session.getAttribute("escuela")!=null ? (String) session.getAttribute("escuela") : "000";
System.out.println(escuelaId);
FinAlumSaldos als = new FinAlumSaldos();

List<FinEdoCtaReporte> saldos = new ArrayList();

saldos.addAll(als.getSaldosNoMatriculados(conElias, escuelaId));

%>

<div class="well">
<h3>Deudores no inscritos</h3>
</div>

<table class="table table-bordered table-hover" style="width: 80%; margin: 0px auto;">
<thead>
	<tr style="text-align: center;">
		<th>Codígo</th>
		<th>Nombre</th>
		<th>Nivel</th>
		<th>Ultimo Movimiento</th>
		<th>Deudor</th>
		<th>Acreedor</th>
	</tr>
</thead>
<tbody>
	<%
	for(FinEdoCtaReporte fr : saldos){
		if(fr.getSaldo().compareTo(BigDecimal.ZERO)!=0){
	%>
	<tr>
		<td><%= fr.getCodigoid() %></td>
		<td><%= fr.getNombre() %></td>
		<td><%= fr.getNivelgradogrupo() %></td>
		<td><%= fr.getFfinal() %></td>
		<td style="text-align: right;"><%= fr.getNaturaleza().equals("D")? fr.getSaldo().setScale(2) : "-"  %></td>
		<td style="text-align: right;"><%= fr.getNaturaleza().equals("C")? fr.getSaldo().setScale(2) : "-"  %></td>
		
	</tr>
	<%
		}
	}
	%>
</tbody>


</table>


<%@ include file="../../cierra_elias.jsp"%>