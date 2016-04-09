<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%
	String cicloGrupo 		= (String) session.getAttribute("cicloGrupoId");
	String cursoId 			= (String) session.getAttribute("cursoId");
	String modulo 			= request.getParameter("ModuloId");
	String temaId			= request.getParameter("TemaId")==null?"0":request.getParameter("TemaId");
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

<div id="content">
	<h2><fmt:message key="aca.SubirArchivo" /> <small><%= aca.ciclo.CicloGpoTema.nombreTema(conElias,cicloGrupo,cursoId,temaId) %></small></h2>
	
	<div class="alert alert-info">
			<fmt:message key="aca.MensajeLimite10mb" />
	</div>
	
	<div class="well">
		<a href="modulo.jsp?ModuloId=<%= modulo%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form name="formaEnviar" id="formaEnviar" enctype="multipart/form-data" action="guardar.jsp?TemaId=<%=temaId%>&ModuloId=<%= modulo %>" method="post">
		<div class="alert alert-info">
			<input type="file" id="archivo" name="archivo""/>
		</div >
		<div class="well">
			  <button id="btnGuardar" onclick="guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></button>
		</div>
	</form>
	
</div>

<%@ include file="../../cierra_elias.jsp" %>