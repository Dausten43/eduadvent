<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="docLista" scope="page" class="aca.archivo.ArchDocumentoLista"/>


<script>
	function Borrar( DocumentoId ){
		if(confirm("¿Estás seguro de eliminar el documento? ")==true){
	  		document.location="accion.jsp?Accion=4&DocumentoId="+DocumentoId;
	  	}
	}
</script>
	
<%
	String escuelaId 								= (String) session.getAttribute("escuela");
	ArrayList<aca.archivo.ArchDocumento> lisDoc		= docLista.getListAll(conElias, escuelaId, "ORDER BY DOCUMENTO_NOMBRE" );
%>

<div id="content">
	<h2><fmt:message key="archivo.ListadodeDocumentos" /></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="accion.jsp?Accion=1">
			<i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a>
	</div>
	
	<table class="table table-condensed">
		<tr> 
			<th><fmt:message key="aca.Operacion"/></th>
			<th><fmt:message key="archivo.Documentos"/></th>
		</tr>
<%
	for (int i=0; i< lisDoc.size(); i++){
		aca.archivo.ArchDocumento doc = (aca.archivo.ArchDocumento) lisDoc.get(i);
%>  
		<tr> 
			<td>
				<a href="accion.jsp?Accion=5&DocumentoId=<%=doc.getDocumentoId() %>" class="icon-pencil"></a>
				<a href="javascript:Borrar('<%=doc.getDocumentoId() %>')" class="icon-remove"></a>
			</td>
			<td><%=doc.getDocumentoNombre() %></td>
		</tr>
<%
	}	
%>  
	</table>
</div>
<%@ include file= "../../cierra_elias.jsp" %> 
