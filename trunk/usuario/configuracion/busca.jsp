<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../administradores.jsp" %>

<jsp:useBean id="Usuario" scope="page" class="aca.vista.Usuarios"/>
<jsp:useBean id="moduloLista" scope="page" class="aca.menu.ModuloLista"/>
<jsp:useBean id="menuLista" scope="page" class="aca.menu.MenuLista"/>
<jsp:useBean id="opcionLista" scope="page" class="aca.menu.ModuloOpcionLista"/>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="cicloGrupoCurso" scope="page"	class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="alumPersonal" scope="page"	class="aca.alumno.AlumPersonal" />
<jsp:useBean id="empPersonal" scope="page"	class="aca.empleado.EmpPersonal" />
<jsp:useBean id="ejercicioL" scope="page" class="aca.fin.FinEjercicioLista" />

<%
	String escuelaId 	= (String)session.getAttribute("escuela");
	String accion		= request.getParameter("Accion");
	String matricula	= request.getParameter("matricula").toUpperCase().trim().length()<7? "00000000" : request.getParameter("matricula").toUpperCase().trim();
	
	String strNombreUsuario		= "x";
	String ciclo				= "";
	int intTipoUsuario			= 0;
	boolean esAdminBusca		= false;
	
	ArrayList lisMenu			= new ArrayList();
	ArrayList lisOpcion			= new ArrayList();
	ArrayList lisMenuPrincipal	= new ArrayList();
	String strOpcion			= "";
	String salto				= "X";
	
	if( accion.equals("3") && !session.getAttribute("admin").equals("-------") ){
		
		if( admins.contains(String.valueOf(session.getAttribute("admin")))){
			if(matricula.equals("GERMANENCINAS"))
				matricula = "B01P0002";
			else if(matricula.equals("ALGARCIA"))
				matricula = "B01E0092";
			else if(matricula.equals("ULISESJP"))
				matricula = "B01E0093";
			
			Usuario.setCodigoId(matricula);
			Usuario.setEscuelaId(escuelaId = matricula.substring(0,3));
		}
		else{
			Usuario.setCodigoId(matricula);
			Usuario.setEscuelaId(escuelaId);
		}
		
		
		if(!Usuario.existeReg(conElias)){
			salto = "../../general/inicio/index.jsp?mensaje=1";
		}else{			
			session.setAttribute("codigoId", matricula);
			session.setAttribute("codigoAlumno",matricula);
			session.setAttribute("codigoEmpleado", matricula);
			session.setAttribute("codigoUltimo", matricula);
			session.setAttribute("escuela", escuelaId);
			
			
			/*aca.menu.MenuLista	 menuL					= new aca.menu.MenuLista();
			aca.menu.ModuloLista moduloL				= new aca.menu.ModuloLista();
			aca.menu.ModuloOpcionLista opcionL			= new aca.menu.ModuloOpcionLista();
			session.setAttribute("lisMenuPrincipal", menuL.getListUser(conElias, matricula));
			session.setAttribute("lisModulo", moduloL.getListUser(conElias, matricula));
			session.setAttribute("lisOpcion", opcionL.getListUser(conElias,matricula));*/			
			
			intTipoUsuario	= aca.usuario.Usuario.getTipo(conElias, matricula);
			if (intTipoUsuario ==1){
				strNombreUsuario = aca.alumno.AlumPersonal.getNombre(conElias,matricula,"NOMBRE");
				opciones = "-PAL-PPA-PMO";
			}else if (intTipoUsuario ==2 || intTipoUsuario ==3){
				strNombreUsuario = aca.empleado.EmpPersonal.getNombre(conElias,matricula,"NOMBRE");
				if (intTipoUsuario ==2) opciones = "-PEM";
				if (intTipoUsuario ==3) opciones = "-PPA";
			}
			if (esAdminBusca) opciones = "-PAL-PEM-PPA-PMO";
			
			
			
			if(aca.usuario.Usuario.esSuper(conElias, matricula)){
			
				lisMenuPrincipal = menuLista.getListUser(conElias, matricula);
				lisMenu = moduloLista.getListUserSuper(conElias, matricula);
				lisOpcion = opcionLista.getListUserSuper(conElias, matricula);
			}else{
			
				lisMenuPrincipal = menuLista.getListUser(conElias, matricula);
				lisMenu = moduloLista.getListUser(conElias, matricula);
				lisOpcion = opcionLista.getListUser(conElias, matricula);

			}
			for (int i=0;i<lisOpcion.size();i++){
				aca.menu.ModuloOpcion opc = (aca.menu.ModuloOpcion) lisOpcion.get(i);
				strOpcion = strOpcion + "-"+ opc.getOpcionId();
			}				
			strOpcion+= opciones+"-";
			
			// Si es empleado puede consultar a los alumnos
			if (intTipoUsuario ==2) strOpcion += "-6";
			
			session.setAttribute("lisMenuPrincipal", lisMenuPrincipal);
			session.setAttribute("lisMenu", lisMenu);
			session.setAttribute("lisOpcion", lisOpcion);
			session.setAttribute("opciones", strOpcion);
			
			// Elegir el mejor ciclo
			ciclo = aca.ciclo.Ciclo.getMejorCarga(conElias, matricula);
			if (!ciclo.substring(0,3).equals(matricula)){				
				ciclo = aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId); 
			}				
			session.setAttribute("cicloId", ciclo);			
			
			
			// Cambiar a String la clave de la escuela en la tabla FIN_EJERCICIO
			ArrayList<aca.fin.FinEjercicio> listaEjercicios = ejercicioL.getListPorEscuela(conElias, escuelaId, "ORDER BY YEAR");
			String EjercicioId = "";
			if(listaEjercicios.size()>0){
				EjercicioId = listaEjercicios.get(listaEjercicios.size()-1).getEjercicioId();
			}
			session.setAttribute("EjercicioId", EjercicioId);
			
			
			/* OPCIONES DEL PORTAL */
			usuario.mapeaRegId(conElias, matricula);
			if(usuario.getDivision().equals("S")){
				session.setAttribute("portalDivision", true);
			}else{
				session.setAttribute("portalDivision", false);
			}
			if(usuario.getAdministrador().equals("S") && usuario.getAsociacion().split("-").length!=0){
				session.setAttribute("portalAdmin", true);
			}else{
				session.setAttribute("portalAdmin", false);
			}
			if(cicloGrupoCurso.existeMaestro(conElias, matricula)){
				session.setAttribute("portalMaestro", true);
			}else{
				session.setAttribute("portalMaestro", false);
			}
			if(alumPersonal.existeReg(conElias, matricula)){
				session.setAttribute("portalAlumno", true);
			}else{
				session.setAttribute("portalAlumno", false);
			}
			empPersonal.mapeaRegId(conElias, matricula);
			if(empPersonal.existeReg(conElias) && matricula.substring(3,4).equals("P")){
				session.setAttribute("portalPadre", true);
			}else{
				session.setAttribute("portalPadre", false);
			}
			
			salto = "../../general/inicio/index.jsp";
%>
<%			
		}
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>