<%@ include file= "../../administradores.jsp" %>
<%
	java.util.ArrayList<aca.menu.Menu> MENU				= (java.util.ArrayList<aca.menu.Menu>) session.getAttribute("lisMenuPrincipal");
	java.util.ArrayList<aca.menu.Modulo> MODULO			= (java.util.ArrayList<aca.menu.Modulo>) session.getAttribute("lisMenu");
	java.util.ArrayList<aca.menu.ModuloOpcion> OPCION	= (java.util.ArrayList<aca.menu.ModuloOpcion>) session.getAttribute("lisOpcion");
		
	String menuUSER = (String)session.getAttribute("codigoId");
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ page pageEncoding="UTF-8"%>

<i class="icon-print impresora"></i>

<div class="navbar" ><!--  navbar-inverse -->
      <div class="navbar-inner" style="border-radius:0;">
        <div class="container">
          
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          
          <a class="brand" href="../../general/inicio/index.jsp">eduADVENT</a>
     
          <div class="nav-collapse collapse">
            <ul class="nav">
            	
            	<!-- ********************* PORTALES *********************** -->
            	<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown">Portales <b class="caret"></b></a>		 	
			  		<ul class="dropdown-menu">
			  				<%		
								if((Boolean)session.getAttribute("portalDivision")){
							%>
								  <li><a href="../../portal/dia/uniones.jsp" >Portal DIA</a></li>
							<%	
								}
								if((Boolean)session.getAttribute("portalAdmin")){
							%>
								  <li><a href="../../portal/administrador/grafica.jsp" >Portal del Admin</a></li>
							
							<%	}
								if((Boolean)session.getAttribute("portalMaestro")){
							%>
								  <li><a href="../../portal/maestro/opcion.jsp" >Portal del Maestro</a></li>
								  <% if (menuUSER.startsWith("H")){ %>
								  <li class="dropdown-submenu"><a>Utilerías del maestro</a>
	                  		 	  	<ul class="dropdown-menu second-level">
	                  		 	  		<li><a tabindex="-1" href="../../kinder/areas-criterios/observacionesKinder.jsp">Observaciones Kinder</a></li>
	                  		 	  		<li><a tabindex="-1" href="../../maestro/observaciones/observaciones.jsp">Observaciones boletín</a></li>
	                  		 	  		<li><a tabindex="-1" href="../../disciplina/reporte/repalumno.jsp">Reportes del alumno</a></li>
	                  		 	  	</ul>
	                  		 	  </li>
	                  		 	  <% } %>
							<%
								}
							
								if((Boolean)session.getAttribute("portalAlumno")){
							%>
									  <li><a href="../../portal/alumno/datos.jsp">Portal del Alumno</a></li>
							<%
								}
							
								
								if((Boolean)session.getAttribute("portalPadre")){
							%>
									<li><a href="../../portal/padre/portalPadre.jsp" >Portal del Padre</a></li>
							<%
								}
							%>
							
					 </ul>
				</li>
				
				<!-- ********************* OPCIONES DEL MENU *********************** -->
                 
          <%
          		for(aca.menu.Menu m: MENU){
          			if(m.getMenu_id().equals("7"))continue;
          %>         
               <li class="dropdown">
	                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><%=m.getMenu_nombre() %> <b class="caret"></b></a>
	                <ul class="dropdown-menu">
	                  
	                  <%
	                  for(aca.menu.Modulo mo: MODULO){
	                	  if(!mo.getMenuId().equals(m.getMenu_id()))continue;
	                  %>
	                  
	                  <li class="dropdown-submenu"><a><%=mo.getNombreModulo() %></a>
	                  		 <ul class="dropdown-menu second-level">
	                  		 		<%
					                  for(aca.menu.ModuloOpcion o: OPCION){
					                	  if(!o.getModuloId().equals(mo.getModuloId()))continue;
					                 %>
	                  		 	
	                                	<li><a tabindex="-1" href="../../<%=mo.getUrl()%><%=o.getUrl()%>"><%=o.getNombreOpcion() %></a></li>
	                               	<%
	                               	  } 
	                               	%>
	                         </ul>
	                  </li>
	                  <%
	                  }
	                  %>
	                  
	                </ul>	             
	           </li>
	                
	                
	      <%
          		}
	      %>
              

            </ul>
			
			
		<!-- ********************** OPCIONES DEL USUARIO ********************** -->	
		   
           <ul class="nav pull-right">
                     <li class="dropdown">
                       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><%=aca.vista.UsuariosLista.getNombreCorto(conElias, menuUSER)  %> <b class="caret"></b></a>
                       <ul class="dropdown-menu">
                         
                         <%
                         int contadorMenu = 0;
                         for (int j=0; j<OPCION.size(); j++){
								aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) OPCION.get(j);
								if (op.getModuloId().equals("A05") || op.getModuloId().equals("A20")){
									String url = "";
									if(op.getModuloId().equals("A05"))url="usuario";
									else url = "parametros";
									
									String icon = "icon-cog";
									
									if(op.getOpcionId().equals("80")){
										icon = "icon-user";
									}else if(op.getOpcionId().equals("380")){
										icon = "icon-calendar";
									}else if(op.getOpcionId().equals("381")){
										icon = "icon-home";
									}
									contadorMenu++;
							%>
								<li><a href="../../<%=url%><%=op.getUrl()%>" ><i class="<%=icon%>"></i> <%=op.getNombreOpcion() %></a></li>
							<%
								}
							}
                         
                         
                         
                         	if(contadorMenu>0){
                         %>
                         	<li class="divider"></li>
                         <% }%>
                                                 
                         <li><a href="../../general/editar/editar_idioma.jsp"><i class="icon-flag"></i> <fmt:message key="aca.Lenguaje" /></a></li>
                         <li><a href="../../general/editar/cambia_clave.jsp"><i class="icon-briefcase"></i> <fmt:message key="aca.EditarContra" /></a></li>
                         <li><a href="../../out.jsp"><i class="icon-off"></i> <fmt:message key="aca.Salir" /></a></li>
                       </ul>
                     </li>
           	</ul>
           	
           	<!-- ********************** SEARCH INPUT ********************** -->
           	<%
           	System.out.println("holaaaaa------------" + session.getAttribute("buscador") );
           	if((boolean) session.getAttribute("buscador") || menuUSER.equals("B01P0002") || admins.contains(String.valueOf(session.getAttribute("admin")))){ %>
           	<form class="navbar-search form-search pull-right" action="" style="margin-right:10px;">
                   	<div class="input-prepend">
					    
					    <% if (!session.getAttribute("admin").equals("-------")){ %>
					    	<!-- SOLO PARA ADMINISTRADORES -->
					    	<a class="btn suplantar"><i class="icon-user"></i></a>
					    <%}%>
					    <% 
                                            System.out.println("#########################" + menuUSER + " " + session.getAttribute("admin"));
					    if(aca.empleado.EmpPersonal.existeReg(conElias, menuUSER) &&  (!menuUSER.contains("P") || menuUSER.equals("B01P0002") || admins.contains(String.valueOf(session.getAttribute("admin"))))){ %>
					    <input type="text" class="span2 search-query" placeholder="Buscar" style="border-radius:0;">
					    <button class="btn" style="border-radius: 0 14px 14px 0;border-left:0;"><i class="icon-search"></i></button>
					    <%} %>
					</div>
           </form>
           <%} %>

          </div>
        </div>
      </div>
    </div>

