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
	function Refrescar(){
 		document.form.Accion.value = "0";
 		document.form.submit();
	}
	
	function Guardar(){
 		document.form.Accion.value = "1";
 		document.form.submit();
	}
</script>

<% 
	String escuelaId 		= (String) session.getAttribute("escuela");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	String cicloEnvia		= request.getParameter("CicloEnvia")==null?"0":request.getParameter("CicloEnvia");
	String periodoEnvia		= request.getParameter("PeriodoEnvia")==null?"0":request.getParameter("PeriodoEnvia");
	
	String cicloRecibe		= request.getParameter("CicloRecibe")==null?"0":request.getParameter("CicloRecibe");
	String periodoRecibe	= request.getParameter("PeriodoRecibe")==null?"1":request.getParameter("PeriodoRecibe");
	
	String mensaje			= "";
	
	//System.out.println("ELEGIDO : "+cicloElegido);
	
	
	/* LISTA DE PERIODOS DE INCRIPCION */
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodoEnvia 	= cicloPeriodoL.getListCiclo(conElias, cicloEnvia, "ORDER BY CICLO_PERIODO.F_INICIO");
	
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodoRecibe 	= cicloPeriodoL.getListCiclo(conElias, cicloRecibe, "ORDER BY CICLO_PERIODO.F_INICIO");
	
	boolean encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisPeriodoRecibe){
		if(per.getPeriodoId().equals(periodoRecibe)){
			encontro = true;
		}
	}
	if(encontro==false && lisPeriodoRecibe.size()>0){
		periodoRecibe = lisPeriodoRecibe.get(0).getPeriodoId();
	}
	
	//String numPagosIniciales	= aca.fin.FinPago.numPagosIniciales(conElias, cicloId, periodoIdClon);
	
	/* LISTA DE CICLOS ESCOLARES DE LA ESCUELA */
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloL.getListAll(conElias, escuelaId, " ORDER BY CICLO_ID ");
	
	
	/* LISTA DE FECHAS DE COBRO*/
	ArrayList<aca.fin.FinPago> lisFinPago = finPagoL.getListCicloPeriodo(conElias, cicloEnvia, periodoEnvia, " ORDER BY FIN_PAGO.FECHA, DESCRIPCION");
	
	/* LISTA DE FECHAS DE COBRO COPIA*/
	ArrayList<aca.fin.FinPago> lisFinPagoCopia = finPagoL.getListCicloPeriodo(conElias, cicloRecibe, periodoRecibe, " ORDER BY FIN_PAGO.FECHA, DESCRIPCION");

	
// 	if(accion.equals("0")){	//REFRESCA
// 		System.out.println("IMPRIME : "+cicloEnvia+" - "+periodoEnvia);
// 	}
	
		if(accion.equals("1")){
		for(int x=0; x<lisFinPago.size(); x++){
			System.out.println("for");
			finPago.setCicloId(cicloRecibe);
			finPago.setPeriodoId(periodoRecibe);
			finPago.setFecha(lisFinPago.get(x).getFecha());
			finPago.setDescripcion(lisFinPago.get(x).getDescripcion());
			finPago.setTipo(lisFinPago.get(x).getTipo());
			finPago.setOrden(lisFinPago.get(x).getOrden());
		
			//Busca el siguiente folio 
			finPago.setPagoId(finPago.maximoReg(conElias, cicloRecibe, periodoRecibe));			
			// inserta el registro
			if(finPago.insertReg(conElias)){
				mensaje = "Guardado";
			}else{
				mensaje = "NoGuardo";
			}
		}
%>		
		<meta http-equiv="refresh" content="0; URL='traspaso.jsp?ciclo=<%=cicloEnvia%>&periodo=<%=periodoEnvia %>&cicloId=<%=cicloRecibe%>&periodoId=<%=periodoRecibe %>'" />
<%

	}

%>
	<div id="content">
	
		<h2><fmt:message key="aca.ClonarCobros" /></h2>
		
		<form id="forma" name="forma" action="traspaso.jsp" method="post">
			<div class="well">
		 		<a class="btn btn-primary" href="cobro.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
			</div>
<%-- 			<input type="hidden" name="Accion" value="<%=accion%>"> --%>
			<input type="hidden" id="Accion" name="Accion" >
			
			<div class="row">
				<div class="span5">					
					<h3><fmt:message key="aca.Envia" /></h3>
					<label><fmt:message key="aca.Ciclo" />:</label>
					<select id="CicloEnvia" name="CicloEnvia" onchange="javascript:Refrescar();">
				<%
					for(int i = 0; i < lisCiclo.size(); i++){
						ciclo = (Ciclo) lisCiclo.get(i);
				%>
						<option value="<%=ciclo.getCicloId() %>" <% if (cicloEnvia.equals(ciclo.getCicloId())) out.print("selected");%> ><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
				<%
					}
				%>
					</select>
					<br><br>
					<label><fmt:message key="aca.Periodo" />:</label>				
					<select id="periodo" name="periodo" >
				<%		
					for(int i = 0; i < lisPeriodoEnvia.size(); i++){
						cicloPeriodo = (CicloPeriodo) lisPeriodoEnvia.get(i);
				%>
						<option value="<%=cicloPeriodo.getPeriodoId() %>" <%if (cicloPeriodo.equals(cicloPeriodo.getPeriodoId())) out.print("selected");%>><%=cicloPeriodo.getPeriodoNombre() %></option>
				<%
					}
				%>					
					</select>
			<br><br>
		<table class="table table-bordered table-striped">
			<%
			//System.out.println("MUESTRA : "+lisFinPago);
			if(lisFinPago.size() > 0){%>
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
				if(!FinPago.tieneDatos(conElias, cicloEnvia, periodoEnvia))
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
				<div class="span2"><br><br><br><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="btn btn-success"><i class="icon-arrow-right icon-white"></i></a></i></div>
				
				<div class="span5">					
					<h3><fmt:message key="aca.Recibe" /></h3>
					<label><fmt:message key="aca.Ciclo" />:</label>
					<select id="CicloRecibe" name="CicloRecibe">
				<%
					for(int i = 0; i < lisCiclo.size(); i++){
						ciclo = (Ciclo) lisCiclo.get(i);
				%>
						<option value="<%=ciclo.getCicloId() %>" <% if (cicloRecibe.equals(ciclo.getCicloId())) out.print("selected");%> ><%=ciclo.getCicloId()%> | <%=ciclo.getCicloNombre()%></option>
				<%
					}
				%>
					</select>
					<br><br>
					<label><fmt:message key="aca.Periodo" />:</label>				
					<select id="periodo" name="periodo" >
				<%		
					for(int i = 0; i < lisPeriodoRecibe.size(); i++){
						cicloPeriodo = (CicloPeriodo) lisPeriodoRecibe.get(i);
				%>
						<option value="<%=cicloPeriodo.getPeriodoId() %>" <%if (cicloPeriodo.equals(cicloPeriodo.getPeriodoId())) out.print("selected");%>><%=cicloPeriodo.getPeriodoNombre() %></option>
				<%
					}
				%>					
					</select>
			<br><br>
		<table class="table table-bordered table-striped">
			<%
			//System.out.println("MUESTRA : "+lisFinPago);
			if(lisFinPago.size() > 0){%>
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
				if(!FinPago.tieneDatos(conElias, cicloRecibe, periodoRecibe))
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




<%@ include file= "../../cierra_elias.jsp" %>