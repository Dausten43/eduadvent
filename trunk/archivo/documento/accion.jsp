<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Doc" scope="page" class="aca.archivo.ArchDocumento"/>

<script>
	
	function Grabar(){
		if(document.forma.Documento.value!="" && document.forma.DocumentoId.value!=""){			
			document.forma.Accion.value="2";
			document.forma.submit();			
		}else{
			alert("<fmt:message key="aca.LlenarFormulario"/> ");
		}
	}
	
	function Borrar( ){
		if(confirm("<fmt:message key="aca.EliminarRegistro"/>")==true){
  			document.forma.Accion.value="4";
			document.forma.submit();
		}			
		
	}
	
	function Consultar(){
		document.forma.Accion.value="5";
		document.forma.submit();		
	}	
</script>

<%
	// Declaracion de variables	
	int nAccion				= Integer.parseInt(request.getParameter("Accion"));
	String sResultado		= "";
	String escuelaId 		= (String) session.getAttribute("escuela");
	String documentoId  	= documentoId = request.getParameter("DocumentoId");
	String salto			= "X";
	
	
	if(documentoId==null){
		documentoId = Doc.maximoReg(conElias, escuelaId);
	}
	
	if(documentoId==null){
		documentoId = request.getParameter("DocumentoId");
	}
		
	// Operaciones a realizar en la pantalla	
	switch (nAccion){
		
		case 2: { // Grabar
			conElias.setAutoCommit(false);
			Doc.setDocumentoId(request.getParameter("DocumentoId"));
			Doc.setDocumentoNombre(request.getParameter("Documento"));
			Doc.setEscuelaId(escuelaId);
			
			if (Doc.existeReg(conElias) == false){
				if (Doc.insertReg(conElias)){
					sResultado = "Guardado";
					conElias.commit();
				}else{
					sResultado = "NoGuardo";
				}
			}else{
				if (Doc.updateReg(conElias)){
					sResultado = "Modificado";
					conElias.commit();
				}else{
					sResultado = "NoModifico";
				}
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 4: { // Borrar
			conElias.setAutoCommit(false);
			Doc.setDocumentoId(request.getParameter("DocumentoId"));
			Doc.setEscuelaId(escuelaId);

			if (Doc.existeReg(conElias) == true){
				if (Doc.deleteReg(conElias)){
					sResultado = "Eliminado";
					conElias.commit();
					salto = "documento.jsp";
				}else{
					sResultado = "NoElimino ";
				}	
			}else{
				sResultado = "NoExiste";
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 5: { // Consultar	
			Doc.setDocumentoId(request.getParameter("DocumentoId"));
			Doc.setEscuelaId(escuelaId);
			
			if (Doc.existeReg(conElias) == true){
				Doc.mapeaRegId(conElias, escuelaId, request.getParameter("DocumentoId"));
			}else{
				sResultado = "NoExiste "; 
			}	
			break;			
		}
	}	
	if(documentoId==null){
		documentoId = Doc.getDocumentoId();
	}
	pageContext.setAttribute("resultado", sResultado);
	
%>

<div id="content">

	<h2><fmt:message key="archivo.Documentos" /></h2>
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a class="btn btn-primary"  href="documento.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a> 
	</div>
	
	<form action="accion.jsp" method="post" name="forma" target="_self">
		<input type="hidden" name="Accion">
		<input name="DocumentoId" type="hidden" id="DocumentoId" size="3" maxlength="3" value="<%=documentoId %>">
		    
	    <fieldset>
	    	<label for="Documento">
	        	<fmt:message key="aca.Documento" />
	        </label>
	       <input name="Documento" type="text" id="Documento" size="40" maxlength="30" value="<%=Doc.getDocumentoNombre() %>">
 	   </fieldset>
	
		<div class="well" style="overflow:hidden;">
		  	<a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a>
		  	<%if(nAccion!=1){ %>
		  		<a class="btn btn-danger btn-large" href="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
		  	<%} %>
		</div>
	</form>
	
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>
