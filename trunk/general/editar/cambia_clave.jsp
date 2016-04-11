<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "aca.menu.*"%>
<%@ page import= "sun.misc.BASE64Encoder"%>
<%@ page import= "java.security.MessageDigest" %>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>

<% 
	String codigoId			= (String) session.getAttribute("codigoId");
	String accion 			= request.getParameter("Accion");
	String strModulob		= request.getParameter("moduloId")==null?"":request.getParameter("moduloId");
	String noMuestres 		= request.getParameter("noMuestres");
	String strCarpetab		= request.getParameter("carpeta");
	String salto			= "X";
	
	ModuloOpcion opcionb 	= new ModuloOpcion();
	Modulo modulob 			= new Modulo();
	
	opcionb.mapeaRegId(conElias,idJsp);
	modulob.mapeaRegId(conElias,opcionb.getModuloId());
	
	String msj      = "";
	
	if(accion == null)
		accion = "0";
	usuario.mapeaRegId(conElias, codigoId);	
	if(accion.equals("1")){
		
		String cuenta = request.getParameter("cuenta");
		
		if (codigoId.substring(3, 4).equals("E") == false){
			cuenta = usuario.getCuenta();
		}
		
		String clave = request.getParameter("clave1");
		//System.out.println("Datos:"+codigoId+":"+cuenta+":"+aca.usuario.Usuario.existeCuenta(conElias, cuenta, codigoId));
		// Valida que no exista la cuenta
		if (!aca.usuario.Usuario.existeCuenta(conElias, cuenta, codigoId)){
			usuario.setCuenta(cuenta);
			
			// Encripta la clave 
			MessageDigest md5 			= MessageDigest.getInstance("MD5");
			md5.update(clave.getBytes("UTF-8"));
		    byte raw[] = md5.digest();    
		    String claveDigest = (new BASE64Encoder()).encode(raw);
			usuario.setClave(claveDigest);
			if(usuario.updateReg(conElias)){
				salto = "../inicio/index.jsp";
				//msj = "<div class='alert alert-success'><button class='close' data-dismiss='alert'>&times;</button> Se Actualizo tu Contraseña Correctamente</div>";
				msj = "ActualizoPass";
			}else{
				//msj = "<div class='alert alert-error'><button class='close' data-dismiss='alert'>&times;</button> Ocurrió un error al actualizar tu Contraseña</div>";
				msj = "NoActualizoPass";
			}
		}else{
			msj = "ExisteCuenta";
		}
	}
	pageContext.setAttribute("msj", msj);
%>

<div id="content">

	<h2><fmt:message key="pass.CambiaPass" /> <small><%=usuario.getCuenta() %></small></h2>
	
	<%if(!msj.equals("")){%> 
		<div class='alert alert-success'><button class='close' data-dismiss='alert'>&times;</button> <fmt:message key="aca.${msj}" /></div>			
	<%}%>
	
	<div class="alert alert-info"> <fmt:message key="aca.InstrucionesUsuario" /></div>
	
<form id="forma" name="forma" action="cambia_clave.jsp?Accion=1" method="post">
	
	<fieldset>
		<div class="control-group ">
	    	<label for="cuenta"><fmt:message key="aca.Cuenta" /><span class="required-indicator">*</span></label>
	        <input type="text" id="cuenta" name="cuenta" value="<%=usuario.getCuenta()%>" <% if (codigoId.substring(3, 4).equals("E") == false){ out.print("readonly");}%>/>	
		</div>
		<div class="control-group ">
	    	<label for="nombre"><fmt:message key="pass.Pass" /><span class="required-indicator">*</span></label>
	        <input type="password" id="clave1" name="clave1" />
		</div>	       
		<div class="control-group ">
	    	<label for="username"><fmt:message key="pass.RepitePass" /><span class="required-indicator">*</span></label>
	        <input type="password" id="clave2" name="clave2" />
		</div>
	</fieldset>
	
	<div class="well">
		<a class="btn btn-primary btn-large" onclick="verifica();" ><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		<a class="btn btn-large" href="../../general/inicio/index.jsp"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></a>	
	</div>

</form>

</div>

<script type="text/javascript">
	function verifica(){
		if(document.getElementById("cuenta").value != "" && document.getElementById("clave1").value != "" && document.getElementById("clave2").value != ""){
			if(document.getElementById("clave1").value == document.getElementById("clave2").value){
				document.forma.submit();
			}else{
				alert("<fmt:message key="js.ClaveNoCoincide" />");
			}
		}else{
			alert("<fmt:message key="js.EscribirDosVeces" />");
		}
	}
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="1; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>