<%@page import="java.net.URLDecoder"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "java.security.MessageDigest" %>
<%@ page import= "sun.misc.BASE64Encoder"%>
<jsp:useBean id="Clave" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="Personal" scope="page" class="aca.alumno.AlumPersonal"/>

<head>
<%
	System.out.println(Personal.toString());
	//request.setCharacterEncoding("LATIN1");
	// Declaracion de variables
	String escuela 			= (String)session.getAttribute("escuela");
	boolean inserto 		= false;
	
	String nuevoAlumno 	= Personal.maximoReg(conElias, escuela);
	Personal.setCodigoId(nuevoAlumno);
	Personal.setEscuelaId(escuela);
	Personal.setNombre(request.getParameter("Nombre"));
	Personal.setApaterno(request.getParameter("APaterno"));
	Personal.setAmaterno(request.getParameter("AMaterno"));
	Personal.setGenero(request.getParameter("Genero"));
	Personal.setCurp("-");
	Personal.setFNacimiento(request.getParameter("FNacimiento"));
	
	//Autogenerar clave--------------------------------------------------------------->
	MessageDigest md5	= MessageDigest.getInstance("MD5");
	md5.update(Personal.getCodigoId().getBytes("UTF-8"));
	byte raw[] = md5.digest();
	String claveDigest	= (new BASE64Encoder()).encode(raw);	
	
	// Inicia la transacción de alta del alumno y creación de cuenta
	conElias.setAutoCommit(false);	
	
	if (Personal.insertNuevo(conElias)){
		
		Clave.setCodigoId(Personal.getCodigoId());
		Clave.setTipoId("1");
		Clave.setCuenta(Personal.getCodigoId());
		Clave.setClave(claveDigest);
		Clave.setAdministrador("N");
		Clave.setCotejador("N");
		Clave.setContable("N");
		Clave.setNivel("-");
		Clave.setEscuela("-"+escuela+"-");
		Clave.setPlan("x");
		Clave.setAsociacion("-");
		Clave.setIdioma("es");
		
		if(Clave.existeReg(conElias) == false){
			if (Clave.insertReg(conElias)){
				conElias.commit();
				inserto = true;
				
				//-------------------------------------------------------------------------------->		
				// subir el codigo reciente del alumno a session
				session.setAttribute("codigoAlumno",nuevoAlumno);
				
			}else{
				conElias.rollback();
			}	
		}		
	}
	conElias.setAutoCommit(true);
	
	Personal.mapeaRegId(conElias, nuevoAlumno);
	if (inserto){
		out.println("<p align='center'><font color='black' size='2'>El alumno fue creado, recuerda que debes actualizar sus datos!</font></p>");
	}else{
		out.println("<p align='center'><font color='black' size='2'>¡Error en la operación, intentelo nuevamente!</font></p>");
	}
%>
<meta http-equiv="refresh" content="1;url=alumno.jsp" />
<%@ include file= "../../cierra_elias.jsp" %>
