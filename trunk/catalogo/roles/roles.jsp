<%@page import="aca.menu.Modulo"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="rolL" scope="page" class="aca.rol.RolLista"/>
<jsp:useBean id="rol" scope="page" class="aca.rol.Rol"/>
<jsp:useBean id="moduloOpcionLista" scope="page" class="aca.menu.ModuloOpcionLista"/>

<%
	String nombre 	= request.getParameter("rolNombre")==null?"-":request.getParameter("rolNombre");
	String rolId 	= request.getParameter("RolId")==null?"-":request.getParameter("RolId");
	String accion 	= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	
	ArrayList<aca.menu.ModuloOpcion>lisModuloOpcion = moduloOpcionLista.getListaActivosSuper(conElias, "ORDER BY MODULO_OPCION, MODULO_NOMBRE(MODULO_ID), NOMBRE_OPCION");
	
	String opcionesUsuario	= "";
	String temp 			= "X";
	String nombreModulo		= "X";
	String strCheckOpcion	= "";
	String strCheck			= "";
	int numCont				= 0;
%>

	<script>
		function Agregar(){
			document.frmrol.Accion.value="1";
		}
		
		function Borrar(id){
			document.frmrol.RolId.value=id;
			document.frmrol.submit();
		}
		
		function Modificar(id){
			document.frmrol.Accion.value="3";
			document.frmrol.RolId.value=id;
		}
	</script>

<%	
	if(accion.equals("1") && !nombre.equals("-")){
		rol.setRolId(rol.maximoReg(conElias));
		rol.setRolNombre(nombre);
		if(rol.insertReg(conElias)){
			conElias.commit();
		}
	}else if(accion.equals("2")){
		rol.setRolId(rolId);
		rol.mapeaRegId(conElias);
		if(rol.deleteReg(conElias)){
			conElias.commit();
		}
	}else if(accion.equals("3")){
		rol.setRolId(rolId);
		rol.setRolNombre(nombre);
		if(rol.updateReg(conElias)){
			conElias.commit();
		}
	}
	
	ArrayList<aca.rol.Rol> roles		= rolL.getListAll(conElias, "");
%>

<div id="content">
	<h1>Roles</h1>
	<div class="row-fluid">
    <div class="well well-small">  
		<!-- Trigger the modal with a button -->
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="javascript:changeValue(''); javascript:Agregar(''); javascript:changetitulo(1)"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /> </button>
		<!-- Modal -->
		<div id="myModal" class="modal fade" role="dialog">
			<div class="modal-dialog">
				<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title"><span id="titulo"><fmt:message key="aca.Agregar"/></span> <fmt:message key="aca.Rol"/></h4>
					</div>
					<div class="modal-body">
						<form action="roles.jsp" id = "frmrol" name="frmrol" method="post" >
							<input type = "text" placeholder="Nombre del nuevo rol" name = "rolNombre" id="rolNombre" required="required" oninvalid="this.setCustomValidity('<fmt:message key="aca.CamposRequeridos"/>')"/>
							<input type="hidden" name="Accion" id="Accion"/>
							<input type="hidden" name="RolId" id="RolId" value="<%=rol.getRolId()%>"/>
								<h5>Elija los privilegios por categoria a asiganar</h5>
								<%
									for (int i = 0; i < lisModuloOpcion.size(); i++) {
										aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) lisModuloOpcion.get(i);
										
										/*if(opcionesUsuario.indexOf("-"+op.getOpcionId()+"-") != -1) strCheckOpcion = "checked"; else strCheckOpcion = " ";
										usuarioMenu.setCodigoId(strCodigoId);
										usuarioMenu.setOpcionId(op.getOpcionId());
										if (usuarioMenu.existeReg(conElias)){
											usuarioMenu.mapeaRegId(conElias,strCodigoId,op.getOpcionId());
										}*/
										
										if(!op.getModuloId().equals(temp)){
											nombreModulo = aca.menu.Modulo.getModuloNombre(conElias, op.getModuloId());
											temp = op.getModuloId();
											
											if(i > 0)
												out.print("</table></div>");
								%>
									<div class="alert alert-info" style="background:white">
										<h5><%=nombreModulo %></h5>
										<table class="table table-condensed">	
								<%
										}
								%>
										<tr>
											<td align="left">
											<input name="Opcion<%=i %>" type="checkbox" value="S" <%=strCheckOpcion %>>
											<%=op.getNombreOpcion() %> - [<%=op.getOpcionId() %>]
											<input name="ModuloId<%=i%>" type="hidden" id="ModuloId<%=i%>" value="<%=op.getModuloId()%>">
											<input name="OpcionId<%=i%>" type="hidden" id="OpcionId<%=i%>" value="<%=op.getOpcionId()%>">
											</td>
										</tr>
								<%
										numCont ++;
									}
								%>
										</table>
									</div>
						</form>  
					</div>
					<div class="modal-footer">
						 <button type="submit" form = "frmrol" class="btn btn-default" value="submit" onclick="javascript:Agregar()"><fmt:message key="boton.Guardar"/> </button>
					</div>
				</div>	
			</div>
		</div>
	</div>
	</div>

	<table class="table table-striped table-bordered">
	<tbody>
	<th width="2%">#</th>
	<th width="4%"><fmt:message key="aca.Operacion"/> </th>
	<th>Nombre</th>
<%
	for(int i = 0; i < roles.size(); i ++){
%>
		<tr>
			<td><%= i + 1 %></td>
			<td>
				<a id="modificar" onclick="javascript:changeValue('<%= roles.get(i).getRolNombre()%>'); javascript:Modificar('<%= roles.get(i).getRolId() %>'); javascript:changetitulo(2)" class="icon-pencil" data-toggle="modal" data-target="#myModal" href=""> </a> 
				<a id="eliminar" href="javascript:Borrar(<%= roles.get(i).getRolId()%>)" onclick="javascript:confirmDelete()" class="icon-remove"></a> 
			</td>
			<td><%= roles.get(i).getRolNombre() %></td>
		</tr>
<%	
	}
%>
	</tbody>
	</table>

	<script>
	   function changeValue(rolNombre){
	     document.getElementById('rolNombre').value=rolNombre;
	    }
	   function changetitulo(x){
		   if(x == 1){
		   	document.getElementById('titulo').innerHTML='<fmt:message key="aca.Agregar"/>';
		   }else{
			   document.getElementById('titulo').innerHTML='<fmt:message key="boton.Modificar"/>';
		   }
	   }
	   function confirmDelete(x){
		    if (confirm("Seguro que quiere eliminar el rol?") == true) {
		    	document.frmrol.Accion.value="2";
		    } else {
		    	document.frmrol.Accion.value="";
		    }
	   }
	</script>
</div>
<%@ include file= "../../cierra_elias.jsp" %>