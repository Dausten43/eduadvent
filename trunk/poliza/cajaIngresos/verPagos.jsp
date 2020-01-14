<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinMovimientosLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="CicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="finPagoL" scope="page" class="aca.fin.FinPagoLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
	
<script>	
	function cambiaCiclo(){
		document.forma.submit();
	}
	
	function cambiaPeriodo(){
		document.forma.submit();
	}
	
	function cancelarMovimientos(pago){
		if(confirm("<fmt:message key="js.Confirma" />")){
			document.forma.Pago.value 	= pago;
			document.forma.Accion.value = "1";
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
		salto = "ingresos.jsp";
	}
	
	FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
	
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovimientosLista.getMovimientosPolizaIngreso(conElias, ejercicioId, polizaId, " ORDER BY AUXILIAR, RECIBO_ID DESC, FECHA DESC ");
	
	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 		= FinCuentaL.mapCuentasEscuela(conElias, escuelaId);
	
	/* ******** CICLO ******** */
	ArrayList<aca.ciclo.Ciclo> lisCiclo				= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	String cicloId 			= (String) session.getAttribute("cicloId");
	
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
	
	
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	
	if(accion.equals("1") && FinPoliza.getEstado().equals("A")){//Eliminar movimientos
		
		String pago = request.getParameter("Pago")==null?"":request.getParameter("Pago");
		
		boolean error = false;
		conElias.setAutoCommit(false);
		
		for(aca.fin.FinMovimientos mov : movimientos){ 
			
			String cicloMov 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[0] : "";
			String periodoMov 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[1] : "";
			String pagoMov 	 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[2] : "";
			
			if(cicloMov.equals(cicloId)==false || periodoMov.equals(periodoId)==false || pagoMov.equals(pago)==false){
				continue;
			}
		
			if(mov.deleteReg(conElias)){
				//Eliminado
			}else{
				error = true; break;
			}
			
			
			if(pago.equals("PI")){//Pago Inicial
				if(aca.fin.FinCalculo.updateInscrito(conElias, cicloId, periodoId, mov.getAuxiliar(), "G")){
					//Estado actualizado
				}else{
					error = true; break;
				}
			}else{
				if(aca.fin.FinCalculoPago.updateEstado(conElias, cicloId, periodoId, mov.getAuxiliar(), pago, mov.getCuentaId(), "A")){
					//Estado actualizado
				}else{
					System.out.println("ERROR AL ACTUALIZAR EDO");
					System.out.println(cicloId+" - "+periodoId+" - "+mov.getAuxiliar()+" - "+pago+" - "+mov.getCuentaId()+" - "+"A");
					error = true; break;
				}	
			}
			
		}
		
		if(error==true){
			conElias.rollback();
			msj = "NoModifico"; 
		}else{
			conElias.commit();
			movimientos = FinMovimientosLista.getMovimientosPolizaIngreso(conElias, ejercicioId, polizaId, " ORDER BY AUXILIAR, RECIBO_ID DESC, FECHA DESC ");
			msj = "Modificado";
		}
		
		conElias.setAutoCommit(true);
	}
	
	pageContext.setAttribute("resultado", msj);
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Movimientos" /> <small>( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong> )</small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<form action="" name="forma" method="post">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Pago" />
	
		<div class="well">
			<a href="ingresos.jsp" class="btn btn-primary">
				<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
			</a>
			
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
		
		 	
		<table class="table table-condensed table-bordered">
			<thead>
				<tr>
						<th style="width:2%;">#</th>
						<th style="width:15%;"><fmt:message key="aca.Alumno" /></th>
						<th style="width:15%;"><fmt:message key="aca.Cuenta" /></th>
						<th style="width:10%;"><fmt:message key="aca.Fecha" /></th>
						<th style="width:20%;"><fmt:message key="aca.Descripcion" /></th>
						<th style="width:10%;" class="text-right"><fmt:message key="aca.Importe" /></th>
					</tr>
			</thead>
			
			<%
			
				/* AGREGAR EL PAGO INICIAL A LA LISTA DE PAGOS */
				aca.fin.FinPago PI = new aca.fin.FinPago();
				PI.setDescripcion("Pago inicial");
				PI.setPagoId("PI");
				lisFinPago.add(0, PI);
				
				for(aca.fin.FinPago pago : lisFinPago){
					
					/* VER SI HAY MOVIMIENTOS DE ESTE PAGO */
					int number = 0;
					for(aca.fin.FinMovimientos mov : movimientos){ 
						String cicloMov 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[0] : "";
						String periodoMov 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[1] : "";
						String pagoMov 	 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[2] : "";
						
						if(cicloMov.equals(cicloId)==false || periodoMov.equals(periodoId)==false || pagoMov.equals(pago.getPagoId())==false){
							continue;
						}
						number++;
					}
					
			%>
					<tr class="alert">
						<td colspan="6">
							<%=pago.getDescripcion() %>
							
							<%if(number>0 && FinPoliza.getEstado().equals("A")){ %>
								<a href="javascript:cancelarMovimientos('<%=pago.getPagoId() %>');" class="btn btn-danger btn-mini pull-right"><fmt:message key="aca.CancelarMovimientos" /></a>
							<%} %>
						</td>
					</tr>
			<%
					
					/* MOSTRAR LOS MOVIMIENTOS DE ESTE PAGO */
					int cont = 0;
					for(aca.fin.FinMovimientos mov : movimientos){ 
						
						String cicloMov 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[0] : "";
						String periodoMov 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[1] : "";
						String pagoMov 	 	= mov.getReferencia().split("\\$\\$").length == 3 ? mov.getReferencia().split("\\$\\$")[2] : "";
						
						if(cicloMov.equals(cicloId)==false || periodoMov.equals(periodoId)==false || pagoMov.equals(pago.getPagoId())==false){
							continue;
						}
						
						cont++;
						
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
							<td class="text-right"><%=getformato.format( Float.parseFloat(mov.getImporte()) ) %></td>
						</tr>
			<%
					}
				}
			%>
			</table>
			
			<br />
			
			<h4><fmt:message key="aca.MovimientosSinClasificacion" /></h4>
			
			<table class="table table-condensed table-bordered table-striped">
				<thead>
					<tr>
						<th style="width:2%;">#</th>
						<th style="width:15%;"><fmt:message key="aca.Alumno" /></th>
						<th style="width:15%;"><fmt:message key="aca.Cuenta" /></th>
						<th style="width:10%;"><fmt:message key="aca.Fecha" /></th>
						<th style="width:20%;"><fmt:message key="aca.Descripcion" /></th>
						<th style="width:10%;" class="text-right"><fmt:message key="aca.Importe" /></th>
					</tr>
				</thead>
			
			<%
				int cont = 0;
				for(aca.fin.FinMovimientos mov : movimientos){ 
					
					if(mov.getReferencia().split("\\$\\$").length == 3){
						continue;
					}
					
					cont++;
					
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
						<td class="text-right"><%=getformato.format( Float.parseFloat(mov.getImporte()) ) %></td>
					</tr>
			<%
				}
			%>
				
		</table>
	
	</form>
	
</div>	
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>