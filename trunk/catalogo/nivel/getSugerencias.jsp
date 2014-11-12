<%@ include file= "../../con_elias.jsp" %>

<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivel"/>


<%
	String nivelId = request.getParameter("NivelId");

	Nivel.mapeaRegId(conElias, nivelId);
%>

<div><div class="nombre"><%=Nivel.getNivelNombre() %></div><div class="titulo"><%=Nivel.getTitulo() %></div><div class="gradoIni"><%=Nivel.getGradoIni() %></div><div class="gradoFin"><%=Nivel.getGradoFin() %></div><div class="notaMinima"><%=Nivel.getNotaMinima() %></div></div>

<%@ include file= "../../cierra_elias.jsp" %>