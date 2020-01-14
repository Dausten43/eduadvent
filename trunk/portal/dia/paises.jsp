<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="CatEstado" scope="page" class="aca.catalogo.CatEstado"/>
<jsp:useBean id="CatPais" scope="page" class="aca.catalogo.CatPais"/>
<jsp:useBean id="CatEstadoLista" scope="page" class="aca.catalogo.CatEstadoLista"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoId 		= (String)session.getAttribute("codigoId");
	int row 	= 0;
	int cont 	= 0;
	String paisId			= request.getParameter("paisId")==null?"0":request.getParameter("paisId");
	
	ArrayList<aca.catalogo.CatEstado> lisEstado = CatEstadoLista.getEscEstadoPais(conElias, paisId, "ORDER BY ESTADO_ID");
	
	/* HashMap que obtiene el numero de escuelas por estado*/
	java.util.HashMap<String,String> mapEstado	= CatEstadoLista.getMapEstTotEsc(conElias, paisId);
%>
<div id="content">
	<h3>Pais: <%=CatPais.getPais(conElias, paisId) %>
	<a class="btn btn-info" href="escuelas.jsp"><i class="icon-white icon-arrow-left"></i></a>
	</h3>		
</div>	
	<table class="table table-bordered table-striped">
	<tr>
		<th>#</th>
		<th>Estado</th>
		<th>Total</th>
	</tr>	
	<%
	int totEsc = 0;
	for( aca.catalogo.CatEstado estado: lisEstado){
		// Buscar el numero de asociacione en la union
		String estados = "0";
		if ( mapEstado.containsKey(estado.getEstadoId()) ){
			estados = mapEstado.get(estado.getEstadoId());
			totEsc  += Integer.parseInt(estados); 
			cont++;
%>	
			<tr>
				<td><%= cont %></td>
				<td><%= estado.getEstadoNombre()%></td>
				<td style="text-align:right"><%= estados%></td>
			</tr>
<%	
		}
	}%>	
	<tr>
		<td colspan="2" style="text-align:center"><h4>Total</h4></td>
		<td style="text-align:right"><%= totEsc%></td>
	</tr>
	</table>
<script>
	jQuery('.escuelas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>