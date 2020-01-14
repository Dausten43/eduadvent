<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinMovimientosLista" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="FinCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
	
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
	
	ArrayList<aca.fin.FinMovimientos> movimientos = FinMovimientosLista.getMovimientosPolizaIngreso(conElias, ejercicioId, polizaId, " ORDER BY RECIBO_ID DESC, FECHA DESC ");
	
	/* MAP DE CUENTAS DE LA ESCUELA */
	java.util.HashMap<String, aca.fin.FinCuenta> mapCuenta 		= FinCuentaL.mapCuentasEscuela(conElias, escuelaId);
	
%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Movimientos" />
	</h2>
	
	<div class="alert alert-info">
		<fmt:message key="aca.EjercicioActual" />: <strong><%=ejercicioId.replace(escuelaId+"-","")%></strong>
	</div>
	
	<div class="well">
		<a href="ingresos.jsp" class="btn btn-primary">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	 	
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<th>Trans Reference</th>
				<th>Cod Cuenta</th>
				<th>Nombre de Cuenta</th>
				<th>TFWW</th>
				<th>Fondo</th>
				<th>Funcion</th>
				<th>Restr</th>
				<th>OrgID</th>
				<th>Who</th>
				<th>Detalles</th>
				<th>Proyecto</th>
				<th>Descripción Transaccion</th>
				<th>Cantidad</th>
				<th>Mone</th>
				<th>Flag</th>
				<th>Allctn</th>
			</tr>
		</thead>
		
		<!--  ===== MOVIMIENTOS =====  -->
		 
		<%
			java.util.HashMap<String, String> cuentasSunPlus = new java.util.HashMap<String, String>();
			cuentasSunPlus.put("621110", "ENSEÑANZA");
			cuentasSunPlus.put("622110", "INGRESOS POR INSCRIPCIÓN");
			cuentasSunPlus.put("601110", "TIENDA ESCOLAR");
			cuentasSunPlus.put("601110", "UNIFORMES ESTUDIANTES");
			cuentasSunPlus.put("671140", "INGRESOS POR OTROS SERVICIOS");
			cuentasSunPlus.put("622120", "DERECHO A EXAMEN");
			cuentasSunPlus.put("622140", "SALA DE TAREAS");
			cuentasSunPlus.put("622150", "INGRESOS CLÍNICA NACIONALES");
			cuentasSunPlus.put("671120", "RECARGO ESTUDIANTIL");
		
			boolean cuentasAsociadasConSunPlus 		= true; 
			ArrayList<String> cuentasNoAsociadas 	= new ArrayList<String>();
		
			for(aca.fin.FinMovimientos mov : movimientos){
				if(mov.getEstado().equals("C")){ continue; }
				
				float importe = Float.parseFloat(mov.getImporte());
				
				String cuentaNombre 	= mov.getCuentaId();
				String cuentaSunPlus 	= "-";
				if(mapCuenta.containsKey(mov.getCuentaId())){
					cuentaNombre 	= mapCuenta.get(mov.getCuentaId()).getCuentaNombre();
					cuentaSunPlus 	= mapCuenta.get(mov.getCuentaId()).getCuentaSunPlus();
				}
				
				if( cuentasSunPlus.containsKey(cuentaSunPlus) == false ){
					cuentasAsociadasConSunPlus = false;
					if(cuentasNoAsociadas.contains(mov.getCuentaId()) == false){
						cuentasNoAsociadas.add(mov.getCuentaId());
					}
				}
				
				
				/* ============== MOVIMIENTOS DE ENSENANZA ============== */
				
				
				if( cuentaSunPlus.equals("621110") ){
		%>
						<tr>
							<td><%=FinPoliza.getDescripcion() %></td>
							<td>370120</td>
							<td>INGRESOS DIFERIDOS POR ENSEÑANZA</td>
							<td></td>
							<td><%=aca.catalogo.CatAsociacion.getFondoIdEscuela(conElias, escuelaId) %></td>
							<td><%=aca.catalogo.CatNivelEscuela.getFuncionId(conElias, escuelaId, aca.alumno.AlumPersonal.getNivel(conElias, mov.getAuxiliar())+"")  %></td>
							<td>01</td>
							<td><%=aca.catalogo.CatEscuela.getOrgId(conElias, escuelaId) %></td>
							<td></td>
							<td></td>
							<td><%=aca.catalogo.CatEscuela.getDistrito(conElias, escuelaId) %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=FinPoliza.getDescripcion() %></td>
							<td>134ALUM01</td>
							<td>ALUMNO</td>
							<td></td>
							<td><%=aca.catalogo.CatAsociacion.getFondoIdEscuela(conElias, escuelaId) %></td>
							<td><%=aca.catalogo.CatNivelEscuela.getFuncionId(conElias, escuelaId, aca.alumno.AlumPersonal.getNivel(conElias, mov.getAuxiliar())+"")  %></td>
							<td>01</td>
							<td><%=aca.catalogo.CatEscuela.getOrgId(conElias, escuelaId) %></td>
							<td></td>
							<td></td>
							<td><%=aca.catalogo.CatEscuela.getDistrito(conElias, escuelaId) %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
		<%
				
		
				/* ============== MOVIMIENTOS DE INGRESOS POR INSCRIPCION ============== */
		
		
				}else if( cuentaSunPlus.equals("622110") ){
		%>
						<tr>
							<td><%=FinPoliza.getDescripcion() %></td>
							<td>370110</td>
							<td>INGRESOS DIFERIDOS POR INSCRIPCIÓN</td>
							<td></td>
							<td><%=aca.catalogo.CatAsociacion.getFondoIdEscuela(conElias, escuelaId) %></td>
							<td><%=aca.catalogo.CatNivelEscuela.getFuncionId(conElias, escuelaId, aca.alumno.AlumPersonal.getNivel(conElias, mov.getAuxiliar())+"")  %></td>
							<td>01</td>
							<td><%=aca.catalogo.CatEscuela.getOrgId(conElias, escuelaId) %></td>
							<td></td>
							<td></td>
							<td><%=aca.catalogo.CatEscuela.getDistrito(conElias, escuelaId) %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=FinPoliza.getDescripcion() %></td>
							<td>134ALUM01</td>
							<td>ALUMNO</td>
							<td></td>
							<td><%=aca.catalogo.CatAsociacion.getFondoIdEscuela(conElias, escuelaId) %></td>
							<td><%=aca.catalogo.CatNivelEscuela.getFuncionId(conElias, escuelaId, aca.alumno.AlumPersonal.getNivel(conElias, mov.getAuxiliar())+"")  %></td>
							<td>01</td>
							<td><%=aca.catalogo.CatEscuela.getOrgId(conElias, escuelaId) %></td>
							<td></td>
							<td></td>
							<td><%=aca.catalogo.CatEscuela.getDistrito(conElias, escuelaId) %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
		<%

		
				/* ============== MOVIMIENTOS DE LAS DEMAS CUENTAS ============== */


				}else{
		%>
						<tr>
							<td><%=FinPoliza.getDescripcion() %></td>
							<td>370120</td>
							<td>INGRESOS DIFERIDOS POR ENSEÑANZA</td>
							<td></td>
							<td><%=aca.catalogo.CatAsociacion.getFondoIdEscuela(conElias, escuelaId) %></td>
							<td><%=aca.catalogo.CatNivelEscuela.getFuncionId(conElias, escuelaId, aca.alumno.AlumPersonal.getNivel(conElias, mov.getAuxiliar())+"")  %></td>
							<td>01</td>
							<td><%=aca.catalogo.CatEscuela.getOrgId(conElias, escuelaId) %></td>
							<td></td>
							<td></td>
							<td><%=aca.catalogo.CatEscuela.getDistrito(conElias, escuelaId) %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right"><%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td><%=FinPoliza.getDescripcion() %></td>
							<td><%=cuentaSunPlus %></td>
							<td><%=cuentasSunPlus.containsKey(cuentaSunPlus)==true ? cuentasSunPlus.get(cuentaSunPlus) : "-" %></td>
							<td></td>
							<td><%=aca.catalogo.CatAsociacion.getFondoIdEscuela(conElias, escuelaId) %></td>
							<td><%=aca.catalogo.CatNivelEscuela.getFuncionId(conElias, escuelaId, aca.alumno.AlumPersonal.getNivel(conElias, mov.getAuxiliar())+"")  %></td>
							<td>01</td>
							<td><%=aca.catalogo.CatEscuela.getOrgId(conElias, escuelaId) %></td>
							<td></td>
							<td></td>
							<td><%=aca.catalogo.CatEscuela.getDistrito(conElias, escuelaId) %></td>
							<td><%=mov.getDescripcion() %> | <%=mov.getAuxiliar() %></td>
							<td class="text-right">-<%=getformato.format( importe ) %></td>
							<td>DOP1</td>
							<td></td>
							<td></td>
						</tr>
		<%					
				}
		
			}
		%>
		
	</table>
	
	<%if(cuentasAsociadasConSunPlus == false){%>
		<style>#sunPlusTable{display: none;}</style>
		
		<div class="alert alert-danger">
			<fmt:message key="aca.ErrorExportacionSunPlusCuentas" />
		</div>
		
		<table class="table table-bordered table-condensed">
			<tr>
				<th>#</th>
				<th><fmt:message key="aca.Cuenta" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
				<th><fmt:message key="aca.CuentaSunPlus" /></th>
			</tr>
			<%
				int cont = 0 ;
				for(String cuenta: cuentasNoAsociadas){
					cont++;
					String cuentaNombre 	= cuenta;
					String cuentaSunPlus 	= "-"; 
					if(mapCuenta.containsKey(cuenta)){
						cuentaNombre 	= mapCuenta.get(cuenta).getCuentaNombre();
						cuentaSunPlus 	= mapCuenta.get(cuenta).getCuentaSunPlus();
					}
			%>
				<tr>
					<td><%=cont %></td>
					<td><%=cuenta %></td>
					<td><%=cuentaNombre %></td>
					<td><%=cuentaSunPlus %></td>
				</tr>
			<%} %>
		</table>
	
	<%} %>

</div>	
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>