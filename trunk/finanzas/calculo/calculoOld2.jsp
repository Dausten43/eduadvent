<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="Calculo" scope="page" class="aca.fin.FinCalculo"/>
<jsp:useBean id="FinCostoL" scope="page" class="aca.fin.FinCostoLista"/>
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="DetalleL" scope="page" class="aca.fin.FinCalculoDetLista"/>
<jsp:useBean id="FinCalculo" scope="page" class="aca.fin.FinCalculo"/>
<jsp:useBean id="FinCalculoDet" scope="page" class="aca.fin.FinCalculoDet"/>
<jsp:useBean id="FinCalculoPago" scope="page" class="aca.fin.FinCalculoPago"/>
<jsp:useBean id="FinPago" scope="page" class="aca.fin.FinPago"/>
<jsp:useBean id="FinPagoL" scope="page" class="aca.fin.FinPagoLista"/>
<jsp:useBean id="FinCalculoPagoL" scope="page" class="aca.fin.FinCalculoPagoLista"/>

<script>	
	function cambiaCiclo( ){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
	
	function cambiaPeriodo( ){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
	
	function Grabar(){
		document.forma.Accion.value	= "2";
		document.forma.submit();
	}
	
	function Calcular(){
		if( $('.checkbox-pagos:checked').length > 0 || $('#TipoPago').val() == 'C' ){
			document.forma.Accion.value	= "4";
			document.forma.submit();
		}else{
			alert("<fmt:message key='js.SeleccionarAlMenosUnPago' />");
		}
	}
	
	function Formato( periodoId ){
		document.location.href = "formato.jsp?PeriodoId="+periodoId;
	}
	
	function CerrarCalculo( ){
		if (confirm("<fmt:message key='js.SeguroDeCerrarCalculoCobro' />")){
			document.forma.Accion.value	= "5";
			document.forma.submit();
		}
	}
	
	function AbrirCalculo( ){
		if (confirm("<fmt:message key='js.CancelarCalculoCobro' />")){
			document.forma.Accion.value	= "6";
			document.forma.submit();
		}	
	}
	
	function Todos(){		
		$(".checkbox-pagos").prop('checked',true);
	}
		
	function Ninguno(){		
		$(".checkbox-pagos").prop('checked',false);
	}
</script>

<%! 
   
	/* CLASE PARA TRAER LA BECA EN PORCENTAJE, CANTIDAD E IMPORTE TOTAL */
   public class Beca{
		
		public BigDecimal importeBeca;
		public BigDecimal becaPorcentaje;
		public BigDecimal becaCantidad;
		
		private Beca(ArrayList<aca.beca.BecAlumno> becasAlumno, BigDecimal importeTotal){
			importeBeca 	= new BigDecimal("0");
			becaPorcentaje 	= new BigDecimal("0");
			becaCantidad 	= new BigDecimal("0");
			
			for(aca.beca.BecAlumno beca : becasAlumno){
				if(beca.getTipo().equals("PORCENTAJE")){
					importeBeca 	= importeBeca.add( importeTotal.multiply( new BigDecimal(beca.getBeca()) ).divide( new BigDecimal("100"), 2, RoundingMode.DOWN ) );
					becaPorcentaje	= becaPorcentaje.add( new BigDecimal(beca.getBeca()) );
				}else{
					importeBeca		= importeBeca.add( new BigDecimal(beca.getBeca()) );
					becaCantidad	= becaCantidad.add( new BigDecimal(beca.getBeca()) );
				}
			}
			
			/* VERIFICAR QUE LA BECA NO SEA MAYOR QUE EL COSTO */
			
			if(importeBeca.compareTo(importeTotal) == 1){ // Si importeBeca > importeTotal
				importeBeca = importeTotal;
			}
			
			if(becaPorcentaje.compareTo(new BigDecimal("100")) == 1){ // Si becaPorcentaje > 100
				becaPorcentaje = new BigDecimal("100");
			}
			
			if(becaCantidad.compareTo(importeTotal) == 1){ // Si becaCantidad > importeTotal
				becaCantidad = importeTotal;
			}
			
		}
   }

	public BigDecimal PIpagos(BigDecimal importe, BigDecimal importeBeca, BigDecimal porcentajePagoInicial){
		return importe.subtract(importeBeca).multiply(porcentajePagoInicial).divide(new BigDecimal("100"), 2, RoundingMode.DOWN);
	}

%>

<%
	java.text.DecimalFormat formato 			= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String usuario 			= (String) session.getAttribute("codigoId");
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String codigoAlumno 	= (String) session.getAttribute("codigoAlumno");
	boolean esContable 		= aca.usuario.Usuario.esContable(conElias, usuario);
	boolean esAdmin 		= aca.usuario.Usuario.esAdministrador(conElias, usuario);
	
	String cicloElegido		= request.getParameter("Ciclo")		== null ? "0" : request.getParameter("Ciclo");
	String periodoId		= request.getParameter("PeriodoId")	== null ? "1" : request.getParameter("PeriodoId");
	
	/* CICLO ESCOLAR ELEGIDO O ACTIVO */
	if (!cicloElegido.equals("0")){
		cicloId = cicloElegido;
		session.setAttribute("cicloId", cicloId);
	}
	
	/* PERIODOS DE INSCRIPCIÓN */
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodo 	= CicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_PERIODO.F_INICIO");
	boolean encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisPeriodo){
		if(per.getPeriodoId().equals(periodoId)){
			encontro = true;
		}
	}
	if(encontro==false && lisPeriodo.size()>0){
		periodoId = lisPeriodo.get(0).getPeriodoId();
	}
	
	
	String fecha 				= request.getParameter("Fecha")				==null ? aca.util.Fecha.getHoy() : request.getParameter("Fecha");
	String accion 				= request.getParameter("Accion")			==null ? "0" : request.getParameter("Accion");
	String inicialPagos			= request.getParameter("InicialPagos")		==null ? "0" : request.getParameter("InicialPagos");
	String inicialContado		= request.getParameter("InicialContado")	==null ? "0" : request.getParameter("InicialContado");
	String tipoPago 			= request.getParameter("TipoPago")			==null ? "P" : request.getParameter("TipoPago");
	
	String numPagosIniciales	= aca.fin.FinPago.numPagosIniciales(conElias, cicloId, periodoId);
	
	/* PAGOS DEL ALUMNO */
	ArrayList<aca.fin.FinCalculoPago> pagosAlumno 	= FinCalculoPagoL.getListPagosAlumnoCuentas(conElias, cicloId, periodoId, codigoAlumno, " ORDER BY TO_CHAR(FECHA,'YYYY')||TO_CHAR(FECHA,'MM')||TO_CHAR(FECHA,'DD')");
	
	/* PAGOS DADOS DE ALTA EN CIERTO CICLO Y PERIODO DE INSCRIPCION */
	ArrayList<aca.fin.FinPago> lisPagos 			= FinPagoL.getListCicloPeriodo(conElias, cicloId, periodoId, "'P'"," ORDER BY TO_CHAR(FECHA,'YYYY')||TO_CHAR(FECHA,'MM')||TO_CHAR(FECHA,'DD')");
	
	
	/* INFORMACION ACADEMICA DEL ALUMNO */
	
	String nombreAlumno			= "";
	String planId				= "";
	String grado 				= "0";
	String grupo				= "0";	
	String clasFin				= "0";
	
	boolean existeAlumno 		= false;
	boolean existePlan			= false;
	
	// Busca el nombre del alumno
	if (Alumno.existeReg(conElias, codigoAlumno)){
		Alumno.mapeaRegId(conElias, codigoAlumno);
		nombreAlumno = Alumno.getNombre()+" "+Alumno.getApaterno()+" "+Alumno.getAmaterno();
		AlumPlan.setCodigoId(codigoAlumno);	
		
		// Busca el plan de estudios del alumno
		if ( AlumPlan.mapeaRegActual(conElias, codigoAlumno) ){
			planId 	= AlumPlan.getPlanId();
			grado 	= AlumPlan.getGrado();
			grupo 	= AlumPlan.getGrupo();			
			existePlan = true;
		}
		// Busca la clasificacion del alumno
		clasFin = aca.alumno.AlumPersonal.getClasFinId(conElias, codigoAlumno);
		existeAlumno = true;
	}
	
	
	/* INFORMACION FINANCIERA DEL ALUMNO */
	
	boolean existeCalculo	= false;
		
	// Busca los datos del cálculo de cobro
	FinCalculo.setCicloId(cicloId);
	FinCalculo.setPeriodoId(periodoId);
	FinCalculo.setCodigoId(codigoAlumno);						
	if (FinCalculo.existeReg(conElias)){
		FinCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
		if (!accion.equals("4") && !accion.equals("5")){ /* SI NO SE VA HA REALIZAR EL CALCULO DE COBRO, Y SI SI ENTONCES PONER EL QUE ESTA SELECCIONADO */
			tipoPago = FinCalculo.getTipoPago();
		}
		existeCalculo = true;
	}else{
		// Graba el calculo de cobro con valores default
		if (!cicloId.equals("0") && existeAlumno ){
			FinCalculo.setClasFinId(clasFin);
			FinCalculo.setImporte("0");
			FinCalculo.setInscrito("N");
			FinCalculo.setPlanId(planId);
			FinCalculo.setTipoPago(tipoPago);
			FinCalculo.setNumPagos("0");
			FinCalculo.setFecha(fecha);
			FinCalculo.setFolio( FinCalculo.maxReg(conElias, cicloId, periodoId));
			if (FinCalculo.insertReg(conElias)){
				existeCalculo = true;
			}
		}
	}
	
	
	/* CICLOS */
	ArrayList<aca.ciclo.Ciclo> lisCiclo				= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	/* COSTOS QUE NO ESTEN YA ASIGNADOS AL ALUMNO */	
	ArrayList<aca.fin.FinCosto> lisCosto 			= FinCostoL.getListPlanCostosAlumno(conElias, cicloId, periodoId, planId, codigoAlumno, "ORDER BY PLAN_ID, CUENTA_ID, CLASFIN_ID");
	
	/* DETALLES DEL CALCULO DE COBRO*/
	ArrayList<aca.fin.FinCalculoDet> lisDetalles	= DetalleL.getListCalDet(conElias, cicloId, periodoId, codigoAlumno,"ORDER BY CUENTA_ID");
	
	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 		= FinCuentaL.mapCuentasEscuela(conElias, escuelaId);	
	
	String msj = "";
	
	/* ========== GRABA LOS COSTOS AL ALUMNO ========== */
	if (accion.equals("2")){
		
		conElias.setAutoCommit(false);
		boolean error = false;
		
		if (existeCalculo){
			for(aca.fin.FinCosto costo : lisCosto){
				
				/* Si la clasificacion financiera no es la misma que la del alumno */
				if(!aca.alumno.AlumPersonal.getClasFinId(conElias, codigoAlumno).equals(costo.getClasFinId())){
					continue;
				}
				
				/* Grabar solo los costos seleccionados */
				if (request.getParameter("COSTO-"+costo.getCostoId())!=null){					
					
					// Importe total del costo
					BigDecimal importe = new BigDecimal(costo.getImporte());
					
					// Becas del alumno en esta cuenta (pueden ser de varias entidades)
					Beca objBeca = new Beca(aca.beca.BecAlumnoLista.getBecasAlumno(conElias, cicloId, periodoId, codigoAlumno, costo.getCuentaId(), ""), importe);
					BigDecimal importeBeca 		= objBeca.importeBeca;
					BigDecimal becaPorcentaje 	= objBeca.becaPorcentaje;
					BigDecimal becaCantidad 	= objBeca.becaCantidad;					
					
					
					// Busca el porcentaje inicial de la cuenta				
					BigDecimal porcentajePagoInicial = new BigDecimal("0");
					if (mapCuenta.containsKey(costo.getCuentaId())){
						porcentajePagoInicial = new BigDecimal(mapCuenta.get(costo.getCuentaId()).getPagoInicial());
					}
					
					// Calcula el importe inicial de la cuenta por pagos
					BigDecimal importeInicialPagos = PIpagos(importe, importeBeca, porcentajePagoInicial);
					
					FinCalculoDet.setCicloId(cicloId);
					FinCalculoDet.setPeriodoId(periodoId);
					FinCalculoDet.setCodigoId(codigoAlumno);
					FinCalculoDet.setCuentaId(costo.getCuentaId());					
					FinCalculoDet.setFecha(aca.util.Fecha.getHoy());
					FinCalculoDet.setImporte(importe+"");
					FinCalculoDet.setBecaPorcentaje(becaPorcentaje+"");
					FinCalculoDet.setBecaCantidad(becaCantidad+"");
					FinCalculoDet.setImporteBeca(importeBeca+"");
					FinCalculoDet.setPagoInicialPorcentaje(porcentajePagoInicial+"");
					FinCalculoDet.setImporteInicial(importeInicialPagos+"");
					
					if (FinCalculoDet.insertReg(conElias)){
												
					}else{
						error = true; break;
					}
				}
			}
			if (error == false){
				conElias.commit();
				msj = "Guardado";
				
				/* CAMBIAR ESTADO CALCULO DE COBRO */
				aca.fin.FinCalculo.updateInscrito(conElias, cicloId, periodoId, codigoAlumno, "N");
				
				/* ACTUALIZAR LOS COSTOS YA ASIGNADOS AL ALUMNO */	
				lisCosto 			= FinCostoL.getListPlanCostosAlumno(conElias, cicloId, periodoId, planId, codigoAlumno, "ORDER BY PLAN_ID, CUENTA_ID, CLASFIN_ID");
				
				/* ACTUALIZAR LOS DETALLES DEL CALCULO DE COBRO*/
				lisDetalles	= DetalleL.getListCalDet(conElias, cicloId, periodoId, codigoAlumno,"ORDER BY CUENTA_ID");
			}else{
				conElias.rollback();
				msj = "NoGuardo";
			}
		}
		conElias.setAutoCommit(true);
	}
	
	/* ========== QUITA COSTOS AL ALUMNO ========== */
	if (accion.equals("3")){
		
		conElias.setAutoCommit(false);
		boolean error	= false;		
		
		FinCalculoDet.setCicloId(cicloId);
		FinCalculoDet.setPeriodoId(periodoId);
		FinCalculoDet.setCodigoId(codigoAlumno);
		FinCalculoDet.setCuentaId(request.getParameter("CuentaId"));
		
		if (FinCalculoDet.existeReg(conElias)){
			if(FinCalculoDet.deleteReg(conElias)){
				
			}else{
				error = true;
			}								
		}
		if (error == false){
			aca.fin.FinCalculo.updateInscrito(conElias, cicloId, periodoId, codigoAlumno, "N");			
			if (aca.fin.FinCalculoDet.getNumDetalles(conElias, cicloId, periodoId, codigoAlumno)==0){
				FinCalculo.setCicloId(cicloId);
				FinCalculo.setPeriodoId(periodoId);
				FinCalculo.setCodigoId(codigoAlumno);
				if (FinCalculo.existeReg(conElias)){
					if (FinCalculo.deleteReg(conElias)){
												
					}else{
						error = true;						
					}
				}
			}
		}
		
		
		if(error == false){
			conElias.commit();
			msj = "Guardado";
			
			/* ACTUALIZAR LOS DETALLES DEL CALCULO DE COBRO*/
			lisDetalles	= DetalleL.getListCalDet(conElias, cicloId, periodoId, codigoAlumno,"ORDER BY CUENTA_ID");
			
			/* ACTUALIZAR LOS COSTOS */	
			lisCosto 			= FinCostoL.getListPlanCostosAlumno(conElias, cicloId, periodoId, planId, codigoAlumno, "ORDER BY PLAN_ID, CUENTA_ID, CLASFIN_ID");
		}else{
			conElias.rollback();
			msj = "NoGuardo";
		}
		
		conElias.setAutoCommit(true);
	}

	/* ========== CORRER CALCULO DE COBRO ========== */
	if (accion.equals("4") || accion.equals("5")){
		
		String importe 								= request.getParameter("Importe")==null?"0":request.getParameter("Importe");
		String pagoInicial 							= tipoPago.equals("P") ? inicialPagos : inicialContado;
		BigDecimal numeroPagos 						= new BigDecimal("0");
		
		if (tipoPago.equals("P")){
			for (aca.fin.FinPago pago : lisPagos){
				if( request.getParameter("fechaCobro"+pago.getPagoId()) != null ){
					numeroPagos = numeroPagos.add(new BigDecimal("1")); /* numeroPagos++ */
				}
			}
		}		
		
		/* EMPEZAR CALCULO DE COBRO */
		conElias.setAutoCommit(false);
		boolean error = false;
				
		FinCalculo.setCicloId(cicloId);
		FinCalculo.setPeriodoId(periodoId);
		FinCalculo.setCodigoId(codigoAlumno);
		
		if (FinCalculo.existeReg(conElias)){			
			
			FinCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
			FinCalculo.setInscrito("C");
			FinCalculo.setImporte(importe);
			FinCalculo.setTipoPago(tipoPago);
			FinCalculo.setClasFinId(clasFin);
			FinCalculo.setNumPagos(numeroPagos+"");
			FinCalculo.setPagoInicial(pagoInicial);
			FinCalculo.setFecha(fecha);
			
			if (FinCalculo.updateReg(conElias)){				
				
				// Borra los pagos que tenga el alumno en la tabla Fin_Calculo_Pagos
				aca.fin.FinCalculoPago.deletePagosAlumno(conElias, cicloId, periodoId, codigoAlumno);
				
				if (aca.fin.FinCalculoPago.numPagosAlumno(conElias, cicloId, periodoId, codigoAlumno) != 0){
					error = true;
				}		
				
				// Grabar el pago inicial de contado o en pagos
				FinPago.mapeaRegInicial(conElias, cicloId, periodoId);
				for(aca.fin.FinCalculoDet detalleInicial : lisDetalles){
					FinCalculoPago.setCicloId(cicloId);
					FinCalculoPago.setPeriodoId(periodoId);					
					FinCalculoPago.setCodigoId(codigoAlumno);
					FinCalculoPago.setPagoId(FinPago.getPagoId());
					FinCalculoPago.setCuentaId(detalleInicial.getCuentaId());					
					FinCalculoPago.setFecha(FinPago.getFecha());
					FinCalculoPago.setImporte( detalleInicial.getImporteInicial() );
					if (tipoPago.equals("C")){
						FinCalculoPago.setBeca( detalleInicial.getImporteBeca() );
					}else{
						FinCalculoPago.setBeca( "0" );
					}
									
					FinCalculoPago.setEstado("A");
					FinCalculoPago.setPagado("N");
					if (FinCalculoPago.insertReg(conElias)){
						
					}else{
						error = true;
					}
				}
				
				
				// ======> DE CONTADO
						
				if (tipoPago.equals("C")){
					
					// Modifica el pago inicial y el importe de las cuentas
					if (aca.fin.FinCalculoDet.updateContado(conElias, cicloId, periodoId, codigoAlumno)){
											
					}else{
						error = true;						
					}
					
				// ======> POR PAGARES	
				}else{					
					
					for(aca.fin.FinCalculoDet det : lisDetalles){
						
						BigDecimal ImporteDetalle 		= new BigDecimal(det.getImporte());
						BigDecimal ImporteDetalleBeca 	= new BigDecimal(det.getImporteBeca());
						BigDecimal importeInicialPagos  = new BigDecimal("0");
						
						/* MODIFICA EL PAGO INICIAL */
						
							// Busca el porcentaje inicial de la cuenta				
							BigDecimal porcentajePagoInicial = new BigDecimal("0");
							if (mapCuenta.containsKey(det.getCuentaId())){
								porcentajePagoInicial = new BigDecimal(mapCuenta.get(det.getCuentaId()).getPagoInicial());
							}
							
							// Calcula el importe inicial de la cuenta por pagos
							importeInicialPagos = PIpagos(ImporteDetalle, ImporteDetalleBeca, porcentajePagoInicial);	
							
							// Actualiza el detalle
							det.setPagoInicialPorcentaje(porcentajePagoInicial+"");
							det.setImporteInicial(importeInicialPagos+"");
							if(det.updatePago(conElias)){
								
							}else{
								error = true;
							}
							
						/* CALCULA Y GUARDA LOS PAGOS */
							
							String ultimoPago 									= "";
							
							BigDecimal ImporteDeTodosLosPagosDetalle			= ImporteDetalle.subtract(importeInicialPagos); /* importe - pagoInicial */
							BigDecimal ImporteDeUnPagoDetalle					= new BigDecimal("0");
							BigDecimal ImporteExtraParaBalancearPagosDetalle 	= new BigDecimal("0");
							
							BigDecimal BecaDeTodosLosPagosDetalle 				= ImporteDetalleBeca;
							BigDecimal BecaDeUnPagoDetalle						= new BigDecimal("0");
							BigDecimal BecaExtraParaBalancearPagosDetalle 		= new BigDecimal("0");
							
							
							/* Calcular numero de pagos */
							for (aca.fin.FinPago pago : lisPagos){
								if( request.getParameter("fechaCobro"+pago.getPagoId()) != null ){
									ultimoPago = pago.getPagoId();
								}
							}
							
							ImporteDeUnPagoDetalle 	= ImporteDeTodosLosPagosDetalle.divide(numeroPagos, 2, RoundingMode.DOWN); /*  ImporteDeTodosLosPagosDetalle/numeroPagos */
							BecaDeUnPagoDetalle 	= BecaDeTodosLosPagosDetalle.divide(numeroPagos, 2, RoundingMode.DOWN); /*  BecaDeTodosLosPagosDetalle/numeroPagos */
							
							/* calcular los decimales extra para agregarselos al ultimo pago (para que de justo) */
							ImporteExtraParaBalancearPagosDetalle 	= ImporteDeTodosLosPagosDetalle.subtract( (ImporteDeUnPagoDetalle.multiply(numeroPagos)) ); /* ImporteDeTodosLosPagosDetalle - (ImporteDeUnPagoDetalle * numeroPagos) */
							BecaExtraParaBalancearPagosDetalle 		= BecaDeTodosLosPagosDetalle.subtract( (BecaDeUnPagoDetalle.multiply(numeroPagos)) ); /* BecaDeTodosLosPagosDetalle - (BecaDeUnPagoDetalle * numeroPagos) */
							
							
							if (error == false){
								
								if (aca.fin.FinCalculoPago.numPagosAlumnoCuenta(conElias, cicloId, periodoId, codigoAlumno, det.getCuentaId()) == 0){
									
									for (aca.fin.FinPago pago : lisPagos){
										
										if( request.getParameter("fechaCobro"+pago.getPagoId()) == null ){
											continue;
										}
										
										BigDecimal importeExtra = new BigDecimal("0");
										BigDecimal becaExtra 	= new BigDecimal("0");
										if(pago.getPagoId().equals(ultimoPago)){
											importeExtra 	= ImporteExtraParaBalancearPagosDetalle;
											becaExtra		= BecaExtraParaBalancearPagosDetalle;
										}
										
										FinCalculoPago.setCicloId(cicloId);
										FinCalculoPago.setPeriodoId(periodoId);
										FinCalculoPago.setCodigoId(codigoAlumno);
										FinCalculoPago.setPagoId(pago.getPagoId());
										FinCalculoPago.setImporte( ImporteDeUnPagoDetalle.add(importeExtra)+"" ); /* al ultimo pago le agregamos los decimales sobrantes para que cuadre perfectamente la division de pagos */
										FinCalculoPago.setFecha(pago.getFecha());
										FinCalculoPago.setEstado("A");
										FinCalculoPago.setBeca( BecaDeUnPagoDetalle.add(becaExtra)+"" ); /* al ultimo pago le agregamos los decimales sobrantes para que cuadre perfectamente la division de pagos */
										FinCalculoPago.setCuentaId(det.getCuentaId());
										FinCalculoPago.setPagado("N");
										
										if (FinCalculoPago.insertReg(conElias)){
											
										}else{
											error = true; break;
										}
									}
									
								}else{
									error = true;
								}			
							}else{
								error = true;
							}	
						
					}//End for detalle					
						
				
				}				
			}else{
				error = true;
			}
		}
		
		if(error == false){
			conElias.commit();
			msj = "Guardado";
		}else{
			conElias.rollback();
			msj = "NoGuardo";
		}
		
		conElias.setAutoCommit(true);
		
		/* Refrescar datos */
		pagosAlumno = FinCalculoPagoL.getListPagosAlumno(conElias, cicloId, periodoId, codigoAlumno, " ORDER BY TO_CHAR(FECHA,'YYYY')||TO_CHAR(FECHA,'MM')||TO_CHAR(FECHA,'DD')");
	}
	
	/* ========== CERRAR CALCULO DE COBRO ========== */
	if (accion.equals("5")){
		FinCalculo.setCicloId(cicloId);
		FinCalculo.setPeriodoId(periodoId);
		FinCalculo.setCodigoId(codigoAlumno);
		if (FinCalculo.existeReg(conElias)){			
			FinCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
			FinCalculo.setInscrito("G");
			if (FinCalculo.updateReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}	
	}
	
	/* ========== ABRIR CALCULO DE COBRO ========== */
	if (accion.equals("6")){
		FinCalculo.setCicloId(cicloId);
		FinCalculo.setPeriodoId(periodoId);
		FinCalculo.setCodigoId(codigoAlumno);
		if (FinCalculo.existeReg(conElias)){			
			FinCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
			FinCalculo.setInscrito("C");
			if (FinCalculo.updateReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}	
	}	
		
	
	pageContext.setAttribute("resultado", msj);
	
	
	// Actualiza FinCalculo
	FinCalculo.setCicloId(cicloId);
	FinCalculo.setPeriodoId(periodoId);
	FinCalculo.setCodigoId(codigoAlumno);
	if (FinCalculo.existeReg(conElias)){
		FinCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);
	} 
	
%>
<div id="content">	

<%if(!Alumno.existeReg(conElias, codigoAlumno)){ %>
	<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
	</div>
<%}else{ %>
	
	<h2><fmt:message key="aca.CalculoDeCobro" /> <small><%=codigoAlumno%> | <%=nombreAlumno%></small></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<form id="forma" name="forma" action="calculo.jsp" method="post">	
		<input type="hidden" name="Accion">
	
		<div class="well">
			<fmt:message key="aca.Ciclo" />:&nbsp;
			<select name="Ciclo" id="Ciclo" onchange="javascript:cambiaCiclo()" class="input-xlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
				<%} %>
			</select>
			&nbsp;&nbsp;<fmt:message key="aca.Periodo" />:&nbsp;
			<select name="PeriodoId" id="PeriodoId" onchange="javascript:cambiaPeriodo()">
				<%for(aca.ciclo.CicloPeriodo periodo : lisPeriodo){%>
					<option value="<%=periodo.getPeriodoId() %>" <%if(periodo.getPeriodoId().equals(periodoId)){out.print("selected");} %>><%=periodo.getPeriodoNombre() %></option>
				<%}%>
			</select>			
			&nbsp;&nbsp;<fmt:message key="aca.Fecha" />:&nbsp; 
			<input name="Fecha" class="input-medium" type="text" id="Fecha" value="<%=fecha%>" style="margin:0;">
		</div>
		
		<div class="alert alert-info">
			<fmt:message key="aca.Plan" />: [<strong><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></strong>] &nbsp;
			<fmt:message key="aca.Grado" />: [<strong><%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(grado))%> "<%=grupo%>"</strong>] &nbsp; 
			<fmt:message key="aca.ClasificacionFin" />: [<strong><%=aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, clasFin)  %></strong>] &nbsp;
			<fmt:message key="aca.Saldo" />: [<strong><%=formato.format(aca.fin.FinMovimiento.saldoAlumno(conElias, codigoAlumno, aca.util.Fecha.getHoy()))%></strong>] &nbsp;
		</div>
				
	<div class="row">
		<div class="span6">	
		
			<div class="alert">
				<h4><fmt:message key="aca.CostoDisponibles" /></h4>
			</div>	
		
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){%>
							<th rowspan="2">&nbsp;</th>
						<%} %>
						<th rowspan="2"><fmt:message key="aca.Cuenta" /></th>
						<th class="text-right" rowspan="2"><fmt:message key="aca.Costo" /></th>
						<th colspan="3" class="text-center alert"><fmt:message key="aca.BecaDescuentoAlumno" /></th>
						<th class="text-right" rowspan="2"><fmt:message key="aca.Total" /></th>
					</tr>
					<tr>
						<th class="text-right"><fmt:message key="aca.Porcentaje" /></th>
						<th class="text-right"><fmt:message key="aca.Cantidad" /></th>
						<th class="text-right"><fmt:message key="aca.BecaTotal" /></th>
					</tr>
				</thead>
				<%
					for(aca.fin.FinCosto costo : lisCosto){
						if(!aca.alumno.AlumPersonal.getClasFinId(conElias, codigoAlumno).equals(costo.getClasFinId()))continue;
				
						// Busca el nombre de la cuenta
						String nombreCuenta = costo.getCuentaId();
						if (mapCuenta.containsKey(costo.getCuentaId())){					 
							nombreCuenta = mapCuenta.get(costo.getCuentaId()).getCuentaNombre();			
						}
						
						// Importe total del costo
						BigDecimal importeTotal = new BigDecimal(costo.getImporte());
						
						// Becas del alumno en esta cuenta (pueden ser de varias entidades)
						Beca objBeca = new Beca(aca.beca.BecAlumnoLista.getBecasAlumno(conElias, cicloId, periodoId, codigoAlumno, costo.getCuentaId(), ""), importeTotal);
						BigDecimal importeBeca 		= objBeca.importeBeca;
						BigDecimal becaPorcentaje 	= objBeca.becaPorcentaje;
						BigDecimal becaCantidad 	= objBeca.becaCantidad;
				%>
						<tr>
							<%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){ %>
								<td>
									<input type="Checkbox" id="COSTO-<%=costo.getCostoId()%>" name="COSTO-<%=costo.getCostoId()%>" value="S" />
								</td>
							<%} %>
							<td><%=nombreCuenta%></td>
							<td class="text-right"><%=formato.format(importeTotal)%></td>
							<td class="text-right"><%=becaPorcentaje%>%</td>
							<td class="text-right"><%=formato.format(becaCantidad)%></td>
							<td class="text-right"><%=formato.format(importeBeca)%></td>
							<td class="text-right"><%=formato.format(importeTotal.subtract(importeBeca))%></td>
						</tr>
				<%				
					}
				%>	
			</table>
			
			<%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){%>	
				<div class="well">
					<a class="btn btn-primary" href="javascript:Grabar();"><fmt:message key="boton.Aplicar" /> <i class="icon-arrow-right icon-white"></i></a>&nbsp;&nbsp;
					<select id="TipoPago" name="TipoPago" class="TipoPago input-medium" onclick="javascript:muestraPago()">
						<option value="C" <%if (tipoPago.equals("C")) out.print("Selected");%>><fmt:message key="aca.DeContado" /></option>
						<option value="P" <%if (tipoPago.equals("P")) out.print("Selected");%>><fmt:message key="aca.PorPagos" /></option>
					</select>
					&nbsp;&nbsp;
				<%if(FinCalculo.getInscrito().equals("N") || FinCalculo.getInscrito().equals("C")){%>			
					<a href="javascript:Calcular()" class="btn btn-primary"><i class="icon-refresh icon-white"></i> <fmt:message key="aca.CalcularCobro" /></a>
					<%if (FinCalculo.getInscrito().equals("C")){%>
					<a href="javascript:CerrarCalculo()" class="btn btn-success"><i class="icon-ok icon-white"></i> <fmt:message key="aca.CerrarCobro" /></a>
					<%}%>
					
				<%}else if (FinCalculo.getInscrito().equals("G") || FinCalculo.getInscrito().equals("P")){%>	   	
			   	
			   		<a class="btn btn-info" href="javascript:Formato('<%=periodoId%>')"><i class="icon-print icon-white"></i> <fmt:message key="boton.Imprimir" /></a>
			   	
					<%if ( (esContable||esAdmin) && (!FinCalculo.getInscrito().equals("")) && FinCalculo.getInscrito().equals("P")==false){%>
					<a class="btn btn-primary" href="javascript:AbrirCalculo()"><i class="icon-eye-open icon-white"></i> <fmt:message key="boton.Abrir" /></a>
					<%}%>				    	
				<%}%>
				</div>
			<%} %>
			
		</div>		
		<div class="span7">
		
			<div class="alert alert-success">
				<h4><fmt:message key="aca.CostoAplicados" /></h4>
			</div>
		
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){%>
							<th rowspan="2" ><fmt:message key="aca.Accion" /></th>					
						<%} %>
						<th><fmt:message key="aca.Cuenta" /></th>
						<th class="text-right"><fmt:message key="aca.Costo" /></th>
						<th class="text-right"><fmt:message key="aca.Beca" /></th>
						<th class="text-right"><fmt:message key="aca.Total" /></th>
						<th class="text-right"><fmt:message key="aca.PagoInicial" /></th>
						<th class="text-right"><fmt:message key="aca.PorPagos" /></th>
					</tr>
				</thead>
			 
				<%
				 	
				 	BigDecimal totalImporte 		= new BigDecimal("0");
				 	BigDecimal totalImporteBeca 	= new BigDecimal("0");
				 	BigDecimal totalImporteTotal 	= new BigDecimal("0");
				 	BigDecimal totalPagoInicial		= new BigDecimal("0");
				 	BigDecimal totalEnPagos			= new BigDecimal("0");
				 
					for(aca.fin.FinCalculoDet detalle : lisDetalles){
						
						// Busca el nombre de la cuenta y el porcentaje de pago inicial
						String nombreCuenta 				= detalle.getCuentaId();
						BigDecimal porcentajePagoInicial 	= new BigDecimal("0");
						if (mapCuenta.containsKey(detalle.getCuentaId())){					 
							nombreCuenta 			= mapCuenta.get(detalle.getCuentaId()).getCuentaNombre();
							porcentajePagoInicial 	= new BigDecimal(mapCuenta.get(detalle.getCuentaId()).getPagoInicial());
						}
						
						BigDecimal importe 		= new BigDecimal(detalle.getImporte());
						BigDecimal importeBeca 	= new BigDecimal(detalle.getImporteBeca());
						BigDecimal importeTotal = importe.subtract(importeBeca);
						
						BigDecimal pagoInicial  = new BigDecimal("0");						
						if (FinCalculo.getTipoPago().equals("P"))
							pagoInicial	= PIpagos(importe, importeBeca, porcentajePagoInicial);
						else
							pagoInicial	= importeTotal;
						
						BigDecimal enPagos 		= importeTotal.subtract(pagoInicial);
						
						totalImporte 		= totalImporte.add(importe);
						totalImporteBeca 	= totalImporteBeca.add(importeBeca);
						totalImporteTotal 	= totalImporteTotal.add(importeTotal);
						totalPagoInicial 	= totalPagoInicial.add(pagoInicial);
						totalEnPagos 		= totalEnPagos.add(enPagos);								 
				%>
						<tr>
							<%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){%>
								<td>
							  		<a href="calculo.jsp?cicloId=<%=cicloId%>&PeriodoId=<%=periodoId%>&CuentaId=<%=detalle.getCuentaId()%>&Accion=3"><i class="icon-remove icon-black"></i></a>
								</td>
							<%} %>
							<td><%=nombreCuenta%></td>
							<td class="text-right"><%=formato.format(importe) %></td>
							<td class="text-right"><%=formato.format(importeBeca) %></td>
							<td class="text-right"><%=formato.format(importeTotal) %></td>
							<td class="text-right"><%=formato.format(pagoInicial) %></td>
							<td class="text-right"><%=formato.format(enPagos) %></td>
						</tr>
				<%				
					}
				%>	
				<tr>
					<th <%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){%>colspan="2"<%} %>>
						<fmt:message key="aca.Total"/>
					</th>
					<th class="text-right"><%=formato.format(totalImporte) %></th>
					<th class="text-right"><%=formato.format(totalImporteBeca) %></th>
					<th class="text-right"><%=formato.format(totalImporteTotal) %></th>
					<th class="text-right"><%=formato.format(totalPagoInicial) %></th>
					<th class="text-right"><%=formato.format(totalEnPagos) %></th>
				</tr>
			</table>
		</div>
	</div>
	
	<%if ( FinCalculo.getInscrito().equals("C") || FinCalculo.getInscrito().equals("G") ){%>		
	
	<%}%>
	<%if(!lisDetalles.isEmpty()){ %>
	
		<div class="well">
			
			<%if(FinCalculo.getInscrito().equals("N")||FinCalculo.getInscrito().equals("C")){%>			
			
				<span class="numPagos">
					
					<a href="#myModal" data-toggle="modal" class="btn btn-info"><i class="icon-calendar icon-white"></i> </a>
					
					<!-- Modal -->
					<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					  <div class="modal-header">
					    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="position:static;">x</button>
					    <h3 id="myModalLabel"><fmt:message key="aca.FechasPagos" /></h3>
					    <!--
					    <a onclick="javascript:Todos();" class="btn btn-mini">Todos</a>&nbsp;
					    <a onclick="javascript:Ninguno();" class="btn btn-mini">Ninguno</a>&nbsp;
					    -->			    					    
					  </div>
					  <div class="modal-body">
				    	<%for(aca.fin.FinPago pago : lisPagos){ %>
				    		<%
				    			String checked = "";
				    			for(aca.fin.FinCalculoPago p : pagosAlumno){
				    				if(pago.getPagoId().equals(p.getPagoId())){
				    					checked = "checked=true";
				    				}
				    			}
				    			
				    			if(pagosAlumno.size()==0){
				    				checked = "checked='checked' ";
				    			}
				    			
				    		%>
				    		
			    			<div style="margin-bottom:7px;">
			    				<input class="checkbox-pagos" type="checkbox" name="fechaCobro<%=pago.getPagoId() %>" value="<%=pago.getPagoId() %>" style="margin-top:-3px;">
			    				<%=pago.getFecha() %> - <%=pago.getTipo().equals("I")?"Inicial":"Ordinario"%> 
			    			</div>
				    	<%} %>
					  </div>
					  <div class="modal-footer text-left">
					    <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></button>
					  </div>
					</div>
									
				</span>
				
				<hr />
				
			<%}%>
			
			<input name="InicialPagos" type="hidden" id="InicialPagos" value="<%=totalPagoInicial%>">
			<input name="InicialContado" type="hidden" id="InicialContado" value="<%=totalPagoInicial%>">
			<input name="Importe" type="hidden" id="Importe" value="<%=totalImporteTotal%>">		
			
		</div>
	
	<%} %>
	
</form>

<%}%>

</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
	$('.fechaCobro').datepicker();
</script>
<script>	
	function muestraPago(){
		var valor = $('select#TipoPago').val();
		if(valor=="P"){
			$(".numPagos").show();
		}else{
			$(".numPagos").hide();
		}
	}
	$('select#TipoPago').on('change',function(){
		muestraPago();
	});
	muestraPago();
</script>
<%@ include file= "../../cierra_elias.jsp" %>