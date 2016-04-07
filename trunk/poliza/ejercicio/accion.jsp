<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="ejercicio" scope="page" class="aca.fin.FinEjercicio" />

<script>
	function grabar() {
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");

	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String resultado 	= "";
	String salto		= "X";

	if (accion.equals("1")) {//Grabar
		ejercicio.setEscuelaId(escuelaId);
		ejercicio.setYear(request.getParameter("Year"));
		ejercicio.setFechaIni(request.getParameter("FechaIni"));
		ejercicio.setFechaFin(request.getParameter("FechaFin"));	
			
		if (request.getParameter("Year").length() < 4){
			resultado = "ElAnoDebeTenerCuatroDigitos";
		}else{

			ejercicio.setEjercicioId(escuelaId + "-" + request.getParameter("Year"));

			if (ejercicio.existeReg(conElias)) {
				resultado = "EsteEjercicioYaExiste";
			} else {
				if (ejercicio.insertReg(conElias)) {
					resultado = "Guardado";
					session.setAttribute("EjercicioId", escuelaId + "-" + request.getParameter("Year"));
				} else {
					resultado = "NoGuardo";
				}
			}

		}
	} else if (accion.equals("2")) {
		ejercicio.setEjercicioId(request.getParameter("Id"));
		ejercicio.deleteReg(conElias);
		salto = "ejercicio.jsp";
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
		<a class="btn btn-primary" href="ejercicio.jsp">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	
	<form action="accion.jsp" method="post" name="forma" target="_self">
		
		<input type="hidden" name="Accion">
		
		<fieldset>
			<label for="Year"><fmt:message key="aca.Ano" /></label>
			<input type="text" size="4" maxlength="4" name="Year" id="Year">
		</fieldset>	
		
		<fieldset>
			<label for="FechaIni"><fmt:message key="aca.FechaInicio" /></label>
			<input type="text" size="4" maxlength="4" name="FechaIni" id="FechaIni">
		</fieldset>	
		
		<fieldset>
			<label for="FechaFin"><fmt:message key="aca.FechaFinal" /></label>
			<input type="text" size="4" maxlength="4" name="FechaFin" id="FechaFin">
		</fieldset>
		
					
	</form>
	
	<div class="well">
		<button class="btn btn-primary btn-large" type="button" onclick="grabar();">
			<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" />
		</button>
	</div>
		
</div>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FechaIni').datepicker();
	$('#FechaFin').datepicker();
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>