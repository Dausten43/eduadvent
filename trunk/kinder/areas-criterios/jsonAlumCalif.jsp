<%@page import="java.util.ArrayList"%>
<%@page import="aca.conecta.Conectar"%>
<%@page import="java.sql.Connection"%>
<%@page import="aca.kinder.Evaluacion"%>
<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilEvaluacion"%>



<%
   // Returns all employees (active and terminated) as json.
   

String ciclo_gpo_id = request.getParameter("ciclo_gpo_id")!=null ? request.getParameter("ciclo_gpo_id") :"";
String maestro_id = request.getParameter("maestro_id")!=null ? request.getParameter("maestro_id") :"";
String alumno_id = request.getParameter("alumno_id")!=null ? request.getParameter("alumno_id") :"";
Integer evaluacion_id = request.getParameter("evaluacion_id")!=null ? new Integer(request.getParameter("evaluacion_id")) : 0;
Integer calificacion = request.getParameter("calificacion")!=null ? new Integer(request.getParameter("calificacion")) : 1;
Long actividad_id = request.getParameter("actividad_id")!=null ? new Long(request.getParameter("actividad_id")) : 0L;

Connection  conElias 	= new Conectar().conEliasPostgres();
UtilEvaluacion ue = new UtilEvaluacion(conElias);


List<Evaluacion> lsEvaluaciones = new ArrayList();
if(request.getParameter("tipo")!=null){
	if(request.getParameter("tipo").equals("grupo")){
		lsEvaluaciones.addAll(ue.getLsEvaluaciones(0L, ciclo_gpo_id, 0L, 0, maestro_id, "", ""));
	}
}

conElias.close();
%>

[
<% 
int cont = 0;
for(Evaluacion e : lsEvaluaciones){ 
	cont++;
	out.println("{\"codigopersonal\":\""+e.getAlumno_id()+"\",\"calificacion\":\""+ e.getCalificacionTxt() + "\", \"actividad\":\"" +e.getActividad_id()+"\",\"nota\":\""+e.getCalificacion()+"\"}");
	out.println(cont<lsEvaluaciones.size() ? ",\n" : "\n");
} %>
]

