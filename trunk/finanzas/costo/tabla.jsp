<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="nivelL" scope="page" class="aca.catalogo.CatNivelLista"/>
<jsp:useBean id="finCosto" scope="page" class="aca.fin.FinCosto"/>
<jsp:useBean id="finCostoL" scope="page" class="aca.fin.FinCostoLista"/>
<jsp:useBean id="planL" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="finCuentaL" scope="page" class="aca.fin.FinCuentaLista"/>
<jsp:useBean id="clasFinL" scope="page" class="aca.catalogo.CatClasFinLista"/>

<script>
	function revisa(){
		if(document.forma.importe.value != ""){
			document.forma.Accion.value = "1";
			document.forma.submit();
		}else{
			alert("<fmt:message key='js.Completar' />");
		}
	}
	
	function modificar(costo){
		document.forma.Accion.value 	= "2";
		document.forma.costo.value 		= costo;
		document.forma.submit();
	}
	
	function eliminar(costo){
		if(confirm("<fmt:message key='js.Confirma' />")){
			document.forma.Accion.value 	= "3";
			document.forma.costo.value 		= costo;
			document.forma.submit();
		}
	}
</script>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00; -###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	
	String cicloId		= request.getParameter("ciclo")		== null ? (String) session.getAttribute("cicloId") : request.getParameter("ciclo");
	String periodoId	= request.getParameter("periodo")	== null ? "0" : request.getParameter("periodo");
	String planId		= request.getParameter("plan")		== null ? "0" : request.getParameter("plan");
	String costoId		= request.getParameter("costo")		== null ? "0" : request.getParameter("costo");
	String cuentaId		= request.getParameter("cuentaId")	== null ? "0" : request.getParameter("cuentaId");
	String clasFin		= request.getParameter("clasFin")	== null ? "0" : request.getParameter("clasFin");
	String importe		= request.getParameter("importe")	== null ? "0" : request.getParameter("importe");
	String numPagos		= request.getParameter("numPagos")	== null ? "0" : request.getParameter("numPagos");
	
	// Trae los ciclos escolares
	ArrayList<aca.ciclo.Ciclo> lisCiclo 	= cicloL.getListAll(conElias, escuelaId, "AND ESTADO NOT IN ('I') ORDER BY CICLO_ID");
	
	// Verifica que tenga un ciclo valido en session.
	if (cicloId.equals("XXXXXXX")){
		if (lisCiclo.size()>0){
			cicloId =  ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
			session.setAttribute("cicloId",cicloId);
		}	
	}
	
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String resultado 	= "";
	
	if(accion.equals("1")){	//	Guardar
		//System.out.println("Datos:"+cicloId+":"+periodoId+":"+planId+":"+cuentaId+":"+clasFin);
		if(costoId.equals("0") ){
			finCosto.setCostoId(finCosto.maxReg(conElias, cicloId));
			//System.out.println("Maximo");
		}else{
			finCosto.setCostoId(costoId);
			finCosto.mapeaRegId(conElias, cicloId, costoId);
			//System.out.println("Mapea:"+costoId);
		}
		
		finCosto.setCicloId(cicloId);
		finCosto.setPeriodoId(periodoId);		
		finCosto.setPlanId(planId);
		finCosto.setCuentaId(cuentaId);
		finCosto.setClasFinId(clasFin);
		finCosto.setImporte(importe);
		
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
		costoId = "0";

	}else if(accion.equals("2")){	// Situar todo para modificar		
		
		finCosto.mapeaRegId(conElias, cicloId, costoId);
		clasFin 	= finCosto.getClasFinId();
		cuentaId 	= finCosto.getCuentaId();
		
	}else if(accion.equals("3")){ // Borrar
		
		finCosto.setCicloId(cicloId);
		finCosto.setCostoId(costoId);
		
		// Traer el registro a borrar
		finCosto.mapeaRegId(conElias, cicloId, costoId);
		
		if (!aca.fin.FinCosto.existenDatos(conElias, cicloId, periodoId, finCosto.getCuentaId(),finCosto.getClasFinId(), finCosto.getPlanId())){					
			if(finCosto.deleteReg(conElias)){
				resultado = "Eliminado";
			}else{
				resultado = "NoElimino";
			}		
		}else{			
			resultado = "NoElimino";
		}		
		
	}
	
	pageContext.setAttribute("resultado", resultado);
