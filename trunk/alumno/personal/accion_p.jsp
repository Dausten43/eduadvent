<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<link href="../../bootstrap/css/bootstrap.min.css" rel="STYLESHEET" type="text/css">
  
<%@page import="aca.catalogo.CatReligion"%>
<%@page import="aca.alumno.AlumCiclo"%>
<%@page import="aca.kardex.KrdxCursoAct"%>

<jsp:useBean id="Personal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="PlanLista" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="catReligion" scope="page" class="aca.catalogo.CatReligion"/>
<jsp:useBean id="catReligionLista" scope="page" class="aca.catalogo.CatReligionLista"/>
<jsp:useBean id="alumCiclo" scope="page" class="aca.alumno.AlumCiclo"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioInformacion" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioMenu" scope="page" class="aca.usuario.UsuarioMenu"/>
<%!	
	private String getRandomString(){
		String alphaNum="1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		StringBuffer sbRan = new StringBuffer(11);
		int num;
		for(int i=0; i<11; i++){
			num = (int)(Math.random()*(alphaNum.length()-1));
			sbRan.append(alphaNum.substring(num, num+1));
		}
		return sbRan.toString();
	}
%>
<html>
	<head>
		<link href="../../css/academico.css" rel="STYLESHEET" type="text/css">
		<script type="text/javascript">
		
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
				document.frmPersonal.Acfe.value				= "N";
				document.frmPersonal.Acta.value				= "X";
				document.frmPersonal.Crip.value				= "X";
				document.frmPersonal.Cotejado.value			= "N";
				document.frmPersonal.Tutor.value			= "";
				document.frmPersonal.Celular.value			= "1";
				document.frmPersonal.submit();		
			}
			
			function Grabar(){
										
				if(document.frmPersonal.CodigoPersonal.value!="" && document.frmPersonal.Nombre!=""
					&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
					&& document.frmPersonal.FNacimiento.value!="" && document.frmPersonal.Sexo.value!="" ){
					
					document.frmPersonal.Accion.value	="2";
					document.frmPersonal.tipo.value		= "Nuevo";
					parent.document.getElementById("CodigoAlumno").value = document.frmPersonal.CodigoPersonal.value;					
					document.frmPersonal.submit();
					
				}else{
					alert(" Complete todos los campos con *");
				}
			}
			
			function Modificar(){
				  				   
				if(document.frmPersonal.CodigoPersonal.value!="" && document.frmPersonal.Nombre!=""
					&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
					&& document.frmPersonal.FNacimiento.value!="" && document.frmPersonal.Sexo.value!="" ){

					document.frmPersonal.Accion.value="3";
					document.frmPersonal.submit();
					
				}else{
				
					alert(" Complete todos los campos con *");
				}
			}
			
			function Borrar( ){
				if(document.frmPersonal.CodigoPersonal.value!=""){
					if(confirm("¿Estás seguro de eliminar el registro?")==true){
			  			document.frmPersonal.Accion.value="4";
						document.frmPersonal.submit();
					}			
				}else{
					alert("¡Escribe la Clave!");
					document.frmPersonal.CodigoPersonal.focus(); 
			  	}
			}
			
			function Consultar(){
				document.frmPersonal.Accion.value="5";
				document.frmPersonal.submit();		
			}
			
			function PEC( Pec, tipo){		
				document.frmPersonal.Accion.value="6";
				document.frmPersonal.tipo.value 	= tipo;
				document.frmPersonal.Pec.value 	= Pec;
				document.frmPersonal.submit();
			}
		</script>
	</head>
