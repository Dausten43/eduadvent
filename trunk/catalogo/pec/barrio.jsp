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
  <h2><fmt:message key="catalogo.ListadoDeCiudad" /></h2> 
  <div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="ciudad.jsp?PaisId=<%=strPaisId %>&EstadoId=<%=strEstadoId%>&CiudadId=<%=strCiudadId%>">
		  <i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>&nbsp;
		<a class="btn btn-primary" href="accion_c.jsp?Accion=1&PaisId=<%=strPaisId%>&EstadoId=<%=strEstadoId%>&CiudadId=<%=strCiudadId%>">
		  <i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a> 
	
  </div>
  <table width="40%" align="center" class="table table-condensed">
  <tr> 
    <th width="17%"><fmt:message key="aca.Operacion" /></th>
    <th width="9%">#</th>
    <th width="74%"><fmt:message key="aca.Ciudad" /></th>
    <th width="74%"><fmt:message key="aca.Barrio" /></th>
  </tr>
<%
	for (int i=0; i< lisBarrio.size(); i++){
		aca.catalogo.CatBarrio ciudad = (aca.catalogo.CatBarrio) lisBarrio.get(i);
		if(ciudad.getPaisId().equals(strPaisId) && ciudad.getEstadoId().equals(strEstadoId)){
%>  
  <tr> 
    <td align="center">
	  <a class="icon-pencil" href="accion_c.jsp?Accion=5&CiudadId=<%=ciudad.getCiudadId()%>&EstadoId=<%=ciudad.getEstadoId()%>&PaisId=<%=ciudad.getPaisId()%>">
	  </a>
	  <a class="icon-remove" href="javascript:Borrar ('<%=ciudad.getPaisId()%>','<%=ciudad.getEstadoId()%>','<%=ciudad.getCiudadId()%>','<%=ciudad.getBarrioId()%>')">
	  </a>
	</td>
    <td align="center"><%=ciudad.getCiudadId()%></td>
    <td><%=ciudad.getBarrioNombre()%></td>
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
