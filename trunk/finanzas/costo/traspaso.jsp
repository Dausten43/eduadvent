<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>
<%@page import="aca.fin.FinPago"%>

<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="nivelL" scope="page" class="aca.catalogo.CatNivelLista"/>
<jsp:useBean id="finCosto" scope="page" class="aca.fin.FinCosto"/>
<jsp:useBean id="finCostoL" scope="page" class="aca.fin.FinCostoLista"/>
<jsp:useBean id="planL" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="finCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="clasFinL" scope="page" class="aca.catalogo.CatClasFinLista"/>
 
<script>
	function Refrescar(){
 		document.forma.Accion.value = "0";
 		document.forma.submit();
	}
	
	function Guardar(){
 		document.forma.Accion.value = "1";
 		document.forma.submit();
	}
</script>

<% 
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00; -###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String accion			= request.getParameter("Accion")		==null?"0":request.getParameter("Accion");
	
	String cicloEnvia		= request.getParameter("CicloEnvia")	==null? (String) session.getAttribute("cicloId") : request.getParameter("CicloEnvia");
	String periodoEnvia		= request.getParameter("PeriodoEnvia")	==null?"0":request.getParameter("PeriodoEnvia");
	String planEnvia		= request.getParameter("PlanEnvia")		==null?"0":request.getParameter("PlanEnvia");
	
	String cicloRecibe		= request.getParameter("CicloRecibe")	==null? (String) session.getAttribute("cicloId") : request.getParameter("CicloRecibe");
	String periodoRecibe	= request.getParameter("PeriodoRecibe")	==null?"0":request.getParameter("PeriodoRecibe");
	String planRecibe		= request.getParameter("PlanRecibe")	==null?"0":request.getParameter("PlanRecibe");
	
	String resultado 	= "";

	
	/* LISTA DE CICLOS ESCOLARES DE LA ESCUELA */
	ArrayList<aca.ciclo.Ciclo> lisCiclo 	= cicloL.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID");
	
	/* LISTA DE PERIODOS */
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodoEnvia 	= cicloPeriodoL.getListCiclo(conElias, cicloEnvia, "ORDER BY F_INICIO");
	ArrayList<aca.ciclo.CicloPeriodo> lisPeriodoRecibe 	= cicloPeriodoL.getListCiclo(conElias, cicloRecibe, "ORDER BY F_INICIO");
	
	// Verifica que tenga un ciclo valido en session.
	if (cicloEnvia.equals("XXXXXXX")){
		if (lisCiclo.size()>0){
			cicloEnvia =  ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
			session.setAttribute("cicloEnvia",cicloEnvia);
		}	
	}
	
	// Verifica que tenga un ciclo valido en session.
		if (cicloRecibe.equals("XXXXXXX")){
			if (lisCiclo.size()>0){
				cicloRecibe =  ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
				session.setAttribute("cicloRecibe",cicloRecibe);
			}	
		}
	
	/* LISTA DE PLANES */
 	ArrayList<aca.plan.Plan> lisPlanEnvia	 = planL.getListPlanPermiso(conElias, cicloEnvia, "ORDER BY NIVEL_ID");
 	ArrayList<aca.plan.Plan> lisPlanRecibe   = planL.getListPlanPermiso(conElias, cicloRecibe, "ORDER BY NIVEL_ID");
 	
 	ArrayList<aca.fin.FinCosto> lisCostoEnvia = finCostoL.getListPlanCostos(conElias, cicloEnvia, periodoEnvia, planEnvia, "ORDER BY PLAN_ID, CUENTA_ID, CLASFIN_ID");
	String nivelIdEnvia = aca.plan.Plan.getNivel(conElias, planEnvia);
	
	ArrayList<aca.fin.FinCosto> lisCostoRecibe = finCostoL.getListPlanCostos(conElias, cicloRecibe, periodoRecibe, planRecibe, "ORDER BY PLAN_ID, CUENTA_ID, CLASFIN_ID");
	String nivelIdRecibe = aca.plan.Plan.getNivel(conElias, planRecibe);	
	

	
	
	boolean encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisPeriodoEnvia){
		if(per.getPeriodoId().equals(periodoEnvia)){
			encontro = true;
		}
	}
	if(encontro==false && lisPeriodoEnvia.size()>0){
		periodoEnvia = lisPeriodoEnvia.get(0).getPeriodoId();
	}
	
    encontro = false;
	for(aca.ciclo.CicloPeriodo per : lisPeriodoRecibe){
		if(per.getPeriodoId().equals(periodoRecibe)){
			encontro = true;
		}
	}
	if(encontro==false && lisPeriodoRecibe.size()>0){
		periodoRecibe = lisPeriodoRecibe.get(0).getPeriodoId();
	}
	
	encontro = false;
	for(aca.plan.Plan per : lisPlanEnvia){
		if(per.getPlanId().equals(planEnvia)){
			encontro = true;
		}
	}
	if(encontro==false && lisPlanEnvia.size()>0){
		planEnvia = lisPlanEnvia.get(0).getPlanId();
	}
	
	encontro = false;
	for(aca.plan.Plan per : lisPlanRecibe){
		if(per.getPlanId().equals(planRecibe)){
			encontro = true;
		}
	}
	if(encontro==false && lisPlanRecibe.size()>0){
		planRecibe = lisPlanRecibe.get(0).getPlanId();
	}
	
	if(accion.equals("1")){	//	Guardar
	
		for(aca.fin.FinCosto registro : lisCostoEnvia){
			
			if(registro.getCostoId().equals("0") ){
				finCosto.setCostoId(finCosto.maxReg(conElias, cicloRecibe));
				//System.out.println("Maximo");
			}else{
				finCosto.setCostoId(registro.getCostoId());
				finCosto.mapeaRegId(conElias, cicloRecibe, registro.getCostoId());
				//System.out.println("Mapea:"+costoId);
			}
			
			finCosto.setCicloId(cicloRecibe);
			finCosto.setPeriodoId(periodoRecibe);		
			finCosto.setPlanId(planRecibe);
			finCosto.setCuentaId(registro.getCuentaId());
			finCosto.setClasFinId(registro.getClasFinId());
			finCosto.setImporte(registro.getImporte());
			
			if(!finCosto.existeReg(conElias)){
				if(!finCosto.existeCuenta(conElias)){
					if(finCosto.insertReg(conElias)){
						resultado = "Guardado";
					}else{ 
						resultado = "NoGuardo";
					}
				}else{
					resultado = "EstaCuentaYaAsignada";
				}
			}else{
				if(finCosto.updateReg(conElias)){
					resultado = "Modificado";
				}else{
					resultado = "NoModifico";
				}
			}
// 			costoId = "0";	
			
		}

	}
	
	pageContext.setAttribute("resultado", resultado);
