<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file="../../seguro.jsp"%>

<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioMenu" scope="page" class="aca.usuario.UsuarioMenu"/>
<jsp:useBean id="moduloOpcionLista" scope="page" class="aca.menu.ModuloOpcionLista"/>
<head>
	<script>
	
		function GrabarMenu(){			
			document.frmMenu.Accion.value="1";
			document.frmMenu.submit();
		}
		
	</script>
</head>
<%
	String strAccion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String strCodigoId		= (String) session.getAttribute("codigoReciente");
	String tipo				= "";
	String nombreUsuario 	= "";
	
	ArrayList<aca.menu.ModuloOpcion> lisModuloOpcion	= new ArrayList<aca.menu.ModuloOpcion>();
	if(aca.usuario.Usuario.esSuper(conElias, strCodigoId)){
		lisModuloOpcion		= moduloOpcionLista.getListaActivosSuper(conElias, "ORDER BY MODULO_OPCION, MODULO_NOMBRE(MODULO_ID), NOMBRE_OPCION");
	}else{
		lisModuloOpcion		= moduloOpcionLista.getListaActivosAdmin(conElias, "ORDER BY MODULO_OPCION, MODULO_NOMBRE(MODULO_ID), NOMBRE_OPCION");
	}	
		
	String opcionesUsuario	= "";
	String nombreOpcion		= "";
	String nombreModulo		= "X";
	String temp 			= "X";
	String strCheckOpcion	= "";
	String strCheck			= "";
	
	int i					= 0;
	int numCont				= 0;
	int numColor			= 0;
	int numAccion			= 0;
	
	usuario.setCodigoId(strCodigoId);
	if (usuario.existeReg(conElias)){
		usuario.mapeaRegId(conElias, strCodigoId);
		tipo = aca.usuario.UsuarioTipo.getTipoNombre(conElias,Integer.parseInt(usuario.getTipoId() ) );
		if (usuario.getTipoId().equals("1")){
			nombreUsuario = aca.alumno.AlumPersonal.getNombre(conElias, strCodigoId,"NOMBRE");
		}else if (usuario.getTipoId().equals("2")){
			nombreUsuario = aca.empleado.EmpPersonal.getNombre(conElias, strCodigoId,"NOMBRE");
		}else{
			tipo = "Padre";
			nombreUsuario = "Padre";
		}
	}	 
	
	
	numAccion 	= Integer.parseInt(strAccion);
	
	switch (numAccion){
		case 1: { // Graba el password
			
			String checkOpcion 	= "N";			
			
			for (i=0; i<lisModuloOpcion.size(); i++){
				aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) lisModuloOpcion.get(i);
				
				checkOpcion 	= request.getParameter("Opcion"+i)==null?"N":request.getParameter("Opcion"+i);
				
				if (checkOpcion.equals("S")){
					usuarioMenu.setCodigoId(strCodigoId);
					usuarioMenu.setOpcionId(op.getOpcionId());					
					
					if (usuarioMenu.existeReg(conElias)==false){						
						if (usuarioMenu.insertReg(conElias)){
							// Se grabó
						}
					}
					
				}else{					
					usuarioMenu.setCodigoId(strCodigoId);
					usuarioMenu.setOpcionId(op.getOpcionId());
					if (usuarioMenu.existeReg(conElias)){						
						if (usuarioMenu.deleteReg(conElias)){							
							// Se borró
						}
					}
				}
			}
			break;
		}
	}	
%>
<body>

<div id="content">

	<h2><fmt:message key="privilegios.PrivilegiosAplicaciones" /> ( <small><%=nombreUsuario%> | <%=strCodigoId%></small> )</h2>	
	<div class="well">
		<a href="usuario.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

<form action="menu.jsp" method="post" name="frmMenu">
<input name="Accion" type="hidden">
  
<%	
	// Privilegios del usuario
	opcionesUsuario = aca.usuario.UsuarioMenu.getUsuarioOpcion(conElias, strCodigoId);

	for (i=0; i<lisModuloOpcion.size(); i++){ 
		aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) lisModuloOpcion.get(i);

		if(opcionesUsuario.indexOf("-"+op.getOpcionId()+"-") != -1) strCheckOpcion = "checked"; else strCheckOpcion = " ";
		usuarioMenu.setCodigoId(strCodigoId);
		usuarioMenu.setOpcionId(op.getOpcionId());
		if (usuarioMenu.existeReg(conElias)){
			usuarioMenu.mapeaRegId(conElias,strCodigoId,op.getOpcionId());
		}
		if (!op.getModuloId().equals(temp)){ 
		    nombreModulo= aca.menu.Modulo.getModuloNombre(conElias, op.getModuloId() );
		    temp 		= op.getModuloId();
		    
		    if(i>0)out.print("</table></div>");
%>
  			<div class="alert alert-info" style="background:white;">					  
			  	<h5><%=nombreModulo%></h5>
			  	<a onclick="jQuery('.selecciona<%=op.getModuloId()%>').prop('checked',true)" class="btn btn-mini">Todos</a>&nbsp;&nbsp;
			  	<a onclick="jQuery('.selecciona<%=op.getModuloId()%>').prop('checked',false)" class="btn btn-mini">Ninguno</a>
			  	
			  	<table class="table table-condensed">
<%		} 	%>	
					  <tr>						    
					    <td align="left"> 
						  <input class="selecciona<%=op.getModuloId()%>" name="Opcion<%=i%>" type="checkbox" value="S" <%=strCheckOpcion%>>
							<%=op.getNombreOpcion()%> - [<%=op.getOpcionId()%>]
						  <input name="ModuloId<%=i%>" type="hidden" id="ModuloId<%=i%>" value="<%=op.getModuloId()%>">
						  <input name="OpcionId<%=i%>" type="hidden" id="OpcionId<%=i%>" value="<%=op.getOpcionId()%>">
						</td>
					</tr>		
<%		numCont++;
	} //fin del for opciones
%>
				</table>
			</div>
  
	  <input name="NumOpciones" type="hidden" value="<%=numCont%>">
	  
	<div class="well">
		<a href="javascript:GrabarMenu()" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
	</div>
	
</form>


</div>

</body>
<%	
	lisModuloOpcion		= null;
%>
<%@ include file= "../../cierra_elias.jsp" %>
