<%@page import="aca.kinder.UtilCandado"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.Criterios"%>
<%@ include file="../../con_elias.jsp"%>
<%


UtilCriterios uc = new UtilCriterios(conElias);
UtilAreas ua = new UtilAreas(conElias); 
List<Criterios> lsCriterios = new ArrayList();
Map<Long, Areas> mapAreas = new HashMap();
UtilCandado ulock = new UtilCandado(conElias);



if(request.getParameter("guardarCriterio")!=null){
	System.out.println("entro a guardar");
	Criterios c = new Criterios();
	c.setArea_id(new Long(request.getParameter("area_id")));
	c.setCiclo_id(request.getParameter("ciclo_id"));
	c.setCriterio(request.getParameter("criterio"));
	uc.addCriterio(c);
}

if(request.getParameter("eliminar")!=null){
	Criterios c = new Criterios();
	c.setId(new Long(request.getParameter("idcriterio")));
	c.setEstado(new Integer(request.getParameter("estado")));
	uc.modifCriterio(c);
	
}

if(request.getParameter("modificar")!=null){
	Criterios c = new Criterios();
	c.setCriterio(request.getParameter("criterio"));
	c.setId(new Long(request.getParameter("idcriterio")));
	uc.modifCriterio(c);
	
}


if(request.getParameter("ciclo_id")!=null && request.getParameter("area_id")!=null){
	lsCriterios.addAll(uc.getLsCriterios(0L, "", request.getParameter("ciclo_id"), new Long(request.getParameter("area_id")), 1));
	mapAreas.putAll(ua.getMapAreas(0L, "", request.getParameter("ciclo_id"), 0));
	ulock.getBloqueaCriterio(request.getParameter("ciclo_id"), "");
	System.out.println("Tamaño arreglo " + ulock.getLsCriterios().size() + "  " + request.getParameter("ciclo_id"))  ;
}

%>
<table class="table table-bordered" style="width: 70%">
<thead>
	<tr>
		<th style="width: 5%">#</th>
		<th>Area</th>
		<th>Criterios</th>
		<th>Acción</th>
	</tr>
	</thead>
	<%
	int contador=0;
		for(Criterios c : lsCriterios){
			contador++;
			
			boolean isAbierto = true;
		
			if(ulock.getLsCriterios().contains(c.getId())){
				isAbierto = false;
			}
	%>
	<tr>
		<td><%= contador %></td>
		<td><%= mapAreas.containsKey(c.getArea_id()) ? mapAreas.get(c.getArea_id()).getArea() : c.getArea_id() %></td>
		<td><%= c.getCriterio()  %></td>
		<td style="text-align: center;"><a href="" onclick="modificar(<%= c.getId() %>, '<%= c.getCriterio() %>'); return false;" class="btn btn-mini btn-default">Modificar</a> 
		<%  if(isAbierto){ %><a href="" onclick="confirm('eliminar(<%= c.getId() %>,<%= (c.getEstado()*-1) %>)'); return false;"  class="btn btn-mini btn-danger">Eliminar</a><% } %></td>
	</tr>
	<% } %>
</table>
<%@ include file="../../cierra_elias.jsp"%>