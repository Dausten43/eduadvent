<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="EstadoLista" scope="page" class="aca.catalogo.CatEstadoLista"/>
<head>
<script>
	function Borrar( EstadoId, PaisId ){
		if(confirm("<fmt:message key="js.Confirma" />")==true){
	  		document.location="accion_e.jsp?Accion=4&EstadoId="+EstadoId+"&PaisId="+PaisId;
	  	}
	}
</script>
</head>
<%
	String strPaisId			= request.getParameter("PaisId");
	ArrayList lisEstado			= new ArrayList();	
	lisEstado	 				= EstadoLista.getArrayList(conElias, strPaisId, "ORDER BY ESTADO_NOMBRE");
	
	String estadoId				= request.getParameter("EstadoId");
%>
<body>
<div id= "content">
    <h2><fmt:message key="catalogo.ListadoDeEdo" /> </h2>
    <div class="well" style="overflow:hidden;">
	<a class="btn btn-primary" href="pais.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>&nbsp; <a href="accion_e.jsp?Accion=1&PaisId=<%=strPaisId%>" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a> 
	</div>
		

  <table width="60%" align="center" class="table table-condensed">
  <tr> 
    <th width="17%"><fmt:message key="aca.Operacion" /></th>
    <th width="9%">#</th>
    <th width="74%"><fmt:message key="aca.Estado" /></th>
  </tr>
<%
	for (int i=0; i< lisEstado.size(); i++){
		aca.catalogo.CatEstado estado = (aca.catalogo.CatEstado) lisEstado.get(i);
		if(estado.getPaisId().equals(strPaisId)){
%>  
  <tr> 
    <td align="center">
	  <a class="icon-pencil" href="accion_e.jsp?Accion=5&EstadoId=<%=estado.getEstadoId()%>&PaisId=<%=estado.getPaisId()%>">
	  </a>
	  <a class="icon-remove" href="javascript:Borrar('<%=estado.getEstadoId()%>','<%=estado.getPaisId()%>')">
	  </a>
	</td>
    <td align="center"><%=estado.getEstadoId()%></td>
    <td>
      <a href="ciudad.jsp?PaisId=<%=estado.getPaisId()%>&EstadoId=<%=estado.getEstadoId()%>">
		<%=estado.getEstadoNombre()%>
	  </a>
	</td>
  </tr>
<%
	}
}	
	EstadoLista	 		= null;
	lisEstado			= null;
%>  
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
