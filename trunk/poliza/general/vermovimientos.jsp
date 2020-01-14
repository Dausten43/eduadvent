<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="AlumPersonalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>

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
	
	String movimientoId = request.getParameter("MovimientoId")==null?"":request.getParameter("MovimientoId");
	
	/* ACCIONES */
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	pageContext.setAttribute("resultado", msj);
	
	/* ALUMNOS */
	ArrayList<aca.alumno.AlumPersonal> alumnos = AlumPersonalLista.getListAllNombres(conElias, escuelaId, "");
	
	/* CUENTAS */
	ArrayList<aca.fin.FinCuenta> cuentas = FinCuentaLista.getListCuentas(conElias, escuelaId, " ORDER BY CUENTA_ID");
	
	/* MOVIMIENTOS */
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovLista.getAllMovimientosPoliza(conElias, ejercicioId, polizaId, "");
	
	if(!movimientoId.equals("")){
		FinMov.mapeaRegId(conElias, ejercicioId, polizaId, movimientoId);	
	}
%>

<div id="content">
	
	<h2>
		<fmt:message key="aca.Movimiento" />
		<small>(
			<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong>&nbsp;&nbsp;
			<fmt:message key="aca.Poliza" />: <strong><%=polizaId %> | <%=FinPoliza.getDescripcion() %></strong>
		)</small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
		
	<div class="well">
		<a href="poliza.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
				
	<div class="row">
		
		<div class="span9">
			
			<h4><fmt:message key="aca.Movimientos" /></h4>
			
			<table class="table table-condensed table-bordered table-striped">
				<thead>
					<tr>
						<th>#</th>
						<th><fmt:message key="aca.Alumno" /></th>
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
						<tr>
							<td><%=cont %></td>
							<td>
								<%=aca.alumno.AlumPersonal.getNombre(conElias, mov.getAuxiliar(), "NOMBRE")  %>
							</td>
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
					<th colspan="6"><fmt:message key="aca.Total" /></th>
					<th class="text-right"><%=getformato.format( totalCargo) %></th>
					<th class="text-right"><%=getformato.format( totalCredito) %></th>
				</tr>
			</table>
				
		</div>
	</div>	
</div>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>