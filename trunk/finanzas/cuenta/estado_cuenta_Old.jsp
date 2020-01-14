<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.fin.FinMovimiento"%>
<%@page import="aca.util.Fecha"%>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="finMovimiento" scope="page" class="aca.fin.FinMovimiento"/>
<jsp:useBean id="finMovimientoL" scope="page" class="aca.fin.FinMovimientoLista"/>

<%
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String accion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String resultado	= "";
	
	if (accion.equals("0")){
		// limpiar los datos
		finMovimiento = new aca.fin.FinMovimiento();
		
	}else if(accion.equals("1")){	//Guardar
		String fecha		= request.getParameter("fecha")==null?aca.util.Fecha.getHoy():request.getParameter("fecha");
		String descripcion	= request.getParameter("descripcion");
		String importe		= request.getParameter("importe");
		String naturaleza	= request.getParameter("naturaleza");
		String referencia	= request.getParameter("referencia");
		
		finMovimiento.setCodigoId(codigoId);
		finMovimiento.setFolio(FinMovimiento.maxReg(conElias, codigoId));
		finMovimiento.setFecha(fecha);
		finMovimiento.setDescripcion(descripcion);
		finMovimiento.setImporte(importe);
		finMovimiento.setNaturaleza(naturaleza);
		finMovimiento.setReferencia(referencia);
		if(finMovimiento.insertReg(conElias)){
			resultado = "Se guar&oacute; correctamente el movimiento!!!";
		}else{
			resultado = "No se pudo guardar. Int&eacute;ntelo de nuevo!";
		}
		finMovimiento = new FinMovimiento();
	}else if(accion.equals("2")){	// Borrar
		String folio = request.getParameter("folio");
		
		finMovimiento.setCodigoId(codigoId);
		finMovimiento.setFolio(folio);
		if(finMovimiento.deleteReg(conElias)){
			resultado = "Se borr&oacute; correctamente el movimiento!!!";
		}else{
			resultado = "No se pudo borrar. Int&eacute;ntelo de nuevo!";
		}
	}else if(accion.equals("3")){	// Carga los datos a modificar
		String folio = request.getParameter("folio");		
		finMovimiento.mapeaRegId(conElias, codigoId, folio);
	}else if(accion.equals("4")){	// Modificar
		String folio		= request.getParameter("folio");
		String fecha 		= request.getParameter("fecha");
		String descripcion	= request.getParameter("descripcion");
		String importe		= request.getParameter("importe");
		String naturaleza	= request.getParameter("naturaleza");
		String referencia	= request.getParameter("referencia");
		
		finMovimiento.mapeaRegId(conElias, codigoId, folio);
		finMovimiento.setDescripcion(descripcion);
		finMovimiento.setImporte(importe);
		finMovimiento.setNaturaleza(naturaleza);
		finMovimiento.setReferencia(referencia);
		finMovimiento.setFecha(fecha);
		if(finMovimiento.updateReg(conElias)){
			resultado = "Se modific&oacute; correctamente el movimiento!!!";
		}else{
			resultado = "No se pudo modificar. Int&eacute;ntelo de nuevo!";
		}
		finMovimiento = new FinMovimiento();
	}
	alumPersonal.mapeaRegId(conElias, codigoId);
%>
<head>
<script type="text/javascript" src="../../js/popcalendar.js"></script>
<script type="text/javascript">
	function revisa(){
		if(document.forma.descripcion.value != "" &&
			document.forma.importe.value != ""){
			document.forma.action = document.forma.action + "?Accion=<%=(accion.equals("0") || accion.equals("2"))?"1":accion.equals("3")?"4":"1" %>";
<%			if(accion.equals("3")){ %>
				document.forma.action += "&folio=<%=request.getParameter("folio") %>";
<%			} %>
				return true;
		}else{
			alert("Necesita llenar por lo menos la descripcion y el importe para poder guardar");
		}
		return false;
	}
	
	function nuevo(){
		document.forma.action = document.forma.action + "?Accion=0";
		return true;		
	}
			
	function borrar(folio){
		if(confirm("¿Está seguro que desea eliminar el movimiento?")){
			document.forma.action += "?Accion=2&folio="+folio;
			document.forma.submit();
		}
	}
			
	function modificar(folio){
		document.location = "estado_cuenta.jsp?Accion=3&folio="+folio;
	}
