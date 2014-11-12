<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatAsociaciones" scope="page" class="aca.catalogo.CatAsociacion"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="catEscuelaU" scope="page" class="aca.catalogo.CatEscuelaLista"/>
	
	
<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String)session.getAttribute("codigoId");
 
	ArrayList<String> AsociacionesDelUsuario = aca.usuario.Usuario.AsociacionesDelUsuario(conElias, codigoId); 
	
	java.util.HashMap<String, String> mapPolizas = aca.fin.FinPolizaLista.getCantidadPolizasAsociacion(conElias);
	
%>

<style>
	.table tr td:nth-child(4), .table tr td:nth-child(7), .table tr:nth-child(2) th:nth-child(3), .table tr:nth-child(2) th:nth-child(6)  {
		border-right: 1px solid #D8D8D8;
	}
</style>

<div id="content">
	
	<h2>
		<fmt:message key="aca.Polizas" />
	</h2>
	
	<div class="well text-right">
		<a href="historialDescargas.jsp" class="btn btn-info"><i class="icon-white icon-time"></i> <fmt:message key="aca.HistorialDescargas" /></a> 
	</div>
	
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th rowspan="2"><fmt:message key="aca.Asociaciones" /></th>
				<th class="alert alert-success" colspan="3"><fmt:message key="aca.Caja" /></th>
				<th class="alert alert-info" colspan="3"><fmt:message key="inscripcion.Inscripcion" /></th>
				<th class="alert" colspan="3"><fmt:message key="aca.General" /></th>
			</tr>
			<tr>
				<th class="text-right"><fmt:message key="aca.Abiertas" /></th>
				<th class="text-right">
					<a style="float: left;" href="javascript:if(confirm('<fmt:message key="js.ConfirmaExportarSunplus" />')){location.href='exportarCajaSunPlusAsociaciones.jsp';}" class="btn btn-mini btn-info" title="Exportar a SunPlus"><i class="icon-arrow-up icon-white"></i> SunPlus</a>
					<fmt:message key="aca.Cerradas" />
				</th>
				<th class="text-right"><fmt:message key="aca.SunPlus" /></th>
				
				<th class="text-right"><fmt:message key="aca.Abiertas" /></th>
				<th class="text-right">
					<a style="float: left;" href="javascript:if(confirm('<fmt:message key="js.ConfirmaExportarSunplus" />')){location.href='exportarInscripcionSunPlusAsociaciones.jsp';}" class="btn btn-mini btn-info" title="Exportar a SunPlus"><i class="icon-arrow-up icon-white"></i> SunPlus</a>
					<fmt:message key="aca.Cerradas" />
				</th>
				<th class="text-right"><fmt:message key="aca.SunPlus" /></th>
				
				<th class="text-right"><fmt:message key="aca.Abiertas" /></th>
				<th class="text-right"><fmt:message key="aca.Cerradas" /></th>
				<th class="text-right"><fmt:message key="aca.SunPlus" /></th>
			</tr>
		</thead>
		<%
			for (int i=0; i<AsociacionesDelUsuario.size();i++){
				String asociacionId = AsociacionesDelUsuario.get(i);
				String nombre 		= aca.catalogo.CatAsociacion.getNombre(conElias, asociacionId);
		%>
			
				<tr>
					<td><a href="escuela.jsp?AsociacionId=<%=asociacionId%>"><%=nombre %></a></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-C-A") ? mapPolizas.get(asociacionId+"-C-A") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-C-T") ? mapPolizas.get(asociacionId+"-C-T") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-C-C") ? mapPolizas.get(asociacionId+"-C-C") : "-"  %></td>
					
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-I-A") ? mapPolizas.get(asociacionId+"-I-A") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-I-T") ? mapPolizas.get(asociacionId+"-I-T") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-I-C") ? mapPolizas.get(asociacionId+"-I-C") : "-"  %></td>
					
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-G-A") ? mapPolizas.get(asociacionId+"-G-A") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-G-T") ? mapPolizas.get(asociacionId+"-G-T") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(asociacionId+"-G-C") ? mapPolizas.get(asociacionId+"-G-C") : "-"  %></td>
				</tr>
		<%
			} 
		%>
	</table>

</div>	

	
<%@ include file= "../../cierra_elias.jsp" %>