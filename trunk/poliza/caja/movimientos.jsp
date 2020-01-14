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
<jsp:useBean id="FinFolio" scope="page" class="aca.fin.FinFolio"/>
<jsp:useBean id="empleadoU" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>

<script>
	function Guardar( movimiento ){
		if( document.forma.Importe.value != "" && document.forma.Descripcion.value != "" && document.forma.Auxiliar.value ){
			
			var importe = $('#Importe').val();
			
			if(!isNaN(parseFloat(importe)) && parseFloat(importe)!=0){
			document.forma.Accion.value = "1";
			document.forma.MovimientoId.value = movimiento;
			console.log(document.forma);
			document.forma.submit();	
			}else{
				alert('El Importe es numerico.decimal y no puede ser Cero');
			}
		}else{
			alert('<fmt:message key="js.Completar" />');
		}
	}
	
	function Eliminar(movimientoId){
		if(confirm(' <fmt:message key='js.Confirma' /> ')){
			document.forma.Accion.value = "2";
			document.forma.MovimientoId.value = movimientoId;
			document.forma.submit();
		}
	}
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));	

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String)session.getAttribute("ejercicioId");
	String usuario 			= (String)session.getAttribute("codigoId"); 
	String codigoPadre		= request.getParameter("Padre")==null?"0":request.getParameter("Padre");
	
	String salto			= "X";
	
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
	String polizaId = request.getParameter("polizaId");
	
	if(polizaId != null){
		session.setAttribute("polizaId", polizaId);
	} else {
		polizaId 	= (String) session.getAttribute("polizaId");
	}
	
	if( polizaId == null ){
		salto = "caja.jsp";
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	String movimientoId = request.getParameter("MovimientoId")==null?"0":request.getParameter("MovimientoId");
	
	/* ACCIONES */
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	if(!FinPoliza.getEstado().equals("A")){
		accion = "";	
	}
	
	String msj 		= "";
	
	if( accion.equals("1") ){//Guardar
		if(movimientoId.equals("0") || movimientoId == null){
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
		FinMov.setTipoMovId("1");
		
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
		
		FinMov.setEjercicioId(ejercicioId);
		FinMov.setPolizaId(polizaId);
		FinMov.setMovimientoId(movimientoId);
		
		if(FinMov.existeReg(conElias)){
			if(FinMov.deleteReg(conElias)){
				msj = "Eliminado";
			}else{
				msj = "NoElimino";
			}
		}
		
		FinMov = new aca.fin.FinMovimientos();
		movimientoId = "";
	}
	
	pageContext.setAttribute("resultado", msj);
	
	/* PADRES */
	ArrayList<aca.empleado.EmpPersonal> padres 			= empleadoU.getListEscuela(conElias, escuelaId," AND SUBSTR(CODIGO_ID,4,1)='P' AND (SELECT COUNT(*) FROM ALUM_PADRES WHERE CODIGO_PADRE= EMP_PERSONAL.CODIGO_ID OR CODIGO_MADRE = EMP_PERSONAL.CODIGO_ID OR CODIGO_TUTOR = EMP_PERSONAL.CODIGO_ID) > 0 ORDER BY SUBSTR(CODIGO_ID,1,3),APATERNO,AMATERNO,NOMBRE");
	
	/* ALUMNOS */
	ArrayList<aca.alumno.AlumPersonal> alumnosEscuela	= AlumPersonalLista.getListAllNombres(conElias, escuelaId, "");
	
	/* HIJOS DEL PADRE SELECCIONADO*/
	ArrayList<aca.alumno.AlumPadres> alumnosPadre 		= alumPadresLista.getListTutor(conElias, codigoPadre, "ORDER BY 1");
	
	/* CUENTAS */
	ArrayList<aca.fin.FinCuenta> cuentas 			= FinCuentaLista.getListCuentas(conElias, escuelaId, " ORDER BY CUENTA_ID");
	
	/* MOVIMIENTOS DEL RECIBO ACTUAL */
	ArrayList<aca.fin.FinMovimientos> movimientos 	= FinMovLista.getMovimientos(conElias, ejercicioId, polizaId, FinFolio.getReciboActual() , "");
	
	if(!movimientoId.equals("0") && movimientoId != null){
		FinMov.mapeaRegId(conElias, ejercicioId, polizaId, movimientoId);
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
		<%if(movimientos.size()==0){ %>
			<a disabled title="Este recibo aún no tiene movimientos" class="btn btn-success"><i class="icon-list-alt icon-white"></i> <fmt:message key="aca.GuardarRecibo" /></a>
		<%}else{ %>
			<a href="recibo.jsp" class="btn btn-success"><i class="icon-list-alt icon-white"></i> <fmt:message key="aca.GuardarRecibo" /></a>
		<%} %>
	</div>
			
	<div class="row">
		<div class="span5">
			
			<form action="movimientos.jsp" method="post" name="forma">
				<input type="hidden" name="Accion" />
				<input type="hidden" name="MovimientoId"/>
				<input type="hidden" name="polizaId" value="<%=polizaId %>"/>
										
				<div class="alert">						
					<fieldset>								
						<a href="#myModal2" role="button" data-toggle="modal"><label for="Auxiliar"><fmt:message key="aca.Padres" /> <i class="icon-question-sign"></i></label></a>
						<select name="Padre" id="Padre" style="width:100%;">
							<option value="0"><fmt:message key="boton.Todos" /></option>
							<%for(aca.empleado.EmpPersonal padre : padres){%>
							<option value="<%=padre.getCodigoId() %>" <%if(codigoPadre.equals(padre.getCodigoId())){out.print("selected");}%>>
									<%=padre.getCodigoId() %> | <%=padre.getNombre()+" "+padre.getApaterno()+" "+padre.getAmaterno() %>
							</option>
							<%}%>
						</select>
					</fieldset>						
					<fieldset>
						<a href="#myModal" role="button" data-toggle="modal"><label for="Auxiliar"><fmt:message key="aca.Alumno" /> <i class="icon-question-sign"></i></label></a>
						<select name="Auxiliar" id="Auxiliar" style="width:100%;">
							<option value="<%=escuelaId%>00000"><%=escuelaId%>00000-INGRESO GENERAL</option>
<%						if (codigoPadre.equals("0")){

							for(aca.alumno.AlumPersonal alumno : alumnosEscuela){%>
							<option value="<%=alumno.getCodigoId()%>" <%if(FinMov.getAuxiliar().equals(alumno.getCodigoId()))out.print(" selected"); %>>
								<%=alumno.getCodigoId()%> | <%=alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno() %>
							</option>
<%							}
						}else{
							for(aca.alumno.AlumPadres alum : alumnosPadre){
%>
							<option value="<%=alum.getCodigoId()%>">
								<%=alum.getCodigoId()%> | <%=aca.alumno.AlumPersonal.getNombre(conElias, alum.getCodigoId(), "NOMBRE") %>
							</option>
<%	
							}
						}
%>
						</select>
					</fieldset>
								
					<fieldset>
						<label for="CuentaId"><fmt:message key="aca.Cuenta" /></label>
						<select name="CuentaId" id="CuentaId" style="width:100%;">
							<%for(aca.fin.FinCuenta cuenta : cuentas){%>
								<option value="<%=cuenta.getCuentaId() %>" <%if(FinMov.getCuentaId().equals(cuenta.getCuentaId()))out.print("selected"); %>>
									<%=cuenta.getCuentaId() %> | <%=cuenta.getCuentaNombre() %>
								</option>
							<%}%>
						</select>
					</fieldset>
					
					<fieldset>			
						<label for="Importe"><fmt:message key="aca.Importe" /></label>
						<input type="text" name="Importe" id="Importe" style="max-width:100%;" maxlength="8" value="<%=FinMov.getImporte() %>" />
					</fieldset>
					
					<fieldset>
						<label for="Descripcion"><fmt:message key="aca.Descripcion" /></label>
						<textarea name="Descripcion" id="Descripcion" rows="2" cols="20" style="max-width:100%;width: 100%;box-sizing: border-box;"><%=FinMov.getDescripcion() %></textarea>
					</fieldset>
						
					<fieldset>
						<label for="Referencia"><fmt:message key="aca.Referencia" /></label>
						<input type="text" name="Referencia" id="Referencia" maxlength="20" value="<%=FinMov.getReferencia() %>" />
					</fieldset>
				
				</div>
						
				<div class="well">
					<a href="javascript:Guardar('<%=movimientoId%>');" class="btn btn-primary btn-large" id="btnGuardar"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
					<%if(!movimientoId.equals("")){ %>
							<a href="movimientos.jsp" class="btn btn-large"  ><i class="icon-file"></i> <fmt:message key="boton.Nuevo" /></a>
					<%} %>
				</div>
			</form>
					
		</div>
				
		<div class="span7">
					
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
					for(aca.fin.FinMovimientos mov : movimientos){
						cont++;
						
						float importe = Float.parseFloat(mov.getImporte());
						total+=importe;
				%>
						<tr>
							<td><%=cont %></td>
							<td>
								<a href=" javascript:Eliminar('<%=mov.getMovimientoId() %>'); "><i class="icon-remove"></i></a>
								<a href="movimientos.jsp?MovimientoId=<%=mov.getMovimientoId() %>"><i class="icon-pencil"></i></a>
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
	
	padre.on('change', function(){
		cambiarHijos();
	});
	
	
</script>
<script src="../../js-plugins/tableToExcel/tableToExcel.js"></script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>