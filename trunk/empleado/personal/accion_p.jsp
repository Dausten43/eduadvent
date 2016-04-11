<%@ include file= "../../con_elias.jsp" %>
<% String idJsp = "0";%>

<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.alumno.AlumPadres"%>
<%@page import="aca.empleado.EmpTipo"%>
<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="empTipo" scope="page" class="aca.empleado.EmpTipo"/>
<jsp:useBean id="empTipoLista" scope="page" class="aca.empleado.EmpTipoLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioMenu" scope="page" class="aca.usuario.UsuarioMenu"/>
<%!
	private String getRandomString(){
        String alphaNum="1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        StringBuffer sbRan = new StringBuffer(11);
        int num;
        for(int i = 0; i < 11; i++){
          num = (int)(Math.random()* (alphaNum.length() - 1));
          sbRan.append(alphaNum.substring(num, num+1));
        }
        return sbRan.toString();
   }
%>
<head>
	<link href="../../css/academico.css" rel="STYLESHEET" type="text/css">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="STYLESHEET" type="text/css">
<%
	//Declaracion de variables	
	
	String escuela 		= (String)session.getAttribute("escuela");

	String strCodigo 	= request.getParameter("CodigoEmpleado");
	String strTipo 		= request.getParameter("tipo");
	String strAccion 	= request.getParameter("Accion");
	String vref			= request.getParameter("ref");	
	
	if (vref==null)vref	= "0";
	
	if (strAccion == null) strAccion = "5";
	int nAccion			= Integer.parseInt(strAccion);
	int i 				= 0;
	String sResultado	= "";
	ArrayList listor		= new ArrayList();
	ArrayList lisPais		= new ArrayList();
	
	String clave 		= "";
	String codPers		= "";
	boolean existe 		= false;
%>
	<script>
		
		function Nuevo(){	
			document.frmPersonal.Accion.value			="1";
			document.frmPersonal.Nombre.value 			= "";
			document.frmPersonal.ApellidoPaterno.value 	= "";
			document.frmPersonal.ApellidoMaterno.value 	= "";
			document.frmPersonal.FNacimiento.value		= "";
			document.frmPersonal.Sexo.value				= "M";
			document.frmPersonal.Telefono.value			= "1";
			document.frmPersonal.Email.value			= "1";
			document.frmPersonal.PaisId.value			= "135";
			document.frmPersonal.EstadoId.value			= "19";
			document.frmPersonal.CiudadId.value			= "1";
			document.frmPersonal.Colonia.value			= "x";
			document.frmPersonal.Direccion.value		= "";
			document.frmPersonal.Estado.value			= "A";
			document.frmPersonal.Rfc.value				= "";
			document.frmPersonal.Ssocial.value			= "";			
			document.frmPersonal.submit();		
		}
		
		function Grabar(){
			if(document.frmPersonal.CodigoEmpleado.value!="" && document.frmPersonal.Nombre!=""
				&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
				&& document.frmPersonal.FNacimiento.value!="" && document.frmPersonal.Sexo.value!="" && document.frmPersonal.Rfc.value!="" && document.frmPersonal.Ssocial.value!="" ){
				document.frmPersonal.Accion.value	="2";
				document.frmPersonal.tipo.value		= "Nuevo";			
				document.frmPersonal.submit();			
			}else{
				alert("<fmt:message key="js.CompletaCamposAsterisco" />");
			}
		}
		
		function Modificar(){
			document.frmPersonal.Accion.value="3";
			document.frmPersonal.submit();
		}
		
		function Borrar( ){
			if(document.frmPersonal.CodigoEmpleado.value!=""){
				if(confirm("<fmt:message key="aca.EliminarRegistro" />")){
		  			document.frmPersonal.Accion.value="4";
					document.frmPersonal.submit();
				}
			}else{
				alert("<fmt:message key="js.EscribaClave" />");
				document.frmPersonal.CodigoEmpleado.focus();
		  	}
		}
		
		function Consultar(){
			document.frmPersonal.Accion.value = "5";
			document.frmPersonal.submit();		
		}
		
		function PEC( Pec, tipo){		
			document.frmPersonal.Accion.value="6";
			document.frmPersonal.tipo.value = tipo;
			document.frmPersonal.Pec.value 	= Pec;
			if (document.frmPersonal.Pec.value=="1")
				document.frmPersonal.EstadoId.value 	= "0";
			document.frmPersonal.submit();
		}
		
		function agregaHijo(){
			document.location.href = "accion_p.jsp?tipo=Padre&ref=0&Accion=7&CodigoEmpleado=<%=strCodigo %>&hijo="+document.getElementById("hijo").value;
		}
		
		function eliminaHijo(codigoId){
			if(confirm("<fmt:message key="js.ConfirmaRelacionPadreHijo" />"+codigoId+"?"))
				document.location.href = "accion_p.jsp?tipo=Padre&ref=0&Accion=8&CodigoEmpleado=<%=strCodigo %>&hijo="+codigoId;
		}
		
	</script>
	