%>

	
<div id="content">

	<h2><fmt:message key="aca.CostosEnsenanza" /></h2>
	
	<% if (resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
			
	<form action="tabla.jsp" id="forma" name="forma" method="post">
		
		<input type="hidden" name="Accion" />
		<input name="costo" type="hidden" value="<%=costoId%>">
		
		<div class="well">
			<fmt:message key="aca.Ciclo" />:&nbsp;
			<select class="input-xlarge" id="ciclo" name="ciclo" onchange="document.location='tabla.jsp?ciclo='+this.options[this.selectedIndex].value;" class="input-xlarge">
				<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
					<option value="<%=ciclo.getCicloId() %>" <%if(cicloId.equals(ciclo.getCicloId())){out.print("selected");} %>><%=ciclo.getCicloNombre() %></option>	
				<%}%>
			</select>
			&nbsp;&nbsp;<fmt:message key="aca.Periodo" />:&nbsp;			
			<select id="periodo" name="periodo" onchange="document.forma.submit();" class="input-xlarge">
				<% 
					ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo = cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY F_INICIO");
					if(periodoId.equals("0")){
						if(lisCicloPeriodo.size() > 0) periodoId = lisCicloPeriodo.get(0).getPeriodoId();					
					}
					for(aca.ciclo.CicloPeriodo cicloPeriodo : lisCicloPeriodo){
				%>
						<option value="<%=cicloPeriodo.getPeriodoId() %>" <%if(periodoId.equals(cicloPeriodo.getPeriodoId())){out.print("selected");} %>><%=cicloPeriodo.getPeriodoNombre() %></option>			
				<%
					}
				%>
			</select>
			&nbsp;&nbsp;<fmt:message key="aca.Plan" />:&nbsp;
			<select id="plan" name="plan" onchange="document.forma.submit();" class="input-xlarge">
				<%
					ArrayList<aca.plan.Plan> lisPlan = planL.getListPlanPermiso(conElias, cicloId, "ORDER BY NIVEL_ID");
					if(planId.equals("0")){
						if(lisPlan.size() > 0) planId = lisPlan.get(0).getPlanId();
					}
					
					for(aca.plan.Plan plan : lisPlan){
				%>
						<option value="<%=plan.getPlanId() %>" <%if(planId.equals(plan.getPlanId())){out.print("selected");} %>><%=plan.getPlanNombre() %></option>
				<%
					}
				%>
			</select>
			&nbsp;&nbsp;
			<a class="btn btn-success" href="traspaso.jsp">
				   <fmt:message key="aca.ClonarCostos" /><i class="icon-random icon-white"></i>
			</a>
		</div>
		
	  	
	  	<div class="row">
	  	
	  		<div class="span4">
	  			
	  			<div class="alert">
	  			
		  			<fieldset>
		  				<label for="cuenta"><fmt:message key="aca.Cuenta" /></label>
		  				<select id="cuentaId" name="cuentaId">
							<% 
								ArrayList<aca.fin.FinCuenta> lisCuentas = finCuentaL.getListCuentasPorTipo(conElias, escuelaId, "-ALUMNO","ORDER BY CUENTA_ID");
								for(aca.fin.FinCuenta finCuenta : lisCuentas){
							%>
									<option value="<%=finCuenta.getCuentaId()%>"<%=finCuenta.getCuentaId().equals(cuentaId)?" Selected":""%>><%=finCuenta.getCuentaNombre() %></option>	
							<%			
								} 
							%>						
				    	</select>
		  			</fieldset>
		  			
		  			<fieldset>
		  				<label for=""><fmt:message key="aca.ClasificacionFin" /></label>
		  				<select id="clasFin" name="clasFin">
							<%
								ArrayList<aca.catalogo.CatClasFin> lisClasFin = clasFinL.getListEscuela(conElias, escuelaId, "ORDER BY CLASFIN_ID");
								for(aca.catalogo.CatClasFin clas : lisClasFin){
							%>
					  				<option value="<%=clas.getClasfinId()%>"<%=clas.getClasfinId().equals(clasFin)?" Selected":""%>><%=clas.getClasfinNombre()%></option>
							<%
								} 
							%>
						</select>	
		  			</fieldset>
		  			
		  			<fieldset>
		  				<label for=""><fmt:message key="aca.ImporteTotal" /></label>
		  				<input type="text" id="importe" name="importe" value="<%=finCosto.getImporte() %>" maxlength="9" />
		  			</fieldset>
		  			
		  		</div>	
		  			
	  			<div class="well">
	  				<%if (lisCiclo.size()>0 && lisCicloPeriodo.size()>0 && lisPlan.size()>0 && lisCuentas.size()>0 && lisClasFin.size()>0){%>
				    	<a class="btn btn-primary btn-large"  onclick="revisa();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
				  	<%} %> 
	  			</div>
	  			
	  		</div>
	  		
	  		<div class="span7">	
	  			  
				<%			
					ArrayList<aca.fin.FinCosto> lisCosto = finCostoL.getListPlanCostos(conElias, cicloId, periodoId, planId, "ORDER BY PLAN_ID, CUENTA_ID, CLASFIN_ID");

					// Busca el nivel del plan de estudios
					String nivelId = aca.plan.Plan.getNivel(conElias, planId);			 
				%>			
	      		
	      		<div class="alert alert-info">
	      			<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivelId) %>
	      		</div>
	      		
	      		<table class="table table-condensed table-bordered table-striped">				
					<tr>
			  			<th><fmt:message key="aca.Accion" /></th>
					  	<th><fmt:message key="aca.Cuenta" /></th>				 
					  	<th><fmt:message key="aca.ClasificacionFin" /></th>				  
					  	<th class="text-right"><fmt:message key="aca.ImporteTotal" /></th>
					</tr>
					<%for(aca.fin.FinCosto fCosto : lisCosto){%>
							<tr>
							    <td>
							    	<a class="icon-pencil" href="javascript:modificar('<%=fCosto.getCostoId() %>');"></a>
							      	<a class="icon-remove" href="javascript:eliminar('<%=fCosto.getCostoId() %>');"></a>
							    </td>
							    <td><%=fCosto.getCuentaId()%> | <%= aca.fin.FinCuenta.getCuentaNombre(conElias, fCosto.getCuentaId()) %></td>
								<td><%=aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, fCosto.getClasFinId()) %></td>
								<td class="text-right"><%=formato.format(Double.valueOf(fCosto.getImporte()))%></td>
							</tr>
					<%}%>
				</table>
		
			</div>
		</div>	
	</form>
</div>
	
<%@ include file= "../../cierra_elias.jsp" %>