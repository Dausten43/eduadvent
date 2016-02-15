<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatArea" scope="page" class="aca.catalogo.CatArea"/>
<jsp:useBean id="CatAreaL" scope="page" class="aca.catalogo.CatAreaLista"/>

<head>
	<script>
		function Borrar(areaId){
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
		  		document.location="areas.jsp?Accion=4&AreaId="+areaId;
		  	}
		}
	</script>
</head>
<%
	String escuelaId 		= (String)session.getAttribute("escuela");
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	if(accion.equals("4")){
		System.out.println("Test");
		CatArea.setAreaId(request.getParameter("AreaId"));
		if(CatArea.existeReg(conElias)){
			CatArea.deleteReg(conElias);
		}		
	}
	ArrayList<aca.catalogo.CatArea> list	= CatAreaL.getListAll(conElias, "");
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
			</tr>
  			<%
				for (int i=0; i< list.size(); i++){
					aca.catalogo.CatArea area = (aca.catalogo.CatArea) list.get(i);
			%>
  					<tr> 
    					<td><%=i+1%></td>
					    <td> 
					      <a class="icon-pencil" href="accion.jsp?Accion=2&AreaId=<%=area.getAreaId() %>"> </a> 
					      <a href="javascript:Borrar('<%=area.getAreaId() %>')" class="icon-remove"></a> 
					    </td>
					    <td><%=area.getAreaId() %></td>
					    <td><%=area.getNombre() %></td>					    
    				</tr>
  			<%
				}	
			%>
   		</table>

	</form>
</div>
<%@ include file= "../../cierra_elias.jsp" %>