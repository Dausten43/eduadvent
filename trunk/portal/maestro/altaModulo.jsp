<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Modulo" scope="page" class="aca.ciclo.CicloGpoModulo" />

<%
		String cicloGrupo	= (String) session.getAttribute("cicloGrupoId");
		String cursoId		= (String) session.getAttribute("cursoId");
		String modulo		= "";
		String salto		= "X";

		int numAccion = 0;
		if (request.getParameter("Accion") != null){
			numAccion = Integer.parseInt(request.getParameter("Accion"));	
		}

		String resultado = "";

		if (numAccion == 1) {
			Modulo.setCicloGrupoId(cicloGrupo);
			Modulo.setCursoId(cursoId);
			Modulo.setModuloId(Modulo.maximoReg(conElias));
		} else {
			Modulo.setModuloId(request.getParameter("ModuloId"));
		}

		//operaciones a realizar

		switch (numAccion) {

		case 0: {
			Modulo.mapeaRegId(conElias, cicloGrupo, request.getParameter("ModuloId"), cursoId);
			break;
		}

		case 2: { // Grabar
			// verificar que sea de longitud 2
			modulo = request.getParameter("ModuloId").length() == 1 ? "0" + request.getParameter("ModuloId") : request.getParameter("ModuloId");

			Modulo.setCicloGrupoId(cicloGrupo);
			Modulo.setCursoId(cursoId);
			Modulo.setModuloId(modulo);
			Modulo.setModuloNombre(request.getParameter("Nombre"));
			Modulo.setDescripcion(request.getParameter("Descripcion"));
			Modulo.setOrden(request.getParameter("Orden"));

			if (Modulo.existeReg(conElias) == false) {
				if (Modulo.insertReg(conElias)) {
					resultado = "Guardado";					
				} else {
					resultado = "NoGuardo";
				}
			} else {
				if (Modulo.updateReg(conElias)) {
					resultado = "Modificado";					
				} else {
					resultado = "NoModifico";
				}
			}

			break;
		}
		case 3: {//borrar
			Modulo.setCicloGrupoId(cicloGrupo);
			Modulo.setCursoId(cursoId);
			Modulo.setModuloId(request.getParameter("ModuloId"));
			
			conElias.setAutoCommit(false);
			if (Modulo.existeReg(conElias) == true) {
				if (Modulo.deleteReg(conElias)) {
					resultado = "Eliminado";
					conElias.commit();
					salto = "modulo.jsp";
				} else {
					resultado = "NoElimino";
				}
			} else {
				resultado = "NoExiste";
			}
			conElias.setAutoCommit(true);
			
			break;
		}

		}

		modulo = request.getParameter("ModuloId") == null ? "0" : request.getParameter("ModuloId");
		
		pageContext.setAttribute("resultado", resultado);
		
		String maximoOrden = Modulo.maximoOrden(conElias, cicloGrupo, cursoId);
%>


<div id="content">
	<h2>
		<%if(numAccion==1){%>
			<fmt:message key="boton.AnadirModulo" />
		<%}else{%>
			<fmt:message key="boton.EditarModulo" />
		<%} %>
	</h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
  	<div class="well" style="overflow: hidden;">
		<a href="modulo.jsp?ModuloId=<%=modulo%>" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	
	<form name="frmAlta" method="post" action="altaModulo.jsp">
		<input name="Accion" type="hidden"> <input type="hidden" name="CicloGrupoId" value="<%=cicloGrupo%>"> 
		<input type="hidden" name="CursoId" value="<%=cursoId%>">
		<input name="ModuloId" type="hidden" class="text" id="ModuloId" value="<%=Modulo.getModuloId()%>" size="3" maxlength="3">

		<fieldset>
			<label for="Nombre"><fmt:message key="aca.Nombre" /></label>
			<input class="input-xxlarge" name="Nombre" type="text" class="text" id="Nombre" value="<%=Modulo.getModuloNombre()%>" size="30">
		</fieldset>
		
		<fieldset>
			<label for="Descripcion"><fmt:message key="aca.Descripcion" /></label>
			<textarea name="Descripcion" id="Descripcion" rows="10" class="input-xxlarge"><%=Modulo.getDescripcion()%></textarea>
		</fieldset>
		
		<fieldset>
			<label for="Orden"><fmt:message key="aca.Orden" /></label>
			<input data-placement="right" title="<fmt:message key="aca.OrdenModuloMsj" />" class="onlyNumbers input-mini" maxlength="5" type="text" name="Orden" id="Orden" value="<%=Modulo.getOrden().equals("")?maximoOrden:Modulo.getOrden() %>" />
		</fieldset>

		<div class="well" style="overflow: hidden;">
					<a class="btn btn-primary btn-large" href="javascript:grabar()">
						<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" />
					</a>
					<%
						if (aca.ciclo.CicloGpoModulo.numTemas(conElias, Modulo.getCicloGrupoId(), Modulo.getCursoId(), Modulo.getModuloId()) == 0
							&& numAccion != 1) {
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

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Nombre').maxlength({ 
	    max: 50
	});
/*
	$('#Descripcion').maxlength({ 
	    max: 2000
	});
*/	

	function grabar() {
		if (document.frmAlta.ModuloId.value != ""
				&& document.frmAlta.Nombre.value != ""
				&& document.frmAlta.Orden.value != "") {
			document.frmAlta.Accion.value = "2";
			document.frmAlta.submit();
		} else {
			alert("<fmt:message key="aca.LlenarFormulario" />");
		}
		cicloGrupo
	}

	function borrar() {
		if (document.frmAlta.ModuloId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmAlta.Accion.value = "3";
				document.frmAlta.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmAlta.ModuloId.focus();
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