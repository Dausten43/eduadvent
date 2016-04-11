<!DOCTYPE html>
<%@ page import="aca.menu.*"%>
<%@ page buffer="8kb" autoFlush="true"%>
<%@ include file="con_elias.jsp"%>

<jsp:useBean id="usuario2" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="moduloLista" scope="page" class="aca.menu.ModuloLista"/>
<jsp:useBean id="opcionLista" scope="page" class="aca.menu.ModuloOpcionLista"/>
<jsp:useBean id="usuarios" scope="page" class="aca.vista.Usuarios"/>
<jsp:useBean id="cicloGrupoCurso" scope="page"	class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="alumPersonal" scope="page"	class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="empPersonal" scope="page"	class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="msj" scope="page" class="aca.usuario.UsuarioMensaje"/>

<html>
<head>
<%
	String currentColor = (String) session.getAttribute("colorUsuario");
	
	String mensaje = request.getParameter("mensaje")==null?"":request.getParameter("mensaje");
%>

<title>Sistema Escolar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="SHORTCUT ICON" href="imagenes/icoEs.png">

<script src='js/jquery-1.7.1.min.js'></script>
<script type="text/javascript" src="js/prototype-1.6.js"></script>

<link href="bootstrap/css/bootstrap.min.css" rel="STYLESHEET" type="text/css">

<link rel="stylesheet" type="text/css" href="superfish/css/superfish.css" media="screen">
<%
    String codigo 			= request.getParameter("Codigo")==null?"vacio":request.getParameter("Codigo");
	String nombreUsuario	= ""; 
	String strOpcion 		= "";	

	//Si escribio el codigo que quiere subplantar   
	if(!codigo.equals("vacio")){
		
		// si existe el usuario
		usuario2.setCodigoId(codigo);
		if (usuario2.existeReg(conElias)){
			
			// Actualiza el menu principal y las opciones a las que tiene acceso el usuario
			ArrayList<aca.menu.Modulo> lisMenu				= new ArrayList<aca.menu.Modulo>();
			ArrayList<aca.menu.ModuloOpcion> lisOpcion		= new ArrayList<aca.menu.ModuloOpcion>();
			
			lisMenu = moduloLista.getListUser(conElias, codigo);
			lisOpcion = opcionLista.getListUser(conElias, codigo);
			for (int i=0;i<lisOpcion.size();i++){
				aca.menu.ModuloOpcion opc = (aca.menu.ModuloOpcion) lisOpcion.get(i);
				strOpcion = strOpcion + "-"+ opc.getOpcionId();				
			}
			
			// Pone en sesion el nombre del usuario 
			int intTipoUsuario	= aca.usuario.Usuario.getTipo(conElias, codigo);
			if (intTipoUsuario ==1){
				nombreUsuario = aca.alumno.AlumPersonal.getNombre(conElias,codigo,"NOMBRE");				
			}else if (intTipoUsuario ==2 || intTipoUsuario ==3){
				nombreUsuario = aca.empleado.EmpPersonal.getNombre(conElias,codigo,"NOMBRE");				
			}			
			strOpcion+= "-PAL-PEM-PPA-";
			
			// Si es empleado se agrega la opcion de consultar
			if (intTipoUsuario ==2) strOpcion += "-6-380";
			
			session.setAttribute("codigoId", codigo );
			session.setAttribute("lisMenu", lisMenu);
			session.setAttribute("lisOpcion", lisOpcion);
			session.setAttribute("opciones", strOpcion);			
			session.setAttribute("nombreUsuario",nombreUsuario);
			session.setAttribute("cicloId",aca.ciclo.Ciclo.getMejorCarga(conElias, codigo));
			

		}
	} 
	
	String strEscuela = (String)session.getAttribute("escuela");
	String escuela 	  = aca.catalogo.CatEscuela.getNombre(conElias,strEscuela);
	String strNombreUsuario	= (String)session.getAttribute("nombreUsuario");
	
	String strUsuario		= (String)session.getAttribute("codigoId");//Robar cuenta
	String strAdmin			= (String)session.getAttribute("admin");
	
	
	boolean otroUsuario = false;
	if(!strUsuario.equals(strAdmin)){
		otroUsuario=true;
	}
	
	ArrayList lisOpcion		= (ArrayList)session.getAttribute("lisOpcion");
	String admin			= (String)session.getAttribute("admin");
	String sUsuario			= (String)session.getAttribute("cuenta");
	String sCodigoPersonal 	= (String)session.getAttribute("codigoId");
	ArrayList lisModulo		= (ArrayList)session.getAttribute("lisMenu");
	ArrayList menuPrincipal	= (ArrayList)session.getAttribute("lisMenuPrincipal");

	String user = (String) session.getAttribute("user");
	usuario.mapeaRegId(conElias, strUsuario);
	
