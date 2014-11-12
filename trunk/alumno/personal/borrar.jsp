<%@ include file= "../../con_enoc.jsp" %>
<%
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	boolean borrar 			= false;
	
	String dirFoto = application.getRealPath("/WEB-INF/fotos/"+codigoAlumno+".jpg");	
	java.io.File foto = new java.io.File(dirFoto);	
	if (foto.exists()){		    
		if (foto.delete()){
			borrar = true;
		}
	}	
	if (borrar){
		response.sendRedirect("datos.jsp");
	}else{
		out.println("<font color=black> No se puedo elimiar la foto del alumno:["+codigoAlumno+"] - "+aca.alumno.AlumPersonal.getNombreAlumno(conEnoc, codigoAlumno, "NOMBRE")+"</font>");
	}
%>
<%@ include file="../../cierra_enoc.jsp" %>