<!DOCTYPE HTML>
<html>
<head>
	<meta charset="UTF-8">
	<title>Iniciar Sesi&oacuten</title>
	<link rel="shortcut icon" href="imagenes/icon.png">


	<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/login.css">
	
<%
	if((String)session.getAttribute("escuela") != null ){
		response.sendRedirect("general/inicio/index.jsp");
	}
%>

<!-- Google Tag Manager -->
		<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-5BZSVZ"
		height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
		<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
		new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
		j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
		'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
		})(window,document,'script','dataLayer','GTM-5BZSVZ');</script>
<!-- End Google Tag Manager -->


</head>
<body>

	<div class="logo">
		
		<img src="imagenes/eduAdvent.png" >
	</div>

	<div class="well-white">
        <div class="page-header">
            <h1>Entrar al Sistema</h1>
        </div>

        <form action="" method="post">
        
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
        		<button id="entrar" class="btn btn-success btn-large"><i class="icon-user icon-white"></i> Iniciar Sesi&oacute;n</button>
        	</p>
			
        </form>
        &nbsp;
    </div>

	<div class="footer">
		<a target="_blank" href="AvisoDePrivacidad.pdf" style="color: #D8D8D8;">Aviso de privacidad</a>
	</div>

    <script src="js/jquery-1.9.1.min.js"></script>
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
    				$('<div class="alert alert-error">Todos los campos son requeridos.</div>').fadeIn().prependTo(form);
    				return;
    			}
    			
    			if(password.val() == ''){
    				usuario.parent('div').removeClass('error');
    				password.parent('div').addClass('error');
    				$('<div class="alert alert-error">Todos los campos son requeridos.</div>').fadeIn().prependTo(form);
    				return;
    			}
    			
    			usuario.parent('div').removeClass('error');
    			password.parent('div').removeClass('error');
    			
    			$this.addClass('disabled').html('<img src="imagenes/loader.gif" /> Validando...');

    			$.post('valida.jsp', form.serialize(), function(r){
    				if($.trim(r) == 'errorUsuario'){
    					usuario.parent('div').addClass('error');
    					$('<div class="alert alert-error">Este Usuario no existe.</div>').fadeIn().prependTo(form);
    				}else if($.trim(r) == 'errorPassword'){
    					password.parent('div').addClass('error');
    					$('<div class="alert alert-error">Password Incorrecto.</div>').fadeIn().prependTo(form);
    				}else if($.trim(r) == 'correcto'){
    					location.href='./general/inicio/index.jsp';
    				}else if($.trim(r) == 'correcto'){
    					usuario.parent('div').addClass('error');
    					$('<div class="alert alert-error">Tu escuela se encuentra inactiva.</div>').fadeIn().prependTo(form);
    				}
    				
    				$this.removeClass('disabled').html('<i class="icon-user icon-white"></i> Iniciar Sesi&oacute;n');
    			});

    		});

    	});
    </script>
	
</body>
</html>