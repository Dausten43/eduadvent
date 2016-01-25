<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="asocL" scope="page" class="aca.catalogo.CatAsociacionLista"/>
<jsp:useBean id="CatUnionU" scope="page" class="aca.catalogo.CatUnionLista"/>
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
	
	String sColonia					="";
	String sEmail					="";
	ArrayList<aca.catalogo.CatUnion> uniones = CatUnionU.getListAll(conElias, "ORDER BY UNION_ID");
	String unionId = request.getParameter("unionId");
	if(unionId==null){
		if(uniones.size()>0){
			unionId = uniones.get(0).getUnionId();	
		}
	}
	ArrayList<aca.catalogo.CatAsociacion> list					= asocL.getListAll(conElias,"WHERE UNION_ID = "+unionId+" ORDER BY ASOCIACION_ID");
%>
<body>

<div id="content">
    <form action="" name="forma">
    
    	<h2><fmt:message key="catalogo.ListadoDeAsoc" /></h2> 
   
	    <div class="well">
	    	<a class="btn btn-primary " href="accion.jsp?Accion=1&anadir=1&unionId=<%=unionId%>"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	    	<select name="unionId" id="unionId" onchange="document.forma.submit()" style="float:right;">
	    	<%for(aca.catalogo.CatUnion union : uniones){%>
	    		<option value="<%=union.getUnionId() %>"  <%if(union.getUnionId().equals(unionId))out.print("selected"); %>><%=union.getUnionNombre() %></option>	
	    	<%}%>
	    	</select>
	    </div>
   
   		<table class="table tabe-condensed">
  			<tr> 
    			<th width="2%">#</th>
			    <th width="5%"><fmt:message key="aca.Operacion" /></th>
			    <th width="2%"><fmt:message key="aca.Id" /></th>
			    <th width="30%"><fmt:message key="aca.Nombre" /></th>
			    <th width="30%"><fmt:message key="aca.NombreCorto" /></th>
			    <th width="30%"><fmt:message key="aca.Fondo" /></th>
			</tr>
  			<%
				for (int i=0; i< list.size(); i++){
					aca.catalogo.CatAsociacion asoc = (aca.catalogo.CatAsociacion) list.get(i);
					String nombre = asoc.getAsociacionNombre();
					String nombreCorto = asoc.getAsociacionNombreCorto();
			%>
  					<tr> 
    					<td><%=i+1%></td>
					    <td> 
					      <a class="icon-pencil" href="accion.jsp?Accion=4&AsocId=<%=asoc.getAsociacionId()%>&unionId=<%=unionId%>"> </a> 
					      <a href="javascript:Borrar('<%=asoc.getAsociacionId()%>')" class="icon-remove"></a> 
					    </td>
					    <td><%=asoc.getAsociacionId() %></td>
					    <td><%=nombre%></td>
					    <td><%=nombreCorto%></td>
					    <td><%=asoc.getFondoId() %></td>
    				</tr>
  			<%
				}	
			%>
   		</table>

	</form>
</div>
<%@ include file= "../../cierra_elias.jsp" %> 
