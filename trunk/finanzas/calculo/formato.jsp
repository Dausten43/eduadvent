<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="finCalculo" scope="page" class="aca.fin.FinCalculo"/>
<jsp:useBean id="DetalleL" scope="page" class="aca.fin.FinCalculoDetLista"/>
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="FinCalculoPagoL" scope="page" class="aca.fin.FinCalculoPagoLista"/>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,###,##0.00;-###,###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 				= (String) session.getAttribute("escuela");
	String cicloId					= (String) session.getAttribute("cicloId");
	String codigoAlumno 			= (String) session.getAttribute("codigoAlumno");
	String periodoId				= request.getParameter("PeriodoId")==null?"1":request.getParameter("PeriodoId");
	
	int nivelAlumno 				= aca.alumno.AlumPlan.getNivelAlumno(conElias, codigoAlumno);
	finCalculo.mapeaRegId(conElias, cicloId, periodoId, codigoAlumno);	
	Escuela.mapeaRegId(conElias, escuelaId);
	alumno.mapeaRegId(conElias, codigoAlumno);	
	
	ArrayList<aca.fin.FinCalculoDet> lisDetalles	=  DetalleL.getListCalDet(conElias, cicloId, periodoId, codigoAlumno,"ORDER BY CUENTA_ID");
	ArrayList<aca.fin.FinCalculoPago> listaPagos 	= FinCalculoPagoL.getListPagosAlumnoCuentas(conElias, cicloId, periodoId, codigoAlumno, " ORDER BY TO_CHAR(FECHA,'YYYY')||TO_CHAR(FECHA,'MM')||TO_CHAR(FECHA,'DD'), ORDEN_PAGO(CICLO_ID,PERIODO_ID, PAGO_ID)");	
%>

<style>
	.datosAlumno td{
		padding-right: 20px;
	}
</style>

