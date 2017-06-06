<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="FinPolizaLista" scope="page" class="aca.fin.FinPolizaLista" />
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza" />
<jsp:useBean id="FinMovs" scope="page" class="aca.fin.FinMovimientos" />
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista" />
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista" />

<script>
	function cerrarPoliza(polizaId) {

		if (confirm("<fmt:message key="js.ConfirmaCerrarPoliza" />")) {
			location.href = "ingresos.jsp?Accion=1&polizaId=" + polizaId;
		}

	}
</script>

<%
	String escuelaId = (String) session.getAttribute("escuela");
	String ejercicioId = (String) session.getAttribute("ejercicioId");
	String usuario = (String) session.getAttribute("codigoId");

	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta = FinCuentaL.mapCuentasEscuela(conElias, escuelaId);

	/* ACCIONES */

	String accion = request.getParameter("Accion") == null ? "" : request.getParameter("Accion");
	String msj = "";

	/* CERRAR POLIZA */
	if (accion.equals("1")) {

		/* **** BEGIN TRANSACTION **** */
		conElias.setAutoCommit(false);
		boolean error = false;

		String polizaId = request.getParameter("polizaId");

		/* ==== CAMBIAR ESTADO DE LA POLIZA ==== */
		FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
		if (!FinPoliza.getEstado().equals("A")) {
			error = true;
		}
		FinPoliza.setEstado("T");//Transicion, cerrada temporalmente hasta que se mande al SunPlus

		if (FinPoliza.updateEstado(conElias)) {
			//Actualizado
		} else {
			error = true;
		}

		/* ==== GENERAR UN MOVIMIENTO PARA CUADRAR POR CADA MOVIMIENTO ==== */

		ArrayList<aca.fin.FinMovimientos> movs = FinMovLista.getAllMovimientosPoliza(conElias, ejercicioId, polizaId, "");

		for (aca.fin.FinMovimientos mov : movs) {

			String nombreCuenta = mov.getCuentaId();
			if (mapCuenta.containsKey(mov.getCuentaId())) {
				nombreCuenta = mapCuenta.get(mov.getCuentaId()).getCuentaNombre();
			}

			/* ==== GUARDAR MOVIMIENTO PARA CUADRAR LA POLIZA ==== */
			FinMovs.setEjercicioId(ejercicioId);
			FinMovs.setPolizaId(polizaId);
			FinMovs.setMovimientoId(FinMovs.maxReg(conElias, ejercicioId, polizaId));
			FinMovs.setCuentaId(mov.getCuentaId());
			FinMovs.setAuxiliar("-");
			FinMovs.setDescripcion("ACUMULADO EN: " + nombreCuenta);
			FinMovs.setImporte(mov.getImporte());
			FinMovs.setNaturaleza("C"); /* Credito */
			FinMovs.setReferencia("-");
			FinMovs.setEstado("R");
			FinMovs.setFecha(aca.util.Fecha.getDateTime());
			FinMovs.setReciboId("0");
			FinMovs.setCicloId("00000000");
			FinMovs.setPeriodoId("0");
			FinMovs.setTipoMovId("5");

			if (FinMovs.existeReg(conElias)) {
				error = true;
			} else {
				if (FinMovs.insertReg(conElias)) {
					//Guardado
				} else {
					error = true;
				}
			}

		}

		if (error == true) {
			conElias.rollback();
			msj = "NoGuardo";
		} else {
			conElias.commit();
			msj = "Guardado";
		}

		conElias.setAutoCommit(true);
		/* **** END TRANSACTION **** */
	}

	pageContext.setAttribute("resultado", msj);

	ArrayList<aca.fin.FinPoliza> listaPoliza = FinPolizaLista.getPolizaPorUsuarioDeIngreso(conElias, usuario, ejercicioId, " ORDER BY FECHASYS DESC");
%>

<div id="content">

	<h2>
		<fmt:message key="aca.PolizasIngreso" /> <small>( <fmt:message key="aca.EjercicioActual" /> : <strong><%=ejercicioId.replace(escuelaId + "-", "")%></strong> )</small>
	</h2>
	
	<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>	
	
<%	if(aca.fin.FinEjercicio.existeEjercicio(conElias, ejercicioId)){ %>
		
	<div class="well">
		<a href="accion.jsp" class="btn btn-primary"> <i
			class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a>
	</div>

	<table class="table table-striped table-bordered" id="table">
		<tr>
			<th style="width: 5%;"><fmt:message key="aca.Operacion" /></th>
			<th style="width: 5%;"><fmt:message key="aca.Poliza" /></th>
			<th><fmt:message key="aca.Descripcion" /></th>
			<th><fmt:message key="aca.Fecha" /></th>
			<th><fmt:message key="aca.Reportes" /></th>
			<th style="width: 2%;"><fmt:message key="boton.Cerrar" /></th>
			<th><fmt:message key="aca.Estado" /></th>
		</tr>
		<%for (aca.fin.FinPoliza poliza : listaPoliza) {%>
			<tr>
				<td>
					<a href="accion.jsp?polizaId=<%=poliza.getPolizaId()%>"><i class="icon-pencil"></i></a> 
					<%if (!aca.fin.FinMovimientos.existePoliza(conElias, ejercicioId, poliza.getPolizaId())) {%>
						<a href="javascript:if(confirm('<fmt:message key="js.Confirma" /> ')){location.href='accion.jsp?Accion=2&polizaId=<%=poliza.getPolizaId()%>';}"><i class="icon-remove"></i></a> 
					<%}%>
				</td>
				<td><%=poliza.getPolizaId()%></td>
				<td><a href="importarMovimientos.jsp?polizaId=<%=poliza.getPolizaId()%>"><%=poliza.getDescripcion()%></a></td>
				<td><%=poliza.getFecha()%></td>
				<td>
					<a href="verMovimientos.jsp?polizaId=<%=poliza.getPolizaId()%>" class="btn btn-mini"><fmt:message key="aca.Movimientos" /></a>
					<a href="verPagos.jsp?polizaId=<%=poliza.getPolizaId()%>" class="btn btn-mini"><fmt:message key="aca.Pagos" /></a>
					
					<%//if(aca.catalogo.CatEscuela.getUnionId(conElias, escuelaId).equals("7")){%>
					<%if(false){ %>
					<a href="exportacionSunPlus.jsp?polizaId=<%=poliza.getPolizaId() %>" class="btn btn-mini btn-info"><i class="icon-asterisk icon-white"></i> SunPlus</a>
					<%} %>
				</td>
				<td>
					<%if (poliza.getEstado().equals("A")) {%> 
						<a href="javascript:cerrarPoliza('<%=poliza.getPolizaId()%>');" class="btn btn-mini btn-primary"><fmt:message key="aca.CerrarPoliza" /></a> 
					<%} else {%> 
						<a disabled class="btn btn-mini btn-primary" title="<fmt:message key="aca.PolizaYaEstaCerrada" />"><fmt:message key="aca.CerrarPoliza" /></a> 
					<%}%>
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
<%	}else{%>
<div class="alert alert-danger">
		<h3><fmt:message key="aca.EjercicioNoValido" /></h3>
</div>
<%	} %>
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

<%@ include file="../../cierra_elias.jsp"%>