<%@page import="java.util.List"%>
<%@ include file="../../con_elias.jsp"%>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista" />
<%
String escuelaId = (String) session.getAttribute("escuela");
String cicloId = (String) session.getAttribute("cicloId");
String ciclogpoid = request.getParameter("ciclo_gpo_id")!=null ? request.getParameter("ciclo_gpo_id") : "";


List<String> lsAlumnosGpo = new ArrayList();

if(request.getParameter("ciclo_gpo_id")!=null){
	lsAlumnosGpo.addAll(krdxCursoActL.getListAlumnosGrupo(conElias, request.getParameter("ciclo_gpo_id")));
}
if(lsAlumnosGpo.size()>0){
	%>
	<a onclick="generar()" class="btn btn-default">Imprimir Boletín General</a>
	<table class="table table-bordered" style="width: 60%;">
  <tr>
    <th>#</th>
    <th>Alumno</th>
    <th></th>
  </tr>
  <%
  int cont=0;
  	for(String codigoid : lsAlumnosGpo){
  		cont++;
  %>
  <tr>
    <td><%= cont %></td>
    <td><%= aca.alumno.AlumPersonal.getNombre(conElias, codigoid, "APELLIDO") %></td>
    <td><a onclick="generar('<%= codigoid %>')" class="btn btn-default">Boletín Individual</a></td>
  </tr>
  <%
	}
  %>
</table>

	<% 
}
%>


<%@ include file="../../cierra_elias.jsp"%>