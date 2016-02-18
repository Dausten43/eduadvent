<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file="../../seguro.jsp"%>

<%@ page import= "java.security.MessageDigest" %>
<%@ page import= "sun.misc.BASE64Encoder"%>
<%@ page import="aca.catalogo.CatEscuela"%>

<jsp:useBean id="UsuarioLogin" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="Usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="UsuarioMenu" scope="page" class="aca.usuario.UsuarioMenu"/>
<jsp:useBean id="UsuarioMenuLista" scope="page" class="aca.usuario.UsuarioMenuLista"/>
<jsp:useBean id="EscuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>

<jsp:useBean id="Modulo" scope="page" class="aca.menu.Modulo"/>
<jsp:useBean id="ModuloOpcion" scope="page" class="aca.menu.ModuloOpcion"/>
<jsp:useBean id="RolL" scope="page" class="aca.rol.RolLista"/>
<jsp:useBean id="RolOpcionL" scope="page" class="aca.rol.RolOpcionLista"/>

<%
	String strCodigo		= (String)session.getAttribute("codigoId");
	String strCodigoId 		= (String)session.getAttribute("codigoReciente");
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion"); 
	
	String tipo				= "";
	String tipoId			= "";
	String nombreUsuario 	= "";
	String nombreModulo		= "";
	String nombreOpcion		= "";
	String temp				= "";
	String respuesta		= "";
	
	boolean existeUsuario	= false;
	
	UsuarioLogin.setCodigoId(strCodigo);
	if (UsuarioLogin.existeReg(conElias)){
		UsuarioLogin.mapeaRegId(conElias, strCodigo);
	}
	
	Usuario.setCodigoId(strCodigoId);
	if (Usuario.existeReg(conElias)){		
		existeUsuario = true;
		Usuario.mapeaRegId(conElias, strCodigoId);
		tipo = aca.usuario.UsuarioTipo.getTipoNombre(conElias, Integer.parseInt(Usuario.getTipoId() ) );
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
		Usuario.setClave(strCodigoId);
		Usuario.setAdministrador("N");
		Usuario.setContable("N");
		Usuario.setCotejador("N");
		Usuario.setEscuela( "-"+String.valueOf( strCodigoId.substring(0,3))+"-");
		Usuario.setPlan("N");
		Usuario.setCuenta(strCodigoId);
		Usuario.setTipoId(tipoId);
		Usuario.setNivel("-");
		Usuario.setAsociacion("-");
		if (Usuario.insertReg(conElias)){		
			existeUsuario = true;
		}
	}else{
		//System.out.println("No grabe el usuario");
	}
	
	// Aplicar el rol para el usuario
	if (accion.equals("1")){
		// obtener las opciones del rol		
		String rolId = request.getParameter("Rol")==null?"0":request.getParameter("Rol");
		ArrayList<aca.rol.RolOpcion> lisRolOpcion 		= RolOpcionL.getList(conElias, rolId, " ORDER BY 1");

		conElias.setAutoCommit(false);
		for (aca.rol.RolOpcion opcion : lisRolOpcion){
			UsuarioMenu.setCodigoId(strCodigoId);
			UsuarioMenu.setOpcionId(opcion.getopcionId());
			if (!UsuarioMenu.existeReg(conElias)){

				if (UsuarioMenu.insertReg(conElias))
					conElias.commit();
			}		
		}
		conElias.setAutoCommit(true);
	}
	
	// Eliminar el rol para el usuario
		if (accion.equals("2")){
			// obtener las opciones del rol		
			String rolId = request.getParameter("Rol")==null?"0":request.getParameter("Rol");
			ArrayList<aca.rol.RolOpcion> lisRolOpcion 		= RolOpcionL.getList(conElias, rolId, " ORDER BY 1");

			conElias.setAutoCommit(false);
			for (aca.rol.RolOpcion opcion : lisRolOpcion){
				UsuarioMenu.setCodigoId(strCodigoId);
				UsuarioMenu.setOpcionId(opcion.getopcionId());
				if (UsuarioMenu.existeReg(conElias)){

					if (UsuarioMenu.deleteReg(conElias))
						conElias.commit();
				}		
			}
			conElias.setAutoCommit(true);
		}
	
	// Verifica si es administrador
	boolean admin = aca.usuario.Usuario.esAdministrador(conElias, strCodigo);
	
	ArrayList<aca.rol.Rol> lisRoles 		= RolL.getListAll(conElias, " ORDER BY 1");
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
	  		<%if (UsuarioLogin.getAdministrador().equals("S")){ %>
	  		<form action="usuario.jsp" id="frmRol" name="frmRol" method="post">
	  		<input name="Accion" id="Accion" type="hidden"/>
	  		<div class="well">
	  			<a href="menu.jsp" class="btn btn-primary"><i class="icon-pencil icon-white"></i> <fmt:message key="boton.Editar" /></a>
	  			&nbsp;&nbsp;&nbsp;
	  			Rol:
	  			<select name="Rol" class="input input-medium">
<%
			for (aca.rol.Rol rol : lisRoles){
%>
					<option value="<%=rol.getRolId()%>"><%=rol.getRolNombre()%></option>				
<%					
			}
%>	  			
	  			</select>&nbsp;
	  			<a href="javascript:Aplicar()" class="btn btn-success" title="Guardar"><i class="icon-plus-sign icon-white"></i></a>
	  			<a href="javascript:Eliminar()" class="btn btn-danger" title="Borrar"><i class="icon-trash icon-white"></i></a>
	  		</div>
	  		</form>
	  		<%} %>          
			        
			<%
				ArrayList<aca.usuario.UsuarioMenu> ListMenuUsuario = UsuarioMenuLista.getListUsuario(conElias, strCodigoId, " ORDER BY 2");
				
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
						<td><%=Usuario.getAdministrador().equals("S")?"Si":"No" %></td>
					</tr>
					<tr>
						<td><fmt:message key="aca.Cotejador" /></td>
						<td><%=Usuario.getCotejador().equals("S")?"Si":"No" %></td>
					</tr>
					<tr>
						<td><fmt:message key="aca.EsUsuarioContable" /></td>
						<td><%=Usuario.getContable().equals("S")?"Si":"No" %></td>
					</tr>
				</table>					  	
			</div>			
			
			<div class="alert alert-info" style="background:white;">
				<h5><fmt:message key="catalogo.Niveles" /></h5>
				
				<table class="table table-condensed">
				                     	
				<%
						if (existeUsuario){		
							String escuelaUsuarioId = aca.usuario.Usuario.getEscuelaUsuario(conElias, strCodigoId, String.valueOf(aca.usuario.Usuario.getTipo(conElias, strCodigoId)));			
							if(Usuario.getNivel()!=null){
								String [] niveles = Usuario.getNivel().split("-");
								String nivel = "";
								for(int i=0; i<niveles.length; i++){
									if(niveles[i].equals("0"))nivel="Maternal";
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
<script>
    function Aplicar(){
    	document.frmRol.Accion.value = "1";
    	document.frmRol.submit();
    }
    
    function Eliminar(){
    	document.frmRol.Accion.value = "2";
    	document.frmRol.submit();
    }
</script>

</body>
<%@ include file= "../../cierra_elias.jsp" %>