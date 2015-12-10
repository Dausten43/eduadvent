<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="ejercicio" scope="page" class="aca.fin.FinEjercicio" />

<script>	
	function Modificar(){
		document.forma.Accion.value = "3";
		document.forma.submit();
	}
	
	function Consultar(){
		document.forma.Accion.value = "5";
		document.forma.submit();		
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");

	String ejercicioId  = request.getParameter("EjercicioId")==null?"0":request.getParameter("EjercicioId");
	String accion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String resultado 	= "";
	
	if(accion.equals("3")){
		//ejercicio.setEjercicioId(ejercicioId);
		ejercicio.setEjercicioId(request.getParameter("EjercicioId"));
		ejercicio.setFechaIni(request.getParameter("FechaIni"));
		ejercicio.setFechaFin(request.getParameter("FechaFin"));		
		
		if (ejercicio.existeReg(conElias) == true){			
			if (ejercicio.updateReg(conElias)){
				resultado = "Modificado";
			}else{
				resultado = "Nocambio";
				accion = "5";
			}
		}else{			
			resultado = "NoExiste";
			accion = "5";
		}
	}
	
	else if( accion.equals("5") ){ // Consultar	
		ejercicio.setEjercicioId(ejercicioId);
		if (ejercicio.existeReg(conElias) == true){
			ejercicio.mapeaRegId(conElias, ejercicioId);			
		}else{
			resultado = "NoExiste";
		}		
	}	
	
	pageContext.setAttribute("resultado", resultado);
%>

<div id="content">

	<!-- <h2><fmt:message key="boton.Anadir" /></h2> -->
	
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
	
	<form action="editarEjercicio.jsp" method="post" name="forma" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="EjercicioId" value="<%=ejercicio.getEjercicioId()%>">
		
		<fieldset>
			<label for="Year"><fmt:message key="aca.Ano" /></label>
			<input type="text" size="4" maxlength="4" name="Year" id="Year" value="<%=ejercicio.getEjercicioId()%>" disabled>
		</fieldset>	
		
		<fieldset>
			<label for="FechaIni"><fmt:message key="aca.FechaInicio" /></label>
			<input type="text" size="4" maxlength="4" name="FechaIni" id="FechaIni" value="<%=ejercicio.getFechaIni()%>">
		</fieldset>	
		
		<fieldset>
			<label for="FechaFin"><fmt:message key="aca.FechaFinal" /></label>
			<input type="text" size="4" maxlength="4" name="FechaFin" id="FechaFin" value="<%=ejercicio.getFechaFin()%>">
		</fieldset>
		
		<div class="well">
			<%if( accion.equals("5") ){%>
					<a href="javascript:Modificar()" class="btn btn-primary btn-large" ><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
	        <%}%>
		</div>
					
	</form>
		
</div>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FechaIni').datepicker();
	$('#FechaFin').datepicker();
</script>

<%@ include file="../../cierra_elias.jsp"%>