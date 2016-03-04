<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="CatSeguro" scope="page" class="aca.catalogo.CatSeguro" />
<jsp:useBean id="CatSeguroL" scope="page" class="aca.catalogo.CatSeguroLista" />


<script>
	function eliminar(escuelaId, year) {
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			location = "poliza.jsp?Accion=1&escuelaId=" + escuelaId + "&year=" + year;
		}
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");

	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if (accion.equals("1")) {
		CatSeguro.setEscuela(request.getParameter("escuelaId"));
		CatSeguro.setYear(request.getParameter("year"));
			
		if (CatSeguro.deleteReg(conElias)) {
			msj = "Eliminado";
		} else {
			msj = "NoElimino";
		}
	}
	
	ArrayList<aca.catalogo.CatSeguro> lisSeguros = CatSeguroL.getListAll(conElias, escuelaId, "");
%>

<div id="content">
	<h2><fmt:message key="aca.Periodos" /></h2>
	

	<form id="forma" name="forma" action="notas.jsp" method="post">
		
		<div class="well">
			<a class="btn btn-primary btn-mobile" href="accion.jsp?"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
		</div>
	</form>
	<table class="table table-bordered">
		<tr>
			<th width="5%">#</th>
			<th width="10%"><fmt:message key="aca.Op" /></th>
			<th width="10%"><fmt:message key="aca.Ano" /></th>
			<th width="75%"><fmt:message key="aca.Poliza" /></th>
		</tr>
<%
			int cont = 1;
			for(aca.catalogo.CatSeguro seguro : lisSeguros){
%>
		<tr>
			<td><%=cont %></td>
			<td>
				<a href="accion.jsp?escuelaId=<%=seguro.getEcuelaId()%>&year=<%=seguro.getYear()%>&Accion=2"><i class="icon-pencil"></i></a>
				<a onclick="eliminar('<%=seguro.getEcuelaId()%>', '<%=seguro.getYear()%>');"><i class="icon-remove"></i></a>
			</td>
			<td><%=seguro.getYear()%></td>
			<td><%=seguro.getPoliza() %></td>
		</tr>
<%	
				cont++;
			}
%>
	</table>
	

	
</div>

<%@ include file="../../cierra_elias.jsp"%>