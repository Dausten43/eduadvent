<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPolizaLista" scope="page" class="aca.fin.FinPolizaLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinMovs" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinFolio" scope="page" class="aca.fin.FinFolio"/>
	
<script>
	function cerrarPoliza(polizaId){
		
		if( confirm("<fmt:message key="js.ConfirmaCerrarPoliza" />") ){
			location.href="caja.jsp?Accion=1&polizaId="+polizaId;
		}
		
	}
</script>
	
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");
	String usuario 			= (String) session.getAttribute("codigoId");
	
	/* ACCIONES */
	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 				= "";
	
	/* CERRAR POLIZA */
	if(accion.equals("1")){
		
		/* **** VERIFICA SI TIENE MOVIMIENTOS SUELTOS **** */
		String polizaId = request.getParameter("polizaId");
		
		/* INFORMACION DEL RECIBO */
		FinFolio.mapeaRegId(conElias, ejercicioId, usuario);

		FinFolio.setEjercicioId(ejercicioId);
		FinFolio.setUsuario(usuario);
		ArrayList<aca.fin.FinMovimientos> movimientos = FinMovLista.getMovimientos(conElias, ejercicioId, polizaId, FinFolio.getReciboActual() , "");
		
		if(movimientos.size()==0){
			/* **** BEGIN TRANSACTION **** */
			conElias.setAutoCommit(false);
			boolean error = false;
			boolean seHaSolicitadoUnaCancelacion = false;
			
			/* ==== CAMBIAR ESTADO DE LA POLIZA ==== */
			FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
			if(!FinPoliza.getEstado().equals("A")){
				error = true;
			}
			FinPoliza.setEstado("T");//Transicion, cerrada temporalmente hasta que se mande al SunPlus
			
			if( FinPoliza.updateEstado(conElias) ){
				//Actualizado
			}else{
				error = true;
			}
			
			/* ==== SUMAR MOVIMIENTOS Y BORRAR LOS QUE NUNCA LLEGARON AL RECIBO ==== */
			ArrayList<aca.fin.FinMovimientos> movs = FinMovLista.getAllMovimientosPoliza(conElias, ejercicioId, polizaId, "");
		
			float totalImporte = 0;	
			for(aca.fin.FinMovimientos mov : movs){
				
				//Si esta creado y nunca paso a guardar el recibo
				if( mov.getEstado().equals("A") ){
					if( mov.deleteReg(conElias) ){
						//Eliminado
					}else{
						error = true; break;
					}
				}
				//Si se ha solicitado una cancelacion
				else if( mov.getEstado().equals("S") ){
					error = true; seHaSolicitadoUnaCancelacion = true; break;
				}
				//Si se guardo el recibo
				else if( mov.getEstado().equals("R") ){
					totalImporte += Float.parseFloat(mov.getImporte());
				}
				
			}
			
			/* ==== GUARDAR MOVIMIENTO PARA CUADRAR LA POLIZA ==== */
			FinMovs.setEjercicioId(ejercicioId);
			FinMovs.setPolizaId(polizaId);
			FinMovs.setMovimientoId("0");
			FinMovs.setCuentaId("0");
			FinMovs.setAuxiliar("-");
			FinMovs.setDescripcion("Diario de caja");
			FinMovs.setImporte(String.valueOf(totalImporte));
			FinMovs.setNaturaleza("D"); /* Debito */
			FinMovs.setReferencia("-");
			FinMovs.setEstado("R"); /* Recibo */
			FinMovs.setFecha(aca.util.Fecha.getDateTime());
			FinMovs.setReciboId("0");
			FinMovs.setCicloId("00000000");
			FinMovs.setPeriodoId("0");
			FinMovs.setTipoMovId("0");
			
			if( FinMovs.existeReg(conElias) ){
				error = true;
			}else{
				if( FinMovs.insertReg(conElias) ){
					//Guardado
				}else{
					error = true;
				}
			}
			
			if( error==true ){
				conElias.rollback();
				
				if( seHaSolicitadoUnaCancelacion==true ){
					msj = "NoSePuedeCerrarLaPolizaRecibosPendientes";
				}else{
					msj = "NoGuardo";
				}
				
			}else{
				conElias.commit();
				msj = "Guardado";
			}
			
			conElias.setAutoCommit(true);
			/* **** END TRANSACTION **** */
		}else{
			msj = "MovimientosSinRecibo";
		}
	}
	
	pageContext.setAttribute("resultado", msj);
	
	List<aca.fin.FinPoliza> listaPoliza = new ArrayList();
	listaPoliza.addAll(FinPolizaLista.getPolizaPorUsuarioDeCaja(conElias, usuario, ejercicioId, " ORDER BY FECHASYS desc"));
	
	SimpleDateFormat dtFormat = new SimpleDateFormat();
	Date dt = new Date();
	
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.PolizasCajaGeneral"/><small> ( <fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong> ) </small>
	</h2>
	
	<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>	 
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<% }%>
  	
  	<%
  	if(aca.fin.FinEjercicio.existeEjercicio(conElias, ejercicioId)){ %>	
	<div class="well">
		<a href="accion.jsp" class="btn btn-primary">
			<i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a>
	</div>
	 	
	<table class="table table-striped table-bordered" id="table">
		<thead>
			<tr>
				<th style="width:5%;"><fmt:message key="aca.Operacion" /></th>
				<th style="width:5%;"><fmt:message key="aca.Poliza" /></th>			
				<th><fmt:message key="aca.Descripcion" /></th>
				<th><fmt:message key="aca.RangoRecibo" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Reportes" /></th>
				<th style="width:2%;"><fmt:message key="boton.Cerrar" /></th>
				<th><fmt:message key="aca.Estado" /></th>
			</tr>
		</thead>
		<%for(aca.fin.FinPoliza poliza : listaPoliza){
			ArrayList<aca.fin.FinMovimientos> movs = FinMovLista.getAllMovimientosPoliza(conElias, poliza.getEjercicioId(), poliza.getPolizaId(), " ORDER BY MOVIMIENTO_ID");
		%>
		<tr>
			<td>
				<a href="accion.jsp?polizaId=<%=poliza.getPolizaId() %>">
					<i class="icon-pencil"></i>
				</a>
				<%if(!aca.fin.FinMovimientos.existePoliza(conElias, ejercicioId, poliza.getPolizaId())){ %>	
				<a href="javascript:if(confirm('<fmt:message key="js.Confirma" /> ')){location.href='accion.jsp?Accion=2&polizaId=<%=poliza.getPolizaId() %>';}">
					<i class="icon-remove"></i>
				</a>
				<%} %>
			</td>
			<td><%= poliza.getPolizaId() %></td>
			<td>
				<a href="movimientos.jsp?polizaId=<%=poliza.getPolizaId() %>"><%=poliza.getDescripcion() %></a>
			</td>
			<td>
			<% if(movs.size() > 1){ %>
				<%=poliza.getEstado().equals("A") ? movs.get(0).getReciboId() : movs.get(1).getReciboId()%> - <%=movs.get(movs.size() - 1).getReciboId()%>
			<% } else if(movs.size() == 1) { %>
				<%=poliza.getEstado().equals("A") ? movs.get(0).getReciboId() : "-"%>
			<% } %>
			</td>
			<td>
			<%
				dtFormat.applyPattern("dd/MM/yyyy");
				dt = dtFormat.parse(poliza.getFecha());
				dtFormat.applyPattern("yyyy-MM-dd");
			%>
			<%= dtFormat.format(dt) %>
			</td>
			<td>
				<a href="verRecibos.jsp?polizaId=<%=poliza.getPolizaId() %>" class="btn btn-mini"><fmt:message key="aca.Recibos" /></a>
				<a href="verMovimientos.jsp?polizaId=<%=poliza.getPolizaId() %>" class="btn btn-mini"><fmt:message key="aca.Movimientos" /></a>
				<%//if(aca.catalogo.CatEscuela.getUnionId(conElias, escuelaId).equals("7")){%>
				<%if(false){ %>
				<a href="exportacionSunPlus.jsp?polizaId=<%=poliza.getPolizaId() %>" class="btn btn-mini btn-info"><i class="icon-asterisk icon-white"></i> SunPlus</a>
				<%} %>
			</td>
			<td>
				<%if(poliza.getEstado().equals("A")){%>
					<a href="javascript:cerrarPoliza('<%=poliza.getPolizaId() %>');" class="btn btn-mini btn-primary"><fmt:message key="aca.CerrarPoliza" /></a>
				<%}else{ %>
					<a disabled class="btn btn-mini btn-primary" title="<fmt:message key="aca.PolizaYaEstaCerrada" />"><fmt:message key="aca.CerrarPoliza" /></a>
				<%} %>
			</td>
			<td>
				<%if(poliza.getEstado().equals("A")){%>
					<span class="label label-success"><fmt:message key="aca.Abierta" /></span>
				<%}else if(poliza.getEstado().equals("T")){ %>
					<span class="label label-inverse"><fmt:message key="aca.Cerrada" /></span>
				<%}else{ %>
					<span class="label label-info"><fmt:message key="aca.SunPlus" /></span>
				<%} %>
			</td>
		</tr>
		<%}%>
	</table>	
<%}else{%>
<div class="alert alert-danger">
		<h3><fmt:message key="aca.EjercicioNoValido" /></h3>
</div>
<%} %>
</div>

<link rel="stylesheet" href="../../js-plugins/tablesorter/themes/blue/style.css" />
<script src="../../js-plugins/tablesorter/jquery.tablesorter.js"></script>


<script src="../../js/search.js"></script>

<script>
	$('#table').tablesorter();

	$('#buscar').search({
		table:$("#table")}
	);
</script>	
	
<%@ include file= "../../cierra_elias.jsp" %>