%>
<style>
body {
	margin: 0;
	padding: 0;
	overflow-y: hidden;
	background: url(imagenes/bg.png);
	font-family: "HelveticaNeue-Light", "Helvetica Neue Light",
		"Helvetica Neue", sans-serif;
}

#secondFrame {
	min-width: 1023px;
}

a.menu:after,.dropdown-toggle:after {
	content: none;
}

li {
	line-height: .9;
}

.icon-arr {
	position: absolute;
	top: -8px;
	left: 3px;
	height: 15px;
	width: 31px;
	background: url(imagenes/arr.png);
}

.icon-arr-left {
	position: absolute;
	top: -6px;
	right: 18px;
	height: 15px;
	width: 31px;
	background: url(imagenes/arr.png);
}

.arr-left-side{
	background: url(imagenes/arrowLeft.png);
	position: absolute;
	top: 8px;
	left: -14px;
	height: 15px;
	width: 14px;
}

.arr-left-side-bottom{
	background: url(imagenes/arrowLeft.png);
	position: absolute;
	bottom: 16px;
	left: -14px;
	height: 15px;
	width: 14px;
}

.sf-menu {
	padding: 0 0 0 1px;
}

#menu {
	color: #F2F2F2;
	letter-spacing: 0px;
}

#menu:hover {
	color: white;
}

.main-menu li:hover ul,.main-menu li.sfHover ul {
	left: 0;
	top: 2.5em; /* match top ul list item height */
	z-index: 99;
}

.user-menu li:hover ul,.user-menu li.sfHover ul {
	right: 0;
	top: 2.5em; /* match top ul list item height */
	z-index: 99;
	width: 130px;
}

.container {
	width: 100%;
	min-width: 1023px;
}

#header {
	height: 45px;
	margin-bottom: 4px;
	-moz-box-shadow: 0 1px 6px 0px #6E6E6E;
	-webkit-box-shadow: 0 1px 6px 0px #6E6E6E;
	box-shadow: 0 1px 6px 0px #6E6E6E;
}

.titulo {
	font-size: 20px;
	color: white;
	letter-spacing: 1px;
	padding: 11px 0 0 10px;
	float: left;
	cursor:pointer;
}

.sf-menu {
	float: left;
	padding: 7px 0 0 10px;
}

.user-menu{
	padding: 7px 7px 0 0px;
}

<%
//Cambiar color hader y hover del menu
  		
		if (!currentColor.equals ("default")){
			out.print(" #header{background:"+currentColor+";}");
			out.print (".sf-menu a:hover {background: "+currentColor+";}");
		}else {
			out.print(" #header{background:#66A600;} ");
			out.print(" .sf-menu a:hover{background : #66A600;}");
		}
%>
</style>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-57674943-1', 'auto');
  ga('send', 'pageview');

</script>

</head>

