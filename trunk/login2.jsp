<!DOCTYPE>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Virtual UM</title>
	<link rel="SHORTCUT ICON" href="imagenes/icoAc.png">

	<link href="loginStyle.css" rel="STYLESHEET" type="text/css">

<%
	String focus = "document.getElementById('Usuario').focus();";
%>

	<script type="text/javascript" src="js/prototype-1.6.js"></script>
			

			<body onLoad="<%=focus%>" scroll="no" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
					
						<table>
							<tr>
								<td valign="middle" align="left">

									<table widht="100%" height="100px" align="center"
										class="cuadroLogin">
										<tr>
											<td colspan="2" class="um" valign="bottom"><img
												src="imagenes/exoduslogo.png" height="40px"></td>
										</tr>
										<tr>
											<td height="6px"></td>
										</tr>
										<tr>
											<td align="right">Usuario &nbsp;&nbsp;</td>
											<td><input onKeyDown="funcionEnter(event);" class="input" id="Usuario" name="Usuario" maxlength=20 type="text" tabindex=1></td>
										</tr>
										<tr>
											<td style="height: 14px;"></td>
										</tr>

										<tr>
											<td align="right">Contraseña &nbsp;&nbsp;</td>
											<td><input onKeyDown="funcionEnter(event);" class="input" id="Clave" name="Clave" maxlength=20 type="password" tabindex=2></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td align="right" colspan="2">
												<p id="txt" valign="middle" style="letter-spacing: 1px;"></p>
												<input onclick="validar();" class="button" type="button"
												value="Entrar"><br>&nbsp; 
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						
							
						
				<script>
	
	function validar(){
		
		new Ajax.Request(  
			  "valida.jsp?Usuario="+document.getElementById("Usuario").value+"&Clave="+document.getElementById("Clave").value, {  
				   method:'get',
				   parameters:  {timestamp:new Date().getTime()},  
				   
				   onSuccess: function(req){
						eval(req.responseText);
					},
				   
				   onFailure: function(req){
					   error();
					},
					
					onLoading:cargando()
			   }  
		);  

	}
	
	function funcionEnter(evento){ 
		//para IE 
		if (window.event) { 
			if (window.event.keyCode==13){ 
				validar();
			} 
		} 
		else{ 
		//Firefox y otros navegadores 
			if (evento){ 
				if(evento.which==13) { 
					validar();
				} 
			} 
		} 
	}
	
	function error(){
		document.getElementById("txt").innerHTML="error en la pagina";
	}
	
	function cargando(){
		document.getElementById("txt").innerHTML="<img style='position:relative;top:2px;' height='15px' src=\"imagenes/loading.gif\" /> <font size=2>Un momento porfavor</font> ";
	}
	
	function usuarioIncorrecto(){
		document.getElementById("txt").innerHTML = "<font size=2 color=#C21515><b>X</b> Usuario incorrecto</font>";
		document.getElementById("Usuario").style.border = "1px solid #FC3E3E";
		document.getElementById("Clave").style.border = "0px solid #FC3E3E";
		document.getElementById('Usuario').focus();
	}
	
	function claveIncorrecto(){
		document.getElementById("txt").innerHTML = "<font size=2 color=#C21515><b>X</b> Contraseña incorrecta</font>";
		document.getElementById("Clave").style.border = "1px solid #FC3E3E";
		document.getElementById("Usuario").style.border = "0px solid #FC3E3E";
		document.getElementById("Clave").value = "";
		document.getElementById('Clave').focus();
	}
	
	function camposRequeridos(accion){
		document.getElementById("txt").innerHTML = "<font size=2 color=#B11414>Todos los campos son requeridos</font>";
		if(accion=='1'){
			document.getElementById("usuario").innerHTML = "<font size=4 color=red>*</font>";
			document.getElementById('Usuario').focus();
		}else{
			document.getElementById("clave").innerHTML = "<font size=4 color=red>*</font>";
			document.getElementById('Clave').focus();
		}
	}
	
	function entrar(){
		document.getElementById("txt").innerHTML ="";
		window.open('principal.jsp', '_blank');
	}
	
</script>
			</body>
</html>