<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPolizaLista" scope="page" class="aca.fin.FinPolizaLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinMovs" scope="page" class="aca.fin.FinMovimientos"/>

<script>
	function abrirPoliza(polizaId){
		
		if( confirm("<fmt:message key="js.ConfirmaAbrirPoliza" />") ){
			location.href="poliza.jsp?Accion=1&polizaId="+polizaId;
		}
		
	}
</script>	
	
<%
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("ejercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");
	
	/* ACCIONES */
	
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	boolean abiertas    = false;
	
	/* VERIFICAR QUE NO HAYA OTRAS POLIZAS ABIERTAS DEL MISMO USUARIO */
	if(accion.equals("1")){
		String polizaId = request.getParameter("polizaId");
		
		/* ==== CAMBIAR ESTADO DE LA POLIZA ==== */
		FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
		
		ArrayList<aca.fin.FinPoliza> listaPoliza = FinPolizaLista.getPolizaPorUsuarioDeCaja(conElias, FinPoliza.getUsuario(), ejercicioId, " AND ESTADO = 'A' ");
		
		if(listaPoliza.size()>0 && FinPoliza.getTipo().equals("C")){
			abiertas = true;
			msj = "NoGuardoYaHayUnaPolizaAbiertaDelUsuario";
		}
		
	}
	
	/* ABRIR POLIZA */
	if(accion.equals("1") && abiertas == false){
				
		/* **** BEGIN TRANSACTION **** */
		conElias.setAutoCommit(false);
		boolean error = false;
		
		String polizaId = request.getParameter("polizaId");
		
		/* ==== CAMBIAR ESTADO DE LA POLIZA ==== */
		FinPoliza.mapeaRegId(conElias, ejercicioId, polizaId);
		if(!FinPoliza.getEstado().equals("T")){
			error = true;
		}
		FinPoliza.setEstado("A");//Abierta
		
		if( FinPoliza.updateEstado(conElias) ){
			//Actualizado
		}else{
			error = true;
		}
		
		
		/* ==== ELIMINAR MOVIMIENTO QUE CUADRA LA POLIZA ==== */
		FinMovs.setEjercicioId(ejercicioId);
		FinMovs.setPolizaId(polizaId);
		
		if(FinPoliza.getTipo().equals("C")){
			if(FinMovs.deleteMovimientosParaCuadrarPolizaCaja(conElias)){
				//Eliminado
			}else{
				error = true;
			}
		}else if(FinPoliza.getTipo().equals("I")){
			if(FinMovs.deleteMovimientosParaCuadrarPolizaIngreso(conElias)){
				//Eliminado
			}else{
				error = true;
			}
		}
		
		
		if( error==true ){
			conElias.rollback();
			msj = "NoGuardo";
		}else{
			conElias.commit();
			msj = "Guardado";
		}
		
		conElias.setAutoCommit(true);
		/* **** END TRANSACTION **** */
	}
	
	pageContext.setAttribute("resultado", msj);
	
	
	ArrayList<aca.fin.FinPoliza> listaPoliza = FinPolizaLista.getPolizas(conElias, ejercicioId, " ORDER BY FECHASYS DESC");
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Polizas" />
	</h2>
	
	<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	</div>	
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
		
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong>
	</div>
	
	<table class="table table-striped table-bordered" id="table">
		<thead>
			<tr>
				<th style="width:5%;"><fmt:message key="aca.Poliza" /></th>			
				<th><fmt:message key="aca.Descripcion" /></th>
				<th><fmt:message key="aca.Usuario" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Tipo" /></th>
				<th><fmt:message key="aca.Reportes" /></th>
				<th><fmt:message key="aca.Estado" /></th>
			</tr>
		</thead>
		<%for(aca.fin.FinPoliza poliza : listaPoliza){%>
			<tr>
				<td><%=poliza.getPolizaId() %></td>
				<td><%=poliza.getDescripcion() %></td>
				<td><%=aca.empleado.EmpPersonal.getNombre(conElias, poliza.getUsuario(), "NOMBRE") %></td>
				<td><%=poliza.getFecha() %></td>
				<td>
					<%if(poliza.getTipo().equals("C")){ %>
						<fmt:message key="aca.Caja" />
					<%}else if(poliza.getTipo().equals("I")){ %>
						<fmt:message key="aca.Ingreso" />
					<%}else if(poliza.getTipo().equals("G")){ %>
						<fmt:message key="aca.General" />
					<%} %>
				</td>
				<td>
					<a href="verMovimientos.jsp?polizaId=<%=poliza.getPolizaId() %>" class="btn btn-mini"><fmt:message key="aca.Movimientos" /></a>
				</td>
				<td>
					<%if(poliza.getEstado().equals("A")){%>
						<span class="label label-success"><fmt:message key="aca.Abierta" /></span>
					<%}else if(poliza.getEstado().equals("T")){ %>
						<span class="label label-inverse"><fmt:message key="aca.Cerrada" /></span>
					<%}else{ %>
						<span class="label label-info"><fmt:message key="aca.SunPlus" /></span>
					<%} %>
					<%if(poliza.getEstado().equals("T")){%>
						<a href="javascript:abrirPoliza('<%=poliza.getPolizaId() %>');" class="btn btn-mini btn-primary"><fmt:message key="aca.AbrirPoliza" /></a>
					<%}%>
				</td>
			</tr>
		<%}%>
	</table>	

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