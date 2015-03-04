<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%
	String codigoAlumno		= (String) session.getAttribute("codigoAlumno");
%>

<script>
	function guardar(){
		if(document.formaEnviar.archivo.value != ""){
			document.formaEnviar.btnGuardar.disabled = true;
			document.formaEnviar.btnGuardar.value = "Guardando...";
			document.formaEnviar.submit();
		}
	}
</script>

<link rel="stylesheet" href="../../js-plugins/bootstrap-fileupload/bootstrap-fileupload.min.css" />
<script src="../../js-plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>

<div id="content">
	
	<h2><fmt:message key="aca.SubirFotoAlumno"/></h2>
		
	<div class="well">
		<a href="catalogo.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>		
	</div>
	
	<div class="alert alert-info">
		<fmt:message key="aca.MensajeLimite5mb" />
	</div>

	<form name="formaEnviar" id="formaEnviar" enctype="multipart/form-data" action="guardar.jsp" method="post">
		
		<div class="well">
			<div class="fileupload fileupload-new" data-provides="fileupload">
				<div class="fileupload-new thumbnail" style="width: 50px; height: 50px;"><img src="http://www.placehold.it/50x50/EFEFEF/AAAAAA" /></div>
				<div class="fileupload-preview fileupload-exists thumbnail" style="width: 50px; height: 50px;"></div>
			  	<span class="btn btn-file">
			  		<span class="fileupload-new"><fmt:message key="boton.SeleccionaImagen" /></span>
			  		<span class="fileupload-exists"><fmt:message key="boton.Cambiar" /></span>
			  		<input type="file" id="archivo" name="archivo" />
			  	</span>
				<a href="#" class="btn fileupload-exists" data-dismiss="fileupload"><fmt:message key="boton.Quitar" /></a>
			</div>			
		</div>		
		<div class="well">
			<button type="button" id="btnGuardar" class="btn btn-primary btn-large" onclick="guardar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></button>
		</div>
	</form>	
</div>
<%@ include file="../../cierra_elias.jsp" %>