</head>
<% 
	Personal.setCodigoId(strCodigo);

	// Operaciones a realizar en la pantalla
	switch (nAccion){
		case 1: { // Nuevo
			sResultado = "LlenarFormulario";
				if (strCodigo.substring(3,4).equals("E")) 
					Personal.setCodigoId(Personal.maximoRegEmp(conElias,escuela));
				if (strCodigo.substring(3,4).equals("P")) 
					Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setEstado(request.getParameter("Estado"));
			Personal.setTipoId(request.getParameter("tipoId"));
			Personal.setRfc(request.getParameter("Rfc"));
			Personal.setSsocial(request.getParameter("Ssocial"));
			strTipo = "Nuevo";
%>
	<script type="text/javascript">
		parent.document.getElementById("CodigoEmpleado").value = "<%=Personal.maximoRegEmp(conElias,escuela) %>";
	</script>
<%
			break;
		}		
		case 2: { // Grabar
				if (strCodigo.substring(3,4).equals("E")) 
			Personal.setCodigoId(Personal.maximoRegEmp(conElias,escuela));
				if (strCodigo.substring(3,4).equals("P")) 
			Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setTipoId(request.getParameter("tipoId"));
			Personal.setRfc(request.getParameter("Rfc"));
			Personal.setSsocial(request.getParameter("Ssocial"));
			//Personal.setEstado("A");			
			Personal.setEstado(request.getParameter("Estado"));
			
			
			if (strCodigo.substring(3,4).equals("E")){ 		
				if (Personal.existeReg(conElias) == false){				
					if (Personal.insertReg(conElias)){							
						session.setAttribute("codigoEmpleado", Personal.getCodigoId());
						Personal.mapeaRegId(conElias, strCodigo);
						sResultado = "Grabado";
						conElias.commit();
					}else{
							sResultado = "NoGrabo";
					}
				}else{
					sResultado = "Existe";
				}			
				break;
			}
			
			if(strCodigo.substring(3,4).equals("P")){
				if (Personal.existeReg(conElias) == false){							
					if (Personal.insertReg(conElias)){							
						session.setAttribute("codigoPadre", Personal.getCodigoId());
						Personal.mapeaRegId(conElias, strCodigo);
						sResultado = "Grabado";
						conElias.commit();
					}else{
						sResultado = "NoGrabo";
					}
				}else{
					sResultado = "Existe";
				}			
				break;
			}
		}
		case 3: { // Modificar
			
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setTipoId(request.getParameter("tipoId"));
			Personal.setRfc(request.getParameter("Rfc"));
			Personal.setSsocial(request.getParameter("Ssocial"));
			//Personal.setEstado("A");
			Personal.setEstado(request.getParameter("Estado"));

			
			if (Personal.existeReg(conElias)){
				if (Personal.updateReg(conElias)){
					Personal.mapeaRegId(conElias, strCodigo);
					sResultado = "Modificado";
					conElias.commit();
				}else{
					sResultado = "NoCambio";
				}
			}else{
				sResultado = "NoExiste";
			}
			
			break;
		}
		case 4: { // Borrar
			if (Personal.existeReg(conElias) == true){
				if(!cicloGrupoCurso.existeMaestro(conElias, strCodigo)){ //Si el maestro no tiene materias asignadas puede borrar
					conElias.setAutoCommit(false);
					if (Personal.deleteReg(conElias)){
						usuario.setCodigoId(strCodigo);
						usuario.setCodigoId(strCodigo);
						usuarioMenu.setCodigoId(strCodigo);
						if(usuario.deleteReg(conElias) && usuarioMenu.deleteAllReg(conElias) && usuario.deleteReg(conElias)){
							sResultado = "Eliminado";
							conElias.commit();
						}else{
							conElias.rollback();
							sResultado = "NoBorro";
						}
					}else{
						sResultado = "NoBorro";
					}
					conElias.setAutoCommit(true);
				}else{// Si el maestro si tiene materias solo se despliega el mensaje diciendo esto
					sResultado = "NoBorroMateriasAsignadas";
				}
			}else{
				sResultado = "NoExiste";
			}
			break;
		}
		case 5: { // Consultar
			if (Personal.existeReg(conElias) == true){
				Personal.mapeaRegId(conElias, strCodigo);
				sResultado = "Consulta";
				strTipo = "Consulta";
			}else{
				sResultado = "NoExiste";
				strTipo = "Nuevo";
			}	
			break;
		}
		case 6: { // Refrescar combos PEC
			if (strTipo.equals("Nuevo"))
				if (strCodigo.substring(3,4).equals("E")) 
					Personal.setCodigoId(Personal.maximoRegEmp(conElias,escuela));
				if (strCodigo.substring(3,4).equals("P")) 
					Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));
			Personal.setEscuelaId(escuela);
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setFNacimiento(request.getParameter("FNacimiento"));
			Personal.setPaisId(request.getParameter("PaisId"));
			Personal.setEstadoId(request.getParameter("EstadoId"));
			Personal.setCiudadId(request.getParameter("CiudadId"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setTipoId(request.getParameter("tipoId"));
			Personal.setEstado("A");
			sResultado = "LlenarFormulario"; 
		}break;
		case 7: { // Guardar Hijo
			String hijo = request.getParameter("hijo");

			if (Personal.existeReg(conElias) == true){
				Personal.mapeaRegId(conElias, strCodigo);
				sResultado = "Consulta";
				strTipo = "Consulta";
			}else{
				sResultado = "NoExiste";
				strTipo = "Nuevo";
			}
			alumPadres.setCodigoId(hijo);
			if(alumPadres.existeReg(conElias)){
				sResultado = "AlumnoYaTienePadre";
			}else{
				alumPadres.setCodigoPadre(strCodigo);
				if(alumPadres.insertReg(conElias)){
					sResultado = "AlumnoGuardadoCorrectamente";
				}else{
					sResultado = "ErrorGuardadoAlumno";
				}
			}
		}break;
		case 8: { //Elimina Hijo
			String hijo = request.getParameter("hijo");

			if (Personal.existeReg(conElias) == true){
				Personal.mapeaRegId(conElias, strCodigo);
				sResultado = "Consulta";
				strTipo = "Consulta";
			}else{
				sResultado = "NoExiste";
				strTipo = "Nuevo";
			}
			alumPadres.setCodigoId(hijo);
			if(alumPadres.existeReg(conElias)){
				if(alumPadres.deleteReg(conElias)){
					sResultado = "AlumnoFueBorradoExactamente";
				}else{
					sResultado = "ErrorAlBorrarAlumno";
				}
			}else{
				sResultado = "NoExisteRelacion";
			}
		}
	}
	session.setAttribute("emp",Personal.getCodigoId());
	pageContext.setAttribute("sResultado", sResultado);
	if(Personal.existeReg(conElias) || nAccion == 1 || nAccion == 2 || nAccion == 3){
%>
<head>
<script type="text/javascript">
	function credencial(){
		abrirVentana("credencial",405,285,0,0,"no","yes","no","no","no","credencial.jsp");
	}
		
	function camara(){
		location.href="tomarfoto.jsp";
	}
	
	/*function camara(){
		abrirVentana("camara",370,540,0,0,"no","yes","no","no","no","camara.jsp");
	}*/
		
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
		location.href="accion_p.jsp?x=<%=getRandomString()%>&CodigoEmpleado=<%=strCodigo%>";
	}
	
	function inicio(){
		v = window.open("","camara");
		if (v.location.href=="about:blank")	v.close();
		else v.setMatricula('<%=strCodigo%>');
	}
