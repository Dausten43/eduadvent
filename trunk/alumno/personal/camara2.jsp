<%@ page buffer= "none" %>
<html>
<title><fmt:message key="aca.Camara"/></title>
<head>
	<script>
		function refrescar(){
			alert("refrescar de camara.jsp");
			window.
			window.opener.refrescar();
		}
		function setMatricula(m){
			document.camara.setMatricula(m);
		}
	</script>
</head>
<body bgcolor='#999999' leftmargin=0 topmargin=0>
<table>
	<tr>
	<td >
		<applet name='camara' code="camara.Camara" width="360" height="535" alt="Se necesita Java para mostrar la camara.">
			<param name= "matricula" value="<%=session.getAttribute("mat")%>">
		</applet>
	</td>
	</tr>
</table>
</body>
</html>