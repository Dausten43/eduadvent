<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinReciboLista" scope="page" class="aca.fin.FinReciboLista"/>
<jsp:useBean id="FinRecibo" scope="page" class="aca.fin.FinRecibo"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>
	
<script>
	function Cancelar(respuesta, reciboId){
		if( confirm(" <fmt:message key="js.EstasSeguro" /> ") ){
			location.href='recibo.jsp?Accion=1&reciboId='+reciboId+'&respuesta='+respuesta;
		}
	}
</script>
	
<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("##0.00;(##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	
	/* ACCIONES */
	
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if( accion.equals("1") ){//Solicitar cancelación
		
		String reciboId 	= request.getParameter("reciboId");
		String respuesta 	= request.getParameter("respuesta"); 
		
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		
		
		
		
		FinRecibo.setReciboId(reciboId);
		FinRecibo.setEjercicioId(ejercicioId);
		if( FinRecibo.existeReg(conElias) ){
			FinRecibo.mapeaRegId(conElias, reciboId, ejercicioId);
			
			if(FinRecibo.getEstado().equals("S")){
				if( FinRecibo.updateEstado(conElias, respuesta, FinRecibo.getReciboId(), FinRecibo.getEjercicioId()) ){
					//Estado actualizado	
				}else{
					error = true;
				}	
			}else{
				error = true;
			}
		}else{
			error = true;
		}
		
		if( respuesta.equals("C") ){ // Si se cancela el recibo entonces cancela todos sus movimientos
			/* MOVIMIENTOS DEL RECIBO ACTUAL */
			ArrayList<aca.fin.FinMovimientos> movimientos = FinMovLista.getMovimientosRecibo(conElias, ejercicioId, reciboId, "");
			for(aca.fin.FinMovimientos mov : movimientos){
				mov.setEstado("C");
				if(mov.updateEstado(conElias)){
					//Cancelado
				}else{
					error = true; break;
				}
			}
		}
		
		
		
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoGuardo";
		}else{
			conElias.commit();
			msj = "Guardado";
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **
	}
	
	pageContext.setAttribute("resultado", msj);
	
	ArrayList<aca.fin.FinRecibo> recibos = FinReciboLista.getRecibosSolicitandoCancelacion(conElias, ejercicioId, " ORDER BY RECIBO_ID DESC, FECHA DESC ");
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.RecibosSolicitandoCancelacion" />
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong>
	</div>
	 	
	<table class="table table-condensed table-striped table-bordered">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Recibo" /></th>
				<th><fmt:message key="aca.CancelarPregunta" /></th>
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
		%>
				<tr>
					<td><%=cont %></td>
					<td>
						<%=recibo.getReciboId() %>
					</td>
					<td>
						<a href="javascript:Cancelar('C', '<%=recibo.getReciboId() %>');" class="btn btn-primary btn-mini"><i class="icon-ok icon-white"></i> <fmt:message key="aca.Si" /></a>
						<a href="javascript:Cancelar('A', '<%=recibo.getReciboId() %>');" class="btn  btn-mini"><i class="icon-remove"></i> <fmt:message key="aca.Negacion" /></a>
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
					<td class="text-right"><%=recibo.getImporte() %></td>
				</tr>
		<%
			}
		%>
	</table>

</div>	
	
<%@ include file= "../../cierra_elias.jsp" %>