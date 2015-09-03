<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../idioma.jsp" %>

<jsp:useBean id="FinPagoLista" scope="page" class="aca.fin.FinCalculoPagoLista"/>

<%	
	String alumno 		= request.getParameter("alumno");
	String escuelaId 	= (String) session.getAttribute("escuela");

	ArrayList<aca.fin.FinCalculoPago> pagos 		= FinPagoLista.listPagosPendientes(conElias, alumno, "ORDER BY PAGO_ID");
	System.out.println(pagos.size());
%>
	<table class="table table-condensed">
		<tr>
			<th>#</th>
			<th>Fecha</th>
			<th>Importe</th>
		</tr>
	<%
			int row = 0;
			for (aca.fin.FinCalculoPago pago: pagos){
				row++;
	%>
		<tr>
			<td><%=row%></td>
			<td><%= pago.getFecha() %></td>
			<td><%= pago.getImporte() %></td>
		</tr>
	<%			
			}
	%>
	</table>	

<%@ include file= "../../cierra_elias.jsp" %>