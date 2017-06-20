<%@page import="aca.kinder.UtilCandado"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.Actividades"%>
<%@page import="aca.kinder.Criterios"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kinder.UtilActividades"%>
<%@ include file="../../con_elias.jsp"%>
<%
SimpleDateFormat sdfA = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sdfB = new SimpleDateFormat("dd-MM-yyyy");

String codigoId = session.getAttribute("codigoId").toString();
String escuelaId = session.getAttribute("escuela").toString();
String cicloId = session.getAttribute("cicloId").toString();
String cicloGrupoId = (String) session.getAttribute("cicloGrupoId");


UtilActividades uac = new UtilActividades(conElias);
UtilCriterios uc = new UtilCriterios(conElias);
UtilAreas ua = new UtilAreas(conElias);
UtilCandado ulock = new UtilCandado(conElias);


Map<Long,Areas> mapAreas = new HashMap();
mapAreas.putAll(ua.getMapAreas(0L, "", cicloId, 1));
Map<Long,Criterios> mapCriterios = new HashMap();
mapCriterios.putAll(uc.getMapCriterios(0L, "", cicloId, 0L, 1));
List<Long> lsBloqueados = new ArrayList();

ulock.getBloqueaActividad("",cicloGrupoId);

if(request.getParameter("guardar")!=null){
	Enumeration enumeration = request.getParameterNames();
	
	while(enumeration.hasMoreElements()){
		String paramname = (String)enumeration.nextElement();
		if(paramname.startsWith("criterio_id")){
			System.out.println("guardaria " + request.getParameter("ciclo_gpo_id") 
			+ "\t" + request.getParameter("maestro_id") 
			+ "\t" + request.getParameter("actividad")
			+ "\t" + request.getParameter("fecha")
			+ "\t" + request.getParameter(paramname)
			+ "\t" + mapCriterios.get(new Long(request.getParameter(paramname))).getArea_id());
			
			Actividades ac = new Actividades();
			ac.setActividad(request.getParameter("actividad"));
			ac.setArea_id(mapCriterios.get(new Long(request.getParameter(paramname))).getArea_id());
			ac.setCiclo_grupo_id(request.getParameter("ciclo_gpo_id"));
			ac.setCriterio_id(new Long(request.getParameter(paramname)));
			ac.setFecha(request.getParameter("fecha"));
			ac.setMaestro_id(request.getParameter("maestro_id"));
			ac.setEvaluacion(new Integer(request.getParameter("evaluacion")));
			uac.addActividad(ac);
		}
	}
}

if(request.getParameter("name")!=null && request.getParameter("name").equals("modificafecha")){
	Actividades a = new Actividades();
	a.setFecha(request.getParameter("value"));
	a.setId(new Long(request.getParameter("pk")));
	uac.modifActividad(a);
}
if(request.getParameter("name")!=null && request.getParameter("name").equals("modificaactividad")){
	Actividades a = new Actividades();
	a.setActividad(request.getParameter("value"));
	a.setId(new Long(request.getParameter("pk")));
	uac.modifActividad(a);
}

if(request.getParameter("eliminar")!=null){
	Actividades a = new Actividades();
	a.setId(new Long(request.getParameter("idactividad")));
	a.setEstado(new Integer(request.getParameter("estado")));
	uac.modifActividad(a);
}

String trimestre="";

Map<Long,Actividades> mapActividades = new HashMap();

if(request.getParameter("evaluacion")!=null){
	mapActividades.putAll(uac.getMapActividades(0L, "", cicloGrupoId, 0L, 0L, codigoId, 1, new Integer(request.getParameter("evaluacion"))));
	trimestre = "TRIMESTRE " + request.getParameter("evaluacion"); 
}

List<Long> lsIdArea = new ArrayList(mapAreas.keySet());
List<Long> lsIdCriterio = new ArrayList(mapCriterios.keySet());
List<Long> lsIdActividad = new ArrayList(mapActividades.keySet());
Collections.sort(lsIdArea);
Collections.sort(lsIdCriterio);
Collections.sort(lsIdActividad);

	
%>
<h3><%= trimestre %></h3>
<table class="table table-bordered">
<%
for(Long idarea : lsIdArea){
	
	for(Long idcriterio : lsIdCriterio){
		boolean isVisible= false;
		for(Long idactividad : lsIdActividad){
			if(mapActividades.get(idactividad).getArea_id().equals(idarea) && mapActividades.get(idactividad).getCriterio_id().equals(idcriterio)){
				isVisible = true;
			}
		}
	
		if(isVisible){
%>
<tr style="background-color: lightgray">
	<th><%= mapAreas.get(idarea).getArea() %> - <%= mapCriterios.get(idcriterio).getCriterio() %></th>
	<th>Fecha</th>
	<th>Acción</th>
</tr>
<% 
			for(Long idActividad : lsIdActividad){ 
				if(mapActividades.get(idActividad).getCriterio_id().equals(idcriterio)){
					String fecha = sdfB.format(sdfA.parse(mapActividades.get(idActividad).getFecha()));
					boolean isAbierto = true;
					String isEditableDisabled = "false";
					if(ulock.getLsActividades().contains(idActividad)){
						isAbierto = false;
						isEditableDisabled = "true";
					}
					
%>
<tr>
	<td><a href="#" class="xeditable "  data-disabled="<%= isEditableDisabled %>" data-type="text" data-pk="<%= idActividad %>" data-value="<%= mapActividades.get(idActividad).getActividad() %>" data-url="ajaxActividades.jsp" data-name="modificaactividad"></a></td>
	<td><a href="#" class="xeditable "  data-disabled="<%= isEditableDisabled %>" data-type="combodate" data-value="<%= fecha %>" data-format="DD-MM-YYYY" data-viewformat="DD/MM/YYYY" data-template="D / MM / YYYY" data-url="ajaxActividades.jsp" data-pk="<%= idActividad %>" data-name="modificafecha" data-title="Seleccione una fecha"></a></td>
	<td style="text-align: center;"><% if(isAbierto){ %><a href="#" onclick="confirm('eliminar(<%= idActividad %>,<%= (mapActividades.get(idActividad).getEstado()*-1) %>)'); return false;" class="btn btn-sm btn-danger">Eliminar</a><% } %></td>
</tr>
<% 		
				}
			}
		}
	}
}
%>
</table>

<script>
$(document).ready(function() {
		$.fn.editable.defaults.mode = 'inline';
	    $('.xeditable').editable();
	});
	</script>
<%@ include file="../../cierra_elias.jsp"%>