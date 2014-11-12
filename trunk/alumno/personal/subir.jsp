<%@ include file= "../../con_enoc.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%
	String matricula = (String) session.getAttribute("codigoAlumno");
%>
<head>
<script type="text/javascript" src="../js/prototype-1.6.js"></script>
<script type="text/javascript">
	function guardar(){
		if(document.formaEnviar.archivo.value != ""){
			document.formaEnviar.btnGuardar.disabled = true;
			document.formaEnviar.btnGuardar.value = "Guardando...";
			document.formaEnviar.submit();
		}else
			alert("<fmt:message key="aca.SeleccionarArchivo"/>");
	}
</script>
</head>
<body>
<table class="goback">
	<tr>
		<td><a href="datos.jsp">&lsaquo;&lsaquo; <fmt:message key="aca.Regresar"/></a></td>
	</tr>
</table>
<table width="80%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td align="center" class="title2" style="font-size:14pt;"> <fmt:message key="aca.SubirFotoAlumno"/></td>
  </tr>	
  <tr>
	<td align="center" class="title2" style="font-size:10pt;"><fmt:message key="aca.Alumno"/>: [<%=matricula%>] - <%= aca.alumno.AlumPersonal.getNombreAlumno(conEnoc, matricula, "NOMBRE")%></td>
  </tr>
</table>
<br>
<form name="formaEnviar" id="formaEnviar" enctype="multipart/form-data" action="guardar.jsp" method="post">
<table width="80%" align="center">
	<tr>
		<td><b><fmt:message key="aca.EligeFoto"/></b></td>
	</tr>
	<tr>
		<td><input type="file" id="archivo" name="archivo" /></td>
	</tr>	
	<tr>
		<td><button type="button" class="btn btn-primary" id="btnGuardar" onclick="guardar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></button></td>
	</tr>	
</table>
</form>
</body>
<%@ include file= "../../cierra_enoc.jsp" %>