<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Tema" scope="page" class="aca.ciclo.CicloGpoTema" />
<jsp:useBean id="Modulo" scope="page" class="aca.ciclo.CicloGpoModulo" />


<%
	String cicloGrupo	= (String) session.getAttribute("cicloGrupoId");
		String cursoId	= (String) session.getAttribute("cursoId");
		String modulo	= request.getParameter("ModuloId");
		String temaId	= request.getParameter("TemaId") == null ? "0" : request.getParameter("TemaId");
		String salto	= "X";

		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

		int numAccion = 0;
		if (request.getParameter("Accion") != null)
			numAccion = Integer
					.parseInt(request.getParameter("Accion"));

		String resultado = "";

		if (numAccion == 1) {
			Tema.setCicloGrupoId(cicloGrupo);
			Tema.setCursoId(cursoId);
			Tema.setModuloId(modulo);
			Tema.setTemaId(Tema.maximoReg(conElias));
		} else {
			Tema.setTemaId(request.getParameter("TemaId"));
		}

		switch (numAccion) {

		case 0: { // Consulta
			Tema.mapeaRegId(conElias, cicloGrupo, temaId, cursoId);
			break;
		}

		case 2: { // Grabar
			Tema.setCicloGrupoId(cicloGrupo);
			Tema.setCursoId(cursoId);
			Tema.setModuloId(modulo);
			Tema.setTemaId(request.getParameter("TemaId"));
			Tema.setTemaNombre(request.getParameter("Nombre"));
			Tema.setDescripcion(request.getParameter("Descripcion"));
			Tema.setOrden(request.getParameter("Orden"));
			Tema.setFecha(request.getParameter("Fecha"));

			if (Tema.existeReg(conElias) == false) {
				if (Tema.insertReg(conElias)) {
					resultado = "Guardado";					
				} else {
					resultado = "NoGuardo";
				}
			} else {
				if (Tema.updateReg(conElias)) {
					resultado = "Modificado";					
				} else {
					resultado = "NoModifico";
				}
			}

			break;
		}
		case 3: {//borrar

			Tema.setCicloGrupoId(cicloGrupo);
			Tema.setCursoId(cursoId);
			Tema.setTemaId(request.getParameter("TemaId"));

			if (Tema.existeReg(conElias) == true) {
				if (Tema.deleteReg(conElias)) {
					resultado = "Eliminado";
					salto = "modulo.jsp?ModuloId="+modulo;
				} else {
					resultado = "NoElimino";
				}
			} else {
				resultado = "NoExiste";
			}
			break;
		}
		}
		
		pageContext.setAttribute("resultado", resultado);
		
		String maximoOrden = Tema.maximoOrden(conElias, cicloGrupo, cursoId, modulo);
%>

<div id="content">
	<h2>
		<%if(numAccion==1){%>
			<fmt:message key="boton.AnadirTema" />
		<%}else{%>
			<fmt:message key="boton.EditarTema" />
		<%} %>
	</h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a href="modulo.jsp?ModuloId=<%=modulo%>" class="btn btn-primary"><i
			class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form name="frmAlta" method="post" action="tema.jsp">
		<input name="Accion" type="hidden"> 
		<input type="hidden" name="ModuloId" value="<%=modulo%>">
		<input name="TemaId" type="hidden" id="TemaId" value="<%=Tema.getTemaId()%>" size="5" >
		
		<fieldset>
			<label for="Nombre"><fmt:message key="aca.Nombre" /></label> 
			<input name="Nombre" type="text" class="text input-xxlarge" id="Nombre" value="<%=Tema.getTemaNombre()%>"  maxlength="75">
		</fieldset>
		
		<fieldset>
			<label for="Fecha"><fmt:message key="aca.Fecha" /></label> 
			<input name="Fecha" type="text" class="text " id="Fecha" value="<%= !Tema.getFecha().equals("") ? Tema.getFecha() : sdf.format(new Date()) %>" readonly="readonly" style="cursor: pointer;">
		</fieldset>
		
		<fieldset>
			<label for="Descripcion"><fmt:message key="aca.Descripcion" /></label>
			<textArea name="Descripcion" id="Descripcion" rows="7" class="text input-xxlarge"><%=Tema.getDescripcion()%></textArea>
		</fieldset>
		
		<fieldset>
			<label for="Orden"><fmt:message key="aca.Orden" /></label>
			<input data-placement="right" title="<fmt:message key="aca.OrdenTemaMsj" />" class="onlyNumbers input-mini" maxlength="5" type="text" name="Orden" id="Orden" value="<%=Tema.getOrden().equals("")?maximoOrden:Tema.getOrden() %>" />
		</fieldset>
			
		<div class="well">
			<a class="btn btn-primary btn-large" href="javascript:grabar()">
				<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" />
			</a>
			<%
				if (aca.ciclo.CicloGpoTema.numTareas(conElias, Tema.getCicloGrupoId(), Tema.getCursoId(), Tema.getTemaId()) == 0 &&
					aca.ciclo.CicloGrupoArchivo.numArchivos(conElias, Tema.getCicloGrupoId(), Tema.getCursoId(), Tema.getTemaId()) == 0 &&
					numAccion != 1) {
			%>
					<a class="btn btn-danger btn-large" href="javascript:borrar()">
						<i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" />
					</a>
			<%
				}
			%>
		</div>
	</form>


</div>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();	
</script>

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Nombre').maxlength({ 
	    max: 75
	});
	
	$('#Descripcion').maxlength({ 
	    max: 2000
	});
	
	function grabar() {
		if (document.frmAlta.TemaId.value.value != ""
				&& document.frmAlta.Nombre.value != ""
				&& document.frmAlta.Orden.value != ""
				&& document.frmAlta.Fecha.value != "") {
			document.frmAlta.Accion.value = "2";
			document.frmAlta.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function borrar() {
		if (document.frmAlta.TemaId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmAlta.Accion.value = "3";
				document.frmAlta.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmAlta.TemaId.focus();
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

	
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>