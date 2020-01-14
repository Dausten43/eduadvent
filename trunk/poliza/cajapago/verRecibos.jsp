<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinReciboLista" scope="page" class="aca.fin.FinReciboLista"/>
<jsp:useBean id="FinRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
	
<script>
	function solicitarCancelacion(reciboId){
		if( confirm(" <fmt:message key="js.ConfirmaSolicitudDeCancelacion" /> ") ){
			location.href='verRecibos.jsp?Accion=1&reciboId='+reciboId;
		}
	}
</script>
	
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
		salto = "caja.jsp";
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	
	/* ACCIONES */
	
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if( accion.equals("1") ){//Solicitar cancelación
		
		String reciboId = request.getParameter("reciboId");
		
		FinRecibo.setReciboId(reciboId);
		FinRecibo.setEjercicioId(ejercicioId);
		if( FinRecibo.existeReg(conElias) && FinPoliza.getEstado().equals("A") ){
			FinRecibo.mapeaRegId(conElias, reciboId, ejercicioId);
			
			if(FinRecibo.getEstado().equals("A")){
				if( FinRecibo.updateEstado(conElias, "S", FinRecibo.getReciboId(), FinRecibo.getEjercicioId()) ){
					//Estado actualizado	
				}	
			}
		}
	}
	
	
	ArrayList<aca.fin.FinRecibo> recibos = FinReciboLista.getListPoliza(conElias, polizaId, ejercicioId, " ORDER BY RECIBO_ID DESC, FECHA DESC ");
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Recibos" /> <small> ( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong> ) </small>
	</h2>
		
	<div class="well">
		<a href="caja.jsp" class="btn btn-primary">
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
				<th style="width:3%">&nbsp;</th>
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
					<td>
						<%=recibo.getReciboId() %>
					</td>
					<td>
						<a href="imprimirRecibo.jsp?reciboId=<%=recibo.getReciboId() %>&from=verRecibos">
							<%=recibo.getCliente() %>
						</a>
					</td>
					<td><%=recibo.getDomicilio() %></td>
					<td><%=recibo.getCheque() %></td>
					<td><%=recibo.getBanco() %></td>
					<td><%=recibo.getObservaciones() %></td>
					<td><%=recibo.getRfc() %></td>
					<td><%=recibo.getFecha() %></td>
					<td class="text-center">
						<%if(recibo.getEstado().equals("A") && FinPoliza.getEstado().equals("A")){ %>
							<a href="javascript:solicitarCancelacion('<%=recibo.getReciboId()%>');" class="btn btn-mini"><fmt:message key="aca.SolicitarCancelacion" /></a>
						<%}else if(recibo.getEstado().equals("S")){ %>
							<a disabled class="btn btn-mini"><fmt:message key="aca.SolicitudEnviada" /></a>
						<%}else if(recibo.getEstado().equals("C")){ %>
							<span class="label label-important"><fmt:message key="aca.Cancelado" /></span>
						<%} %>
					</td>
					<td class="text-right"><%=recibo.getImporte() %></td>
				</tr>
		<%
			}
		%>
			<tr>
				<th colspan="10"><fmt:message key="aca.Total" /></th>
				<th class="text-right"><%=getformato.format( total ) %></th>
			</tr>
	</table>

</div>	
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>