<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String codigoId			= (String) session.getAttribute("codigoPersonal");
	String mensaje			= request.getParameter("mensaje")==null?" ":request.getParameter("mensaje");
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
	<h2><fmt:message key="aca.Importar"/> <small><fmt:message key="aca.Empleado"/></small></h2>
	<hr>
	<h4>Estructura del archivo</h4>
	<table class="table table-striped">
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th>A</th>
				<th>B</th>
				<th>C</th>
				<th>D</th>
				<th>E</th>
				<th>F</th>
				<th>G</th>
				<th>H</th>
				<th>I</th>	
				<th>J</th>
				<th>K</th>
				<th>L</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><b>Dato</b></td>
				<td>Grabar</td>	
				<td>Nombre</td>
				<td>Apellido Paterno</td>
				<td>Apellido Materno</td>
				<td>Fecha Nacimiento</td>
				<td>Genero</td>
				<td>Correo</td>
				<td>Colonia</td>
				<td>Dirección</td>
				<td>Tel. Casa</td>
				<td>Ocupación</td>
				<td>Estado</td>
			</tr>
			<tr>
				<td><b>Formato</b></td>
				<td>Texto</td>
				<td>Texto</td>
				<td>Texto</td>
				<td>Texto</td>
				<td>DD/MM/YYYY</td>
				<td>Letra</td>
				<td>Texto</td>
				<td>Texto</td>
				<td>Texto</td>
				<td>Texto</td>
				<td>Texto</td>
				<td>Texto</td>
			</tr>
			<tr>
				<td><b>Valores</b></td>
				<td>G</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>M,F</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>A,I</td>
			</tr>
			<tr>
				<td><b>Ejemplo</b></td>
				<td>G</td>
				<td>Jorge Luis</td>
				<td>Martínez</td>
				<td>Garcia</td>
				<td>30/06/1980</td>
				<td>M</td>
				<td>jorgeluis80@hotmail.com</td>
				<td>Cumbres</td>
				<td>Calle La Fuente # 206</td>
				<td>(826)2635298</td>
				<td>Ingeniero</td>
				<td>A</td>
			</tr>
		</tbody>
	</table>
	<form enctype="multipart/form-data" action="leerExcel.jsp?verificar=1" method="post">
		
			<p>
				<input type="file"  id="archivo" name="archivo" /><br>
			</p>			
			<div class="well">
				<button class="btn btn-primary btn-large"> Subir</button> &nbsp;&nbsp; <%=mensaje%>
			</div>
		</form>
</div>
<%@ include file="../../cierra_elias.jsp"%>