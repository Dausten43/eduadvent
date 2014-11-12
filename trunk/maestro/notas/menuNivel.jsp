<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<jsp:useBean id="CatNivelEsc" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="PermisoLista" scope="page" class="aca.ciclo.CicloPermisoLista"/>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId		= (String) session.getAttribute("cicloId");	
	ArrayList <aca.catalogo.CatNivelEscuela> lisNivel = CatNivelEsc.getListEscuela(conElias, escuelaId, "ORDER BY NIVEL_ID");
	ArrayList<aca.ciclo.CicloPermiso> lisConPermiso		= PermisoLista.getListConPermiso(conElias,cicloId,"ORDER BY NIVEL_ID");
%>

<div id="content">
<h2><fmt:message key="maestros.SeleccioneunNivel" />: <small>Ciclo: [<%=cicloId%>] &nbsp;<%=aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId)%></small></h2>
	<%for(aca.ciclo.CicloPermiso permiso : lisConPermiso){%>
       <br><a href="reporte.jsp?NivelId=<%=permiso.getNivelId() %>" class="btn" style="font-size:15pt;"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, permiso.getNivelId()) %></a><br>
	<%}%>
</div>
<%@ include file= "../../cierra_elias.jsp" %>