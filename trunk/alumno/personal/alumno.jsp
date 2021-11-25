
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="aca.catalogo.CatReligion"%>
<%@page import="aca.alumno.AlumCiclo"%>
<%@page import="aca.kardex.KrdxCursoAct"%>

<jsp:useBean id="Personal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="PaisL" scope="page" class="aca.catalogo.CatPaisLista"/>
<jsp:useBean id="EstadoL" scope="page" class="aca.catalogo.CatEstadoLista"/>
<jsp:useBean id="CiudadL" scope="page" class="aca.catalogo.CatCiudadLista"/>
<jsp:useBean id="BarrioL" scope="page" class="aca.catalogo.CatBarrioLista"/>
<jsp:useBean id="AlumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="PlanLista" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="catReligion" scope="page" class="aca.catalogo.CatReligion"/>
<jsp:useBean id="catReligionLista" scope="page" class="aca.catalogo.CatReligionLista"/>
<jsp:useBean id="alumCiclo" scope="page" class="aca.alumno.AlumCiclo"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioMenu" scope="page" class="aca.usuario.UsuarioMenu"/>
<jsp:useBean id="ClasFinLista" scope="page" class="aca.catalogo.CatClasFinLista"/>
<jsp:useBean id="finMovtosLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<%@ page pageEncoding="LATIN1"%>
<script>
	
	function Nuevo(){	
		document.frmPersonal.Nombre.value			= "";
		document.frmPersonal.ApellidoPaterno.value 	= "";
		document.frmPersonal.ApellidoMaterno.value 	= "";
		document.frmPersonal.FNacimiento.value		= "";
		document.frmPersonal.Sexo.value				= "M";
		document.frmPersonal.Telefono.value			= "1";
		document.frmPersonal.Email.value			= "1";
		document.frmPersonal.Curp.value				= "1";		
		document.frmPersonal.Accion.value			="1";		
		document.frmPersonal.PaisId.value			= "135";
		document.frmPersonal.EstadoId.value			= "19";
		document.frmPersonal.CiudadId.value			= "1";
		document.frmPersonal.Colonia.value			= "x";
		document.frmPersonal.Direccion.value		= "";
		document.frmPersonal.ClasificacionFin.value	= "N";
		document.frmPersonal.Acta.value				= "X";
		document.frmPersonal.Crip.value				= "X";
		document.frmPersonal.Cotejado.value			= "N";
		document.frmPersonal.Tutor.value			= "";
		document.frmPersonal.Celular.value			= "2";
		document.frmPersonal.TipoSangre.value		= "O+";
		document.frmPersonal.Cedula.value			= "-";
		document.frmPersonal.BarrioId.value			= "0";
		document.frmPersonal.UrlPago.value			= "";
		document.frmPersonal.submit();		
	}
	
	function Grabar(){
		
		if(document.frmPersonal.CodigoPersonal.value!="" && document.frmPersonal.Nombre!=""
			&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
			&& document.frmPersonal.FNacimiento.value!="" && document.frmPersonal.Sexo.value!="" ){
			
			document.frmPersonal.Accion.value	="3";
			document.frmPersonal.tipo.value		= "Grabar";
			parent.document.getElementById("CodigoAlumno").value = document.frmPersonal.CodigoPersonal.value;					
			document.frmPersonal.submit();
			
		}else{
			alert("<fmt:message key="aca.CamposObligatorios" />");
		}
	}
	
	function Modificar(){
		  				   
		if(document.frmPersonal.CodigoPersonal.value!="" && document.frmPersonal.Nombre!=""
			&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
			&& document.frmPersonal.FNacimiento.value!="" && document.frmPersonal.Sexo.value!="" ){

			document.frmPersonal.Accion.value	= "4";
			document.frmPersonal.submit();
			
		}else{
		
			alert("<fmt:message key="aca.CamposObligatorios" />");
		}
	}
	
	function Borrar( ){
		if(document.frmPersonal.CodigoPersonal.value!=""){
			if(confirm("<fmt:message key="aca.EliminarRegistro" />")==true){
	  			document.frmPersonal.Accion.value	= "5";
				document.frmPersonal.submit();
			}			
		}else{
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmPersonal.CodigoPersonal.focus(); 
	  	}
	}
	
	function ConsultarDatos(){
		document.frmPersonal.Accion.value	= "6";
		document.frmPersonal.submit();		
	}
	
	function PEC( Pec, tipo){		
		document.frmPersonal.Accion.value	= "7";
		document.frmPersonal.tipo.value 	= tipo;
		document.frmPersonal.Pec.value 		= Pec;
		document.frmPersonal.submit();
	}
	
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
	
	String strAccion 		= request.getParameter("Accion")==null?"6":request.getParameter("Accion");	
	int accion				= Integer.parseInt(strAccion);	
	
	String cicloId 			= aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId);
	String periodoId		= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);		
	 
	// Recuperar el codigo del Alumno en el request
	if (request.getParameter("CodigoAlumno")!=null) codigoAlumno = request.getParameter("CodigoAlumno");	
	
	String sTipo 			= request.getParameter("tipo")==null?"N":request.getParameter("tipo");	
	String vref				= request.getParameter("ref");	
	String strPlanId		= request.getParameter("Plan");
	
	Calendar año = new GregorianCalendar();
	String muestraAño			= String.valueOf(año.get(Calendar.YEAR));

	String nombreAlumno		= "";
	String tipoCodigo		= "";
	boolean acceso 			= false;
	
	session.setAttribute("mat",codigoAlumno);
	
	ArrayList<aca.plan.Plan> lisPlan		= PlanLista.getListEscuela(conElias, escuelaId, " ORDER BY NIVEL_ID");
	ArrayList<String> listTipoSangre 		= new ArrayList<String>();
	
	listTipoSangre.add("--");
	listTipoSangre.add("O+");
	listTipoSangre.add("O-");
	listTipoSangre.add("A+");
	listTipoSangre.add("A-");
	listTipoSangre.add("B+");
	listTipoSangre.add("B-");
	listTipoSangre.add("AB+");
	listTipoSangre.add("AB-");

	if(vref==null) vref		= "0";	
	String sResultado		= "";		
	String clave 			= "";
	String codPers			= "";	
	String nivelNombre		= "";
	
	boolean existePlan		= false;
	boolean existeAlumno	= false;
	boolean inscrito		= aca.vista.AlumInscrito.estaInscrito(conElias, codigoAlumno);
	

	Personal.setCodigoId(codigoAlumno);
	
	// Verificar plan del alumno	
	if(AlumPlan.mapeaRegActual(conElias,codigoAlumno)){
		if (strPlanId != null)
			strPlanId = AlumPlan.getPlanId();
		existePlan = true;
	}

	// Operaciones a realizar en la pantalla
	switch (accion){
	
		case 1:{// Consultar	
			
			if (Personal.existeReg(conElias)){				
				Personal.mapeaRegId(conElias, codigoAlumno);				
				existeAlumno = true;
				
				// Elegir el pais de acuerdo a la escuela
				if (escuelaId.contains("G") && Personal.getPaisId().equals("0")){
					// Colocar por default el pais de República Dominicana					
					Personal.setPaisId("166");					
				}else if (escuelaId.contains("H") && Personal.getPaisId().equals("0")){
					// Colocar por default el pais de Panama
					Personal.setPaisId("153");					
				}else if ( Personal.getPaisId().equals("0")){
					// Colocar por default el pais de Mexico
					Personal.setPaisId("135");
				}				
				
				nombreAlumno = aca.alumno.AlumPersonal.getNombre(conElias, codigoAlumno,"NOMBRE");
				if (nombreAlumno.equals("x")){		
					nombreAlumno = "No Definido";
				}else if (!codigoAlumno.substring(0,3).equals(escuelaId)){
					nombreAlumno = "No Pertenece";
				}else{
					acceso = true;
				}
			}			
			break;
		}
		case 3: { // Grabar
		
			strPlanId = request.getParameter("Plan");
			Personal.setCodigoId(Personal.maximoReg(conElias,escuelaId));
			Personal.setEscuelaId(escuelaId);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno( request.getParameter("ApellidoPaterno"));			
			Personal.setAmaterno( request.getParameter("ApellidoMaterno")==null?" ":request.getParameter("ApellidoMaterno"));						
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId")==null?"0":request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId")==null?"0":request.getParameter("CiudadId"));
			Personal.setClasfinId(request.getParameter("ClasificacionFin"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setNivelId(aca.plan.Plan.getNivel(conElias,strPlanId));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado("1");
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta")==null?"-":request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip")==null?"-":request.getParameter("Crip"));
			Personal.setReligion(request.getParameter("Religion"));
			Personal.setTransporte(request.getParameter("transporte"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));			
			Personal.setCorreo(request.getParameter("emailAlumno").equals("")?"-":request.getParameter("emailAlumno"));		
			Personal.setIglesia(request.getParameter("Iglesia").equals("")?"-":request.getParameter("Iglesia"));
			Personal.setTipoSangre(request.getParameter("TipoSangre"));
			Personal.setEstado(request.getParameter("Status").equals("")?"A":request.getParameter("Status"));
			Personal.setTutorCedula(request.getParameter("Cedula").equals("")?"-":request.getParameter("Cedula"));
			Personal.setBarrioId(request.getParameter("BarrioId")==null?"0":request.getParameter("BarrioId"));
			Personal.setUrlPago(request.getParameter("UrlPago")==null?"":request.getParameter("UrlPago"));
			conElias.setAutoCommit(false);
			
			if (Personal.existeReg(conElias) == false){
				if (Personal.insertReg(conElias)){
					session.setAttribute("codigoAlumno", Personal.getCodigoId());
					existeAlumno = true;
					
					Personal.mapeaRegId(conElias, codigoAlumno);
					AlumPlan.setCodigoId(codigoAlumno);
					AlumPlan.setPlanId(request.getParameter("Plan"));
					AlumPlan.setGrado(request.getParameter("Grado"));
					AlumPlan.setGrupo(request.getParameter("Grupo"));
					if (AlumPlan.grabaPlanActual(conElias)){
						sResultado = "Grabado: "+Personal.getCodigoId();
						Personal.mapeaRegId(conElias, codigoAlumno);
						acceso = true;
						existePlan = true;
						conElias.commit();	
					}else{
						conElias.rollback();
					}				
				}else{
					sResultado = "NoGrabó: "+Personal.getCodigoId();
				}
			}else{
				sResultado = "Existe: "+Personal.getCodigoId();
			}			
			
			conElias.setAutoCommit(true);
			
		}break;
		case 4: { // Modificar
			//System.out.println("modifica alumno " + request.getParameter("ApellidoPaterno"));
			
			strPlanId = request.getParameter("Plan");		
			Personal.setEscuelaId(escuelaId);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));			
			Personal.setAmaterno(request.getParameter("ApellidoMaterno")==null?" ":request.getParameter("ApellidoMaterno"));	
			
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId")==null?"0":request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId")==null?"0":request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId")==null?"0":request.getParameter("CiudadId"));
			Personal.setClasfinId(request.getParameter("ClasificacionFin"));
			
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setNivelId(aca.plan.Plan.getNivel(conElias,strPlanId));
			
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado("1");
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta")==null?"-":request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip")==null?"-":request.getParameter("Crip"));
			Personal.setReligion(request.getParameter("Religion"));
			
			Personal.setTransporte(request.getParameter("transporte"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));
			Personal.setCorreo(request.getParameter("emailAlumno").equals("")?"-":request.getParameter("emailAlumno"));
			Personal.setIglesia(request.getParameter("Iglesia").equals("")?"-":request.getParameter("Iglesia"));
			Personal.setTipoSangre(request.getParameter("TipoSangre"));
			
			Personal.setEstado(request.getParameter("Status")==null?"A":request.getParameter("Status"));
			
			
			Personal.setTutorCedula(request.getParameter("Cedula")!=null && !request.getParameter("Cedula").equals("") ? request.getParameter("Cedula") : "-");
			
			Personal.setBarrioId(request.getParameter("BarrioId")==null?"0":request.getParameter("BarrioId"));
			Personal.setUrlPago(request.getParameter("UrlPago")==null?"":request.getParameter("UrlPago"));
			Personal.setDiscapacidad("-");
			
			System.out.println("DATOS alumno " + Personal.toString());
			conElias.setAutoCommit(false);
			
			if (Personal.existeReg(conElias)){
				existeAlumno = true;
				
				if (Personal.updateReg(conElias)){
					Personal.mapeaRegId(conElias, codigoAlumno);
					AlumPlan.setCodigoId(codigoAlumno);
					AlumPlan.setPlanId(request.getParameter("Plan"));
					
					if (AlumPlan.updateGradoGrupo(conElias, request.getParameter("Grado"), request.getParameter("Grupo"))){
						existePlan = true;
						acceso = true;
						sResultado = "Modificado";
						conElias.commit();						
						Personal.mapeaRegId(conElias, codigoAlumno);
						
					}else{
						conElias.rollback();
					}
					
				}else{
					sResultado = "NoCambió: "+Personal.getCodigoId();
				}
			}else{
				sResultado = "NoExiste: "+Personal.getCodigoId();
			}
			
			conElias.setAutoCommit(true);
			
		}break;
		case 5: { // Borrar
			
			if (Personal.existeReg(conElias) == true){
				if(!KrdxCursoAct.tieneMaterias(conElias, codigoAlumno) && finMovtosLista.getMovimientosAlumno(conElias, codigoAlumno, "").isEmpty() ){//Si el alumno no tiene materias puede pasar a borrar
					
					conElias.setAutoCommit(false);
				
					alumCiclo.setCodigoId(codigoAlumno);
					alumPadres.setCodigoId(codigoAlumno);
					AlumPlan.setCodigoId(codigoAlumno);
					usuario.setCodigoId(codigoAlumno);
					usuarioMenu.setCodigoId(codigoAlumno);
					
					String nombre 	= aca.vista.Usuarios.getNombreUsuario(conElias, codigoAlumno);
					
					if(
						alumCiclo.deleteAllReg(conElias) && 
						alumPadres.deleteReg(conElias) && 
					   	AlumPlan.deleteAllReg(conElias) && 
					   	usuario.deleteReg(conElias, codigoAlumno, nombre, (String) session.getAttribute("user"), aca.vista.Usuarios.getNombreUsuario(conElias, (String)session.getAttribute("user")), aca.util.Fecha.getDateTime(), request.getRemoteAddr()) && 
					   	usuarioMenu.deleteAllReg(conElias)
					){
						if (Personal.deleteReg(conElias)){
							existeAlumno = false;
							acceso = true;
							sResultado = "Borrado: "+Personal.getCodigoId();
							conElias.commit();
						}else{
							conElias.rollback();
							sResultado = "NoBorró \""+Personal.getCodigoId()+"\". ";
						}
					}else{
						conElias.rollback();
						sResultado = "NoBorró \""+Personal.getCodigoId()+"\".";
					}
					conElias.setAutoCommit(true);
				}else{//si el alumno tiene materias, entonces no se borra
					sResultado = "NoBorró \""+Personal.getCodigoId()+"\".";
					Personal.mapeaRegId(conElias, codigoAlumno);
				}
			}else{
				sResultado = "NoExiste: "+Personal.getCodigoId();
				
			}
			break;
		}
		case 6: { // Consultar
			
			if (Personal.existeReg(conElias)){				
				acceso = true;
				existeAlumno = true;
				Personal.mapeaRegId(conElias, codigoAlumno);
				
				// Elegir el pais de acuerdo a la escuela
				if (escuelaId.contains("G") && Personal.getPaisId().equals("0")){
					// Colocar por default el pais de República Dominicana					
					Personal.setPaisId("166");					
				}else if (escuelaId.contains("H") && Personal.getPaisId().equals("0")){
					// Colocar por default el pais de Panama
					Personal.setPaisId("153");					
				}else if ( Personal.getPaisId().equals("0")){
					// Colocar por default el pais de Mexico
					Personal.setPaisId("135");
				}
				
				if (AlumPlan.mapeaRegActual(conElias,codigoAlumno)){
					strPlanId = AlumPlan.getPlanId();
					existePlan = true;
				}
				sResultado = "Consulta";
			}else{				
				sResultado = "NoExiste: "+Personal.getCodigoId();
				sTipo = "Empleado";
			}	
			break;
		}
		case 7: { // Refrescar combos PEC
			if (Personal.existeReg(conElias)){
				existeAlumno = true;
			}		
			
			Personal.setEscuelaId(escuelaId);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno")==null?" ":request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setBarrioId(request.getParameter("BarrioId"));
			Personal.setClasfinId(request.getParameter("ClasificacionFin"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado(request.getParameter("Status")==null?"A":request.getParameter("Status"));
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta")==null?"-":request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip")==null?"-":request.getParameter("Crip"));
			Personal.setReligion(request.getParameter("Religion"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));
			acceso = true;
			sResultado = "LlenarFormulario";
						
			break;
		}		
	}
	
	if ( codigoAlumno.length()>0 && !codigoAlumno.substring(3,4).equals("P") && !codigoAlumno.substring(3,4).equals("E"))
		tipoCodigo = "Alumno";
	else
		tipoCodigo = "Empleado";
	pageContext.setAttribute("resultado", sResultado);	
	
	alumPadres.mapeaRegId(conElias, codigoAlumno);
