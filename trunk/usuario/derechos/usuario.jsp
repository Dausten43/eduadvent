<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file="../../seguro.jsp"%>

<%@ page import= "java.security.MessageDigest" %>
<%@ page import= "sun.misc.BASE64Encoder"%>
<%@page import="aca.catalogo.CatEscuela"%>

<jsp:useBean id="usuarioLogin" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioMenuLista" scope="page" class="aca.usuario.UsuarioMenuLista"/>
<jsp:useBean id="EscuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>

<jsp:useBean id="Modulo" scope="page" class="aca.menu.Modulo"/>
<jsp:useBean id="ModuloOpcion" scope="page" class="aca.menu.ModuloOpcion"/>

<%
	String strCodigo		= (String)session.getAttribute("codigoId");
	String strCodigoId 		= (String)session.getAttribute("codigoReciente");
	
	String tipo				= "";
	String tipoId			= "";
	String nombreUsuario 	= "";
	String nombreModulo		= "";
	String nombreOpcion		= "";
	String temp				= "";
	String respuesta		= "";
	
	boolean existeUsuario	= false;
	
	usuarioLogin.setCodigoId(strCodigo);
	if (usuarioLogin.existeReg(conElias)){
		usuarioLogin.mapeaRegId(conElias, strCodigo);
	}
	
	usuario.setCodigoId(strCodigoId);
	if (usuario.existeReg(conElias)){		
		existeUsuario = true;
		usuario.mapeaRegId(conElias, strCodigoId);
		tipo = aca.usuario.UsuarioTipo.getTipoNombre(conElias, Integer.parseInt(usuario.getTipoId() ) );
	}else{		
		if (strCodigoId.substring(3,4).equals("E"))
			tipo = "EMPLEADO";
		else if (strCodigoId.substring(3,4).equals("P"))
			tipo = "PADRE";
		else
			tipo = "ALUMNO";		
	}	
	
	if (tipo.equals("ALUMNO")){ 
		tipoId = "1";
		nombreUsuario = aca.alumno.AlumPersonal.getNombre(conElias, strCodigoId,"NOMBRE");
	}else{
		if (tipo.equals("EMPLEADO")) tipoId = "2"; else tipoId = "3"; 
		nombreUsuario = aca.empleado.EmpPersonal.getNombre(conElias, strCodigoId,"NOMBRE");
	}	
	// Graba los datos iniciales del usuario cuando no existe
	if ( existeUsuario==false ){
		usuario.setClave(strCodigoId);
		usuario.setAdministrador("N");
		usuario.setContable("N");
		usuario.setCotejador("N");
		usuario.setEscuela( "-"+String.valueOf( strCodigoId.substring(0,3))+"-");
		usuario.setPlan("N");
		usuario.setCuenta(strCodigoId);
		usuario.setTipoId(tipoId);
		usuario.setNivel("-");
		usuario.setAsociacion("-");
		if (usuario.insertReg(conElias)){
			conElias.commit();
			existeUsuario = true;
		}
	}else{
		//System.out.println("No grabe el usuario");
	}
	
	// Verifica si es administrador
	boolean admin = aca.usuario.Usuario.esAdministrador(conElias, strCodigo);
%>
<body>

