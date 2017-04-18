<%@ page buffer= "none" %>  
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%	
HttpServletResponse httpResponse = (HttpServletResponse) response;
httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
httpResponse.setDateHeader("Expires", 0); // Proxies.
System.out.println("SALIENDO ");	
HttpSession sesion = request.getSession();
	Enumeration nombSess = session.getAttributeNames();
	
	//Enumeration nombreReqSe request.getSession().getAttributeNames()
	
	while( nombSess.hasMoreElements()){
		String nm =(String) nombSess.nextElement();
		System.out.println("+++++" +nm + "\t" + session.getAttribute(nm));
	}
	
	session.invalidate();	
	request.getSession().invalidate();
	
	
	
	
	
	
	
// 	response.sendRedirect("login.jsp");
%>
<meta http-equiv="refresh" content="0;url=login.jsp?time=<%= new Date() %>" />
