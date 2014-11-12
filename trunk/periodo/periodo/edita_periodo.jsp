<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>

<jsp:useBean id="cicloPeriodo" scope="page" class="aca.ciclo.CicloPeriodo"/>

<%
	String cicloId		= request.getParameter("ciclo");
	String periodoId	= request.getParameter("periodo");

	String tipoGuardado = "";
	
	if(periodoId != null){
		if(!periodoId.equals("")){
			cicloPeriodo.mapeaRegId(conElias, cicloId, periodoId);
			tipoGuardado = "Modificar";
		}else{
			periodoId = "";
			tipoGuardado = "Guardar";
		}
	}else{
		periodoId = "";
		tipoGuardado = "Guardar";
	}
	
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if(accion.equals("1")){
		cicloPeriodo.setPeriodoNombre(request.getParameter("nombre"));
		cicloPeriodo.setFInicio(request.getParameter("fInicio"));
		cicloPeriodo.setFFinal(request.getParameter("fFinal"));
		
		if(tipoGuardado.equals("Guardar")){	// Guardar			
			cicloPeriodo.setCicloId(cicloId);
			cicloPeriodo.setPeriodoId(cicloPeriodo.siguientePeriodo(conElias, cicloId));
			if(cicloPeriodo.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}else{	//Modificar
			if(cicloPeriodo.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModifico";
			}
		}
	}
	
	pageContext.setAttribute("resultado", msj);
%>

<script>
	function revisa(){
		if(document.getElementById("nombre").value != "" &&
		   document.getElementById("fInicio").value != "" &&
		   document.getElementById("fFinal").value != ""){
			return true;
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
		return false;
	}
</script>

<div id=content>

	<h2><fmt:message key="aca.Periodo" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary btn-mobile" href="listado.jsp?ciclo=<%=cicloId %>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form id="forma" name="forma" action="edita_periodo.jsp?Accion=1&ciclo=<%=cicloId %>&periodo=<%=periodoId %>" method="post">
		<fieldset>
			<label for="nombre"><fmt:message key="aca.Nombre" /></label>
			<input type="text" id="nombre" name="nombre" value="<%=cicloPeriodo.getPeriodoNombre() %>" maxlength="40" size="30" />
		</fieldset>
		
		<fieldset>
				<label for="fInicio"><fmt:message key="aca.FechaInicio" /></label>
	        	<input type="text" id="fInicio" name="fInicio" value="<%=cicloPeriodo.getFInicio() %>" size="8" maxlength="10" />
		</fieldset>
		
		<fieldset>
				<label for="fFinal"><fmt:message key="aca.FechaFinal" /></label>
	        	<input type="text" id="fFinal" name="fFinal" value="<%=cicloPeriodo.getFFinal() %>" size="8" maxlength="10" />
		</fieldset>
		
		
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="return revisa();"><i class="icon-ok icon-white"></i> <fmt:message key='boton.Guardar' /></button>
		</div>
	</form>
		
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fInicio').datepicker();
	$('#fFinal').datepicker();
</script>

<%@ include file= "../../cierra_elias.jsp" %>