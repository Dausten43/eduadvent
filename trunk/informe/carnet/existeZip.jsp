
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>


<%@ page import="java.io.*" %>
<%@ page import="java.util.zip.*" %>
<%@ page import="java.sql.*" %>

<%
	boolean error 		= false;

	String dir			= application.getRealPath("informe/carnet")+"/";
	
	try{
		File f;
		if(request.getParameter("alumnos") != null){
			f = new File(dir+"respaldoAl.zip");
		}else{
			f = new File(dir+"respaldoEmp.zip");
		}
		
		System.out.println("Aqui vamos");
		if(f.exists() && !f.isDirectory()) {
 			//Everything cool man :D
		}else{
			error = true;
		}
	
	}catch(Exception e){
	
		e.printStackTrace();
		error = true;
	
	}

	if(error){
		out.print("<div class='error'>Error</div>");
	}
%>