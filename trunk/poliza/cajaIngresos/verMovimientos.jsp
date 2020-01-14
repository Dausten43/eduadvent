<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinMovimientosLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
	
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
		salto = "ingresos.jsp";
	}
	
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovimientosLista.getMovimientosPolizaIngreso(conElias, ejercicioId, polizaId, " ORDER BY RECIBO_ID DESC, FECHA DESC ");
	
	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 		= FinCuentaL.mapCuentasEscuela(conElias, escuelaId);
	
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Movimientos" /> <small> ( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong> )</small>
	</h2>
		
	<div class="well">
		<a href="ingresos.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	 	
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Alumno" /></th>
				<th><fmt:message key="aca.Cuenta" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Descripcion" /></th>
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
				
				String cuentaNombre = mov.getCuentaId();
				if(mapCuenta.containsKey(mov.getCuentaId())){
					cuentaNombre = mapCuenta.get(mov.getCuentaId()).getCuentaNombre();
				}
		%>
				<tr <%if(mov.getEstado().equals("C")){ %>class="alert alert-danger"<%} %>>
					<td><%=cont %></td>
					<td>
						<%=mov.getAuxiliar() %> |
						<%=aca.alumno.AlumPersonal.getNombre(conElias, mov.getAuxiliar(), "NOMBRE")  %>
						<%if(mov.getEstado().equals("C")){ %><span class="label label-important"><fmt:message key="aca.Cancelado" /></span><%} %>
					</td>
					<td><%=mov.getCuentaId() %> | <%=cuentaNombre %></td>
					<td><%=mov.getFecha() %></td>
					<td><%=mov.getDescripcion() %></td>
					<td class="text-right"><%=getformato.format( importe ) %></td>
				</tr>
		<%
			}
		%>
			<tr>
				<th colspan="5"><fmt:message key="aca.Total" /></th>
				<th class="text-right"><%=getformato.format( total ) %></th>
			</tr>
	</table>

</div>	
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>