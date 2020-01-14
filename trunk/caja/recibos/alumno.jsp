<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="finReciboLista" scope="page" class="aca.fin.FinReciboLista"/>

<%
	String codigoId = (String) session.getAttribute("codigoAlumno");
	if(alumPersonal.existeReg(conElias, codigoId)){
		alumPersonal.mapeaRegId(conElias, codigoId);
%>
<body>
<table width="80%" align="center">
	<tr>
		<td class="titulo">Pagos del alumno [<%=codigoId %>] <%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<table>
				<tr>
					<th>#</th>
					<th>Folio</th>
					<th>Fecha</th>
					<th>Cliente</th>
					<th>Importe</th>
				</tr>
<%
		ArrayList lisRecibos = finReciboLista.getListAlumno(conElias, codigoId, "ORDER BY FECHA");
		java.text.DecimalFormat getformato= new java.text.DecimalFormat("#,###,###,##0.00;-#,###,###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		for(int i = 0; i < lisRecibos.size(); i++){
			finRecibo = (aca.fin.FinRecibo) lisRecibos.get(i);
%>
				<tr onclick="document.location.href = 'recibo.jsp?reciboId=<%=finRecibo.getReciboId() %>';" onmouseover="this.style.backgroundColor='#bcecf7';" onmouseout="this.style.backgroundColor='';" style="cursor: pointer;">
					<td align="center"><%=i+1 %></td>
					<td align="right"><%=finRecibo.getReciboId() %></td>
					<td><%=finRecibo.getFecha() %></td>
					<td><%=finRecibo.getCliente() %></td>
					<td align="right"><%=getformato.format(Float.parseFloat(finRecibo.getImporte())) %></td>
				</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center"><b>F&iacute;n del Listado</b></td>
	</tr>
</table>
<%
	}else{
%>
<table align="center">
	<tr>
		<td class="titulo">Busque el alumno del que desea ver sus pagos</td>
	</tr>
</table>
<%
	}
%>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 