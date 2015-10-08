<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>

<jsp:useBean id="cicloExtra" scope="page" class="aca.ciclo.CicloExtra"/>

<%
	String periodoId	= request.getParameter("periodo");

	String tipoGuardado = "";
	
	
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	String cicloId 		= request.getParameter("ciclo")==null?"":request.getParameter("ciclo");	
	String oportunidad 	= request.getParameter("oportunidad")==null?"0":request.getParameter("oportunidad");	
	cicloExtra.setCicloId(cicloId);
	String max 			= cicloExtra.maximoReg(conElias, cicloId);
	
	if(oportunidad.equals("0")){
		cicloExtra.setOportunidad(max);
	}
	
	if(accion.equals("2")){
		System.out.println("Entra");
		max 			= cicloExtra.maximoReg(conElias, cicloId);
		cicloExtra.setCicloId(cicloId);
		cicloExtra.setOportunidad(max);
		cicloExtra.setValorAnterior(request.getParameter("ValorAnterior"));
		cicloExtra.setValorExtra(request.getParameter("ValorExtra"));
		cicloExtra.setOportunidadNombre(request.getParameter("OportunidadNombre"));
		if(!cicloExtra.existeReg(conElias)){
			if(cicloExtra.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardado";
			}
		}else{
			if(cicloExtra.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModificado";
			}
		}
	}
	
	pageContext.setAttribute("resultado", msj);
	cicloExtra.mapeaRegId(conElias, cicloId, oportunidad);
	
%>



<div id=content>

	<h2><fmt:message key="aca.Periodo" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary btn-mobile" href="notas.jsp?ciclo=<%=cicloId %>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form id="forma" name="forma" action="accion.jsp?Accion=2&ciclo=<%=cicloId %>" method="post">
	<input type="hidden" name="Accion">
		<fieldset>
			<label for="ciclo"><fmt:message key="aca.Ciclo" /></label>
			<input type="text" id="cicloId" name="cicloId" value="<%=cicloExtra.getCicloId()%>" size="8" maxlength="10" readonly>
		</fieldset>
		
		<fieldset>
			<label for="ciclo"><fmt:message key="aca.OportunidadId" /></label>
			<input type="text" id="OportunidadId" name="OportunidadId" value="<%=cicloExtra.getOportunidad()%>" size="8" maxlength="10" readonly>
		</fieldset>
		
		<fieldset>
				<label for="ValorAnterior"><fmt:message key="aca.ValorAnterior" /></label>
	        	<input type="text" id="ValorAnterior" name="ValorAnterior" value="<%=cicloExtra.getValorAnterior() %>" size="8" maxlength="10" />
		</fieldset>
		
		<fieldset>
				<label for="ValorExtra"><fmt:message key="aca.ValorExtra" /></label>
	        	<input type="text" id="ValorExtra" name="ValorExtra" value="<%=cicloExtra.getValorExtra()%>" size="8" maxlength="10" />
		</fieldset>
		
		<fieldset>
				<label for="OportunidadNombre"><fmt:message key="aca.OportunidadNombre" /></label>
	        	<input type="text" id="OportunidadNombre" name="OportunidadNombre" value="<%=cicloExtra.getOportunidadNombre()%>" size="8" maxlength="10" />
		</fieldset>
		
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key='boton.Guardar' /></button>
		</div>
	</form>
		
</div>

<%@ include file= "../../cierra_elias.jsp" %>