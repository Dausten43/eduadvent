<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CiudadLista" scope="page" class="aca.catalogo.CatCiudadLista"/>
<head>
	<script>
		function Borrar( PaisId, EstadoId, CiudadId ){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
		  		document.location="accion_c.jsp?Accion=4&PaisId="+PaisId+"&EstadoId="+EstadoId+"&CiudadId="+CiudadId;
		  	}
		}
	</script>

<%
	String strPaisId				= request.getParameter("PaisId");
	String strEstadoId				= request.getParameter("EstadoId");
	ArrayList lisCiudad				= new ArrayList();	
	lisCiudad	 					= CiudadLista.getArrayList(conElias, strPaisId, strEstadoId, " ORDER BY CIUDAD_NOMBRE");
%>
</head>
<body>
<div id= "content">
  <h2><fmt:message key="catalogo.ListadoDeCiudad" /></h2> 
  <div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="estado.jsp?PaisId=<%=strPaisId %>&EstadoId=<%=strEstadoId %>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>&nbsp;<a class="btn btn-primary" href="accion_c.jsp?Accion=1&PaisId=<%=strPaisId%>&EstadoId=<%=strEstadoId%>"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a> 
	
  </div>
  <table width="40%" align="center" class="table table-condensed">
  <tr> 
    <th width="17%"><fmt:message key="aca.Operacion" /></th>
    <th width="9%">#</th>
    <th width="74%"><fmt:message key="aca.Ciudad" /></th>
  </tr>
<%
	for (int i=0; i< lisCiudad.size(); i++){
		aca.catalogo.CatCiudad ciudad = (aca.catalogo.CatCiudad) lisCiudad.get(i);
		if(ciudad.getPaisId().equals(strPaisId) && ciudad.getEstadoId().equals(strEstadoId)){
%>  
  <tr> 
    <td align="center">
	  <a class="icon-pencil" href="accion_c.jsp?Accion=5&CiudadId=<%=ciudad.getCiudadId()%>&EstadoId=<%=ciudad.getEstadoId()%>&PaisId=<%=ciudad.getPaisId()%>">
	  </a>
	  <a class="icon-remove" href="javascript:Borrar ('<%=ciudad.getPaisId()%>','<%=ciudad.getEstadoId()%>','<%=ciudad.getCiudadId()%>')">
	  </a>
	</td>
    <td align="center"><%=ciudad.getCiudadId()%></td>
    <td><%=ciudad.getCiudadNombre()%></td>
	</tr>
<%
		}
	}
		
	CiudadLista	 		= null;
	lisCiudad			= null;
%>  
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
