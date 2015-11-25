<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinRecibo" scope="page" class="aca.fin.FinRecibo"/>


<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("##0.00;(##0.00)");
	String from = request.getParameter("from");

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	
	String recibo 		= request.getParameter("reciboId");
	if(recibo == null){
		response.sendRedirect(from+".jsp");
	}
	
	/* INFORMACION DE LA POLIZA */
	String polizaId 	= (String) session.getAttribute("polizaId");
	
	if( polizaId == null ){
		response.sendRedirect("caja.jsp");
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	/* INFORMACION DEL RECIBO */
	FinRecibo.mapeaRegId(conElias, recibo, ejercicioId);
		
	/* MOVIMIENTOS DEL RECIBO ACTUAL */
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovLista.getMovimientos(conElias, ejercicioId, polizaId, recibo, "");
	
%>

<div id="content">
	
	<h2><fmt:message key="aca.Recibo" /><small> ( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong> ) </small></h2>
	
	<div class="alert alert-info">		
		<fmt:message key="aca.Poliza" />: [ <strong><%=polizaId %> | <%=FinPoliza.getDescripcion() %></strong> ]&nbsp;&nbsp;	
		<fmt:message key="aca.Recibo" />: [ <strong><%=recibo %></strong> ]
	</div>
	
	<div class="well">
		<a href="<%=from %>.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a href="reciboPDF.jsp?Recibo=<%=recibo %>&ejercicioId=<%=ejercicioId%>&polizaId=<%=polizaId %>" class = "btn btn-primary"><i class="icon-print icon-white"></i> M&eacute;xico</a>
		<a href="reciboHTML.jsp?Recibo=<%=recibo %>&ejercicioId=<%=ejercicioId%>&polizaId=<%=polizaId %>" class = "btn btn-primary"><i class="icon-print icon-white"></i> UDOCA</a>
	</div>
		
	<h4><fmt:message key="aca.Movimientos" /></h4>
	<table class="table table-condensed table-bordered">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Alumno" /></th>
				<th><fmt:message key="aca.Cuenta" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Descripcion" /></th>
				<th><fmt:message key="aca.Referencia" /></th>
				<th class="text-right"><fmt:message key="aca.Importe" /></th>
			</tr>
		</thead>
		<%
			float total = 0;
			int cont = 0;
			for(aca.fin.FinMovimientos mov : movimientos){
				cont++;
				
				float importe = Float.parseFloat(mov.getImporte());
				if(!mov.getEstado().equals("C")){
					total+=importe;
				}
		%>
				<tr <%if(mov.getEstado().equals("C")){ %>class="alert alert-danger"<%} %>>
					<td><%=cont %></td>
					<td>
						<%=aca.alumno.AlumPersonal.getNombre(conElias, mov.getAuxiliar(), "NOMBRE")  %>
						<%if(mov.getEstado().equals("C")){ %><span class="label label-important"><fmt:message key="aca.Cancelado" /></span><%} %>
					</td>
					<td><%=mov.getCuentaId() %></td>
					<td><%=mov.getFecha() %></td>
					<td><%=mov.getDescripcion() %></td>
					<td><%=mov.getReferencia() %></td>
					<td class="text-right"><%=getformato.format( importe ) %></td>
				</tr>
		<%
			}
		%>
		<tr>
			<th colspan="6"><fmt:message key="aca.Total" /></th>
			<th class="text-right"><%=getformato.format( total ) %></th>
		</tr>
	</table>	
						
</div>


<%@ include file= "../../cierra_elias.jsp" %>