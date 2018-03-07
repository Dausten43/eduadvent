<%@page import="aca.kinder.Criterios"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.UtilCandado"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@ include file="../../con_elias.jsp"%>

<%
UtilAreas ua = new UtilAreas(conElias);
UtilCriterios uc = new UtilCriterios(conElias);
List<Areas> lsAreas = new ArrayList();
String escuelaId = (String) session.getAttribute("escuela");


if(request.getParameter("showOrigen")!=null){
	Map<Long, Areas> mapAreas = ua.getMapAreas(0L, "", request.getParameter("ciclo_id"), 1);
	Map<Long, Criterios> mapCriterios = uc.getMapCriterios(0L, "", request.getParameter("ciclo_id"), 0L, 1);
	
	%>
	<table class="table table-bordered">
	<caption>ORIGEN : <%= request.getParameter("texto")!=null ? request.getParameter("texto") : "" %></caption>
		<thead>
			<tr>
				<th>Datos en Origen</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
		<% for(Long idar : mapAreas.keySet()){  %>
			<tr>
				<td><%= mapAreas.get(idar).getArea() %></td>
				<td></td>
			</tr>
			<% for(Long idcr : mapCriterios.keySet()){ 
				if(mapCriterios.get(idcr).getArea_id().equals(idar)){
			%>
			<tr>
				<td></td>
				<td><%= mapCriterios.get(idcr).getCriterio() %></td>
			</tr>
		<% 			} 
				}	
			}
		%>	
		</tbody>
	</table>
	<%
}

if(request.getParameter("transfiere")!=null){
	
	Map<Long, Areas> mapAreas = ua.getMapAreas(0L, "", request.getParameter("ciclo_id"), 1);
	Map<Long, Criterios> mapCriterios = uc.getMapCriterios(0L, "", request.getParameter("ciclo_id"), 0L, 1);
	
	String ciclo_destino = request.getParameter("ciclo_destino")!=null ? request.getParameter("ciclo_destino") : "-";
	
	Map<Long, Areas> mapAreasDes = ua.getMapAreas(0L, "", ciclo_destino, 1);
	Map<Long, Criterios> mapCriteriosDes = uc.getMapCriterios(0L, "", ciclo_destino, 0L, 1);
	%>
	<table class="table table-bordered">
	<caption>DESTINO: <%= request.getParameter("textoDestino")!=null ? request.getParameter("textoDestino") : "" %></caption>
	<thead>
			<tr>
				<th>Datos en Destino</th>
				<th></th>
			</tr>
		</thead>
	<%
	System.out.println(mapAreasDes.size() + " "+ mapCriteriosDes.size());
	if(!ciclo_destino.equals("-") && mapAreasDes.size()==0 && mapCriteriosDes.size()==0){
		for(Long idarea : mapAreas.keySet()){
			Areas ar = mapAreas.get(idarea);
			if(!ar.getArea().equals("")){
				Areas arN = new Areas();
				arN.setArea(ar.getArea());
				arN.setCiclo_id(ciclo_destino);
				Long idAreaNuevo = ua.addAreaId(arN);
				%>
				<tr>
					<td><%= arN.getArea() %> </td>
					<td></td>
				</tr>
				<%
				if(idAreaNuevo.compareTo(new Long(0))!=0){
					for(Long idcri : mapCriterios.keySet()){
						Criterios cr = mapCriterios.get(idcri);
						if(cr.getArea_id().equals(ar.getId())){
							if(!cr.getCriterio().equals("")){
								Criterios crN = new Criterios();
								crN.setArea_id(idAreaNuevo);
								crN.setCiclo_id(ciclo_destino);
								crN.setCriterio(cr.getCriterio());
								uc.addCriterio(crN);
								%>
								<tr>
									<td></td>
									<td><%= crN.getCriterio() %> </td>
								</tr>
								<%								
							}
						}
					}
				}
			}
		}
		
	}else{%>
		<tr>
		<td colspan="2">ciclo destino ya tiene datos <input type="hidden" id="resultado" value="false"></td>
		</tr>
		<%
	}
	
	%>
	</table>
	<%
}



%>
<%@ include file="../../cierra_elias.jsp"%>