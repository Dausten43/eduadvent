<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	String escuelaId 		= (String) session.getAttribute("escuela");
	String documentoId		= request.getParameter("DocumentoId");
	String hoja				= request.getParameter("Hoja")==null?"0":request.getParameter("Hoja");	
%>

<script>
	function guardar(){
		if(document.formaEnviar.archivo.value != ""){
			document.formaEnviar.btnGuardar.disabled = true;
			document.formaEnviar.btnGuardar.value = "<fmt:message key="aca.Guardando" />";
			document.formaEnviar.submit();
		}else{
			alert("<fmt:message key="aca.SeleccioneArchivo" />");
		}
	}
</script>

<link rel="stylesheet" href="../../js-plugins/bootstrap-fileupload/bootstrap-fileupload.min.css" />
<script src="../../js-plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>


<div id="content">
	
	<h2>
		<fmt:message key="aca.SubirImagen" />
		<small><%= aca.archivo.ArchDocumento.getNombreDoc(conElias, documentoId, escuelaId)%> </small>
	</h2>
	
	<div class="well">
		<a href="docalum.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<div class="alert alert-info">
		<ul style="margin-bottom:0;">
			<li><fmt:message key="aca.MensajeLimite10mb" /></li>
			<li><fmt:message key="aca.SoloImagenes" /></li>
		</ul>
	</div>
	
	<form name="formaEnviar" id="formaEnviar" enctype="multipart/form-data" action="guardar.jsp?DocumentoId=<%=documentoId%>&Hoja=<%=hoja%>" method="post">
		<div class="well">
			<div class="fileupload fileupload-new" data-provides="fileupload">
			  <div class="fileupload-new thumbnail" style="width: 50px; height: 50px;"><img src="http://www.placehold.it/50x50/EFEFEF/AAAAAA" /></div>
			  <div class="fileupload-preview fileupload-exists thumbnail" style="width: 50px; height: 50px;"></div>
			  <span class="btn btn-file"><span class="fileupload-new"><fmt:message key="boton.SeleccionaImagen" /></span><span class="fileupload-exists"><fmt:message key="boton.Cambiar" /></span><input type="file" id="archivo" name="archivo" /></span>
			  <a href="#" class="btn fileupload-exists" data-dismiss="fileupload"><fmt:message key="boton.Quitar" /></a>
			</div>	
		</div >
		
		<div class="well">
			  <button id="btnGuardar" onclick="guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></button>
		</div>
	</form>
	
</div>
<%@ include file="../../cierra_elias.jsp" %>