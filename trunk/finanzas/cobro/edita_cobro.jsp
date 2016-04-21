<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>
<%@page import="aca.fin.FinPago"%>

<jsp:useBean id="finPago" scope="page" class="aca.fin.FinPago"/>

<script>
	function evaluar(){
		if(document.forma.descripcion.value != "" && document.forma.fecha.value != ""){
		  	document.forma.submit();
		}else{
		 	alert("<fmt:message key='js.Completar' />");
		}
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId		= (String) session.getAttribute("cicloId");	
	
	String periodoId	= request.getParameter("periodo")==null?"1":request.getParameter("periodo");
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String pagoId		= request.getParameter("pago");	
	String metodo		= "";	
	
	String numPagosIniciales	= aca.fin.FinPago.numPagosIniciales(conElias, cicloId, periodoId);
	
	if(pagoId != null){
		if(!pagoId.equals("")){
			finPago.mapeaRegId(conElias, cicloId, periodoId, pagoId);
			metodo = "Modificar";
		}else{
			metodo = "Guardar";
		}
	}else{
		pagoId = "";
		metodo = "Guardar";
	}
	
	String msj = "";
	
	if(accion.equals("1")){
		finPago.setCicloId(cicloId);
		finPago.setPeriodoId(periodoId);
		finPago.setFecha(request.getParameter("fecha"));
		finPago.setDescripcion(request.getParameter("descripcion"));
		finPago.setTipo(request.getParameter("tipo"));
		finPago.setOrden(request.getParameter("orden"));
		finPago.setFechaVence(request.getParameter("FechaVence"));
		if(metodo.equals("Guardar")){	// Guardar	
			//Busca el siguiente folio 
			finPago.setPagoId(finPago.maximoReg(conElias, cicloId, periodoId));			
			// inserta el registro
			if(finPago.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}else{	//Modificar
			finPago.setPagoId(pagoId);			
			if(finPago.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModifico";
			}
		}
	}
	
	pageContext.setAttribute("resultado", msj);
%>

<div id="content">
	
	<h2><fmt:message key="boton.Editar" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a class="btn btn-primary" href="cobro.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form id="forma" name="forma" action="edita_cobro.jsp?Accion=1&pago=<%=pagoId %>" method="post">
		<input type="hidden" name="ciclo" value="<%=cicloId%>">
		<input type="hidden" name="periodo" value="<%=periodoId%>">
				
		<fieldset>
			<label for="descripcion"><fmt:message key="aca.Descripcion" /></label>
			<input type="text" id="descripcion" name="descripcion" value="<%=finPago.getDescripcion() %>" maxlength="40" size="30" />
		</fieldset>
				
		<fieldset>
			<label for="fecha"><fmt:message key="aca.FechaAplica" /></label>
			<input type="text" id="fecha" name="fecha" value="<%=finPago.getFecha() %>" size="8" maxlength="10" />
		</fieldset>
		
		<fieldset>
			<label for="FechaVence"><fmt:message key="aca.FechaVence" /></label>
			<input type="text" id="FechaVence" name="FechaVence" value="<%=finPago.getFechaVence() %>" size="8" maxlength="10" />
		</fieldset>
		
		<fieldset>
			<label for="tipo"><fmt:message key="aca.Tipo" /></label>
			<select name="tipo" id="tipo">
			<% if (numPagosIniciales.equals("0") || finPago.getTipo().equals("I")){ %>
				<option value="I" <% if (finPago.getTipo().equals("I")) out.print("selected");%>><fmt:message key="aca.Inicial" /></option>
			<% }%>	
				<option value="P" <% if (finPago.getTipo().equals("P")) out.print("selected");%>><fmt:message key="aca.Ordinario" /></option>
			</select>						
		</fieldset>
		
		<fieldset>
			<label for="orden"><fmt:message key="aca.Orden" /></label>
			<input type="text" id="orden" name="orden" value="<%=finPago.getOrden() %>" size="3" maxlength="2" />
		</fieldset>
			
		<div class="well">
			<a href="javascript:evaluar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		</div>
				
	</form>
	</div>


<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fecha').datepicker();
	$('#FechaVence').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>