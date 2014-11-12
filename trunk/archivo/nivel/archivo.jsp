<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="docU" scope="page" class="aca.archivo.ArchDocumentoLista" />
<jsp:useBean id="docNivelU" scope="page" class="aca.archivo.ArchDocNivelLista" />
<jsp:useBean id="docNivel" scope="page" class="aca.archivo.ArchDocNivel" />
<jsp:useBean id="nivelLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista" />

<%
	String escuelaId = (String) session.getAttribute("escuela");
	String nivelId = request.getParameter("nivelId") == null ? "1" : request.getParameter("nivelId");
	String accion = request.getParameter("Accion") == null ? "0" : request.getParameter("Accion");
	String resultado = "";

	if(accion.equals("1")){
		docNivel.setEscuelaId(escuelaId);
		docNivel.setDocumentoId(request.getParameter("DocumentoId"));
		docNivel.setNivelId(nivelId);

		if(docNivel.existeReg(conElias) == false){
			if (docNivel.insertReg(conElias)) {
				resultado = "Guardado";
			} else {
				resultado = "NoGuardo ";
			}
		} else {
			resultado = "DocAsignado";
		}
	}else if (accion.equals("2")){
		docNivel.setEscuelaId(escuelaId);
		docNivel.setDocumentoId(request.getParameter("DocumentoId"));
		docNivel.setNivelId(nivelId);

		if (docNivel.deleteReg(conElias)) {
			resultado = "Eliminado";
		} else {
			resultado = "NoElimino";
		}
	}

	
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel 		= nivelLista.getListEscuela(conElias, escuelaId, "ORDER BY NIVEL_ID");
	ArrayList<aca.archivo.ArchDocumento> lisDoc 	= docU.getListArchDocumento(conElias, escuelaId, "ORDER BY DOCUMENTO_ID");
	ArrayList<aca.archivo.ArchDocNivel> lisDocNivel	= docNivelU.getListDocNivel(conElias, escuelaId, nivelId, "ORDER BY NIVEL_ID");
	
	
	pageContext.setAttribute("resultado", resultado);
%>

<div id="content">

	<h2><fmt:message key="aca.ArchivosPorNivel" /></h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
		
	<form id="forma" name="forma" action="archivo.jsp" method="post" target="_self">
		<input type="hidden" name="Accion">
		<div class="well">
			<select name="nivelId" id="nivelId" onchange="document.forma.submit();">
			<%
				for (aca.catalogo.CatNivelEscuela nivel: lisNivel) {
			%>
					<option value="<%=nivel.getNivelId()%>" <%=nivel.getNivelId().equals(nivelId) ? "Selected" : ""%> ><%=nivel.getNivelNombre()%></option>
			<%
				}
			%>
			</select>
		</div>
	</form>


	<div class="row">
		
		<div class="span5">
		
			<table class="table table-condensed table-striped table-bordered">
				<thead>
					<tr>
						<th><fmt:message key="archivo.DocumentosDisponibles"/></th>
					</tr>
				</thead>
			<%
				int cont = 0;
				for (aca.archivo.ArchDocumento doc: lisDoc) {
					for (aca.archivo.ArchDocNivel doc1: lisDocNivel) {
						if (doc.getDocumentoId().equals(doc1.getDocumentoId())) {
							cont = 1;
						}
					}
					
					if (cont == 0) {
			%>
						<tr>
							<td>
								<a href="archivo.jsp?Accion=1&DocumentoId=<%=doc.getDocumentoId()%>&nivelId=<%=nivelId%>"><%=doc.getDocumentoNombre()%></a>
							</td>
						</tr>
			<%
					}
					cont = 0;
				}
			%>
			</table>
		</div>
		
		<div class="span5">
			<table class="table table-condensed table-striped table-bordered">
				<tr>
					<th><fmt:message key="aca.DocumentosRequeridos"/></th>
				</tr>
			<%
				for(aca.archivo.ArchDocNivel doc: lisDocNivel){
			%>
					<tr>
						<td>
							<a href="archivo.jsp?Accion=2&DocumentoId=<%=doc.getDocumentoId()%>&nivelId=<%=nivelId%>">
								<%=aca.archivo.ArchDocumento.getNombreDoc(conElias, doc.getDocumentoId(), escuelaId)%>
							</a>
						</td>

					</tr>
			<%
				}
			%>
			</table>	
		</div>
		
	</div>

</div>

<%@ include file="../../cierra_elias.jsp"%>