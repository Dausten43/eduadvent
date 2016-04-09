<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>


<% 
	String cursoId 		= request.getParameter("cursoId");
	String cicloGrupoId = request.getParameter("cicloGrupoId");
	String bloqueId  	= request.getParameter("bloqueId");

	
	ArrayList <aca.kardex.KrdxAlumEval> reprobones = kardexLista.getReprobones(conElias, cursoId, cicloGrupoId, bloqueId, "ORDER BY 1");
%>

<div id="content">

	<h2><fmt:message key="aca.Reprobados" /> <small><%=aca.plan.PlanCurso.getCursoNombre(conElias,cursoId) %></small></h2>
	
	<div class="well">
		<a href="alumnos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<table class="table table-condensed">
		<tr>
			<th>#</th>
			<th>Codigo</th>
			<th>Nombre</th>
			<th>Nota</th>
		</tr>
<% 
		int cont = 0;
		for(aca.kardex.KrdxAlumEval reprobado: reprobones){
			cont++;
%>
		<tr>
			<td><%=cont %></td>
			<td><%=reprobado.getCodigoId() %></td>
			<td><%=aca.alumno.AlumPersonal.getNombre(conElias, reprobado.getCodigoId(), "NOMBRE") %></td>
			<td><%=reprobado.getNota() %></td>
		</tr>
<%
		}
%>
	</table>


</div>



<%@ include file="../../cierra_elias.jsp" %>