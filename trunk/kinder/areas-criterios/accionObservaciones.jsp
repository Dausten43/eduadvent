<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="aca.kardex.UtilKrdxAlumObs"%>
<%@page import="aca.kardex.KrdxAlumObs"%>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista" />

<%

Connection  conElias 	= new Conectar().conEliasPostgres(); 

UtilKrdxAlumObs uob = new UtilKrdxAlumObs(conElias);

String codigoid = request.getParameter("codigoid")!=null ? request.getParameter("codigoid") : "";
Long id = request.getParameter("id")!=null && !request.getParameter("id").equals("") ? new Long(request.getParameter("id")) : 0L;
//String cicloGpoId = request.getParameter("cicloGpoId")!=null ? request.getParameter("cicloGpoId") : "";
Integer periodo = request.getParameter("periodo")!=null && !request.getParameter("periodo").equals("") ? new Integer(request.getParameter("periodo")) : 0;
String observacion = request.getParameter("observacion")!=null ? request.getParameter("observacion") : "";
String observacion2 = request.getParameter("observacion2")!=null ? request.getParameter("observacion2") : "";
String escuelaId = (String) session.getAttribute("escuela");
String codigoId = (String) session.getAttribute("codigoEmpleado");
String cicloId = (String) session.getAttribute("cicloId");
String cicloGrupoId = request.getParameter("CicloGrupoId");
String cursoId = request.getParameter("CursoId");


if(request.getParameter("guardar")!=null){
	
	if(id==0L){
		KrdxAlumObs ob = new KrdxAlumObs(id,cicloGrupoId,codigoid,periodo,observacion,observacion2);
		Long salida = uob.addObservacion(ob);
		out.println(salida);
	}else{
		uob.updObservaciones(id, observacion, observacion2);
		out.println(id);	
	}
}

if(request.getParameter("borrar")!=null){
	uob.delObservaciones(id);
}


if(request.getParameter("showTable")!=null){
	
	String planId = aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	
	
	List<Integer> lsPeriodos = new ArrayList();
	lsPeriodos.add(1);
	lsPeriodos.add(2);
	lsPeriodos.add(3);

	List<String> lisKardexAlumnos = new ArrayList();
	lisKardexAlumnos.addAll(krdxCursoActL.getListAlumnosGrupo(conElias, cicloGrupoId));

	UtilKrdxAlumObs uk = new UtilKrdxAlumObs(conElias);
	Map<String, KrdxAlumObs> mapObs = new HashMap();
	mapObs.putAll(uk.getObservacionesComplexKey(0L, cicloGrupoId, "", 0));
	%>
		</form>
		
		

	<table class="table table-bordered">
	<thead>
		<tr>
			<th >#</th>
			<th >Código</th>
			<th >Nombre</th>
			<th >Trimestre 1</th>
			<th >Trimestre 2</th>
			<th >Trimestre 3</th>
		</tr>

	</thead>
	<tbody>
		<% 
		int i = 1;
		for(String kal : lisKardexAlumnos){ %>
		<tr>
			<td><%= i %></td>
			<td><%= kal %></td>
			<td><%= aca.alumno.AlumPersonal.getNombre(conElias, kal, "APELLIDO") %></td>
			<% for(Integer pe : lsPeriodos){ 
			String idmsg = "";
			String obs = "";
			String obs2 = "";
			String gly = "icon-plus";
			boolean isErr = false;
				
			if(mapObs.containsKey(kal+"-"+pe)){
				idmsg = mapObs.get(kal+"-"+pe).getId().toString();
				obs = mapObs.get(kal+"-"+pe).getObservacion_1();
				obs2 = mapObs.get(kal+"-"+pe).getObservacion_2();
				gly = "icon-pencil";
				isErr = true;
			}
			%>
			<td  id="td-<%= kal %>-<%= pe %>" style="text-align: center;">
			<a data-toggle="modal" title="Observación" data-idobs="<%= idmsg %>" 
			data-obs="<%= obs %>" data-obs2="<%= obs2 %>" 
			data-id="<%= kal  %>" data-tipo="O" 
			data-periodo="<%= pe %>" class="open-ObsBox btn btn-default btn-mini" 
			href="#obsBox" id="O-<%= kal %>-<%= pe %>"><i class="<%= gly %>"></i></a>
			<% if(isErr){ %>
			&nbsp&nbsp&nbsp&nbsp<a href="#" onclick="borrar(<%= idmsg %>,'<%= kal %>',<%= pe %>);" class="btn btn-danger btn-mini"><i class="icon-remove icon-white"></i></a>
			<% } %>
			</td>
			<% } %>
		</tr>
		<% 
		i++;
		} %>
	</tbody>
	</table>

	  <%
}

conElias.close();
%>
