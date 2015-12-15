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


<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	

	String cicloIdOriginal		= request.getParameter("ciclo")==null?"0":request.getParameter("ciclo");
	String periodoIdOriginal	= request.getParameter("periodo")==null?"0":request.getParameter("periodo");
	
	String cicloId				= (String) session.getAttribute("cicloId");
	
	String cicloIdnew			= request.getParameter("cicloId")==null?"0":request.getParameter("cicloId");
	String periodoIdnew			= request.getParameter("periodoId")==null?"1":request.getParameter("periodoId");
	
	String accion				= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	String cicloElegido			= request.getParameter("Ciclo")==null?"0":request.getParameter("Ciclo");
	
	String mensaje				= "";	
	
	
	
	
	// Ciclo escolar elegido o activo
	if (!cicloElegido.equals("0")){
		cicloId = cicloElegido;
		session.setAttribute("cicloId", cicloId);
	}
	
	/* LISTA DE PERIODOS DE INCRIPCION */
	ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodoOriginal = cicloPeriodoL.getListCiclo(conElias, cicloIdOriginal, "ORDER BY CICLO_PERIODO.F_INICIO");
	
	ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo = cicloPeriodoL.getListCiclo(conElias, cicloIdnew, "ORDER BY CICLO_PERIODO.F_INICIO");
	boolean encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisCicloPeriodo){
		if(per.getPeriodoId().equals(periodoIdnew)){
			encontro = true;
		}
	}
	if(encontro==false && lisCicloPeriodo.size()>0){
		periodoIdnew = lisCicloPeriodo.get(0).getPeriodoId();
	}
	
	String numPagosIniciales	= aca.fin.FinPago.numPagosIniciales(conElias, cicloId, periodoIdnew);
	

	
	/* LISTA DE CICLOS ESCOLARES DE LA ESCUELA */
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloL.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID ");
	
	
	/* LISTA DE FECHAS DE COBRO*/
	ArrayList<aca.fin.FinPago> lisFinPago = finPagoL.getListCicloPeriodo(conElias, cicloIdOriginal, periodoIdOriginal, "ORDER BY FIN_PAGO.FECHA, DESCRIPCION");
	
	/* LISTA DE FECHAS DE COBRO COPIA*/
	ArrayList<aca.fin.FinPago> lisFinPagoCopia = finPagoL.getListCicloPeriodo(conElias, cicloIdnew, periodoIdnew, "ORDER BY FIN_PAGO.FECHA, DESCRIPCION");
	
	
	if(accion.equals("1")){
		for(int x=0; x<lisFinPago.size(); x++){
			System.out.println("for");
		finPago.setCicloId(cicloIdnew);
		finPago.setPeriodoId(periodoIdnew);
		finPago.setFecha(lisFinPago.get(x).getFecha());
		finPago.setDescripcion(lisFinPago.get(x).getDescripcion());
		finPago.setTipo(lisFinPago.get(x).getTipo());
		finPago.setOrden(lisFinPago.get(x).getOrden());
		
			//Busca el siguiente folio 
			finPago.setPagoId(finPago.maximoReg(conElias, cicloIdnew, periodoIdnew));			
			// inserta el registro
			if(finPago.insertReg(conElias)){
				mensaje = "Guardado";
			}else{
				mensaje = "NoGuardo";
			}
		}
%>		
		<meta http-equiv="refresh" content="0; URL='traspaso.jsp?ciclo=<%=cicloIdOriginal%>&periodo=<%=periodoIdOriginal %>&cicloId=<%=cicloIdnew%>&periodoId=<%=periodoIdnew %>'" />
<%

	}

%>



