<%@ include file="../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>


<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.sql.*" %>

<%
	boolean error 		= false;

	String dir			= application.getRealPath("/alumno/respaldo")+"/";
	
	try{
		 
		new File(dir+"respaldo.zip").delete();
	
	}catch(Exception e){
	
		e.printStackTrace();
		error = true;
	
	}

	if(error){
		out.print("<div class='error'>Error</div>");
	}
%>

<%@ include file="../../cierra_elias.jsp"%>