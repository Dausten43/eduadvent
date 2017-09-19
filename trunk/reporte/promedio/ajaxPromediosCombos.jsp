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

if(request.getParameter("genera_materias")!=null){
	System.out.println("de aqui salen las materias");
		out.print("<option value=\"");
		out.print("");
		out.print("\">");
		out.print("Seleccione una materia");
		out.println("</option>");
		for(String key : mapCicloGrupo.keySet()){
			out.print("<option value=\"");
			out.print(key);
			out.print("\">");
			out.print(mapCicloGrupo.get(key));
			out.println("</option>");
		}
	
}


if(request.getParameter("genera_grupos")!=null){
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
	System.out.println("cambiando periodos");
	for(String key : mapPeriodos.keySet()){
		out.print("<option value=\"");
		out.print(key);
		out.print("\">");
		out.print(mapPeriodos.get(key));
		out.println("</option>");
	}
}

if(request.getParameter("genera_reporte")!=null){
	String cicloid = request.getParameter("cicloId")!=null ? request.getParameter("cicloId") :"";
	String cicloGpoId = request.getParameter("cicloGpoId")!=null ? request.getParameter("cicloGpoId") :"";
	String periodos = request.getParameter("periodos")!=null ? request.getParameter("periodos") :"-1";
	String materia = request.getParameter("materia")!=null ? request.getParameter("materia") :"";
	String limite = request.getParameter("limite")!=null ? request.getParameter("limite") :"";
	String nivel = request.getParameter("nivel")!=null ? request.getParameter("nivel") :"";
	String orden = request.getParameter("orden")!=null ? request.getParameter("orden") :"";
	System.out.println("-" + cicloid + "- -" + cicloGpoId +  "- -" + periodos + "- -" + materia+"-"+nivel+"-") ;
	
	Map<String,RepPromedio> mapPromedios = new LinkedHashMap();
	Map<String,RepPromedio> mapPromediosF = new LinkedHashMap();
	mapPromedios.putAll(uc.getPromedios(cicloid, cicloGpoId, materia, periodos, nivel, ""));
	
	for(String idProm : mapPromedios.keySet()){
		if(!materia.equals("")){
			if(mapPromedios.get(idProm).getCurso_id().equals(materia)){
				if(!limite.equals("")){
					String[] txtSp = limite.split("-");
					if(mapPromedios.get(idProm).getPromedio().compareTo(new BigDecimal(txtSp[0].trim()).setScale(7))>=0 
							&& 
					   mapPromedios.get(idProm).getPromedio().compareTo(new BigDecimal(txtSp[1].trim()).setScale(7))<=0	){
						mapPromediosF.put(idProm, mapPromedios.get(idProm))		;				
					}
				}else{
				mapPromediosF.put(idProm, mapPromedios.get(idProm))		;
				}
			}
		}else{
			if(!limite.equals("")){
				String[] txtSp = limite.split("-");
				if(mapPromedios.get(idProm).getPromedio().compareTo(new BigDecimal(txtSp[0].trim()))>=0 
						&& 
				   mapPromedios.get(idProm).getPromedio().compareTo(new BigDecimal(txtSp[1].trim()))<=0	){
					mapPromediosF.put(idProm, mapPromedios.get(idProm))		;				
				}
			}else{
			mapPromediosF.put(idProm, mapPromedios.get(idProm))		;
			}
		}
	}
	
	
	
	System.out.println(mapPromediosF.size());
	%>
	<table class="table table-bordered" >
	<tr>
		<th>#</th>
		<th>Grupo</th>
		<th>Alumno</th>
<!-- 		<th>Periodo</th> -->
		<% if(materia.equals("")){ %>
<!-- 		<th>Materias Evaluadas</th> -->
		<% }else{ %>
		<th>Materia</th>
		<% } %>
		<th>Promedio</th>
		<th></th>
	</tr>
	<% 
	int cont = 0;
	for(String idProm : mapPromediosF.keySet()){ 
	cont++;
	%>
	<tr>
		<td><%= cont %></td>
		<td><%= mapPromediosF.get(idProm).getCiclo_nombre() %></td>
		<td><%= mapPromediosF.get(idProm).getCodigo_id() %> <%= mapPromediosF.get(idProm).getNombre_alumno() %></td>
<%-- 		<td><%= mapPromediosF.get(idProm).getEvaluacion_id() %></td> --%>
		<% if(materia.equals("")){ %>
<%-- 		<td><%= mapPromediosF.get(idProm).getNumMaterias() %></td> --%>
		<% }else{ %>
		<td><%= mapPromediosF.get(idProm).getNombre_materia() %></td>
		<% } %>
		<td><%= mapPromediosF.get(idProm).getPromedio().setScale(4,RoundingMode.DOWN) %></td>
		<td><%= mapPromediosF.get(idProm).getPromedio() %></td>
	</tr>
	<% } %>
	</table>	
		
<%	}
	
	if(request.getParameter("reporte_materias")!=null){
		String cicloid = request.getParameter("cicloId")!=null ? request.getParameter("cicloId") :"";
		String cicloGpoId = request.getParameter("cicloGpoId")!=null ? request.getParameter("cicloGpoId") :"";
		String periodos = request.getParameter("periodos")!=null ? request.getParameter("periodos") :"-1";
		String materia = request.getParameter("materia")!=null ? request.getParameter("materia") :"";
		String limite = request.getParameter("limite")!=null ? request.getParameter("limite") :"";
		String nivel = request.getParameter("nivel")!=null ? request.getParameter("nivel") :"";
		String orden = request.getParameter("orden")!=null ? request.getParameter("orden") :"";
		System.out.println("-" + cicloid + "- -" + cicloGpoId +  "- -" + periodos + "- -" + materia+"-"+nivel+"-") ;
		
		Map<String,RepPromedio> mapPromedios = new LinkedHashMap();
		Map<String,RepPromedio> mapPromediosF = new LinkedHashMap();
		mapPromedios.putAll(uc.getPromedios(cicloid, cicloGpoId, materia, periodos,nivel,orden));
		
		for(String idProm : mapPromedios.keySet()){
			
				
					if(!limite.equals("")){
						String[] txtSp = limite.split("-");
						if(mapPromedios.get(idProm).getPromedio().compareTo(new BigDecimal(txtSp[0].trim()))>=0 
								&& 
						   mapPromedios.get(idProm).getPromedio().compareTo(new BigDecimal(txtSp[1].trim()))<=0	){
							mapPromediosF.put(idProm, mapPromedios.get(idProm))		;				
						}
					}else{
					mapPromediosF.put(idProm, mapPromedios.get(idProm))		;
					}
				
			
		}
		
		
		%>
		<table class="table table-bordered" >
		<tr>
			<th>#</th>
			<th>Grupo</th>
			<th>Alumno</th>
			<th>Periodo</th>
			<% if(materia.equals("")){ %>
			<th>Materias Evaluadas</th>
			<% }else{ %>
			<th>Materia</th>
			<% } %>
			<th>Promedio</th>
			<th></th>
		</tr>
		<%
		int cont = 0;
		for(String idProm : mapPromediosF.keySet()){ 
		cont++;
		%>
		<tr>
			<td><%= cont %></td>
			<td><%= mapPromediosF.get(idProm).getCiclo_nombre() %></td>
			<td><%= mapPromediosF.get(idProm).getCodigo_id() %> <%= mapPromediosF.get(idProm).getNombre_alumno() %></td>
			<td><%= mapPromediosF.get(idProm).getEvaluacion_id() %></td>
			<% if(materia.equals("")){ %>
			<td><%= mapPromediosF.get(idProm).getNumMaterias() %></td>
			<% }else{ %>
			<td><%= mapPromediosF.get(idProm).getNombre_materia() %></td>
			<% } %>
			<td><%= mapPromediosF.get(idProm).getPromedio().setScale(4,RoundingMode.DOWN) %></td>
			<td><%= mapPromediosF.get(idProm).getPromedio() %></td>
		</tr>
		<% } %>
		</table>
		
<%	}


%>

<%@ include file="../../cierra_elias.jsp"%>