<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>

<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<%
		String sSalto		= "";
		sSalto				= "datos.jsp";
		String matricula 	= request.getParameter("matricula");
		String nombre 		= request.getParameter("nombre");
		String aPaterno		= request.getParameter("aPaterno");
		String aMaterno		= request.getParameter("aMaterno");
		String direccion 	= request.getParameter("direccion");
		String colonia 		= request.getParameter("colonia");
		String pais			= request.getParameter("pais");
		String ciudad		= request.getParameter("ciudad");
		String cotejado		= request.getParameter("cotejado");
		String estado 		= request.getParameter("estado");
		String fecha 		= request.getParameter("Fecha");
		String estado1 		= request.getParameter("estado1");
		String sexo 		= request.getParameter("sexo");
		String religion 	= request.getParameter("religion");
		String telefono 	= request.getParameter("telefono");
		String email 		= request.getParameter("email");
		String curp 		= request.getParameter("curp");
		String sResultado	= "";	
	
		alumno.setCodigoId(matricula);		
		if (alumno.existeReg(conElias) == true){
			
			// Consulta los datos actuales
			alumno.mapeaRegId(conElias, matricula);
			
			// Modifica los campos con los nuevos valores
			alumno.setNombre(nombre);
			alumno.setApaterno(aPaterno);
			alumno.setAmaterno(aMaterno);
			alumno.setGenero(sexo);
			alumno.setCurp(curp);
			alumno.setFNacimiento(fecha);
			alumno.setPaisId(pais);
			alumno.setEstadoId(estado);
			alumno.setCiudadId(ciudad);
			alumno.setEmail(email);
			alumno.setColonia(colonia);
			alumno.setDireccion(direccion);
			alumno.setTelefono(telefono);
			alumno.setCotejado(cotejado);
			alumno.setEstado(estado1);
			alumno.setReligion(religion);
			if (alumno.updateReg(conElias)){
				sResultado = "<font color=blue>Modificado: "+alumno.getCodigoId()+"</font>";
				conElias.commit();
			}else{
				sResultado = "<font color=red>No Cambió: "+alumno.getCodigoId()+"</font>";
			}
		}else{
			sResultado = "<font color=red>No existe: "+alumno.getCodigoId()+"</font>";
		}		
		response.sendRedirect(sSalto); 
%>
<%@ include file="../../cierra_elias.jsp" %>