<html>
	<head>
		<link href="../../css/academico.css" rel="STYLESHEET" type="text/css">
	</head>
	
	<body bgcolor="white" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
		<div align="center">
			
		</div>
		<br>
		<br>
		<br>
		<br>
		<br>	
		<table align="center" border="0">
			<tr>
			<%	
				String error 		= request.getParameter("error");
				String escuelaId 	= request.getParameter("EscuelaId");
				String escuela		= request.getParameter("Escuela");
				String usuario		= request.getParameter("Usuario")==null ? "" : request.getParameter("Usuario");
				String mensaje		= "";
				
				if(!error.equals("1") && !error.equals("2")){
			%>
				<td>
					<img src="imagenes/errorpage.png"></img>
				</td>
			<%	}%>
				<td width="20">&nbsp;</td>
				<td>
					<h1>
					<%	if(!error.equals("1") && !error.equals("2")){ %>
							Disculpe las molestias.<br>
					<%
						}
						if( error.equals("1") ){  
							mensaje = "Clave Incorrecta";
						}

						if( error.equals("2") ){ 
							mensaje = "Usuario Incorrecto";
						}
						
						if( error.equals("3") ){%>
							No tiene privilegios para ejecutar<br>
							esta operación.
					<%	}
						
						if( error.equals("4") ){%>
							Sesión invalida.
					<%	}
						
						if( error.equals("5") ){%>
							<meta http-equiv="refresh" content="0;url=paginaerror2.jsp" />
						<%	mensaje = "Terminó la Sesión";
						}
						
						if( error.equals("6") ){ 
							mensaje = "¡ No tienes privilegios para ingresar al Sistema de ésta escuela !";
						}%>
					</h1>
				</td>
			</tr>
		</table>
		<% if (!error.equals("3")&&!error.equals("4")&&!error.equals("5")){%>
				<meta http-equiv="refresh" content="0;url=login.jsp?EscuelaId=<%=escuelaId%>&Escuela=<%=escuela%>&Mensaje=<%=mensaje %>&Usuario=<%=usuario%>" />
		<% }%>
	</body>
</html>
