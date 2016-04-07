<%@page import="aca.menu.Modulo"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatAspectosCal"%>

<jsp:useBean id="AspectosCal" scope="page" class="aca.catalogo.CatAspectosCal"/>
<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<script>
	function Grabar() {
		document.forma.Accion.value="2";
	}
</script>

<%
	String nombre			= request.getParameter("Nombre")==null?"":request.getParameter("Nombre");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String nivelId			= request.getParameter("nivelId")==null?"0":request.getParameter("nivelId");
	String calId			= request.getParameter("calId")==null?"0":request.getParameter("calId");
	String escuela			= request.getParameter("escuelaId")==null?(String)session.getAttribute("escuela"):request.getParameter("escuelaId");
	String msj 				= "";
	
	
	if(accion.equals("2")){
		
		AspectosCal.setEscuelaId(escuela);
		AspectosCal.setNivelId(nivelId);
		AspectosCal.setCalId(calId);
		AspectosCal.setCalNombre(nombre);
		AspectosCal.setCalCorto(request.getParameter("calCorto"));
		
		if(!AspectosCal.existeReg(conElias)){
			
			if(AspectosCal.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}else{		
			
			
			if(AspectosCal.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModificado";
			}
		}
	}else if(accion.equals("3")){
		AspectosCal.setEscuelaId(escuela);
		AspectosCal.setNivelId(nivelId);
		AspectosCal.setCalId(calId);
		AspectosCal.mapeaRegId(conElias);
	}
	
	pageContext.setAttribute("msj", msj);
	
	ArrayList<aca.catalogo.CatNivelEscuela> lisNiveles 	= nivelU.getListEscuela(conElias, escuela, "ORDER BY 2");
%>

<div id=content>

	<h2>Tipo movimientos</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${msj}"/></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${msj}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary btn-mobile" href="tipo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form name="forma" action="accion.jsp" method="post">
	<input type="hidden" name="Accion">	
		<fieldset>
			<label for="NombreTipoMovimiento">Nombre</label>
		   	<input type="text" id="Nombre" name="Nombre" value="<%out.print(AspectosCal.getCalNombre());%>"/>
		</fieldset>
			
		<fieldset>
			<label for="NombreTipoMovimiento">Cal. Id</label>
		   	<input type="text" id="calId" name="calId" value="<%out.print(AspectosCal.getCalId());%>"/>
		</fieldset>
		<fieldset>
			<label for="NombreTipoMovimiento">Nivel Id</label>
			<select class="form-control" name="nivelId"  id="nivelId" required>
	    		<option value="">Seleccione Nivel</option>
<%		for(aca.catalogo.CatNivelEscuela nivel: lisNiveles){
%>
	    		<option value="<%=nivel.getNivelId()%>" <% if (nivel.getNivelId().equals(AspectosCal.getNivelId())){out.print("Selected");}%>><%=nivel.getNivelNombre()%></option>
<%
	    } %>
	    	</select>	        
		</fieldset>
		<fieldset>
			<label for="NombreTipoMovimiento">Cal. Corto</label>
	       	<input type="text" id="calCorto" name="calCorto" value="<%out.print(AspectosCal.getCalCorto());%>"/>
		</fieldset>
		
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key='boton.Guardar' /></button>
		</div>
	</form>
</div>

<%@ include file= "../../cierra_elias.jsp" %>
