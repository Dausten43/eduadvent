<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ page import="aca.beca.BecEntidad"%>
<%@ page import="aca.beca.BecEntidadLista"%>

<jsp:useBean id="entidadU" scope="page" class="aca.beca.BecEntidadLista"/>


<script>
	function Borrar(InstitucionId) {
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			document.location = "accion.jsp?Accion=4&EntidadId="+ InstitucionId;
		}
	}
</script>

<%
	String escuelaId 		= (String) session.getAttribute("escuela");

	ArrayList<aca.beca.BecEntidad> lisEntidad 	= entidadU.getListAll(conElias, escuelaId," ORDER BY ENTIDAD_NOMBRE");
%>


<div id="content">

	<h2><fmt:message key="catalogo.Entidades" />
		<small> (<%=aca.catalogo.CatEscuela.getNombreCorto(conElias, escuelaId)%>) </small>
	</h2>
	
	<div class="well">
		<a href="accion.jsp?Accion=1" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
	</div>
		
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<th><fmt:message key="aca.Operacion" /></th>
				<th>#</th>
				<th><fmt:message key="aca.Descripcion" /></th>
				<th><fmt:message key="aca.Referente" /></th>
				<th><fmt:message key="aca.Telefono" /></th>
				<th><fmt:message key="aca.LimitePorcentaje" /></th>
				<th><fmt:message key="aca.LimiteCantidad" /></th>
			</tr>
		</thead>
		<%
			for (int i = 0; i < lisEntidad.size(); i++) {
				BecEntidad entidad = (BecEntidad) lisEntidad.get(i);
		%>
		<tr>
			<td align="center">
			  <a class="icon-pencil" href="accion.jsp?Accion=5&EntidadId=<%=entidad.getEntidadId()%>"></a>
			  <a class="icon-remove" href="javascript:Borrar('<%=entidad.getEntidadId()%>')"> </a>
			</td>
			<td align="center"><%=i+1%></td>
			<td><%=entidad.getEntidadNombre()%></td>
			<td><%=entidad.getReferente()%></td>
			<td><%=entidad.getTelefono()%></td>
			<td><%=entidad.getLimitePorcentaje() %> %</td>
			<td><%=entidad.getLimiteCantidad() %></td>
		</tr>
		<%
			}
		%>
	</table>
	
</div>

<%@ include file="../../cierra_elias.jsp"%>
