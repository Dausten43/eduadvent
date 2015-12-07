<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="ejercicioL" scope="page" class="aca.fin.FinEjercicioLista" />
<jsp:useBean id="ejerc" scope="page" class="aca.fin.FinEjercicio" />

<script>
	function cambiar(ejercicioId) {
		document.location = "elegir.jsp?Accion=1&ejerId=" + ejercicioId;
	}
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");

	ArrayList<aca.fin.FinEjercicio> listaEjercicios = ejercicioL.getListPorEscuela(conElias, escuelaId, "ORDER BY YEAR");

	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	if (accion.equals("1")) {
		session.setAttribute("ejercicioId", request.getParameter("ejerId"));
	}

	ejerc.mapeaRegId(conElias, (String) session.getAttribute("ejercicioId"));
%>

<div id="content">
	<h2>
		<fmt:message key="aca.ElegirEjercicio" /> 
	</h2>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <%=ejerc.getYear()%>
	</div>

	<table class="table table-condensed table-striped table-bordered">
		<tr>
			<th style="width:12%;"><fmt:message key="aca.Id" /></th>
			<th><fmt:message key="aca.Ano" /></th>
			<th><fmt:message key="aca.FechaInicio" /></th>
			<th><fmt:message key="aca.FechaFinal" /></th>
		</tr>
		<%for (aca.fin.FinEjercicio ejer : listaEjercicios){%>
			<tr>
				<td>
					<a href="javascript:cambiar('<%=ejer.getEjercicioId()%>');"><%=ejer.getEjercicioId()%></a>
				</td>
				<td><%=ejer.getYear()%></td>
				<td><%=ejer.getFechaIni()%></td>
				<td><%=ejer.getFechaFin()%></td>
			</tr>
		<%}%>
	</table>
</div>

<%@ include file="../../cierra_elias.jsp"%>