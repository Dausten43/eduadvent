<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Tarea" scope="page" class="aca.ciclo.CicloGrupoTarea"/>
<jsp:useBean id="tema" scope="page" class="aca.ciclo.CicloGpoTema"/>


<%
	String cicloGrupo 		= (String) session.getAttribute("cicloGrupoId");
	String cursoId 			= (String) session.getAttribute("cursoId");		
	String modulo 			= request.getParameter("ModuloId");
	String temaId			= request.getParameter("TemaId")==null?"0":request.getParameter("TemaId");
	String tareaId			= request.getParameter("Tarea");
	String salto			= "X";
	
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	
	int numAccion 				= 0;	
	if (request.getParameter("Accion")!=null) numAccion = Integer.parseInt(request.getParameter("Accion"));
		
	String isNueva = "no";		
	String resultado		= "";
	
	if (numAccion == 1){
		Tarea.setCicloGrupoId(cicloGrupo);
		Tarea.setCursoId(cursoId);
		Tarea.setTemaId(temaId);
		Tarea.setTareaId(Tarea.maximoReg(conElias));
		isNueva = "si"; 
	}else{		
		Tarea.setTareaId(request.getParameter("Tarea"));
	}
	
	//operaciones a realizar
	switch (numAccion){

		case 0: { // Consultar			
    		
			Tarea.mapeaRegId(conElias, cicloGrupo, cursoId, tareaId);		
		break;
		}	
		
		case 2: { // Grabar	
			Tarea.setCicloGrupoId(cicloGrupo);
			Tarea.setCursoId(cursoId);
			Tarea.setTemaId(temaId);
			Tarea.setTareaId(request.getParameter("Tarea"));
			Tarea.setTareaNombre(request.getParameter("Nombre"));
			Tarea.setFecha(request.getParameter("Fecha"));
			Tarea.setDescripcion(request.getParameter("Descripcion"));
			
			if (Tarea.existeReg(conElias) == false){
				if (Tarea.insertReg(conElias)){
					resultado = "Guardado";
				}else{
					resultado = "NoGuardo";
				}
			}else{				
				if (Tarea.updateReg(conElias)){
					resultado = "Modificado";
				}else{
					resultado = "NoModifico";
				}
			}
		break;
		}
		
		case 3:{//borrar
			Tarea.setCicloGrupoId(cicloGrupo);
			Tarea.setCursoId(cursoId);			
			Tarea.setTareaId(request.getParameter("Tarea"));
			
			if (Tarea.existeReg(conElias) == true){
				if (Tarea.deleteReg(conElias)){
					resultado = "Eliminado";
					salto = "modulo.jsp?ModuloId="+modulo;
				}else{
					resultado = "NoElimino";
				}	
			}else{
					resultado = "NoExiste";
			}
		break;
		}
	}  
	
	pageContext.setAttribute("resultado", resultado);
%>

<div id="content">
	<h2>
		<%if(numAccion==1){%>
			<fmt:message key="boton.AnadirTareas" />
		<%}else{%>
			<fmt:message key="boton.EditarTareas" />
		<%} %>
	</h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a href="modulo.jsp?ModuloId=<%=modulo%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	<form name="frmAlta" method="post" action="tarea.jsp">
		<input name="Accion" type= "hidden">
      	<input type="hidden" name="ModuloId" value="<%=modulo%>">
      	<input type="hidden" name="TemaId" value="<%=temaId%>">
		<input name="Tarea" type="hidden" id="Tarea" value="<%=Tarea.getTareaId()%>">
		<input type="hidden" id="isNueva" value="<%= isNueva %>">
		<input type="hidden" id="FechaOriginal" value="<%= Tarea.getFecha() %>">
		
		<fieldset>
			<label for="Nombre"><fmt:message key="aca.Titulo" /></label>
			<input name="Nombre" type="text" class="input-xxlarge" id="Nombre" value="<%=Tarea.getTareaNombre()%>" size="30" maxlength="50">
		</fieldset>
		<fieldset>
			<label for="Fecha"><fmt:message key="aca.FechaEntrega" /></label>
			<input name="Fecha" type="text" id="Fecha" size="10" maxlength="10" value="<%= !Tarea.getFecha().equals("") ? Tarea.getFecha() : sdf.format(new Date()) %>" readonly> <span style="font-weight: bolder; color: red;" id="numeroTareas"></span>
		</fieldset>
		<fieldset>
			<label for="Descripcion"><fmt:message key="aca.Descripcion" /></label>
			<textArea name="Descripcion" id="Descripcion" rows="7" class="input-xxlarge"><%= Tarea.getDescripcion() %></textArea>
		</fieldset>
		
		<div class="well">
			<a class="btn btn-primary btn-large" id="guardarLink" href="javascript:grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		<%
			if(numAccion != 1){
		%>
				<a class="btn btn-danger btn-large" href="javascript:borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
		<%
			}
		%>
		</div>
	</form>
   	<form >
	</form>
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker().on('changeDate', function(e){
		console.log("FECHAS REVISA " +$('#Fecha').val() + " " + $('#FechaOriginal').val())
		if($('#isNueva').val()=='si'){
			$('#Fecha').trigger('change');
		}else{
			if($('#Fecha').val()!=$('#FechaOriginal').val()){
				$('#Fecha').trigger('change');
			}else{
				$('#numeroTareas').html('');
				$('#guardarLink').attr("href","javascript:grabar()");
			}
		}
	});
</script>

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>
	$('#Nombre').maxlength({ 
	    max: 50
	});
	
	$('#Descripcion').maxlength({ 
	    max: 2000
	});
</script>


<script>
	function grabar(){
		if(document.frmAlta.Tarea.value!="" && document.frmAlta.Nombre!="" ){			
			document.frmAlta.Accion.value="2";
			document.frmAlta.submit();			
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
	
	function borrar( ){
		if(document.frmAlta.Tarea.value!=""){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
	  			document.frmAlta.Accion.value="3";
				document.frmAlta.submit();
			}			
		}else{
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmAlta.Tarea.focus(); 
	  	}
	}
</script>
<script src="../../js-plugins/ckeditor/ckeditor.js"></script>
<style>
	.cke{
		margin-bottom: 10px;
	}
</style>
<script>
	$(function() {
		if($('#isNueva').val()=='si')		
	    	$('#Fecha').trigger('change');
		
	})
	// Replace the <textarea id="constancia"> with an CKEditor instance.
	CKEDITOR.replace( 'Descripcion', {
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
	
	CKEDITOR.config.height = 200;

	const MAX_ACTIVIDADES = 200;
	
	$('#Fecha').change(function(){
		var ciclogpoid = '<%= cicloGrupo %>';
		var fecha = $(this).val();
		var numeroTareas = 0;
		var datadata = 'fecha='+fecha+'&ciclo_gpo_id='+ciclogpoid+'&numeroTareas=true';
		
		$.ajax({
			url : '../../portal/maestro/ajaxLimiteTareas.jsp',
			type : 'post',
			data : datadata,
			success : function(output) {
				numeroTareas = parseInt(output);
				if(numeroTareas >= MAX_ACTIVIDADES){
					$('#numeroTareas').html('Las ' + MAX_ACTIVIDADES + ' tareas para este día ya están asignadas. Selecciona una nueva fecha.');
					$('#guardarLink').attr("href", "javascript:void(0)");
				}else{
					$('#numeroTareas').html('');
					$('#guardarLink').attr("href","javascript:grabar()");
				}
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	});
	
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>