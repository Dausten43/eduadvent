<%@ include file= "../../con_elias.jsp" %>
<%@page contentType="application/json; charset=UTF-8" language="java"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="aca.reporte.Reporte"%>
<%@page import="aca.reporte.UtilReporteNew"%>
<%
response.setContentType("application/json");
response.setHeader("Content-Disposition", "inline");

String[] codigoAlumno = request.getParameterValues("alumno");

if(codigoAlumno != null){
	List<String> lsALumnos = Arrays.asList(codigoAlumno);
	
	Reporte reportes = UtilReporteNew.generaReportes(conElias, lsALumnos);
	
	String rep = new Gson().toJson(reportes);
	out.print(rep);
}
%>
<%@ include file= "../../cierra_elias.jsp" %>