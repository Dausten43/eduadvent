<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="DescargaSunplusL" scope="page" class="aca.fin.FinDescargaSunplusLista"/>
<jsp:useBean id="DescargaSunplus" scope="page" class="aca.fin.FinDescargaSunplus"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinPolizaL" scope="page" class="aca.fin.FinPolizaLista"/>
	
<script>
	function cancelarDescarga(descargaId){
		if(confirm("¿Estás seguro de cancelar esta descarga? Ten en cuenta que una vez cancelada no se podrá saber que polizas se habían exportado en esta descarga")){
			document.forma.Accion.value = "1";
			document.forma.DescargaId.value = descargaId;
			document.forma.submit();
		}
	}
</script>	
	
<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String)session.getAttribute("codigoId");
	
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if(accion.equals("1")){// CANCELAR DESCARGA
		
		conElias.setAutoCommit(false);
		boolean error = false;
		
		String descargaId = request.getParameter("DescargaId");
		
		ArrayList<aca.fin.FinPoliza> polizas = FinPolizaL.getPolizasDescarga(conElias, descargaId, "");
		for(aca.fin.FinPoliza poliza : polizas){
			FinPoliza.setEjercicioId(poliza.getEjercicioId());
			FinPoliza.setPolizaId(poliza.getPolizaId());
			FinPoliza.setEstado("T");
			FinPoliza.setDescargaId("0");
			
			if(FinPoliza.updateEstadoYDescargaId(conElias)){
				//todo chido
			}else{
				error = true; break;
			}
		}
		
		// GUARDAR LA DESCARGA DE LA POLIZA
		DescargaSunplus.setDescargaId(descargaId);
		
		if(DescargaSunplus.deleteReg(conElias)){
			//todo chido
		}else{
			error = true;
		}
	
		if(error){
			conElias.rollback();
			msj = "<style>#tabla-movs{display:none;}</style><div class='alert alert-danger'>Ocurrió un error al cancelar la descarga</div>";
		}else{
			conElias.commit();
			msj = "<div class='alert alert-success'>Se canceló la descarga</div>";
		}
		conElias.setAutoCommit(true);
		
	}
 
	ArrayList<aca.fin.FinDescargaSunplus> descargas = DescargaSunplusL.getDescargasUsuario(conElias, codigoId, "ORDER BY FECHA DESC"); 	
%>

<style>
	.table tr td:nth-child(4), .table tr td:nth-child(7), .table tr:nth-child(2) th:nth-child(3), .table tr:nth-child(2) th:nth-child(6)  {
		border-right: 1px solid #D8D8D8;
	}
</style>

<div id="content">
	
	<h2>
		<fmt:message key="aca.HistorialDescargas" />
	</h2>
	
	<%=msj %>
	
	<div class="well">
		<a href="asociacion.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a> 
	</div>
	
	<form action="" method="post" name="forma">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="DescargaId" />
	
		<table class="table table-condesed table-bordered table-striped">
			<tr>
				<th>#</th>
				<th>Fecha descarga</th>
				<th>Tipo</th>
				<th>Acción</th>
			</tr>
			<%int cont = 0; %>
			<%for(aca.fin.FinDescargaSunplus descarga : descargas){%>
			<%
				cont++; 
				String tipo = ""; 
				if(descarga.getTipoPoliza().equals("C")){
					tipo = "Pólizas de Caja";
				}else if(descarga.getTipoPoliza().equals("I")){
					tipo = "Pólizas de Inscripción";
				}else if(descarga.getTipoPoliza().equals("G")){
					tipo = "Pólizas Generales";
				}	
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=descarga.getFecha() %> &nbsp;&nbsp; <a class="btn btn-mini btn-success" href="descargarArchivo.jsp?descargaId=<%=descarga.getDescargaId() %>"><i class="icon-arrow-down icon-white"></i> Descargar archivo</a></td>
					<td><%=tipo %></td>
					<td>
						<a class="btn btn-mini" href="javascript:cancelarDescarga('<%=descarga.getDescargaId()%>');"><i class="icon-remove"></i> Cancelar esta descarga</a>
					</td>
				</tr>
			<%} %>
		</table>
	
	</form>
	

</div>	

	
<%@ include file= "../../cierra_elias.jsp" %>