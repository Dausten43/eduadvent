<!DOCTYPE HTML>
<html>
<head>
	<meta charset="UTF-8">
	<title>Iniciar Sesi&oacuten</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
	
	<link rel="stylesheet" href="jqm/jquery.mobile-1.4.2.min.css" />
	<script src="jqm/jquery-1.9.1.min.js"></script>
	<script src="jqm/jquery.mobile-1.4.2.min.js"></script>
	
	<link rel="stylesheet" href="css/style.css" />
	
	
<%
	if((String)session.getAttribute("escuela") != null ){
		response.sendRedirect("general/inicio/datos.jsp");
	}
%>
</head>
<body>

<style>
	.ui-page {
		background-color: #268fc0 !important;
	}
</style>

<div data-role="page">
    <div data-role="content">
	    <br><br>
		<center>
			<div class="IniciarSesion">
				Iniciar Sesión
			</div>
			<div class="SistemaAcademico">
				eduAdvent
			</div>
		</center>
		<br><br>
        <form action="" class="login-form" method="post"> 
            <p>
                <div class="control-group">
                    <input id="Usuario" name="Usuario" type="text" placeholder="Usuario">
                </div>
            </p>
            
            <p>
                <div class="control-group">
                    <input id="Clave" name="Clave" type="password" placeholder="Password">
                </div>
            </p>
            
            <p>
                <span class="loginError"></span>
            </p>
            
            <p>
                <button id="entrar"> Iniciar Sesi&oacute;n</button>
            </p>
        </form>
    </div>
</div>
    
	
    <script>
    	$(window).ready(function(){

    		var form = $('form'),
    			usuario = $('#Usuario').focus(),
    			password = $('#Clave');
    		
    		$('#entrar').on('click', function(evt){
    			evt.preventDefault();
    			$this = $(this);

    			$('.alert').hide();
    			
    			if(usuario.val() == ''){
    				usuario.parent('div').addClass('error');
    				$('<center><div>Todos los campos son requeridos.</div></center>').fadeIn().prependTo(form);
    				return;
    			}
    			
    			if(password.val() == ''){
    				usuario.parent('div').removeClass('error');
    				password.parent('div').addClass('error');
    				$('<center><div>Todos los campos son requeridos.</div></center>').fadeIn().prependTo(form);
    				return;
    			}
    			
    			usuario.parent('div').removeClass('error');
    			password.parent('div').removeClass('error');
    			
    			$this.addClass('disabled').html('Validando...');

    			$.post('../valida.jsp', form.serialize(), function(r){
    				if($.trim(r) == 'errorUsuario'){
    					usuario.parent('div').addClass('error');
    					$('<center><div>Este Usuario no existe.</div></center>').fadeIn().prependTo(form);
    				}else if($.trim(r) == 'errorPassword'){
    					password.parent('div').addClass('error');
    					$('<center><div>Password Incorrecto.</div></center>').fadeIn().prependTo(form);
    				}else if($.trim(r) == 'correcto'){
    					location.href='general/inicio/datos.jsp';
    				}else if($.trim(r) == 'correcto'){
    					usuario.parent('div').addClass('error');
    					$('<center><div>Tu escuela se encuentra inactiva.</div></center>').fadeIn().prependTo(form);
    				}
    				
    				$this.removeClass('disabled').html('<i class="icon-user icon-white"></i> Iniciar Sesi&oacute;n');
    			});

    		});

    	});
    </script>
    
  
	
</body>
</html>