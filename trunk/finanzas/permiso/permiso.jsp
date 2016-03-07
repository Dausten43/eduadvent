<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="permisoLista" scope="page" class="aca.fin.FinPermisoLista"/>
<% 
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	ArrayList<aca.fin.FinPermiso> lisPermiso		= permisoLista.getListAll(conElias, " ");
%>

<div id="content">
	<h2><fmt:message key="aca.Permiso" /><small>( <%=escuelaId%> - <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> )</small></h2> 
   
   <div class="well">
      <a class="btn btn-primary" href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
   </div>
    
	<form id="forma" name="forma" action="accion.jsp" >
		<table class="table table-condensed table-bordered table-striped">
	  		<tr>
	    		<th><fmt:message key="aca.Accion" /></th>
	    		<th>#</th>
	    		<th><fmt:message key="aca.CodigoId" /></th>
	    		<th><fmt:message key="aca.Folio" /></th>    
	    		<th><fmt:message key="aca.FechaInicio" /></th>
	    		<th><fmt:message key="aca.FechaFinal" /></th>
	    		<th><fmt:message key="aca.Estado" /></th>
	    		<th><fmt:message key="aca.Comentario" /></th>
	  		</tr>
	  		<%
	  			int cont = 0;
				for (aca.fin.FinPermiso permiso : lisPermiso){
					cont++;
			%>
	  				<tr> 
	    				<td>
	      					<a class="icon-pencil" href="accion.jsp?Accion=5&CodigoId=<%=permiso.getCodigoId()%>&folio=<%=permiso.getFolio()%>"> </a>
	      					<%if(!aca.fin.FinPermiso.existeSoloCuenta(conElias, cuenta.getCuentaId()) && !aca.fin.FinMovimientos.existeCuentaId(conElias, cuenta.getCuentaId())){%> 
	      						<a class="icon-remove" id="del" href="javascript:Elimina('<%=cuenta.getCuentaId() %>');" ></a>
	      					<%} %>
	    				</td>
	    				<td><%=permiso.getCodigoId() %></td>
	    				<td><%=permiso.getFolio() %></td>    
	    				<td><%=permiso.getFecha_ini() %></td>    
					    <td><%=permiso.getFecha_fin() %></td>
					    <td><%=permiso.getEstado() %></td>
					    <td><%=permiso.getComentario() %></td>
					</tr>
	  		<%
				}	
			%>
		</table>
	</form>
</div>

<script>   
	function Elimina(cuentaId ){
		if(confirm("<fmt:message key='js.Confirma' />")){
			document.location = "accion.jsp?Accion=4&CuentaId="+cuentaId;
		}
	}
</script>

<%@ include file= "../../cierra_elias.jsp" %>