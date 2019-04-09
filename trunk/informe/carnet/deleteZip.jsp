<%@ include file="../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>


<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.sql.*" %>

<%
	boolean error 		= false;

	String dir			= application.getRealPath("informe/carnet")+"/";
		
	try{
		if(request.getParameter("alumnos") != null){
			new File(dir+"respaldoAl.zip").delete();
		}else{
			new File(dir+"respaldoEmp.zip").delete();
		}
	}catch(Exception e){
	
		e.printStackTrace();
		error = true;
	
	}

	if(error){
		out.print("<div class='error'>Error</div>");
	}
%>

<%@ include file="../../cierra_elias.jsp"%>