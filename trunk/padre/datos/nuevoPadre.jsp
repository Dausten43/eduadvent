<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "java.security.MessageDigest" %>
<%@ page import= "sun.misc.BASE64Encoder"%>
<jsp:useBean id="Clave" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<head>

<div id="content">
<%
	// Declaracion de variables
	String escuela 			= (String)session.getAttribute("escuela");
	boolean inserto 		= false;
	
	String nuevoEmpleado 	= Personal.maximoRegPad(conElias,escuela);
	Personal.setCodigoId(nuevoEmpleado);
	Personal.setEscuelaId(escuela);
	Personal.setNombre(request.getParameter("Nombre"));
	Personal.setApaterno(request.getParameter("APaterno"));
	Personal.setAmaterno(request.getParameter("AMaterno"));
	Personal.setGenero(request.getParameter("Genero"));	
	Personal.setFNacimiento(request.getParameter("FNacimiento"));
	
	//Autogenerar clave--------------------------------------------------------------->
	MessageDigest md5	= MessageDigest.getInstance("MD5");
	md5.update(Personal.getCodigoId().getBytes("UTF-8"));
	byte raw[] = md5.digest();
	String claveDigest	= (new BASE64Encoder()).encode(raw);
	
	conElias.setAutoCommit(false);	
	if (Personal.insertNuevo(conElias)){		
		
		Clave.setCodigoId(Personal.getCodigoId());
		Clave.setTipoId("3");
		Clave.setCuenta(Personal.getCodigoId());
		Clave.setClave(claveDigest);
		Clave.setAdministrador("N");
		Clave.setCotejador("N");
		Clave.setContable("N");	
		Clave.setEscuela("-"+escuela+"-");
		Clave.setPlan("x");
		Clave.setNivel("-");
		Clave.setAsociacion("-");
		Clave.setIdioma("es");
		
		if(Clave.existeReg(conElias) == false){
			if (Clave.insertReg(conElias)){
				conElias.commit();
				inserto = true;
				
				// subir el codigo reciente del alumno a session
				session.setAttribute("codigoPadre",nuevoEmpleado);
				session.setAttribute("codigoReciente",nuevoEmpleado);
				
			}else{
				conElias.rollback();
			}	
		}		
	}
	conElias.setAutoCommit(true);
	
	Personal.mapeaRegId(conElias, nuevoEmpleado);
	if (inserto){
		out.print("<div class='alert alert-info'>¡El padre fue creado, recuerda que debes actualizar sus datos!  </div>  ");
		out.print("<meta http-equiv='refresh' content='1;url=accion_p.jsp' />");
	}else{
		%> 
			<div class="alert alert-danger"><fmt:message key="aca.ErrorEnOperacion"/></div>			
			<a href="accion_p.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
		<%
	}
%>
</div>
<%@ include file= "../../cierra_elias.jsp" %>