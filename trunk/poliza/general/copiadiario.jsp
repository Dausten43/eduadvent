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

//modulo para generar poliza y guardar;

if(request.getParameter("polizaFuente")!=null && !request.getParameter("polizaFuente").equals("") && !request.getParameter("fecha").equals("") && !request.getParameter("descripcion").equals("")){
	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	String polizaId     = request.getParameter("polizaId")==null?"":request.getParameter("polizaId");
	String polizaFuente = request.getParameter("polizaFuente");
	String msj = "";
	
	
	polizaId = escuelaId + FinPoliza.maximoReg(conElias, ejercicioId);
	
	//System.out.println("NUMERO DE POLIZA " + polizaId);
	
	FinPoliza.setEjercicioId(ejercicioId);
	FinPoliza.setPolizaId(polizaId);
	FinPoliza.setFecha(request.getParameter("fecha"));
	FinPoliza.setDescripcion(request.getParameter("descripcion"));
	FinPoliza.setUsuario(usuario);
	FinPoliza.setEstado("A");//Abierta
	FinPoliza.setTipo("G"); //General
	
	
	
	
	if(FinPoliza.insertReg(conElias)){
		msj = "Guardado";
	//	System.out.println("guarda encabezado y procede a leer los movimientos " + polizaId);	
		ArrayList<aca.fin.FinMovimientos> movimientos = FinMovLista.getAllMovimientosPoliza(conElias, ejercicioId, polizaFuente, "");
	//	System.out.println("obtiene movimientos  " + movimientos.size());
		String movimientoId ="";
		
		for(aca.fin.FinMovimientos mov : movimientos){
			if(movimientoId.equals("")){
				movimientoId = FinMov.maxReg(conElias, ejercicioId, polizaId);
			}
			
			FinMov.setEjercicioId(ejercicioId);
			FinMov.setPolizaId(polizaId);
			FinMov.setMovimientoId(movimientoId);
			FinMov.setCuentaId(mov.getCuentaId());
			FinMov.setAuxiliar(mov.getAuxiliar());
			FinMov.setDescripcion(mov.getDescripcion());
			FinMov.setImporte(mov.getImporte());
			FinMov.setNaturaleza(mov.getNaturaleza()); /* Cargo o Debito */
			FinMov.setReferencia(mov.getReferencia());
			FinMov.setEstado(mov.getEstado()); /* Recibo */
			//if(request.getParameter("actualizaFecha")!=null){
				FinMov.setFecha(request.getParameter("fecha") + "00:00:00");
			//}else{
				FinMov.setFecha(mov.getFecha());
			//}
			FinMov.setReciboId(mov.getReciboId());
			FinMov.setCicloId(mov.getCicloId());
			FinMov.setPeriodoId(mov.getPeriodoId());
			FinMov.setTipoMovId(mov.getTipoMovId());
			
			if(FinMov.insertReg(conElias)){
		//		System.out.println("inserta movimientos  " );
				movimientoId="";
				msj = "Guardado";
			}else{
				msj = "NoGuardo";	
			}
		}
		
		%>
		<meta http-equiv="refresh" content="0; url=poliza.jsp" />
		<%
						
	}else{
		msj = "NoGuardo";
	}
	
	
}




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
	<div>
		<fmt:message key="aca.CopiaDiario" /> <%= polizaId %> |  <%=FinPoliza.getDescripcion() %>
		
	</div>
	</h2>
	<div class="well">
	<form class="form-horizontal" method="POST">
		<div class="control-group">
			<label class="control-label" for="fecha">Fecha</label>
			<div class="controls">
				<input type="text" id="fecha" name="fecha" autocomplete="off" required="required">
			</div>
		</div>
		
		<div class="control-group">
			<label class="control-label" for="descripcion">Descripcion</label>
			<div class="controls">
				<input type="text" id="descripcion" name="descripcion" required="required">
			</div>
		</div>
		<div class="control-group">
			<div class="controls" >
				<!--  <label class="checkbox" for="actualizaFecha">
					<input type="checkbox" id="actualizaFecha" name="actualizaFecha" checked="checked"> Modificar la fecha en los movimientos al copiar
				</label>-->
				<input type="hidden" name="polizaFuente" value="<%= polizaId %>">
				<button type="submit" class="btn">copiar</button>
			</div>
		</div>
	</form>
	
	</div>
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
	<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fecha').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>