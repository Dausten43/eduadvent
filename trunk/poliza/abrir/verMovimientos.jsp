<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinMovimientosLista" scope="page" class="aca.fin.FinMovimientosLista"/>
	
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
	
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovimientosLista.getAllMovimientosPolizaEstado(conElias, ejercicioId, polizaId, " ORDER BY RECIBO_ID DESC, FECHA DESC ");
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Movimientos" />
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
				<th><fmt:message key="aca.Alumno" /></th>
				<th><fmt:message key="aca.Recibo" /></th>
				<th><fmt:message key="aca.Cuenta" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Descripcion" /></th>
				<th><fmt:message key="aca.Referencia" /></th>
				<th><fmt:message key="aca.Cargo" /></th>
				<th><fmt:message key="aca.Creditos" /></th>
			</tr>
		</thead>
		
		<%
			float totalCargo	= 0;
			float totalCredito 	= 0;
			int cont = 0;
			for(aca.fin.FinMovimientos mov : movimientos){ 
				cont++;
				
				float importe = Float.parseFloat(mov.getImporte());
				if(mov.getNaturaleza().equals("D") && !mov.getEstado().equals("C")){
					totalCargo+=importe;
				}else if(mov.getNaturaleza().equals("C") && !mov.getEstado().equals("C")){
					totalCredito+=importe;
				}
		%>
				<tr <%if(mov.getEstado().equals("C")){ %>class="alert alert-danger"<%} %>>
					<td><%=cont %></td>
					<td>
						<%=aca.alumno.AlumPersonal.getNombre(conElias, mov.getAuxiliar(), "NOMBRE")  %>
						<%if(mov.getEstado().equals("C")){ %><span class="label label-important"><fmt:message key="aca.Cancelado" /></span><%} %>
					</td>
					<td><%=mov.getReciboId() %></td>
					<td><%=mov.getCuentaId() %></td>
					<td><%=mov.getFecha() %></td>
					<td><%=mov.getDescripcion() %></td>
					<td><%=mov.getReferencia() %></td>
					<td class="text-right">
						<%if(mov.getNaturaleza().equals("D")){ %>
							<%=getformato.format( importe ) %>
						<%}%>
					</td>
					<td class="text-right">
						<%if(mov.getNaturaleza().equals("C")){ %>
							<%=getformato.format( importe ) %>
						<%}%>
					</td>
				</tr>
		<%
			}
		%>
			<tr>
				<th colspan="7"><fmt:message key="aca.Total" /></th>
				<th class="text-right"><%=getformato.format( totalCargo) %></th>
				<th class="text-right"><%=getformato.format( totalCredito) %></th>
			</tr>
	</table>

</div>	
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>	
<%@ include file= "../../cierra_elias.jsp" %>