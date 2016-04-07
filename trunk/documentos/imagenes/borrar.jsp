<%@ include file= "../../con_elias.jsp" %>
<table class="goback">
	<tr>
		<td><a href="catalogo.jsp">&lsaquo;&lsaquo; Regresar</a></td>
	</tr>
</table>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%
	String nombreArchivo	= request.getParameter("nombreArchivo")==null?"":request.getParameter("nombreArchivo");
	String escuela			= (String) session.getAttribute("escuela");
	boolean borrar 			= false;
	String salto			= "X";
	
	String dirFoto = application.getRealPath("/WEB-INF/"+escuela+"/"+nombreArchivo);
	java.io.File foto = new java.io.File(dirFoto);
	int i=0;
	if (foto.exists()){
		
		// Ciclo para corregir error en sistemas opreativos windows(No es necesario si el servidor de aplicaciones está en linux)
		while(!borrar && i<50000){
			if(foto.delete()){
				borrar = true;				
			}
			i++;
		}
	}
	if (borrar){
		salto = "catalogo.jsp";
	}else{
		out.println("No se puedo elimiar la foto <br>");
	}
%>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>