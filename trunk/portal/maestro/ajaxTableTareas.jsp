<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="aca.preescolar.CicloGrupoKinderTareas"%>
<%@page import="aca.preescolar.UtilPreescolar"%>
<%
UtilPreescolar up = new UtilPreescolar();

String cicloid = request.getParameter("cicloid")!=null ? request.getParameter("cicloid") : "" ;
String cursoid = request.getParameter("cursoid")!=null ? request.getParameter("cursoid") : "" ;
String ciclogrupoid = request.getParameter("ciclogrupoid")!=null ? request.getParameter("ciclogrupoid") : "" ;

Integer promedioid = request.getParameter("promedioid")!=null ? new Integer(request.getParameter("promedioid")) : 0;
Integer evaluacionid = request.getParameter("evaluacionid")!=null ? new Integer(request.getParameter("evaluacionid")) : 0;
Integer actividadid = request.getParameter("actividadid")!=null ? new Integer(request.getParameter("actividadid")) : 0;

String actividad = request.getParameter("actividad")!=null ? request.getParameter("actividad") : "" ;
String observacion = request.getParameter("observacion")!=null ? request.getParameter("observacion") : "" ;

if(request.getParameter("guardar")!=null){
	CicloGrupoKinderTareas cgkt = new CicloGrupoKinderTareas(
			0L,
			ciclogrupoid,
			cursoid,
			new Long(evaluacionid),
			new Long(actividadid),
			actividad,
			observacion,
			cicloid,
			new Integer(1),
			new Long(promedioid)
			);
	up.addTareaKinder(cgkt);
}

if(request.getParameter("quitar")!=null){
	up.desactivarActividad(new Integer(request.getParameter("id_kinder_tarea")));
}

CicloGrupoKinderTareas cgkt = new CicloGrupoKinderTareas(
		0L,
		ciclogrupoid,
		cursoid,
		new Long(evaluacionid),
		new Long(actividadid),
		actividad,
		observacion,
		cicloid,
		new Integer(1),
		new Long(promedioid)
		);
//System.out.println(cgkt.toString());

List<CicloGrupoKinderTareas> lsCGKT = new ArrayList();
lsCGKT.addAll(up.getTareas(ciclogrupoid, cursoid, evaluacionid, actividadid, cicloid, 1, promedioid, actividadid));


up.close();
%>

<table class="table table-bordered table-condensed">
	<tr>
		<th style="width: 5%"></th>
		<th>Tarea</th>
		<th>Observación</th>
	</tr>
	<%
	for(CicloGrupoKinderTareas ck : lsCGKT){
	%>
	<tr>
		<th><form method="post">
			<input type="submit" onclick="quitar(<%= ck.getId_kinder_tarea() %>); return false;" value="X" class="btn btn-danger btn-sm"></form></th>
		<td><%= ck.getActividad() %></td>
		<td><%= ck.getObservacion() %></td>
	</tr>
	<%
	}
	%>
</table>