</script>
</head>
<body>
<form action="accion_p.jsp" method="post" name="frmPersonal" target="_self">
<input type="hidden" name="Accion">
<input type="hidden" name="Pec">
<input type="hidden" name="tipo" value="<%=strTipo%>">
<table width="70%" class="table table-fullcondensed table-nohover" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
  <tr>
  	<th align="center"><font size="2"><fmt:message key="empleados.DatosPersonalesMin" /></font></th>
  </tr>
  <tr>
    <td>
	  <table width="100%" border="0">
          <tr> 
            <td colspan='2' rowspan='8' align='center'>
              <img src="imagen.jsp?id=<%=new java.util.Date().getTime()%>" width="140">
              <a href="javascript:camara()" title="Tomar la Foto"><img src='../../imagenes/camaraweb.jpg' width="20" border="0"></a>&nbsp;
              <a href="subir.jsp" title="Subir Foto de un archivo"><img src='../../imagenes/upload.jpg' width="30" border="0"></a>
            <!--  <input name="button" type='button' onclick='camara()' value='  Abrir Camara  '> -->              
            </td>
            <td width="14%" height="26"><strong> <fmt:message key="aca.Genero" />:</strong></td>
            <td width="44%"> <select name="Sexo" id="Sexo">
                <% if(Personal.getGenero().equals("M")){%>
                <option value='M' selected><fmt:message key="aca.Hombre" /></option>
                <option value='F' ><fmt:message key="aca.Mujer" /></option>
                <%}else{%>
                <option value='M'><fmt:message key="aca.Hombre" /></option>
                <option value='F' selected><fmt:message key="aca.Mujer" /></option>
                <%} %>
              </select></td>
          </tr>
          <tr> 
            <td><strong> <fmt:message key="aca.FNacimiento" />:</strong></td>
            <td><input name="FNacimiento" type="text" id="FNacimiento" size="10" maxlength="10" value="<%=Personal.getFNacimiento()%>"> DD/MM/AAAA </td>
          </tr>
          <tr> 
            <td><strong><fmt:message key="aca.Pais" />:</strong></td>
            <td> <select name="PaisId" id="PaisId" onchange = "PEC('1','<%=strTipo%>')">
                <%			  	
				aca.catalogo.CatPaisLista paisL = new aca.catalogo.CatPaisLista();
				lisPais = paisL.getListAll(conElias,"ORDER BY 2");
				for( i=0;i<lisPais.size();i++){
					aca.catalogo.CatPais pais = (aca.catalogo.CatPais) lisPais.get(i);
					if (pais.getPaisId().equals(Personal.getPaisId())){
						out.print(" <option value='"+pais.getPaisId()+"' Selected>"+ pais.getPaisNombre()+"</option>");
					}else{
						out.print(" <option value='"+pais.getPaisId()+"'>"+ pais.getPaisNombre()+"</option>");
					}				
				}				
				paisL	= null;
			  %>
              </select> </td>
          </tr>
          <tr> 
            <td><strong> <fmt:message key="aca.Estado" />:</strong></td>
            <td> <select name="EstadoId" id="EstadoId"  onChange= "javascript:PEC('2','<%=strTipo%>')">
