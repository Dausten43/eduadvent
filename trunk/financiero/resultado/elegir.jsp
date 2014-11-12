<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@ page import="aca.cont.ContEjercicio"%>

<jsp:useBean id="contMascara" scope="page" class="aca.cont.ContMascara"/>
<jsp:useBean id="contEjercicioL" scope="page" class="aca.cont.ContEjercicioLista"/>
<%
	String ejercicioId 					= request.getParameter("ejercicioId");
	
	ArrayList<ContEjercicio> lisEjercicios = contEjercicioL.getListAll(conElias, "ORDER BY EJERCICIO_ID");
	
	if(ejercicioId == null)
		ejercicioId 					= (String) session.getAttribute("ejercicioId");
	
	contMascara.mapeaRegId(conElias, "1");
%>
<body>
<form id="forma" name="forma" action="elegir.jsp" method="post">
<table width="95%" align="center">
	<tr>
		<td class="titulo">Resultado General</td>
	</tr>
	<tr>
		<td align="center">
			<select id="ejercicioId" name="ejercicioId" onchange="document.forma.submit();">
<%
	for(ContEjercicio contEjercicio: lisEjercicios){
%>
				<option value="<%=contEjercicio.getEjercicioId() %>"><%=contEjercicio.getEjercicioNombre() %></option>
<%
	}
%>
			</select>
		</td>
	</tr>
</table>
</form>

<table width="40%" align="center">
	<tr>
		<th>
			Elige el Nivel de Datalle
		</th>
	</tr>
<%
	for(int i = 0; i < contMascara.getMascResultado().length(); i++){
%>
	<tr class="button" onclick="location.href='general.jsp?ejercicioId=<%=ejercicioId %>&nivel=<%=i+1 %>';">
		<td align="center"><a href="general.jsp?ejercicioId=<%=ejercicioId %>&nivel=<%=i+1 %>">Nivel <%=i+1 %></a></td>
	</tr>
<%
	}
%>
</table>
</body>
<%@ include file= "../../cierra_elias.jsp" %>