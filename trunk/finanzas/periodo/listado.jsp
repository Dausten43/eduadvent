<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>

<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo" />
<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="cicloPeriodo" scope="page"
	class="aca.ciclo.CicloPeriodo" />
<jsp:useBean id="cicloPeriodoL" scope="page"
	class="aca.ciclo.CicloPeriodoLista" />
<jsp:useBean id="AlumCicloLista" scope="page"
	class="aca.alumno.AlumCicloLista" />

<head>
<script type="text/javascript" src="../../js/prototype.js"></script>
<script type="text/javascript">
	function eliminar(ciclo, periodo, cantAlumnos) {
		if (cantAlumnos > 0) {
			alert("Este periodo no puede ser eliminado porque tiene asignados "
					+ cantAlumnos + " alumnos");
		} else if (confirm("¿Esta seguro de querer elminar el periodo "
				+ periodo + " del ciclo " + ciclo + "?")) {
			location = "listado.jsp?Accion=1&ciclo=" + ciclo + "&periodo="
					+ periodo;
		}
	}
</script>
</head>
<%
	String escuelaId = (String) session.getAttribute("escuela");
		String cicloId = request.getParameter("ciclo");
		String accion = request.getParameter("Accion");

		ArrayList lisCiclo = cicloL.getListAll(conElias, escuelaId,
				"ORDER BY F_INICIAL");

		if (cicloId == null) {
			cicloId = (String) session.getAttribute("cicloId");
			if (!cicloId.substring(0, 2).equals(escuelaId)) { // Esto es por si en sesion hay cargado un ciclo que pertenece a otra escuela
				ciclo = (Ciclo) lisCiclo.get(0);
				cicloId = ciclo.getCicloId();
				session.setAttribute("cicloId", cicloId);
			}
		} else
			session.setAttribute("cicloId", cicloId);

		if (accion == null)
			accion = "0";

		if (accion.equals("1")) {
			cicloPeriodo.mapeaRegId(conElias, cicloId,
					request.getParameter("periodo"));
			if (cicloPeriodo.deleteReg(conElias)) {
%>
<table align="center" onmouseover="$(this).remove();">
	<tr>
		<td><font color="blue" size="3"><b>Se elimin&oacute;
					correctamente el periodo</b></font></td>
	</tr>
</table>
<%
	} else {
%>
<table align="center" onmouseover="$(this).remove();">
	<tr>
		<td><font color="red" size="3"><b>Ocurri&oacute; un
					error al eliminar. Int&eacute;ntelo de nuevo</b></font></td>
	</tr>
</table>
<%
	}
		}
%>
<body>
	<div id="content">
		<h2>Períodos del ciclo</h2>

		<form id="forma" name="forma" action="listado.jsp" method="post">
			<div class="well">
				<select id="ciclo" name="ciclo" onchange="document.forma.submit();"
					style="width: 310px; margin-bottom: 0;">
					<%
						for (int i = 0; i < lisCiclo.size(); i++) {
								ciclo = (Ciclo) lisCiclo.get(i);
					%>
					<option value="<%=ciclo.getCicloId()%>"
						<%=cicloId.equals(ciclo.getCicloId()) ? " Selected"
							: ""%>><%=ciclo.getCicloNombre()%></option>
					<%
						}
					%>
				</select>
				&nbsp;<a class="btn btn-primary"
				href="edita_periodo.jsp?ciclo=<%=cicloId%>"><i
				class="icon-file icon-white"></i> Nuevo</a>
			</div>
		</form>

			<table width="60%" class="table table-condensed"finanza/costo/tabla.jsp"">
				<%
					ArrayList lisCicloPeriodo = cicloPeriodoL.getListCiclo(
								conElias, cicloId, "ORDER BY F_INICIO");
						if (lisCicloPeriodo.size() > 0) {
				%>
				<tr>
					<th>Operación</th>
					<th>Nombre</th>
					<th>F. Inicio</th>
					<th>F. Final</th>
				</tr>
				<%
					for (int i = 0; i < lisCicloPeriodo.size(); i++) {
								cicloPeriodo = (CicloPeriodo) lisCicloPeriodo.get(i);
								int cantAlumnos = AlumCicloLista.getListAll(
										conElias,
										escuelaId,
										" AND CICLO_ID='" + cicloId
												+ "' AND PERIODO_ID='"
												+ cicloPeriodo.getPeriodoId() + "' ")
										.size();
				%>
				<tr>
					<td align="center">
					<a onclick="location = 'edita_periodo.jsp?ciclo=<%=cicloId%>&periodo=<%=cicloPeriodo.getPeriodoId()%>'"><i class="icon-pencil"></i></a>
					 <%
 	if (!CicloPeriodo.tieneDatos(conElias, cicloId,
 						cicloPeriodo.getPeriodoId())) {
 %>
						<a onclick="eliminar('<%=cicloId%>', '<%=cicloPeriodo.getPeriodoId()%>', '<%=cantAlumnos%>');"><i class="icon-remove"></i></a>
						 <%
 	}
 %></td>
					<td><%=cicloPeriodo.getPeriodoNombre()%></td>
					<td align="center"><%=cicloPeriodo.getFInicio()%></td>
					<td align="center"><%=cicloPeriodo.getFFinal()%></td>
				</tr>
				<%
					} 
						} else {
				%>
				<tr>
					<td align="center">No existen periodos para este Ciclo</td>
				</tr>
				<%
					}
				%>
			</table>
		</td>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>