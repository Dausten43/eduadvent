<%@ page isErrorPage="true" %>

<html>
<head>
	<link href="bootstrap/css/bootstrap.min.css" rel="STYLESHEET" type="text/css">
   <title>Error Page</title>
</head>

<script>
	function inicio(){
		top.location.href="login.jsp";
	}
</script>

<%
String admin = (String)session.getAttribute("admin");
%>

<body bgcolor="white" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
	<br>
	<br>
	<br>
	<br>
	<br>

	<table align="center" border="0">
		<tr>
			<td>
				<img src="imagenes/errorpage.png"></img>
			</td>
			<td width="20">&nbsp;</td>
			<td>
			<% 	if(session.getId()==null || admin==null || exception==null){%>
					<h1>
						La sesión ha expirado.<br>
						<a href="#"; onclick="inicio()"><h1>Iniciar sesión</h1></a>
						<!--<script>
							setTimeout 'inicio()',5000);
						</script>-->
					</h1>	
			<%	}
				else{%>
					<h1>
						Disculpe las molestias.<br>
						Ocurrió un error al cargar la página.
					</h1>
			<% 	}%>
			<% 	if(exception!=null && (admin!=null && admin.equals("B01P0002"))){%>
					<b>Excepción:</b><br> 
					<%= exception.toString() %>
			<% 	}%>
			</td>
		</tr>
	</table>
</body>
</html>