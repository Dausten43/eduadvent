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

if(request.getParameter("genera_combos")!=null){
 	if(request.getParameter("ciclo_id")!=null && request.getParameter("ciclo_gpo_id")==null){
 		mapCicloGrupo.putAll(uc.getDatos(request.getParameter("escuela_id"), request.getParameter("ciclo_id"), "", ""));
 		System.out.println("Tamaño Arreglo = " + mapCicloGrupo.size());
 	}else if(request.getParameter("ciclo_gpo_id")!=null){
 		mapCicloGrupo.putAll(uc.getDatos(request.getParameter("escuela_id"), "", request.getParameter("ciclo_gpo_id"), ""));
 	}
 	
 	

}

if(request.getParameter("genera_periodos")!=null){
	mapCicloGrupo.putAll(uc.getDatos(request.getParameter("escuela_id"), request.getParameter("ciclo_id"), "", ""));
	System.out.println(uc.getNivel_eval());
	mapPeriodos.putAll(uc.periodos(request.getParameter("ciclo_id"), uc.getNivel_eval()));
}

if(request.getParameter("genera_materias"))


if(request.getParameter("genera_combos")!=null){
	out.print("<option value=\"");
	out.print("");
	out.print("\">");
	out.print("Seleccione un grupo");
	out.println("</option>");
	for(String key : mapCicloGrupo.keySet()){
		out.print("<option value=\"");
		out.print(key);
		out.print("\">");
		out.print(mapCicloGrupo.get(key));
		out.println("</option>");
	}
}
if(request.getParameter("genera_periodos")!=null){
	
	for(String key : mapPeriodos.keySet()){
		out.print("<option value=\"");
		out.print(key);
		out.print("\">");
		out.print(mapPeriodos.get(key));
		out.println("</option>");
	}
}



%>

<%@ include file="../../cierra_elias.jsp"%>