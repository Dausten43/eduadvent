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
	<h2><fmt:message key="aca.Importar"/>( <small><fmt:message key="aca.Alumno"/></small> )</h2>
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
				<th>M</th>
				<th>N</th>
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
				<td>Celular</td>
				<td>Nivel</td>
				<td>Grado</td>
				<td>Grupo</td>
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
				<td>Número</td>
				<td>Numero</td>
				<td>Letra</td>				
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
				<td>0,1,2,3,4</td>
				<td>1,2,3,4,5,6</td>
				<td>A,B,C,D</td>				
			</tr>
			<tr>
				<td><b>Ejemplo</b></td>
				<td>G</td>
				<td>Jorge Luis</td>
				<td>Martínez</td>
				<td>Garcia</td>
				<td>30/06/2005</td>
				<td>M</td>
				<td>jorgeluis05@hotmail.com</td>
				<td>Cumbres</td>
				<td>Calle La Fuente # 206</td>
				<td>(826)2635298</td>
				<td>8261069854</td>
				<td>2</td>
				<td>3</td>
				<td>A</td>				
			</tr>
		</tbody>
	</table>
	<form enctype="multipart/form-data" action="leerExcel.jsp" method="post">
		
		<p>
			<input type="file"  id="archivo" name="archivo" /><br>
		</p>			
		<div class="well">
			<button class="btn btn-primary btn-large"> Subir</button> &nbsp;&nbsp; <%=mensaje%>
		</div>
				
	</form>
</div>
<%@ include file="../../cierra_elias.jsp"%>