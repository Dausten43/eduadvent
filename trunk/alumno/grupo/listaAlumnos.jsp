<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="NivelLista" scope="page" class="aca.catalogo.CatNivelLista"/>
<jsp:useBean id="FechaActual" scope="page" class="aca.util.Fecha"/>
<jsp:useBean id="AlumnoCiclo" scope="page" class="aca.alumno.AlumCicloLista"/>

<%	//Declaracion de Variables
	String escuelaId	= (String) session.getAttribute("escuela");

	String nivelId		= request.getParameter("nivel_id");
	String grado		= request.getParameter("grado");
	String grupo		= request.getParameter("grupo");
	String cantidad		= request.getParameter("Cantidad");
	String cicloId		= request.getParameter("ciclo");
	String periodoId	= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);
	String sBgcolor		= "";
	String edad			= "";
	int i=0;
	String Insc			= request.getParameter("ins");
	
	ArrayList<aca.alumno.AlumPersonal> lisAlumnos = AlumnoLista.getListAlumnosGrado(conElias, escuelaId, cicloId, periodoId, nivelId, grado, " AND GRUPO='"+grupo+"' ORDER BY APATERNO, AMATERNO, NOMBRE, GRUPO");
	
%>

<div id="content">
	<h2><fmt:message key="catalogo.Listadealumnos"/></h2>
	
	<div class="alert alert-info">
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivelId)%>&nbsp;&nbsp;&nbsp;&nbsp;
		<%=aca.catalogo.CatNivel.getGradoNombre(Integer.valueOf(grado).intValue())%>
		"<%=grupo%>"
	</div>

	<div class="well">
		<a href="grupo.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>		
	</div>
	
    <table class="table table-bordered table-condensed">
  		<tr>
			<th>#</th>
	    	<th><fmt:message key="aca.Matricula"/></th>
	    	<th><fmt:message key="aca.Nombre"/></th>
	    	<th><fmt:message key="aca.CID"/></th>
	    	<th><fmt:message key="aca.Genero"/></th>
	    	<th><fmt:message key="aca.Edad"/></th>
	    	<th><fmt:message key="aca.Colonia"/></th>
	    	<th><fmt:message key="aca.Direccion"/></th>
	    	<th><fmt:message key="aca.CelularTutor"/></th>
	  	</tr>  
		<%		
			String genero;
	   		for (i=0; i< lisAlumnos.size(); i++){
		    	aca.alumno.AlumPersonal alumno = (aca.alumno.AlumPersonal) lisAlumnos.get(i);
	   
    			if (alumno.getGrupo().equals(grupo)){
    				if(alumno.getGenero().equals("M")){
    					genero = "Hombre";
    				}else{
    					genero = "Mujer";
    				}
		%>
	  				<tr>
						<td><%=i+1%></td>
						<td><%=alumno.getCodigoId()%></td>
						<td><%=alumno.getApaterno()%>&nbsp;<%=alumno.getAmaterno()%>&nbsp;<%=alumno.getNombre()%></td>
						<td><%=alumno.getCurp() %></td>
						<td><%= genero  %></td>
						<td><%=aca.alumno.AlumPersonal.getEdad(conElias, alumno.getCodigoId())%></td>
						<td><%=alumno.getColonia()%></td>
						<td><%=alumno.getDireccion()%></td>
						<td><%=alumno.getCelular()%></td>
				 	</tr>  
		<%			
				}
			} 
		%>
	</table>

	<div class="alert"><h3><fmt:message key="aca.Total"/>:<%=cantidad%></h3></div>

</div>

<%@ include file= "../../cierra_elias.jsp" %>