%>	

<div id="content">	
	<h2><fmt:message key="aca.ClonarCostos" /></h2>
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	<form id="forma" name="forma" action="traspaso.jsp" method="post">
		<div class="well">
			<a class="btn btn-primary" href="tabla.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
		<input type="hidden" id="Accion" name="Accion">
			
		<div class="row">
			<div class="span5">					
				<h3><fmt:message key="aca.Envia" /></h3>
				<label><fmt:message key="aca.Ciclo" />:</label>
				<select id="CicloEnvia" name="CicloEnvia" onchange="javascript:Refrescar();" class="input-xlarge">
			<%
			for(aca.ciclo.Ciclo ciclo : lisCiclo){					
			%>
					<option value="<%=ciclo.getCicloId() %>" <% if (cicloEnvia.equals(ciclo.getCicloId())) out.print("selected");%> ><%=ciclo.getCicloNombre()%></option>
			<%
				}
			%>
				</select>
				<br><br>
				<label><fmt:message key="aca.Periodo" />:</label>				
				<select id="PeriodoEnvia" name="PeriodoEnvia" onchange="javascript:Refrescar();" class="input-xlarge">
			<%		
				for(aca.ciclo.CicloPeriodo periodo :lisPeriodoEnvia){
			%>
					<option value="<%=periodo.getPeriodoId() %>" <%if (periodoEnvia.equals(periodo.getPeriodoId())) out.print("selected");%>><%=periodo.getPeriodoNombre() %></option>
			<%
				}
			%>					
				</select>
				<br><br>
				<label><fmt:message key="aca.Plan" />:</label>
				<select id="PlanEnvia" name="PlanEnvia" onchange="javascript:Refrescar();" class="input-xlarge">
				<%
				if(planEnvia.equals("0")){
					if(lisPlanEnvia.size() > 0) planEnvia = lisPlanEnvia.get(0).getPlanId();
				}
					for(aca.plan.Plan plan : lisPlanEnvia){
				%>
						<option value="<%=plan.getPlanId() %>" <%if(planEnvia.equals(plan.getPlanId())){out.print("selected");} %>><%=plan.getPlanNombre() %></option>
				<%
					}
				%>
				</select>
				<br><br>
				<table class="table table-condensed table-bordered table-striped">	
				<%if(lisCostoEnvia.size() > 0){%>	
					<thead>		
						<tr>
						  	<th><fmt:message key="aca.Cuenta" /></th>				 
						  	<th><fmt:message key="aca.ClasificacionFin" /></th>				  
						  	<th class="text-right"><fmt:message key="aca.ImporteTotal" /></th>
						</tr>
					</thead>	
					<%for(aca.fin.FinCosto fCosto : lisCostoEnvia){%>
							<tr>
							    <td><%=fCosto.getCuentaId()%> | <%= aca.fin.FinCuenta.getCuentaNombre(conElias, fCosto.getCuentaId()) %></td>
								<td><%=aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, fCosto.getClasFinId()) %></td>
								<td class="text-right"><%=formato.format(Double.valueOf(fCosto.getImporte()))%></td>
							</tr>
					<%}
				}else{
			%>
					<tr><td>No hay costos para este plan</td></tr>
			<%
				}
			%>
				</table>		
			</div>
			<div class="span2"><br><br><br><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="btn btn-success"><i class="icon-arrow-right icon-white"></i></a></i></div>
				
			<div class="span5">					
				<h3><fmt:message key="aca.Recibe" /></h3>
				<label><fmt:message key="aca.Ciclo" />:</label>
				<select id="CicloRecibe" name="CicloRecibe" onchange="javascript:Refrescar();" class="input-xlarge">
			<%
				for(aca.ciclo.Ciclo ciclo : lisCiclo){	
			%>
					<option value="<%=ciclo.getCicloId() %>" <% if (cicloRecibe.equals(ciclo.getCicloId())) out.print("selected");%> ><%=ciclo.getCicloNombre()%></option>
			<%
				}
			%>
				</select>
				<br><br>
				<label><fmt:message key="aca.Periodo" />:</label>				
				<select id="PeriodoRecibe" name="PeriodoRecibe" onchange="javascript:Refrescar();" class="input-xlarge">
			<%		
				for(aca.ciclo.CicloPeriodo periodo :lisPeriodoRecibe){
			%>
					<option value="<%=periodo.getPeriodoId() %>" <%if (periodoRecibe.equals(periodo.getPeriodoId())) out.print("selected");%>><%=periodo.getPeriodoNombre() %></option>
			<%
				}
			%>					
				</select>
				<br><br>
				<label><fmt:message key="aca.Plan" />:</label>
				<select id="PlanRecibe" name="PlanRecibe" onchange="javascript:Refrescar();" class="input-xlarge">
				<%
				if(planRecibe.equals("0")){
					if(lisPlanRecibe.size() > 0) planRecibe = lisPlanRecibe.get(0).getPlanId();
				}
					for(aca.plan.Plan plan : lisPlanRecibe){
				%>
						<option value="<%=plan.getPlanId() %>" <%if(planRecibe.equals(plan.getPlanId())){out.print("selected");} %>><%=plan.getPlanNombre() %></option>
				<%
					}
				%>
				</select>
				<br><br>
				<table class="table table-condensed table-bordered table-striped">	
				<%
			if(lisCostoRecibe.size() > 0){%>
					<thead>			
						<tr>
						  	<th><fmt:message key="aca.Cuenta" /></th>				 
						  	<th><fmt:message key="aca.ClasificacionFin" /></th>				  
						  	<th class="text-right"><fmt:message key="aca.ImporteTotal" /></th>
						</tr>
					</thead>
					<%for(aca.fin.FinCosto fCosto : lisCostoRecibe){%>
							<tr>
							    <td><%=fCosto.getCuentaId()%> | <%= aca.fin.FinCuenta.getCuentaNombre(conElias, fCosto.getCuentaId()) %></td>
								<td><%=aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, fCosto.getClasFinId()) %></td>
								<td class="text-right"><%=formato.format(Double.valueOf(fCosto.getImporte()))%></td>
							</tr>
					<%}
				}else{
			%>
					<tr><td>No hay costos para este plan</td></tr>
			<%
				}
			%>
				</table>					
			</div>		
		</div>			
		<div class="well">
			<%
			if(!cicloEnvia.equals(cicloRecibe)){						 
			%>
				<a class="btn btn-primary" href="javascript:Guardar();">
					  <i class="icon-plus icon-white"></i> <fmt:message key="boton.Copiar" />
				</a>
			<%
			}				 
			%>
		</div>	
	</form>
</div>	

<%@ include file= "../../cierra_elias.jsp" %>