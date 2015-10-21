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
	
	java.util.HashMap<String, String> mapAlumPago = FinCalculoLista.getListAlumnosPagos(conElias, cicloId, periodoId, pagoId);
%>

<div id="content">
	
	<h2><fmt:message key="aca.Movimiento" /></h2>	
	
	<div class="alert alert-info">
			
	</div>
	<table>	
<% 	for(int x=0; x<mapAlumPago.size(); x++){
%>		
	<tr>
		<td></td>
		<td><%=mapAlumPago.get(x)%></td>
	</tr>
<%	
	}

%>		
	</table>		
</div>

<%@ include file= "../../cierra_elias.jsp" %>