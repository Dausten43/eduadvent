<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPolizaLista" scope="page" class="aca.fin.FinPolizaLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinMovs" scope="page" class="aca.fin.FinMovimientos"/>
<jsp:useBean id="FinMovLista" scope="page" class="aca.fin.FinMovimientosLista"/>
	
<script>
	function cerrarPoliza(polizaId){
		
		if( confirm("<fmt:message key="js.ConfirmaCerrarPoliza" />") ){
			location.href="poliza.jsp?Accion=1&polizaId="+polizaId;
		}
		
	}
</script>	
<%
	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String)session.getAttribute("ejercicioId");
	String usuario 			= (String)session.getAttribute("codigoId");
	String cuadrarPoliza	= "N";
	boolean existeEjercicio = aca.fin.FinEjercicio.existeEjercicio(conElias, ejercicioId);
	
	//System.out.println("Datos:"+escuelaId+":"+ejercicioId+":"+usuario);
	
/* ACCIONES */	
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	/* CERRAR POLIZA */
	if(accion.equals("1")){
		
		/* **** BEGIN TRANSACTION **** */
		conElias.setAutoCommit(false);
		boolean error = false;
		boolean seHaSolicitadoUnaCancelacion = false;
		
		String polizaId = request.getParameter("polizaId");
		
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
		
		if (cuadrarPoliza.equals("S")){
			if(aca.fin.FinMovimientos.getCPoliza(conElias, ejercicioId, polizaId).equals(aca.fin.FinMovimientos.getDPoliza(conElias, ejercicioId, polizaId)) == false){
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
	}
	
	pageContext.setAttribute("resultado", msj);	
		
	ArrayList<aca.fin.FinPoliza> listaPoliza = FinPolizaLista.getPolizaPorUsuarioGenerales(conElias, usuario, ejercicioId, " ORDER BY FECHASYS DESC ");
	
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.PolizasGenerales" />
		<small>(
			<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong>
		)</small>
	</div>
	</h2>	
	<div class="well" style="overflow:hidden;">
	 	<input type="text" class="input-medium search-query" placeholder="<fmt:message key="boton.Buscar" />" id="buscar">
	<%if(existeEjercicio){ %>
		&nbsp;&nbsp;
		<a href="accion.jsp" class="btn btn-primary">
			<i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
		</a>
	<%} %>
	</div>
		
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>

	<%if(existeEjercicio){ %>
	 	
	<table class="table table-striped table-bordered" id="table">
		<tr>
			<th style="width:5%;"><fmt:message key="aca.Operacion" /></th>
			<th style="width:5%;"><fmt:message key="aca.Poliza" /></th>			
			<th><fmt:message key="aca.Descripcion" /></th>
			<th><fmt:message key="aca.Fecha" /></th>
			<th><fmt:message key="aca.CopiaDiario" /></th>
			<th style="width:2%;"><fmt:message key="boton.Cerrar" /></th>
			<th><fmt:message key="aca.Estado" /></th>
		</tr>		
		<%for(aca.fin.FinPoliza poliza : listaPoliza){%>
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
				<td><%=poliza.getPolizaId().substring(2) %></td>
				<td>
				<%	if(poliza.getEstado().equals("A")){%>
					<a href="movimientos.jsp?polizaId=<%=poliza.getPolizaId() %>"><%=poliza.getDescripcion() %></a>
				<%	}else{ %>
					<a href="vermovimientos.jsp?polizaId=<%=poliza.getPolizaId() %>"><%=poliza.getDescripcion() %></a>
				<%	} %>
				</td>
				<td><%=poliza.getFecha() %></td>
				<td><a href="copiadiario.jsp?ejercicioId=<%= ejercicioId %>&polizaId=<%= poliza.getPolizaId() %>">copiar</a></td>
				<td>
					<%if(poliza.getEstado().equals("A")){%>
						<%if(cuadrarPoliza.equals("N") || aca.fin.FinMovimientos.getCPoliza(conElias, ejercicioId, poliza.getPolizaId()).equals(aca.fin.FinMovimientos.getDPoliza(conElias, ejercicioId, poliza.getPolizaId()))){ %>
							<a href="javascript:cerrarPoliza('<%=poliza.getPolizaId() %>');" class="btn btn-mini btn-primary"><fmt:message key="aca.CerrarPoliza" /></a>
						<%}else{ %>
							<a disabled class="btn btn-mini btn-primary" title="<fmt:message key="aca.AunNoCuadra" />"><fmt:message key="aca.CerrarPoliza" /></a>
						<%} %>
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