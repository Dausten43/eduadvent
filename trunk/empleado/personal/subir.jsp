<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%
	String codigoEmpleado		= (String) session.getAttribute("codigoEmpleado");
%>

<script>
	function guardar(){
		if(document.formaEnviar.archivo.value != ""){
			document.formaEnviar.btnGuardar.disabled = true;
			document.formaEnviar.btnGuardar.value = "Guardando...";
			document.formaEnviar.submit();
		}else
			alert("<fmt:message key="aca.SeleccionaArchivo"/>");
	}
</script>

<link rel="stylesheet" href="../../js-plugins/bootstrap-fileupload/bootstrap-fileupload.min.css" />
<script src="../../js-plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>

<div id="content">
	
	<h2><fmt:message key="empleados.SubirFotoEmpleado"/></h2>
		
	<div class="well">
		<a href="empleado.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>		
	</div>
	
	<div class="alert alert-info">
		<fmt:message key="aca.MensajeDimensiones" />:
		<ul>
			<li>360x480</li>
			<li>480x640</li>
			<li>600x800</li>
			<li>720x960</li>
			<li>768x1024</li>
		</ul>
		<fmt:message key="aca.MensajeLimite150kb" />
	</div>

	<form name="formaEnviar" id="formaEnviar" enctype="multipart/form-data" action="guardar.jsp" method="post">
		
		<div class="well">
			<div class="fileupload fileupload-new" data-provides="fileupload">
			  <div class="fileupload-new thumbnail" style="width: 50px; height: 50px;"><img src="http://www.placehold.it/50x50/EFEFEF/AAAAAA" /></div>
			  <div class="fileupload-preview fileupload-exists thumbnail" style="width: 50px; height: 50px;"></div>
			  <span class="btn btn-file"><span class="fileupload-new"><fmt:message key="boton.SeleccionaImagen" /></span><span class="fileupload-exists"><fmt:message key="boton.Cambiar" /></span><input type="file" id="archivo" name="archivo" /></span>
			  <a href="#" class="btn fileupload-exists" data-dismiss="fileupload"><fmt:message key="boton.Quitar" /></a>
			</div>			
		</div>
		
		<div class="well">
			<button type="button" id="btnGuardar" class="btn btn-primary btn-large" onclick="guardar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></button>
		</div>
	</form>
	
</div>


<%@ include file="../../cierra_elias.jsp" %>