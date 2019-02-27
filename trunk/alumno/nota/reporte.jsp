<%@ include file= "../../con_elias.jsp" %>
<%@page contentType="application/json; charset=UTF-8" language="java"%>
<%@page import="aca.reporte.UtilReporte"%>
<%@page import="java.util.Arrays"%>
<%

String[] codigoAlumno = request.getParameterValues("alumnos[]");

if(codigoAlumno != null){
	String escuelaId = codigoAlumno[0].substring(0,2);

	UtilReporte ur = new UtilReporte(conElias, escuelaId, new ArrayList<String>( Arrays.asList(codigoAlumno) ));

	String urJson = ur.getJson();
	out.print(urJson);
}
%>
<%@ include file= "../../cierra_elias.jsp" %>