<%
				aca.catalogo.CatEstadoLista estadoL = new aca.catalogo.CatEstadoLista();
				listor = estadoL.getArrayList(conElias, Personal.getPaisId(), "ORDER BY 1,3");
				for( i=0;i<listor.size();i++){
					aca.catalogo.CatEstado estado = (aca.catalogo.CatEstado) listor.get(i);
					if (estado.getEstadoId().equals(Personal.getEstadoId())){
						out.print(" <option value='"+estado.getEstadoId()+"' Selected>"+ estado.getEstadoNombre()+"</option>");
					}else{
						out.print(" <option value='"+estado.getEstadoId()+"'>"+ estado.getEstadoNombre()+"</option>");
					}
				}
				listor 		= null;
				//pais	= null;
				estadoL	= null;
			  %>
              </select></td>
          </tr>
          <tr> 
            <td><strong> <fmt:message key="aca.Ciudad" />:</strong></td>
            <td> <select name="CiudadId" id="CiudadId">
<%
				aca.catalogo.CatCiudadLista ciudadL = new aca.catalogo.CatCiudadLista();
				listor = ciudadL.getArrayList(conElias, Personal.getPaisId(), Personal.getEstadoId(), "ORDER BY 4");
				for( i=0;i<listor.size();i++){
					aca.catalogo.CatCiudad ciudad = (aca.catalogo.CatCiudad) listor.get(i);
					if (ciudad.getCiudadId().equals(Personal.getCiudadId())){
						out.print(" <option value='"+ciudad.getCiudadId()+"' Selected>"+ ciudad.getCiudadNombre()+"</option>");
					}else{
						out.print(" <option value='"+ciudad.getCiudadId()+"'>"+ ciudad.getCiudadNombre()+"</option>");
					}
				}
				listor 		= null;
				ciudadL	= null;
			  %>
              </select> </td>
          </tr>
          <tr> 
            <td><strong><fmt:message key="aca.Colonia" />: </strong></td>
            <td><input type="text" name="Colonia" id="Colonia" size="20" maxlength="20" value="<%=Personal.getColonia()%>"></td>
          </tr>
          <tr> 
            <td><strong><fmt:message key="aca.Direccion" />:</strong></td>
            <td><input name="Direccion" type="text" id="Direccion" size="40" maxlength="50" value="<%=Personal.getDireccion()%>"></td>
          </tr>
          <tr> 
            <td><strong><fmt:message key="aca.Telefono" />:</strong></td>
            <td><input name="Telefono" type="text" id="Telefono" size="30" maxlength="30" value="<%=Personal.getTelefono()%>"></td>
          </tr>
          <tr> 
            <td width="14%"><strong><fmt:message key="aca.Clave" />:<b><font color="#AE2113"> *</font></b></strong></td>
            <td width="28%"> <input name="CodigoEmpleado" type="text" value="<%=Personal.getCodigoId()%>"></td>
            <td><strong><fmt:message key="aca.Email" />:</strong></td>
            <td><input name="Email" type="text" id="Email" size="40" maxlength="50" value="<%=Personal.getEmail()%>"></td>
          </tr>
          <tr> 
            <td height="27"><strong><fmt:message key="aca.Nombre" />:<b><font color="#AE2113"> *</font></b></strong></td>
            <td><input name="Nombre" type="text" id="Nombre" size="20" maxlength="40" value="<%=Personal.getNombre()%>"></td>
            <td><strong><fmt:message key="aca.Estado" />:</strong></td>
            <td><select name="Estado" id="Estado">
                <% if(Personal.getEstado().equals("A")){%>
                <option value='A' selected>Activo</option>
                <option value='I' >Inactivo</option>
                <%}else{%>
                <option value='A'>Activo</option>
                <option value='I' selected>Inactivo</option>
                <%} %>
              </select></td>
          </tr>
          <tr> 
            <td height="28"><strong><fmt:message key="aca.APaterno" />:<b><font color="#AE2113"> *</font></b></strong></td>
            <td><input name="ApellidoPaterno" type="text" id="ApellidoPaterno" size="20" maxlength="40" value="<%=Personal.getApaterno()%>"></td>
            <td height="27"><strong> RFC:</strong></td>
            <td><input name="Rfc" type="text" id="Rfc" size="20" maxlength="40" value="<%= Personal.getRfc()%>"></td>            
          </tr>
          <tr> 
            <td height="26"><strong><fmt:message key="aca.AMaterno" />:<b><font color="#AE2113"> *</font></b></strong></td>
            <td><input name="ApellidoMaterno" type="text" id="ApellidoMaterno" size="20" maxlength="40" value="<%=Personal.getAmaterno()%>"></td>
            <td height="27"><strong><fmt:message key="aca.SeguroSocial" />:<b><font color="#AE2113"> *</font></b></strong></td>
            <td><input name="Ssocial" type="text" id="Ssocial" size="20" maxlength="20" value="<%=Personal.getSsocial()%>"></td>
          </tr>
          <tr>
          	<td height="26"><strong><fmt:message key="aca.Tipo" /></strong></td>
          	<td>
