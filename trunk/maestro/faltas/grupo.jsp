<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="aca.ciclo.Ciclo"%>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="cicloGrupoLista" scope="page"
	class="aca.ciclo.CicloGrupoLista" />
<head>
<script type="javascript">
	function cambiaCiclo() {
		document.frmCiclo.action = "grupo.jsp";
		document.frmCiclo.Accion.value = "1";
		document.frmCiclo.submit();
	}

	function grupo(cicloGrupoId) {
		document.location.href = "alumnos.jsp?CicloGrupoId=" + cicloGrupoId;
	}
	function grupal(cicloGrupoId) {
		document.location.href = "bimestre.jsp?CicloGrupoId=" + cicloGrupoId;
	}
	function evaluaciones(cicloGrupoId) {
		document.location.href = "evaluaciones.jsp?CicloGrupoId="
				+ cicloGrupoId;
	}
</script>
</head>
<%
	String codigoId = (String) session.getAttribute("codigoId");
		String cicloId = (String) session.getAttribute("cicloId");
		String escuelaId = (String) session.getAttribute("escuela");

		if (cicloId == "XXXXXXX")
			cicloId = Ciclo.getCargaActual(conElias, escuelaId);

		ArrayList lisCiclo = new ArrayList();
		lisCiclo = CicloLista.getListActivos(conElias, escuelaId,
				"ORDER BY CICLO_ID");

		String strAccion = request.getParameter("Accion");
		if (strAccion == null)
			strAccion = "0";
		int numAccion = Integer.parseInt(strAccion);
		int i = 0, j = 0, row = 0;

		switch (numAccion) {
		case 1: {
			cicloId = request.getParameter("Ciclo");
			session.setAttribute("cicloId", cicloId);
			break;
		}
		}
		ArrayList lisCicloGrupo = new ArrayList();
		lisCicloGrupo = cicloGrupoLista.getListGrupos(conElias,
				cicloId, " ORDER BY NIVEL_ID, GRADO, GRUPO");
		String strNivel = "-1";
%>
<body>
	<div id="content">
		<h2><fmt:message key="aca.Elegir" /></h2>
		<form name="frmCiclo" action="permiso.jsp" method="post">
			<div class="well">
				<select name="Ciclo" id="Ciclo" onchange='javascript:cambiaCiclo()'
					style="width: 310px;">
					<%
						for (j = 0; j < lisCiclo.size(); j++) {
								aca.ciclo.Ciclo ciclo = (aca.ciclo.Ciclo) lisCiclo.get(j);
								if (ciclo.getCicloId().equals(cicloId)) {
									out.print(" <option value='" + ciclo.getCicloId()
											+ "' Selected>" + ciclo.getCicloNombre()
											+ "</option>");
								} else {
									out.print(" <option value='" + ciclo.getCicloId()
											+ "'>" + ciclo.getCicloNombre() + "</option>");
								}
							}
					%>
				</select>
			</div>
		</form>

		<%
			for (i = 0; i < lisCicloGrupo.size(); i++) {
					row++;
					aca.ciclo.CicloGrupo grupo = (aca.ciclo.CicloGrupo) lisCicloGrupo
							.get(i);
					if (!grupo.getNivelId().equals(strNivel)) {
						strNivel = grupo.getNivelId();
						row = 1;
		%>


		<tr>
			<td align="center" colspan="5">&nbsp;</td>
		</tr>

		<table width="70%" align="center"
			class="table table-fullcondensed table-nohover">
			<tr>
				<td style="text-align: center; border: 1px solid gray;" align="center" colspan="4"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, strNivel)%></td>
				<td colspan="3" style="text-align: center; border: 1px solid gray;"><fmt:message key="aca.VerFaltas" /></td>
			</tr>
			<tr>
				<th width="5%" align="center">#</th>
				<th width="20%" align="center"><fmt:message key="aca.Grado" /></th>
				<th width="5%" align="center"><fmt:message key="aca.Grupo" /></th>
				<th width="50%" align="center"><fmt:message key="aca.Maestro" /></th>
				<th width="10%" align="center"><fmt:message key="aca.Plan" /></th>
				<th width="5%" align="center"><fmt:message key="aca.Alumnos" /></th>
				<th width="5%" align="center"><fmt:message key="aca.Evaluaciones" /></th>
			</tr>

			<%
				} //if de cambia nivel
			%>
			<tr>
				<td align="center"><strong><%=row%></strong></td>
				<td align="left">&nbsp; <%=aca.catalogo.CatNivel.getGradoNombre(Integer
							.parseInt(grupo.getGrado()))%>
				</td>
				<td align="center"><strong>"<%=grupo.getGrupo()%>"
				</strong></td>
				<td align="left"><%=aca.empleado.EmpPersonal.getNombre(conElias,
							grupo.getEmpleadoId(), "NOMBRE")%></td>
				<td style="text-align: center;"
					title="<%=aca.plan.Plan.getNombrePlan(conElias,
							grupo.getPlanId())%>"><strong><%=grupo.getPlanId()%></strong></td>
				<td style="text-align: center; cursor:pointer;"
					onclick="grupo('<%=grupo.getCicloGrupoId()%>');"
					onmouseover="this.style.backgroundColor='#F2F2F2';"
					onmouseout="this.style.backgroundColor='';"><img
					src="../../imagenes/ir.png" width="28px" height="22px" /></td>
				<td style="text-align: center; cursor:pointer;"
					onclick="evaluaciones('<%=grupo.getCicloGrupoId()%>');"
					onmouseover="this.style.backgroundColor='#F2F2F2';"
					onmouseout="this.style.backgroundColor='';"><img
					src="../../imagenes/ir.png" width="28px" height="22px" /></td>
			</tr>
			<%
				} //fin de for
			%>
		</table>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
