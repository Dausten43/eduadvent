<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinCalculoLista" scope="page" class="aca.fin.FinCalculoLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="DetalleL" scope="page" class="aca.fin.FinCalculoDetLista"/>
<jsp:useBean id="CalculoPagoL" scope="page" class="aca.fin.FinCalculoPagoLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="finPagoL" scope="page" class="aca.fin.FinPagoLista"/>
<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonalLista"/>

<script>	
	
	function cambiaCiclo(){
		document.forma.submit();
	}
	
	function cambiaPeriodo(){
		document.forma.submit();
	}
	function guardar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00");

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("EjercicioId");
	String usuario 		= (String)session.getAttribute("codigoId"); 
	
	

	
	/* INFORMACION DE LA POLIZA */
	
	if(request.getParameter("polizaId") != null){
		session.setAttribute("polizaId", request.getParameter("polizaId"));
	}
	
	String polizaId 	= (String) session.getAttribute("polizaId");
	
	if( polizaId == null ){
		response.sendRedirect("ingresos.jsp");
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	/* ******** CICLO ******** */
	ArrayList<aca.ciclo.Ciclo> lisCiclo				= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	String cicloId 			= (String) session.getAttribute("cicloId");
	java.util.HashMap<String, String> mapAlum = Alumno.mapNombreCorto(conElias, escuelaId, cicloId,"NOMBRE");
	
	if(request.getParameter("cicloId")!=null){
		cicloId = request.getParameter("cicloId");
		session.setAttribute("cicloId", cicloId);
	}

	
	boolean encontroCiclo 	= false;
	for(aca.ciclo.Ciclo ciclo : lisCiclo){
		if(ciclo.getCicloId().equals(cicloId))encontroCiclo=true;
	}
	if(encontroCiclo==false && lisCiclo.size()>0){
		cicloId = lisCiclo.get(0).getCicloId();
	}
	
	/* ******** PERIODO ******** */
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodo 	= CicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_PERIODO.F_INICIO");
	
	String periodoId		= (String) session.getAttribute("periodoId")==null?"":(String) session.getAttribute("periodoId");
	
	if(request.getParameter("periodoId")!=null){
		periodoId = request.getParameter("periodoId");
		session.setAttribute("periodoId", periodoId);
	}
	
	boolean encontroPeriodo	= false;
	for(aca.ciclo.CicloPeriodo periodo : lisPeriodo){
		if(periodo.getPeriodoId().equals(periodoId))encontroPeriodo=true;
	}
	if(encontroPeriodo==false && lisPeriodo.size()>0){
		periodoId = lisPeriodo.get(0).getPeriodoId();
	}
	
	
	/* LISTA DE FECHAS DE COBRO*/
	ArrayList<aca.fin.FinPago> lisFinPago 					= finPagoL.getListCicloPeriodo(conElias, cicloId, periodoId, "ORDER BY FIN_PAGO.FECHA, DESCRIPCION");
	
	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 	= FinCuentaL.mapCuentasEscuela(conElias, escuelaId);
	
	/* ******** ACCIONES ******** */
	
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	String pagoId 	= request.getParameter("pagoId")==null?"":request.getParameter("pagoId");
	
	// GUARDAR LOS MOVIMIENTOS	
	if(accion.equals("1")){
		
		/* ALUMNOS */
		ArrayList<aca.fin.FinCalculo> alumnos 			= null;
		
					
		/* ************ PAGO INICIAL ************ */
		
		if( pagoId.equals("PI") ){
			
			/*DETALLES FIN CALCULO */
			ArrayList<aca.fin.FinCalculoDet> lisDetalles	= DetalleL.getListCalDetTodosAlumnos(conElias, cicloId, periodoId, "ORDER BY CODIGO_ID, CUENTA_ID");
			
			// Lista de alumnos sin pago inicial
			alumnos = FinCalculoLista.getListAlumnos(conElias, cicloId, periodoId, "'G'","");
			
			/* BEGIN TRANSACTION */
			conElias.setAutoCommit(false);
			boolean error = false;
			
			String nombreAlumno = "";
			
			for(aca.fin.FinCalculo alumno : alumnos){			
				 
				if(mapAlum.containsKey(alumno.getCodigoId())){
					nombreAlumno = mapAlum.get(alumno.getCodigoId()).toString();
				}else{
					nombreAlumno = "-";
				}
				
				for(aca.fin.FinCalculoDet detalle : lisDetalles){
					 /* Solo los detalles del alumno actual */
					if(detalle.getCodigoId().equals(alumno.getCodigoId()) == false ){
						continue;
					}
						
					float importeInicial = Float.parseFloat( detalle.getImporteInicial() );
					if(importeInicial > 0){/* Si el importe es mayor que cero entonces guarda el movimiento */
						
						String cuentaNombre = detalle.getCuentaId();
						if(mapCuenta.containsKey(detalle.getCuentaId())){
							cuentaNombre = mapCuenta.get(detalle.getCuentaId()).getCuentaNombre();
						}
						
						if(alumno.getTipoPago().equals("P")){// Si es por pagaré no hay beca en el Pago Inicial, asi que solo se guarda el importe ya calculado de Pago Inicial
							
							FinMov.setEjercicioId(ejercicioId);
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(detalle.getCuentaId());
							FinMov.setAuxiliar(detalle.getCodigoId());
							FinMov.setDescripcion("PAGO INICIAL DE CONTADO - "+ cuentaNombre +" - "+ detalle.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(detalle.getImporteInicial());
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									//Guardado
								}else{
									error = true;
								}
							}
							
						}else{// Si es de contado la beca y el costo total se guardan en el Pago Inicial
							
							FinMov.setEjercicioId(ejercicioId);
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(detalle.getCuentaId());
							FinMov.setAuxiliar(detalle.getCodigoId());
							FinMov.setDescripcion("PAGO INICIAL - "+cuentaNombre +" - "+detalle.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(detalle.getImporte());
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									//Guardado
								}else{
									error = true;
								}
							}
							
							FinMov.setEjercicioId(ejercicioId);
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(detalle.getCuentaId());
							FinMov.setAuxiliar(detalle.getCodigoId());
							FinMov.setDescripcion("BECA DE PAGO INICIAL - "+cuentaNombre +" - "+ detalle.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(detalle.getImporteBeca());
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									//Guardado
								}else{
									error = true;
								}
							}
							
						}
						
					}
						
				}
				
				if(aca.fin.FinCalculo.updateInscrito(conElias, cicloId, periodoId, alumno.getCodigoId(), "P")){
					//Estado actualizado
				}else{
					error = true;
				}
			}
			
			/* END TRANSACTION */
			if(error){
				conElias.rollback();
				msj = "NoGuardo";
			}else{
				conElias.commit();
				msj = "Guardado";
			}
			conElias.setAutoCommit(true);
		}
		
		/* ************ O T R O S   P A G O S ************ */
		
		// Si se selecciono alguno de los pagos (por lo tanto no el pago inicial)
		if( !pagoId.equals("PI") ){ 
			
			/*DETALLES FIN CALCULO */
			ArrayList<aca.fin.FinCalculoPago> pagosAlumno	= CalculoPagoL.getListPagos(conElias, cicloId, periodoId, pagoId, "'A'","ORDER BY CODIGO_ID, CUENTA_ID");
				
			// Lista de alumnos con pago inicial
			alumnos = FinCalculoLista.getListAlumnos(conElias, cicloId, periodoId, "'P'","");
			
			/* BEGIN TRANSACTION */
			conElias.setAutoCommit(false);
			boolean error = false;
			
			String nombreAlumno = "-"  ;
			for(aca.fin.FinCalculo alumno : alumnos){
				//System.out.println("Datos:"+alumno.getCodigoId()+":"+pagoId+":"+alumno.getNumPagos()+":"+pagosAlumno.size());
				
				for(aca.fin.FinCalculoPago pago : pagosAlumno){
					
					
					if(mapAlum.containsKey(pago.getCodigoId())){
						nombreAlumno = mapAlum.get(pago.getCodigoId()).toString();
					}else{
						nombreAlumno = "-";
					}
					
					/* SOLO A LOS PAGOS QUE AUN NO HAN SIDO CONTABILIZADOS */	
					if( pago.getCodigoId().equals(alumno.getCodigoId()) &&  aca.fin.FinCalculoPago.getEstado(conElias, cicloId, periodoId, alumno.getCodigoId(), pagoId, pago.getCuentaId()).equals("A") ){ 
							
						//System.out.println("Pago:"+alumno.getCodigoId()+":"+pago.getCuentaId()+":"+pago.getImporte()+":"+pago.getPagoId()+":"+pagoId);
								
						String cuentaNombre = pago.getCuentaId();
						if(mapCuenta.containsKey(pago.getCuentaId())){
							cuentaNombre = mapCuenta.get(pago.getCuentaId()).getCuentaNombre();
						}
								
						BigDecimal costoPago 	= new BigDecimal(pago.getImporte());
						BigDecimal becaPago 	= new BigDecimal(pago.getBeca());
						//BigDecimal totalPago 	= costoPago.subtract(becaPago); 
								
						/* Si el costo es mayor que cero entonces guarda el movimiento */
						if(costoPago.compareTo(BigDecimal.ZERO) > 0){
							
							/* ==== GRABAR MOVIMIENTO DE COSTO ==== */
							
							FinMov.setEjercicioId(ejercicioId);						
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(pago.getCuentaId());
							FinMov.setAuxiliar(pago.getCodigoId());
							FinMov.setDescripcion("PAGO "+pagoId+" - "+cuentaNombre +" - "+ pago.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(costoPago+"");
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									//Guardado
									//System.out.println("Guarde costo:"+pago.getCodigoId()+":"+pago.getCuentaId());
								}else{
									//System.out.println("Encontre Error en costo..");
									error = true;
								}
							}
						}	
						
						/* Si el importe de la beca es mayor que cero entonces guarda el movimiento */
						if(becaPago.compareTo(BigDecimal.ZERO) > 0){
							/* ==== GRABAR MOVIMIENTO DE BECA  */
	
							FinMov.setEjercicioId(ejercicioId);						
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(pago.getCuentaId());
							FinMov.setAuxiliar(pago.getCodigoId());
							FinMov.setDescripcion("BECA DE PAGO "+pagoId+" - "+cuentaNombre+" - "+pago.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(becaPago+"");
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									//Guardado
									//System.out.println("Guarde beca:"+pago.getCodigoId()+":"+pago.getCuentaId());
								}else{
									//System.out.println("Encontre Error en beca..");
									error = true;
								}
							}
						}	
							
						if(aca.fin.FinCalculoPago.updateEstado(conElias, cicloId, periodoId, alumno.getCodigoId(), pagoId, pago.getCuentaId(), "C") ){
							//Estado actualizado								
						}else{
							//System.out.println("Encontre Error al actualizar estado..");
							error = true;
						}								
															
					}// Si no está contabilizado					
				
				}//end for pagos alumno
				
				
			} // end de ciclo de alumnos
			
			/* END TRANSACTION */
			if(error){
				conElias.rollback();
				msj = "NoGuardo";
			}else{
				conElias.commit();
				msj = "Guardado";
			}
			conElias.setAutoCommit(true);
			
		}		
		
	}
	
	pageContext.setAttribute("resultado", msj);
												
