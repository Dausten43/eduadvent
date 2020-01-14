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

<script>
	function Guardar(){
		if( document.forma.Importe.value != "" && document.forma.Descripcion.value != "" ){
			document.forma.Accion.value = "1";
			document.forma.submit();	
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
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	
	if( accion.equals("1") ){//Guardar
		if(movimientoId.equals("")){
			movimientoId = FinMov.maxReg(conElias, ejercicioId, polizaId);
		}
		
		FinMov.setEjercicioId(ejercicioId);
		FinMov.setPolizaId(polizaId);
		FinMov.setMovimientoId(movimientoId);
		FinMov.setCuentaId(request.getParameter("CuentaId"));
		FinMov.setAuxiliar(request.getParameter("Auxiliar"));
		FinMov.setDescripcion(request.getParameter("Descripcion"));
		FinMov.setImporte(request.getParameter("Importe"));
		FinMov.setNaturaleza(request.getParameter("Naturaleza")); /* Cargo o Debito */
		FinMov.setReferencia(request.getParameter("Referencia"));
		FinMov.setEstado("R"); /* Recibo */
		FinMov.setFecha(aca.util.Fecha.getDateTime());
		FinMov.setReciboId("0");
		FinMov.setCicloId("00000000");
		FinMov.setPeriodoId("0");
		FinMov.setTipoMovId("0");
		
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
		movimientoId = "";
		
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
	
	<h3>
		<fmt:message key="aca.Movimiento" />&nbsp;&nbsp;
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","") %></strong>&nbsp;&nbsp;
		<fmt:message key="aca.Poliza" />: <strong><%=polizaId %> | <%=FinPoliza.getDescripcion() %></strong>
	</h3>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	<div class="well">
		<a href="poliza.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<%if( !FinPoliza.getEstado().equals("A") ){ %>
			
		<div class="alert">
			<fmt:message key="aca.PolizaCerrada" />
		</div>
		
	<%}else{ %>
			
	<div class="row">
		<div class="span5">
			
			<form action="" method="post" name="forma">
				<input type="hidden" name="Accion" />
				<input type="hidden" name="MovimientoId" />
				
				<div class="alert">
					<fieldset>
						<label for="Auxiliar"><fmt:message key="aca.Alumno" /></label>
						<select name="Auxiliar" id="Auxiliar" style="width:100%;">
							<option value="-"><fmt:message key="aca.NoAplica" /></option>
							<%for(aca.alumno.AlumPersonal alumno : alumnos){ %>
								<option value="<%=alumno.getCodigoId()%>" <%if(FinMov.getAuxiliar().equals(alumno.getCodigoId()))out.print("selected"); %>>
									<%=alumno.getCodigoId()%> | <%=alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno() %>
								</option>
							<%} %>
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
					
					<fieldset>
						<label for="Naturaleza"><fmt:message key="aca.Naturaleza" /></label>
						<select name="Naturaleza" id="Naturaleza">
							<option value="D" <%if(FinMov.getNaturaleza().equals("D")){out.print("selected");} %>><fmt:message key="aca.Cargo" /></option>
							<option value="C" <%if(FinMov.getNaturaleza().equals("C")){out.print("selected");} %>><fmt:message key="aca.Credito" /></option>
						</select>
					</fieldset>
				
				</div>
				
				<div class="well">
					<a href="javascript:Guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
					<%if(!movimientoId.equals("")){ %>
						<a href="movimientos.jsp" class="btn btn-large"><i class="icon-file"></i> <fmt:message key="boton.Nuevo" /></a>
					<%} %>
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
								<a href=" javascript:Eliminar('<%=mov.getMovimientoId() %>'); "><i class="icon-remove"></i></a>
								<a href="movimientos.jsp?MovimientoId=<%=mov.getMovimientoId() %>"><i class="icon-pencil"></i></a>
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
	
	<%} %>	
	
	
</div>

<link rel="stylesheet" href="../../js-plugins/chosen/chosen.css" />
<script src="../../js-plugins/chosen/chosen.jquery.js" type="text/javascript"></script>
<script> 
		$("#CuentaId").chosen({width: "100%"}); 
		
		$('#Auxiliar').chosen();
</script>

<link rel="stylesheet" href="../../js-plugins/maxlength/jquery.maxlength.css" />
<script src="../../js-plugins/maxlength/jquery.maxlength.min.js"></script>

<script>

	$('#Descripcion').maxlength({ 
	    max: 70,
	    showFeedback: false,
	});
	
</script>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>