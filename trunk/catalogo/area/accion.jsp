<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatArea" scope="page" class="aca.catalogo.CatArea"/>

<head>

</head>
<%
	
	String escuela 			= (String)session.getAttribute("escuela");
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String areaId			= request.getParameter("AreaId")==null?"0":request.getParameter("AreaId");	
	
	if(accion.equals("1")){
		CatArea.setAreaId(CatArea.maximoReg(conElias));
		CatArea.setNombre(request.getParameter("descripcion"));		
		
		conElias.setAutoCommit(false);
		if(CatArea.insertReg(conElias)){
			conElias.commit();
		}else{
			//System.out.println("No Grabo");
		}
		conElias.setAutoCommit(true);
		
	}else if(accion.equals("2")){
		CatArea.setAreaId(areaId);
		if(CatArea.existeReg(conElias)){
			CatArea.mapeaRegId(conElias);
		}
	}else if(accion.equals("3")){
		CatArea.setAreaId(areaId);
		if(CatArea.existeReg(conElias)){			
			CatArea.setAreaId(areaId);
			CatArea.setNombre(request.getParameter("descripcion"));			
			conElias.setAutoCommit(false);
			if(CatArea.updateReg(conElias)){
				conElias.commit();
			}
			conElias.setAutoCommit(true);
		}

	}

%>
<div id="content">
	<h2><fmt:message key="aca.agregarAspecto" /></h2> 
	 
   <div class="well" style="overflow:hidden;">
  	<a class="btn btn-primary" href="areas.jsp"><i class="icon-list icon-white"></i>&nbsp;<fmt:message key="boton.Listado" /></a>
  </div>

	
	<form action="accion.jsp" data-toggle="validator" role="form" method="get" name="forma" target="_self">
	<input name="Accion" id="Accion" hidden value="<%=accion.equals("")?"1":"3"%>">
	<input name="AreaId" id="AreaId" hidden value="<%=areaId==null?"0":areaId%>">
	  <div class="form-group">
	    <label for="descripcion">Descripcion:</label>
	    <textarea class="form-control" name="descripcion" id="descripcion" required><%=CatArea.getNombre()%></textarea>	    
	  </div>
	  <button class="btn btn-primary" type="submit"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Grabar" /></button>
	</form>
</div>





<%@ include file= "../../cierra_elias.jsp" %> 