<%if(menuUSER.contains("E") || menuUSER.equals("B01P0002") || admins.contains(String.valueOf(session.getAttribute("admin")))){ %> 
    
<!-- SOLO PARA LOS QUE TIENEN ACCESO A LA BUSQUEDA -->
   
<!-- ********************** LIGHTBOX HTML MARKUP ********************** -->
    
    <div class="search-lightbox">
    	<div>
	    	<div class="lightbox-navbar">
	    			
	    			<div class="lightbox-text">
	    				<div>
	    				<div class="txt">
	    					Resultados de la Busqueda: 
	    				</div>
	    				</div>
	    			</div>
	    	
	    			<div class="lightbox-close">
	    				<i class="lightbox-iconClose"></i>
	    			</div>
	    	</div>
	    	
	    	<div class="lightbox-result">
	    		
	    	</div>
    	</div>
    </div>

<style>
li.dropdown-submenu:hover > .dropdown-menu {
	display: none;
}
</style>
<script>
	(function(){
		
		$('li.dropdown-submenu').on('mouseenter.hoverdir, mouseleave.hoverdir click', function(event){
			var li = jQuery(this);
			event.stopPropagation();
			
			var secondLvl = li.find('.second-level');
			
			li.siblings('.dropdown-submenu').find('.second-level').hide();
			
			if(event.type == 'click'){// If the user click on a menu option
				//alert('click');
				if(secondLvl.is(':visible')){
					secondLvl.hide();
				}else if(secondLvl.is(':hidden')){
					secondLvl.show();
				}	
			}else{// If the user put the mouse over a menu option
				//alert('mouseover');
				//if is mobile device then don't do this below just 'return'
				if ('ontouchstart' in document.documentElement){
					return;
				}
				
				if(event.type == 'mouseenter' && secondLvl.is(':hidden')){
					secondLvl.show();
				}else if(event.type == 'mouseleave' && secondLvl.is(':visible')){
					secondLvl.hide();
				}	
			}
		});
		
	})();
</script>

<!-- ********************** SCRIPT DE LA IMPRESORA ********************** -->

<script>

	(function(){
		
		$('.impresora').on('click', function(){
			window.print();
		});
		
	})();

</script>

<!-- ********************** SCRIPT DE LA BUSQUEDA ********************** -->
<script>

	(function(){
		
		var lightBox 	= $('.search-lightbox'),
			content  	= lightBox.children('div'),
			navbar   	= $('.lightbox-navbar'),
			result   	= lightBox.find('.lightbox-result'),
			loading  	= $('<div class="alert alert-info search-loading" ><img src="../../imagenes/loading.gif"> &nbsp;Buscando...</div>'),
			navSearch  	= $('.navbar-search'),
			inputQuery 	= navSearch.find('.search-query');
		
		var openLightBox = function(searchVal, rs){
			
			var tmp = $('<div />').html(rs);
			var conincidencias = tmp.find('.size').html();
			tmp.remove();
			loading.remove();
			
			result.html(rs);
			fixHeight();
			lightBox.find('div.lightbox-text').find('.txt').html(conincidencias+" Conincidencias de <span>&#8220;"+searchVal+"&#8221;</span>");
			content.css({
						marginTop: -lightBox.outerHeight()
					});
					
			lightBox.fadeIn(300, function(){
										content.animate({
											marginTop: 0
										}, 400);					
								});
			
			
		};
		
		$(window).resize(function(){
			fixHeight();
		});
		
		var fixHeight = function(){
			result.css('max-height', lightBox.outerHeight()-navbar.outerHeight());
		}
		
		var closeLightBox = function(){
			lightBox.fadeOut(400, function(){
												result.html("");
											});
		}
		
		//TRIGGER EVENTS
		$('.lightbox-close').on('click', function(){
			closeLightBox();
		});
		
		lightBox.on('click', function(){
			closeLightBox();
        });
		
		//STOP PROPAGATION
		lightBox.on('click', 'div', function(e){
            e.stopPropagation();
        });
			
		navSearch.on('submit', function(e){
			e.preventDefault();
			
			var input = inputQuery;
			
			var top = input.offset().top + input.outerHeight()+10;
			
			loading.remove().appendTo('body').css({
				top: input.offset().top,
				left: input.offset().left,
				width: input.outerWidth()
			}).show().animate({
								top: top
							}, 300);
			
			var searchVal = input.val();
			console.log(searchVal);
// 			$.get('../../buscar.jsp?parametro='+searchVal, function(r){
// 				openLightBox(searchVal, r);
// 			});
			var datadata = 'parametro='+searchVal;
			
			$.ajax({url: '../../buscar.jsp',
                type: "post",
                data: datadata,
                success: function (output) {
                	openLightBox(searchVal, output);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status + " " + thrownError);
                }});
			
			
		});
		
		$('.suplantar').on('click', function(){
			
				var input = inputQuery;
				location.href = "../../usuario/configuracion/busca.jsp?Accion=3&matricula="+input.val();
		});
		
		
		
		
	})();
	

</script>    

<%}%>
    
