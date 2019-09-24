<%@ include file= "../../con_elias.jsp" %>
<%@page contentType="application/json; charset=UTF-8" language="java"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="aca.reporte.Reporte"%>
<jsp:useBean id="utilReporte" scope="page" class="aca.reporte.UtilReport"/>
<%
response.setContentType("application/json");
response.setHeader("Content-Disposition", "inline");

String[] codigoAlumno = request.getParameterValues("alumno");

if(codigoAlumno != null){
	List<String> lsALumnos = Arrays.asList(codigoAlumno);
	
	Reporte reportes = utilReporte.generaReportes(conElias, lsALumnos);
	
	String rep = new Gson().toJson(reportes);
	out.print(rep);
}
%>
<%@ include file= "../../cierra_elias.jsp" %>