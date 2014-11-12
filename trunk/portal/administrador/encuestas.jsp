<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="estEncuestaLista" scope="page" class="aca.est.EstEncuestaLista" />

<%
	String codigoId = (String)session.getAttribute("codigoId");
	
	ArrayList<aca.est.EstEncuesta> encuestas = estEncuestaLista.getListAll(conElias, "");

%>

<div id="content">
	<h2>
		<fmt:message key="aca.Encuestas" />
	</h2>	
	<div class="well">
		&nbsp;
	</div>
	
	<table class="table table-bordered table-hover">
		<tr>
			<th>#</th>
			<th>Encuesta</th>
		</tr>
	<%
		int cont = 0;
		for(aca.est.EstEncuesta encuesta: encuestas){
			cont++;
	%>
		<tr style="cursor:pointer;" onclick="location.href='preguntas.jsp?encuestaId=<%=encuesta.getEncuestaId() %>'">
			<td><%=cont %></td>
			<td><%=encuesta.getEncuestaNombre() %> </td>
		</tr>
	<%
		}
	%>
	</table>
	
</div>
<script>
	jQuery('.encuestas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp"%>
