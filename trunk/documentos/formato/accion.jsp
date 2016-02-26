<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>


<%

	String escuelaId 			= (String) session.getAttribute("escuela");
	String codigoId 			= (String) session.getAttribute("codigoId");
	String constanciaId         = request.getParameter("constanciaId")==null?"":request.getParameter("constanciaId");
	
	String msj					= "";
	String accion 				= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	if(accion.equals("1")){//Guardar
		if(constanciaId.equals("")){
			AlumConstancia.setConstanciaId(AlumConstancia.maximoReg(conElias, escuelaId));	
			constanciaId = AlumConstancia.getConstanciaId();
		}else{
			AlumConstancia.setConstanciaId(constanciaId);
		}
		
		AlumConstancia.setEscuelaId(escuelaId);
		AlumConstancia.setConstanciaNombre(request.getParameter("nombre"));
		AlumConstancia.setConstancia(request.getParameter("constancia"));
		AlumConstancia.setCodigoId(codigoId);
		
		
		if( AlumConstancia.existeReg(conElias) ){
			if(AlumConstancia.updateReg(conElias)){
	       		msj = "Modificado";
	       		
			}else{
				msj = "NoModifico"; 
			}
		}else{
			if(AlumConstancia.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}
	}
	
	pageContext.setAttribute("resultado", msj);
	
	if(!constanciaId.equals("")){
		AlumConstancia.mapeaRegId(conElias, constanciaId, escuelaId);
	}

%>

<div id="content">
	
	<h2>
	<%
		if(constanciaId.equals("")){		
	%>
			<fmt:message key="boton.Anadir"/>
	<%
		}else{
	%> 
			<fmt:message key="boton.Editar"/>
	<%
		}
	%>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
  	<div class="alert alert-info">
  		<h5>Variables Disponibles:</h5>
  		#Escuela
  		&nbsp;
  		#Codigo
  		&nbsp;
  		#Nombre
  		&nbsp;
  		#Paterno
  		&nbsp;
  		#Materno
  		&nbsp;
  		#Curp
  		&nbsp;
  		#Nivel
  		&nbsp;
  		#Grado
  		&nbsp;
  		#Grupo
  		&nbsp;
  		#Estado
  		&nbsp;
  		#Ciudad
  		&nbsp;
  		#Fecha
  		&nbsp;
  		#Dia
  		&nbsp;
  		#Mes
  		&nbsp;
  		#Year
  		&nbsp;
  		#Foto
  		&nbsp;
  		#Calificaciones
  		#CIP
  		
  	</div>	
	
	<div class="well">
		<a href="documento.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar"/>
		</a>
		
	<%
		if(!constanciaId.equals("")){		
	%>
		<a href="accion.jsp" class="btn btn-primary">
			<i class="icon-plus icon-white"></i> <fmt:message key="boton.Nuevo"/>
		</a>
	<%
		}
	%>
	</div>
	
	<form action="" method="post" name="forma">
		<input type="hidden" name="Accion" value="1" />
		<input type="hidden" name="constanciaId" value="<%=constanciaId%>" />
	
		<p>
			<label for="nombre"><fmt:message key="aca.Nombre"/>:</label>
			<input class="input-xxlarge" type="text" id="nombre" name="nombre" value="<%=AlumConstancia.getConstanciaNombre() %>" />
		</p>
		<p>
		
			<label for="constancia"><fmt:message key="alumnos.Constancia"/>:</label>
			<!-- This <div> holds alert messages to be display in the sample page. -->
			<div id="alerts">
				<noscript>
					<p>
						<strong>CKEditor requires JavaScript to run</strong>. In a browser with no JavaScript
						support, like yours, you should still see the contents (HTML data) and you should
						be able to edit it normally, without a rich editor interface.
					</p>
				</noscript>
			</div>
			
			<textarea cols="500" id="constancia" name="constancia" rows="10">
				<% if(AlumConstancia.getConstancia().equals("")){ %>
						<p style="text-align:right">&nbsp;</p> <p style="text-align:right"><span style="font-size:14px"><strong>ASUNTO: CONSTANCIA DE&nbsp; ESTUDIOS</strong></span></p> <p style="text-align:right">&nbsp;</p> <p style="text-align:right">&nbsp;</p> <p style="text-align:right">&nbsp;</p> <p><span style="font-size:14px">A QUIEN CORRESPONDA</span></p> <p>&nbsp;</p> <p style="text-align:justify"><span style="font-size:14px">El que suscribe, Profesor Juan Perez, Director de la escuela primaria, perteneciente al Sistema Educativo Nacional con clave de incorporaci&oacute;n estatal: 1100294 y oficio 1234 con fecha Enero de 1944, hace constar que:</span><br /> &nbsp;</p> <p style="text-align:center"><span style="font-size:20px"><strong>#Nombre #Paterno #Materno</strong></span></p> <p style="text-align:justify"><br /> <span style="font-size:14px">Es alumno regular de &eacute;sta instituci&oacute;n cursa el #Grado de educaci&oacute;n #Nivel del curso escolar 2013-2014.</span></p> <p style="text-align:justify"><span style="font-size:14px">A petici&oacute;n de la interesado(a) y para los fines que a este convenga, se extiende la presente <strong>CONSTANCIA</strong>, en la ciudad de #Ciudad, #Estado a los #Dia d&iacute;as del mes de #Mes de #Year.</span></p> <p style="text-align:justify">&nbsp;</p> <p style="text-align:justify"><span style="font-size:14px">Atentamente</span></p> <p style="text-align:justify">&nbsp;</p> <p style="text-align:justify">&nbsp;</p> <p style="text-align:justify"><span style="font-size:14px">Prof. Juan Perez<br /> Director primaria</span></p> <p>&nbsp;</p>
				<% }else{%>
						<%=AlumConstancia.getConstancia() %>
				<% } %>
			</textarea>
		
		</p>
	</form>
		
	<div class="well">
		<button onclick="guardar();" class="btn btn-primary btn-large">
			<i class="icon-ok icon-white"></i>
			<fmt:message key="boton.Guardar"/>			
		</button>
	</div>
	
</div>	

<script src="../../js-plugins/ckeditor/ckeditor.js"></script>

<script>

	function guardar(){
		if(document.forma.nombre.value != "" && document.forma.constancia.value !=""){
			document.forma.submit();
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}

	// Replace the <textarea id="constancia"> with an CKEditor instance.
	CKEDITOR.replace( 'constancia', {
		on: {
			// Check for availability of corresponding plugins.
			pluginsLoaded: function( evt ) {
				var doc = CKEDITOR.document, ed = evt.editor;
				if ( !ed.getCommand( 'bold' ) )
					doc.getById( 'exec-bold' ).hide();
				if ( !ed.getCommand( 'link' ) )
					doc.getById( 'exec-link' ).hide();
			}
		},
		toolbar :
			[
				{ name: 'document', items : [ 'Source','-','DocProps','Preview','Print','-','Templates' ] },
				{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
				{ name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
				{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak' ] },
				{ name: 'links', items : [ 'Link','Unlink' ] },
				'/',
				{ name: 'tools', items : [ 'Maximize','-' ] },
				{ name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
				{ name: 'colors', items : [ 'TextColor','BGColor' ] },
				{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
				{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote',
				'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] }
				
			],
	});
	
	CKEDITOR.config.height = 500;

	
</script>


<%@ include file="../../cierra_elias.jsp" %>