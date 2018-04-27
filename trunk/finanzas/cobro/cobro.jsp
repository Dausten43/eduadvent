<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>
<%@page import="aca.fin.FinPago"%>

<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloPeriodo" scope="page" class="aca.ciclo.CicloPeriodo"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="finPago" scope="page" class="aca.fin.FinPago"/>
<jsp:useBean id="finPagoL" scope="page" class="aca.fin.FinPagoLista"/>


<script>
	function nuevo(){
		document.forma.action = "edita_cobro.jsp";
		document.forma.submit();
	}
	
	function elimina(ciclo, periodo, pago){
		if(confirm("<fmt:message key='js.Confirma' />")){
			document.forma.action = document.forma.action + "?Accion=1&ciclo="+ciclo+"&periodo="+periodo+"&pago="+pago;
			document.forma.submit();
		} 
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId		= (String) session.getAttribute("cicloId");
	
	String periodoId	= request.getParameter("Periodo")==null?"1":request.getParameter("Periodo");	
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String cicloElegido	= request.getParameter("Ciclo")==null?"0":request.getParameter("Ciclo");
	
	String mensaje		= "";	
	
	// Ciclo escolar elegido o activo
	if (!cicloElegido.equals("0")){
		cicloId = cicloElegido;
		session.setAttribute("cicloId", cicloId);
	}
	
	/* LISTA DE PERIODOS DE INCRIPCION */
	ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo = cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY CICLO_PERIODO.F_INICIO");
	boolean encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisCicloPeriodo){
		if(per.getPeriodoId().equals(periodoId)){
			encontro = true;
		}
	}
	if(encontro==false && lisCicloPeriodo.size()>0){
		periodoId = lisCicloPeriodo.get(0).getPeriodoId();
	}
	
	String numPagosIniciales	= aca.fin.FinPago.numPagosIniciales(conElias, cicloId, periodoId);
	
	if(accion.equals("1")){	//Eliminar
		String pagoId	= request.getParameter("pago");
		finPago.setCicloId(cicloId);
		finPago.setPeriodoId(periodoId);
		finPago.setPagoId(pagoId);
		if(finPago.deleteReg(conElias)){
			mensaje = "1";
		}else{
			mensaje = "2";
		}
	}
	
	/* LISTA DE CICLOS ESCOLARES DE LA ESCUELA */
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloL.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID ");
	
	
	/* LISTA DE FECHAS DE COBRO*/
	ArrayList<aca.fin.FinPago> lisFinPago = finPagoL.getListCicloPeriodo(conElias, cicloId, periodoId, "ORDER BY FIN_PAGO.FECHA, DESCRIPCION");
%>

<div id="content">
	
	<h2><fmt:message key="aca.FechasDeCobro" /><small>( <%=escuelaId%> - <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> )</small></h2>
	
	<form id="forma" name="forma" action="cobro.jsp" method="post">
		<div class="well">
			<fmt:message key="aca.Ciclo" />:&nbsp;&nbsp;			
			<select id="Ciclo" name="Ciclo" onchange="document.location = 'cobro.jsp?Ciclo='+this.options[this.selectedIndex].value;" style="width:360px;margin-bottom:0px;">
		<%
			for(int i = 0; i < lisCiclo.size(); i++){
				ciclo = (Ciclo) lisCiclo.get(i);
		%>
				<option value="<%=ciclo.getCicloId() %>"<%=cicloId.equals(ciclo.getCicloId())?" Selected":"" %>><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
		<%
			}
		%>
			</select>
			&nbsp;&nbsp;<fmt:message key="aca.Periodo" />:&nbsp;&nbsp;				
			<select id="Periodo" name="Periodo" onchange="document.forma.submit();" >
		<%		
			for(int i = 0; i < lisCicloPeriodo.size(); i++){
				cicloPeriodo = (CicloPeriodo) lisCicloPeriodo.get(i);
		%>
				<option value="<%=cicloPeriodo.getPeriodoId() %>"<%=periodoId.equals(cicloPeriodo.getPeriodoId())?" Selected":"" %>><%=cicloPeriodo.getPeriodoNombre() %></option>
		<%
			}
		%>
			</select>
			&nbsp;&nbsp;
			<a class="btn btn-primary" href="edita_cobro.jsp?ciclo=<%=cicloId%>&periodo=<%=periodoId%>">
				  <i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" />
			</a> 
			&nbsp;&nbsp;
			<a class="btn btn-success" href="traspaso.jsp">
				   <fmt:message key="aca.ClonarFechasCobros" /><i class="icon-random icon-white"></i>
			</a>			
		</div>
		
		<table class="table table-bordered table-striped">
			<%if(lisFinPago.size() > 0){%>
				<thead>
					<tr>
						<th><fmt:message key="aca.Accion" /></th>
						<th>#</th>
						<th><fmt:message key="aca.Descripcion" /></th>
						<th><fmt:message key="aca.FechaAplica" /></th>
						<th><fmt:message key="aca.FechaVence" /></th>
						<th><fmt:message key="aca.Tipo" /></th>
						<th><fmt:message key="aca.Orden" /></th>
					</tr>
				</thead>
			<%
				boolean elimina = false;
				if(!FinPago.tieneDatos(conElias, cicloId, periodoId))
					elimina = true;
					
					for(int i = 0; i < lisFinPago.size(); i++){
						finPago = (FinPago) lisFinPago.get(i);					 
			%>
						<tr>
							<td>					
								<a href="edita_cobro.jsp?ciclo=<%=cicloId %>&periodo=<%=periodoId %>&pago=<%=finPago.getPagoId() %>"><i class="icon-pencil"></i></a>
								<%if(elimina){%>
									<a href="javascript:elimina('<%=finPago.getCicloId()%>','<%=finPago.getPeriodoId()%>','<%=finPago.getPagoId()%>');"><i class="icon-remove"></i></a>
								<%}%>
							</td>
							<td>
								<%=i+1 %>
							</td>
							<td><%=finPago.getDescripcion() %></td>
							<td><%=finPago.getFecha() %></td>
							<td><%=finPago.getFechaVence() %></td>
							<td><%=finPago.getTipo().equals("I")?"Inicial":"Ordinario" %></td>
							<td><%=finPago.getOrden()%></td>
						</tr>
			<%
					}
				}else{
			%>
					<tr><td><fmt:message key="aca.NoExistenCobros" /></td></tr>
			<%
				}
			%>
		</table>
		<%
			if (numPagosIniciales.equals("0")){
		%>		
				<div class="alert alert-info"><fmt:message key="aca.NoExistePagoInicial"/></div>
		<%						
			}else if (Integer.parseInt(numPagosIniciales) > 1){
		%>		
				<div class="alert alert-danger">¡Error! Solo se permite un pago inicial.</div>
		<%		
			}
		%>
	</form>
</div>

<%@ include file= "../../cierra_elias.jsp" %>