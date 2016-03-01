<%@page import="aca.fin.FinCalculoPago"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPagoLista" scope="page" class="aca.fin.FinCalculoPagoLista"/>
<script>
	function CancelarPago(ciclo, periodo, alumno, pago, cuenta, fecha){
		if(confirm(' <fmt:message key='js.ConfirmaCancelar' /> ')){
			document.location.href="pagodetalle.jsp?Accion=1&CicloId="+ciclo+"&PeriodoId="+periodo+"&Auxiliar="+alumno+"&PagoId="+pago+"&CuentaId="+cuenta+"&Fecha="+fecha;			
		}
	}	
</script>
<%	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String) session.getAttribute("ejercicioId");	
	
	String alumno 		= request.getParameter("Auxiliar");
	String fecha 		= request.getParameter("Fecha");
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String padreCaja 	= request.getParameter("Padre")==null?"0":request.getParameter("Padre");
	
	// Cancelar el pago
	if (accion.equals("1")){
		String cicloId 		= request.getParameter("CicloId");
		String periodoId 	= request.getParameter("PeriodoId");
		String pagoId 		= request.getParameter("PagoId");
		String cuentaId 	= request.getParameter("CuentaId");
		//System.out.println("Cancelar..."+cicloId+":"+periodoId+":"+pagoId+":"+cuentaId);
		
		if ( FinCalculoPago.updateEstado(conElias, cicloId, periodoId, alumno, pagoId, cuentaId, "C") ){
		}
		
	}
	
	// Lista de pagos del alumno por fecha
	ArrayList<aca.fin.FinCalculoPago> pagos 		= FinPagoLista.listPagosAlumnoPorFecha(conElias, alumno, fecha, " ORDER BY CUENTA_ID");
%>
<div id="content">	
	<h2><fmt:message key="aca.Pago" /> <small> ( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong> )</small></h2>
	<div class="well">
		<a href="movimientos.jsp?Auxiliar=<%=alumno%>&Padre=<%=padreCaja%>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	<table class="table table-condensed">
		<tr>
			<th>#</th>
			<th>Op.</th>
			<th>Fecha</th>
			<th>Cuenta</th>			
			<th style="text-align:right">Importe</th>
			<th>Estado</th>
		</tr>
	<%
			int row = 0;
			for (aca.fin.FinCalculoPago pago: pagos){
				row++;
				String nombreCuenta = aca.fin.FinCuenta.getCuentaNombre(conElias, pago.getCuentaId());
	%>
		<tr>
			<td><%=row%></td>
			<td>
				<a href="javascript:CancelarPago('<%=pago.getCicloId()%>','<%=pago.getPeriodoId()%>','<%=alumno%>','<%=pago.getPagoId()%>','<%=pago.getCuentaId()%>','<%=fecha%>')">
					<i class="icon-remove-sign"></i>
				</a>
			</td>
			<td><%= pago.getFecha() %></td>
			<td>[<%= pago.getCuentaId() %>] <%= nombreCuenta %></td>
			<td style="text-align:right"><%= pago.getImporte() %></td>
			<td><%= pago.getEstado() %></td>
		</tr>
	<%			
			}
	%>
	</table>	
</div>
<%@ include file= "../../cierra_elias.jsp" %>