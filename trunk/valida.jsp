<%@ page buffer= "none" %>
<%@ page import="java.sql.*"%>
<%@ page import="aca.menu.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Base64"%>
<%@ page import="java.security.MessageDigest"%>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario" />
<jsp:useBean id="moduloLista" scope="page" class="aca.menu.ModuloLista" />
<jsp:useBean id="menuLista" scope="page" class="aca.menu.MenuLista" />
<jsp:useBean id="opcionLista" scope="page" class="aca.menu.ModuloOpcionLista" />
<jsp:useBean id="bOp" scope="page" class="aca.portal.Alumno" />
<jsp:useBean id="fecha" scope="page" class="aca.util.Fecha" />
<jsp:useBean id="ejercicioL" scope="page" class="aca.fin.FinEjercicioLista" />
<jsp:useBean id="escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="cicloGrupoCurso" scope="page"	class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="alumPersonal" scope="page"	class="aca.alumno.AlumPersonal" />
<jsp:useBean id="empPersonal" scope="page"	class="aca.empleado.EmpPersonal" />

<% 	



	String strIp		 		= request.getRemoteAddr();
	String strCuenta 			= request.getParameter("Usuario");
	String strClave				= request.getParameter("Clave");
	
	String strEscuela			= "";
	String strEscuelaId			= "";	
	String strEstadoEscuela		= "I";	
	String strCodigoId			= "X";
	String strNombreUsuario		= "x";
	String admin				= "";	
	int intTipoUsuario			= 0;
	
	// "ISO-8859-1"
	MessageDigest md5 			= MessageDigest.getInstance("MD5");
	md5.update(strClave.getBytes("UTF-8"));
    byte raw[] = md5.digest();    
    String claveDigest = Base64.getEncoder().encodeToString(raw);    
	aca.conecta.Conectar c 		= new aca.conecta.Conectar();
	Connection conn				= null;
	aca.util.Fecha f			= new aca.util.Fecha();	
	String strOpcion			= "";	
	String strSalto				= "";
	String opciones				= "";
	String menu					= "";
	String ciclo				= "";		
	boolean esAdmin				= false;	
	boolean error 				= false;	
	boolean entrar 				= false;
	
	// Menu principal (Nivel 1)
	ArrayList<aca.menu.Menu> lisMenuPrincipal		= new ArrayList<aca.menu.Menu>();
	// Menu secundario (Nivel 2)
	ArrayList<aca.menu.Modulo> lisMenu				= new ArrayList<aca.menu.Modulo>();
	// Opciones del sistema (Nivel 3)
	ArrayList<aca.menu.ModuloOpcion> lisOpcion		= new ArrayList<aca.menu.ModuloOpcion>();

	//Coneccion a Oracle
	System.out.println("REVISANDO USUARIO QUE SE INGRESA " + strCuenta + "\t" + strIp);
	
	try{
		conn = c.conEliasPostgres();
		if(conn!= null){
			strCodigoId 	= usuario.getEsUsuario(conn, strCuenta, claveDigest);
			
			if (!strCodigoId.equals ("x")){
				strEscuelaId 		= strCodigoId.substring(0,3);				
			    strEstadoEscuela 	= aca.catalogo.CatEscuela.getEstadoEscuela(conn, strEscuelaId);
			    System.out.println("CARGANDO LOS PRIMEROS VALORES  " + strEscuelaId + "\t" + strEstadoEscuela);
			}
	
			// Si es usuario	
			boolean isActive = aca.empleado.EmpPersonal.getEstadoEmp(conn, strCodigoId);
			if(!strCodigoId.equals("x") && strEstadoEscuela.equals("A") && isActive){
				
				// Guarda en sesion el codigo si es administrador(usado para mirar portal de otros usuarios)
				if (aca.usuario.Usuario.esAdministrador(conn, strCodigoId)){
					admin 		= strCodigoId;
					esAdmin 	= true;
				}else{
					admin 		= "-------";
				}
				
				// Sesión
				HttpSession sesion = request.getSession();
				//sesion.setMaxInactiveInterval(18000);
				System.out.println("Nueva session:"+sesion.getCreationTime()+"- User:"+strCodigoId);
				session.setAttribute("admin",admin);
				session.setAttribute("user", strCodigoId);
				session.setAttribute("certificado", "true");
				session.setAttribute("codigoId", strCodigoId );
				session.setAttribute("codigoReciente", strCodigoId );
				session.setAttribute("lenguaje", aca.usuario.Usuario.getIdioma(conn, strCodigoId));
				
				System.out.println("valores que se suben a la sesion  " + admin + "\t" + aca.empleado.EmpPersonal.getNombre(conn,strCodigoId,"NOMBRE") + "\t" + aca.alumno.AlumPersonal.getNombre(conn,strCodigoId,"NOMBRE") + "\t" + strCodigoId + "\t" + sesion.getId()) ;
				
				// Registrar en sesion el ejercicio actual
				String ejercicioId = aca.fin.FinEjercicio.getEjercicioActual(conn, strEscuelaId);
				
				session.setAttribute("ejercicioId", ejercicioId);
				
				// Agregar opciones de acuerdo al tipo de usuario
				intTipoUsuario	= aca.usuario.Usuario.getTipo(conn, strCodigoId);
				if (intTipoUsuario ==1){
					strNombreUsuario = aca.alumno.AlumPersonal.getNombre(conn,strCodigoId,"NOMBRE");
					opciones = "-PAL-PPA-PMO";
				}else if (intTipoUsuario ==2 || intTipoUsuario ==3){
					strNombreUsuario = aca.empleado.EmpPersonal.getNombre(conn,strCodigoId,"NOMBRE");				
					// Acceso al portal del empleado(PEM) y al curriculum(203) vitae
					if (intTipoUsuario ==2) opciones = "-PEM-203";
					// Acceso al portal del padre(PPA)
					if (intTipoUsuario ==3) opciones = "-PPA-PMO";
				}
				if (esAdmin) opciones = "-PAL-PEM-PPA-203-PMO";
							
				session.setAttribute("nombreUsuario",strNombreUsuario);
				
				// Busca a que escuela pertenece el usuario y crea una clave de 2 caracteres ejmplo "01"
				strEscuela = strCodigoId.substring(0,3);				
				session.setAttribute("escuela", strEscuela);		
				
				session.setAttribute("escuelaNombre", aca.catalogo.CatEscuela.getNombre(conn, strEscuela ));				
				
				if(aca.usuario.Usuario.esSuper(conn, strCodigoId)){
				
					lisMenuPrincipal = menuLista.getListUser(conn, strCodigoId);
					lisMenu = moduloLista.getListUserSuper(conn, strCodigoId);
					lisOpcion = opcionLista.getListUserSuper(conn, strCodigoId);
				}else{
				
					lisMenuPrincipal = menuLista.getListUser(conn, strCodigoId);
					lisMenu = moduloLista.getListUser(conn, strCodigoId);
					lisOpcion = opcionLista.getListUser(conn, strCodigoId);

				}
				
				for (int i=0;i<lisOpcion.size();i++){
					ModuloOpcion opc = (ModuloOpcion) lisOpcion.get(i);
					strOpcion = strOpcion + "-"+ opc.getOpcionId();
				}				
				strOpcion+= opciones+"-";
				
				// Si es empleado puede consultar a los alumnos
				if (intTipoUsuario ==2) strOpcion += "-6-380";
				
				session.setAttribute("lisMenuPrincipal", lisMenuPrincipal);
				session.setAttribute("lisMenu", lisMenu);
				session.setAttribute("lisOpcion", lisOpcion);
				session.setAttribute("opciones", strOpcion);
				
				session.setAttribute("codigoAlumno", strCodigoId);
				session.setAttribute("codigoEmpleado", strCodigoId );				
				session.setAttribute("codigoPadre", "00000000");
				
				// Elegir el mejor ciclo
				ciclo = aca.ciclo.Ciclo.getMejorCarga(conn,strCodigoId);
				if (!ciclo.substring(0,3).equals(strEscuela)){ 
					ciclo = aca.ciclo.Ciclo.getCargaActual(conn, strEscuela);
				}				
				session.setAttribute("cicloId", ciclo);
			
				
				/* OPCIONES DEL PORTAL */
				usuario.mapeaRegId(conn, strCodigoId);
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
				if(cicloGrupoCurso.existeMaestro(conn, strCodigoId)){
					session.setAttribute("portalMaestro", true);
				}else{
					session.setAttribute("portalMaestro", false);
				}
				if(alumPersonal.existeReg(conn, strCodigoId)){
					session.setAttribute("portalAlumno", true);
				}else{
					session.setAttribute("portalAlumno", false);
				}
				
				/* REQUERIMIENTOS DE BUSCADOR */
				
				if(usuario.getAdministrador().equals("S") || usuario.getCotejador().equals("S") || usuario.getContable().equals("S")){
					session.setAttribute("buscador", true);
				}else{
					session.setAttribute("buscador", false);
				}
				

				empPersonal.mapeaRegId(conn, strCodigoId);
				if(empPersonal.existeReg(conn) && strCodigoId.substring(3,4).equals("P")){
					session.setAttribute("portalPadre", true);
				}else{
					session.setAttribute("portalPadre", false);
				}
				
				entrar = true;
				
			}else{ 
				if(!aca.usuario.Usuario.getValidaCuenta(conn,strCuenta)){
					%>errorUsuario<%
				}else if(!aca.usuario.Usuario.getValidaClave(conn, strCuenta, claveDigest)){
					%>errorPassword<%
				}else if(strEstadoEscuela.equals ("I")){
					%>escuelaInactiva<%
				}else if(!isActive){
					%>usuarioInactivo<%
				}
				entrar=false;
				error = true;
			}
				// else escuelaEstado
		
			conn.close();
		}

	}catch(Exception e){
		System.out.println("ERROR!!!: "+e.toString());
	}

	lisMenu 		= null;
	lisOpcion		= null; 
	opcionLista		= null;
	moduloLista 	= null;
%>

<%if(entrar){%>correcto<%} %>