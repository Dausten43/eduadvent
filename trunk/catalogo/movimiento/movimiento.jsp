<%@page import="aca.menu.Modulo"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="TipoMovimientoL" scope="page" class="aca.catalogo.CatTipoMovimientoList"/>
<jsp:useBean id="TipoMovimiento" scope="page" class="aca.catalogo.CatTipoMovimiento"/>

<script>
		function eliminar(tipoMovId) {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
 				location = "movimiento.jsp?Accion=1&tipoMovId=" + tipoMovId;
			}
		}
</script>

<%
	String nombre 			= request.getParameter("nombre")==null?"":request.getParameter("nombre");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	String tipoMovId		= request.getParameter("tipoMovId")==null?"0":request.getParameter("tipoMovId");
	String mensaje  		= "";
	String salto			= "X";

	ArrayList<aca.catalogo.CatTipoMovimiento> movimientos		= TipoMovimientoL.getListAll(conElias, "");
	
	if (accion.equals("1")) {
		
		TipoMovimiento.mapeaRegId(conElias, tipoMovId);
		
		TipoMovimiento.setTipoMovId(tipoMovId);
			
		if (TipoMovimiento.deleteReg(conElias)) {
			mensaje = "Eliminado";
			salto = "movimiento.jsp";
		} else {
			mensaje = "NoElimino";
		}
	}

%>

<div id="content">
	<h1>Tipo movimientos</h1>
	
	<% 
	if (mensaje.equals("Eliminado") || mensaje.equals("Modificado") || mensaje.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${mensaje}" /></div>
  	<% }else if(!mensaje.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${mensaje}" /></div>
  	<%} %>
		
	 <form id="forma" name="forma" action="movimiento.jsp" method="post">
	 	<div class="well">
			<a class="btn btn-primary btn-mobile" href="accion.jsp"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
		</div>
	</form>

	 	
	<table class="table table-striped table-bordered">
		<th width="5%"><fmt:message key="aca.Accion" /></th>
		<th width="2%">#</th>
		<th>Nombre</th>
		<th>Tipo</th>
<%
	for(int i = 0; i < movimientos.size(); i ++){
%>
		<tr>
			<td>
				<a href="accion.jsp?tipoMovId=<%=movimientos.get(i).getTipoMovId()%>"><i class="icon-pencil"></i></a>
				<a id="borrar" name="borrar" onclick="eliminar('<%=movimientos.get(i).getTipoMovId()%>');"><i class="icon-remove"></i></a>
			</td>
			<td><%= i + 1 %></td>
			<td><%=movimientos.get(i).getNombre()%></td>
			<%if(movimientos.get(i).getTipo().equals("C")){%>
			<td><%="Caja"%></td>
			<%}else {%>
			<td><%="Sistema"%></td>
			<%}%>
			
		</tr>
<%	
	}
%>
	</table>
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>