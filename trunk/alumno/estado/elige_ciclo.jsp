<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="aca.ciclo.CicloLista"%>
<%@page import="aca.ciclo.Ciclo"%>
<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"></jsp:useBean>

<%
	String escuelaId = (String) session.getAttribute("escuela");
		ArrayList lisCiclo = new ArrayList();
		lisCiclo = cicloL
				.getListTodo(conElias, escuelaId, "ORDER BY 1");

		String cicloId = request.getParameter("cicloId");
		String cicloNombre = request.getParameter("cicloNombre");
%>

<body>
	<div id="content">
		<h2>Elegir Ciclo</h2>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="estado.jsp?Accion=0"><i
				class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
		</div>

		<form name="documento" method="post" action="accion.jsp?Accion=1">
			<div class="well">
				<select name="cicloId" style="width: 310px;">
					<option value=""></option>
					<%
						for (int i = 0; i < lisCiclo.size(); i++) {
								Ciclo ciclo = (Ciclo) lisCiclo.get(i);
					%>
					<option value="<%=ciclo.getCicloId()%>"><%=ciclo.getCicloNombre()%></option>
					<%
						}
					%>
				</select>
				<button class="btn btn-primary"><i class="icon-ok icon-white"></i> <fmt:message key="boton.SeleccionarPlan"/></button>
			</div>
		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>