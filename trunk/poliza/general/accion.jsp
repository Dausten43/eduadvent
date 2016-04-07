<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
	
<script>
	function Guardar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>	
	
<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	String polizaId     = request.getParameter("polizaId")==null?"":request.getParameter("polizaId");
	String salto		= "X";
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	String accion 	 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if(accion.equals("1")){//Grabar
		
		if(polizaId.equals("")){
			polizaId = escuelaId + FinPoliza.maximoReg(conElias, ejercicioId);
		}
		
		FinPoliza.setEjercicioId(ejercicioId);
		FinPoliza.setPolizaId(polizaId);
		FinPoliza.setFecha(request.getParameter("Fecha"));
		FinPoliza.setDescripcion(request.getParameter("Descripcion"));
		FinPoliza.setUsuario(usuario);
		FinPoliza.setEstado("A");//Abierta
		FinPoliza.setTipo("G"); //General
		
		if(FinPoliza.existeDelUsuario(conElias)){
			if(FinPoliza.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModifico";
			}
		}else{
			if(FinPoliza.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}
		
	}else if(accion.equals("2")){//Eliminar
		FinPoliza.setEjercicioId(ejercicioId);
		FinPoliza.setPolizaId(polizaId);
		FinPoliza.setUsuario(usuario);
		
		if(FinPoliza.existeDelUsuario(conElias)){
			if(FinPoliza.deleteReg(conElias)){
				salto = "poliza.jsp";
			}else{
				msj = "NoElimino";
			}
		}else{
			msj = "NoExiste";
		}
	}
	
	pageContext.setAttribute("resultado", msj);
%>
<div id="content">
	<h2>
		<fmt:message key="boton.Anadir" />
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <%=ejercicioId.replace(escuelaId+"-","")%>
	</div>
	
	<div class="well">
		<a href="poliza.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	 	
	<form action="" method="post" name="forma">
	
		<input type="hidden" name="Accion" />
		<input type="hidden" name="polizaId" value="<%=polizaId%>" />
		
		<fieldset>
			<label for="Fecha"><fmt:message key="aca.Fecha" /></label>
			<input type="text" name="Fecha" id="Fecha" value="<%=FinPoliza.getFecha() %>" />
		</fieldset>
		
		<fieldset>
			<label for="Descripcion"><fmt:message key="aca.Descripcion" /></label>
			<textarea name="Descripcion" id="Descripcion" rows="3" class="input-large"><%=FinPoliza.getDescripcion() %></textarea>
		</fieldset>
		
	</form>
	
	<div class="well">
		<a href="javascript:Guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
	</div>

</div>	

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>
	$('#Descripcion').maxlength({ 
	    max: 70
	});
</script>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
</script>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>