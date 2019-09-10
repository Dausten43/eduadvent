<%@ include file="../../con_elias.jsp"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.ciclo.CicloGrupoCursoLista"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Collections"%>

<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<%
	

	
	String cicloId_test = "H181919A";
	String empleadoId = "H18E0054";

	String cursoId = request.getParameter("planId");
	String grado = request.getParameter("grado");
	String cursoBaseId = request.getParameter("cursoBaseId");
	
	ArrayList<CicloGrupoCurso> lisClases = cicloGrupoCursoLista.getListMateriasEmpleado(conElias, cicloId_test, empleadoId, "ORDER BY CURSO_ID");
	
	for (CicloGrupoCurso clase: lisClases){
%>	
		<%=clase.getCursoId()%>
<%	
	}
	System.out.println(lisClases);
%>

<%@ include file= "../../cierra_elias.jsp" %>
