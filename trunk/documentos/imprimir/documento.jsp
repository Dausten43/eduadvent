<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumConstanciaL" scope="page" class="aca.alumno.AlumConstanciaLista"/>
<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>
<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>

<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String codigoAlumno			= (String) session.getAttribute("codigoAlumno");
	String accion 				= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 					= "";
	
	if( AlumPersonal.existeReg(conElias, codigoAlumno) == false ){
		codigoAlumno = "";
	}
	
	ArrayList<aca.alumno.AlumConstancia> constancias = AlumConstanciaL.getListAll(conElias, escuelaId, " ORDER BY CONSTANCIA_ID ");

%>

<div id="content">
	
	<h2>
		<fmt:message key="alumnos.Constancias"/> <small>( <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> )</small>
	</h2>
	
	<form action="vistaPrevia.jsp" target="_blank">
	
		<div class="well">
			
			<select name="constanciaId" id="constanciaId" class="input-xxlarge">
			<%
				for(aca.alumno.AlumConstancia constancia: constancias){
			%>
					<option value="<%=constancia.getConstanciaId() %>"><%=constancia.getConstanciaNombre() %></option>
			<%
				}
			%>
			</select>
			
			<input value="<%=codigoAlumno %>" type="text" name="codigoId" id="codigoId" placeholder="Codigo del Alumno" style="margin:0;" class="input-medium" />
			
			<button class="btn btn-primary"><i class="icon-print icon-white"></i> Imprimir</button>
			
		</div>
	
	</form>
	
</div>	

<script>
	$('#codigoId').focus();
</script>

<%@ include file="../../cierra_elias.jsp" %>