<div id="content">

	<h2><fmt:message key="privilegios.Informacion" /></h2>
	
	<div class="alert alert-info">
		<strong><fmt:message key="aca.Codigo" />:</strong> <%=strCodigoId %>
		<strong><fmt:message key="aca.Nombre" />:</strong> <%=nombreUsuario %>
		<strong><fmt:message key="aca.Tipo" />:</strong> <%=tipo %>
	</div>
	
	<div class="row">
	  <div class="span5">
	  
	  		<h4><fmt:message key="aca.MenuUsuario" /></h4>	
	  		<%if (usuarioLogin.getAdministrador().equals("S")){ %>
	  		<div class="well">
	  			<a href="menu.jsp" class="btn btn-primary"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Editar" /></a>
	  		</div>
	  		<%} %>          
			        
			<%
				ArrayList ListMenuUsuario = new ArrayList();
				ListMenuUsuario = usuarioMenuLista.getListUsuario(conElias, strCodigoId, " ORDER BY 2");
				
				temp = "x";
				for (int i=0;i<ListMenuUsuario.size();i++){
					aca.usuario.UsuarioMenu userMenu = (aca.usuario.UsuarioMenu) ListMenuUsuario.get(i);
					nombreModulo 	= Modulo.getModuloNombre(conElias, Integer.parseInt( userMenu.getOpcionId()) );
					nombreOpcion 	= ModuloOpcion.getOpcionNombre(conElias,userMenu.getOpcionId());		
					if (!temp.equals(nombreModulo)){ 
						temp = nombreModulo;
						
						if(i>0)out.print("</table></div>");
			%>
						
					  <div class="alert alert-info" style="background:white;">
					  
					  	<h5><%=nombreModulo%></h5>
					  	
					  	<table class="table table-condensed">
					  	
					    
			<%		} %>
					  <tr>
					    <td width="2%"><i class="icon-bookmark"></i></td>
					    <td width="59%" align="left"><%=nombreOpcion%></td>
					  </tr>
			<%	}%>
			 </table>
		  	</div>
		  	
	  </div>
	  <div class="span5">
	  
		  	<h4><fmt:message key="aca.PrivilegiosInformacion" /></h4>	
		  	<%if (admin){ %>
		  		<div class="well">
		  			<a href="perfil.jsp?NombreUsuario=<%=nombreUsuario%>" class="btn btn-primary"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Editar" /></a>
		  		</div>
		  	<%} %>    
			
			<div class="alert alert-info" style="background:white;">
					  
					  	<h5><fmt:message key="aca.Privilegios" /></h5>
					  	
					  	<table class="table table-condensed">
					  		
					  		<tr>
					  			<td><fmt:message key="aca.EsAdministrador" /></td>
					  			<td><%=usuario.getAdministrador().equals("S")?"Si":"No" %></td>
					  		</tr>
					  		<tr>
					  			<td><fmt:message key="aca.Cotejador" /></td>
					  			<td><%=usuario.getCotejador().equals("S")?"Si":"No" %></td>
					  		</tr>
					  		<tr>
					  			<td><fmt:message key="aca.EsUsuarioContable" /></td>
					  			<td><%=usuario.getContable().equals("S")?"Si":"No" %></td>
					  		</tr>
					  	
					  	</table>
					  	
			</div>
			
			
			<div class="alert alert-info" style="background:white;">
					<h5><fmt:message key="catalogo.Niveles" /></h5>
					
					<table class="table table-condensed">
				                     	
				<%
						if (existeUsuario){		
							String escuelaUsuarioId = aca.usuario.Usuario.getEscuelaUsuario(conElias, strCodigoId, String.valueOf(aca.usuario.Usuario.getTipo(conElias, strCodigoId)));			
							if(usuario.getNivel()!=null){
								String [] niveles = usuario.getNivel().split("-");
								String nivel = "";
								for(int i=0; i<niveles.length; i++){
									if(niveles[i].equals("1"))nivel="Preescolar";
									if(niveles[i].equals("2"))nivel="Primaria";
									if(niveles[i].equals("3"))nivel="Secundaria";
									if(niveles[i].equals("4"))nivel="Preparatoria";
									if(!niveles[i].equals("")){
										pageContext.setAttribute("nivel",nivel);
					%>			
									<tr>
									  <td width="10%" >
									  	<%=niveles[i]%>
									  </td>	  
									  <td>
									    <%=nivel%>
									    <label><fmt:message key="aca.${nivel}" /></label>
									  </td>
									</tr>
					<%			
									}
								}
							}
						}		
				%> 		  
			 		</table>
			  </div>
			
			  
	  </div>
	</div>
	
   
    
    

</div>

</body>
<%@ include file= "../../cierra_elias.jsp" %>