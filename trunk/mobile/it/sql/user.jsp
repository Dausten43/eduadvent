<%@page import="java.sql.*"%>
<%
	String query	= request.getParameter("query");
	String user		= request.getParameter("user");
	String pass		= request.getParameter("pass");
	
	int accion		= request.getParameter("Accion")==null?0:Integer.parseInt(request.getParameter("Accion"));
	
	switch(accion){
		case 5:{	//Sube a session el usuario y contraseña
			session.setAttribute("userDB", user);
			session.setAttribute("passwordDB", pass);
			//System.out.println("antes del response.sendRedirect - "+query);
			response.sendRedirect("dataGrid.jsp?query="+query);
		}break;
	}
%>
<body>
	<form id="forma" name="forma" action="user.jsp?query=<%=query %>&Accion=5" method="post">
		<table align="center">
			<tr>
				<td colspan="2" class="title">Log in para Base de Datos</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td><b>Usuario</b></td>
				<td><input type="text" class="text" id="user" name="user" /></td>
			</tr>
			<tr>
				<td><b>Contraseña</b></td>
				<td><input type="password" id="pass" name="pass" /></td>
			</tr>
			<tr>
				<td colspan="2"><input type="submit" value="Continuar >>" /></td>
			</tr>
		</table>
	</form>
</body>