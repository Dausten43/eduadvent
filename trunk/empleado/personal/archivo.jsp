<%@ page import="com.oreilly.servlet.MultipartRequest"%> 
<%	
	String matricula=request.getParameter("matricula");
	String dir=application.getRealPath("/WEB-INF/fotos/");
	System.out.println("Directorio:"+dir);
	MultipartRequest multi = new MultipartRequest(request, dir, 5*1024*1024);
%>