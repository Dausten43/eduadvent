<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>


<jsp:useBean id="empleado" scope="page" class="aca.empleado.EmpPersonal"/>
<%
	String matricula 	= (String) session.getAttribute("codigoEmpleado");
	empleado.mapeaRegId(conElias,matricula);
%>

<script type="text/javascript" src="../../js/webcam.js"></script>
<script>
	Webcam.set({
		jpeg_quality: 100,
		upload_name: 'photo',
	});
   	
   	function take_snapshot() {
		// take snapshot and upload to server
		//if(confirm("¿ Deseas cambiar la foto del alumno ?")){
			document.getElementById('resultado').innerHTML = '<div class="alert alert-info"><fmt:message key="aca.Subiendo"/></div>'+
			'<img height="70" style="margin-top:80px;" src="../../imagenes/cargando2.gif" />';
			Webcam.snap(function(data_uri) {
				Webcam.upload(data_uri, '/edusystems/api/imagenes/user/<%=matricula%>?next=/escuela/alumno/datos/tomarfoto.jsp', function(code, err) {
					if(code === 200) {				
						document.getElementById('resultado').innerHTML = '<div class="alert alert-info"><fmt:message key="aca.FotoGrabada"/></div>'+
							'<img height="340" style="border:1px solid gray;" src=foto.jsp?mat=<%=matricula%>&hola='+escape(new Date())+'>';
					}
				})
			});
		//}	
	}
</script>


<div id="content">

	<h2><fmt:message key="boton.TomarFoto"/> <small><%=empleado.getNombre(conElias, matricula, "NOMBRE") %></small></h2>
	
	<div class="well">
		<a href="empleado.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>

	<form action="">	
		<div class="row">
			<div class="span4">
				<div class="alert alert-info" style="text-align:center;">
						<fmt:message key="boton.Camara" />
				</div>
			
		       	<div id="webcam" align="center" id="cuadro" style="width:360px; height:480px; overflow:hidden; border:1px solid gray;">
		 			</div>
			 		  <script>
			 		 	Webcam.attach( '#webcam' );
			 		  </script>
				
				<br>
				
				<div class="well" style="width:322px;text-align:center;">
		  	  		<a class="btn btn-primary" onClick="take_snapshot()"><i class="icon-camera icon-white"></i> <fmt:message key="boton.TomarFoto"/></a>
		  	  		<!--<a class="btn btn-primary" onClick="webcam.configure()"><i class="icon-wrench icon-white"></i></a>-->
				</div>
				
			</div>
			<div class="span4">
				<div id="resultado" style="text-align:center;">
					<div class="alert alert-info">
						<fmt:message key="aca.FotoActual" />
					</div>
					<img style="border:1px solid gray;" height="340" src="foto.jsp?mat=<%=matricula%>">
				</div>
			</div>
		</div>
	</form>

</div>

<%@ include file= "../../cierra_elias.jsp" %>