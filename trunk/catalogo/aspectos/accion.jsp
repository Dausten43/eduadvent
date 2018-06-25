<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CatAspectos" scope="page" class="aca.catalogo.CatAspectos"/>
<jsp:useBean id="CatAreaU" scope="page" class="aca.catalogo.CatAreaLista"/>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<head>

</head>
<%
	
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String aspectosId		= request.getParameter("AspectoId")==null?"0":request.getParameter("AspectoId");
	String escuela 			= (String)session.getAttribute("escuela");
	
	ArrayList<aca.catalogo.CatNivelEscuela> niveles = nivelU.getListEscuela(conElias, escuela, "ORDER BY 2");
	ArrayList<aca.catalogo.CatArea> areaLista		= CatAreaU.getListAll(conElias, "");


	if(accion.equals("1")){
		
		CatAspectos.setAspectosId(CatAspectos.maximoReg(conElias, escuela));
		CatAspectos.setNombre(request.getParameter("descripcion"));
		CatAspectos.setOrden(request.getParameter("orden"));
		CatAspectos.setNivelId(request.getParameter("nivel"));
		CatAspectos.setArea(request.getParameter("area"));
		CatAspectos.setEscuelaId(escuela);
		
		conElias.setAutoCommit(false);
		if(CatAspectos.insertReg(conElias)){
			conElias.commit();
		}else{
			//System.out.println("No Grabo");
		}
		conElias.setAutoCommit(true);
		
	}else if(accion.equals("2")){
		CatAspectos.setAspectosId(aspectosId);
		CatAspectos.setEscuelaId(escuela);
		if(CatAspectos.existeReg(conElias)){
			CatAspectos.mapeaRegId(conElias);
		}
	}else if(accion.equals("3")){
		CatAspectos.setAspectosId(aspectosId);
		CatAspectos.setEscuelaId(escuela);
		if(CatAspectos.existeReg(conElias)){
			//System.out.println(aspectosId);
			CatAspectos.setAspectosId(aspectosId);
			CatAspectos.setNombre(request.getParameter("descripcion"));
			CatAspectos.setOrden(request.getParameter("orden"));
			CatAspectos.setNivelId(request.getParameter("nivel"));
			CatAspectos.setArea(request.getParameter("area"));
			
			conElias.setAutoCommit(false);
			if(CatAspectos.updateReg(conElias)){

			}else{
				//System.out.println("No Grabo");
			}
			conElias.setAutoCommit(true);
		}

	}

%>
<div id="content">
	<h2><fmt:message key="aca.agregarAspecto" /></h2> 
	 
	<div class="well" style="overflow:hidden;">
  		<a class="btn btn-primary" href="aspectos.jsp"><i class="icon-list icon-white"></i>&nbsp;<fmt:message key="boton.Listado" /></a>
	</div>
		
	<form action="accion.jsp" data-toggle="validator" role="form" method="post" name="forma" target="_self">
	<div class="form-group">
	    <label for="descripcion">Descripcion:</label>
	    <textarea class="form-control" name="descripcion" id="descripcion" required><%=CatAspectos.getNombre()%></textarea>
	    <label for="orden">Orden:</label>
	    <input type="number" min="0" class="form-control" name="orden" id="orden" required value=<%=CatAspectos.getOrden()%>>
	    <label for="nivel">Nivel:</label>
	    <select class="form-control" name="nivel"  id="nivel" required>
	    <option value="">Seleccione Nivel</option>
<%		for(aca.catalogo.CatNivelEscuela nivel: niveles){
%>
	    	<option value="<%=nivel.getNivelId()%>" <% if (nivel.getNivelId().equals(CatAspectos.getNivelId())){out.print("Selected");}%>><%=nivel.getNivelNombre()%></option>
<%
	    } %>
	    </select>
	    <label for="area">Area:</label>
   	    <select class="form-control" name="area"  id="area" required>
   	    <option value="">Seleccione Area</option>
<%		for(aca.catalogo.CatArea area: areaLista){
%>
	    	<option value="<%=area.getAreaId()%>" <%if (area.getAreaId().equals(CatAspectos.getArea())){out.print("Selected");}%>><%=area.getNombre() %></option>
<%
	    } %>
	    </select>
	    <input name="Accion" id="Accion" hidden value="<%=accion.equals("")?"1":"3"%>">
	    <input name="AspectoId" id="AspectoId" hidden value="<%=aspectosId==null?"0":aspectosId%>">
	</div>
	<button class="btn btn-primary" type="submit"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="boton.Grabar" /></button>
	</form>
</div>





<%@ include file= "../../cierra_elias.jsp" %> 
