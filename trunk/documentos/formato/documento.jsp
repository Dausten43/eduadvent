<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumConstanciaL" scope="page" class="aca.alumno.AlumConstanciaLista"/>
<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>

<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String accion 				= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 					= "";
	
	if(accion.equals("1")){//Eliminar
		AlumConstancia.setConstanciaId(request.getParameter("constanciaId"));
		AlumConstancia.setEscuelaId(escuelaId);
		
		if(AlumConstancia.deleteReg(conElias)){
			msj = "Eliminado";
		}else{
			msj = "NoElimino";
		}
	}

	pageContext.setAttribute("resultado", msj);

	ArrayList<aca.alumno.AlumConstancia> constancias = AlumConstanciaL.getListAll(conElias, escuelaId, " ORDER BY CONSTANCIA_ID ");

%>

<div id="content">
	
	<h2>
		<fmt:message key="alumnos.Constancias"/> <small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> )</small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a href="accion.jsp" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir"/></a>
	</div>
	
	<table class="table table-condensed">
		<tr>
			<th>#</th>
			<th>Accion</th>
			<th>Constancia</th>
			<th>Vista Previa</th>
		</tr>
	
	<%
		int cont = 0;
		for(aca.alumno.AlumConstancia constancia: constancias){
			cont++;
	%>
		<tr>
			<td><%=cont %></td>
			<td>
				<a href="javascript:borrar('<%=constancia.getConstanciaId()%>')"><i class="icon-remove"></i></a>
				<a href="accion.jsp?constanciaId=<%=constancia.getConstanciaId() %>"><i class="icon-pencil"></i></a>
			</td>
			<td><%=constancia.getConstanciaNombre() %></td>
			<td>
				<a target="_blank" href="vistaPrevia.jsp?constanciaId=<%=constancia.getConstanciaId() %>" class="btn btn-info btn-mini"><i class="icon-resize-full icon-white"></i></a>
			</td>
		</tr>
	<%
		}
	%>
	
	</table>
	
</div>	

<script>
	function borrar(constanciaId){
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			location.href = "documento.jsp?Accion=1&constanciaId="+constanciaId;
		}
	}
</script>

<%@ include file="../../cierra_elias.jsp" %>