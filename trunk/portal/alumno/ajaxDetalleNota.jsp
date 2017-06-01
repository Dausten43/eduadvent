
<%@page import="java.util.ArrayList"%>
<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="aca.kinder.Actividades"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kinder.Evaluacion"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="aca.kinder.UtilActividades"%>
<%@page import="aca.kinder.UtilEvaluacion"%>


<%

Connection conElias =  new Conectar().conEliasPostgres();

String alumnoid = request.getParameter("alumnoid")!=null ? request.getParameter("alumnoid") : "" ;
String criterio = request.getParameter("criterioid")!=null ? request.getParameter("criterioid") : "0" ;
String evaluacion = request.getParameter("evaluacion")!=null ? request.getParameter("evaluacion") : "0" ;

UtilEvaluacion ue = new UtilEvaluacion(conElias);
UtilActividades uac = new UtilActividades(conElias);
UtilAreas ua = new UtilAreas(conElias);
UtilCriterios uc = new UtilCriterios(conElias);

Map<Long, Evaluacion> mapEv = new HashMap();
mapEv.putAll(ue.getMapEvaluaciones(0L, "", 0L, 0, "", alumnoid, ""));
Map<Long, Evaluacion> mpEvf = new HashMap();
for(Evaluacion ev : mapEv.values()){
	mpEvf.put(ev.getActividad_id(),ev);
}

List<Actividades> lsActividades = new ArrayList();
//lsActividades.addAll(uac.getLsActividades(0L, "", "", 0L, new Long(criterio), "", 1,  new Integer(evaluacion)));
lsActividades.addAll(uac.getLsActividades(0L, "", "", 0L, new Long(criterio), "", 1, new Integer(evaluacion)));
	conElias.close();
%>
<table class="table table-bordered">
<% for(Actividades a : lsActividades){ 
		if(mpEvf.containsKey(a.getId())){
		
%>
<tr>
	<td><%= a.getActividad() %></td>
	<td><%= ue.calificacionTxt(mpEvf.get(a.getId()).getCalificacion()) %></td>
	
</tr>
<% 
		}
		} 
		

%>
</table>
