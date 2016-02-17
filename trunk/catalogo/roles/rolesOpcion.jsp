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
	
	

	
	String opcionesUsuario	= "";
	String temp 			= "X";
	String nombreModulo		= "X";
	String strCheckOpcion	= "";
	String strCheck			= "-";
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
	</script>

<%	
	if(accion.equals("1") && !nombre.equals("")){
		rol.setRolId(rol.maximoReg(conElias));
		rol.setRolNombre(nombre);
		conElias.setAutoCommit(false);
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
		conElias.setAutoCommit(true);
		
	}else if(accion.equals("2")){
		rol.setRolId(rolId);
		rol.mapeaRegId(conElias);
		if(rol.deleteReg(conElias)){
			//
		}
	}else if(accion.equals("3")){
		rol.setRolId(rolId);
		conElias.setAutoCommit(false);
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
		conElias.setAutoCommit(true);
	}
	
	ArrayList<aca.rol.Rol> roles		= rolL.getListAll(conElias, "");
	java.util.HashMap<String, String> mapRolOpcion = rolOpL. mapOpUsuarios(conElias, rolId);

%>

<div id="content">
	<h1>Roles <small>( <%=aca.rol.Rol.getNombre(conElias, rolId)%> )</small></h1>
		
	 	<form action="rolesOpcion.jsp?RolId=<%=rolId %>" id = "frmrol" name="frmrol" method="post">
	 		  <div class="well">
	 		  		<a class="btn btn-primary" href="roles.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	 		  <div class="form-group" style="display:inline-block;">
			    <label for="nombre" style="display:inline-block;">&nbsp;Nombre Rol: </label>
			    <input type="text" class="form-control" id="rolNombre" name="rolNombre" required value="<%=aca.rol.Rol.getNombre(conElias, rolId)==null?"":aca.rol.Rol.getNombre(conElias, rolId)%>">
			  	<button type="submit" form = "frmrol" class="btn btn-primary btn-lg" value="submit"><fmt:message key="boton.Guardar"/> </button>
			  </div>
			  </div>
		<input type="hidden" name="Accion" id="Accion" value="3"/>
<% 		for (int i = 0; i < lisModuloOpcion.size(); i++) {
		aca.menu.ModuloOpcion op = (aca.menu.ModuloOpcion) lisModuloOpcion.get(i);
		
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
		
		if(mapRolOpcion.containsKey(rolId+op.getOpcionId())){
			strCheckOpcion = mapRolOpcion.get(rolId+op.getOpcionId());
		}
%>
		<tr>
			<td align="left">
			<input name="Opcion<%=i %>" type="checkbox" value="S" <%=strCheckOpcion.equals(op.getOpcionId())?"checked":"" %>>
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
		</form>
		</div>
		<div class="well">
	 		<button type="submit" form = "frmrol" class="btn btn-default" value="submit"><fmt:message key="boton.Guardar"/> </button>
		</div>
<%@ include file= "../../cierra_elias.jsp" %>