<%@page import="aca.menu.Modulo"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AspectosCalL" scope="page" class="aca.catalogo.CatAspectosCalLista"/>
<jsp:useBean id="AspectosCal" scope="page" class="aca.catalogo.CatAspectosCal"/>
<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<script>
		function eliminar(escuelaId,nivelId,calId) {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.location.href = "tipo.jsp?Accion=2&escuelaId="+escuelaId+"&nivelId="+nivelId+"&calId="+calId;
			}
		}
</script>

<%
	String escuela			= request.getParameter("escuelaId")==null?(String)session.getAttribute("escuela"):request.getParameter("escuelaId");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	String nivelId			= request.getParameter("nivelId")==null?"0":request.getParameter("nivelId");
	String calId			= request.getParameter("calId")==null?"0":request.getParameter("calId");
	String mensaje  		= "";
	String salto			= "X";
	
	
	
	if (accion.equals("1")) {
		
		AspectosCal.setCalId(calId);
		AspectosCal.setNivelId(nivelId);
		AspectosCal.setEscuelaId(escuela);
		AspectosCal.mapeaRegId(conElias);
		
			
		if (AspectosCal.deleteReg(conElias)) {
			mensaje = "Eliminado";
			salto = "movimiento.jsp";
		} else {
			mensaje = "NoElimino";
		}
	}else if(accion.equals("2")){
		AspectosCal.setEscuelaId(escuela);
		AspectosCal.setNivelId(nivelId);
		AspectosCal.setCalId(calId);
		if(AspectosCal.deleteReg(conElias)){
			mensaje = "Eliminado";
		}else{
			mensaje = "NoEliminado";
		}
	}
	
	ArrayList<aca.catalogo.CatAspectosCal> aspectos		= AspectosCalL.getListAll(conElias,escuela, "ORDER BY NIVEL_ID, CAL_ID");	
%>

<div id="content">
	<h2>Tipo de Nota<small> ( <fmt:message key="aca.HabitosyActitudes" /> ) </small></h2>
	
	<% 
	if (mensaje.equals("Eliminado") || mensaje.equals("Modificado") || mensaje.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${mensaje}" /></div>
  	<% }else if(!mensaje.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${mensaje}" /></div>
  	<%} %>
		
	 <form id="forma" name="forma" action="tipo.jsp" method="post">
	 	<div class="well">
			<a class="btn btn-primary btn-mobile" href="accion.jsp"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
		</div>
	</form>

	 	
	<table class="table table-striped table-bordered">
		<th width="5%"><fmt:message key="aca.Accion" /></th>
		<th width="2%">#</th>
		<th>Nivel Id</th>
		<th>Cal. Id</th>
		<th>Nombre</th>
		<th>Cal Corto</th>
<%
	for(int i = 0; i < aspectos.size(); i ++){
%>
		<tr>
			<td>
				<a href="accion.jsp?Accion=3&escuelaId=<%=aspectos.get(i).getEscuelaId()%>&calId=<%=aspectos.get(i).getCalId()%>&nivelId=<%=aspectos.get(i).getNivelId()%>"><i class="icon-pencil"></i></a>
				<a id="borrar" name="borrar" href="javascript:eliminar('<%=aspectos.get(i).getEscuelaId()%>','<%=aspectos.get(i).getNivelId()%>','<%=aspectos.get(i).getCalId()%>');"><i class="icon-remove"></i></a>
			</td>
			<td><%= i + 1 %></td>
			<td><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuela, aspectos.get(i).getNivelId())%></td>
			<td><%=aspectos.get(i).getCalId()%></td>
			<td><%=aspectos.get(i).getCalNombre()%></td>
			<td><%=aspectos.get(i).getCalCorto()%></td>
			
		</tr>
<%	
	}
%>
	</table>
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>