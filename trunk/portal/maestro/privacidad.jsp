<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../seguro.jsp" %>



<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<head>
<script>
		function Grabar(){
			document.forma.Accion.value="1";
			document.forma.submit();	
		}
</script>
<%
	String codigoId 	= (String)session.getAttribute("codigoId");
	String mensaje 		= "";

	empPersonal.mapeaRegId(conElias, codigoId);
	
	String accion = request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	if(accion.equals("1")){
		empPersonal.setPublicar(request.getParameter("privacidad"));
		if(empPersonal.updateReg(conElias)){
			mensaje="Guardado";
		}else{
			mensaje="NoGuardo";
		}
	}
	
	pageContext.setAttribute("resultado", mensaje);
%>
</head>
<body>
<form action="privacidad.jsp" method="post" name="forma" target="_self">
	<input type="hidden" name="Accion">
	<table width="100%" height="80px" align="center">
		<tr>	
			<td align="center">
				<select style="margin-bottom: 0px;" id="privacidad" name="privacidad">
					<option value="S" <%if(empPersonal.getPublicar().equals("S"))out.print("selected");%>><fmt:message key="aca.Si" /></option>
					<option value="N" <%if(empPersonal.getPublicar().equals("N"))out.print("selected");%>><fmt:message key="aca.Negacion" /></option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
				<a class="btn btn-primary" onclick="Grabar();"><fmt:message key="boton.Guardar" /></a>
			</td>
		</tr>
		<tr>
			<td align="center"><fmt:message key="aca.${resultado}" />&nbsp;</td>
		</tr>
	</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>