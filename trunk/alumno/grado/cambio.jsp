<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<script>
	function recarga(){
		document.frmEscuela.submit();
	}
</script>
<%
		//Declaracion de Variables
		String escuelaId					= (String) session.getAttribute("escuela");
		String cicloId						= request.getParameter("cicloId");
		ArrayList lisPeriodo					= new ArrayList();
		lisPeriodo	 						= cicloLista.getListActivos(conElias, escuelaId, "ORDER BY 1");

%>
<body>
	<br>
	<form name="frmEscuela" method="post" action="cambio.jsp">
	<table width="50%" border="0" align="center">
		<tr>
			<td align="center"><fmt:message key="aca.ElegirPeriodoAca"/><</td>
		</tr>
		<tr>
			<td align="center">
				<select name="escuela" onchange="javascript:recarga()">
<%	
		for(int i=0;i< lisPeriodo.size(); i++){
			aca.ciclo.Ciclo periodo = (aca.ciclo.Ciclo) lisPeriodo.get(i);
			System.out.println("periodo: "+periodo.getCicloId()+" | cicloId: "+cicloId);
%>
					<option value="<%=periodo.getCicloId()%>" <%if(periodo.getCicloId().equals(cicloId)) out.print("selected");%>><%=periodo.getCicloNombre()%></option>
<%} %>
				</select>
			</td>
		</tr>
	</table>
	</form>
<%
	if(cicloId != null){
%>
	
	
	
<%
	}else{
%>
	<br>
	<table width="50%" align="center" border="0">
		<tr>
			<td align="center"><fmt:message key="aca.PeriodoAca"/></td>
		</tr>
	</table>
<%} %>
	
	
</body>
<%@ include file= "../../cierra_elias.jsp" %> 