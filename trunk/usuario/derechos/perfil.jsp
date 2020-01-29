<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file="../../seguro.jsp"%>

<%@ page import= "java.security.MessageDigest" %>
<%@ page import= "sun.misc.BASE64Encoder"%>
<%@ page import="aca.catalogo.CatEscuela"%>

<jsp:useBean id="usuarioLogin" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="EscuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>

<script>
		function CambiarClave(){
			document.frmCuenta.Accion.value		= "1";
			document.frmCuenta.Cambiar.value 	= "si";
			document.frmCuenta.submit();
		}
		
		function GrabarClave(){
			if(document.frmCuenta.Cuenta.value!="" && document.frmCuenta.Clave.value!=""){
				document.frmCuenta.Accion.value="2";
				document.frmCuenta.submit();
			}else{
				alert(" <fmt:message key="aca.CamposRequeridos" />");
			}	
		}
		
		function GrabarPrivilegios(){
			document.frmPrivilegio.Accion.value="3";
			document.frmPrivilegio.submit();
		}

		function GrabarNivel(){
			document.nivel.Accion.value="7";
			document.nivel.submit();
		}
</script>


<% 	
	String escuela			= (String) session.getAttribute("escuela");
	String strCodigo		= (String) session.getAttribute("codigoId");
	String strCodigoId 		= (String) session.getAttribute("codigoReciente");
	
	String strAccion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String strAdmin			= request.getParameter("Admin")==null?"N":request.getParameter("Admin");
	String strCoteja		= request.getParameter("Coteja")==null?"N":request.getParameter("Coteja");
	String strContable		= request.getParameter("Contable")==null?"N":request.getParameter("Contable");
	String strDivision		= request.getParameter("Division")==null?"N":request.getParameter("Division");
	
	String strCambiar		= request.getParameter("Cambiar");
	int numAccion 			= Integer.parseInt(strAccion.equals("") ? "0" : strAccion.trim());
	
	String nombreUsuario	= "";
	String tipo				= "";
	String tipoId			= "";
	String strResultado		= "";
	String respuesta		= "";
	
	boolean existeUsuario	= false;
	
	if(strCambiar == null) strCambiar = "";	
	if(strAccion.equals("0")) strCambiar = "0";
	
	
	usuarioLogin.setCodigoId(strCodigo);
	if (usuarioLogin.existeReg(conElias)){
		usuarioLogin.mapeaRegId(conElias, strCodigo);
	}
	
	usuario.setCodigoId(strCodigoId);
	if (usuario.existeReg(conElias)){
		usuario.mapeaRegId(conElias, strCodigoId);
		tipoId = usuario.getTipoId();
		tipo = aca.usuario.UsuarioTipo.getTipoNombre(conElias,Integer.parseInt(usuario.getTipoId() ) );	
	}else{
		if (strCodigoId.substring(3,4).equals("E")){
			tipo 	= "EMPLEADO";
			tipoId	= "2";			
		}else if (strCodigoId.substring(3,4).equals("P")){
			tipo 	= "PADRE";
			tipoId	= "3";		
		}else{
			tipo = "ALUMNO";
			tipoId = "1";			
		}
	}
	
	if (tipoId.equals("2")||tipoId.equals("3")){
		nombreUsuario 	= aca.empleado.EmpPersonal.getNombre(conElias, strCodigoId,"NOMBRE");
	}else{
		nombreUsuario 	= aca.alumno.AlumPersonal.getNombre(conElias, strCodigoId,"NOMBRE");
	}
	
	switch (numAccion){
		case 2: { // Graba el password
		
			// Encriptacion de la clave
			MessageDigest md5	= MessageDigest.getInstance("MD5");
			md5.update(request.getParameter("Clave").getBytes("UTF-8"));
			byte raw[] = md5.digest();    
		 	String claveDigest	= (new BASE64Encoder()).encode(raw);		 		
		 	usuario.setCuenta(request.getParameter("Cuenta"));
			usuario.setClave(claveDigest);			
			if(!aca.usuario.Usuario.existeCuenta(conElias, usuario.getCuenta(), strCodigoId)){
				if (usuario.existeReg(conElias) == true){
					if (usuario.updateReg(conElias)){
						strResultado = "Modificado";								
					}else{
						strResultado = "NoModifico";
					}
				}else{
					usuario.setTipoId(tipoId);
					usuario.setAdministrador("N");
					usuario.setCotejador("N");
					usuario.setContable("N");
					usuario.setPlan("N");
					usuario.setEscuela("-"+escuela+"-");
					if (usuario.insertReg(conElias)){
						strResultado = "Guardado";								
					}else{
						strResultado = "NoGuardo";
					}
				}
			}else{
				out.print("<table align=\"center\"><tr><td><h3><strong >El usuario ya existe. Elija otro nombre de usuario</strong></h3></td></tr></table>");
			}
			break;
		}		
		case 3: { // Graba Privilegios de Datos
		
			usuario.setCodigoId(strCodigoId);
			usuario.setAdministrador(strAdmin);
			usuario.setCotejador(strCoteja);
			usuario.setContable(strContable);
			usuario.setEscuela(request.getParameter("Escuelas"));
			usuario.setAsociacion(request.getParameter("Asociaciones"));
			if(strCodigo.equals("B01P0002")){
				usuario.setDivision(strDivision);
			}
			
			if (usuario.existeReg(conElias) == true){
				usuario.updateRegPrivilegio(conElias);
				strResultado = "Guardado";
			} else {
				usuario.setEscuela("-0-");
				usuario.setPlan("x");
				usuario.insertReg(conElias);
				strResultado = "Registro";
			}
			break;
		}

		case 7:{ // Grabar Nivel
			String n0 = request.getParameter("Maternal")==null?"":request.getParameter("Maternal");
			String n1 = request.getParameter("Preescolar")==null?"":request.getParameter("Preescolar");
			String n2 = request.getParameter("Primaria")==null?"":request.getParameter("Primaria");
			String n3 = request.getParameter("Secundaria")==null?"":request.getParameter("Secundaria");
			String n4 = request.getParameter("Preparatoria")==null?"":request.getParameter("Preparatoria");
			
			String nivel = "";
			if(n0.equals("0"))nivel=nivel+"-"+n0;
			if(n1.equals("1"))nivel=nivel+"-"+n1;
			if(n2.equals("2"))nivel=nivel+"-"+n2;
			if(n3.equals("3"))nivel=nivel+"-"+n3;
			if(n4.equals("4"))nivel=nivel+"-"+n4;
			if(!nivel.equals(""))nivel=nivel+"-";
			
			usuario.setCodigoId(strCodigoId);
			conElias.setAutoCommit(false);
			
			if(usuario.existeReg(conElias)){
				usuario.mapeaRegId(conElias, strCodigoId);
				usuario.setNivel(nivel);
				if(usuario.updateReg(conElias)){
					conElias.commit();
					respuesta = "NivelesModificados";
				}else{
					respuesta = "ErrorNivelesModificados";
					conElias.rollback();
				}			
			}
			conElias.setAutoCommit(false);
		}break;
	}
	
	if (usuario.existeReg(conElias)){
		existeUsuario = true;
		usuario.mapeaRegId(conElias, strCodigoId);
	}
	pageContext.setAttribute("strResultado", strResultado);
	pageContext.setAttribute("respuesta", respuesta);