%>

<div id="content">
	
	<h2><fmt:message key="aca.Movimiento" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong>
		<br>
		<fmt:message key="aca.Poliza" />: <strong><%=polizaId %> | <%=FinPoliza.getDescripcion() %></strong>
	</div>

	<%if( !FinPoliza.getEstado().equals("A") ){ %>
		
		<div class="well">
			<a href="ingresos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
		
		<div class="alert">
			<fmt:message key="aca.PolizaCerrada" />
		</div>
		
	<%}else{ %>
			
		<form action="" name="forma" method="post">
			<input type="hidden" name="Accion" />
			
			<div class="well">
				<a href="ingresos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
				
				
				<select name="cicloId" id="cicloId" onchange='javascript:cambiaCiclo()' class="input-xlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>><%=ciclo.getCicloNombre() %></option>
				<%}%>
				</select>
			
				
				<select name="periodoId" id="periodoId" onchange='javascript:cambiaPeriodo()' class="input-xlarge">
				<%for(aca.ciclo.CicloPeriodo periodo : lisPeriodo){%>
					<option value="<%=periodo.getPeriodoId() %>" <%if(periodo.getPeriodoId().equals(periodoId)){out.print("selected");} %>><%=periodo.getPeriodoNombre() %></option>
				<%}%>
				</select>	
				
			</div>
			
			<div class="row">
			
				<div class="span4">
					<div class="alert">
						<h5><fmt:message key="aca.AlumnosPendientes" /></h5>
						
						
						<table class="table table-condensed table-bordered">
							<tr>
								<th>#</th>
								<th><fmt:message key="aca.Pago" /></th>
								<th><fmt:message key="aca.Alumnos" /></th>
							</tr>
							<tr>
								<td>1</td>
								<td>Pago inicial</td>
								<td><%=aca.fin.FinCalculo.pendientesPagoInicial(conElias, cicloId, periodoId) %></td>
							</tr>
							<%int cont = 1; %>
							<%for(aca.fin.FinPago pago : lisFinPago){%>
								<%cont++;%>
								<tr>
									<td><%=cont %></td>
									<td><%=pago.getDescripcion() %></td>
									<td><%=aca.fin.FinCalculo.pendientesPago(conElias, cicloId, periodoId, pago.getPagoId()) %></td>
								</tr>
							<%}%>	
						</table>
						
					</div>
				</div>
				
				<div class="span4">
					<p>
						<label for="pagoId">
							<fmt:message key="aca.Pago" />
						</label>
						<select name="pagoId" id="pagoId">
							<option value="PI" <%if(pagoId.equals("PI")){out.print("selected");} %>>Pago Inicial</option>
							<%for(aca.fin.FinPago pago : lisFinPago){%>
								<option value="<%=pago.getPagoId() %>" <%if(pago.getPagoId().equals(pagoId)){out.print("selected");} %>><%=pago.getDescripcion() %></option>
							<%} %>
						</select>
					</p>					
					
					<div class="well">
						<a href="javascript:guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
					</div>
				</div>
			
			</div>			
			
		</form>
					
	<%} %>
		
</div>

<%@ include file= "../../cierra_elias.jsp" %>