<%@page import="aca.menu.Modulo"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatTipoMovimiento"%>

<jsp:useBean id="TipoMovimiento" scope="page" class="aca.catalogo.CatTipoMovimiento"/>

<script>
	function Grabar() {
		document.forma.Accion.value="2";
	}
</script>

<%
	String nombre			= request.getParameter("Nombre")==null?"":request.getParameter("Nombre");
	String tipo				= request.getParameter("Tipo")==null?"":request.getParameter("Tipo");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String tipoMovId		= request.getParameter("tipoMovId")==null?"99":request.getParameter("tipoMovId");
	String msj 				= "";
	
	if(tipoMovId != "99"){
		TipoMovimiento.mapeaRegId(conElias, tipoMovId);	
	}
	
	if(accion.equals("2")){
		
		conElias.setAutoCommit(false);
		
		TipoMovimiento.setTipoMovId(tipoMovId);
		if(!TipoMovimiento.existeReg(conElias)){
			
			tipo = (tipo.equals("Caja")) ? "C" : "S";
			
			TipoMovimiento.setNombre(nombre);
			TipoMovimiento.setTipo(tipo);
			TipoMovimiento.setTipoMovId(TipoMovimiento.maximoReg(conElias));
			
			if(TipoMovimiento.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}else{		
			
			tipo = (tipo.equals("Caja")) ? "C" : "S";
			
			TipoMovimiento.setNombre(nombre);
			TipoMovimiento.setTipo(tipo);
			
			if(TipoMovimiento.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModificado";
			}
		}
	}	
%>

<div id=content>

	<h2>Tipo movimientos</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${msj}"/></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${msj}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary btn-mobile" href="movimiento.jsp?"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form name="forma" action="accion.jsp?tipoMovId=<%=tipoMovId%>" method="post">
	<input type="hidden" name="Accion">	
		<fieldset>
				<label for="NombreTipoMovimiento">Nombre tipo movimiento</label>
	        	<input type="text" id="Nombre" name="Nombre" value="<%out.print(TipoMovimiento.getNombre());%>"/>
		</fieldset>
		
		<fieldset>
				<label for="TipoMovimiento">Tipo movimiento</label>
	        	<select id="Tipo" name="Tipo">
					<option name="caja" <%if(TipoMovimiento.getTipo().equals("C")){out.print("selected");} %>><%="Caja"%></option>
					<option name="sistema" <%if(TipoMovimiento.getTipo().equals("S")){out.print("selected");} %>><%="Sistema"%></option>
	        	</select>
		</fieldset>
		
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key='boton.Guardar' /></button>
		</div>
	</form>
		
</div>

<%@ include file= "../../cierra_elias.jsp" %>