<body onload="jQuery('#parametroBusqueda').focus()" oncontextmenu="return false"
				ondragstart="return false" onselectstart="return false">
	<div class="container">

		<div id="header">

			<div class="titulo">
				<a href="principal.jsp" style="text-decoration:none;color:#F2F2F2;cursor:pointer;"><img style="position:relative;top:-3px;" src="imagenes/logoUni.png" width="25px"/> Exodus</a>
			</div>

			<%@ include file="--menuHeader.jsp"%>
			
			
			<ul class="sf-menu user-menu" style="float:right;margin:0 0 3px 0;">
				<li>
						<a href="#" class="principal" id="menu" style="cursor:pointer;min-width:95px;text-align:right;">&nbsp;&nbsp;&nbsp;<%=aca.vista.UsuariosLista.getNombreCorto(conElias, strUsuario)  %></a>
						<ul class="drpmenu" style="min-width:150px;">
							<i class="icon-arr-left"></i>
							<%for (int j=0; j<lisOpcion.size(); j++){
								ModuloOpcion opcion = (ModuloOpcion) lisOpcion.get(j);
								if (opcion.getModuloId().equals("A05") || opcion.getModuloId().equals("A20")){
									String url = "";
									if(opcion.getModuloId().equals("A05"))url="usuario";
									else url = "parametros";
									
									String icon = "icon-cog";
									
									if(opcion.getOpcionId().equals("80")){
										icon = "icon-user";
									}else if(opcion.getOpcionId().equals("380")){
										icon = "icon-calendar";
									}else if(opcion.getOpcionId().equals("381")){
										icon = "icon-home";
									}
							%>
								<li><a href="<%=url%><%=opcion.getUrl()%>?moduloId=<%=opcion.getModuloId()%>&carpeta=<%=opcion.getUrl()%> " target="secondFrame"><i class="<%=icon%>"></i> <%=opcion.getNombreOpcion() %></a></li>
							<%
								}
							}
							empPersonal.setCodigoId(sCodigoPersonal);
							if(empPersonal.existeReg(conElias) && sCodigoPersonal.substring(3,4).equals("E")){
							%>
							<li><a target="secondFrame" href="empleado/curriculum/vitae.jsp"><i class="icon-list-alt"></i> Curriculum</a></li>
							<%} %>
							 <li><a href="cambia_clave.jsp" target="secondFrame"><i class="icon-lock"></i> Editar Contraseña</a></li>
							<li class="changeColor"><a class="cambiarColor" style="cursor:pointer;"><i class="icon-picture"></i> Cambiar color</a></li>
							 <li><a target="_top" href="salir.jsp"><i class="icon-off"></i> Salir</a></li>
						</ul>
				</li>
			</ul>
			
			<%if(user.contains("E") || user.equals("B01P0002")){ %>
			
			<div class="<% if (!session.getAttribute("admin").equals("-------")){%>input-prepend<%} %> input-append" style="float:right;padding:10px 0 0 0;">
				<% if (!session.getAttribute("admin").equals("-------")){%><button style="height:26px" onclick="cambiaCodigoPersonal()" class="btn" type="button"><i class="icon-user"></i></button><%} %><input style="height:16px;width:120px;" placeholder="Buscar" type="text" id="parametroBusqueda" size="16" /><button style="height:26px" class="btn search" type="button"><i class="icon-search"></i></button>
			</div>
			
			<%} %>
		
		</div>

	</div>


	<iframe style="height: 100%;position:absolute;" id="secondFrame" name="secondFrame"
		width="100%" src="inicial.jsp" scrolling="auto" frameborder="0"></iframe>
</body>
</html>

<script type="text/javascript" src="superfish/js/hoverIntent.js"></script>
<script type="text/javascript" src="superfish/js/superfish.js"></script>
<script type="text/javascript">

jQuery(function(){
	jQuery('ul.sf-menu').superfish();
	
});

</script>


<script type="text/javascript">
	(function($){
		
		$('#secondFrame').load(function(){
	        $('#secondFrame').contents().find('body').on('click', function(){
	        	$('.principal').parent('li').children('ul').hide().css('visibility','hidden');
	        });
	    });
		
		
		$(document).ready(function() {
			var windowHeight 	= $(window).height();
	  		$("#secondFrame").css({
					"height": windowHeight-$(".container").height()
			});
		});
  		
  		$(window).resize(function(){	
  			
  			var windowHeight 	= $(window).height();
  			
  			$("#secondFrame").css({
  				"height": windowHeight-$(".container").height()
  			});
  		});
  		
  		
		
	})(jQuery);

	function refrescar(){
		location.href = "../../principal.jsp";
	}
	
	//Sustituir codigo id
	
	function cambiaCodigoPersonal(){
		document.location = "usuario/configuracion/busca.jsp?Accion=3&matricula="+jQuery("#parametroBusqueda").val();
	}
	
	jQuery('#parametroBusqueda').keypress(function(e) {
	    if(e.ctrlKey && e.keyCode == 13) {
	    	cambiaCodigoPersonal();
	    }
	});
	
	var menuIcons = jQuery('.user-menu').find('ul').find('li').find('a');
	
	for(var k=0; k<menuIcons.length; k++){
		jQuery(menuIcons[k]).on('mouseover', function(){
			jQuery(this).children('i').addClass('icon-white');
		});
		
		jQuery(menuIcons[k]).on('mouseout', function(){
			jQuery(this).children('i').removeClass('icon-white');
		});	
	}
