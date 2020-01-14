<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinReciboLista" scope="page" class="aca.fin.FinReciboLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
	
<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("##0.00;(##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	String salto		= "X";
	
	/* INFORMACION DE LA POLIZA */
	
	if(request.getParameter("polizaId") != null){
		session.setAttribute("polizaId", request.getParameter("polizaId"));
	}
	
	String polizaId 	= (String) session.getAttribute("polizaId");
	
	if( polizaId == null ){
		salto = "poliza.jsp";
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	
	ArrayList<aca.fin.FinRecibo> recibos = FinReciboLista.getListPoliza(conElias, polizaId, " ORDER BY RECIBO_ID DESC, FECHA DESC ");
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Recibos" />
	</h2>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong>
	</div>
	
	<div class="well">
		<a href="poliza.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	 	
	<table class="table table-condensed table-bordered">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Recibo" /></th>
				<th><fmt:message key="aca.Cliente" /></th>
				<th><fmt:message key="aca.Domicilio" /></th>
				<th><fmt:message key="aca.Cheque" /></th>
				<th><fmt:message key="aca.Banco" /></th>
				<th><fmt:message key="aca.Observaciones" /></th>
				<th><fmt:message key="aca.rfc" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th class="text-right"><fmt:message key="aca.Importe" /></th>
			</tr>
		</thead>
		
		<%
			float total = 0;
			int cont = 0;
			for(aca.fin.FinRecibo recibo : recibos){ 
				cont++;
				
				float importe = Float.parseFloat(recibo.getImporte());
				if(!recibo.getEstado().equals("C")){/* Si no esta cancelado el recibo */
					total+=importe;
				}
		%>
				<tr <%if(recibo.getEstado().equals("C")){ %>class="alert alert-danger"<%} %>>
					<td><%=cont %></td>
					<td><%=recibo.getReciboId() %></td>
					<td>
						<a href="imprimirRecibo.jsp?reciboId=<%=recibo.getReciboId() %>&from=verRecibos">
							<%=recibo.getCliente() %>
						</a>
						
						<%if(recibo.getEstado().equals("C")){ %><span class="label label-important"><fmt:message key="aca.Cancelado" /></span><%} %>
					</td>
					<td><%=recibo.getDomicilio() %></td>
					<td><%=recibo.getCheque() %></td>
					<td><%=recibo.getBanco() %></td>
					<td><%=recibo.getObservaciones() %></td>
					<td><%=recibo.getRfc() %></td>
					<td><%=recibo.getFecha() %></td>
					<td class="text-right"><%=recibo.getImporte() %></td>
				</tr>
		<%
			}
		%>
			<tr>
				<th colspan="9"><fmt:message key="aca.Total" /></th>
				<th class="text-right"><%=getformato.format( total ) %></th>
			</tr>
	</table>

</div>	
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>	
<%@ include file= "../../cierra_elias.jsp" %>