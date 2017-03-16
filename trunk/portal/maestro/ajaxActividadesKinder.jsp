<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="aca.preescolar.CicloActividadEvaluacionPromedio"%>
<%@page import="java.util.List"%>
<%@page import="aca.preescolar.UtilPreescolar"%>
<%

String cicloid = request.getParameter("ciclo_id")!=null ? request.getParameter("ciclo_id") : "" ;
String cursoid = request.getParameter("curso_id")!=null ? request.getParameter("curso_id") : "" ;
String ciclogrupoid = request.getParameter("ciclo_grupo_id")!=null ? request.getParameter("ciclo_grupo_id") : "" ;

Integer promedioid = request.getParameter("promedioid")!=null ? new Integer(request.getParameter("promedioid")) : 0;
Integer evaluacionid = request.getParameter("evaluacionid")!=null ? new Integer(request.getParameter("evaluacionid")) : 0;
Integer actividadid = request.getParameter("actividadid")!=null ? new Integer(request.getParameter("actividadid")) : 0;

UtilPreescolar up = new UtilPreescolar();
List<CicloActividadEvaluacionPromedio> lsCAP = new ArrayList();
lsCAP.addAll(up.getCAEP(cicloid, cursoid, ciclogrupoid));
Map<Integer, CicloActividadEvaluacionPromedio> mapCAEP = new LinkedHashMap();
up.close();
List<Integer> lsEval = new ArrayList();
List<Integer> lsActi = new ArrayList();

//System.out.println(lsCAP.size() + "\t" + promedioid + "\t" );
if(request.getParameter("selectEvaluacion")!=null){
	%>
	<label>Criterio:</label>
	<select id="sEvaluacion" class="form-control">
	<option value="">Seleccione...</option>
	<%
	for(CicloActividadEvaluacionPromedio p : lsCAP){
		
		if(p.getPromedioId().equals(promedioid) && !lsEval.contains(p.getEvaluacionId())){
			lsEval.add(p.getEvaluacionId());
			%>
			<option value="<%=p.getEvaluacionId() %>"><%= p.getNombreEvaluacion() %></option>
			<%
			
		}
		
	}	
	
	%>
	</select>
	<%
}
%>
<%
if(request.getParameter("selectActividad")!=null){
	%>
	<label>Período:</label>
	<select id="sActividad" class="form-control">
	<option value="">Seleccione...</option>
	<%
	for(CicloActividadEvaluacionPromedio p : lsCAP){
		//System.out.println( (p.getPromedioId().equals(promedioid) && p.getEvaluacionId().equals(evaluacionid)) +"\t" + promedioid + "\t" + evaluacionid);
		if(p.getPromedioId().equals(promedioid) && p.getEvaluacionId().equals(evaluacionid)){
			
			%>
			<option value="<%=p.getActividadId() %>"><%= p.getNombreActividad() %></option>
			<%
			
		}
		
	}	
	
	%>
	</select>
	<%
}
%>
