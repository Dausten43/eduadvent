<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>

<%
	String matricula 	= (String) session.getAttribute("codigoAlumno");
	alumno.mapeaRegId(conElias,matricula);
%>

<script type="text/javascript" src="../../js/webcam.js"></script>
<script>
    webcam.set_api_url( 'upload.jsp' );
    webcam.set_quality( 100 ); // JPEG quality (1 - 100)
    webcam.set_shutter_sound( true ); // play shutter click sound
   	webcam.set_hook( 'onComplete', 'my_completion_handler' );
   	
   	function take_snapshot() {
		// take snapshot and upload to server
		//if(confirm("¿ Deseas cambiar la foto del alumno ?")){
			document.getElementById('resultado').innerHTML = '<div class="alert alert-info"><fmt:message key="aca.Subiendo"/></div>'+
			'<img height="70" style="margin-top:80px;" src="../../imagenes/cargando2.gif" />';
			webcam.snap();
		//}	
	}

	function my_completion_handler(msg) {
		// show JPEG image in page
		document.getElementById('resultado').innerHTML = '<div class="alert alert-info"><fmt:message key="aca.FotoGrabada"/></div>'+
		'<img height="340" style="border:1px solid gray;" src=foto.jsp?mat=<%=matricula%>&hola='+escape(new Date())+'>';
		
		// reset camera for another shot
		webcam.reset();
	}
</script>


<div id="content">

	<h2><fmt:message key="boton.TomarFoto"/> <small><%=aca.alumno.AlumPersonal.getNombre(conElias, matricula, "NOMBRE") %></small></h2>
	
	<div class="well">
		<a href="alumno.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/></a>
	</div>

	<form action="">	
		<div class="row">
			<div class="span4">
				<div class="alert alert-info" style="text-align:center;">
						<fmt:message key="boton.Camara" />
				</div>
			
		       	<div align="center" id="cuadro" style="width:360px; height:480px; overflow:hidden; border:1px solid gray;">
		    		<div id="webcam" style="position:relative; left: -140px;">
			 		  <script>
			      			document.write( webcam.get_html(640, 480) );
			 		  </script>
		 			</div>
				</div>
				
				<br>
				
				<div class="well" style="width:322px;text-align:center;">
		  	  		<a class="btn btn-primary" onClick="take_snapshot()"><i class="icon-camera icon-white"></i> <fmt:message key="boton.TomarFoto"/></a>
		  	  		<a class="btn btn-primary" onClick="webcam.configure()"><i class="icon-wrench icon-white"></i></a>
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