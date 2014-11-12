<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="escuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>

<%
		ArrayList lisEscuela					= new ArrayList();
		lisEscuela	 						= escuelaLista.getListAll(conElias," ORDER BY ESCUELA_NOMBRE");

%>

<body>
	<br>
	<table align="center" border="0" width="70%">
		<tr>
			<td colspan="3" align="center">
				<font size="3" face="Arial"><strong>Escuelas</strong></font>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<font size="2" face="Arial">Seleccionar una escuela</font>
			</td>
		</tr>
		<tr>
			<th>#</th>
			<th>Nombre</th>
			<th>Dirección</th>
		</tr>
<%
	for (int i=0; i< lisEscuela.size(); i++){
		aca.catalogo.CatEscuela escuela = (aca.catalogo.CatEscuela) lisEscuela.get(i);
%>
		<tr>
			<td align="center"><%=i+1%></td>
			<td><a href="action.jsp?Accion=1&EscuelaId=<%=escuela.getEscuelaId()%>" title="Seleccionar Escuela"><%=escuela.getEscuelaNombre()%></a></td>
			<td><%=escuela.getDireccion()%></td>
		</tr>
<%} %>
	<tr>
	  <td colspan="3" align="center">Fin del Listado</td>
	</tr>
	</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 