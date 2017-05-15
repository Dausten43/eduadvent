<%@page import="java.util.Enumeration"%>
<%
Enumeration enumeration = request.getParameterNames();

while(enumeration.hasMoreElements()){
	String paramname = (String)enumeration.nextElement();
	System.out.println(paramname + "\t" + request.getParameter(paramname));
}
%>