<div id="content">
	
	<h2><fmt:message key="aca.CopiarCobrosA" /><small> ( <%=cicloIdOriginal%> - <%= cicloPeriodo.periodoNombre(conElias, cicloIdOriginal, periodoIdOriginal) %> )</small></h2>
	<form id="forma" name="forma" action="traspaso.jsp" method="post">
		<div class="well">
	 		<a class="btn btn-primary"href="cobro.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
	<input type="hidden" name="Accion" value="<%=accion%>">
	<input type="hidden" name="ciclo" value="<%=cicloIdOriginal%>">
	<input type="hidden" name="periodo" value="<%=periodoIdOriginal%>">
	<div class="row">
		<div class="span5">
			<h3><fmt:message key="aca.Recibe" /></h3>
			<label><fmt:message key="aca.Ciclo" />:</label>
			<select id="ciclo" name="ciclo" style="width:360px;margin-bottom:0px;" disabled>
		<%
			for(int i = 0; i < lisCiclo.size(); i++){
				ciclo = (Ciclo) lisCiclo.get(i);
		%>
				<option value="<%=ciclo.getCicloId() %>" <%=cicloIdOriginal.equals(ciclo.getCicloId())?"selected":"" %> <%=cicloId.equals(ciclo.getCicloId())&&!cicloIdOriginal.equals(ciclo.getCicloId())?"selected":"" %>><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
		<%
			}
		%>
			</select>
			<br><br>
			<label><fmt:message key="aca.Periodo" />:</label>				
			<select id="periodo" name="periodo" disabled>
		<%		
			for(int i = 0; i < lisCicloPeriodoOriginal.size(); i++){
				cicloPeriodo = (CicloPeriodo) lisCicloPeriodoOriginal.get(i);
		%>
				<option value="<%=cicloPeriodo.getPeriodoId() %>"<%=periodoIdOriginal.equals(cicloPeriodo.getPeriodoId())?" selected":"" %>><%=cicloPeriodo.getPeriodoNombre() %></option>
		<%
			}
		%>
			</select>
			<br><br>
		<table class="table table-bordered table-striped">
			<%if(lisFinPago.size() > 0){%>
				<thead>
					<tr>
						<th>#</th>
						<th><fmt:message key="aca.Descripcion" /></th>
						<th><fmt:message key="aca.Fecha" /></th>
						<th><fmt:message key="aca.Tipo" /></th>
						<th><fmt:message key="aca.Orden" /></th>
					</tr>
				</thead>
			<%
				boolean elimina = false;
				if(!FinPago.tieneDatos(conElias, cicloIdOriginal, periodoIdOriginal))
					elimina = true;
					
					for(int i = 0; i < lisFinPago.size(); i++){
						finPago = (FinPago) lisFinPago.get(i);					 
			%>
						<tr>
							<td>
								<%=i+1 %>
							</td>
							<td><%=finPago.getDescripcion() %></td>
							<td><%=finPago.getFecha() %></td>
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
		</div>
		
		<div class="span2"><br><br><br><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="btn btn-success"><i class="icon-arrow-left icon-white"></i></a></i></div>
		
		<div class="span5">
				<h3><fmt:message key="aca.Envia" /></h3>
				<label><fmt:message key="aca.Ciclo" />:</label>
			<select id="cicloId" name="cicloId" onchange="document.location = 'traspaso.jsp?cicloId='+this.options[this.selectedIndex].value+'&ciclo=<%=cicloIdOriginal%>&periodo=<%=periodoIdOriginal%>';" style="width:360px;margin-bottom:0px;">
		<%
			for(int i = 0; i < lisCiclo.size(); i++){
				ciclo = (Ciclo) lisCiclo.get(i);
		%>
				<option value="<%=ciclo.getCicloId() %>" <%=cicloIdnew.equals(ciclo.getCicloId())?"selected":"" %> <%=cicloIdnew.equals(ciclo.getCicloId())&&!cicloIdOriginal.equals(ciclo.getCicloId())?"selected":"" %>><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
		<%
			}
		%>
			</select>
			<br><br>
			<label><fmt:message key="aca.Periodo" />:</label>				
			<select id="periodoId" name="periodoId" >
		<%		
			for(int i = 0; i < lisCicloPeriodo.size(); i++){
				cicloPeriodo = (CicloPeriodo) lisCicloPeriodo.get(i);
		%>
				<option value="<%=cicloPeriodo.getPeriodoId() %>"<%=periodoIdnew.equals(cicloPeriodo.getPeriodoId())?" selected":"" %>><%=cicloPeriodo.getPeriodoNombre() %></option>
		<%
			}
		%>
			</select>
			<br><br>
		<table class="table table-bordered table-striped">
			<%if(lisFinPagoCopia.size() > 0){%>
				<thead>
					<tr>
						<th>#</th>
						<th><fmt:message key="aca.Descripcion" /></th>
						<th><fmt:message key="aca.Fecha" /></th>
						<th><fmt:message key="aca.Tipo" /></th>
						<th><fmt:message key="aca.Orden" /></th>
					</tr>
				</thead>
			<%
				boolean elimina = false;
				if(!FinPago.tieneDatos(conElias, cicloIdnew, periodoIdnew))
					elimina = true;
					
					for(int i = 0; i < lisFinPagoCopia.size(); i++){
						finPago = (FinPago) lisFinPagoCopia.get(i);					 
			%>
						<tr>
							<td>
								<%=i+1 %>
							</td>
							<td><%=finPago.getDescripcion() %></td>
							<td><%=finPago.getFecha() %></td>
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
		</div>
	</div>
	
		<div class="well">
			<a class="btn btn-primary" href="javascript:Guardar();">
				  <i class="icon-plus icon-white"></i> <fmt:message key="boton.Copiar" />
			</a>
		</div>
	</form>
</div>
<script>
	function Guardar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%@ include file= "../../cierra_elias.jsp" %>