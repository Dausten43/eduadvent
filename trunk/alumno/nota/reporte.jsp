<%@ include file= "../../con_elias.jsp" %>
<%@page import="java.util.List"%>
<%@page contentType="application/json; charset=UTF-8" language="java"%>
<%@page import="aca.reporte.UtilReporte"%>
<%@page import="java.util.Arrays"%>
<%

String[] codigoAlumno = request.getParameterValues("alumno");
final String url = "https://eduadvent.um.edu.mx/escuela/imagenes/logos/";

if(codigoAlumno != null){
	String escuelaId = codigoAlumno[0].substring(0,2);
	List<String> lsALumnos = Arrays.asList(codigoAlumno);
	for(String alumnos : lsALumnos){
		if(alumnos.length()>=3){
			escuelaId=alumnos.substring(0,3);
		}
	}
	System.out.println(escuelaId);
	
	UtilReporte ur = new UtilReporte(conElias, escuelaId, new ArrayList<String>( Arrays.asList(codigoAlumno) ));
	
	ur.setLogo(url + ur.getLogo());
	
	String urJson = ur.getJson();
	out.print(urJson);
}
%>
<%@ include file= "../../cierra_elias.jsp" %>