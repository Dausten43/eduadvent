<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="HorarioU" scope="page" class="aca.catalogo.CatHorarioLista"/>
<jsp:useBean id="HorarioPeriodo" scope="page" class="aca.catalogo.CatHorarioPeriodo"/>

<%
	String escuelaId = (String) session.getAttribute("escuela");

	ArrayList<aca.catalogo.CatHorario> horarios = HorarioU.getListAll(conElias, escuelaId, "ORDER BY 1" );
%>

<div id="content">

	<h2><fmt:message key="aca.Horarios" /></h2>
	
	<div class="well">
		<a class="btn btn-primary add" href="accion.jsp"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
	</div>


	<table class="table table-striped">
		<thead>
			<tr>
				<th><fmt:message key="aca.Operacion" /></th>
				<th><fmt:message key="aca.Horario" /></th>
				<th><fmt:message key="aca.Estado" /></th>
			</tr>
		</thead>
	<%
		int cont = 0;
		for(aca.catalogo.CatHorario horario: horarios){
			cont++;
			
			HorarioPeriodo.setHorarioId(horario.getHorarioId());
	%>
		<tr>
			<td>
				<%if(!HorarioPeriodo.existeHorario(conElias)){ %>
					<a href="javascript: if(confirm('<fmt:message key="js.Confirma" />'))location.href='accion.jsp?HorarioId=<%=horario.getHorarioId() %>&Accion=2';">	
						<i class="icon-remove"></i> 
					</a>
				<%}else{%>
					<a href="javascript: alert('<fmt:message key="js.HorarioError" />');">	
						<i class="icon-remove"></i> 
					</a>
				<%} %>
				<a href="accion.jsp?HorarioId=<%=horario.getHorarioId() %>">
					<i class="icon-pencil"></i>
				 </a>
			</td>
			<td>
					<a href="periodo.jsp?horarioId=<%=horario.getHorarioId()%>" class="nombre">
						<%=horario.getHorarioNombre() %> 
					</a>  
			</td>
			<td>
				<%=horario.getEstado().equals("A")?"Activo":"Inactivo" %>
			</td>
		</tr>
	<%
		}
	%>
	</table>
</div>

<%@ include file= "../../cierra_elias.jsp" %>