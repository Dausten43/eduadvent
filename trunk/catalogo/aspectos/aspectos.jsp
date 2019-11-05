<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatAspectos" scope="page" class="aca.catalogo.CatAspectos"/>
<jsp:useBean id="CatAspectosU" scope="page" class="aca.catalogo.CatAspectosLista"/>


<head>
	<script>
		function Borrar(AspectosId){
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
		  		document.location="aspectos.jsp?Accion=4&AspectoId="+AspectosId;
		  	}
		}
	</script>
</head>
<%
	
	String sColonia		="";
	String sEmail		="";
	String escuelaId 	= (String)session.getAttribute("escuela");
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	
	
	if(accion.equals("4")){
		CatAspectos.setAspectosId(request.getParameter("AspectoId"));
		CatAspectos.setEscuelaId(escuelaId);
		if(CatAspectos.existeReg(conElias)){
			CatAspectos.deleteReg(conElias);
		}
		
	}
	ArrayList<aca.catalogo.CatAspectos> list	= CatAspectosU.getListAspectos(conElias, escuelaId, "ORDER By NIVEL_ID, ORDEN");
%>
<body>

<div id="content">
    <form action="" name="forma">
    
    	<h2><fmt:message key="aca.listadoDeAspectos" /></h2> 
   
	    <div class="well">
	    	<a class="btn btn-primary " href="accion.jsp"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Anadir" /></a>
	    </div>
   
   		<table class="table tabe-condensed">
  			<tr> 
    			<th width="2%">#</th>
			    <th width="5%"><fmt:message key="aca.Operacion" /></th>
			    <th width="2%"><fmt:message key="aca.Id" /></th>
			    <th width="25%"><fmt:message key="aca.Nombre" />/<fmt:message key="aca.Descripcion" /></th>
			    <th width="5%"><fmt:message key="aca.Orden" /></th>
			    <th width="20%"><fmt:message key="aca.Nivel" /></th>
			    <th width="20%"><fmt:message key="aca.Area" /></th>
			</tr>
  			<%
				for (int i=0; i< list.size(); i++){
					aca.catalogo.CatAspectos aspecto = (aca.catalogo.CatAspectos) list.get(i);
			%>
  					<tr> 
    					<td><%=i+1%></td>
					    <td> 
					      <a class="icon-pencil" href="accion.jsp?Accion=2&AspectoId=<%=aspecto.getAspectosId() %>"> </a> 
					      <a href="javascript:Borrar('<%=aspecto.getAspectosId() %>')" class="icon-remove"></a> 
					    </td>
					    <td><%=aspecto.getAspectosId() %></td>
					    <td><%=aspecto.getNombre() %></td>
					    <td><%=aspecto.getOrden()%></td>
					    <td><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, aspecto.getNivelId())%></td>
					    <td><%=aca.catalogo.CatArea.getNombre(conElias, aspecto.getArea()) %></td>
					    
    				</tr>
  			<%
				}	
			%>
   		</table>

	</form>
</div>
<%@ include file= "../../cierra_elias.jsp" %> 
