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
	
	
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String msj 			= "";
	String cicloId 		= request.getParameter("ciclo")==null?"":request.getParameter("ciclo");	
	String oportunidad 	= request.getParameter("oportunidad")==null?"0":request.getParameter("oportunidad");
	
	cicloExtra.setCicloId(cicloId);
	String max 			= cicloExtra.maximoReg(conElias, cicloId);
	
	if(oportunidad.equals("0")){
		cicloExtra.setOportunidad(max);
		oportunidad=max;
	}

	
	if(accion.equals("2")){
		cicloExtra.setCicloId(cicloId);
		cicloExtra.setOportunidad(oportunidad);
		
		cicloExtra.setValorAnterior(request.getParameter("ValorAnterior"));
		cicloExtra.setValorExtra(request.getParameter("ValorExtra"));
		cicloExtra.setOportunidadNombre(request.getParameter("OportunidadNombre"));

		double total = Double.parseDouble(cicloExtra.getValorAnterior())+Double.parseDouble(cicloExtra.getValorExtra());
		
		if(total == 100){
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
		}else{
			msj = "La suma de Los porcentajes de Calificacion anterior y Oportunidad debe ser 100";
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
	
	<form name="forma" action="accion.jsp?Accion=2&ciclo=<%=cicloId %>" method="post">
	<input type="hidden" name="Accion">
		<fieldset>
			<label for="ciclo"><fmt:message key="aca.Ciclo" /></label>
			<input type="text" id="cicloId" name="cicloId" value="<%=cicloExtra.getCicloId()%>" size="8" maxlength="10" readonly>
		</fieldset>
		
		<fieldset>
			<label for="oportunidad"><fmt:message key="aca.OportunidadId" /></label>
			<input type="text" id="oportunidad" name="oportunidad" value="<%=cicloExtra.getOportunidad()%>" size="8" maxlength="10" readonly>
		</fieldset>
		
		<fieldset>
				<label for="ValorAnterior"><fmt:message key="aca.ValorAnteriorCalificacionPorcentaje"/> % </label>
	        	<input type="number" min="0" mad="100" step="0.01"id="ValorAnterior" name="ValorAnterior" value="<%=cicloExtra.getValorAnterior()%>" size="8" maxlength="10" />
		</fieldset>
		
		<fieldset>
				<label for="ValorExtra"><fmt:message key="aca.ValorOportunidadPorcentaje" /> % </label>
	        	<input type="number"  min="0" step="0.01" mad="100" id="ValorExtra" name="ValorExtra" value="<%=cicloExtra.getValorExtra()%>" size="8" maxlength="10" />
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