<%-- 
    Document   : subir
    Created on : 24/06/2020, 05:20:40 PM
    Author     : Daniel
--%>

<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="aca.fin.FinMovimientos"%>
<%@page import="java.util.List"%>
<%@page import="aca.fin.UitilUploadPoliza"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>


    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <%
	
	if(ServletFileUpload.isMultipartContent(request)){

	UitilUploadPoliza up = new UitilUploadPoliza();
	
	List<FinMovimientos> lsMov =  up.uploadFile(request);
	
	up.close();
	%>
	<h2>Movimientos ingresados</h2>
	<a href="subir.jsp">Cargar nueva</a>
	<%
	for(FinMovimientos fm : lsMov){
		%>
		<p><%= fm.toString() %></p>
		<%	
	}
	
	%>
	<h2>Movimientos ingresados</h2>
	<a href="subir.jsp">Cargar nueva</a>
	<%
	
	}else{


%>
    
    
        <form enctype="multipart/form-data" action="" method="post">
		
		<p>
			<input type="file"  id="archivo" name="archivo" required/><br>
		</p>			
		<div class="well">
			<button class="btn btn-primary btn-large"> Subir</button> &nbsp;&nbsp; 
		</div>
				
	</form>
	<% } %>
    </body>
</html>