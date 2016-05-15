<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="docU" scope="page" class="aca.archivo.ArchDocumentoLista" />
<jsp:useBean id="docA" scope="page" class="aca.archivo.ArchDocAlum" />
<jsp:useBean id="docAlumL" scope="page" class="aca.archivo.ArchDocAlumLista" />

<script>
	function guardar() {
		if (document.forma.fecha.value != "" && document.forma.Comentario.value != "") {
			document.forma.action += "?Accion=2";
			return true;
		} else {
			alert("<fmt:message key="aca.LlenarFormulario" />");
		}
		return false;
	}
</script>

<%
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String escuelaId 	= (String) session.getAttribute("escuela");
	String documento 	= request.getParameter("documentoId")==null?"0":request.getParameter("documentoId");
	String usuario 		= (String) session.getAttribute("codigoId");	
	String tipoCodigo 	= request.getParameter("tipo");	
	String salto		= "X";
	int accion 			= request.getParameter("Accion") == null ?0: Integer.parseInt(request.getParameter("Accion"));
	
	String nivelAlumno  = String.valueOf(aca.alumno.AlumPersonal.getNivel(conElias, codigoId));
	
	ArrayList<aca.archivo.ArchDocumento> lisDoc 		= docU.getListArchDocumentoNivel(conElias, escuelaId, nivelAlumno, " ORDER BY DOCUMENTO_ID");
	ArrayList<aca.archivo.ArchDocAlum> lisDocumentos 	= docAlumL.getListArchDocAlum(conElias, codigoId, "ORDER BY DOCUMENTO_ID");
	
	String Resultado = "";

	//operaciones a realizar 
	switch (accion) {
	
		case 0: { // Consulta
			docA.mapeaRegId(conElias, codigoId, escuelaId, request.getParameter("documentoId"));
			break;
		}

		case 2: { // Grabar y modificar
			docA.setCodigoId(codigoId);
			docA.setEscuelaId(escuelaId);
			docA.setDocumentoId(documento);
			docA.setFecha(request.getParameter("fecha"));
			docA.setComentario(request.getParameter("Comentario"));
			docA.setUsuario(usuario);

			if (docA.existeReg(conElias) == false) {
				if (docA.insertReg(conElias)) {
					Resultado = "Guardado";					
				} else {
					Resultado = "NoGuardo";
				}
			} else {
				if (docA.updateReg(conElias)) {
					Resultado = "Modificado";					
				} else {
					Resultado = "NoModifico";
				}
			}
			break;
		}

		case 3: {//borrar
			
			docA.setCodigoId(codigoId);
			docA.setEscuelaId(escuelaId);			
			docA.setDocumentoId(request.getParameter("documentoId"));

			if (docA.existeReg(conElias) == true) {
				if (docA.deleteReg(conElias)) {
					Resultado = "Eliminado";					
					salto = "docalum.jsp";
				} else {
					Resultado = "NoElimino";
				}
			} else {
				Resultado = "NoExiste";
			}
			lisDocumentos = docAlumL.getListArchDocAlum(conElias, codigoId, "ORDER BY DOCUMENTO_ID");
			break;

		}
	} // Fin de switch
	
	pageContext.setAttribute("resultado", Resultado);
%>
<div id="content">

	<h2><fmt:message key="boton.Anadir" /></h2>
	
	<% if (Resultado.equals("Eliminado") || Resultado.equals("Modificado") || Resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!Resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
		
	<div class="well" style="overflow: hidden;">
		<a href="docalum.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>


	<form id="forma" name="forma" action="documento.jsp" method="post">
		<input type="hidden" name="Accion">
	
		<fieldset>
			<label for="documentoId"> 
				<fmt:message key="archivo.Documentos"/>
			</label>
			<select id="documentoId" name="documentoId">
			<%
				for (aca.archivo.ArchDocumento doc: lisDoc) {
					boolean imprimir = true;
					for (aca.archivo.ArchDocAlum alumno: lisDocumentos) {
						if (alumno.getDocumentoId().equals(doc.getDocumentoId())) {
							imprimir = false;
						}
					}
					if (imprimir || doc.getDocumentoId().equals(documento)) {
			%>
						<option value="<%=doc.getDocumentoId()%>" <%=doc.getDocumentoId().equals(documento) ?"selected":""%>> <%=doc.getDocumentoNombre()%></option>
			<%
					}
				}
			%>
			</select>
		</fieldset>
				
		<fieldset>
			<label for="fecha"> <fmt:message key="aca.Fecha"/></label>
			<input type="text" id="fecha" name="fecha" value="<%=docA.getFecha()%>" maxlength="10" size="7" />
		</fieldset>
						 
		<fieldset>	
			<label for="Grado"> <fmt:message key="aca.Comentario"/>* </label>
			<textarea id="Comentario" name="Comentario" cols="25" rows="2"><%=docA.getComentario()%></textarea>
		</fieldset>
	
		<div class="well">		
			<button class="btn btn-primary btn-large" onclick="return guardar();">
				<i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar"/>
			</button>
		</div>
	</form>
	
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fecha').datepicker();
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>