<div id="content">	
	
	<h3>
		<%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> 
		<small>( <fmt:message key="aca.Fecha" />: <strong><%= aca.util.Fecha.getHoy() %></strong> )</small>
	</h3>	
	<div class="alert">
		<%=aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId)%> |
		 <%=aca.ciclo.CicloPeriodo.periodoNombre(conElias, cicloId, periodoId) %>	
	</div>
			
	<table class="datosAlumno">
  	  <tr>
	    <td><strong><fmt:message key="aca.Codigo" /></strong></td>
	    <td style="border-bottom: 1px solid #666666;"><%= codigoAlumno %></td>
	    <td style="width:7%;">&nbsp;</td>
	    <td><strong><fmt:message key="aca.Nombre" /></strong></td>	     
	    <td style="border-bottom: 1px solid #666666;"><%= alumno.getNombre()+" "+alumno.getApaterno()+" "+alumno.getAmaterno() %></td>
  	  </tr>
  	  <tr>
	    <td><strong><fmt:message key="aca.Plan" /></strong></td>
	    <td style="border-bottom: 1px solid #666666;"><%= aca.plan.Plan.getNombrePlan(conElias, aca.alumno.AlumPlan.getPlanActual(conElias, codigoAlumno)) %></td>
	    <td>&nbsp;</td>
	    <td><strong><fmt:message key="aca.Nivel" /></strong></td>  
	    <td style="border-bottom: 1px solid #666666;"><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, String.valueOf(nivelAlumno))%></td>
  	  </tr>
  	  <tr>
	    <td><strong><fmt:message key="aca.Grado" /></strong></td>
	    <td style="border-bottom: 1px solid #666666;"><%= aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(alumno.getGrado()))%></td>
	    <td>&nbsp;</td>
	    <td><strong><fmt:message key="aca.Grupo" /></strong></td>	     
	    <td style="border-bottom: 1px solid #666666;">" <%= alumno.getGrupo() %> "</td>
  	  </tr>
  	  <tr>
	    <td><strong><fmt:message key="aca.FormaDePago" /></strong></td>
	    <td style="border-bottom: 1px solid #666666;">
	    	<%if(finCalculo.getTipoPago().equals("P")){%>
	    		<fmt:message key="aca.PorPagos" />
	    	<%}else{%>
	    		<fmt:message key="aca.DeContado" />
	    	<%}%>
	    </td>
	    <td>&nbsp;</td>
	    <td><strong><fmt:message key="aca.ClasificacionFin" /></strong></td>	     
	    <td style="border-bottom: 1px solid #666666;"><%=aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, alumno.getClasfinId()) %></td>
  	  </tr>
	</table>
	  
	<h4><fmt:message key="aca.Costos" /></h4>	  
	
	<table class="table table-fullcondensed table-bordered">
	    <tr>
	      <th>#</th>
	      <th><fmt:message key="aca.Cuenta" /></th>
	      <th class="text-right"><fmt:message key="aca.Costo" /></th>
	      <th class="text-right"><fmt:message key="aca.Beca" /></th>
	      <th class="text-right"><fmt:message key="aca.Total" /></th>
	    </tr>
		<%	 
			
			BigDecimal impBeca		= new BigDecimal("0");
			BigDecimal impCuenta	= new BigDecimal("0");
			BigDecimal impTotal		= new BigDecimal("0");
			
			BigDecimal totBeca		= new BigDecimal("0");
			BigDecimal totCuenta	= new BigDecimal("0");
			BigDecimal totCalculo	= new BigDecimal("0");
			
			for(int j=0;j<lisDetalles.size();j++){ 
				aca.fin.FinCalculoDet detalle = (aca.fin.FinCalculoDet) lisDetalles.get(j);
				
				impBeca		= new BigDecimal("0");
				impCuenta	= new BigDecimal("0");
			
				impCuenta	= new BigDecimal(detalle.getImporte());
				impBeca 	= new BigDecimal(detalle.getImporteBeca());
				impTotal 	= impCuenta.subtract(impBeca);
			
				totBeca 	= totBeca.add(impBeca);
				totCuenta	= totCuenta.add(impCuenta);
				totCalculo	= totCalculo.add(impTotal);
		%>		
			    <tr>
			      <td><%= j+1 %></td>
			      <td><%= aca.fin.FinCuenta.getCuentaNombre(conElias, detalle.getCuentaId()) %></td>
			      <td class="text-right"><%=formato.format(impCuenta)%></td>
			      <td class="text-right"><%=formato.format(impBeca)%></td>
			      <td class="text-right"><%=formato.format(impTotal)%></td>
			    </tr>
		<%	
			} 
		%>
			<tr>
		      <th colspan="2"><fmt:message key="aca.Total" /></th>
		      <th class="text-right"><%=formato.format(totCuenta)%></th>
		      <th class="text-right"><%=formato.format(totBeca)%></th>
		      <th class="text-right"><%=formato.format(totCalculo)%></th>
		    </tr>	
		</table>
				
		<%if (finCalculo.getTipoPago().equals("P")){%>
			<h4><fmt:message key="aca.Pagos" /></h4>		    
	    		
		    <table class="table table-fullcondensed table-bordered" style="width:500px;">
		    	<tr>
		      		<th>#</th>
		      		<th><fmt:message key="aca.Fecha" /></th>
			      	<th><fmt:message key="aca.Descripcion" /></th>
			      	<th class="text-right"><fmt:message key="aca.Costo" /></th>
			      	<th class="text-right"><fmt:message key="aca.Beca" /></th>
			      	<th class="text-right"><fmt:message key="aca.Total" /></th>
			    </tr>			    
				<%
					BigDecimal totPago 		= new BigDecimal("0");
					BigDecimal costoPago 	= new BigDecimal("0");
					BigDecimal becaPago 	= new BigDecimal("0");
				
					int cont = 0;
					for(aca.fin.FinCalculoPago pago : listaPagos){
						cont++;
						totPago 	= totPago.add( new BigDecimal( pago.getImporte() ).subtract( new BigDecimal(pago.getBeca()) ) );
						costoPago 	= costoPago.add( new BigDecimal(pago.getImporte()) );
						becaPago 	= becaPago.add( new BigDecimal(pago.getBeca()) );
						
				%>
						<tr>
							<td><%=cont%></td>
		  					<td><%=pago.getFecha()%>-<%= pago.getPagoId() %></td>
			  				<td><%=aca.fin.FinPago.getDescripcion(conElias, cicloId, periodoId, pago.getPagoId())%></td>
			  				<td class="text-right"><%=pago.getImporte()%></td>
							<td class="text-right"><%=pago.getBeca()%></td>
			  				<td class="text-right"><%= formato.format(new BigDecimal(pago.getImporte()).subtract(new BigDecimal(pago.getBeca()))) %></td>
						</tr>
				<%
					} 
				%>
				<tr>
					<th colspan="3"><fmt:message key="aca.Total" /></th>
					<th class="text-right"><%=formato.format(costoPago) %></th>
					<th class="text-right"><%=formato.format(becaPago) %></th>
					<th class="text-right"><%=formato.format(totPago)%></th>
				</tr>
			</table>
			
			<p>
				Por el presente pagaré me comprometo a pagar a <%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> las cantidades citadas en los vencimientos señalados. Si no fuere cubierto a su vencimiento, causará suspensión de los servicios de enseñanza. En <%=Escuela.getDireccion() %>, a <%=aca.util.Fecha.getHoy() %>.
			</p>
			
			<br /><br /><br />
			
			<p>
				<span style="border-top:1px solid black;padding:5px 15px;">
					FIRMA DE COMPROMISO DEL PADRE O TUTOR
				</span>
			</p>
			
			
		<%}else{ %>
			<div class="alert">
				<h4><fmt:message key="aca.PagoInicial" />:  $ <%=Double.valueOf(finCalculo.getPagoInicial())%></h4>
			</div>
		<%} %>
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>