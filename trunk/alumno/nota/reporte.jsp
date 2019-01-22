<%@ include file= "../../con_elias.jsp" %>
<%@page contentType="application/json; charset=UTF-8" language="java"%>
<%@page import="aca.reporte.UtilReporte"%>
<%@page import="java.util.Arrays"%>
<%

String[] codigoAlumno 	= request.getParameterValues("alumnos[]");
String escuelaId 		= (String) session.getAttribute("escuela");

UtilReporte ur = new UtilReporte(conElias, escuelaId, new ArrayList<String>( Arrays.asList(codigoAlumno) ));
/* PRUEBAS REPORTE *//*
System.out.println("Escuela ID: " + ur.getEscuelaId());
System.out.println("Nombre Escuela: " + ur.getNombreEscuela());
System.out.println("Telefono: " + ur.getTelefono());
System.out.println("Nombre Director: " + ur.getNombreDirector());
for(ReporteAlumno r: ur.getMapaReportes().values()){
	System.out.println("    Codigo Alumno: " + r.getCodigoId());
	System.out.println("    Nombre Alumno: " + r.getNombreAlumno());
	for(Map.Entry<String, aca.reporte.GradoReporte> g: r.getMapaGrados().entrySet()){
		System.out.println("        Grado: " + g.getKey());
		System.out.println("        Nombre Grado: " + g.getValue().getNombreGrado());
		System.out.println("        Ciclo Grupo ID: " + g.getValue().getCicloGrupoId());
		System.out.println("        Ciclo Escolar Id: " + g.getValue().getCicloId());
		System.out.println("        Observaciones: -");
		for(aca.reporte.MateriaReporte m: g.getValue().getListaMaterias()){
			System.out.println("            Materia ID: " + m.getCursoId());
			System.out.println("            Nombre Materia: " + m.getNombre());
			System.out.println("            Horas: " + m.getHoras());
			System.out.println("            Calificación: " + m.getCalificacion());
			System.out.println("            Convalidación: " + m.getConvalidacion());
		}
	}
}
*/
String urJson = ur.getJson();
/*  */
%>
<%= urJson %>
<%@ include file= "../../cierra_elias.jsp" %>