<%
	// Declaracion de variables
	String escuela 			= (String)session.getAttribute("escuela");
	String cicloId 			= aca.ciclo.Ciclo.getCargaActual(conElias, escuela);
	String periodoId		= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);
	
	//System.out.println("Datos:"+escuela+":"+cicloId+":"+periodoId);
	
	String sCodigo 			= request.getParameter("CodigoPersonal");
	String sTipo 			= request.getParameter("tipo");	
	String sAccion 			= request.getParameter("Accion");
	String vref				= request.getParameter("ref");	
	String strPlanId		= request.getParameter("Plan");
	
	session.setAttribute("mat",sCodigo);
	
	ArrayList listor		= new ArrayList();
	ArrayList lisPais		= new ArrayList();
	ArrayList lisPlan		= PlanLista.getListEscuela(conElias, escuela, " ORDER BY NIVEL_ID");
	
	if(vref==null) vref	= "0";
	if(sAccion==null) sAccion = "5";
	int nAccion				= Integer.parseInt(sAccion);
	int i 					= 0;
	String sResultado		= "";		
	String clave 			= "";
	String codPers			= "";	
	String nivelNombre		= "";
	
	boolean existePlan		= false;
	boolean existeAlumno	= false;
	boolean inscrito		= aca.vista.AlumInscrito.estaInscrito(conElias, sCodigo);
	
	Personal.setCodigoId(sCodigo);
	
	// Verificar plan del alumno	
	if(AlumPlan.mapeaRegActual(conElias,sCodigo)){
		if (strPlanId != null)
			strPlanId = AlumPlan.getPlanId();
		existePlan = true;
	}
	

	// Operaciones a realizar en la pantalla
	switch (nAccion){	
	
		case 1: { // Nuevo
			sResultado = "¡Llene el Formulario Correctamente!¡";
			Personal.setCodigoId(Personal.maximoReg(conElias,escuela));
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));			
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));					
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setClasfinId(request.getParameter("Acfe"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setNivelId(request.getParameter("NivelId"));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado(request.getParameter("Estado"));
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));
			Personal.setCorreo(request.getParameter("emailAlumno"));
			existeAlumno 	= false;
			existePlan 		= false;
		%>
			<script type="text/javascript">
				parent.document.getElementById("CodigoAlumno").value = "<%=Personal.maximoReg(conElias,escuela) %>";
			</script>
		<%
			
		}break;
		case 2: { // Grabar			
			strPlanId = request.getParameter("Plan");
			Personal.setCodigoId(Personal.maximoReg(conElias,escuela));
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno( request.getParameter("ApellidoPaterno"));			
			Personal.setAmaterno( request.getParameter("ApellidoMaterno"));						
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId")==null?"0":request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId")==null?"0":request.getParameter("CiudadId"));
			Personal.setClasfinId(request.getParameter("Acfe"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setNivelId(aca.plan.Plan.getNivel(conElias,strPlanId));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado("1");
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip"));
			Personal.setReligion(request.getParameter("Religion"));
			Personal.setTransporte(request.getParameter("transporte"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));			
			Personal.setCorreo(request.getParameter("emailAlumno").equals("")?"-":request.getParameter("emailAlumno"));			
			conElias.setAutoCommit(false);
			
			if (Personal.existeReg(conElias) == false){
				if (Personal.insertReg(conElias)){
					session.setAttribute("codigoAlumno", Personal.getCodigoId());
					existeAlumno = true;
					
					Personal.mapeaRegId(conElias, sCodigo);
					AlumPlan.setCodigoId(sCodigo);
					AlumPlan.setPlanId(request.getParameter("Plan"));
					AlumPlan.setGrado(request.getParameter("Grado"));
					AlumPlan.setGrupo(request.getParameter("Grupo"));
					if (AlumPlan.grabaPlanActual(conElias)){
						sResultado = "Grabado: "+Personal.getCodigoId();
						existePlan = true;
						conElias.commit();	
					}else{
						conElias.rollback();
					}				
				%>
					<script type="text/javascript">
						window.parent.document.location = window.parent.document.location;
					</script>
				<%
				}else{
					sResultado = "No Grabó: "+Personal.getCodigoId();
				}
			}else{
				sResultado = "Ya existe: "+Personal.getCodigoId();
			}			
			
			conElias.setAutoCommit(true);
			
		}break;
		case 3: { // Modificar					    	
			strPlanId = request.getParameter("Plan");
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));			
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));			
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId")==null?"0":request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId")==null?"0":request.getParameter("CiudadId"));
			Personal.setClasfinId(request.getParameter("Acfe"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setNivelId(aca.plan.Plan.getNivel(conElias,strPlanId));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado("1");
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip"));
			Personal.setReligion(request.getParameter("Religion"));
			Personal.setTransporte(request.getParameter("transporte"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));
			Personal.setCorreo(request.getParameter("emailAlumno").equals("")?"-":request.getParameter("emailAlumno"));
			Personal.setDiscapacidad("-");
			
			conElias.setAutoCommit(false);
			
			if (Personal.existeReg(conElias)){
				existeAlumno = true;
				if (Personal.updateReg(conElias)){
					Personal.mapeaRegId(conElias, sCodigo);
					AlumPlan.setCodigoId(sCodigo);
					AlumPlan.setPlanId(request.getParameter("Plan"));
					AlumPlan.setGrado(request.getParameter("Grado"));
					AlumPlan.setGrupo(request.getParameter("Grupo"));
					
					if (AlumPlan.grabaPlanActual(conElias)){
						existePlan = true;
						sResultado = "Modificado: "+Personal.getCodigoId();
						conElias.commit();
					}else{
						conElias.rollback();
					}
					
				}else{
					sResultado = "No Cambió: "+Personal.getCodigoId();
				}
			}else{
				sResultado = "No existe: "+Personal.getCodigoId();
			}
			
			conElias.setAutoCommit(true);
			
		}break;
		case 4: { // Borrar
			if (Personal.existeReg(conElias) == true){
				if(!KrdxCursoAct.tieneMaterias(conElias, sCodigo)){//Si el alumno no tiene materias puede pasar a borrar
					
					conElias.setAutoCommit(false);
				
					alumCiclo.setCodigoId(sCodigo);
					alumPadres.setCodigoId(sCodigo);
					AlumPlan.setCodigoId(sCodigo);
					usuario.setCodigoId(sCodigo);
					usuarioInformacion.setCodigoId(sCodigo);
					usuarioMenu.setCodigoId(sCodigo);
					if(alumCiclo.deleteAllReg(conElias) && alumPadres.deleteReg(conElias) && 
					   AlumPlan.deleteAllReg(conElias) && usuario.deleteReg(conElias) &&
					   usuarioInformacion.deleteReg(conElias) && usuarioMenu.deleteAllReg(conElias)){
						if (Personal.deleteReg(conElias)){
							existeAlumno = false;
							sResultado = "Borrado: "+Personal.getCodigoId();
							conElias.commit();
						}else{
							conElias.rollback();
							sResultado = "No Borr&oacute; \""+Personal.getCodigoId()+"\". Int&eacute;ntelo de nuevo";
						}
					}else{
						conElias.rollback();
						sResultado = "No Borr&oacute; \""+Personal.getCodigoId()+"\". Int&eacute;ntelo de nuevo";
					}
					conElias.setAutoCommit(true);
				}else{//si el alumno tiene materias, entonces no se borra
					sResultado = "No Borr&oacute; \""+Personal.getCodigoId()+"\" porque tiene materias asignadas";
					Personal.mapeaRegId(conElias, sCodigo);
				}
			}else{
				sResultado = "No existe: "+Personal.getCodigoId();
				
			}
			break;
		}
		case 5: { // Consultar
			if (Personal.existeReg(conElias) == true){
				existeAlumno = true;
				Personal.mapeaRegId(conElias, sCodigo);
				if (AlumPlan.mapeaRegActual(conElias,sCodigo)){
					strPlanId = AlumPlan.getPlanId();
					existePlan = true;
				}
				sResultado = "Consulta";
			}else{
				sResultado = "No existe: "+Personal.getCodigoId();				
				sTipo = "Nuevo";
			}	
			break;
		}
		case 6: { // Refrescar combos PEC
			if (sTipo.equals("Nuevo"))
			Personal.setCodigoId(Personal.maximoReg(conElias,escuela));
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setCurp(request.getParameter("Curp"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setClasfinId(request.getParameter("Acfe"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado("A");
			Personal.setGrupo(request.getParameter("Grupo"));
			Personal.setActa(request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip"));
			Personal.setReligion(request.getParameter("Religion"));
			Personal.setCelular(request.getParameter("Celular"));
			Personal.setTutor(request.getParameter("Tutor"));
			
			sResultado = "¡Llene correctamente el formulario!";
			
			break;
		}		
	}
	
	if(Personal.existeReg(conElias) || nAccion == 1 || nAccion == 2 || nAccion == 3 || nAccion == 6){%>
		<script type="text/javascript">
			function credencial(){
				abrirVentana("credencial",405,285,0,0,"no","yes","no","no","no","credencial.jsp");
			}
				
			function camara(){
				abrirVentana("camara",370,540,0,0,"no","yes","no","no","no","camara.jsp");
			}
				
			function abrirVentana(strName,iW,iH,TOP,LEFT,R,S,SC,T,TB,URL){
				var sF="";
				TOP = (screen.height - iH)/2-50
				LEFT = (screen.width - iW)/2
				sF+=iW?'width='+iW+',':'';
				sF+=iH?'height='+iH+',':'';
				sF+=R?'resizable='+R+',':'';
				sF+=S?'status='+S+',':'';
				sF+=SC?'scrollbars='+SC+',':'';
				sF+=T?'titlebar='+T+',':'';
				sF+=TB?'toolbar='+TB+',':'';
				sF+=TB?'menubar='+TB+',':'';
				sF+=TOP?'top='+TOP+',':'';
				sF+=LEFT?'left='+LEFT+',':'';
				newwindow = window.open(URL,strName?strName:'',sF)
				newwindow.focus();
			}
						
			function refrescar(){
				location.href="accion_p.jsp?x=<%=getRandomString()%>&CodigoPersonal=<%=sCodigo%>";
			}
			
			function inicio(){
				v = window.open("","camara");
				if (v.location.href=="about:blank")	v.close();
				else v.setMatricula('<%=sCodigo%>');
			}
		</script>
	<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" background="../../imagenes/back.gif">
		<form action="accion_p.jsp" method="post" name="frmPersonal" target="_self">
			<input type="hidden" name="Accion">
			<input type="hidden" name="Pec">
			<input type="hidden" name="tipo" value="<%=sTipo%>">
			<table width="80%" align="center" cellpadding="0" cellspacing="0" class="table table-fullcondensed table-nohover">	 
  				<tr>
  	  				<th align="center"><font size="2">Datos del Alumno</font></th>
  				</tr>
  				<tr>
    				<td valign="top">
	  					<table width="100%">
	  						<tr>
	  							<td colspan='2' rowspan='5' style="text-align:center;">
			  						<img src="imagen.jsp?id=<%=new java.util.Date().getTime()%>&nuevo=<%=sAccion.equals("1")?"S":"N" %>" width="140"><br>
              						<!-- input name="button" type='button' onclick='camara()' value='  Abrir Camara  '--> 
            					</td>
				            	<td width="14%"><strong>País: </strong></td>
				            	<td width="44%">
				            		<select name="PaisId" id="PaisId" onChange = "PEC('1','<%=sTipo%>')" tabindex="7">
									<%	aca.catalogo.CatPaisLista paisL = new aca.catalogo.CatPaisLista();
										lisPais = paisL.getListAll(conElias,"ORDER BY 2");
										for(i=0; i<lisPais.size(); i++){
											aca.catalogo.CatPais pais = (aca.catalogo.CatPais) lisPais.get(i);
											if(pais.getPaisId().equals(Personal.getPaisId())){
												out.print(" <option value='"+pais.getPaisId()+"' Selected>"+ pais.getPaisNombre()+"</option>");
											}
											else{
												out.print(" <option value='"+pais.getPaisId()+"'>"+ pais.getPaisNombre()+"</option>");
											}
										}				
										paisL = null;%>
					              	</select>
				             	</td>
	  						</tr>
				          	<tr> 
				            	<td><strong>Estado:</strong></td>
				            	<td>
				            		<select name="EstadoId" id="EstadoId"  onChange= "javascript:PEC('2','<%=sTipo%>')" tabindex="8">
					                <%	aca.catalogo.CatEstadoLista estadoL = new aca.catalogo.CatEstadoLista();
										listor = estadoL.getArrayList(conElias, Personal.getPaisId(), "ORDER BY 1,3");
										for(i=0; i<listor.size(); i++){
											aca.catalogo.CatEstado estado = (aca.catalogo.CatEstado) listor.get(i);
											if(estado.getEstadoId().equals(Personal.getEstadoId())){
												out.print(" <option value='"+estado.getEstadoId()+"' Selected>"+ estado.getEstadoNombre()+"</option>");
											}
											else{
												out.print(" <option value='"+estado.getEstadoId()+"'>"+ estado.getEstadoNombre()+"</option>");
											}				
										}
										listor 		= null;
										//pais	= null;
										estadoL	= null;
									  %>
				              		</select>
			              		</td>
				          	</tr>
							<tr>
			            		<td><strong>Ciudad:</strong></td>
			            		<td>
			            			<select name="CiudadId" id="CiudadId" tabindex="9">
			                		<%	aca.catalogo.CatCiudadLista ciudadL = new aca.catalogo.CatCiudadLista();
										listor = ciudadL.getArrayList(conElias, Personal.getPaisId(), Personal.getEstadoId(), "ORDER BY 4");
										for(i=0; i<listor.size(); i++){
											aca.catalogo.CatCiudad ciudad = (aca.catalogo.CatCiudad) listor.get(i);
											if(ciudad.getCiudadId().equals(Personal.getCiudadId())){
												out.print(" <option value='"+ciudad.getCiudadId()+"' Selected>"+ ciudad.getCiudadNombre()+"</option>");
											}
											else{
												out.print(" <option value='"+ciudad.getCiudadId()+"'>"+ ciudad.getCiudadNombre()+"</option>");
											}
										}
										listor = null;
										ciudadL	= null;%>
			              			</select>
								</td>
		          			</tr>
				          	<tr>
				            	<td><strong>CURP:</strong></td>
				            	<td>
				            		<input name="Curp" type="text" id="Curp" size="20" maxlength="19" value="<%=(Personal.getCurp().equals("-") || Personal.getCurp().equals("-                  ") || Personal.getCurp().equals("null"))? "" : Personal.getCurp()%>" tabindex="10"> 
				            	</td>
				          	</tr>
			          		<tr>
			          			<td colspan="2" rowspan='1'>
				          			<table width="100%" style="border:1px solid gray;">
				          				<tr><th colspan="2">Datos del Tutor</th></tr>
							          	<tr>
							            	<td width="14%"><strong>Tutor: </strong></td>
							            	<td width="44%">
							            		<input name="Tutor" type="text" id="Tutor" size="40" maxlength="40" value="<%=(Personal.getTutor()==null || Personal.getTutor().equals("-") || Personal.getTutor().equals("null"))? "" : Personal.getTutor()%>" tabindex="11"> 
							            	</td>          
							          	</tr>
							          	<tr> 
							            	<td><strong>Colonia: </strong></td>
							            	<td>
							            		<input type="text" name="Colonia" id="Colonia" size="20" maxlength="30" value="<%=(Personal.getColonia()==null || Personal.getColonia().equals("-") || Personal.getColonia().equals("null"))? "" : Personal.getColonia()%>" tabindex="11"> 
							            	</td>
							          	</tr>
							          	<tr> 
							            	<td><strong>Direcci&oacute;n:</strong></td>
							            	<td>
							            		<input name="Direccion" type="text" id="Direccion" size="40" maxlength="100" value="<%=(Personal.getDireccion()==null || Personal.getDireccion().equals("-") || Personal.getDireccion().equals("null"))? "" : Personal.getDireccion()%>" tabindex="12">
						            		</td>
							          	</tr>
							          	<tr> 
								            <td><strong>Tel&eacute;fono:</strong></td>
								            <td>
								            	<input name="Telefono" type="text" id="Telefono" size="15" maxlength="60" value="<%=(Personal.getTelefono()==null || Personal.getTelefono().equals("-") || Personal.getTelefono().equals("null"))? "" : Personal.getTelefono()%>" tabindex="12">
								            	&nbsp;&nbsp;&nbsp;
								            	<strong>Celular: </strong>
							            		<input name="Celular" type="text" id="Celular" size="15" maxlength="60" value="<%=(Personal.getCelular()==null || Personal.getCelular().equals("-") || Personal.getCelular().equals("null"))? "" : Personal.getCelular()%>" tabindex="12">
						            		</td>
							          	</tr>
							          	<tr>
							            	<td><strong>Email:</strong></td>
							            	<td>
							            		<input name="Email" type="text" id="Email" size="40" maxlength="50" value="<%=(Personal.getEmail()==null || Personal.getEmail().equals("-") || Personal.getEmail().equals("null"))? "" : Personal.getEmail()%>" tabindex="13">
						            		</td>
							          	</tr>
					          		</table>
					          	</td>
				          	</tr>
				          	<tr valign="bottom"> 
					            <td width="14%"><strong>Clave:<b><font color="#AE2113"> *</font></b></strong></td>
				            	<td width="28%">
									<input name="CodigoPersonal" <%if(nAccion==1||nAccion==6)out.print("type=\"text\"");else out.print("type=\"hidden\"");%> value="<%if(nAccion==1||nAccion==6&&sTipo.equals("Nuevo"))out.print(Personal.maximoReg(conElias, escuela));else out.print(Personal.getCodigoId());%>"> 
			              		<%	if(nAccion!=1 & nAccion!=6){%>
				              			<font size="2"><b><%=Personal.getCodigoId() %></b></font>
			              		<%	}%>
				          	</tr>
				          	<tr>
				            	<td><strong>Nombre:<b><font color="#AE2113"> *</font></b></strong></td>
				            	<td> 
				              	<%	if(!Personal.getCotejado().equals("S")){%>
					              		<input name="Nombre" type="text" id="Nombre" size="20" maxlength="40" value="<%=Personal.getNombre()%>" tabindex="1"> 
				              	<%	}
			              			else{
										out.println(Personal.getNombre());%>
					              		<input name="Nombre" type="hidden" value="<%=Personal.getNombre()%>" /> 
				              	<%	}%>
				            	</td>
				            	<td><strong>Clas. Fin.:</strong></td>
				            	<td>
					            	<select name="Acfe" id="Acfe" onChange="javascript:PEC('3','<%=sTipo%>')" tabindex="14">
				                	<% 	if(Personal.getClasfinId().equals("1")){%>
							                <option value='1' selected>ACFE</option>
							                <option value='2' >NO ACFE</option>
					                <%	}
				                		else{%>
						                	<option value='1'>ACFE</option>
					    		            <option value='2' selected>NO ACFE</option>
				            	    <%	}%>
				              		</select> 
								<%	if(Personal.getClasfinId().equals("2")){%>
										&nbsp;&nbsp;&nbsp;
										<strong>Religi&oacute;n:</strong>
										<select name="Religion" id="Religion" tabindex="15">
										<%	ArrayList lisReligion = catReligionLista.getListAll(conElias, "ORDER BY RELIGION_NOMBRE");
											for(int j = 0; j < lisReligion.size(); j++){
												catReligion = (CatReligion) lisReligion.get(j);
												if(catReligion.getReligionId().equals(Personal.getReligion())){%>
													<option value="<%=catReligion.getReligionId() %>" selected="selected"><%=catReligion.getReligionNombre() %></option>
											<%	}
												else{%>
														<option value="<%=catReligion.getReligionId() %>"><%=catReligion.getReligionNombre() %></option>
											<%	}
											}%>
										</select>
								<%	}else{%>
										<input type="hidden" name="Religion" id="Religion" value="1" />
								<%	}%>
				    	        </td>
		        	  		</tr>
          					<tr> 
            					<td><strong>A. Paterno:<b><font color="#AE2113"> *</font></b></strong></td>
            					<td>
              					<%	if(!Personal.getCotejado().equals("S")){%>
              							<input name="ApellidoPaterno" type="text" id="ApellidoPaterno" size="20" maxlength="40" value="<%=Personal.getApaterno()%>" tabindex="2"> 
              					<%	}
              						else{
										out.println(Personal.getApaterno());%>
              							<input name="ApellidoPaterno" type="hidden" value="<%=Personal.getApaterno()%>"> 
              					<%	}%>
            					</td>
            					<td><strong>Estudia:</strong></td>
            					<td>
								<%	nivelNombre = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Personal.getNivelId());
									if(inscrito){%>
			  							<input type="hidden" id="Plan" name="Plan" value="<%=strPlanId %>" />
              							<select name="Plan" id="Plan" tabindex="16" Disabled>
                						<%	for(int j=0; j<lisPlan.size(); j++){
												aca.plan.Plan plan = (aca.plan.Plan) lisPlan.get(j);
												if(strPlanId==null&&j==0) strPlanId = plan.getPlanId();
												if(plan.getPlanId().equals(strPlanId)){
													out.print(" <option value='"+plan.getPlanId()+"' Selected>"+ plan.getPlanNombre()+"</option>");
												}
												else{
													out.print(" <option value='"+plan.getPlanId()+"'>"+ plan.getPlanNombre()+"</option>");
												}
											}%>
              							</select>
										<strong>Gdo:
						              		<input type="hidden" id="Grado" name="Grado" value="<%=(Personal.getGrado().equals("-") || Personal.getGrado().equals("null"))? "" : Personal.getGrado()%>" /> 
						              		<input name="Grado" title="<%=nivelNombre%>" type="text" id="Grado" size="1" maxlength="1" value="<%=(Personal.getGrado().equals("-") || Personal.getGrado().equals("null"))?"":Personal.getGrado()%>" tabindex="17" Disabled>
						              		Gpo: 
						              		<input type="hidden" id="Grupo" name="Grupo" value="<%=(Personal.getGrupo().equals("-") || Personal.getGrupo().equals("null"))? "" : Personal.getGrupo()%>" />
						              		<input name="Grupo" type="text" id="Grupo" size="1" maxlength="1" value="<%=(Personal.getGrupo().equals("-") || Personal.getGrupo().equals("null"))? "" : Personal.getGrupo()%>" tabindex="18" Disabled>
						              	</strong>
								<%	}
									else{%>
			  							<select name="Plan" id="Plan" tabindex="16">
						                <%	for(int j=0; j<lisPlan.size(); j++){
												aca.plan.Plan plan = (aca.plan.Plan) lisPlan.get(j);
												
												if(plan.getEstado().equals("I"))continue;
												
												if(strPlanId==null&&j==0) strPlanId = plan.getPlanId();
												if(plan.getPlanId().equals(strPlanId)){
													out.print(" <option value='"+plan.getPlanId()+"' Selected>"+ plan.getPlanNombre()+"</option>");
												}
												else{
													out.print(" <option value='"+plan.getPlanId()+"'>"+ plan.getPlanNombre()+"</option>");
												}
											}%>
              							</select>
              							<strong>Gdo: 
						              		<input name="Grado" title="<%=nivelNombre%>" type="text" id="Grado" size="1" maxlength="1" value="<%=(Personal.getGrado().equals("-") || Personal.getGrado().equals("null"))? "" : Personal.getGrado()%>" tabindex="17">
						              		Gpo: 
						              		<input name="Grupo" type="text" id="Grupo" size="1" maxlength="1" value="<%=(Personal.getGrupo().equals("-") || Personal.getGrupo().equals("null"))? "" : Personal.getGrupo()%>" tabindex="18">
						              	</strong>&nbsp;
								<%	}
									if(existePlan){
										out.print("<img src='../../imagenes/acierto.gif' widht='17'>");
									}
									else{
										out.print("<img src='../../imagenes/no.gif' widht='17'>");
									}%>
           						</td>
       						</tr>
				          	<tr> 
				            	<td><strong>A. Materno:<b><font color="#AE2113"> *</font></b></strong></td>
				            	<td> 
				              	<%	if (!Personal.getCotejado().equals("S")){%>
				              			<input name="ApellidoMaterno" type="text" id="ApellidoMaterno" size="20" maxlength="40" value="<%=Personal.getAmaterno()%>" tabindex="3"> 
				              	<%	}
				              		else{
										out.println(Personal.getAmaterno());%>
				              			<input name="ApellidoMaterno" type="hidden" value="<%=Personal.getAmaterno()%>"> 
				              	<%	}%>
				            	</td>
				            	<td><strong>No. Acta: </strong></td>
				            	<td>
				            		<input name="Acta" type="text" id="Acta" size="20" maxlength="20" value="<%=(Personal.getActa().equals("-") || Personal.getActa().equals("null"))? "" : Personal.getActa()%>" tabindex="19"> 
				            	</td>
				          	</tr>
							<tr>
			            		<td><strong>Género:<b><font color="#AE2113"> *</font></b></strong></td>
								<td>
									<select name="Sexo" id="Sexo" tabindex="4">
		                			<%	if(Personal.getGenero().equals("M")){%>
			                				<option value='M' selected>Hombre</option>
			                				<option value='F' >Mujer</option>
			                		<%	}
		                				else{%>
			                				<option value='M'>Hombre</option>
			                				<option value='F' selected>Mujer</option>
			                		<%	}%>
			              			</select>
		              			</td>
			            		<td><strong>CRIP:</strong></td>
			            		<td>
			                		<input name="Crip" type="text" id="Crip" size="20" maxlength="20" value="<%=(Personal.getCrip().equals("-") || Personal.getCrip().equals("null"))? "" : Personal.getCrip()%>" tabindex="20">
			            		</td>
		          			</tr>
						  	<tr>
				            	<td><strong>F. Nacimiento:<b><font color="#AE2113"> *</font></b></strong></td>
								<td>
							  		<input name="FNacimiento" type="text" id="FNacimiento" size="10" maxlength="10" value="<%=Personal.getFNacimiento()%>" tabindex="5"> DD/MM/AAAA
			            		</td>
				            	<td>
				            		<strong>Cotejado:</strong> 
								</td>            
				            	<td>
									<select name="Cotejado" id="Cotejado" tabindex="21">
				                	<%	if(Personal.getCotejado().equals("S")){%>
					                		<option value='S' selected>Si</option>
					                		<option value='N' >No</option>
				                	<%	}
				                		else{%>
					                	<option value='S'>Si</option>
					                	<option value='N' selected>No</option>
				                	<%	}%>
				              		</select>
				            	</td>
			          		</tr>
			          		<tr>
			          			<td><strong>Email: </strong></td>
				            	<td>
				            		<input name="emailAlumno" type="text" id="emailAlumno" size="20" maxlength="50" value="<%=(Personal.getCorreo()==null || Personal.getCorreo().equals("-")) ? "" : Personal.getCorreo() %>" tabindex="6"> 
				            	</td>
				            	<td>
				            		<strong>Transporte:</strong>
				            	</td>
				            	<td>
				            		<select id="transporte" name="transporte" tabindex="22">
				            			<option value="R"<%=Personal.getTransporte().equals("R")?" Selected":"" %>>Automóvil</option>
				            			<option value="V"<%=Personal.getTransporte().equals("V")?" Selected":"" %>>Caminando</option>
				            		</select>
				            	</td>
			          		</tr>
			          		<tr>
				            	<td colspan="4" style="text-align:center;"><%=sResultado%></td>
				          	</tr>
				          	<tr>
				            	<td colspan="4" style="text-align:center;">
								<%	if(nAccion != 1){%>
				              			<input class="btn btn-primary" type="button" value="Modificar" id="modificar" onclick="javascript:Modificar()" style="cursor:pointer" tabindex="23"/>
				              			<input class="btn btn-primary" type="button" value="Borrar" id="borrar" onclick="javascript:Borrar()" style="cursor:pointer"/> 
								<%	}%>
				            	</td>
				          	</tr>
       					</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
<%	}else{%>
		<body>
			<table width="100%">
				<tr><td align="center" width="100%"><font size="5" color="red">Este alumno no existe</font></td></tr>
			</table>
		</body>
<%	}%>
</html>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FNacimiento').datepicker();
	$('#FFinal').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>