</script>


			
<!-- cambiar color -->  


<style>
	.container-colores{
		position: absolute;
		top:0;
		height:150px;
		width:480px;
		background:white;
		border: 1px solid gray;
		padding: 15px;
		
  		-moz-box-shadow: 0 1px 6px 0px #6E6E6E;
   		-webkit-box-shadow: 0 1px 6px 0px #6E6E6E;
		box-shadow: 0 1px 6px 0px #6E6E6E;
		z-index:2000;
		display: none;
	}
	
	.color{
		width:40px;
		height: 40px;
		float:left;
		margin-right: 8px;
		cursor:pointer;
	}
	.bg-colores{
		position:absolute;
		top:0;
		width:100%;
		height:100%;
		background:white;
		opacity: .7;
		z-index:1000;
		display: none;
	}
	.negro{background: #1C1C1C;margin-left:5px;}
	.gris{background: #424242;}
	.ginda{background: #450B08}
	.morado{background: #5F29A1}
	.verde{background: #288B21}
	.rosa{background: #D143BC}
	.celeste{background: #3E8CD5}
	.default{background: #66A600}
	.azul{background: #1E58A8;}
	
	.active{border: 2px solid black;}
	
</style>

<div class="container-colores"><br>
	<table width="450px" align="center">
		<tr>
			<td align="center">
				<div data-color="1C1C1C" class="color negro <%if(currentColor.equals("#1C1C1C"))out.print("active");%>"></div>
				<div data-color="424242" class="color gris <%if(currentColor.equals("#424242"))out.print("active");%>"></div>
				<div data-color="450B08" class="color ginda <%if(currentColor.equals("#450B08"))out.print("active");%>"></div>
				<div data-color="5F29A1" class="color morado <%if(currentColor.equals("#5F29A1"))out.print("active");%>"></div>
				<div data-color="288B21" class="color verde <%if(currentColor.equals("#288B21"))out.print("active");%>"></div>
				<div data-color="D143BC" class="color rosa <%if(currentColor.equals("#D143BC"))out.print("active");%>"></div>
				<div data-color="3E8CD5" class="color celeste <%if(currentColor.equals("#3E8CD5"))out.print("active");%>"></div>
				<div data-color="1E58A8" class="color azul <%if(currentColor.equals("#1E58A8"))out.print("active");%>"></div>
				<div data-color="default" class="color default <%if(currentColor.equals("default"))out.print("active");%>"></div>
				
			</td>
		</tr>
		<tr>
			<td id="txt">&nbsp;</td>
		</tr>
		<tr>
			<td align="center"><br><button class="btn btn-primary grabar">Grabar</button></td>
		</tr>
	</table>
</div>  
<div class="bg-colores"></div>
<script>
	
	(function($){
		$('.changeColor').show();
		
		$('.color').on('click', function(){$(this).addClass('active').siblings('.color').removeClass('active');});
	
		var bgcolores = $('.bg-colores'),
			colores = $('.container-colores'),
			w = $(window).width()/2 - colores.outerWidth()/2,
			h = $(window).height()/2 - colores.outerHeight()/2;
		
		colores.css({'top' : h,'left' : w});
		
		$('<span class="close cerrar" style=position:absolute;top:5px;right:10px;>x</span>').prependTo(colores);
		
		$('.cambiarColor').on('click', toggle);
		
		$('.cerrar').on('click', toggle);
		
		$('.bg-colores').on('click', toggle);
		
		function toggle(){
			bgcolores.fadeToggle();
			colores.fadeToggle();
		}
		
		$('.grabar').on('click', grabar);
		
	
		
	})(jQuery);
	
	function ocultar(){
		
		var url = "ocultarMsj.jsp";
		
		
		new Ajax.Request(  
				  url, {  
					   method:'get',
					   parameters:  {timestamp:new Date().getTime()},  
					   
					   onSuccess: function(req){
							//eval(req.responseText);
						}
				   }  
		);  
		
	}
	
	function grabar(){
		
		var color = jQuery('.container-colores').find('.active').data('color'),
			url = "updateColor.jsp?color="+color;
		
		
		new Ajax.Request(  
				  url, {  
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
	
	function error(){
		document.getElementById("txt").innerHTML="ocurrio un error, favor de intentarlo mas tarde";
	}
	
	function cargando(){
		document.getElementById("txt").innerHTML="<img style='position:relative;top:2px;' height='15px' src=\"imagenes/loading.gif\" /> <font size=2>Un momento porfavor</font> ";
	}
	
	function actualizar(){
		location.href = "principal.jsp";
	}
	
</script>	

<!-- BUSQUEDA -->

<style>
	.container-search{
		position: absolute;
		top:0;
		width:450px;
		background:white;
		border: 1px solid gray;
		/*padding: 15px;*/
		
  		-moz-box-shadow: 0 1px 6px 0px #6E6E6E;
   		-webkit-box-shadow: 0 1px 6px 0px #6E6E6E;
		box-shadow: 0 1px 6px 0px #6E6E6E;
		z-index:2000;
		display: none;
	}
	
	.results{
		padding:2px 15px 0 15px;
	}
	
	.results img{
		margin-bottom: 15px;
	}
	
	.Close{
		float:none;
		text-align:center;
		background: #2E2E2E;
		color:white;
		font-size: 16px;
		letter-spacing: 4px;
		padding:5px;
		border: 1px solid gray;
		border-top:0;
		cursor:pointer;
	}
	.Close:hover{
		background: #424242;	
	}
	
	.mensaje{
		position: absolute;
		top:50px;
		right:10px;
		width:200px;
		background:white;
		border: 1px solid gray;
		padding: 15px;
		
  		-moz-box-shadow: 0 1px 6px 0px #6E6E6E;
   		-webkit-box-shadow: 0 1px 6px 0px #6E6E6E;
		box-shadow: 0 1px 6px 0px #6E6E6E;
		z-index:2000;
	}
	
	.tip{
		position: absolute;
		top:0;
		width:270px;
		height:147px;
		background:white;
		border: 1px solid gray;
		padding: 15px;
		display:none;
		
  		-moz-box-shadow: 0 1px 6px 0px #6E6E6E;
   		-webkit-box-shadow: 0 1px 6px 0px #6E6E6E;
		box-shadow: 0 1px 6px 0px #6E6E6E;
		z-index:100000000000000;
	}
</style>

<div class="container-search">
	<div class="results">
		<img src="imagenes/loading.gif" />
	</div>
</div>

<script src='js/buscar.js'></script>

<script>
	search.init(jQuery(".search"), jQuery("#parametroBusqueda"));
</script>	

<!-- tip -->
<div class="tip"></div>

<script src='js/tip.js'></script>

<!--  mensajes -->
<script>
<%
//mensaje de cambiar color

	msj.setCodigoId(sCodigoPersonal);
	msj.mapeaRegId(conElias, sCodigoPersonal);

	if(msj.getMensaje1().equals("S") || !msj.existeReg(conElias)){
%>

		var usr = jQuery('.user-menu');
		
		jQuery('<img class=warningArrow src=imagenes/warningArrow.png width="160" />').appendTo('body').css({
			'position':'absolute',
			'left':usr.offset().left-160,
			'top':'2px',
			'z-index': '20000000000'
		}).delay(5000).fadeOut(3000);
		
		jQuery('.drpmenu').on('mouseenter', ocultar);

<%
	}
%>
</script>

<%if(mensaje.equals("1")){%>
	<div class="mensaje">
		<span onclick="jQuery('div.mensaje').fadeToggle(300)" class="close close-msj">x</span>
		Este usuario no existe
	</div>
<%}%>
<%@ include file="cierra_elias.jsp"%>

