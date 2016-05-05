<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="inscritosLista" scope="page" class="aca.vista.AlumInscritoLista"/>
<jsp:useBean id="nivelEscuela" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<%
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= request.getParameter("EscuelaId");
	String cicloId			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	
	//LISTA DE ESCUELAS
	ArrayList<aca.vista.AlumInscrito> lisInscritos 	= inscritosLista.getListaInscritos(conElias, escuelaId, " ORDER BY NIVEL, GRADO, GRUPO, NOMBRE,APATERNO,AMATERNO");
	
	// Lista de niveles
	java.util.HashMap<String,aca.catalogo.CatNivelEscuela> mapNiveles = nivelEscuela.mapNivelesEscuela(conElias, escuelaId);

	Calendar year = new GregorianCalendar();
	
%>
<div id="content">
	<h1>Alumnos Inscritos<small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %>)</small></h1>	
  	<div class="well well-small">
  		<a href="listado.jsp" class="btn btn-primary"><fmt:message key="boton.Regresar" /></a>
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
			<td width="10%" class="text-left"><fmt:message key="aca.Foto" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Poliza" /></td>
	  	</tr>
<%
	String codigoAlumno			= "";
	String tieneFoto 			= "No";
	String muestraYear			= String.valueOf(year.get(Calendar.YEAR));

	for(aca.vista.AlumInscrito inscrito : lisInscritos){	
		// Verifica si existe la imagen	
		String dirFoto = application.getRealPath("/WEB-INF/fotos/"+inscrito.getCodigoId()+".jpg");
		java.io.File foto = new java.io.File(dirFoto);
		if (foto.exists()){
			tieneFoto = "Si";
		}else {
			tieneFoto = "No";
		}
%>		
		<tr>
		<td class='text-left'><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, inscrito.getNivel())%></td>
		<td class='text-left'><%= inscrito.getGrado() %></td>
		<td class='text-left'><%= inscrito.getGrupo() %></td>
		<td class='text-left'><%= inscrito.getCodigoId() %></td>
		<td class='text-left'><%= inscrito.getNombre()+" "+inscrito.getaPaterno()+" "+inscrito.getaMaterno() %></td>
		<td class='text-left'><%= inscrito.getCurp() %></td>
		<td class='text-left'><%= inscrito.getTipoSangre() %></td>
		<td class='text-left'><%= tieneFoto %></td>
		<td class='text-left'><%= aca.catalogo.CatSeguro.getPoliza(conElias, escuelaId, muestraYear ) %></td>
		</tr>
<%		
	}
%>	
	</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>