%>

<style>
	label{
		font-size: 14px;
		font-weight: 800;
	}
	.span4{
		font-size: 16px;
		font-weight: 300;
	}
</style>
<div id="content">

	<h2><fmt:message key="alumnos.InformaciondelAlumno" /></h2>

	<div class="well">
		<a class="btn btn-primary" href="datos.jsp"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
    </div>

	<form action="alumno.jsp" method="post" name="frmPersonal" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="Pec">
		<input type="hidden" name="tipo" value="<%=sTipo%>">
<%		
	if(Personal.existeReg(conElias)){		
		boolean tieneMaterias 	= KrdxCursoAct.tieneMaterias(conElias, codigoAlumno);		
		boolean tieneMovtos		= aca.fin.FinMovimientos.existeAlumno(conElias, codigoAlumno);
		boolean tienePagos 		= aca.fin.FinCalculoPago.existeEnPagos(conElias, codigoAlumno);		
		
%>		
		<div class="row">
			<div class="span3">
				<img src="imagen.jsp?id=<%=new java.util.Date().getTime()%>&nuevo=<%=accion==1?"S":"N" %>" width="300">
				
				<br /><br />
				
				<div class="well" style="text-align:center;">
					<%if(existeAlumno){%>
		            	<a class="btn btn-primary"  id="modificar" onclick="javascript:Modificar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></a>
		            	
		            	<%if(!tieneMaterias && inscrito==false && !tieneMovtos && !tienePagos){ %>
		            		<button class="btn btn-danger"  id="borrar" onclick="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar"/></button>
		            	<%} %> 
					<%}%>
				</div>
				
				<%
				// Dato capturado en las escuelas de Panamá
				String polizaSeguro = aca.catalogo.CatSeguro.getPoliza(conElias, escuelaId, muestraAño);
				
				//Si son escuelas de Panamá
				if(escuelaId.substring(0,1).equals("H")){
				%>	
					<h3>Poliza : <%=polizaSeguro.equals("X")?"¡Sin Registrar!":polizaSeguro%></h3>			
				<%	
				}
				%>
				
			</div>
			
			<div class="span3">		
				<p>
					<label><fmt:message key="aca.Clave"/></label>
					<input name="CodigoPersonal" type="text" value="<%if((accion!=1||accion==6)&&sTipo.equals("Nuevo"))out.print(Personal.maximoReg(conElias, escuelaId));else out.print(Personal.getCodigoId());%>" readonly="readonly"> 
				</p>
				
				<p>
					<label for=""><fmt:message key="aca.Nombre"/></label>
					<% if(!Personal.getCotejado().equals("S")){ %>
		            	<input name="Nombre" type="text" id="Nombre" maxlength="40" value="<%=Personal.getNombre()%>"> 
	              	<% }else{
						out.println(Personal.getNombre());
					%>
		            	<input name="Nombre" type="hidden" value="<%=Personal.getNombre()%>" /> 
	              	<% } %>
				</p>
				
				<p>
					<label><fmt:message key="aca.ApellidoPat"/></label>
   					<% if(!Personal.getCotejado().equals("S")){ %>
   							<input name="ApellidoPaterno" type="text" id="ApellidoPaterno" maxlength="40" value="<%=Personal.getApaterno()%>"> 
   					<% }else{
							out.println(Personal.getApaterno());
					%>
   							<input name="ApellidoPaterno" type="hidden" value="<%=Personal.getApaterno()%>"> 
   					<% } %>
				</p>
				
				<p>
					<label><fmt:message key="aca.ApellidoMat"/></label>
					<% if (!Personal.getCotejado().equals("S")){ %>
	              		<input name="ApellidoMaterno" type="text" id="ApellidoMaterno" maxlength="40" value="<%=Personal.getAmaterno()%>"> 
	              	<% }else{
							out.println(Personal.getAmaterno());
					%>
	              		<input name="ApellidoMaterno" type="hidden" value="<%=Personal.getAmaterno()%>"> 
	              	<% } %>
				</p>
				
				<p>
					<label><fmt:message key="aca.Genero"/></label>
					<select name="Sexo" id="Sexo">
	      				<option value='M' <% if(Personal.getGenero().equals("M")){out.print("selected");} %>><fmt:message key="aca.Hombre"/></option>
	      				<option value='F' <% if(Personal.getGenero().equals("F")){out.print("selected");} %>><fmt:message key="aca.Mujer"/></option>
           			</select>
				</p>
				
				<p>
					<label><fmt:message key="aca.FechadeNacimiento"/></label>
					<input name="FNacimiento" type="text" id="FNacimiento" maxlength="10" value="<%=Personal.getFNacimiento()%>">
				</p>
				
				<p>
					<label><fmt:message key="aca.Email"/></label>
					<input name="emailAlumno" type="text" id="emailAlumno" maxlength="50" value="<%=Personal.getCorreo()==null?"-":Personal.getCorreo()%>">
				</p>
				
				<p>
         			<label>
         				<fmt:message key="aca.TipoSangre"/>
         			</label> 
	              	
	              	<select name="TipoSangre" class="input-medium" <%if(inscrito){out.print("readonly");} %>>
	              		<%for(String sangre : listTipoSangre){ %>
		    				<option value="<%=sangre %>" <%if(Personal.getTipoSangre().equals(sangre+"")){out.print("selected");} %>><%=sangre %></option>
		    			<%}%>
	              	</select>
	            </p>
	            
	            <% if (escuelaId.contains("S")){ %>
	            <p>
	            	<label>
	            		Liga de pago
	            	</label>
	            	<input name="UrlPago" type="text" id="UrlPago" maxlength="50" value="<%=Personal.getUrlPago()==null?"":Personal.getUrlPago()%>" placeholder="https://url.com (incluir https://)">
	            </p>
	            <% } %>
				
			</div>
			
			<div class="span3">
				
				<p>
					<label><fmt:message key="aca.Pais"/></label>
					
			        <select name="PaisId" id="PaisId" tabindex="7">
				<%	
					ArrayList<aca.catalogo.CatPais> lisPais = PaisL.getListAll(conElias,"ORDER BY 2");
					for(aca.catalogo.CatPais pais: lisPais){
				%>
						<option value="<%=pais.getPaisId() %>" <%if(pais.getPaisId().equals(Personal.getPaisId())){out.print("selected");} %>><%=pais.getPaisNombre() %></option>						
				<%
					}				
				%>
					</select>
				</p>
				
				<p>
				<%	
					if (!escuelaId.contains("H")){%>
					<label><fmt:message key="aca.Estado"/></label>
					
				<%	}else{ %>
					<label><fmt:message key="aca.Provincia"/></label>
				<%	} %>					
				    <select name="EstadoId" id="EstadoId" >
	                <%	
						ArrayList<aca.catalogo.CatEstado> lisEstado = EstadoL.getArrayList(conElias, Personal.getPaisId(), "ORDER BY 1,3");
						for(aca.catalogo.CatEstado estado: lisEstado){
					%>
							<option value="<%=estado.getEstadoId() %>" <%if(estado.getEstadoId().equals(Personal.getEstadoId())){out.print("selected");} %>><%=estado.getEstadoNombre() %></option>
					<%							
						}
					%>
					</select>
				</p>
						
				<p>
				<%	if (!escuelaId.contains("H")){%>
					<label><fmt:message key="aca.Ciudad"/></label>
				<%	}else{ %>
					<label><fmt:message key="aca.Distrito"/></label>
				<%	} %>	
          			<select name="CiudadId" id="CiudadId" >
              	<%	
					ArrayList<aca.catalogo.CatCiudad> lisCiudad = CiudadL.getArrayList(conElias, Personal.getPaisId(), Personal.getEstadoId(), "ORDER BY 4");
					for(aca.catalogo.CatCiudad ciudad: lisCiudad){
				%>	
						<option value="<%=ciudad.getCiudadId() %>" <%if(ciudad.getCiudadId().equals(Personal.getCiudadId())){out.print("selected");} %>><%=ciudad.getCiudadNombre() %></option>
				<%						
					}
				%>
            		</select>
				</p>				
				<p>
				<%	if (!escuelaId.contains("H")){%>
					<label><fmt:message key="aca.Barrio"/></label>
				<%	}else{ %>
					<label><fmt:message key="aca.Corregimiento"/></label>
				<%	} %>	
          			<select name="BarrioId" id="BarrioId" tabindex="9">
              	<%              		
					ArrayList<aca.catalogo.CatBarrio> lisBarrio = BarrioL.getArrayList(conElias, Personal.getPaisId(), Personal.getEstadoId(),Personal.getCiudadId(), "ORDER BY BARRIO_NOMBRE");
					for(aca.catalogo.CatBarrio barrio: lisBarrio){
				%>	
						<option value="<%=barrio.getBarrioId() %>" <%if(barrio.getBarrioId().equals(Personal.getBarrioId())){ out.print("selected");} %>><%=barrio.getBarrioNombre() %></option>
				<%						
					}
				%>
            		</select>
				</p>
				<p>				
				<%	if (!escuelaId.contains("H") && !escuelaId.contains("S")){%>
					<label><fmt:message key='aca.CURP'/></label>	
				<%	}else if (escuelaId.contains("H")){%>					
					<label>C.I.P.</label>
				<%	}else if (escuelaId.contains("S")){%>					
					<label>NIE</label>
				<%	}%>
				    <input name="Curp" type="text" id="Curp" maxlength="19" value="<%=(Personal.getCurp().equals("-") || Personal.getCurp().equals("-") || Personal.getCurp().equals("null"))? "" : Personal.getCurp()%>"> 
				</p>
				
				<p>
					<label><fmt:message key="aca.ClassFin"/></label>
					<select name="ClasificacionFin" id="ClasificacionFin">
				    <%
				    	ArrayList<aca.catalogo.CatClasFin> clasificaciones = ClasFinLista.getListEscuela(conElias, escuelaId, "ORDER BY CLASFIN_ID");
						for(aca.catalogo.CatClasFin clasificacion : clasificaciones){
					%>
							<option value="<%=clasificacion.getClasfinId() %>" <%if(Personal.getClasfinId().equals(clasificacion.getClasfinId())){out.print("selected");} %>><%=clasificacion.getClasfinNombre() %></option>
					<%
						}				
				    %>
				    </select>
				</p>
					
				<p>
					<label><fmt:message key="aca.Religion"/></label>
					<select name="Religion" id="Religion">
					<%	
						ArrayList<aca.catalogo.CatReligion> religiones = catReligionLista.getListAll(conElias, "ORDER BY RELIGION_NOMBRE");
						for(aca.catalogo.CatReligion religion : religiones){	
					%>
							<option value="<%=religion.getReligionId() %>" <%if(Personal.getReligion().equals(religion.getReligionId())){out.print("selected");} %>><%=religion.getReligionNombre() %></option>		
					<%	
						}
					%>
					</select>
				</p>
					
				<p>
					<label><fmt:message key="aca.CRIP"/></label>
			        <input name="Crip" type="text" id="Crip" maxlength="20" value="<%=Personal.getCrip()==null?"-":Personal.getCrip()%>">
				</p>
				
			</div>
			
			<div class="span3">
				
				<p>
					<label><fmt:message key="aca.NoActa"/></label>
				    <input name="Acta" type="text" id="Acta" maxlength="20" value="<%=Personal.getActa()==null?"-":Personal.getActa()%>"> 
				</p>
				
				<p>
					<label><fmt:message key="aca.Cotejado"/></label> 
					<select name="Cotejado" id="Cotejado">
	                	<option value='S' <%if(Personal.getCotejado().equals("S")){out.print("selected");}%>><fmt:message key="aca.Si"/></option>
	                	<option value='N' <%if(Personal.getCotejado().equals("N")){out.print("selected");}%>><fmt:message key="aca.Negacion" /></option>
	             	</select>
				</p>
				<p>
			   		<label><fmt:message key="aca.Transporte"/></label>
            		<select id="transporte" name="transporte">
            			<option value="R"<%=Personal.getTransporte().equals("R")?" Selected":"" %>><fmt:message key="aca.Auto"/></option>
            			<option value="V"<%=Personal.getTransporte().equals("V")?" Selected":"" %>><fmt:message key="aca.Caminando"/></option>
            		</select>
				</p>
				
				<p>
					<label> 
						<%if(existePlan){%>
							<i class="icon-ok"></i>
						<%}else{%>
							<i class="icon-remove"></i>
						<%} %>
						<fmt:message key="aca.Plan"/>
					</label>
					<select name="Plan" id="Plan" <%if(inscrito){out.print("readonly");} %>>
					<%
						if(strPlanId==null && lisPlan.size()>0){
							strPlanId = lisPlan.get(0).getPlanId();
						}
					
	                	for(aca.plan.Plan plan : lisPlan){
							if(plan.getEstado().equals("I"))continue;
							if(inscrito && !plan.getPlanId().equals(strPlanId))continue;
					%>
							<option value="<%=plan.getPlanId() %>" <%if(plan.getPlanId().equals(strPlanId)){out.print("selected");} %>><%=plan.getPlanNombre() %></option>
					<%		
						}
					%>
         			</select>
         		</p>
         		<p>
         			<label>
         				<fmt:message key="aca.Grado"/>
         			</label> 
	              	
	              	<select name="Grado" class="input-mini" <%if(inscrito){out.print("readonly");} %>>
	              		<option value="0">X</option>
	              		<%for(int i = 1; i<=12; i++){ %>
	              			<%if(inscrito && !Personal.getGrado().equals(i+""))continue; %>
		    				<option value="<%=i %>" <%if(Personal.getGrado().equals(i+"")){out.print("selected");} %>><%=i %></option>
		    			<%}%>
		    			
		    			
	              	</select>
	            </p>
	            
	            <p>
	            	<label>
	            		<fmt:message key="aca.Grupo"/>
	            	</label> 
	            	<select name="Grupo" class="input-mini" <%if(inscrito){out.print("readonly");} %>>
		    			<%for(int i = 65; i <= 84; i++){%>
		    				<%if(inscrito && !Personal.getGrupo().equals(String.valueOf((char)i)))continue; %>
							<option value="<%=(char)i %>" <%if(Personal.getGrupo().equals(String.valueOf((char)i))) out.print("Selected"); %>><%=(char)i%></option>
						<%}%>
	              	</select>
	              	<%if(inscrito){ %>
						<a class="btn btn-primary" href="../cambiarGpo/cambioGrupo.jsp" style='margin-bottom:10px;'><i class="icon-file icon-white"></i> <fmt:message key="boton.Cambiar"/></a>
					<%} %>
	            </p>
				<p>
					<label for=""><fmt:message key="aca.Iglesia"/></label>
					<% if(!Personal.getCotejado().equals("S")){ %>
		            	<input name="Iglesia" type="text" id="Iglesia" maxlength="70" value="<%=Personal.getIglesia()%>"> 
	              	<% }else{
						out.println(Personal.getIglesia());
					%>
		            	<input name="Iglesia" type="hidden" value="<%=Personal.getIglesia()%>" /> 
	              	<% } %>
				</p>
				
				<p>
	            	<label>
	            		Status
	            	</label> 
					<select name="Status" class="input-medium" <%if(inscrito){out.print("Disabled");} %>>
	            		<option value="A" <%if(Personal.getEstado().equals("A")) out.print("Selected"); %>>Activo</option>
	            		<option value="I" <%if(Personal.getEstado().equals("I")) out.print("Selected"); %>>Inactivo</option>
	              	</select>
	            </p>
			</div>
		</div>
		
		
		<div class="row">
		
			<div class="span3"></div>
		
			<div class="span9">
				<div class="alert">
					<h4><fmt:message key="alumnos.DatosdelTutor"/> <a class="btn btn-primary" href="../../padre/datos/datosNew.jsp"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Nuevo"/></a></h4>
				</div>
			</div>
			
		</div>			
<%
		//System.out.println("PADRES: "+alumPadres.getCodigoPadre()+"-"+alumPadres.getCodigoMadre()+"-"+alumPadres.getCodigoTutor());
		if((alumPadres.getCodigoPadre().equals("-")||alumPadres.getCodigoPadre().equals("")) && 
				(alumPadres.getCodigoMadre().equals("-")||alumPadres.getCodigoMadre().equals("")) && 
				(alumPadres.getCodigoTutor().equals("-")||alumPadres.getCodigoTutor().equals(""))){
			if(Personal.getTutor()!=null && !Personal.getTutor().equals("-") && !Personal.getTutor().equals("null") && !Personal.getTutor().equals("")){
%>
		<div class="row">
			<div class="span3"></div>
			<div class="span3">
	          	<p>
	          		<label><fmt:message key="aca.Nombre"/></label>
	          		<input name="Tutor" type="text" id="Tutor" maxlength="40" value="<%=Personal.getTutor()%>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label><fmt:message key="aca.Colonia"/></label>
	          		<input type="text" name="Colonia" id="Colonia" maxlength="30" value="<%=(Personal.getColonia()==null || Personal.getColonia().equals("-") || Personal.getColonia().equals("null"))? "" : Personal.getColonia()%>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label>Cédula</label>
	          		<input type="text" name="Cedula" id="Cedula" maxlength="20" value="<%=(Personal.getTutorCedula()==null || Personal.getTutorCedula().equals("-") || Personal.getTutorCedula().equals("null"))? "" : Personal.getTutorCedula()%>" readonly="readonly">
	          	</p>
	        </div>
	        <div class="span3">
	          	<p>
	          		<label><fmt:message key="aca.Direccion"/></label>
	          		<input name="Direccion" type="text" id="Direccion" maxlength="100" value="<%=(Personal.getDireccion()==null || Personal.getDireccion().equals("-") || Personal.getDireccion().equals("null"))? "" : Personal.getDireccion()%>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label><fmt:message key="aca.Telefono"/></label>
	          		<input name="Telefono" type="text" id="Telefono" maxlength="60" value="<%=Personal.getTelefono()==null?"-":Personal.getTelefono()%>" readonly="readonly">
	          	</p>
	        </div>
	        <div class="span3">
	          	<p>
	          		<label><fmt:message key="aca.Celular"/></label>
	          		<input name="Celular" type="text" id="Celular" maxlength="60" value="<%=Personal.getCelular()==null?"-":Personal.getCelular()%>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label><fmt:message key="aca.Email"/></label>
	          		<input name="Email" type="text" id="Email" maxlength="50" value="<%=Personal.getEmail()==null?"-":Personal.getEmail()%>" readonly="readonly">	
	          	</p>
			</div>
		</div>
<%
			}
		}else{
%>
	          	<input name="Tutor" type="hidden" id="Tutor" maxlength="40" value="<%=(Personal.getTutor()==null || Personal.getTutor().equals("-") || Personal.getTutor().equals("null"))? "" : Personal.getTutor()%>">
	          	<input type="hidden" name="Colonia" id="Colonia" maxlength="30" value="<%=(Personal.getColonia()==null || Personal.getColonia().equals("-") || Personal.getColonia().equals("null"))? "" : Personal.getColonia()%>">
	          	<input type="hidden" name="Cedula" id="Cedula" maxlength="20" value="<%=(Personal.getTutorCedula()==null || Personal.getTutorCedula().equals("-") || Personal.getTutorCedula().equals("null"))? "" : Personal.getTutorCedula()%>">
	          	<input name="Direccion" type="hidden" id="Direccion" maxlength="100" value="<%=(Personal.getDireccion()==null || Personal.getDireccion().equals("-") || Personal.getDireccion().equals("null"))? "" : Personal.getDireccion()%>">
	          	<input name="Telefono" type="hidden" id="Telefono" maxlength="60" value="<%=Personal.getTelefono()==null?"-":Personal.getTelefono()%>">
	          	<input name="Celular" type="hidden" id="Celular" maxlength="60" value="<%=Personal.getCelular()==null?"-":Personal.getCelular()%>">
	          	<input name="Email" type="hidden" id="Email" maxlength="50" value="<%=Personal.getEmail()==null?"-":Personal.getEmail()%>">	
<%
			for(int i = 1; i <= 3; i++){
				String codigo = "", descripcion = "";
				switch(i){
				case 1: codigo = alumPadres.getCodigoPadre();descripcion = "Padre";break;
				case 2: codigo = alumPadres.getCodigoMadre();descripcion = "Madre";break;
				case 3: codigo = alumPadres.getCodigoTutor();descripcion = "Tutor";break;
				}
				if(!codigo.equals("") && !codigo.equals("-")){
					empPersonal.mapeaRegId(conElias, codigo);
%>
		<div class="row">
			<div class="span3"></div>
			<div class="span3">
	          	<p>
	          		<label><fmt:message key="aca.Nombre"/> de <%=descripcion %></label>
	          		<input type="text" maxlength="40" value="<%=empPersonal.getNombre() %> <%=empPersonal.getApaterno() %> <%=empPersonal.getAmaterno() %>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label><fmt:message key="aca.Colonia"/></label>
	          		<input type="text" maxlength="40" value="<%=(empPersonal.getColonia() == null || empPersonal.getColonia().equals("-") || empPersonal.getColonia().equals("null")) ? "" : empPersonal.getColonia()%>" readonly="readonly">
	          	</p>
	        </div>
	        <div class="span3">
	          	<p>
	          		<label><fmt:message key="aca.Direccion"/></label>
	          		<input type="text" maxlength="40" value="<%=(empPersonal.getDireccion() == null || empPersonal.getDireccion().equals("-") || empPersonal.getDireccion().equals("null")) ? "" : empPersonal.getDireccion() %>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label><fmt:message key="aca.Telefono"/>/<fmt:message key="aca.Celular"/></label>
	          		<input type="text" maxlength="40" value="<%=(empPersonal.getTelefono() == null || empPersonal.getTelefono().equals("-") || empPersonal.getTelefono().equals("null")) ? "" : empPersonal.getTelefono() %>" readonly="readonly">
	          	</p>
	        </div>
	        <div class="span3">
	          	<p>
	          		<label><fmt:message key="aca.Email"/></label>
	          		<input type="text" maxlength="40" value="<%=(empPersonal.getEmail() == null || empPersonal.getEmail().equals("-") || empPersonal.getEmail().equals("null")) ? "" : empPersonal.getEmail() %>" readonly="readonly">
	          	</p>
	          	<p>
	          		<label>C&eacute;dula/RFC</label>
	          		<input type="text" maxlength="40" value="<%=(empPersonal.getRfc() == null || empPersonal.getRfc().equals("-") || empPersonal.getRfc().equals("null")) ? "" : empPersonal.getRfc() %>" readonly="readonly">
	          	</p>
			</div>
		</div>
		<div class="row">
			<div class="span3"></div>
			<div class="span3">
				<a class="btn btn-primary" href="../../padre/datos/accion_p.jsp?CodigoPadre=<%=empPersonal.getCodigoId()%>"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Modificar"/></a>
			</div>
		</div>
		<hr />
<%
				}
			}
		}
%>
	</form>
</div>
<%	
	}		
%>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>

<script>

	$('#FNacimiento').datepicker();

	
	$('#PaisId').on('change', function(e){
		updateInfo('Estado');
	});
	
	$('#EstadoId').on('change', function(e){
		updateInfo('Ciudad');
	});
	
	$('#CiudadId').on('change', function(e){
		updateInfo('Barrio');
	});
	
	
	function updateInfo(tipo){
		let data = {
			tipo,
			PaisId : $('#PaisId').val(),
			EstadoId : $('#EstadoId').val(),
			CiudadId : $('#CiudadId').val(),
			BarrioId  : $('#BarrioId').val()
		};
		
		$.ajax({
			url: 'ajaxUbicacion.jsp',
			type : 'POST',
			data : data,
			success : function (output){
				$('#'+tipo+"Id").html(output);
				$('#'+tipo+"Id").trigger('change');
			},
			error : function (xhr, ajaxOptions, thrownError) {
				console.log("error ");
				alert(xhr.status + " " + thrownError);
			}
		});
	}
</script>

<%@ include file= "../../cierra_elias.jsp" %>