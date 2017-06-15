<%@page import="aca.ciclo.UtilTareaPlaneacion"%>
<%@ include file="../../con_elias.jsp"%>
<%
UtilTareaPlaneacion up = new UtilTareaPlaneacion();

int salida =0;
if(request.getParameter("numeroTareas")!=null){
	salida = up.tareasDiaGrupo(conElias, request.getParameter("ciclo_gpo_id"), request.getParameter("fecha"));
}
%>
<%= salida %>
<%@ include file="../../cierra_elias.jsp"%>
