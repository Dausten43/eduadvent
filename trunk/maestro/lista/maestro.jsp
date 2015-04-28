<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="aca.ciclo.Ciclo"%>

<jsp:useBean id="Nivel" scope="page" class="aca.usuario.Usuario" />
<jsp:useBean id="EmpPersonalL" scope="page" class="aca.empleado.EmpPersonalLista" />
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo" />
<%
	String codigoId 		= (String) session.getAttribute("codigoId");
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	String cicloId 			= request.getParameter("ciclo") == null ? Ciclo.getCargaActual(conElias, escuelaId) : request.getParameter("ciclo");
	String nivel 			= Nivel.getNivel(conElias, codigoId);
	
	String[] listaNivel 	= nivel.split("-");
%>
<body>
	<div id="content">
		<h2>Lista de Maestros</h2>

		<form id="frmMaestro" name="frmMaestro" action="maestro.jsp" method="post">
			<div class="well">
				<select id="ciclo" name="ciclo" onchange="document.frmMaestro.submit();" style="width: 360px;">
				<%
					ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListAll( conElias, escuelaId, "ORDER BY CICLO_ID");
						for (int i = 0; i < lisCiclo.size(); i++) {
							ciclo = (aca.ciclo.Ciclo) lisCiclo.get(i);
				%>
					<option value="<%=ciclo.getCicloId()%>" <%=ciclo.getCicloId().equals(cicloId) ? " Selected" : ""%>>[<%=ciclo.getCicloId()%>]&nbsp;<%=ciclo.getCicloNombre()%></option>
					<%
						}
					%>
				</select>
			</div>
		</form>
		<br>
		<%
			for (int j = 1; j < listaNivel.length; j++) {
				ArrayList<aca.empleado.EmpPersonal> lisMaestro = EmpPersonalL.getListMaestroxNivel(conElias, escuelaId, listaNivel[j], cicloId, " ORDER BY NOMBRE");			
				if (lisMaestro.size() > 0) {
		%>
		<table width="50%" border="0" align="center" class="table table-condensed">
			<tr>
				<th colspan="3"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, listaNivel[j] + "")%></th>
			</tr>

			<%
				for (int i = 0; i < lisMaestro.size(); i++) {
			%>
			<tr class=button
				onclick="location='materias.jsp?EmpleadoId=<%=lisMaestro.get(i).getCodigoId()%>&NivelId=<%=listaNivel[j]%>&cicloId=<%=cicloId%>'">
				<td align="center" width="1%"><%=i + 1%></td>
				<td align="center" width="1%"><%=lisMaestro.get(i).getCodigoId()%></td>
				<td width="5%"><%=lisMaestro.get(i).getNombre() + " "
									+ lisMaestro.get(i).getApaterno() + " "
									+ lisMaestro.get(i).getAmaterno()%></td>
			</tr>
			<%
				}
			%>
		</table>
		<br>
		<%
			}
				}
		%>
		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>