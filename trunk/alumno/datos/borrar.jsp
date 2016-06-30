<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	boolean borrar 			= false;
	String salto			= "X";
	
	String dirFoto = application.getRealPath("/WEB-INF/fotos/"+codigoAlumno+".jpg");
	java.io.File foto = new java.io.File(dirFoto);
	int i=0;
	if (foto.exists()){
		
		// Ciclo para corregir error en sistemas opreativos windows(No es necesario si el servidor de aplicaciones está en linux)
		while(!borrar && i<50000){
			if(foto.delete()){
				borrar = true;				
			}
			i++;
		}
	}
	if (borrar){
		salto = "alumno.jsp";		
	}else{
		out.println("No se puedo elimiar la foto del alumno:["+codigoAlumno+"] - "+aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno, "NOMBRE")+"<br>");
		out.println("<font color=black> ESPERE 5 MINUTOS O SUSTITUYA LA IMAGEN</font>");
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0"; url="<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>
