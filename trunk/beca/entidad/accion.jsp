<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Entidad" scope="page" class="aca.beca.BecEntidad"/>

<script>
	
	function Grabar(){
		if(document.frmEntidad.EntidadNombre.value !="" && document.frmEntidad.Porcentaje.value != "" && document.frmEntidad.Cantidad.value != ""){	
			document.frmEntidad.Accion.value="2";
			document.frmEntidad.submit();			
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
	
	function Modificar(){
		document.frmEntidad.Accion.value="3";
		document.frmEntidad.submit();
	}
	
	function Borrar( ){
		if(document.frmEntidad.EntidadId.value!=""){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
	  			document.frmEntidad.Accion.value="4";
				document.frmEntidad.submit();
			}			
		}else{
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmEntidad.EntidadId.focus(); 
	  	}
	}
	
</script>

<%
	// Declaracion de variables	
	String entidadId	= request.getParameter("EntidadId");
	int nAccion			= Integer.parseInt(request.getParameter("Accion"));
	String sResultado	= "";	
	String salto		= "X";
		
	if ( nAccion != 1 && nAccion != 2 ){
		Entidad.setEntidadId(entidadId);
	}
	
	// Operaciones a realizar en la pantalla	
	switch (nAccion){
		
		case 2: { // Grabar
			conElias.setAutoCommit(false);
			Entidad.setEntidadId(Entidad.maximoReg(conElias));
			Entidad.setEntidadNombre(request.getParameter("EntidadNombre"));
			Entidad.setReferente(request.getParameter("Referente"));
			Entidad.setTelefono(request.getParameter("Telefono"));
			Entidad.setLimitePorcentaje(request.getParameter("Porcentaje"));
			Entidad.setLimiteCantidad(request.getParameter("Cantidad"));
			Entidad.setEscuelaId((String)session.getAttribute("escuela"));
			Entidad.setTipo(request.getParameter("Tipo"));
			if (Entidad.existeReg(conElias) == false){
				if (Entidad.insertReg(conElias)){
					sResultado = "Guardado";
					conElias.commit();					
				}else{
					sResultado = "EntidadNoGrabada";
				}
			}else{
				sResultado = "YaExisteEntidad";
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 3: { // Modificar
			conElias.setAutoCommit(false);
			Entidad.setEntidadId(entidadId);
			Entidad.mapeaRegId(conElias, entidadId);
			Entidad.setEntidadNombre(request.getParameter("EntidadNombre"));
			Entidad.setReferente(request.getParameter("Referente"));
			Entidad.setTelefono(request.getParameter("Telefono"));
			Entidad.setLimitePorcentaje(request.getParameter("Porcentaje"));
			Entidad.setLimiteCantidad(request.getParameter("Cantidad"));
			Entidad.setTipo(request.getParameter("Tipo"));
			if (Entidad.existeReg(conElias) == true){
				if (Entidad.updateReg(conElias)){
					sResultado = "Modificado";
					conElias.commit();					
				}else{
					sResultado = "NoModifico";
				}
			}else{
				sResultado = "NoExisteEntidad";
			}
			conElias.setAutoCommit(true);
			break;
			
		}
		case 4: { // Borrar
			conElias.setAutoCommit(false);
			if (Entidad.existeReg(conElias) == true){
				if (Entidad.deleteReg(conElias)){
					sResultado = "Eliminado";
					salto = "entidad.jsp";			
				}else{
					sResultado = "NoBorroEntidad";
				}	
			}else{
				sResultado = "NoExisteEntidad";
			}
			conElias.setAutoCommit(true);
			break;
			
		}
		case 5: { // Consultar			
			if (Entidad.existeReg(conElias) == true){
				Entidad.mapeaRegId(conElias, request.getParameter("EntidadId"));
				
			}else{
				 
			}	
			break;			
		}
		
	}	
	pageContext.setAttribute("resultado",sResultado);
%>


<div id="content">
	<h2><fmt:message key="catalogo.Entidades" /></h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary" href="entidad.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<form action="accion.jsp" method="post" name="frmEntidad" target="_self">
		
		<input type="hidden" name="Accion">
		<input type="hidden" name="EntidadId" id="EntidadId" maxlength="3" value="<%=Entidad.getEntidadId()%>">

		<fieldset>
	    	<label for="EntidadNombre"><fmt:message key="aca.Nombre" /></label>
	        <input name="EntidadNombre" type="text" id="EntidadNombre" value="<%=Entidad.getEntidadNombre()%>" maxlength="70">
	    </fieldset>
	    
	    <fieldset>
	    	<label for="Referente"><fmt:message key="aca.Referente" /></label>
	        <input name="Referente" type="text" id="Referente" value="<%=Entidad.getReferente()%>" maxlength="70">
	    </fieldset>
	    
	    <fieldset>
	    	<label for="Telefono"><fmt:message key="aca.Telefono" /></label>
	        <input name="Telefono" type="text" id="Telefono" value="<%=Entidad.getTelefono()%>" maxlength="50">
	    </fieldset>
	    
	    <fieldset>
	    	<label for="Porcentaje"><fmt:message key="aca.LimitePorcentaje" /></label>
	        <input class="input-small onlyNumbers" name="Porcentaje" type="text" id="Porcentaje" value="<%=Entidad.getLimitePorcentaje()%>" maxlength="3">
	    </fieldset>
	    
	    <fieldset>
	    	<label for="Cantidad"><fmt:message key="aca.LimiteCantidad" /></label>
	        <input class="input-small onlyNumbers" name="Cantidad" type="text" id="Cantidad" value="<%=Entidad.getLimiteCantidad()%>" maxlength="7">
	    </fieldset>
	    
    	<div class="well">
			<%if(nAccion == 1){%>
			  <a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar"/></a>
			<%}%>
			
			<%if(nAccion == 2 || nAccion == 3 || nAccion == 5){%>
			  <a class="btn btn-primary btn-large" href="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
			  <a class="btn btn-danger btn-large" href="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
			<%}%>
		</div>
	</form>
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>
