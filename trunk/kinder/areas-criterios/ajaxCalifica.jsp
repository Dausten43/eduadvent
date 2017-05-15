<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="aca.kinder.Evaluacion"%>
<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilEvaluacion"%>

<%
Connection  conElias 	= new Conectar().conEliasPostgres();


String ciclo_gpo_id = request.getParameter("ciclo_gpo_id")!=null ? request.getParameter("ciclo_gpo_id") :"";
String maestro_id = request.getParameter("maestro_id")!=null ? request.getParameter("maestro_id") :"";
String alumno_id = request.getParameter("alumno_id")!=null ? request.getParameter("alumno_id") :"";
Integer evaluacion_id = request.getParameter("evaluacion_id")!=null ? new Integer(request.getParameter("evaluacion_id")) : 0;
Integer calificacion = request.getParameter("calificacion")!=null ? new Integer(request.getParameter("calificacion")) : 1;
Long actividad_id = request.getParameter("actividad_id")!=null ? new Long(request.getParameter("actividad_id")) : 0L;


UtilEvaluacion ue = new UtilEvaluacion(conElias);

if(request.getParameter("guardar")!=null){
	Evaluacion e = new Evaluacion();	
	e.setCiclo_gpo_id(ciclo_gpo_id);
	e.setEvaluacion_id(evaluacion_id);
	e.setMaestro_id(maestro_id);
	e.setAlumno_id(alumno_id);
	e.setActividad_id(actividad_id);
	ue.removeEvaluacion(e);
	
	
	e = new Evaluacion();
	e.setCiclo_gpo_id(ciclo_gpo_id);
	e.setEvaluacion_id(evaluacion_id);
	e.setMaestro_id(maestro_id);
	e.setAlumno_id(alumno_id);
	e.setActividad_id(actividad_id);
    e.setCalificacion(calificacion);
 	
    ue.addEvaluacion(e);
	
}

if(request.getParameter("eliminar")!=null){
	
	Evaluacion e = new Evaluacion();
	e.setEvaluacion_id(0);
	e.setAlumno_id("");
	
	e.setCiclo_gpo_id(ciclo_gpo_id);
	e.setMaestro_id(maestro_id);
	e.setActividad_id(actividad_id);
	ue.removeEvaluacion(e);
}

conElias.close();

%>
