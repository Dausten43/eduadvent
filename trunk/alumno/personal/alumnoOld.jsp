<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

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
<jsp:useBean id="ClasFinLista" scope="page" class="aca.catalogo.CatClasFinLista"/>

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
<head>
  <script type="text/javascript">
  
	function ConsultarAlumno(){				
		document.frmPersonal.Accion.value="1";
		document.frmPersonal.submit();
	}
	
	function Refresca (e){
		if(e.keyCode == 13){
			e.preventDefault()
			ConsultarAlumno();
		}
	}
	
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
		document.frmPersonal.Celular.value			= "2";
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
</head>
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
	
	String nombreAlumno		= "";
	String tipoCodigo		= "";
	boolean acceso 			= false;
	
	session.setAttribute("mat",codigoAlumno);
	
	ArrayList listor		= new ArrayList();
	ArrayList lisPais		= new ArrayList();
	ArrayList lisPlan		= PlanLista.getListEscuela(conElias, escuelaId, " ORDER BY NIVEL_ID");
	
	if(vref==null) vref		= "0";	
	int i 					= 0;
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
	
		case 1:{			
			if (Personal.existeReg(conElias)){				
				Personal.mapeaRegId(conElias, codigoAlumno);
				existeAlumno = true;
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
		
		case 2: { // Nuevo
			sResultado = "LlenarFormulario";
			Personal.setCodigoId(Personal.maximoReg(conElias,escuelaId));
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
				parent.document.getElementById("CodigoAlumno").value = "<%=Personal.maximoReg(conElias,escuelaId) %>";
			</script>
		<%
			
		}break;
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
			Personal.setActa(request.getParameter("Acta")==null?"-":request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip")==null?"-":request.getParameter("Crip"));
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
				%>
					<script type="text/javascript">
						window.parent.document.location = window.parent.document.location;
					</script>
				<%
				}else{
					sResultado = "NoGrabó: "+Personal.getCodigoId();
				}
			}else{
				sResultado = "Existe: "+Personal.getCodigoId();
			}			
			
			conElias.setAutoCommit(true);
			
		}break;
		case 4: { // Modificar					    	
			strPlanId = request.getParameter("Plan");
			
			Personal.setEscuelaId(escuelaId);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));			
			Personal.setAmaterno(request.getParameter("ApellidoMaterno")==null?" ":request.getParameter("ApellidoMaterno"));	
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
			Personal.setActa(request.getParameter("Acta")==null?"-":request.getParameter("Acta"));
			Personal.setCrip(request.getParameter("Crip")==null?"-":request.getParameter("Crip"));
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
					Personal.mapeaRegId(conElias, codigoAlumno);
					AlumPlan.setCodigoId(codigoAlumno);
					AlumPlan.setPlanId(request.getParameter("Plan"));
					AlumPlan.setGrado(request.getParameter("Grado"));
					AlumPlan.setGrupo(request.getParameter("Grupo"));
					
					if (AlumPlan.grabaPlanActual(conElias)){
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
				if(!KrdxCursoAct.tieneMaterias(conElias, codigoAlumno)){//Si el alumno no tiene materias puede pasar a borrar
					
					conElias.setAutoCommit(false);
				
					alumCiclo.setCodigoId(codigoAlumno);
					alumPadres.setCodigoId(codigoAlumno);
					AlumPlan.setCodigoId(codigoAlumno);
					usuario.setCodigoId(codigoAlumno);
					usuarioInformacion.setCodigoId(codigoAlumno);
					usuarioMenu.setCodigoId(codigoAlumno);
					if(alumCiclo.deleteAllReg(conElias) && alumPadres.deleteReg(conElias) && 
					   AlumPlan.deleteAllReg(conElias) && usuario.deleteReg(conElias) &&
					   usuarioInformacion.deleteReg(conElias) && usuarioMenu.deleteAllReg(conElias)){
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
			Personal.setClasfinId(request.getParameter("Acfe"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setCotejado(request.getParameter("Cotejado"));
			Personal.setGrado(request.getParameter("Grado"));
			Personal.setEstado("A");
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
%>
<body>
<div id="content">

	<form action="alumno.jsp" method="post" name="frmPersonal" target="_self">
	<input type="hidden" name="Accion">
	<input type="hidden" name="Pec">
	<input type="hidden" name="tipo" value="<%=sTipo%>">
	
    <h2><fmt:message key="alumnos.InformaciondelAlumno" />
    <small> 
      Registros: <%=aca.alumno.AlumPersonal.getTotalRegistros(conElias, escuelaId) %> 
      Máximo:  <%=aca.alumno.AlumPersonal.getMaxReg(conElias, escuelaId) %>
     </small></h2> 
    
    <div class="well" style="overflow:hidden;">
    	<input name="CodigoAlumno" style="text-align:center" id="CodigoAlumno" type="text" value="<%=Personal.getCodigoId()%>" onKeypress="Refresca(event)">
		<a class="btn btn-info" onclick="javascript:ConsultarAlumno()" title="Consultar datos"><i class="icon-search icon-white"> </i><fmt:message key="boton.Consultar" /></a>
		<a class="btn btn-info" href="datos.jsp" title="Nuevo padre"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
    </div>    
	<br>
<%	if (acceso){
	
		if(Personal.existeReg(conElias) || accion == 2 || accion == 3 || accion == 4 || accion == 7){
%>
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
			location.href="accion_p.jsp?x=<%=getRandomString()%>&CodigoPersonal=<%=codigoAlumno%>";
		}
			
		function inicio(){
			v = window.open("","camara");
			if (v.location.href=="about:blank")	v.close();
			else v.setMatricula('<%=codigoAlumno%>');
		}
	</script>		
	<table width="80%" align="center" cellpadding="0" cellspacing="0" class="table table-fullcondensed table-nohover">	 
  		<tr>
  			<th align="center"><font size="2"><fmt:message key="alumnos.DatosdelAlumno"/></font></th>
  		</tr>
  		<tr>
    		<td valign="top">
	  			<table width="100%">
	  				<tr>
	  					<td colspan='2' rowspan='5' style="text-align:center;">
							<img src="imagen.jsp?id=<%=new java.util.Date().getTime()%>&nuevo=<%=accion==1?"S":"N" %>" width="140"><br>
        					<!-- input name="button" type='button' onclick='camara()' value='  Abrir Camara  '--> 
        				</td>
			           	<td width="14%"><strong><fmt:message key="aca.Pais"/>:</strong></td>
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
								paisL = null;
							%>
					              	</select>
				             	</td>
	  						</tr>
				          	<tr> 
				            	<td><strong><fmt:message key="aca.Estado"/>:</strong></td>
				            	<td>
				            		<select name="EstadoId" id="EstadoId"  onChange= "javascript:PEC('2','<%=sTipo%>')" tabindex="8">
					                <%	
					                	aca.catalogo.CatEstadoLista estadoL = new aca.catalogo.CatEstadoLista();
										listor = estadoL.getArrayList(conElias, Personal.getPaisId(), "ORDER BY 1,3");
										if (listor!=null){						
											for(i=0; i<listor.size(); i++){
												aca.catalogo.CatEstado estado = (aca.catalogo.CatEstado) listor.get(i);
												if(estado.getEstadoId().equals(Personal.getEstadoId())){
													out.print(" <option value='"+estado.getEstadoId()+"' Selected>"+ estado.getEstadoNombre()+"</option>");
												}
												else{
													out.print(" <option value='"+estado.getEstadoId()+"'>"+ estado.getEstadoNombre()+"</option>");
												}				
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
			            		<td><strong><fmt:message key="aca.Ciudad"/>:</strong></td>
			            		<td>
			            			<select name="CiudadId" id="CiudadId" tabindex="9">
			                		<%	
			                			aca.catalogo.CatCiudadLista ciudadL = new aca.catalogo.CatCiudadLista();
										listor = ciudadL.getArrayList(conElias, Personal.getPaisId(), Personal.getEstadoId(), "ORDER BY 4");
										if (listor!=null){											
											for(i=0; i<listor.size(); i++){
												aca.catalogo.CatCiudad ciudad = (aca.catalogo.CatCiudad) listor.get(i);
												if(ciudad.getCiudadId().equals(Personal.getCiudadId())){
													out.print(" <option value='"+ciudad.getCiudadId()+"' Selected>"+ ciudad.getCiudadNombre()+"</option>");
												}
												else{
													out.print(" <option value='"+ciudad.getCiudadId()+"'>"+ ciudad.getCiudadNombre()+"</option>");
												}
											}
										}	
										listor = null;
										ciudadL	= null;%>
			              			</select>
								</td>
		          			</tr>
				          	<tr>
				            	<td><strong><fmt:message key="aca.CURP"/>:</strong></td>
				            	<td>
				            		<input name="Curp" type="text" id="Curp" size="20" maxlength="19" value="<%=(Personal.getCurp().equals("-") || Personal.getCurp().equals("-                  ") || Personal.getCurp().equals("null"))? "" : Personal.getCurp()%>" tabindex="10"> 
				            	</td>
				          	</tr>
			          		<tr>
			          			<td colspan="2" rowspan='1'>
				          			<table width="100%" style="border:1px solid gray;">
				          				<tr><th colspan="2"><fmt:message key="alumnos.DatosdelTutor"/></th></tr>
							          	<tr>
							            	<td width="14%"><strong><fmt:message key="alumnos.DatosdelTutor"/>:</strong></td>
							            	<td width="44%">
							            		<input name="Tutor" type="text" id="Tutor" size="40" maxlength="40" value="<%=(Personal.getTutor()==null || Personal.getTutor().equals("-") || Personal.getTutor().equals("null"))? "" : Personal.getTutor()%>" tabindex="11"> 
							            	</td>          
							          	</tr>
							          	<tr> 
							            	<td><strong><fmt:message key="aca.Colonia"/>:</strong></td>
							            	<td>
							            		<input type="text" name="Colonia" id="Colonia" size="20" maxlength="30" value="<%=(Personal.getColonia()==null || Personal.getColonia().equals("-") || Personal.getColonia().equals("null"))? "" : Personal.getColonia()%>" tabindex="11"> 
							            	</td>
							          	</tr>
							          	<tr> 
							            	<td><strong><fmt:message key="aca.Direccion"/>:</strong></td>
							            	<td>
							            		<input name="Direccion" type="text" id="Direccion" size="40" maxlength="100" value="<%=(Personal.getDireccion()==null || Personal.getDireccion().equals("-") || Personal.getDireccion().equals("null"))? "" : Personal.getDireccion()%>" tabindex="12">
						            		</td>
							          	</tr>
							          	<tr> 
								            <td><strong><fmt:message key="aca.Telefono"/>:</strong></td>
								            <td>
								            	<input name="Telefono" type="text" id="Telefono" size="15" maxlength="60" value="<%=Personal.getTelefono()==null?"-":Personal.getTelefono()%>" tabindex="12">
								            	&nbsp;&nbsp;&nbsp;
								            	<strong><fmt:message key="aca.Celular"/>:</strong>
							            		<input name="Celular" type="text" id="Celular" size="15" maxlength="60" value="<%=Personal.getCelular()==null?"-":Personal.getCelular()%>" tabindex="12">
						            		</td>
							          	</tr>
							          	<tr>
							            	<td><strong><fmt:message key="aca.Email"/>:</strong></td>
							            	<td>
							            		<input name="Email" type="text" id="Email" size="40" maxlength="50" value="<%=Personal.getEmail()==null?"-":Personal.getEmail()%>" tabindex="13">
						            		</td>
							          	</tr>
					          		</table>
					          	</td>
				          	</tr>
				          	<tr valign="bottom"> 
					            <td width="14%"><strong><fmt:message key="aca.Clave"/>:<b><font color="#AE2113"> *</font></b></strong></td>
				            	<td width="28%">
									<input name="CodigoPersonal" <%if(accion==1||accion==6)out.print("type=\"text\"");else out.print("type=\"hidden\"");%> 
									value="<%if((accion!=1||accion==6)&&sTipo.equals("Nuevo"))out.print(Personal.maximoReg(conElias, escuelaId));else out.print(Personal.getCodigoId());%>" readonly="readonly"> 
			              		<%	if(accion!=1 & accion!=6){%>
				              			<font size="2"><b><%=Personal.getCodigoId() %></b></font>
			              		<%	}%>
				          	</tr>
				          	<tr>
				            	<td><strong><fmt:message key="aca.Nombre"/>:<b><font color="#AE2113"> *</font></b></strong></td>
				            	<td> 
				              	<%	if(!Personal.getCotejado().equals("S")){%>
					              		<input name="Nombre" type="text" id="Nombre" size="20" maxlength="40" value="<%=Personal.getNombre()%>" tabindex="1"> 
				              	<%	}
			              			else{
										out.println(Personal.getNombre());%>
					              		<input name="Nombre" type="hidden" value="<%=Personal.getNombre()%>" /> 
				              	<%	}%>
				            	</td>
				            	<td><strong><fmt:message key="aca.ClassFin"/>:</strong></td>
				            	<td>
				            		<select name="Acfe" id="Acfe" onChange="javascript:PEC('3','<%=sTipo%>')" tabindex="14">
				            	<%
				            		listor = ClasFinLista.getListEscuela(conElias, escuelaId, "ORDER BY CLASFIN_ID");
									if (listor!=null){											
										for(i=0; i<listor.size(); i++){
											aca.catalogo.CatClasFin clasFin = (aca.catalogo.CatClasFin) listor.get(i);
											if(clasFin.getClasfinId().equals(Personal.getClasfinId() )){
												out.print(" <option value='"+clasFin.getClasfinId()+"' Selected>"+ clasFin.getClasfinNombre()+"</option>");
											}else{
												out.print(" <option value='"+clasFin.getClasfinId()+"'>"+ clasFin.getClasfinNombre()+"</option>");
											}
										}
									}	
									listor = null;
				            	%>
				              		</select>
								<%	if(Personal.getClasfinId().equals("2")){%>
										&nbsp;&nbsp;&nbsp;
										<strong><fmt:message key="aca.Religion"/>:</strong>
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
            					<td><strong><fmt:message key="aca.APaterno"/>:<b><font color="#AE2113"> *</font></b></strong></td>
            					<td>
              					<%	if(!Personal.getCotejado().equals("S")){%>
              							<input name="ApellidoPaterno" type="text" id="ApellidoPaterno" size="20" maxlength="40" value="<%=Personal.getApaterno()%>" tabindex="2"> 
              					<%	}
              						else{
										out.println(Personal.getApaterno());%>
              							<input name="ApellidoPaterno" type="hidden" value="<%=Personal.getApaterno()%>"> 
              					<%	}%>
            					</td>
            					<td><strong><fmt:message key="aca.Estudia"/>:</strong></td>
            					<td>
								<%	nivelNombre = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), Personal.getNivelId());
									if(inscrito){%>
              							<select name="Plan" id="Plan" tabindex="16" Disabled class="input-xxlarge">
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
              							<input id="Plan" name="Plan" value="<%=strPlanId %>" type="hidden" />
              							<br>
										<strong><fmt:message key="aca.Gdo"/>:
						              		<input type="hidden" id="Grado" name="Grado" value="<%=(Personal.getGrado().equals("-") || Personal.getGrado().equals("null"))? "" : Personal.getGrado()%>" /> 
						              		<input name="Grado" title="<%=nivelNombre%>" type="text" id="Grado" size="2" maxlength="2" value="<%=(Personal.getGrado().equals("-") || Personal.getGrado().equals("null"))?"":Personal.getGrado()%>" tabindex="17" Disabled>
						              		<fmt:message key="aca.Gpo"/>: 
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
              							<strong><fmt:message key="aca.Gdo"/>: 
						              		<input name="Grado" title="<%=nivelNombre%>" type="text" id="Grado" size="2" maxlength="2" value="<%=(Personal.getGrado().equals("-") || Personal.getGrado().equals("null"))? "" : Personal.getGrado()%>" tabindex="17">
						              		<fmt:message key="aca.Gpo"/>: 
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
				            	<td><strong><fmt:message key="aca.AMaterno"/>:<b><font color="#AE2113"> *</font></b></strong></td>
				            	<td> 
				              	<%	if (!Personal.getCotejado().equals("S")){%>
				              			<input name="ApellidoMaterno" type="text" id="ApellidoMaterno" size="20" maxlength="40" value="<%=Personal.getAmaterno()%>" tabindex="3"> 
				              	<%	}
				              		else{
										out.println(Personal.getAmaterno());%>
				              			<input name="ApellidoMaterno" type="hidden" value="<%=Personal.getAmaterno()%>"> 
				              	<%	}%>
				            	</td>				            	
				            	<td><strong><fmt:message key="aca.NoActa"/>: </strong></td>
				            	<td>
				            		<input name="Acta" type="text" id="Acta" size="20" maxlength="20" value="<%=Personal.getActa()==null?"-":Personal.getActa()%>" tabindex="19"> 
				            	</td>
				          	</tr>
							<tr>
			            		<td><strong><fmt:message key="aca.Genero"/>:<b><font color="#AE2113"> *</font></b></strong></td>
								<td>
									<select name="Sexo" id="Sexo" tabindex="4">
		                			<%	if(Personal.getGenero().equals("M")){%>
			                				<option value='M' selected><fmt:message key="aca.Hombre"/></option>
			                				<option value='F' ><fmt:message key="aca.Mujer"/></option>
			                		<%	}
		                				else{%>
			                				<option value='M'><fmt:message key="aca.Hombre"/></option>
			                				<option value='F' selected><fmt:message key="aca.Mujer"/></option>
			                		<%	}%>
			              			</select>
		              			</td>
			            		<td><strong><fmt:message key="aca.CRIP"/>:</strong></td>
			            		<td>
			                		<input name="Crip" type="text" id="Crip" size="20" maxlength="20" value="<%=Personal.getCrip()==null?"-":Personal.getCrip()%>" tabindex="20">
			            		</td>
		          			</tr>
						  	<tr>
				            	<td><strong><fmt:message key="aca.FNac"/>:<b><font color="#AE2113"> *</font></b></strong></td>
								<td>
							  		<input name="FNacimiento" type="text" id="FNacimiento" size="10" maxlength="10" value="<%=Personal.getFNacimiento()%>" tabindex="5"> DD/MM/AAAA
			            		</td>
				            	<td>
				            		<strong><fmt:message key="aca.Cotejado"/>:</strong> 
								</td>   
				            	<td>
									<select name="Cotejado" id="Cotejado" tabindex="21">
				                	<%	if(Personal.getCotejado().equals("S")){%>
					                		<option value='S' selected><fmt:message key="aca.Si"/></option>
					                		<option value='N' >No</option>
				                	<%	}
				                		else{%>
					                	<option value='S'><fmt:message key="aca.Si"/></option>
					                	<option value='N' selected>No</option>
				                	<%	}%>
				              		</select>
				            	</td>
			          		</tr>
			          		<tr>
			          			<td><strong><fmt:message key="aca.Email"/>: </strong></td>
				            	<td>
				            		<input name="emailAlumno" type="text" id="emailAlumno" size="20" maxlength="50" value="<%=Personal.getCorreo()==null?"-":Personal.getCorreo()%>" tabindex="6"> 
				            	</td>
				            	<td>
				            		<strong><fmt:message key="aca.Transporte"/>:</strong>
				            	</td>
				            	<td>
				            		<select id="transporte" name="transporte" tabindex="22">
				            			<option value="R"<%=Personal.getTransporte().equals("R")?" Selected":"" %>><fmt:message key="aca.Auto"/></option>
				            			<option value="V"<%=Personal.getTransporte().equals("V")?" Selected":"" %>><fmt:message key="aca.Caminando"/></option>
				            		</select>
				            	</td>
			          		</tr>
			          		<tr>
				            	<td colspan="4" style="text-align:center;"><fmt:message key="aca.${resultado}" /></td>
				          	</tr>
				          	<tr>
				            	<td colspan="4" style="text-align:center;">
								<%	if( existeAlumno ){%>
				              			<button class="btn btn-primary"  id="modificar" onclick="javascript:Modificar()" style="cursor:pointer" tabindex="23"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar"/></button>
				              			<button class="btn btn-primary"  id="borrar" onclick="javascript:Borrar()" style="cursor:pointer"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar"/></button> 
								<%	}%>
				            	</td>
				          	</tr>
       					</table>
					</td>
				</tr>
			</table>
		</form>
		</div>
	</body>
<%		}		
	}	
%>
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FNacimiento').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>