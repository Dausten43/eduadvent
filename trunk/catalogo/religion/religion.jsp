<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="religionLista" scope="page"
	class="aca.catalogo.CatReligionLista" />
<head>
<script>
	function Borrar(EscuelaId) {
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			document.location = "accion.jsp?Accion=4&EscuelaId=" + EscuelaId;
		}
	}
</script>
</head>
<%
	ArrayList lisReligion = new ArrayList();
		lisReligion = religionLista.getListAll(conElias,
				" ORDER BY RELIGION_ID, RELIGION_NOMBRE");
		String escuelaId = (String) session.getAttribute("escuela");
%>
<body>
	<div id="content">

		<h2><fmt:message key="catalogo.ListadoDeRelig" /></h2>

		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
		</div>


		<table class="table table-condensed">
			<tr>
				<th width="3%"><fmt:message key="aca.Operacion" /></th>
				<th width="5%">#</th>
				<th width="30%"><fmt:message key="aca.Nombre" /></th>

			</tr>
			<%
				for (int i = 0; i < lisReligion.size(); i++) {
						aca.catalogo.CatReligion relig = (aca.catalogo.CatReligion) lisReligion
								.get(i);
			%>
			<tr>
				<td align="center"><a class="icon-pencil"
					href="accion.jsp?Accion=5&ReligionId=<%=relig.getReligionId()%>&ReligionNombre=<%=relig.getReligionNombre()%>">
				</a> <a class="icon-remove"
					href="accion.jsp?Accion=4&ReligionId=<%=relig.getReligionId()%>&ReligionNombre=<%=relig.getReligionNombre()%>"
					onclick="javascript:confirm('Esta seguro de borrar este registro?');"></a>

				</td>
				<td align="center"><%=relig.getReligionId()%></td>
				<td>&nbsp;<%=relig.getReligionNombre()%></td>
			</tr>
			<%
				}
					lisReligion = null;
			%>
		</table>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
