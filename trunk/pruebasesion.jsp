<%@page import="java.util.Enumeration"%>
<%
Enumeration nombSess = session.getAttributeNames();

//Enumeration nombreReqSe request.getSession().getAttributeNames()

while( nombSess.hasMoreElements()){
	String nm =(String) nombSess.nextElement();
	out.println("+++++" +nm + "\t" + session.getAttribute(nm)+"<br>");
}
%>