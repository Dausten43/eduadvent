<%@page import="java.util.HashMap"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="entidadL" scope="page" class="aca.beca.BecEntidadLista"/>
<jsp:useBean id="entidad" scope="page" class="aca.beca.BecEntidad"/>
<html>
<script type="text/javascript">
	function buscar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)");

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String entidadId		= request.getParameter("EntidadId")==null?"0":request.getParameter("EntidadId");
	
	ArrayList<aca.beca.BecEntidad> listaEntidades		= entidadL.getListAll(conElias, escuelaId, "ORDER BY ENTIDAD_ID");
	
	
%>
<div id="content">
	<h2>Entidad</h2>
	<form name="forma" id="forma" method="post" action="becaPorEntidad.jsp">
	<input type="hidden" name="Accion" />
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		Entidades:
		<select name="EntidadId" id="EntidadId" style="width:350px;">
		<%
		for(aca.beca.BecEntidad entidad : listaEntidades){
		%>
			<option value="<%=entidad.getEntidadId()%>" ><%= entidad.getEntidadNombre() %></option>
		<%	
		}
		%>	
		</select>
		&nbsp;&nbsp;
		<a href="javascript:buscar()" class="btn btn-primary"><i class="icon-white icon-search"></i> Buscar</a>
	</div>
	</form>		
<%
	if(accion.equals("1")){
		entidad.mapeaRegId(conElias, entidadId);
%>
	<table class="table table-striped">
		<tr>
			<th>Entidad</th>
			<th>Total beca</th>
		</tr>
		<tr>
			<td><%=entidad.getEntidadNombre() %></td>
			<td><%=entidad.getEntidadNombre()  %></td>
		</tr>
	</table>
<%	
	}else
	out.print("<h3>Elija la entidad</h3>");
%>
</div>
<%@ include file= "../../cierra_elias.jsp" %>