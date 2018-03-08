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
<style>
		.cmn-toggle {
		  position: absolute;
		  margin-left: -9999px;
		  visibility: hidden;
		}
		.cmn-toggle + label {
		  display: block;
		  position: relative;
		  cursor: pointer;
		  outline: none;
		  user-select: none;
		}
		
		input.cmn-toggle-yes-no + label {
		  padding: 2px;
		  width: 120px;
		  height: 25px;
		}
		input.cmn-toggle-yes-no + label:before,
		input.cmn-toggle-yes-no + label:after {
		  display: block;
		  position: absolute;
		  top: 0;
		  left: 0;
		  bottom: 0;
		  right: 0;
		  color: #fff;
		  font-family: "Roboto Slab", serif;
		  font-size: 20px;
		  text-align: center;
		  line-height: 25px;
		}
		input.cmn-toggle-yes-no + label:before {
		  background-color: #dddddd;
		  content: attr(data-off);
		  transition: transform 0.5s;
		  backface-visibility: hidden;
		}
		input.cmn-toggle-yes-no + label:after {
		  background-color: #8ce196;
		  content: attr(data-on);
		  transition: transform 0.5s;
		  transform: rotateY(180deg);
		  backface-visibility: hidden;
		}
		input.cmn-toggle-yes-no:checked + label:before {
		  transform: rotateY(180deg);
		}
		input.cmn-toggle-yes-no:checked + label:after {
		  transform: rotateY(0);
		}
</style>

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
 		
 		
 		List<String> idcicloGrupo = new ArrayList(mapCicloGrupo.keySet());
 		
 		Map<String,List<String>> mapHijas = new HashMap();
		
		for(String curso_id : mapCicloGrupo.keySet()){
			String[] splitTxt = mapCicloGrupo.get(curso_id).split("\t");
			if(splitTxt[1].equals("-")){
				List<String> lsHijas = new ArrayList();
				for(String cursob : idcicloGrupo){
					String[] splitTxtB = mapCicloGrupo.get(cursob).split("\t");
					
					if(!splitTxtB[1].equals("-")){
						
						if(curso_id.trim().equals(splitTxtB[1].trim())){
							//System.out.println(curso_id +"\t" + mapCicloGrupo.get(cursob) + "\t" + curso_id.trim().equals(splitTxtB[1].trim()) ); 
							lsHijas.add(cursob);
						}
					}
				}
				if(!lsHijas.isEmpty()){
					mapHijas.put(curso_id, lsHijas);
				}
			}
		}
		
		System.out.println(mapHijas.size());
 		%>
 		<table class="table">
 		<thead>
 			<tr>
 				<th>Materias</th>
 				<% for(String periodos : mapPeriodos.keySet()){ %>
 				<th ><%= mapPeriodos.get(periodos)%><br>
 				<label>
 				<input type="checkbox" id="P<%= periodos %>" onchange="cambiaXPeriodo('P<%= periodos %>');"  >
 				 Todas las materias</label>
 				</th>
 				<% } %>
 			</tr>
 		</thead>
 		<tbody>
 		<% for(String grupos : mapCicloGrupo.keySet()){ 
 		String[] splitTxt = mapCicloGrupo.get(grupos).split("\t");
 		if(splitTxt[1].equals("-")){
 		%>
 			<tr>
 				<td><%= splitTxt[0] %></td>
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
 				<td >
 				<div class="switch" style="text-align: center;">
 				<input type="checkbox" style="text-align: center;" id="<%= grupos %>-<%= periodos %>" name="<%= grupos %><%= periodos %>" <%= estado %> onchange="cambiaMateria('<%= grupos %>','<%= periodos %>');" class="cmn-toggle cmn-toggle-yes-no P<%= periodos %>">
 				<label for="<%= grupos %>-<%= periodos %>" data-on="Abierto" data-off="Cerrado" style="text-align: center;"></label>
 				</div>
 				</td>
 				<% } %>
 			</tr>
 			<% 
 			if(mapHijas.containsKey(grupos)){
 				List<String> materias = mapHijas.get(grupos);
 				for(String hija : materias){
 				String[] splitTxtH = mapCicloGrupo.get(hija).split("\t");
 		 		if(!splitTxtH[1].equals("-")){
 		 			%>
 		 			<tr">
 		 				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%= splitTxtH[0] %></td>
 		 				<% for(String periodos : mapPeriodos.keySet()){
			 					String estado = "checked";
									if(mapGruposAbiertos.containsKey(hija + "\t" + periodos)){
										String[] split = mapGruposAbiertos.get(hija + "\t" + periodos).split(",");
										if(new Integer(split[0])==0){
											estado="";
										}
								}else{
									estado="disabled";
								}
			 					%>
			 				<td >
			 				<div class="switch" style="text-align: center;">
			 				<input type="checkbox" style="text-align: center;" id="<%= hija %>-<%= periodos %>" name="<%= hija %><%= periodos %>" <%= estado %> onchange="cambiaMateria('<%= hija %>','<%= periodos %>');" class="cmn-toggle cmn-toggle-yes-no P<%= periodos %>">
			 				<label for="<%= hija %>-<%= periodos %>" data-on="Abierto" data-off="Cerrado" style="text-align: center;"></label>
			 				</div>
			 				</td>
			 				<% } %>
 		 			</tr>
 		 			<%
 		 		}
 				}
 			}
 				
 				} 
 			 } %>	
 		</tbody>
 		
 		</table>
 		
 		<script>
 		$(function(){
 			$("input[id^='P']").each(function(){
 				//console.log(this.id);
 				var mainId = this.id;
 				$('.'+mainId).each(function(){
 					//console.log($(this).attr('id') + '\t' + $(this).attr('class') + '\t' + $(this).prop('checked')  + '\t' + mainId);
 					if($(this).prop('checked')){
						$('#'+mainId).prop('checked', true);
 					}
 				})
 			})
 		});
 		</script>
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