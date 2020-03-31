<%@page import="java.util.HashMap"%>
<%@page import="aca.ciclo.RepPromedio"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
<%@page import="aca.ciclo.UtilCiclo"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="aca.ciclo.CicloGrupo"%>
<%@ include file="../../con_elias.jsp"%>

<%
UtilCiclo uc = new UtilCiclo(conElias);

Map<String,String> mapCicloGrupo = new LinkedHashMap();
Map<String,String> mapGpoCurso = new LinkedHashMap();
Map<String,String> mapPeriodos = new LinkedHashMap();
Map<String,String> mapGruposAbiertos = new HashMap();

	if(request.getParameter("generaTablaGrupos")!=null){
		
			mapCicloGrupo.putAll(uc.getDatos(request.getParameter("escuela_id"), request.getParameter("ciclo_id"), "", ""));
	 		mapPeriodos.putAll(uc.periodos(request.getParameter("ciclo_id"), uc.getNivel_eval()));
			mapGruposAbiertos.putAll(uc.getGruposAbiertasCerradas(request.getParameter("ciclo_id"), uc.getNivel_eval()));	 		
			System.out.println(mapGruposAbiertos.size() + " " + uc.getNivel_eval());
	 		%>
	 		<table class="table">
	 		<thead>
	 			<tr>
	 				<th>Grupos</th>
	 				<% for(String periodos : mapPeriodos.keySet()){ %>
	 				<th style="text-align: center;"><%= mapPeriodos.get(periodos)%></th>
	 				<% } %>
	 			</tr>
	 		</thead>
	 		<tbody>
	 		<% for(String grupos : mapCicloGrupo.keySet()){ %>
	 			<tr>
	 				<td><%= mapCicloGrupo.get(grupos) %></td>
	 				<% for(String periodos : mapPeriodos.keySet()){
	 					String estado = "checked";
	 						if(mapGruposAbiertos.containsKey(grupos + "\t" + periodos)){
	 							String[] split = mapGruposAbiertos.get(grupos + "\t" + periodos).split(",");
	 							if(new Integer(split[0])==0){
	 								estado="";
	 							}
							}else{
								estado="disabled";
							}
	 				%>
	 				<td style="text-align: center;">
	 					<input type="checkbox" id="<%= grupos %>-<%= periodos %>" <%= estado %> onchange="cambiaGrupo('<%= grupos %>-<%= periodos %>');">
	 				</td>
	 				<% } %>
	 			</tr>
	 		<% } %>	
	 		</tbody>
	 		
	 		</table>
	 		<%	
	}
	
	
	if(request.getParameter("generaTablaMaterias")!=null){
		
		mapCicloGrupo.putAll(uc.getDatos(request.getParameter("escuela_id"), "", request.getParameter("ciclo_gpo_id"), ""));
 		mapPeriodos.putAll(uc.periodos(request.getParameter("ciclo_id"), uc.getNivel_eval()));
 		mapGruposAbiertos.putAll(uc.getMateriasAbiertasCerradas(request.getParameter("ciclo_gpo_id"), uc.getNivel_eval()));
 		System.out.println(mapGruposAbiertos.size() + " " + uc.getNivel_eval());
 		%>
 		<table class="table">
 		<thead>
 			<tr>
 				<th>Materias</th>
 				<% for(String periodos : mapPeriodos.keySet()){ %>
 				<th style="text-align: center;"><%= mapPeriodos.get(periodos)%></th>
 				<% } %>
 			</tr>
 		</thead>
 		<tbody>
 		<% for(String grupos : mapCicloGrupo.keySet()){ %>
 			<tr>
 				<td><%= mapCicloGrupo.get(grupos) %></td>
 				<% for(String periodos : mapPeriodos.keySet()){
 					String estado = "checked";
						if(mapGruposAbiertos.containsKey(grupos + "\t" + periodos)){
							String[] split = mapGruposAbiertos.get(grupos + "\t" + periodos).split(",");
							if(new Integer(split[0])==0){
								estado="";
							}
					}else{
						estado="disabled";
					}
 					%>
 				<td style="text-align: center;">
 				<input type="checkbox" id="<%= grupos %>-<%= periodos %>" <%= estado %> onchange="cambiaMateria('<%= grupos %>','<%= periodos %>');">
<%--  				<input <%= estado %> data-toggle="toggle" id="<%= grupos %><%= periodos %>" class="materia" data-on="Abierta" data-off="Cerrada" data-onstyle="success" data-offstyle="danger" data-size="mini" type="checkbox"> --%>
 				</td>
 				<% } %>
 			</tr>
 		<% } %>	
 		</tbody>
 		
 		</table>
 		<%	
	}
	
	if(request.getParameter("cerradura")!=null){
		int salida =0;
		if(request.getParameter("estado").equals("C")){
			System.out.println("cerrando");
			salida=uc.controlMateria("", request.getParameter("ciclo_gpo_id"), request.getParameter("periodo"), request.getParameter("curso_id"), request.getParameter("nivel_eval"), request.getParameter("estado"));
			if(salida!=0){
				uc.cierraMateria(request.getParameter("escuela"), request.getParameter("curso_id"), request.getParameter("ciclo_gpo_id"), request.getParameter("nivel_eval"), request.getParameter("ciclo_id"));
			}
		}else if(request.getParameter("estado").equals("A")){
			System.out.println("abriendo");
			salida=uc.controlMateria("", request.getParameter("ciclo_gpo_id"), request.getParameter("periodo"), request.getParameter("curso_id"), request.getParameter("nivel_eval"), request.getParameter("estado"));
			if(salida!=0){
				uc.abreMateria(request.getParameter("escuela"), request.getParameter("curso_id"), request.getParameter("ciclo_gpo_id"), request.getParameter("nivel_eval"), request.getParameter("ciclo_id"));
			}
		}
	}
	
	
	
%>
<%@ include file="../../cierra_elias.jsp"%>