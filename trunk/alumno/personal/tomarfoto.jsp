<%@ include file= "../../con_enoc.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<%
	String matricula 	= (String) session.getAttribute("codigoAlumno");
	alumno.mapeaRegId(conEnoc,matricula);
%>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../academico.css" rel="STYLESHEET" type="text/css">	
	<script type="text/javascript" src="../../js/webcam.js"></script>
	<script>
        webcam.set_api_url( 'upload.jsp' );
        webcam.set_quality( 100 ); // JPEG quality (1 - 100)
        webcam.set_shutter_sound( true ); // play shutter click sound
    	webcam.set_hook( 'onComplete', 'my_completion_handler' );
    	
    	function take_snapshot() {
			// take snapshot and upload to server
			//if(confirm("¿ Deseas cambiar la foto del alumno ?")){
				document.getElementById('resultado').innerHTML = '<h1>Subiendo...</h1><br><img height=70 src="../../imagenes/cargando2.gif" />';
				webcam.snap();
			//}	
		}
	
		function my_completion_handler(msg) {
			// show JPEG image in page
			document.getElementById('resultado').innerHTML = '<h1>Fotografía Grabada!</h1>'+
			'<br><img height=340 src=foto.jsp?mat=<%=matricula%>&hola='+escape(new Date())+'>';
			
			// reset camera for another shot
			webcam.reset();
		}
	</script>
</head>
<body>
<form>
<table width="77%" cellspacing="0" cellpadding="0" align="center" bordercolor="#C8D4A3" border="1">
  <tr>
    <th style="font-size:12pt;" align="center" colspan="2">
      <b><fmt:message key="aca.Alumno"/>: [<%=matricula %>] &nbsp; <%=aca.alumno.AlumPersonal.getNombreAlumno(conEnoc, matricula, "NOMBRE") %></b>
    </th>
  </tr>    
  <tr>
    <td valign="top" width="50%">
      <table width="100%" border="0">        
        <tr valign="top">
          <td align="center">
            <div id="marco" align="center" style="width:400px; height:500px; margin-top:1em;-moz-border-radius:12px; background-color:#ddd;text-align:center;padding-top:20px;margin-bottom:1em;">
          	  <div align="center" id="cuadro" style="position:relative; left:20; width:360px; height:480px; overflow:hidden;">
	      		<div id="webcam" style="position:relative; left: -140px;">
		  		  <script>
	        		document.write( webcam.get_html(640, 480) );
		  		  </script>
		  		</div>
	  		  </div>
	  		</div>
	  	  </td>	
	    </tr>
	    <tr>
    	  <td align="center">      
      		<button type=button class="btn btn-primary" onClick="webcam.configure()"><i class="icon-wrench icon-white"></i> <fmt:message key="boton.Configurar"/></button>&nbsp;&nbsp;
	  		<button type=button class="btn btn-primary" onClick="take_snapshot()"><i class="icon-camera icon-white"></i> <fmt:message key="boton.TomarFoto"/></button>
	  	  </td>
	  	</tr>  	    	    
	  </table>		
    </td>
    <td valign="top" width="50%" align="center">
      <table width="100%" align="center">   	
        <tr>
          <td align="center">
      		<div id="resultado" style="margin-top:1em;-moz-border-radius:12px; background-color:#ddd;width:360px;text-align:center;height:500px;padding-top:15px;margin-bottom:1em;">
      		  <h1>¡<fmt:message key="aca.FotoActual"/>!</h1><br>
      		  <img height="340" src="foto.jsp?mat=<%=matricula%>">
      		</div>
      	  </td>
      	</tr>
      	<tr>
    	  <td align="center"><a href="datos.jsp" class="btn btn-primary" style="font-size:11pt;"><i class="icon-arrow-left"></i> <fmt:message key="boton.Regresar"/></a></td>
	  	</tr>
     </table> 	  	
    </td>
  </tr>    
</table>
</form>
</body>
<%@ include file= "../../cierra_enoc.jsp" %>