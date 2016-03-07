<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="BarrioLista" scope="page" class="aca.catalogo.CatBarrioLista"/>
<head>
	<script>
		function Borrar( PaisId, EstadoId, CiudadId, BarrioId ){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
		  		document.location="accion_b.jsp?Accion=4&PaisId="+PaisId+"&EstadoId="+EstadoId+"&CiudadId="+CiudadId+"&BarrioId="+BarrioId;
		  	}
		}
	</script>

<%
	String strPaisId				= request.getParameter("PaisId");
	String strEstadoId				= request.getParameter("EstadoId");
	String strCiudadId				= request.getParameter("CiudadId");
	
	// Lista de barrios en una ciudad
	ArrayList<aca.catalogo.CatBarrio> lisBarrio				= BarrioLista.getArrayList(conElias, strPaisId, strEstadoId, strCiudadId, " ORDER BY BARRIO_NOMBRE");
%>
</head>
<body>
<div id= "content">
  <h2><fmt:message key="catalogo.ListadoDeCorregimientos" /></h2> 
  <div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="ciudad.jsp?PaisId=<%=strPaisId %>&EstadoId=<%=strEstadoId%>&CiudadId=<%=strCiudadId%>">
		  <i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>&nbsp;
		<a class="btn btn-primary" href="accion_b.jsp?Accion=1&PaisId=<%=strPaisId%>&EstadoId=<%=strEstadoId%>&CiudadId=<%=strCiudadId%>">
		  <i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a>	
  </div>
  <table class="table table-condensed">
  <tr> 
    <th width="17%"><fmt:message key="aca.Operacion" /></th>
    <th width="9%">#</th>
    <th width="74%"><fmt:message key="aca.Corregimiento" /></th>
  </tr>
<%
	for (int i=0; i< lisBarrio.size(); i++){
		aca.catalogo.CatBarrio barrio = (aca.catalogo.CatBarrio) lisBarrio.get(i);
		if(barrio.getPaisId().equals(strPaisId) && barrio.getEstadoId().equals(strEstadoId)){
%>  
  <tr> 
    <td align="center">
	  <a class="icon-pencil" href="accion_b.jsp?Accion=5&BarrioId=<%=barrio.getBarrioId()%>&CiudadId=<%=barrio.getCiudadId()%>&EstadoId=<%=barrio.getEstadoId()%>&PaisId=<%=barrio.getPaisId()%>">
	  </a>
	  <a class="icon-remove" href="javascript:Borrar ('<%=barrio.getPaisId()%>','<%=barrio.getEstadoId()%>','<%=barrio.getCiudadId()%>','<%=barrio.getBarrioId()%>')">
	  </a>
	</td>
    <td align="center"><%=barrio.getBarrioId()%></td>
    <td><%=barrio.getBarrioNombre()%></td>
	</tr>
<%
		}
	}

	lisBarrio			= null;
%>  
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
