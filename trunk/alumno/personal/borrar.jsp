<%@ include file= "../../con_enoc.jsp" %>
<%
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	boolean borrar 			= false;
	String salto 			= "X";
	
	String dirFoto = application.getRealPath("/WEB-INF/fotos/"+codigoAlumno+".jpg");	
	java.io.File foto = new java.io.File(dirFoto);	
	if (foto.exists()){		    
		if (foto.delete()){
			borrar = true;
		}
	}	
	if (borrar){
		salto = "datos.jsp";
	}else{
		out.println("<font color=black> No se puedo elimiar la foto del alumno:["+codigoAlumno+"] - "+aca.alumno.AlumPersonal.getNombreAlumno(conEnoc, codigoAlumno, "NOMBRE")+"</font>");
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_enoc.jsp" %>

