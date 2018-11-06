
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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

String fecha = "";
SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
fecha = sdf.format(new Date());

if(request.getParameter("fecha")!=null){
	fecha = request.getParameter("fecha");
}

List<FinEdoCtaReporte> saldos = new ArrayList();

saldos.addAll(als.getSaldosNoMatriculadosFecha(conElias, escuelaId,fecha));

%>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript"	src="../../bootstrap/datepicker/datepicker.js"></script>
<div class="well">
<form name="forma" action="" method='post' class="form-inline">
<div class="form-group">
<h3>Deudores no inscritos</h3>&nbsp;&nbsp;&nbsp;&nbsp;
<label>Fecha final:</label><input type="text" name="fecha" id="fecha" data-date-format="dd-mm-yyyy" value="<%=fecha%>"  class="form-control" style="width: 100px; text-align: center;" >
			<input type="submit" name="enviar" value="Generar" class="btn btn-success"> 
</div>
</form>
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
<script>
jQuery('#fecha').datepicker();
</script>

<%@ include file="../../cierra_elias.jsp"%>