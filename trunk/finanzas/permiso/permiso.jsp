<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Permiso" scope="page" class="aca.fin.FinPermiso"/>
<jsp:useBean id="permisoLista" scope="page" class="aca.fin.FinPermisoLista"/>
<% 
	String escuelaId = (String) session.getAttribute("escuela");
	String numAccion		= request.getParameter("Accion")==null?"1":request.getParameter("Accion");
	String codigoId			= request.getParameter("codigoId");
	String folio			= request.getParameter("folio");
	String resultado		= "";

	if(numAccion.equals("1")){
		Permiso.setCodigoId(codigoId);
		Permiso.setFolio(folio);
		
		if(Permiso.existeReg(conElias)){
			if(Permiso.deleteReg(conElias)){
				resultado = "Eliminado";
			}
		}
	pageContext.setAttribute("resultado", resultado);
	}

	ArrayList<aca.fin.FinPermiso> lisPermiso	= permisoLista.getListAll(conElias, "ORDER BY FOLIO");
%>

<div id="content">
	<h2><fmt:message key="permisos.Permiso" /><small>( <%=escuelaId%> - <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> )</small></h2> 
   
   <div class="well">
      <a class="btn btn-primary" href="accion.jsp"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
   	
   </div>
   <% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
    
	<form id="forma" name="forma" action="accion.jsp" >
		<table class="table table-condensed table-bordered table-striped">
	  		<tr>
	  			<th>#</th>
	    		<th><fmt:message key="aca.Accion" /></th>
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
					System.out.println(permiso.getFecha_fin());
			%>
	  				<tr>
	  					<td><%=++cont %></td> 
	    				<td>
	      					<a class="icon-pencil" href="accion.jsp?codigoId=<%=permiso.getCodigoId()%>&folio=<%=permiso.getFolio() %>"> </a>
      						<a class="icon-remove" id="del" href="javascript:Elimina('<%=permiso.getCodigoId()%>', '<%=permiso.getFolio() %>');" ></a>
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
	function Elimina(codigoId, folio ){
		if(confirm("<fmt:message key='js.Confirma' />")){
			document.location = "permiso.jsp?Accion=1&codigoId="+codigoId+"&folio="+folio;
		}
	}
</script>

<%@ include file= "../../cierra_elias.jsp" %>