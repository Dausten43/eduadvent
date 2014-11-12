<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="paisLista" scope="page" class="aca.catalogo.CatPaisLista"/>
<jsp:useBean id="RegionL" scope="page" class="aca.catalogo.CatRegionLista"/>
<head>
	<script>
		function Borrar( PaisId ){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
		  		document.location="accion_p.jsp?Accion=4&PaisId="+PaisId;
		  	}
		}
	</script>
<%
	ArrayList lisPais			= new ArrayList();	
	lisPais	 				= paisLista.getListAll(conElias,"ORDER BY PAIS_NOMBRE");
	String escuelaId = (String) session.getAttribute("escuela");
	
%>
	
</head>
<body>
<div id="content">
  
 <h2><fmt:message key="catalogo.ListadoDePais" /></h2>
	<div class="well" style="overflow:hidden;">
 		<a href="accion_p.jsp?Accion=1" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
	</div>	
		
  
  <table width="40%" class="table table-condensed " align="center">
  <tr> 
    <th width="17%"><fmt:message key="aca.Operacion" /></th>
    <th width="9%">#</th>
    <th width="34%"><fmt:message key="aca.Pais" /></th>
    <th width="10%">Region</th>
  </tr>
<%
	for (int i=0; i< lisPais.size(); i++){
		aca.catalogo.CatPais pais = (aca.catalogo.CatPais) lisPais.get(i);
		
		java.util.HashMap<String, aca.catalogo.CatRegion> mapTotal	= RegionL.getTotalSeccionPorPais(conElias);
		String totalRegion = "";
		if(mapTotal.containsKey(pais.getPaisId())){
			totalRegion		= RegionL.getTotalPorPais(conElias, pais.getPaisId());
			
		}else{
			totalRegion		= "-";
		}
%>  
<tr> 
 <td align="center">
	<a class="icon-pencil" href="accion_p.jsp?Accion=5&PaisId=<%=pais.getPaisId()%>">
	<a class="icon-remove" href="javascript:Borrar('<%=pais.getPaisId()%>')"></a>
 </td>
    <td align="center"><%=pais.getPaisId()%></td>
    <td><a href="estado.jsp?PaisId=<%=pais.getPaisId()%>"><%=pais.getPaisNombre()%></a> </td>
    <%if(!totalRegion.equals("-")){ %>
    	<td><a href="region.jsp?PaisId=<%=pais.getPaisId()%>"><%=totalRegion%></a></td>
    <%}else{ %>
    	<td><%=totalRegion%></td>
    <%} %>
  </tr>
<%
	}	
	paisLista		= null;
	lisPais			= null;
%>
   </table>  
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
