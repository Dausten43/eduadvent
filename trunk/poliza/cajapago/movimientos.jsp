<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="AlumPersonalLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="AlumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="FinCuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="FinMov" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinFolio" scope="page" class="aca.fin.FinFolio"/>
<jsp:useBean id="FinPagoLista" scope="page" class="aca.fin.FinCalculoPagoLista"/>
<jsp:useBean id="empleadoU" scope="page" class="aca.empleado.EmpPersonalLista"/>

<script>

	function EnviarPago(fechaPago){
		document.forma.Accion.value = "4";
		document.forma.FechaPago.value = fechaPago;
		document.forma.submit();
	}
	
	function Eliminar(movimientoId){		
		if(confirm(' <fmt:message key='js.Confirma' /> ')){
			document.forma.Accion.value = "2";
			document.forma.MovimientoId.value = movimientoId;
			document.forma.submit();
		}
	}
	
	function Refrescar(opcion){
		document.forma.Accion.value = "3";
		if (opcion=="Padre")
			document.forma.Auxiliar.value = "0";
		document.forma.submit();
	}
	
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("###,##0.00;(##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String) session.getAttribute("ejercicioId");
	String usuario 		= (String) session.getAttribute("codigoId"); 
	String salto		= "X";
	
	String padreCaja 	= request.getParameter("Padre")==null?"0":request.getParameter("Padre");
	String alumnoCaja 	= request.getParameter("Auxiliar")==null?"0":request.getParameter("Auxiliar");
	String fechaPago 	= request.getParameter("FechaPago")==null?"0":request.getParameter("FechaPago");
	
	/* INFORMACION DEL RECIBO */
	FinFolio.mapeaRegId(conElias, ejercicioId, usuario);
	
	boolean reciboDisponible = false;
	FinFolio.setEjercicioId(ejercicioId);
	FinFolio.setUsuario(usuario);
	if( FinFolio.existeReg(conElias) && 
		Float.parseFloat(FinFolio.getReciboActual()) >= Float.parseFloat(FinFolio.getReciboInicial()) && 
		Float.parseFloat(FinFolio.getReciboActual()) <= Float.parseFloat(FinFolio.getReciboFinal()) ){
		reciboDisponible = true;
	}
	
	/* INFORMACION DE LA POLIZA */
	
	if(request.getParameter("polizaId") != null){
		session.setAttribute("polizaId", request.getParameter("polizaId"));
	}
	
	String polizaId 	= (String) session.getAttribute("polizaId");
	
	if( polizaId == null ){
		salto = "caja.jsp";
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	String movimientoId = request.getParameter("MovimientoId")==null?"":request.getParameter("MovimientoId");
	
	/* ACCIONES */
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	
	// Guardar
	if( accion.equals("1") ){
		if(movimientoId.equals("") || movimientoId.equals("0")){
			movimientoId = FinMov.maxReg(conElias, ejercicioId, polizaId);
		}
		
		FinMov.setEjercicioId(ejercicioId);
		FinMov.setPolizaId(polizaId);
		FinMov.setMovimientoId(movimientoId);
		FinMov.setCuentaId(request.getParameter("CuentaId"));
		FinMov.setAuxiliar(request.getParameter("Auxiliar"));
		FinMov.setDescripcion(request.getParameter("Descripcion"));
		FinMov.setImporte(request.getParameter("Importe"));
		FinMov.setNaturaleza("C"); /* Cargo */
		FinMov.setReferencia(request.getParameter("Referencia"));
		FinMov.setEstado("A"); /* Abierto o Creado */
		FinMov.setFecha(aca.util.Fecha.getDateTime());
		FinMov.setReciboId(FinFolio.getReciboActual());
		FinMov.setCicloId("00000000");
		FinMov.setPeriodoId("0");
		FinMov.setTipoMovId("5");
		
		if(FinMov.existeReg(conElias)){
			if(FinMov.updateReg(conElias)){
				msj = "Modificado";
			}else{
				msj = "NoModifico";
			}
		}else{
			if(FinMov.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";	
			}
		}
		
		FinMov = new aca.fin.FinMovimientos();
		movimientoId = "0";
		
	}else if( accion.equals("2") ){//Eliminar
		conElias.setAutoCommit(false);
		FinMov.setEjercicioId(ejercicioId);
		FinMov.setPolizaId(polizaId);
		FinMov.setMovimientoId(movimientoId);
		 
		if(FinMov.existeReg(conElias)){
			FinMov.mapeaRegId(conElias, ejercicioId, polizaId, movimientoId);
			String [] fechaPag = FinMov.getReferencia().split(",");
			//System.out.println("Datos:"+fechaPag[0]+":"+FinMov.getCuentaId());
			if(FinMov.deleteReg(conElias)){				 
				if (aca.fin.FinCalculoPago.updatePagado(conElias, FinMov.getAuxiliar(), fechaPag[0], FinMov.getCuentaId(), "N")){
					conElias.commit();
					msj = "Eliminado";
				}else{
					msj = "NoElimino";
					conElias.rollback();					
				}
			}else{
				msj = "NoElimino";				
			}
		}
		
		conElias.setAutoCommit(true);
		FinMov = new aca.fin.FinMovimientos();
		movimientoId = "0";
	}
	
	pageContext.setAttribute("resultado", msj);
	
	/* PADRES */
	ArrayList<aca.empleado.EmpPersonal> lisPadres		= empleadoU.getListEscuela(conElias, escuelaId," AND SUBSTR(CODIGO_ID,4,1)='P' AND (SELECT COUNT(*) FROM ALUM_PADRES WHERE CODIGO_PADRE= EMP_PERSONAL.CODIGO_ID OR CODIGO_MADRE = EMP_PERSONAL.CODIGO_ID OR CODIGO_TUTOR = EMP_PERSONAL.CODIGO_ID) > 0 ORDER BY SUBSTR(CODIGO_ID,1,3),APATERNO,AMATERNO,NOMBRE");
	
	/* ALUMNOS */
	ArrayList<aca.alumno.AlumPersonal> lisAlumnos		= AlumPersonalLista.getListAllNombres(conElias, escuelaId, "");
	
	/* LISTA DE HIJOS DE UN PADRE*/
	ArrayList<aca.alumno.AlumPadres> lisHijos 			= AlumPadresLista.getListTutor(conElias, padreCaja, "ORDER BY 1");
	
	/* CUENTAS */
	ArrayList<aca.fin.FinCuenta> lisCuentas 			= FinCuentaLista.getListCuentas(conElias, escuelaId, " ORDER BY CUENTA_ID");
	
	/* LISTA DETALLADA DE PAGOS PENDIENTES DEL ALUMNO*/
	ArrayList<aca.fin.FinCalculoPago> lisPagos 			= FinPagoLista.lisPagos(conElias, alumnoCaja, "'N'","'A'","ORDER BY TO_CHAR(FECHA,'YYYY/MM/DD')");
	
	/* LISTA DE FECHAS DE PAGO (DISTINCT FECHAS) */
	ArrayList<String> lisFechas 						= FinPagoLista.lisFechasPagos(conElias, alumnoCaja,"'N'","'A'");
	
	/* MOVIMIENTOS DEL RECIBO ACTUAL */
	ArrayList<aca.fin.FinMovimientos> lisMovimientos 	= FinMovLista.getMovimientos(conElias, ejercicioId, polizaId, FinFolio.getReciboActual() , "");
	
	/* MAP DE IMPORTE DE CADA PAGO DEL ALUMNO (TOTAL DE IMPORTE-BECA POR PAGO)*/
	java.util.HashMap<String,String> mapaPago 			= FinPagoLista.mapPagoFecha(conElias, alumnoCaja,"'N'");
	
	if(!movimientoId.equals("") && !movimientoId.equals("0")){
		FinMov.mapeaRegId(conElias, ejercicioId, polizaId, movimientoId);
	}
	
	if (accion.equals("4")){
		conElias.setAutoCommit(false);
		for (aca.fin.FinCalculoPago pagos : lisPagos){
			String[] fechaEnPartes = pagos.getFecha().split("/");
			
			/* Si la fecha del pago corresponde*/
			if (fechaPago.equals(fechaEnPartes[2]+"/"+fechaEnPartes[1]+"/"+fechaEnPartes[0])){
				
				float importe = Float.parseFloat(pagos.getImporte())-Float.parseFloat(pagos.getBeca());
				
				movimientoId = FinMov.maxReg(conElias, ejercicioId, polizaId);
				
				// Nombre del alumno
				String nombreAlumno = aca.alumno.AlumPersonal.getNombreCorto(conElias, alumnoCaja, "NOMBRE");
				
				// Nombre del pago
				String nombrePago = aca.fin.FinPago.getDescripcion(conElias, pagos.getCicloId(), pagos.getPeriodoId(), pagos.getPagoId());
			
				FinMov.setEjercicioId(ejercicioId);
				FinMov.setPolizaId(polizaId);
				FinMov.setMovimientoId(movimientoId);
				FinMov.setCuentaId(pagos.getCuentaId());
				FinMov.setAuxiliar(alumnoCaja);
				FinMov.setDescripcion(nombrePago+" - "+aca.fin.FinCuenta.getCuentaNombre(conElias, pagos.getCuentaId())+" - "+alumnoCaja+" - "+nombreAlumno);
				FinMov.setImporte(String.valueOf(importe));
				FinMov.setNaturaleza("C"); /* Cargo */
				FinMov.setReferencia(pagos.getFecha()+","+pagos.getCicloId());
				FinMov.setEstado("A"); /* Abierto o Creado */
				FinMov.setFecha(aca.util.Fecha.getDateTime());
				FinMov.setReciboId(FinFolio.getReciboActual());
				FinMov.setCicloId(pagos.getCicloId());
				FinMov.setPeriodoId(pagos.getPeriodoId());
				FinMov.setTipoMovId("5");
				
				if(FinMov.insertReg(conElias)){
					if (aca.fin.FinCalculoPago.updatePagado(conElias, alumnoCaja, pagos.getFecha(), pagos.getCuentaId(),"S")){
						conElias.commit();
						msj = "Guardado";
					}else{
						conElias.rollback();
						msj = "NoGuardo";
					}					
				}else{
					msj = "NoGuardo";	
				}
				FinMov = new aca.fin.FinMovimientos();
			}
		}
		conElias.setAutoCommit(true);
		// Actualizar la lista movimientos
		lisMovimientos 		= FinMovLista.getMovimientos(conElias, ejercicioId, polizaId, FinFolio.getReciboActual() , "");
		// Actualizar la lista de pagos
		lisPagos 			= FinPagoLista.lisPagos(conElias, alumnoCaja, "'N'","'A'","ORDER BY TO_CHAR(FECHA,'YYYY/MM/DD')");
		// Actualizar la lista de fechas
		lisFechas 			= FinPagoLista.lisFechasPagos(conElias, alumnoCaja,"'N'","'A'");
	}
	
%>

<style>
.modal-body{
   
}
.modal{
   width:70%;
   margin-left: -35%; 
}
@media (max-width: 768px) {
   .modal{
     	width:90%;
        margin-left: 2%; 
   }
}
</style>

<div id="content">
	
	<h2><fmt:message key="aca.Movimiento" /> <small> ( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong> )</small></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<fmt:message key="aca.Poliza" />: <strong>[ <%=polizaId %> | <%=FinPoliza.getDescripcion() %> ]</strong> &nbsp; &nbsp;
		<fmt:message key="aca.ReciboActual" />: <strong>[ <%=FinFolio.getReciboActual().equals("-1")?"-":FinFolio.getReciboActual() %> ]</strong> &nbsp; &nbsp;		
		<fmt:message key="aca.RangoRecibo" />: <strong> [ <%=FinFolio.getReciboInicial() %> - <%=FinFolio.getReciboFinal() %> ]</strong>
	</div>

	<%if(reciboDisponible == false){ %>
		
	<div class="well">
		<a href="caja.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
		
	<div class="alert">
		<fmt:message key="aca.NoRecibosDisponibles" />
	</div>
	
	<%}else if( !FinPoliza.getEstado().equals("A") ){ %>
		
	<div class="well">
		<a href="caja.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
		
	<div class="alert">
		<fmt:message key="aca.PolizaCerrada" />
	</div>
		
	<%}else{ %>
	
	<div class="well">
		<a href="caja.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<%if(lisMovimientos.size()==0){ %>
			<a disabled title="Este recibo aún no tiene movimientos" class="btn btn-success"><i class="icon-list-alt icon-white"></i> <fmt:message key="aca.GuardarRecibo" /></a>
		<%}else{ %>
			<a href="recibo.jsp" class="btn btn-success"><i class="icon-list-alt icon-white"></i> <fmt:message key="aca.GuardarRecibo" /></a>
		<%} %>
	</div>
			
	<div class="row">
		<div class="span5">			
			<form action="" method="post" name="forma">
				<input type="hidden" name="Accion" />
				<input type="hidden" name="MovimientoId" />		
				<input type="hidden" name="FechaPago" />
						
				<div class="alert">
				
					<fieldset>						
						<a href="#myModal2" role="button" data-toggle="modal"><label for="Auxiliar"><fmt:message key="aca.Padres" /> <i class="icon-question-sign"></i></label></a>
						<select name="Padre" id="Padre" style="width:100%;" onchange="javascript:Refrescar('Padre');">			
							<option value="0"><fmt:message key="boton.Todos" /></option>
							<%for(aca.empleado.EmpPersonal padre : lisPadres){%>
								<option value="<%=padre.getCodigoId() %>" <%if(padreCaja.equals(padre.getCodigoId())){out.print("selected");}%>>
									<%=padre.getCodigoId() %> | <%=padre.getNombre()+" "+padre.getApaterno()+" "+padre.getAmaterno() %>
								</option>
							<%}%>
						</select>
					</fieldset>						
					<fieldset>
						<a href="#myModal" role="button" data-toggle="modal"><label for="Auxiliar"><fmt:message key="aca.Alumno" /> <i class="icon-question-sign"></i></label></a>
						<select name="Auxiliar" id="Auxiliar" style="width:100%;" onchange="javascript:Refrescar('Alumno');">
							<option value="0">Elegir</option>
						<% 
							// Muestra todos los alumnos de la escuela
							if (padreCaja.equals("0")){								
								for(aca.alumno.AlumPersonal alum : lisAlumnos){
						%>
							<option value="<%=alum.getCodigoId()%>" <%if(alumnoCaja.equals(alum.getCodigoId())) out.print(" selected"); %>>
								<%=alum.getCodigoId()%> | <%=alum.getNombre()+" "+alum.getApaterno()+" "+alum.getAmaterno() %>
							</option>
						<%		
								}								
							}else{								
								for(aca.alumno.AlumPadres alum : lisHijos){
						%>
							<option value="<%=alum.getCodigoId()%>" <%if(alumnoCaja.equals(alum.getCodigoId())) out.print(" selected"); %>>
								<%=alum.getCodigoId()%> | <%=aca.alumno.AlumPersonal.getNombre(conElias, alum.getCodigoId(), "NOMBRE") %>
							</option>
						<%		
								}								
							}
						%>							
						</select>						
					</fieldset>
					
					<table class="table table-condensed">
					<tr>
						<th>#</th>
						<th>Op.</th>
						<th>Fecha</th>
						<th>Importe</th>
						<th>Enviar</th>
					</tr>
	<%					
					int row = 0;
					for (String fechaPagos: lisFechas){
						row++;
						String[] parteFecha = fechaPagos.split("/");
						String importe = "0";
						if (mapaPago.containsKey(fechaPagos) ){
							importe = mapaPago.get(fechaPagos);
						}
						
						//String pagoId = aca.fin.FinCalculoPago.getPagoDeFecha(conElias, alumnoCaja, fechaPagos);						
	%>
					<tr>
						<td><%= row %></td>
						<td><a href="pagodetalle.jsp?Auxiliar=<%=alumnoCaja%>&Fecha=<%=fechaPagos%>&Padre=<%=padreCaja%>"><i class="icon-list"></i></a></td>
						<td><%= fechaPagos %></td>
						<td><%= importe %></td>
						<td><a class="btn btn-primary btn-small" onclick="javascript:EnviarPago('<%= fechaPagos %>');"><i class="icon-arrow-right icon-white"></i></a></td>
					</tr>
	<%			
					}
					
					// Si no hay cobros registrados
					if (lisFechas.size() == 0){
						out.print("<tr><td colspan='4'>¡No tiene cobros registrados!</td></tr>");
					}
	%>
					</table>
							
				</div>
								
			</form>
					
		</div>
				
		<div class="span9">
			
			<h4><fmt:message key="aca.Movimientos" /> <a href="javascript:tableToExcel('bajarExcel', 'Movimientos')" style="float:right;"><img src="excel.png" height="25" width="25"></a></h4>
			
			<table class="table table-condensed table-bordered table-striped" id="bajarExcel">
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
					for(aca.fin.FinMovimientos mov : lisMovimientos){
						cont++;
						
						float importe = Float.parseFloat(mov.getImporte());
						total+=importe;
				%>
						<tr>
							<td><%=cont %></td>
							<td>
								<a href=" javascript:Eliminar('<%=mov.getMovimientoId() %>'); "><i class="icon-remove"></i></a>								
								<%=aca.alumno.AlumPersonal.getNombre(conElias, mov.getAuxiliar(), "NOMBRE")  %>
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
	</div>
		
	<%} %>	
	 
	<!-- Modal -->
	<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h3 id="myModalLabel"><fmt:message key="aca.Movimientos" /></h3>
	  </div>
	  <div class="modal-body">
	    
	  </div>
	  <div class="modal-footer">
	    <button class="btn" data-dismiss="modal" aria-hidden="true"><fmt:message key="boton.Cerrar" /></button>
	  </div>
	</div>
	
	<!-- Modal 2 -->
	<div id="myModal2" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	    <h3 id="myModalLabel"><fmt:message key="aca.Movimientos" /></h3>
	  </div>
	  <div class="modal-body">
	    
	  </div>
	  <div class="modal-footer">
	    <button class="btn" data-dismiss="modal" aria-hidden="true"><fmt:message key="boton.Cerrar" /></button>
	  </div>
	</div>
	
</div>

<link rel="stylesheet" href="../../js-plugins/chosen/chosen.css" />
<script src="../../js-plugins/chosen/chosen.jquery.js" type="text/javascript"></script>
<script> 
		$("#CuentaId").chosen({width: "100%"}); 
		
		$('#Auxiliar').chosen();
		
		$('#Padre').chosen();
</script>

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Descripcion').maxlength({ 
	    max: 70,
	    showFeedback: false,
	});
	
	var alumno 		= $('#Auxiliar');
	var padre 		= $('#Padre');
	var modalBody	= $('.modal-body');	
	
	$('#myModal').on('show', function () {
		$.get('getMovimientosAlumno.jsp?codigoId='+alumno.val(), function(r){
			modalBody.html($.trim(r));
		});  
	});
	
	$('#myModal2').on('show', function () {
		$.get('getMovimientosPadre.jsp?padre='+padre.val(), function(r){
			modalBody.html($.trim(r));
		});  
	});
/*	
	function cambiarHijos(){
		$('#Auxiliar').html("<option value=''>Cargando...</option>").trigger("liszt:updated");
		
		$.get('getHijos.jsp?padre='+padre.val()+'&alumno='+alumno.val(), function(r){
			$('#Auxiliar').html($.trim(r)).trigger("liszt:updated");
		});
	}
	
	cambiarHijos();
	
	padre.on('change', function(){
		cambiarHijos();
	});
*/	
	
</script>
<script src="../../js-plugins/tableToExcel/tableToExcel.js"></script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>