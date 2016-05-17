<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empeladosLista" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="empelado" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="nivelEscuela" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<%
	String codigoPersonal	= (String) session.getAttribute("codigoPersonal");
	String escuelaId 		= request.getParameter("EscuelaId");
	String cicloId			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	
	//LISTA DE ESCUELAS
	ArrayList<aca.empleado.EmpPersonal> lisEmpleadosActivos 	= empeladosLista.getListAllActivos(conElias, escuelaId, " ORDER BY NOMBRE,APATERNO,AMATERNO");
	
	// Lista de niveles
	java.util.HashMap<String,aca.catalogo.CatNivelEscuela> mapNiveles = nivelEscuela.mapNivelesEscuela(conElias, escuelaId);

	Calendar year = new GregorianCalendar();
	
%>
<div id="content">
	<h1>Empleados Activos<small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %>)</small></h1>	
  	<div class="well well-small">
  		<a href="listado.jsp" class="btn btn-primary"><fmt:message key="boton.Regresar" /></a>
    </div>		
	<table class="table table-bordered" >
		<tr>     
			<td width="10%" class="text-left"><fmt:message key="aca.Codigo" /></td>
			<td width="40%" class="text-left"><fmt:message key="aca.Nombre" /></td>
			<td width="10%" class="text-left">RFC</td>
			<td width="10%" class="text-left"><fmt:message key="aca.Sangre" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Foto" /></td>
			<td width="10%" class="text-left"><fmt:message key="aca.Poliza" /></td>
	  	</tr>
<%
	String codigoAlumno			= "";
	String tieneFoto 			= "No";
	String muestraYear			= String.valueOf(year.get(Calendar.YEAR));

	for(aca.empleado.EmpPersonal empleado : lisEmpleadosActivos){	
		// Verifica si existe la imagen	
		String dirFoto = application.getRealPath("/WEB-INF/fotos/"+empleado.getCodigoId()+".jpg");
		java.io.File foto = new java.io.File(dirFoto);
		if (foto.exists()){
			tieneFoto = "Si";
		}else {
			tieneFoto = "No";
		}
		
%>		
		<tr>		
		<td class='text-left'><%= empleado.getCodigoId() %></td>
		<td class='text-left'><%= empleado.getNombre()+" "+empleado.getApaterno()+" "+empleado.getAmaterno() %></td>
		<td class='text-left'><%= empleado.getRfc() %></td>
		<td class='text-left'><%= empleado.getColonia() %></td>
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