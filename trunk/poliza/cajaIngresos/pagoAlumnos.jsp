<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinCalculoLista" scope="page" class="aca.fin.FinCalculoLista"/>

<script>	
	
	function cambiaCiclo(){
		document.forma.submit();
	}	

</script>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00");

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("EjercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");				
	String cicloId		= request.getParameter("cicloId")==null?"":request.getParameter("cicloId");
	String periodoId	= request.getParameter("periodoId")==null?"":request.getParameter("periodoId");
	String pagoId		= request.getParameter("pagoId")==null?"":request.getParameter("pagoId");
	
	// Lista de alumnos en el pago
	java.util.ArrayList<String> lisAlumnos = FinCalculoLista.listAlumnosEnPago(conElias, cicloId, periodoId, pagoId, "'A'", " ORDER BY 1");
	
	// Map de importes del pago por cada alumno
	java.util.HashMap<String, String> mapPago = FinCalculoLista.mapAlumnosEnPago(conElias, cicloId, periodoId, pagoId, "'A'");
%>

<div id="content">
	
	<h2><fmt:message key="aca.Movimiento" /></h2>	
	
	<div class="well">
			
	</div>
	<table class="table table-striped">
	<tr>
		<th>#</td>
		<th>Matricula</th>
		<th>Nombre</th>
		<th style="text-align:right">Importe</th>
	</tr>
<% 	
	for(String alumno:lisAlumnos){
		double importe = 0.0;
		if (mapPago.containsKey(alumno)){
			importe = Double.parseDouble(mapPago.get(alumno));
		}
%>		
	<tr>
		<td></td>
		<td><%=alumno%></td>
		<td>&nbsp;</td>
		<td style="text-align:right"><%=formato.format(importe)%></td>
	</tr>
<%	
	}

%>		
	</table>		
</div>

<%@ include file= "../../cierra_elias.jsp" %>