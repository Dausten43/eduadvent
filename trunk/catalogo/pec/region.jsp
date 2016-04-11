<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="EstadoLista" scope="page" class="aca.catalogo.CatEstadoLista"/>
<jsp:useBean id="RegionL" scope="page" class="aca.catalogo.CatRegionLista"/>
<head>
<script>
	function Borrar( regionId, PaisId ){
		if(confirm("<fmt:message key="js.Confirma" />")==true){
	  		document.location="accion_r.jsp?Accion=4&RegionId="+regionId+"&PaisId="+PaisId;
	  	}
	}
</script>
</head>
<%
	String strPaisId			= request.getParameter("PaisId");
	ArrayList lisEstado			= EstadoLista.getArrayList(conElias, strPaisId, "ORDER BY ESTADO_NOMBRE");
	ArrayList lisRegion			= RegionL.getListAll(conElias, strPaisId, "ORDER BY REGION_NOMBRE");
	
	String estadoId				= request.getParameter("EstadoId");
%>
<body>
<div id= "content">
    <h2>Lista de Regiones</h2>
    <div class="well" style="overflow:hidden;">
	<a class="btn btn-primary" href="pais.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>&nbsp; <a href="accion_r.jsp?Accion=1&PaisId=<%=strPaisId%>" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a> 
	</div>
		

  <table width="60%" align="center" class="table table-condensed">
  <tr> 
    <th width="17%"><fmt:message key="aca.Operacion" /></th>
    <th width="9%">#</th>
    <th width="74%">Region</th>
  </tr>
<%
	for (int i=0; i< lisRegion.size(); i++){
		aca.catalogo.CatRegion region = (aca.catalogo.CatRegion) lisRegion.get(i);
		if(region.getPaisId().equals(strPaisId)){
%>  
  <tr> 
    <td align="center">
	  <a class="icon-pencil" href="accion_r.jsp?Accion=5&regionId=<%=region.getRegionId()%>&PaisId=<%=region.getPaisId()%>">
	  </a>
	  <a class="icon-remove" href="javascript:Borrar('<%=region.getRegionId()%>','<%=region.getPaisId()%>')">
	  </a>
	</td>
    <td align="center"><%=region.getRegionId()%></td>
    <td><%=region.getRegionNombre()%></td>
  </tr>
<%
	}
}	
	RegionL	 		= null;
	lisRegion			= null;
%>  
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
