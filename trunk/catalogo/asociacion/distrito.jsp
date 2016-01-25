<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="asocL" scope="page" class="aca.catalogo.CatAsociacionLista"/>
<jsp:useBean id="CatUnionU" scope="page" class="aca.catalogo.CatUnionLista"/>
<jsp:useBean id="CatDistU" scope="page" class="aca.catalogo.CatDistritoLista"/>
<jsp:useBean id="Union" scope="page" class="aca.catalogo.CatUnion"/>

<head>
	<script>
		function Borrar( AsocId ){
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
		  		document.location="accion.jsp?Accion=3&AsocId="+AsocId;
		  	}
		}
	</script>
</head>
<%
	String nomAsoc					= request.getParameter("nombre");
	String asociacionId				= request.getParameter("asociacionId");
	String unionId					= request.getParameter("unionId");
	
	ArrayList<aca.catalogo.CatUnion> uniones 		= CatUnionU.getListAll(conElias, "ORDER BY UNION_ID");
	ArrayList<aca.catalogo.CatDistrito> distritos 	= CatDistU.getListAsociacion(conElias, asociacionId, "ORDER BY DISTRITO_ID");
	
	int cont = 1;
%>
<body>

<div id="content">
    <h2><fmt:message key="catalogo.ListadoDistrito" /><small> <fmt:message key="catalogo.Asociacion" />: <%=nomAsoc %></small></h2> 
    <form action="" name="forma">
	    <div class="well" style="overflow:hidden;">
	    	<a class="btn btn-primary " href="accion_d.jsp?Accion=1&anadir=1&asociacionId=<%=asociacionId%>"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	    	<a class="btn btn-primary " href="asociacion.jsp?unionId=<%=unionId%>"><i class="icon-list icon-white"></i>&nbsp;<fmt:message key="boton.Listado" /></a>
	    </div>
    </form>
   <table width="35%" align="center" class="table tabe-condensed">
  <tr> 
    <th width="2%">#</th>
    <th width="5%"><fmt:message key="aca.Operacion" /></th>
    <th width="2%"><fmt:message key="aca.Id" /></th>
    <th width="30%"><fmt:message key="aca.Nombre" /></th>
   </tr>
  <%
	for (aca.catalogo.CatDistrito distrito : distritos){
%>
  		<tr> 
    		<td align="center"><%=cont%></td>
    		<td align="center"> 
	        	<a class="icon-pencil" href="accion.jsp?Accion=4&asociacionId=<%=asociacionId%>&distritoId=<%=distrito.getDistritoId()%>"> </a> 
	      		<a href="javascript:Borrar('<%=asociacionId%>')" class="icon-remove"></a> 
    		</td>
    		<td align="center"><%=distrito.getDistritoId()%></td>
    		<td align="center"><%=distrito.getDistritoNombre()%></a></td>
    	</tr>
  <%
		cont++;
  	}	
%>
   </table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 
