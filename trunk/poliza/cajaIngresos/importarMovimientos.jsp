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
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

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
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	/* ******** CICLO ******** */
	ArrayList<aca.ciclo.Ciclo> lisCiclo				= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	String cicloId 			= (String) session.getAttribute("cicloId");
	java.util.HashMap<String, String> mapAlum = Alumno.mapNombreCorto(conElias, escuelaId, cicloId,"NOMBRE");
	
	if( request.getParameter("cicloId") != null ){
		cicloId = request.getParameter("cicloId");
		session.setAttribute("cicloId", cicloId);
	}
	
	boolean encontroCiclo 	= false;
	for(aca.ciclo.Ciclo ciclo : lisCiclo){
		if(ciclo.getCicloId().equals(cicloId))encontroCiclo=true;
	}
	if(encontroCiclo == false && lisCiclo.size() > 0){
		cicloId = lisCiclo.get(0).getCicloId();
	}
	
	/* ******** PERIODO ******** */
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodo 	= CicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_PERIODO,F_INICIO");
	
	String periodoId		= (String) session.getAttribute("periodoId")==null?"0":(String) session.getAttribute("periodoId");
	
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
	ArrayList<aca.fin.FinPago> lisFinPago 					= finPagoL.getListCicloPeriodo(conElias, cicloId, periodoId, " ORDER BY TO_CHAR(FECHA,'YYYY-MM-DD'), DESCRIPCION");
	
	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 	= FinCuentaL.mapCuentasEscuela(conElias, escuelaId);
	
	/* ******** ACCIONES ******** */	
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	String pagoId 		= request.getParameter("pagoId")==null?"0":request.getParameter("pagoId");
	boolean esPagoIni	= aca.fin.FinPago.esPagoInicial(conElias, cicloId, periodoId, pagoId);
	
	// GUARDAR LOS MOVIMIENTOS	
	if(accion.equals("1")){
		
		/* ALUMNOS */
		ArrayList<aca.fin.FinCalculo> alumnos 			= null;
		
					
		/* ************ PAGO INICIAL ************ */
		
		if( esPagoIni ){
			
			/*DETALLES FIN CALCULO */
			ArrayList<aca.fin.FinCalculoDet> lisDetalles	= DetalleL.getListCalDetTodosAlumnos(conElias, cicloId, periodoId, "ORDER BY CODIGO_ID, CUENTA_ID");
			
			// Lista de alumnos sin pago inicial
			alumnos = FinCalculoLista.getListAlumnosCobro(conElias, cicloId, periodoId, "'G','P'", pagoId, "");
			
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
					/* Si el importe es mayor que cero entonces guarda el movimiento */
					if(importeInicial > 0){
						
						String cuentaNombre = detalle.getCuentaId();
						if(mapCuenta.containsKey(detalle.getCuentaId())){
							cuentaNombre = mapCuenta.get(detalle.getCuentaId()).getCuentaNombre();
						}
						
						// Si es por pagaré no hay beca en el Pago Inicial, asi que solo se guarda el importe ya calculado de Pago Inicial
						if(alumno.getTipoPago().equals("P")){
								
							FinMov.setEjercicioId(ejercicioId);
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(detalle.getCuentaId());
							FinMov.setAuxiliar(detalle.getCodigoId());
							FinMov.setDescripcion("COBRO INICIAL DE CONTADO - "+ cuentaNombre +" - "+ detalle.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(detalle.getImporteInicial());
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");						
							FinMov.setCicloId(detalle.getCicloId());
							FinMov.setPeriodoId(detalle.getPeriodoId());
							FinMov.setTipoMovId("5");
							System.out.println("L1 INSERTANDO ALUMNO " + FinMov.getAuxiliar());
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									// Actualizar el estado del pago a Contabilizado ("C")
									if(aca.fin.FinCalculoPago.updateEstado(conElias, cicloId, periodoId, alumno.getCodigoId(), pagoId, detalle.getCuentaId(), "C") ){
										//System.out.println("1. Estado actualizado en:"+cicloId+":"+periodoId+":"+alumno.getCodigoId()+":"+pagoId+":"+detalle.getCuentaId());
									}
								}else{
									error = true;
								}
							}
							
							if(new BigDecimal(detalle.getImporteBeca()).compareTo(BigDecimal.ZERO)!=0){
								FinMov.setEjercicioId(ejercicioId);
								FinMov.setPolizaId(polizaId);
								FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
								FinMov.setCuentaId(detalle.getCuentaId());
								FinMov.setAuxiliar(detalle.getCodigoId());
								FinMov.setDescripcion("BECA DE COBRO INICIAL - "+cuentaNombre +" - "+ detalle.getCodigoId() +" - "+ nombreAlumno);
								FinMov.setImporte(detalle.getImporteBeca());
								FinMov.setNaturaleza("C"); /* Crédito */
								FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
								FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
								FinMov.setFecha(aca.util.Fecha.getDateTime());
								FinMov.setReciboId("0");
								FinMov.setCicloId(detalle.getCicloId());
								FinMov.setPeriodoId(detalle.getPeriodoId());
								FinMov.setTipoMovId("5");
								System.out.println("L3 INSERTANDO ALUMNO " + FinMov.getAuxiliar());
								if(!FinMov.existeReg(conElias)){
									if(FinMov.insertReg(conElias)){																	
										// Insert de movimiento
									}else{
										error = true;
									}
								}
							}
								
						}else{ // Si es de contado la beca y el costo total se guardan en el Pago Inicial
								
							FinMov.setEjercicioId(ejercicioId);
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(detalle.getCuentaId());
							FinMov.setAuxiliar(detalle.getCodigoId());
							FinMov.setDescripcion("COBRO INICIAL - "+cuentaNombre +" - "+detalle.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(detalle.getImporte());
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							FinMov.setCicloId(detalle.getCicloId());
							FinMov.setPeriodoId(detalle.getPeriodoId());
							FinMov.setTipoMovId("5");
							System.out.println("L2 INSERTANDO ALUMNO " + FinMov.getAuxiliar());
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){
									// Insert de movimiento
								}else{
									error = true;
								}
							}
								
							FinMov.setEjercicioId(ejercicioId);
							FinMov.setPolizaId(polizaId);
							FinMov.setMovimientoId(FinMov.maxReg(conElias, ejercicioId, polizaId));
							FinMov.setCuentaId(detalle.getCuentaId());
							FinMov.setAuxiliar(detalle.getCodigoId());
							FinMov.setDescripcion("BECA DE COBRO INICIAL - "+cuentaNombre +" - "+ detalle.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(detalle.getImporteBeca());
							FinMov.setNaturaleza("C"); /* Crédito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							FinMov.setCicloId(detalle.getCicloId());
							FinMov.setPeriodoId(detalle.getPeriodoId());
							FinMov.setTipoMovId("5");
							System.out.println("L3 INSERTANDO ALUMNO " + FinMov.getAuxiliar());
							if(!FinMov.existeReg(conElias)){
								if(FinMov.insertReg(conElias)){																	
									// Insert de movimiento
								}else{
									error = true;
								}
							}
							
// 							// Actualizar el estado del pago a Contabilizado ("C")
							if(aca.fin.FinCalculoPago.updateEstado(conElias, cicloId, periodoId, alumno.getCodigoId(), pagoId, detalle.getCuentaId(), "C") ){
								// Actualizado
								//System.out.println("3.Estado actualizado en:"+cicloId+":"+periodoId+":"+alumno.getCodigoId()+":"+pagoId+":"+detalle.getCuentaId());
							}else{
								error = true;
							}
							
						}
						
					}
						
				}
				
				// Actualizar el estado del calculo de cobro (Estado anterior "G" se cambia a "P" )
				if(!aca.fin.FinCalculo.updateInscrito(conElias, cicloId, periodoId, alumno.getCodigoId(), "P")){					
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
		if( !esPagoIni ){
			
			/*DETALLES FIN CALCULO */
			ArrayList<aca.fin.FinCalculoPago> pagosAlumno	= CalculoPagoL.getListPagos(conElias, cicloId, periodoId, pagoId, "'A'","ORDER BY CODIGO_ID, CUENTA_ID");
				
			// Lista de alumnos con pago inicial
			alumnos = FinCalculoLista.getListAlumnosCobro(conElias, cicloId, periodoId, "'G','P'", pagoId, "");
			
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
							FinMov.setDescripcion("COBRO "+pagoId+" - "+cuentaNombre +" - "+ pago.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(costoPago.toString());
							FinMov.setNaturaleza("D"); /* Debito */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							FinMov.setCicloId(pago.getCicloId());
							FinMov.setPeriodoId(pago.getPeriodoId());
							FinMov.setTipoMovId("5");	
							
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
							FinMov.setDescripcion("BECA DE COBRO "+pagoId+" - "+cuentaNombre+" - "+pago.getCodigoId() +" - "+ nombreAlumno);
							FinMov.setImporte(becaPago+"");
							FinMov.setNaturaleza("C"); /* Créditos */
							FinMov.setReferencia(cicloId+"$$"+periodoId+"$$"+pagoId);
							FinMov.setEstado("R"); /* Recibo (aunque no se utilizan los recibos en este tipo de movimiento) */
							FinMov.setFecha(aca.util.Fecha.getDateTime());
							FinMov.setReciboId("0");
							FinMov.setCicloId(pago.getCicloId());
							FinMov.setPeriodoId(pago.getPeriodoId());
							FinMov.setTipoMovId("5");
							
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
	
	<h2><fmt:message key="aca.PolizasIngreso" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){ %>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong>
		&nbsp;&nbsp;&nbsp;
		<fmt:message key="aca.Poliza" />: <strong><%=polizaId %> | <%=FinPoliza.getDescripcion() %></strong>
	</div>

<%		if( !FinPoliza.getEstado().equals("A") ){ %>
		
		<div class="well">
			<a href="ingresos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
		
		<div class="alert">
			<fmt:message key="aca.PolizaCerrada" />
		</div>
		
<%		}else{ %>
			
		<form action="" name="forma" method="post">
			<input type="hidden" name="Accion" />
			
			<div class="well">
				<a href="ingresos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
								
				<select name="cicloId" id="cicloId" onchange='javascript:cambiaCiclo()' class="input-xxlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>>[<%=ciclo.getCicloId() %>] <%=ciclo.getCicloNombre() %></option>
				<%}%>
				</select>			
				
				<select name="periodoId" id="periodoId" onchange='javascript:cambiaPeriodo()' class="input-xlarge">
				<%for(aca.ciclo.CicloPeriodo periodo : lisPeriodo){%>
					<option value="<%=periodo.getPeriodoId() %>" <%if(periodo.getPeriodoId().equals(periodoId)){out.print("selected");} %>><%=periodo.getPeriodoNombre() %></option>
				<%}%>
				</select>	
				
			</div>
<% 			
			int numPagosIni = Integer.parseInt(aca.fin.FinPago.numPagosIniciales(conElias, cicloId, periodoId)); 
			if ( numPagosIni > 0){ 
%>			
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
							<%int cont = 0; %>
							<%for(aca.fin.FinPago pago : lisFinPago){%>
								<%cont++;%>
							<tr>
								<td><%=cont %></td>
								<td><a href="pagoAlumnos.jsp?pagoId=<%=pago.getPagoId()%>&cicloId=<%=cicloId%>&periodoId=<%=periodoId%>"><%=pago.getDescripcion() %></a></td>
								<td><%=aca.fin.FinCalculo.pendientesPago(conElias, cicloId, periodoId, pago.getPagoId()) %></td>
							</tr>
							<%}%>	
						</table>						
					</div>
				</div>
				
				<div class="span4">
					<p>
						<label for="pagoId">
							<fmt:message key="aca.GenerarCobro" />
						</label>
						<select name="pagoId" id="pagoId">							
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
<%			}else{ %>
				<div class="alert alert-danger">¡Debes registrar un pago inicial en la opción de "Fechas de Cobro"!</div>
<%			}
%>			
		</form>
					
	<%} %>
		
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>