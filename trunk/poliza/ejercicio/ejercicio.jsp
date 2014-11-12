<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="ejercicioL" scope="page" class="aca.fin.FinEjercicioLista"/>

<script>
	function Borrar( EjercicioId ){
		if(confirm("<fmt:message key='js.Confirma' />")){
	  		document.location="accion.jsp?Accion=2&Id="+EjercicioId;
	  	}
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");

	ArrayList<aca.fin.FinEjercicio> listaEjercicios = ejercicioL.getListPorEscuela(conElias, escuelaId, "ORDER BY YEAR");
%>

<div id="content">
	<h2><fmt:message key="aca.Ejercicios" /></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="accion.jsp">
			<i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a>
	</div>

	<table class="table table-condensed table-bordered table-striped table-fontsmall">
		<tr>
			<th style="width:3%;"><fmt:message key="aca.Borrar" /></th>
			<th><fmt:message key="aca.Id" /></th>
			<th><fmt:message key="aca.Ano" /></th>
		</tr>
		<%for(aca.fin.FinEjercicio ejer : listaEjercicios){%>
			<tr>
				<td>
					<a href="javascript:Borrar('<%=ejer.getEjercicioId()%>')">
						<i class="icon-remove"></i>
					</a> 
				</td>
				<td><%=ejer.getEjercicioId()%></td>
				<td><%=ejer.getYear()%></td>
			</tr>
		<%}%>
	</table>

</div>

<%@ include file= "../../cierra_elias.jsp" %>