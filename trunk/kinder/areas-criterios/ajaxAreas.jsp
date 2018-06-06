<%@page import="aca.kinder.UtilCandado"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@ include file="../../con_elias.jsp"%>
<%


UtilAreas ua = new UtilAreas(conElias);
List<Areas> lsAreas = new ArrayList();
UtilCandado ulock = new UtilCandado(conElias);

if(request.getParameter("guardarArea")!=null){
	System.out.println("entro a guardar");
	Areas a = new Areas();
	a.setArea(request.getParameter("area"));
	a.setCiclo_id(request.getParameter("ciclo_id"));
	ua.addArea(a);
}

if(request.getParameter("eliminar")!=null){
	Areas a = new Areas();
	a.setId(new Long(request.getParameter("idarea")));
	a.setEstado(new Integer(request.getParameter("estado")));
	ua.modifArea(a);
	
}

if(request.getParameter("modificar")!=null){
	Areas a = new Areas();
	a.setArea(request.getParameter("area"));
	a.setId(new Long(request.getParameter("idarea")));
	ua.modifArea(a);
	//lsAreas.addAll(ua.getLsAreas(0L, "", request.getParameter("ciclo_id"), 0));
}


if(request.getParameter("ciclo_id")!=null){
	lsAreas.addAll(ua.getLsAreas(0L, "", request.getParameter("ciclo_id"), 1));
	ulock.getBloqueaArea(request.getParameter("ciclo_id"));
}

%>

<table class="table table-bordered" style="width: 50%">
<thead>
	<tr>
		<th style="width: 5%">#</th>
		<th>Áreas</th>
		<th>Acción</th>
	</tr>
	</thead>
	<%
	int contador = 0;
		for(Areas a : lsAreas){
			contador++;
			boolean isAbierto = true;
			if(ulock.getLsAreas().contains(a.getId())){
				isAbierto = false;
			}
	%>
	<tr>
		<td><%= contador %></td>
		<td><%= a.getArea() %></td>
		<td style="text-align: center;"><a href="" onclick="modificar(<%= a.getId() %>, '<%= a.getArea() %>'); return false;" class="btn btn-mini btn-default">Modificar</a> 
		<% if(isAbierto){ %><a href="#" onclick="confirm('eliminar(<%= a.getId() %>,<%= (a.getEstado()*-1) %>)'); return false;" class="btn btn-mini btn-danger">Eliminar</a><% } %></td>
	</tr>
	<% } %>
</table>

<%@ include file="../../cierra_elias.jsp"%>