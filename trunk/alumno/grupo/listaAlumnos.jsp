<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.empleado.EmpPersonal"%>

<jsp:useBean id="AlumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="AlumnoPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumnoPadres" scope="page" class="aca.alumno.AlumPadres"/>
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
	String Insc			= request.getParameter("ins");
	
	ArrayList<aca.alumno.AlumPersonal> lisAlumnos = AlumnoLista.getListAlumnosGrado(conElias, escuelaId, cicloId, periodoId, nivelId, grado, "ORDER BY APATERNO, AMATERNO, NOMBRE, GRUPO");
	java.util.HashMap<String,aca.alumno.AlumPadres> listTutores = AlumnoPadresLista.getMapEscuela(conElias, escuelaId);
%>

<div id="content">
	<h2><fmt:message key="catalogo.Listadealumnos"/></h2>
	
	<div class="alert alert-info">
		<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivelId)%>&nbsp;&nbsp;&nbsp;&nbsp;
		<%=aca.catalogo.CatNivel.getGradoNombre(Integer.valueOf(grado).intValue())%>
		"<%=grupo%>"
	</div>

	<div class="well">
		<a href="grupo.jsp?ciclo=<%=cicloId%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>		
	</div>
	
    <table class="table table-bordered table-condensed">
  		<tr>
			<th>#</th>
	    	<th><fmt:message key="aca.Matricula"/></th>
	    	<th><fmt:message key="aca.Nombre"/></th>
	    	<th>
	    		<%if(escuelaId.startsWith("S")){ %>
	    		NIE
	    		<%}else if(escuelaId.startsWith("H")){ %>
	    		CID
	    		<%}else{ %>
	    		<fmt:message key="aca.CURP"/>
	    		<%} %>
	    	</th>
	    	<th><fmt:message key="aca.Iglesia"/></th>
	    	<th><fmt:message key="aca.Edad"/></th>
	    	<th><fmt:message key="aca.Colonia"/></th>
	    	<th><fmt:message key="aca.Direccion"/></th>
	    	<th><fmt:message key="aca.CelularTutor"/></th>
	  	</tr>  
		<%	
			EmpPersonal tutor;
			String codigoPadre, codigoMadre, codigoTutor;
			String colonia, direccion, telefono;
	   		for (int i=0, cont = 0; i< lisAlumnos.size(); i++){
		    	aca.alumno.AlumPersonal alumno = (aca.alumno.AlumPersonal) lisAlumnos.get(i);
		    	
		    	tutor = new EmpPersonal();
		    	if(listTutores.containsKey(alumno.getCodigoId())){
					codigoPadre = listTutores.get(alumno.getCodigoId()).getCodigoPadre();
					codigoMadre = listTutores.get(alumno.getCodigoId()).getCodigoMadre();
					codigoTutor = listTutores.get(alumno.getCodigoId()).getCodigoTutor();
					
					if (codigoPadre != null && !codigoPadre.equals("-")){
						tutor.mapeaRegId(conElias, codigoPadre);
					}else if (codigoMadre != null && !codigoMadre.equals("-")){
						tutor.mapeaRegId(conElias, codigoMadre);
					}else if (codigoTutor != null && !codigoTutor.equals("-")){
						tutor.mapeaRegId(conElias, codigoTutor);
					}
				}
		    	
    			if (alumno.getGrupo().equals(grupo)){
    				colonia = 	tutor.getCodigoId().equals("") ? alumno.getColonia()	: tutor.getColonia() == null	? alumno.getColonia()	: tutor.getColonia().equals("")		? alumno.getColonia()	: tutor.getColonia();
    				direccion = tutor.getCodigoId().equals("") ? alumno.getDireccion()  : tutor.getDireccion() == null	? alumno.getDireccion()	: tutor.getDireccion().equals("")	? alumno.getDireccion()	: tutor.getDireccion();
    				telefono = 	tutor.getCodigoId().equals("") ? alumno.getTelefono()	: tutor.getTelefono() == null	? alumno.getTelefono()	: tutor.getTelefono().equals("")	? alumno.getTelefono()	: tutor.getTelefono();
		%>
	  				<tr>
						<td><%=++cont%></td>
						<td><%=alumno.getCodigoId()%></td>
						<td><%=alumno.getApaterno()%>&nbsp;<%=alumno.getAmaterno()%>&nbsp;<%=alumno.getNombre()%></td>
						<td><%=alumno.getCurp() %></td>
						<td><%=alumno.getIglesia()  %></td>
						<td><%=aca.alumno.AlumPersonal.getEdad(conElias, alumno.getCodigoId())%></td>
						<td><%=colonia==null?"":colonia %></td>
						<td><%=direccion==null?"":direccion %></td>
						<td><%=telefono==null?"":telefono %></td>
				 	</tr>  
		<%			
				}
			} 
		%>
	</table>

	<div class="alert"><h3><fmt:message key="aca.Total"/>:<%=cantidad%></h3></div>

</div>

<%@ include file= "../../cierra_elias.jsp" %>