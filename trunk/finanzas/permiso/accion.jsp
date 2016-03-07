<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Permiso" scope="page" class="aca.fin.FinPermiso"/>

<script>
	
	function Nuevo(){
		document.frmPermiso.CodigoId.value		= " ";	
		document.frmPermiso.Folio.value			= " ";
		document.frmPermiso.Fecha_ini.value		= " ";
		document.frmPermiso.Fecha_fin.value		= " ";
		document.frmPermiso.Estado.value		= " ";
		document.frmPermiso.Comentario.value	= " ";
		document.frmPermiso.submit();
	}
	
	function Grabar(){
		if(document.frmPermiso.CodigoId.value	!="" 
			&& document.frmPermiso.Folio		!="" 
			&& document.frmPermiso.Fecha_ini	!=""
			&& document.frmPermiso.Fecha_fin	!="" 
			&& document.frmPermiso.Estado		!="" 
			&& document.frmPermiso.Comentario	!="" 
			document.frmPermiso.submit();
		}else{
			alert("¡Complete el formulario! ");
		}
	}
	
	function Borrar( ){	
		if(document.frmPermiso.CodigoId.value!=""){		
			if(confirm("¿Estás seguro de eliminar el registro?")==true){
	  			document.frmPermido.Accion.value = "4";
				document.frmPermiso.submit();
			}			
		}else{
			alert("¡Escriba la Clave!");
			document.frmPermiso.CodigoId.focus(); 
	  	}
	}
	
	function Consultar(){
		document.frmPermiso.Accion.value = "5";
		document.frmPermio.submit();		
	}	
	
</script>

<%
	// Declaracion de variables
	String numAccion		= request.getParameter("Accion")==null?"1":request.getParameter("Accion");	
	String resultado		= "";
	
	if(numAccion.equals("1")){
		Permiso.setCodigoId(request.getParameter("codigoId"));
		Permiso.setFolio(request.getParameter("folio"));
		Permiso.setFecha_ini(request.getParameter("fecha_ini"));
		Permiso.setFecha_fin(request.getParameter("fecha_fin"));
		Permiso.setEstado(request.getParameter("estado"));
		Permiso.setComentario(request.getParameter("comentario"));
		
		if(!Permiso.existeReg(conElias)){
			Permiso.insertReg(conElias);
			resultado = "Guardado";
		}else if(Permiso.existeReg(conElias)){
				Permiso.updateReg(conElias);
				resultado = "Modificado";
			}
	}
	
	if(numAccion.equals("2")){
		if(Permiso.existeReg(conElias)){
			if(Permiso.deleteReg(conElias)){
				resultado = "Eliminado";
			}
		}
	}
	
	pageContext.setAttribute("resultado", resultado);
	
%>

<div id="content">
	<h2><fmt:message key="boton.Anadir" /></h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>

 	<div class="well">
 		<a class="btn btn-primary"href="permiso.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
 	</div>  

	<form action="accion.jsp" method="post" name="frmPermiso" target="_self">
		<input type="hidden" name="Accion">
		
		<fieldset>
	    	<label for="CodigoId"><fmt:message key="Codigo Id" /></label>
	    	<input class="input-large" name="CodigoId" type="text" id="CodigoId" value="<%=Permiso.getCodigoId()%>">
	    </fieldset>
	    
		<fieldset>
	    	<label for="Folio"><fmt:message key="Folio" /></label>
	    	<input class="input-large" name="Folio" type="text" id="Folio" value="<%=Permiso.getFolio()%>">
	    </fieldset>	        
	    
	    <fieldset>
	    	<label for="Fecha-ini"><fmt:message key="Fecha ini" /></label>
	    	<input name="FechaIni" type="date" id="FechaIni" value="<%=Permiso.getFecha_ini()%>">
	   </fieldset>
	    
	   <fieldset>
	    	<label for="Fecha-fin"><fmt:message key="Fecha fin" /></label>
	        <input name="FechaFin" type="date" id="FechaFin" value="<%=Permiso.getFecha_fin()%>">
	   	</fieldset>
	   
		<fieldset>
	    	<label for="Estado"><fmt:message key="Estado" /></label>
	        <input class="input-large" name="Estado" type="text" id="Estado" value="<%=Permiso.getEstado()%>">
	   </fieldset>
	   
	   <fieldset>
	    	<label for=">Comentario">
				<fmt:message key="Comentario" />
	        </label>
	        <input class="input-large" name="Comentario" type="text" id="Comentario" value="<%=Permiso.getComentario()%>" size="200" maxlength="200">
		</fieldset>
	
		<div class="well">
	    	<a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		</div>	     
	</form>
</div>
<%@ include file= "../../cierra_elias.jsp" %>