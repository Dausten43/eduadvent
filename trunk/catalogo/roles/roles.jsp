<%@page import="aca.menu.Modulo"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="rolL" scope="page" class="aca.rol.RolLista"/>
<jsp:useBean id="rol" scope="page" class="aca.rol.Rol"/>
<jsp:useBean id="rolOp" scope="page" class="aca.rol.RolOpcion"/>
<jsp:useBean id="rolOpL" scope="page" class="aca.rol.RolOpcionLista"/>
<jsp:useBean id="moduloOpcionLista" scope="page" class="aca.menu.ModuloOpcionLista"/>


<%
	String nombre 	= request.getParameter("rolNombre")==null?"":request.getParameter("rolNombre");
	String rolId 	= request.getParameter("RolId")==null?"0":request.getParameter("RolId");
	String accion 	= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	
	ArrayList<aca.menu.ModuloOpcion>lisModuloOpcion = moduloOpcionLista.getListaActivosSuper(conElias, "ORDER BY MODULO_OPCION, MODULO_NOMBRE(MODULO_ID), NOMBRE_OPCION");
	ArrayList<aca.rol.RolOpcion> rolOpLista = rolOpL.getList(conElias, rolId, "");
	
	java.util.HashMap<String, String> mapRolOpcion = rolOpL. mapOpUsuarios(conElias, rolId);

	
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
	if(accion.equals("1") && !nombre.equals("")){
		rol.setRolId(rol.maximoReg(conElias));
		rol.setRolNombre(nombre);
		String checkOpcion 	= "N";
		if (!rol.existeReg(conElias)){
			if (rol.insertReg(conElias)){
				for (int i=0; i<lisModuloOpcion.size(); i++){
					aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) lisModuloOpcion.get(i);
					checkOpcion 	= request.getParameter("Opcion"+i)==null?"N":request.getParameter("Opcion"+i);
					if (checkOpcion.equals("S")){
						rolOp.setRolId(rol.getRolId());
						rolOp.setopcionId(op.getOpcionId());
						
						if (!rolOp.existeReg(conElias)){
							if (rolOp.insertReg(conElias)){
								conElias.commit();
							}else{
								conElias.rollback();
							}
						}
					}
				}
			}else{
				conElias.rollback();
			}
		}

	}else if(accion.equals("2")){
		rol.setRolId(rolId);
		rol.mapeaRegId(conElias);
		if(rol.deleteReg(conElias)){
			for(int i=0; i<rolOpLista.size(); i++){
				rolOp.setRolId(rolOpLista.get(i).getRolId());
				rolOp.mapeaRegId(conElias);
				if(rolOp.deleteReg(conElias)){
				}else{
					conElias.rollback();
				}
			}
			
		}
	}else if(accion.equals("3")){
		rol.setRolId(rolId);
		
		rol.mapeaRegId(conElias);
		rol.setRolNombre(nombre);
		String checkOpcion	= "N";
		if(rol.existeReg(conElias)){
			if(rol.updateReg(conElias)){
				for(int i = 0; i < lisModuloOpcion.size(); i++){
					aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) lisModuloOpcion.get(i);
					checkOpcion 	= request.getParameter("Opcion"+i)==null?"N":request.getParameter("Opcion"+i);
					if(checkOpcion.equals("S")){
						rolOp.setRolId(rol.getRolId());
						rolOp.setopcionId(op.getOpcionId());
						
						if (!rolOp.existeReg(conElias)){
							if (rolOp.insertReg(conElias)){
								conElias.commit();
							}else{
								conElias.rollback();
							}
						}
					}else{
						rolOp.setRolId(rol.getRolId());
						rolOp.setopcionId(op.getOpcionId());
						
						if (rolOp.existeReg(conElias)){
							if (rolOp.deleteReg(conElias)){
								conElias.commit();
							}else{
								conElias.rollback();
							}
						}
					}
				}
			}
		}
	}
	
	ArrayList<aca.rol.Rol> roles		= rolL.getListAll(conElias, "");
	
%>

<div id="content">
	<h1>Roles</h1>
	<div class="well">
		
	 	<form action="roles.jsp" id = "frmrol" name="frmrol" method="post">
	 	
	 		  <div class="form-group">
			    <label for="nombre">Nombre Rol</label>
			    <input type="text" class="form-control" id="rolNombre" name="rolNombre">
			  </div>
	 		<button type="submit" form = "frmrol" class="btn btn-default" value="submit"><fmt:message key="boton.Guardar"/> </button>
	 		<input type="hidden" name="Accion" id="Accion" value="1"/>
	 		<input type="hidden" name="RolId" id="RolId" value="<%=rolId%>"/>
			
		</form>
	</div>

	 	
	<table class="table table-striped table-bordered">
	<tbody>
	<th width="2%">#</th>
	<th width="4%"><fmt:message key="aca.Operacion"/> </th>
	<th>Nombre</th>
	<th>Cantidad de permisos</th>
<%
	
	for(int i = 0; i < roles.size(); i ++){
		java.util.HashMap<String, String> cantidadPermisosDeRol = rolOpL. mapOpUsuarios(conElias, roles.get(i).getRolId());
%>
		<tr>
			<td><%= i + 1 %></td>
			<td>
				<a id="modificar" class="icon-pencil" href="rolesOpcion.jsp?RolId=<%=roles.get(i).getRolId()%>"> </a> 
				<a id="eliminar" class="icon-remove" href="javascript:confirmDelete('<%=roles.get(i).getRolId()%>')" ></a> 
			</td>
			<td><%= roles.get(i).getRolNombre() %></td>
			<td><%= cantidadPermisosDeRol.size() %></td>
		</tr>
<%	
	}
%>
	</tbody>
	</table>
	<script>
	function confirmDelete(rolId){
		if(confirm("¿Seguro que desea eliminar el rol?") == true){
			document.location = "roles.jsp?Accion=2&RolId=" + rolId;
		}else{
			document.frmrol.Accion.value="";
		}
   }
	</script>
</div>
<%@ include file= "../../cierra_elias.jsp" %>