<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="inscritosLista" scope="page" class="aca.vista.AlumInscritoLista"/>

<%
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= request.getParameter("EscuelaId");
	String cicloId			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	
	//LISTA DE ESCUELAS
	ArrayList<aca.vista.AlumInscrito> lisInscritos 	= inscritosLista.getListaInscritos(conElias, escuelaId, " ORDER BY NIVEL, GRADO, GRUPO, NOMBRE,APATERNO,AMATERNO");
%>
<div id="content">
	<h1>Alumnos Inscritos<small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %>)</small></h1>	
  	<div class="well well-small">
  		<a href="listado.jsp" class="btn btn-primary"><fmt:message key="boton.Regresar" /><a>
    </div>		
	<table class="table table-bordered" >
		<tr>     
			<td width="10%"><fmt:message key="aca.Nivel" /></td>
		    <td width="10%"><fmt:message key="aca.Grado" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Grupo" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Codigo" /></td>
			<td width="40%" class="text-left"><fmt:message key="aca.Nombre" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.CIP" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Sangre" /></td>
	  	</tr>
<%	
	for(aca.vista.AlumInscrito inscrito : lisInscritos){	
%>		
		<tr>
		<td class='text-left'><%= inscrito.getNivel() %></td>
		<td class='text-left'><%= inscrito.getGrado() %></td>
		<td class='text-left'><%= inscrito.getGrupo() %></td>
		<td class='text-left'><%= inscrito.getCodigoId() %></td>
		<td class='text-left'><%= inscrito.getNombre()+" "+inscrito.getaPaterno()+" "+inscrito.getaMaterno() %></td>
		<td class='text-left'><%= inscrito.getCurp() %></td>
		<td class='text-left'><%= inscrito.getTipoSangre() %></td>
		</tr>
<%		
	}
%>	
	</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>