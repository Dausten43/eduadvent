<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="especialidadLista" scope="page" class="aca.catalogo.CatEspecialidadLista"/>
<head>
<script>
		function Borrar( EspecialidadId ){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
		  		document.location="accion.jsp?Accion=4&Clave="+EspecialidadId;
		  	}
		}
</script>
</head>
<%
	ArrayList lisEspecialidad			= especialidadLista.getListAll(conElias, "ORDER BY ESPECIALIDAD_ID");
%>
<body>
<div id="content">
	<h2><fmt:message key="catalogo.ListaDeEsp" /></h2> 
	 
	 <div class="well" style="overflow:hidden;">
 		<a class="btn btn-primary" href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>&nbsp;
 		<input type="text" class="input-medium search-query" placeholder="<fmt:message key="aca.Buscarr"/>" id="buscar">
	</div>
<table class="table table-striped table-condensed" id="table">
  <thead>  
	  <tr> 
		<th width="10%"><fmt:message key="aca.Operacion" /></th>
		<th width="5%">#</th>
		<th width="30%"><fmt:message key="aca.Nombre" /></th>
	  </tr>
  </thead>
		  
  <%
  	int cont = 0;
	for (int i=0; i< lisEspecialidad.size(); i++){ cont++;
		aca.catalogo.CatEspecialidad especialidad = (aca.catalogo.CatEspecialidad) lisEspecialidad.get(i);
%>
  <tr> 
    <td align="center"> 
      <a class="icon-pencil" href="accion.jsp?Accion=5&Clave=<%= especialidad.getEspecialidadId() %>"></a> 
      <a class="icon-remove" href="javascript:Borrar('<%=especialidad.getEspecialidadId()%>')"></a>
    </td>
    <td><%= i+1%></td>
    <td><%= especialidad.getEspecialidadNombre()%></td>
  </tr>
<%
	}	
%>
  </table>
</div>
</body>
<script src="../../js/search.js"></script>
<script>
	$('#buscar').search({table:$("#table")});
</script>
<%@ include file= "../../cierra_elias.jsp" %>