%>
<body>

<div id="content">
	
	<h2><fmt:message key="privilegios.PrivilegiosInformacion" /> <small><%= nombreUsuario %></small></h2>
	
<% 
	if(!strResultado.equals("")){
%> 
		<div class='alert alert-info'><fmt:message key="aca.${strResultado }" /></div>
<%
	}
%>	
<% 
	if(!respuesta.equals("")){
%> 
		<div class='alert alert-info'><fmt:message key="aca.${respuesta }" /></div>
<%
	}
%>	
	<div class="well">
		<a href="usuario.jsp?Admin=<%=strAdmin%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	
	  	
	  	<form name="frmCuenta" method="post" action="perfil.jsp">
	    	<input name="NombreUsuario" type="hidden" value="<%=nombreUsuario%>">
	    	<input name="Accion" type="hidden">
	    	<input name="Cambiar" type="hidden">
	    	
	    	
	    	<div class="alert alert-info" style="background:white;">
	    		
	    		<%// cambia la cuenta y contraseña
					if (numAccion==1){%>
	        			<strong><fmt:message key="aca.Cuenta" />:</strong> 
	        			<input name="Cuenta" type="text" id="Cuenta" value="<%=existeUsuario?usuario.getCuenta():strCodigoId%>" size="10" maxlength="20"> &nbsp;
	        			<strong><fmt:message key="aca.Clave" />:</strong> 
	        			<input name="Clave" type="password" id="Clave" value="" size="10" maxlength="20"> &nbsp;
	        			
	        			 <br />
	        			 <a onClick="GrabarClave()" class="btn btn-primary"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Grabar" /></a>
					<%	if(strCambiar.equals("si")){ %>
	        				<a onClick="href='perfil.jsp'" class="btn"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></a>
					<%	}
					}
					else{%>
				        <strong><fmt:message key="aca.Cuenta" />:</strong> 
				        <%=usuario.getCuenta() %> &nbsp; 
				        <strong><fmt:message key="aca.Clave" />:</strong>
				        <%=usuario.getClave() %>&nbsp;
				        <a class="btn btn-primary btn-mini" onClick="CambiarClave()"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Cambiar" /></a>
				<%	}%>
	    	
	    	</div>
	    	
	  	</form>
	  	
	  	
	  	
	  	<form name="frmPrivilegio" method="post" action="perfil.jsp">
	    	<input name="Accion" type="hidden">
	    	
	    	<div class="alert alert-info" style="background:white;">
	    	
		    		<p>
			      			<fmt:message key="aca.Administrador" />&nbsp;
			        		<input name="Admin" type="checkbox" value="S" <% if (usuario.getAdministrador().equals("S")) out.println("checked");%>>
		        			&nbsp;&nbsp;&nbsp; <fmt:message key="aca.Cotejador" />
					        <input name="Coteja" type="checkbox" value="S" <% if (usuario.getCotejador().equals("S")) out.println("checked");%>>
					        &nbsp;&nbsp;&nbsp; <fmt:message key="aca.Contable" />
					        <input name="Contable" type="checkbox" value="S" <% if (usuario.getContable().equals("S")) out.println("checked");%>>
					        <%
					        	if(strCodigo.equals("B01P0002")){
					        %>
					        		&nbsp;&nbsp;&nbsp; <fmt:message key="aca.Division" />
					        		<input name="Division" type="checkbox" value="S" <% if (usuario.getDivision().equals("S")) out.println("checked");%>>
					        <%
					        	}
					        %>
			      	</p>
					<p>			    		
			    			<strong><fmt:message key="aca.Asociaciones" />:</strong>
							<% 	if (aca.usuario.Usuario.esSuper(conElias, strCodigo)){ %>
									<br />
									<textarea name="Asociaciones" id="Asociaciones" style="width:500px;height:100px;"><%= usuario.getAsociacion() %></textarea>
							<% 	}else{ %>
									<input name="Asociaciones" type="hidden" id="Asociaciones" value="<%= usuario.getAsociacion() %>">
							<% 	}%>
			    	</p>
			    	<p>
			    			<strong><fmt:message key="aca.Escuelas" />:</strong>
						<% 	if (aca.usuario.Usuario.esSuper(conElias, usuarioLogin.getCodigoId())){ %>
								<br />
								<textarea name="Escuelas" id="Escuelas" style="width:500px;height:100px;"><%= usuario.getEscuela() %></textarea>
						<% 	}else{ %>
								<input name="Escuelas" type="hidden" id="Escuelas" value="<%= usuario.getEscuela() %>">
						<% 	}%>
			    	</p>
		    
		    	<a onClick="GrabarPrivilegios()" class="btn btn-primary"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Grabar" /></a>
		    	
	    	</div>
	  	</form>
		
		<form name="nivel" method="post" action="perfil.jsp">
		<div class="alert alert-info" style="background:white;">
			<h5><fmt:message key="catalogo.Niveles" /></h5>
		
	    	<input name="Accion" type="hidden">
		<%	
			String [] niveles = (usuario.getNivel()==null?"-":usuario.getNivel()).split("-");
			boolean nivel0 = false;
			boolean nivel1 = false;
			boolean nivel2 = false;
			boolean nivel3 = false;
			boolean nivel4 = false;
			
			for(int i=0; i<niveles.length; i++){
				if(niveles[i].equals("0"))nivel0=true;
				if(niveles[i].equals("1"))nivel1=true;
				if(niveles[i].equals("2"))nivel2=true;
				if(niveles[i].equals("3"))nivel3=true;
				if(niveles[i].equals("4"))nivel4=true;
			}
		%>
		    		<fmt:message key="aca.Nivel" /> 0&nbsp;<input name="Maternal" type="checkbox" value="0" <% if (nivel0) out.println("checked");%>>&nbsp;&nbsp;&nbsp;
			        <fmt:message key="aca.Nivel" /> 1&nbsp;<input name="Preescolar" type="checkbox" value="1" <% if (nivel1) out.println("checked");%>>&nbsp;&nbsp;&nbsp;
			     	<fmt:message key="aca.Nivel" /> 2&nbsp;<input name="Primaria" type="checkbox" value="2" <% if (nivel2) out.println("checked");%>>&nbsp;&nbsp;&nbsp; 
			     	<fmt:message key="aca.Nivel" /> 3&nbsp;<input name="Secundaria" type="checkbox" value="3" <% if (nivel3) out.println("checked");%>>&nbsp;&nbsp;&nbsp;
			     	<fmt:message key="aca.Nivel" /> 4&nbsp;<input name="Preparatoria" type="checkbox" value="4" <% if (nivel4) out.println("checked");%>>&nbsp;&nbsp;&nbsp;
					<br />
					&nbsp;
					<br />
			     	<a onClick="GrabarNivel()" class="btn btn-primary"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Grabar" /></a>
		
		</div>
		
		</form>


</div>	



<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Asociaciones').maxlength({ 
	    max: 300
	});
	
	$('#Escuelas').maxlength({ 
	    max: 1500
	});
		
</script>

<%@ include file= "../../cierra_elias.jsp" %>