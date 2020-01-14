<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinFolio" scope="page" class="aca.fin.FinFolio"/>
<jsp:useBean id="FinRecibo" scope="page" class="aca.fin.FinRecibo"/>

<script>
	function Guardar(){
		if( document.forma.Cliente.value 		!= "" && 
			document.forma.Domicilio.value 		!= "" &&
			document.forma.Cheque.value 		!= "" && 
			document.forma.Banco.value 			!= "" &&
			document.forma.Observaciones.value 	!= "" &&
			document.forma.rfc.value 			!= "" 
		){
			
				document.forma.Accion.value = "1";
				document.forma.submit();
			
		}else{
			alert('<fmt:message key="js.Completar" />');	
		}
	}
</script>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frmSimple	= new java.text.DecimalFormat("#####0.00;(#####0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	String salto		= "X";
	
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
	String polizaId 	= (String) session.getAttribute("polizaId");
	
	if( polizaId == null ){
		salto = "caja.jsp";
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);

	/* MOVIMIENTOS DEL RECIBO ACTUAL */
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovLista.getMovimientos(conElias, ejercicioId, polizaId, FinFolio.getReciboActual() , "");
	
	/* ACCIONES */
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	
	if( accion.equals("1") ){//Guardar
	
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		BigDecimal importeTotal  = new BigDecimal("0");
		for(aca.fin.FinMovimientos mov : movimientos){
			importeTotal = importeTotal.add(new BigDecimal(mov.getImporte()));
			
			mov.setEstado("R");
			if(mov.updateEstado(conElias)){
				//ActualizadoD 
			}else{
				error = true;
			}
			
		}
		
		String reciboActual = FinFolio.getReciboActual();
		
		FinRecibo.setReciboId(reciboActual);
		FinRecibo.setEjercicioId(ejercicioId);
		FinRecibo.setImporte(frmSimple.format(importeTotal));
		FinRecibo.setFecha(aca.util.Fecha.getDateTime());
		FinRecibo.setCliente(request.getParameter("Cliente"));
		FinRecibo.setDomicilio(request.getParameter("Domicilio"));
		FinRecibo.setCheque(request.getParameter("Cheque"));
		FinRecibo.setBanco(request.getParameter("Banco"));
		FinRecibo.setObservaciones(request.getParameter("Observaciones"));
		FinRecibo.setUsuario(usuario);
		FinRecibo.setRfc(request.getParameter("rfc"));
		FinRecibo.setTipo("R");
		FinRecibo.setEstado("A");
		
		if(!FinRecibo.existeReg(conElias)){
			if(FinRecibo.insertReg(conElias)){
				
				FinFolio.setEjercicioId(ejercicioId);
				FinFolio.setUsuario(usuario);
				FinFolio.setReciboActual( String.valueOf((Integer.parseInt(reciboActual)+1)));
				if(FinFolio.updateReciboActual(conElias)){
					//Guardado
				}else{
					error = true;
				}
				
			}else{
				error = true;
				msj = "NoGuardo";
			}
		}else{
			error = true;
		}
		
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoGuardo";
		}else{
			conElias.commit();
			salto = "imprimirRecibo.jsp?reciboId="+reciboActual+"&from=movimientos";
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **
		
	}
	
	pageContext.setAttribute("resultado", msj);
	
%>

<div id="content">
	
	<h2><fmt:message key="aca.Recibo" /> <small>( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong> )</small></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">			
		<fmt:message key="aca.Poliza" />: [ <strong><%=polizaId %> | <%=FinPoliza.getDescripcion() %></strong> ] &nbsp;&nbsp;
		<fmt:message key="aca.ReciboActual" />: [ <strong><%=FinFolio.getReciboActual().equals("-1")?"-":FinFolio.getReciboActual() %></strong> ] &nbsp;&nbsp;
		<fmt:message key="aca.RangoRecibo" />: [ <strong><%=FinFolio.getReciboInicial() %> - <%=FinFolio.getReciboFinal() %></strong> ]
	</div>
	
	<%if(reciboDisponible == false){ %>
	
		<div class="well">
			<a href="caja.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
		
		<div class="alert">
			<fmt:message key="aca.NoRecibosDisponibles" />
		</div>
	
	<%}else{ %>
	
	
			<div class="well">
				<a href="movimientos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
			</div>
			
			<div class="row">
				<div class="span5">
					
					<form action="" method="post" name="forma">
						<input type="hidden" name="Accion" />
					
						<div class="alert">
							<fieldset>
								<label for="Cliente"><fmt:message key="aca.Cliente" /></label>
								<input type="text" name="Cliente" id="Cliente" maxlength="100" value="" />
							</fieldset>
							
							<fieldset>
								<label for="Domicilio"><fmt:message key="aca.Domicilio" /></label>
								<input type="text" name="Domicilio" id="Domicilio" maxlength="100" value="" />
							</fieldset>
							
							<fieldset>
								<label for="Cheque"><fmt:message key="aca.Cheque" /></label>
								<input type="text" name="Cheque" id="Cheque" maxlength="20" value="" />
							</fieldset>
							
							<fieldset>
								<label for="Banco"><fmt:message key="aca.Banco" /></label>
								<input type="text" name="Banco" id="Banco" maxlength="20" value="" />
							</fieldset>
							
							<fieldset>
								<label for="Observaciones"><fmt:message key="aca.Observaciones" /></label>
								<textarea name="Observaciones" id="Observaciones" rows="2" cols="20" style="max-width:100%;width: 100%;box-sizing: border-box;"></textarea>
							</fieldset>
							
							<fieldset>
								<label for="rfc"><fmt:message key="aca.rfc" /></label>
								<input type="text" name="rfc" id="rfc" maxlength="12" value="" />
							</fieldset>
						</div>
						
						<div class="well">
							<a href="javascript:Guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
						</div>
						
					</form>
					
				</div>
				
				<div class="span7">
				
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
								<th class="text-right"><fmt:message key="aca.Importe" /></th>
							</tr>
						</thead>
						<%
							float total = 0;
							int cont = 0;
							for(aca.fin.FinMovimientos mov : movimientos){
								cont++;
								
								float importe = Float.parseFloat(mov.getImporte());
								total+=importe;
						%>
								<tr>
									<td><%=cont %></td>
									<td><%=aca.alumno.AlumPersonal.getNombre(conElias, mov.getAuxiliar(), "NOMBRE")  %></td>
									<td><%=mov.getCuentaId() %></td>
									<td><%=mov.getFecha() %></td>
									<td><%=mov.getDescripcion() %></td>
									<td><%=mov.getReferencia() %></td>
									<td class="text-right"><%=getFormato.format( importe ) %></td>
								</tr>
						<%
							}
						%>
						<tr>
							<th colspan="6"><fmt:message key="aca.Total" /></th>
							<th class="text-right"><%=getFormato.format( total ) %></th>
						</tr>
					</table>	
						
				</div>
			</div>
	
	
	<%} %>
	

</div>

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Observaciones').maxlength({ 
	    max: 500,
	    showFeedback: false,
	});
	
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>