</script>
</head>
<body>
	<div id="content">
		<h2>Estado de cuenta <small>[<%=codigoId %>] <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %> <%=alumPersonal.getNombre() %></small></h2>
		<form id="forma" name="forma" action="estado_cuenta.jsp" method="post">
		<div class="row">
			<div class="span6">
				<fieldset>
					<div class="control-group ">
						<label>Fecha</label>
						<input id="fecha" name="fecha" type="text" value="<%=finMovimiento.getFecha() %>" maxlength="10" size="10" />
				        <img id="calgif" alt="calendario" src="../../imagenes/calendario.gif" onClick="javascript:showCalendar(this, document.getElementById('fecha'), 'dd/mm/yyyy',null,1,-1,-1);" style="cursor:pointer">		
					</div>
				</fieldset>
				
			</div>
			<div class="span6">
				<fieldset>
					<div class="control-group">
						<label>Descripción</label>
						<input id="descripcion" name="descripcion" type="text" value="<%=finMovimiento.getDescripcion() %>" maxlength="70" size="40" />
					</div>
				</fieldset>
			</div>
			<div class="span6">
				<fieldset>
					<label>Referencia</label>
					<%
						if(finMovimiento.getNaturaleza().equals("C") || finMovimiento.getNaturaleza().equals("")){
					%>
					<input id="referencia" name="referencia" type="text" value="<%=finMovimiento.getReferencia() %>" maxlength="20" size="20" />
					<%
						}else{
					%>
					<input id="referencia" name="referencia" type="hidden" value="<%=finMovimiento.getReferencia() %>" />
												----
					<%
						}
					%>
				</fieldset>
			</div>
			<div class="span6">
				<fieldset>
				<label>Tipo</label>
					<%
						if(finMovimiento.getNaturaleza().equals("")){
					%>
					<select id="naturaleza" name="naturaleza">
						<option value="D"<%=finMovimiento.getNaturaleza().equals("D")?" Selected":"" %>>Cargo</option>
						<option value="C"<%=finMovimiento.getNaturaleza().equals("C")?" Selected":"" %>>Crédito</option>
					</select>
					<%
						}else{
					%>
					<input id="naturaleza" name="naturaleza" type="hidden" value="<%=finMovimiento.getNaturaleza() %>" />
												<%=finMovimiento.getNaturaleza().equals("D")?"Cargo":"Credito" %>
					<%
						}
					%>
				</fieldset>
			</div>
			<div class="span6">
				<fieldset>
					<label>Importe</label>
					<input id="importe" name="importe" type="text" value="<%=finMovimiento.getImporte() %>" maxlength="8" size="10" />
				</fieldset>
			</div>
			
		</div>
		<div class="well">
			<div class="row">
				<div class="span4">
					<fieldset>
						<button class="btn btn-primary" onclick="return nuevo();"><i class="icon-plus icon-white"></i> Nuevo</button>
						<button class="btn btn-primary" onclick="return revisa();"><i class="icon-ok icon-white"></i> Grabar</button>
					</fieldset>
				</div>
			</div>	
		</div>
		<table align="center" width="80%">
		  <tr>
			<td align="center"><font size="3"><b></b></font></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  
					<td align="center">
						<table width="100%" class="table table-condensed" align="center" >
						
							<tr>
								<th width="10%">Operación</th>
								<th>#</th>
								<th>Fecha</th>
								<th>Descripción</th>
								<th>Referencia</th>						
								<th>Cargo</th>
								<th>Crédito</th>
								<th>Saldo</th>
							</tr>
		<%
			float total = 0f;
			java.text.DecimalFormat formato= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
			ArrayList lisMovimientos = finMovimientoL.getListAlumno(conElias, codigoId, "ORDER BY TO_CHAR(FECHA,'YYYY'),TO_CHAR(FECHA,'MM'),TO_CHAR(FECHA,'DD'), FOLIO");
			for(int i = 0; i < lisMovimientos.size(); i++){
				finMovimiento = (FinMovimiento) lisMovimientos.get(i);
				
				if((finMovimiento.getImporte()==null)&&(finMovimiento.getNaturaleza()==null)){
					finMovimiento.setImporte("0");
					finMovimiento.setNaturaleza("");					
				}
				
				if(finMovimiento.getNaturaleza().equals("D")){
					total -= Float.parseFloat(finMovimiento.getImporte());
				}else{
					total += Float.parseFloat(finMovimiento.getImporte());
				}	
		%>
							<tr>
								<td align="center">
									<a class="icon-pencil" href="javascript:modificar('<%=finMovimiento.getFolio()%>')"></a>
									<a class="icon-remove" href="javascript:borrar('<%=finMovimiento.getFolio()%>')"></a>
								</td>
								<td><%=i+1 %></td>
								<td><%=finMovimiento.getFecha() %></td>
								<td><%=finMovimiento.getDescripcion() %></td>
								<td><%=finMovimiento.getReferencia() %></td>						
								<td align="right"><%=finMovimiento.getNaturaleza().equals("D")?formato.format(Float.parseFloat(finMovimiento.getImporte())):"" %></td>
								<td align="right"><%=finMovimiento.getNaturaleza().equals("C")?formato.format(Float.parseFloat(finMovimiento.getImporte())):"" %></td>
								<td align="right"><%=formato.format(total) %></td>
							</tr>
		<%
			}
			if(lisMovimientos.size() == 0){
		%>
							<tr>
								<td colspan="7" align="center">No existen movimientos para este alumno</td>
							</tr>
		<%
			}
		%>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>