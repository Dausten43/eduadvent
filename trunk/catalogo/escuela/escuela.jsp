<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="escuelaLista" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="CatUnionU" scope="page" class="aca.catalogo.CatUnionLista"/>

<script>
	function Borrar( EscuelaId , UnionId ){
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
	  		document.location="accion.jsp?Accion=4&EscuelaId="+EscuelaId+"&unionId="+UnionId;
	  	}
	}
</script>

<%
	ArrayList<aca.catalogo.CatUnion> uniones = CatUnionU.getListAll(conElias, "ORDER BY 1");

	String unionId = request.getParameter("unionId");
	if(unionId==null){
		if(uniones.size()>0){
			unionId = uniones.get(0).getUnionId();	
		}
	}

	ArrayList<aca.catalogo.CatEscuela> lisEscuela	= escuelaLista.getListAll(conElias," WHERE (SELECT UNION_ID FROM CAT_ASOCIACION WHERE ASOCIACION_ID = CAT_ESCUELA.ASOCIACION_ID) = "+unionId+" ORDER BY ESCUELA_NOMBRE");
%>

<div id="content">
	<h2><fmt:message key="catalogo.ListadoDeEsc" /></h2> 

	<form action="" name="forma">	
		<div class="well" style="overflow:hidden;">
			<a class="btn btn-primary" href="accion.jsp?Accion=1&unionId=<%=unionId %>"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>&nbsp;
	 		<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar"/>" id="buscar">
	 
	 		<select name="unionId" id="unionId" onchange="document.forma.submit()">
	 		<%for(aca.catalogo.CatUnion union: uniones){%>
	 			<option value="<%=union.getUnionId() %>"  <%if(union.getUnionId().equals(unionId))out.print("selected"); %>><%=union.getUnionNombre() %></option>
	 		<%}%>
	 		</select>
		</div>
	</form>

	<table class="table table-striped table-condensed table-bordered" id="table">
		<thead>
			<tr> 
				<th width="10%"><fmt:message key="aca.Operacion" /></th>
				<th width="5%"><fmt:message key="aca.Id" /></th>
				<th width="30%"><fmt:message key="aca.Nombre" /></th>
				<th width="30%"><fmt:message key="catalogo.Asociacion" /></th>
				<th width="30%"><fmt:message key="aca.Direccion" /></th>
				<th width="30%"><fmt:message key="aca.Telefono" /></th>
				<th width="30%"><fmt:message key="aca.Parametros" /></th>
			</tr>
		</thead>		  
		<%for (aca.catalogo.CatEscuela escuela : lisEscuela){%>
  			<tr> 
    			<td> 
      				<a class="icon-pencil" href="accion.jsp?Accion=5&unionId=<%=unionId %>&EscuelaId=<%=escuela.getEscuelaId()%>&editar=S"></a> 
      				<a class="icon-remove" href="javascript:Borrar('<%=escuela.getEscuelaId()%>', '<%=unionId%>')"></a> 
    			</td>
    			<td><%=escuela.getEscuelaId()%></td>
    			<td><%=escuela.getEscuelaNombre()%></td>
    			<td><%= aca.catalogo.CatAsociacion.getNombre(conElias,  escuela.getAsociacionId()) %></td>
    			<td><%=escuela.getDireccion()%></td>
    			<td><%=escuela.getTelefono()%></td>
    			<td><a href="parametros.jsp?escuela=<%=escuela.getEscuelaId() %>&unionId=<%=unionId%>"><fmt:message key="aca.Config" /></a></td>
  			</tr>
  		<%}%>
	</table>
</div>

<link rel="stylesheet" href="../../js-plugins/tablesorter/themes/blue/style.css" />
<script src="../../js-plugins/tablesorter/jquery.tablesorter.js"></script>

<script src="../../js/search.js"></script>
<script>

	$('#table').tablesorter();

	$('#buscar').search({table:$("#table")});
	
</script>

<%@ include file= "../../cierra_elias.jsp" %>
