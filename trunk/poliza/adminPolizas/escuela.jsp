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
	String asociacionId = request.getParameter("AsociacionId");

//---------------- TRAER LAS ESCUELAS DE LA ASOCIACION-------------- 
	usuario.mapeaRegId(conElias, codigoId);
	String escuelaUsuario 			= usuario.getEscuela();
	String [] escuelasUsuario 		= escuelaUsuario.trim().split("-");
	
	ArrayList <aca.catalogo.CatEscuela> escuelasAsociacion = catEscuelaU.getListAsociacion(conElias, asociacionId, "ORDER BY ESCUELA_ID");
	
	ArrayList <String> EscuelasUsuario = new ArrayList<String>();
	
	for(String str: escuelasUsuario){
		for(aca.catalogo.CatEscuela esc :escuelasAsociacion){
			if(esc.getEscuelaId().equals(str))EscuelasUsuario.add(str);
		}
	}
//---------------- END TRAER LAS ESCUELAS DE LA ASOCIACION-------------- 
	
	java.util.HashMap<String, String> mapPolizas = aca.fin.FinPolizaLista.getCantidadPolizasEscuela(conElias);
	
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
	
	<div class="well">
		<a class="btn btn-primary" href="asociacion.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th rowspan="2"><fmt:message key="aca.Escuelas" /></th>
				<th class="alert alert-success" colspan="3"><fmt:message key="aca.Caja" /></th>
				<th class="alert alert-info" colspan="3"><fmt:message key="inscripcion.Inscripcion" /></th>
				<th class="alert" colspan="3"><fmt:message key="aca.General" /></th>
			</tr>
			<tr>
				<th><fmt:message key="aca.Abiertas" /></th>
				<th><fmt:message key="aca.Cerradas" /></th>
				<th><fmt:message key="aca.SunPlus" /></th>
				
				<th><fmt:message key="aca.Abiertas" /></th>
				<th><fmt:message key="aca.Cerradas" /></th>
				<th><fmt:message key="aca.SunPlus" /></th>
				
				<th><fmt:message key="aca.Abiertas" /></th>
				<th><fmt:message key="aca.Cerradas" /></th>
				<th><fmt:message key="aca.SunPlus" /></th>
			</tr>
		</thead>
		<%
			for (int i=0; i<EscuelasUsuario.size();i++){
				String escuela 	= EscuelasUsuario.get(i);
				String nombre 	= aca.catalogo.CatEscuela.getNombre(conElias, escuela);
		%>
			
				<tr>
					<td><a href="poliza.jsp?escuelaId=<%=escuela%>"><%=nombre %></a></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-C-A") ? mapPolizas.get(escuela+"-C-A") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-C-T") ? mapPolizas.get(escuela+"-C-T") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-C-C") ? mapPolizas.get(escuela+"-C-C") : "-"  %></td>
					
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-I-A") ? mapPolizas.get(escuela+"-I-A") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-I-T") ? mapPolizas.get(escuela+"-I-T") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-I-C") ? mapPolizas.get(escuela+"-I-C") : "-"  %></td>
					
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-G-A") ? mapPolizas.get(escuela+"-G-A") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-G-T") ? mapPolizas.get(escuela+"-G-T") : "-"  %></td>
					<td class="text-right"><%=mapPolizas.containsKey(escuela+"-G-C") ? mapPolizas.get(escuela+"-G-C") : "-"  %></td>
				</tr>
		<%
			} 
		%>
	</table>

</div>	

	
<%@ include file= "../../cierra_elias.jsp" %>