<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="rolL" scope="page" class="aca.rol.RolLista"/>
<jsp:useBean id="rol" scope="page" class="aca.rol.Rol"/>


<%
	String nombre 	= request.getParameter("rolNombre")==null?"-":request.getParameter("rolNombre");
	String rolId 	= request.getParameter("RolId")==null?"-":request.getParameter("RolId");
	String accion 	= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	
%>

	<script>
		function Agregar(){
			document.frmrol.Accion.value="1";
		}
		
		function Borrar(id){
			document.frmrol.Accion.value="2";
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
				        <input type = "text" name = "rolNombre" id="rolNombre" required="required" oninvalid="this.setCustomValidity('<fmt:message key="aca.CamposRequeridos"/>')"/>
				        <input type="hidden" name="Accion" id="Accion"/>
				        <input type="hidden" name="RolId" id="RolId" value="<%=rol.getRolId()%>"/>
				      </form>  
				      </div>
				      <div class="modal-footer">
				      	<button type="submit" form = "frmrol" class="btn btn-default" value="submit" ><fmt:message key="boton.Guardar"/> </button>
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
				<a href="javascript:Borrar(<%= roles.get(i).getRolId()%>)" class="icon-remove"></a> 
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
	</script>
</div>
<%@ include file= "../../cierra_elias.jsp" %>