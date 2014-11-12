<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<%@ page import= "aca.vista.AlumnoCurso"%>

<%@page import="aca.catalogo.CatNivel"%>
<jsp:useBean id="KrdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="pais" scope="page" class="aca.catalogo.CatPais"/> 
<jsp:useBean id="estado" scope="page" class="aca.catalogo.CatEstado"/> 
<jsp:useBean id="ciudad" scope="page" class="aca.catalogo.CatCiudad"/> 
<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/> 
<jsp:useBean id="personal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />

<%
	String cicloGrupoId		= request.getParameter("CicloGrupoId");
	String cursoId			= request.getParameter("Curso");	
	String codigoId 		= request.getParameter("CodigoId");
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	//INFORMACION DEL MAESTRO
	empPersonal.mapeaRegId(conElias, codigoId);
	
	String matricula 		= "";	
	String nivelId			= "";
%>

<div id="content">
	<h2><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> <small><%=empPersonal.getNombre() + " " + empPersonal.getApaterno()+ " " + empPersonal.getAmaterno()%></small></h2> 

	<hr />	

	<div class="row">
	
<%	
	ArrayList<aca.kardex.KrdxCursoAct> lisAlumnos 		= KrdxCursoActL.getListAlumMat(conElias, cicloGrupoId, cursoId, "ORDER BY 1");	
	for(int j=0; j<lisAlumnos.size();j++){
		
		aca.kardex.KrdxCursoAct alumno = (aca.kardex.KrdxCursoAct) lisAlumnos.get(j);
		matricula = alumno.getCodigoId();
		if ((j % 2) == 0 && j!=0) { %></div><div class="row"> <%}
		
		// Obtiene la información de los alumnos
		personal.mapeaRegId(conElias, matricula);
		pais.mapeaRegId(conElias, personal.getPaisId());
		estado.mapeaRegId(conElias, personal.getPaisId(), personal.getEstadoId());
		ciudad.mapeaRegId(conElias, personal.getPaisId(), personal.getEstadoId(), personal.getCiudadId());
		
		String nombre 		= personal.getApaterno()+" "+personal.getAmaterno()+" "+personal.getNombre();
		boolean inscrito 	= aca.vista.AlumInscrito.estaInscrito(conElias,matricula);
		nivelId				= String.valueOf(aca.alumno.AlumPlan.getNivelAlumno(conElias, matricula));		
		alumPlan.mapeaRegActual(conElias, matricula);
		
		
%>

		<div class="span5 alert alert-info">
			<table>
				<tr>
					<td style="vertical-align: top;">
						<img src="imagen.jsp?mat=<%=matricula%>" width="70px">
						<br> 	
						<%=matricula%>
					</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>
							<font size=2><b><%=nombre%></b></font>
							<br>
							<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId) %>
							<br>
							<%=CatNivel.getGradoNombre(Integer.parseInt(personal.getGrado()))%> "<%= alumPlan.getGrupo() %>"
							<br>
							<%=aca.alumno.AlumPersonal.getEdad(conElias, matricula)%> <fmt:message key="aca.Anos" /> (<%=personal.getFNacimiento()%>)
							<br>
							<% if(personal.getGenero().equals("M")){%><fmt:message key="aca.Hombre" /><%}else{%><fmt:message key="aca.Mujer" /><%} %>
							<br>
							<% if(inscrito){ %><fmt:message key="aca.Inscrito" /><%}else{ %><fmt:message key="aca.NoInscrito" /><%} %>
					</td>
				</tr>
			</table>
		</div>
	
<%	}%>

	</div>

</div>

<%@ include file= "../../cierra_elias.jsp" %>