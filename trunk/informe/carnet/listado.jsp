<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="listaEscuelas" scope="page" class="aca.catalogo.CatEscuelaLista"/>

<%
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	String unionId			= aca.catalogo.CatAsociacion.getUnionEscuela(conElias, escuelaId);
	
	//LISTA DE ESCUELAS
	ArrayList<aca.catalogo.CatEscuela> lisEscuelas 	= listaEscuelas.getListUnion(conElias, unionId, "ORDER BY ESCUELA_NOMBRE");	
	
	java.util.HashMap<String,String> mapEmpleadosPorEscuela 	= aca.empleado.EmpPersonalLista.mapEmpleadosPorEscuela(conElias,"'A'","'E'");
%>
<div id="content">
	<h1>Carnet<small>( <%= aca.catalogo.CatUnion.getNombre(conElias, unionId) %>)</small></h1>	
  	<div class="well well-small">        
    </div>		
	<table class="table table-bordered" >
		<tr>     
			<td width="10%">Clave</td>
		    <td width="70%"><fmt:message key="aca.Nombre" /></td>
			<td width="10%" class="text-right"># Alumnos</td>
			<td width="10%" class="text-right"># Empleados</td>
	  	</tr>

<%	
	for(aca.catalogo.CatEscuela escuelas : lisEscuelas){
		
		int registroAlumno 		= aca.vista.AlumInscrito.numInscritos(conElias, escuelas.getEscuelaId());
%>		
		<tr>
		<td class='text-center'><%= escuelas.getEscuelaId() %></td>	
		<td><%=escuelas.getEscuelaNombre()%></td>
		<td class='text-right'><a href="listaAlumnos.jsp?EscuelaId=<%=escuelas.getEscuelaId()%>"><%= registroAlumno %></a></td>
		<td class='text-right'><a href="listaEmpleados.jsp?EscuelaId=<%=escuelas.getEscuelaId()%>"><%= mapEmpleadosPorEscuela.get(escuelas.getEscuelaId()) %></a></td>
		</tr>
<%		
	}
%>
	
	</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>