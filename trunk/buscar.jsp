<!doctype html>

<%@page import="java.util.HashMap"%>
<%@ include file= "con_elias.jsp" %>
<%@ include file= "idioma.jsp" %>

<jsp:useBean id="usuariosU" scope="page" class="aca.vista.UsuariosLista"/>
<jsp:useBean id="AlumPlanLista" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="PlanLista" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="CatNivelEscuelaLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<%@ page pageEncoding="UTF-8"%>
<%if(((String)session.getAttribute("codigoId")).contains("E") || ((String)session.getAttribute("codigoId")).equals("B01P0002") || session.getAttribute("admin").equals("B01P0002")){ %> 

<%

	System.out.println(request.getParameter("parametro"));
	
	String parametro  = request.getParameter("parametro");
	String escuela    = (String) session.getAttribute("escuela");
	
	java.util.HashMap <String, aca.alumno.AlumPlan> mapAlumPlan = AlumPlanLista.mapPlanActivo(conElias, escuela); // codigoPersonal
	
	java.util.HashMap <String, aca.plan.Plan> mapPlan = PlanLista.mapPlanesEscuela(conElias, escuela); //planID
	
	java.util.HashMap <String, aca.catalogo.CatNivelEscuela> mapNivel = CatNivelEscuelaLista.mapNiveles(conElias); //escuela + nivel
	
	ArrayList <aca.vista.Usuarios> usuarios;
	if(parametro.length() >= 3 && parametro.substring(0,3).equals(escuela) ){//busqueda por codigo
		usuarios = usuariosU.getListUsuarios(conElias, escuela, "AND CODIGO_ID like'%"+parametro+"%' ORDER BY NOMBRE, APATERNO, AMATERNO");
		if(usuarios.size() == 1){
			String tipo = "alumno";
			if(usuarios.get(0).getCodigoId().substring(3, 4).equals("E"))
				tipo = "empleado";
			else if(usuarios.get(0).getCodigoId().substring(3, 4).equals("P"))
				tipo = "padre";
			else
				tipo = "alumno";
%>			

				<script>
					location.href = "../../parametros/<%=tipo%>/buscar.jsp?Accion=3&CodigoPersonal=<%=usuarios.get(0).getCodigoId() %>";
				</script>
<%			
		}
	}else{//busqueda por nombre
		usuarios = usuariosU.getListBusqueda(conElias, escuela, parametro.trim().replaceAll(" ", "%"), "ORDER BY NOMBRE, APATERNO, AMATERNO");
	}
%>
	<style>
		.cursor{
			cursor:pointer;
		}
		
		.active{
			color: #999 !important;
			text-decoration: none !important;
			cursor: auto !important;
		}
		
		.breadcrumb a{
			cursor: pointer;
		}

	</style>
	
		
		<div class="size" style="display:none;"><%=usuarios.size() %></div>
<%	
	if(usuarios.size()>1000){ 
%>
		<div style="padding:15px;text-align:center;" class="alert alert-danger">
			<h4>Demasiadas Coincidencias, Favor de ser más especifico</h4>				
		</div>
<%
	}else{
		int alumnos 	= 0;
		int empleados 	= 0;
		int padres 		= 0;
		for(aca.vista.Usuarios usuario: usuarios){
			if(usuario.getCodigoId().substring(3, 4).equals("E")){
				empleados++;
			}else if(usuario.getCodigoId().substring(3, 4).equals("P")){
				padres++;
			}else{
				alumnos++;
			}
		}
%>
		<table class="table table-hover table-bordered" style="margin-bottom:0;">
			<tr>
				<td style="padding:0;">
					<ul class="breadcrumb filtro" style="margin:0;">
					  <li><a data-tipo="todos" class="active">Todos</a> <span class="divider">|</span></li>
					  <li><a data-tipo="alumno"><%=alumnos %> Alumnos</a> <span class="divider">|</span></li>
					  <li><a data-tipo="empleado"><%=empleados %> Empleados</a> <span class="divider">|</span></li>
					  <li><a data-tipo="padre"><%=padres %> Padres</a></li>
					</ul>
				</td>
			</tr>
<%
		for(aca.vista.Usuarios usuario: usuarios){			
			String tipo 	= "alumno";
			if(usuario.getCodigoId().substring(3, 4).equals("E")){				
				tipo 	= "empleado"; 
			}else if(usuario.getCodigoId().substring(3, 4).equals("P")){				
				tipo 	= "padre";
			}
			
			
%>
			<tr class="resultado <%=tipo%>">
			
				<td width="70%" onclick="subirCodigo('../../parametros/<%=tipo%>/buscar.jsp?Accion=3&CodigoPersonal=<%=usuario.getCodigoId()%>')" class="cursor" width="15%">
					<% if (!session.getAttribute("admin").equals("-------")){%>
						<a class="btn btn-link btn-mini" href="../../usuario/configuracion/busca.jsp?Accion=3&matricula=<%=usuario.getCodigoId()%>">
							<i class="icon-user"></i>
						</a>
						&nbsp;
					<%} %>
					<%=usuario.getCodigoId() %>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<%=usuario.getNombre()%> <%=usuario.getaPaterno() %> <%=usuario.getaMaterno()%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					
					</td>
			
			 <%
			 
			 String planId	= "-";
			 String nivelId	= "-";
			 String	nivel	= "-";
			 String grado	= "-";
			 String grupo	= "-";
			 
			 
			if(mapAlumPlan.containsKey(usuario.getCodigoId())){
				
				planId = mapAlumPlan.get(usuario.getCodigoId()).getPlanId();
				grado  = mapAlumPlan.get(usuario.getCodigoId()).getGrado();
				
				grupo  = mapAlumPlan.get(usuario.getCodigoId()).getGrupo();
				
				if(mapPlan.containsKey(planId)){
					nivelId = mapPlan.get(planId).getNivelId();
					System.out.println(" busqueda  " + escuela+nivelId);
					if(mapNivel.containsKey(escuela+nivelId)){
						
						nivel=mapNivel.get(escuela+nivelId).getNivelNombre().replace("NIVEL", "");
						
					}
					
				}
				
				
				%>

			
			<%}%>
			
				<td width="25%"><%=nivel %></td>
				
				<%if(grado.equals(""+0)){%>
					<td width="5%" style=color:red><fmt:message key="aca.Desactivado"/></td>
				<%}else{%>
					<td width="5%"><%=grado%><%=grupo%></td>	
				<%} %>
				
			</tr>
<%	
		}
	}
%>
		</table>
	
<script>
	function subirCodigo(url){
		location.href = url;
	}

	function busquedaAvanzada(link){
		cerrar();
		
		secondFrame.location.href=link;
	}
	
	var resultado = $('.resultado');
	$('.filtro').find('a').on('click', function(){		
			var $this 	= $(this);
			var filtro 	= $this.data('tipo');
			if($this.hasClass('active') == false){
				
				$this.addClass('active').parent('li').siblings('li').children('a').removeClass('active');
				
				/* Hide all */
				resultado.hide();
				
				if(filtro == 'todos'){
					resultado.fadeIn(300);
				}else{
					/* Show match */
					resultado.filter(function( index ) {
				    		return $( this ).hasClass( filtro ) === true;
				  		}).fadeIn(300);
				}
			}
	});
	
</script>

<%} %>

<%@ include file= "cierra_elias.jsp"%>