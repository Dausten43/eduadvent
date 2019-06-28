<%@ include file="../../con_elias.jsp"%>
<jsp:useBean id="PlanCursoLista"  class="aca.plan.PlanCursoLista" scope="page"/>
<%
	
	String planId = request.getParameter("planId");
	String grado = request.getParameter("grado");
	String cursoBaseId = request.getParameter("cursoBaseId");
	
	ArrayList<aca.plan.PlanCurso> lisCursos	= PlanCursoLista.getCursosPorGrado(conElias, planId, grado, "ORDER BY CURSO_NOMBRE");

	for(aca.plan.PlanCurso cursos : lisCursos)
	{
%>	
		<option value="<%= cursos.getCursoId()%>" <%=cursos.getCursoId().equals(cursoBaseId)?" Selected":""%>><%= cursos.getCursoNombre() %></option>
<%
	}
%>
<%@ include file= "../../cierra_elias.jsp" %>