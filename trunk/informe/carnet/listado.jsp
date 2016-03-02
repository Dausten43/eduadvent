<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="listaEscuelas" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="asociacion" scope="page" class="aca.catalogo.CatAsociacion"/>
<jsp:useBean id="alumnoRegistro" scope="page" class="aca.alumno.AlumPersonal"/>


<%

	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= (String) session.getAttribute("escuela");	
	String cicloId			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	
	String unionId			= asociacion.getUnionEscuela(conElias, escuelaId);
	
	//LISTA DE ESCUELAS
	ArrayList<aca.catalogo.CatEscuela> lisEscuelas 	= listaEscuelas.getListUnion(conElias, unionId, "");
	
%>

	<div id="content">
		<h1>Carnet</h1>
		<div class="row-fluid">
          	<div class="well well-small">
            
        	</div>
		</div>
	
		
		<table class="table table-bordered" >
			<tr>     
				<td width="20%">Clave</td>
			    <td width="60%"><fmt:message key="aca.Nombre" /></td>
				<td width="20%">Cantidad alumnos registrados</td>
		  	</tr>

	<%	
			for(aca.catalogo.CatEscuela escuelas : lisEscuelas){
				
				int registroAlumno = alumnoRegistro.getTotalRegistros(conElias, escuelas.getEscuelaId());
				
				out.print("<tr>");
				out.print("<td class='text-center'>"+escuelas.getEscuelaId()+"</td>");	
				out.print("<td class='text-center'>"+escuelas.getEscuelaNombre()+"</td>");	
				out.print("<td class='text-center'>"+registroAlumno+"</td>");	
				out.print("</tr>");
			}
	%>
	
		</table>
	</div>
</body>

<%@ include file= "../../cierra_elias.jsp" %>