<%
				if(!Personal.getApaterno().equals("") && Personal.getCodigoId().substring(3,4).equals("P")){
%>
				<input type="hidden" id="tipoId" name="tipoId" value="7">Padre
<%
				}else{
%>
				<select id="tipoId" name="tipoId">
<%
					// Excepto el tipo padre
					ArrayList lisTipo = empTipoLista.getListSinEsteTipo(conElias, "7","ORDER BY TIPO_ID");
					for(i = 0; i < lisTipo.size(); i++){
						empTipo = (EmpTipo) lisTipo.get(i);
%>
					<option value="<%=empTipo.getTipoId() %>" <%if(Personal.getTipoId().equals(empTipo.getTipoId())) out.print("Selected"); %>><%=empTipo.getTipoNombre() %></option>
<%
					}
%>
				</select>
<%
				}
%>
          	</td>
          </tr>
          <tr> 
            <td colspan="4" style="text-align:center;"><fmt:message key="aca.${sResultado}" /></td>
          </tr>
          <tr> 
            <td colspan="4" style="text-align:center;">              
              <% if(Personal.existeReg(conElias)== false){ %> 
              <button class="btn btn-primary" id="grabar" onclick="javascript:Grabar()" style="cursor:pointer"><i class="icon-ok icon-white"></i> Grabar</button> 
              <% }else{%>
              <button class="btn btn-primary" id="modificar" onclick="javascript:Modificar()" style="cursor:pointer"><i class="icon-edit icon-white"></i> Modificar</button>
              <% }%>
              <button class="btn btn-primary" id="borrar" onclick="javascript:Borrar()" style="cursor:pointer"><i class="icon-remove icon-white"></i> Eliminar</button>
            </td>
          </tr>
        </table>
	</td>
  </tr>
</table>
</form>
</body>
<%
	}else{
%>
	<table>
		<tr><td align="center" width="100%"><font size="5" color="red"><fmt:message key="aca.EsteEmpleadoNoExiste" /></font></td></tr>
	</table>
<%
	}
%>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FNacimiento').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>
