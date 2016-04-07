<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="PlanLista" class="aca.plan.PlanLista" scope="page" />
<jsp:useBean id="CicloLista" class="aca.ciclo.CicloLista" scope="page" />
<jsp:useBean id="AlumLista" class="aca.alumno.AlumPersonalLista" scope="page" />
<jsp:useBean id="Alum" class="aca.alumno.AlumPersonal" scope="page" />
<jsp:useBean id="AlumPlan" class="aca.alumno.AlumPlan" scope="page" />

<script>
	function Buscar() {
		document.forma.Accion.value = "1";
		document.forma.submit();
	}

	function Promover() {
		if (document.forma.PlanId2.value != "Selecciona" && document.forma.grado2 != null && document.forma.grupo2 != null) {
			document.forma.Accion.value = "2";
			document.forma.submit();
		} else {
			alert("<fmt:message key="aca.CompletaCampos"/>");
		}
	}

	function seleccionarTodos(checkAll) {
		var inputs = document.getElementsByTagName("INPUT");
		for (i = 0; i < inputs.length; i++) {
			if (inputs[i].type == "checkbox") {
				inputs[i].checked = checkAll.checked;
			}
		}
	}
</script>

<%
	String escuelaId	= (String) session.getAttribute("escuela");
	String fecha 		= aca.util.Fecha.getHoy();
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String ciclo			= request.getParameter("ciclo");	
	String planId	 		= request.getParameter("PlanId")==null?"Selecciona":request.getParameter("PlanId");
	String grado	 		= request.getParameter("grado")==null?"":request.getParameter("grado");
	String grupo	 		= request.getParameter("grupo")==null?"":request.getParameter("grupo").toUpperCase();
	
	String planId2	 		= request.getParameter("PlanId2")==null?"Selecciona":request.getParameter("PlanId2");
	String grado2	 		= request.getParameter("grado2")==null?"":request.getParameter("grado2");
	String grupo2	 		= request.getParameter("grupo2")==null?"":request.getParameter("grupo2").toUpperCase();	
	
	int cont 				= 0;
	int num 				= 0;
	int contadorArreglo 	= 0;	
	
	String nivelId			= "0";
	String sResultado		= "";
	
	ArrayList<aca.plan.Plan> lisPlan		= PlanLista.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
	ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, " ORDER BY CICLO_ID");
	String [] arreglo 						= new String[0];// arreglo para guardar codigos_id a promover
	
	if(accion.equals("2")){
		
		ArrayList<aca.alumno.AlumPersonal> lisPro2	= AlumLista.getListPromover(conElias, escuelaId, ciclo, planId, grado, grupo, "ORDER BY NOMBRE");
		arreglo 			= new String[lisPro2.size()];
		
		/* BEGIN TRANSACTION */
		conElias.setAutoCommit(false);
		boolean error = false;
		
		for (int i=0; i< lisPro2.size(); i++){
			aca.alumno.AlumPersonal alum = (aca.alumno.AlumPersonal) lisPro2.get(i);
			String alumnoSeleccionado = request.getParameter("Alum"+ (alum.getCodigoId()));
		
			if(alumnoSeleccionado!=null){// PROMOVER
		
				// DESACTIVAR EL PLAN ANTERIOR (SI ES QUE ES DIFERENTE AL NUEVO)
				AlumPlan.setCodigoId(alum.getCodigoId());
				AlumPlan.setPlanId(planId);
				if (AlumPlan.existeReg(conElias) && !planId.equals(planId2) ){
					if (AlumPlan.updateRegDesactivarPlan(conElias, alum.getCodigoId(), planId)){
						//Se desactivo correctamente						
					}else{
						error = true;
					}
				}
		
				// ACTUALIZAMOS DATOS EN ALUM_PLAN
				AlumPlan.setCodigoId(alum.getCodigoId());
				AlumPlan.setPlanId(planId2);
				if (AlumPlan.existeReg(conElias)){
					AlumPlan.mapeaRegId(conElias, alum.getCodigoId(), planId2);
					AlumPlan.setGrado(grado2);
					AlumPlan.setGrupo(grupo2);
					AlumPlan.setEstado("1");
					if (AlumPlan.updateReg(conElias)){
						//Se mofico en Alum_plan				
					}else{
						error = true;
					}
				}else{
					AlumPlan.setCodigoId(alum.getCodigoId());
					AlumPlan.setFInicio(fecha);
					AlumPlan.setEstado("1");
					AlumPlan.setPlanId(planId2);							
					AlumPlan.setGrado(grado2);
					AlumPlan.setGrupo(grupo2);
					if (AlumPlan.insertReg(conElias)){
						//Se grabo en Alum_plan						
					}else{
						error = true;
					}
				}
								
				// ACUTALIZAMOS DATOS EN ALUM_PERSONAL
				if (error == false){
					nivelId = aca.plan.Plan.getNivel(conElias, planId2);
					Alum.setCodigoId(alum.getCodigoId());
					Alum.setNivelId(nivelId);
					Alum.setGrado(grado2);
					Alum.setGrupo(grupo2);
					if(Alum.existeReg(conElias)){
						if (Alum.updateRegPromover(conElias)){
							num++;
							arreglo[contadorArreglo] = alum.getCodigoId();
							contadorArreglo++;
						}else{							
							error = true;
						}
					}else{
						error = true;
					}	
				}
				
			}//End if alumno seleccionado		  
		}//End for que recorre alumnos
		
		
		if(error == true){
			conElias.rollback();
			sResultado = "NoGuardo";
		}else{
			conElias.commit();
			sResultado = "Guardado";
		}
		
		/* END TRANSACTION */
		conElias.setAutoCommit(true);
		
	}
	
	pageContext.setAttribute("resultado", sResultado);
%>


<div id="content">

	<form action="promover.jsp" method="post" name="forma">
		<input type="hidden" name="Accion">
	
		<h3><fmt:message key="boton.Buscar" /></h3>
		
		<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
	   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
	  	<% }else if(!sResultado.equals("")){%>
	  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
	  	<%} %>
		
		<hr />
	
		<div class="row">
			<div class="span4">
				
					<fieldset>
						<label> <fmt:message key="aca.Ciclo" /></label> 
						<select name="ciclo" id="ciclo" style="width: 310px;" onchange="refreshPlan();">
							<option value="Selecciona" selected><fmt:message key="aca.SeleccionaP" /></option>
							<%for(aca.ciclo.Ciclo cic : lisCiclo){%>
								<option value="<%=cic.getCicloId() %>" <%if (cic.getCicloId().equals(ciclo)){ out.print("selected"); } %>><%=cic.getCicloNombre() %></option>
							<%}%>
						</select>
					</fieldset>
					<fieldset>
						<label> <fmt:message key="aca.Plan"/> </label>
						<select name="PlanId" id="PlanId">
							<option value="Selecciona" selected><fmt:message key="aca.SeleccionaP" /></option>
							<%for(aca.plan.Plan plan : lisPlan){%>
								<option value="<%=plan.getPlanId() %>" <%if (plan.getPlanId().equals(planId)){ out.print("selected"); } %>><%=plan.getPlanNombre() %></option>
							<%} %>	
						</select>
					</fieldset>
					<fieldset>
						<label> <fmt:message key="aca.Grado" /> </label> 
						<input name="grado" type="text" id="grado" size="3" maxlength="2" value="<%=grado%>">
					</fieldset>
					<fieldset>	
						<label> <fmt:message key="aca.Grupo" /> </label> 
						<input name="grupo" type="text" id="grupo" size="3" maxlength="2" value="<%=grupo%>">
					</fieldset>
					
					<div class="well">
						<a class="btn btn-primary" id="buscar" onclick="javascript:Buscar()">
							<i class="icon-search icon-white"></i> <fmt:message key="boton.Buscar" />
						</a>
					</div>
				
			</div>
			
			<div class="span4">
				<%
					if(accion.equals("1")||accion.equals("2")){ 
				  	ArrayList<aca.alumno.AlumPersonal> lisPro	= AlumLista.getListPromover(conElias, escuelaId, ciclo, planId, grado, grupo, "ORDER BY NOMBRE");
				%>
					<table class="table table-condensed table-bordered">
						<tr>
							<th width="1%">
								<input name="CheckAll" type="checkbox" value="S" checked onclick='javascript:seleccionarTodos(CheckAll)'>
							</th>
							<th width="5%">#</th>
							<th width="8%"><fmt:message key="aca.Matricula" /></th>
							<th width="30%"><fmt:message key="aca.Nombre" /></th>
							<th width="2%"><fmt:message key="aca.Edad" /></th>
						</tr>
						<%int contador = 0; %>
						<%for (aca.alumno.AlumPersonal alum : lisPro){%>
							<%contador++; %>
							<tr>
								<td><input type="checkbox" id="alum" name="Alum<%=alum.getCodigoId()%>" value="<%=alum.getCodigoId()%>" /></td>
								<td><%=contador%></td>
								<td><%=alum.getCodigoId()%></td>
								<td><%=alum.getNombre()+" "+alum.getApaterno()+" "+alum.getAmaterno()%></td>
								<td><%=alum.getEdad(conElias, alum.getCodigoId())%></td>
							</tr>
						<%}%>
					</table>
				<%
					}
				%>
			</div>
		</div>
		
		<%if(accion.equals("1")||accion.equals("2")){%>
			<h3><fmt:message key="aca.Promover" /></h3>
		
			<hr />
		<%} %>
		
		<div class="row">
			<div class="span4">
				
				<%if(accion.equals("1")||accion.equals("2")){%>
						
						<fieldset>
							<label><fmt:message key="aca.Plan" /></label>
							<select name="PlanId2" id="PlanId2">
								<option value="Selecciona" selected><fmt:message key="aca.SeleccionaP" /></option>
								<%for(aca.plan.Plan plan : lisPlan){%>
									<option value="<%=plan.getPlanId() %>" <%if (plan.getPlanId().equals(planId2)){ out.print("selected"); } %>><%=plan.getPlanNombre() %></option>
								<%} %>
							</select>
						</fieldset>
						
						<fieldset>
							<label><fmt:message key="aca.Grado" /></label>
							<input name="grado2" type="text" id="grado2" size="3" maxlength="2" value="<%=grado2%>">
						</fieldset>
						
						<fieldset>
							<label><fmt:message key="aca.Grupo" /></label>
							<input name="grupo2" type="text" id="grupo2" size="3" maxlength="2" value="<%=grupo2%>">
						</fieldset>
						
						<div class="well">
							<a class="btn btn-primary" onclick="Promover()">
								<i class="icon icon-ok icon-white"></i> <fmt:message key="boton.Promovers" />
							</a>
						</div>
						
				<%}%>
				
			</div>
			
			<div class="span4">
				
				<%
					if(accion.equals("2")){
						ArrayList<aca.alumno.AlumPersonal> lisPro3	= AlumLista.getListPromover(conElias, escuelaId, ciclo, planId2, grado2, grupo2, "ORDER BY NOMBRE");
				%>
						<table class="table table-bordered table-condesed">
							<tr>
								<th width="5%">#</th>
								<th width="8%"><fmt:message key="aca.Matricula" /></th>
								<th width="30%"><fmt:message key="aca.Nombre" /></th>
							</tr>
							<%
								int conta = 0;
								for (aca.alumno.AlumPersonal alum : lisPro3){
									boolean promovido = false;
									conta++;
									for(int k=0; k<arreglo.length; k++){
										String temp = arreglo[k];
										if(temp==null){
											temp="";
										}
										if(temp.equals(alum.getCodigoId())){
											promovido = true;
										}
									}
							%>
									<tr>
										<td <%if(promovido==true){%> style="color: red" <%}%>><%=conta%></td>
										<td <%if(promovido==true){%> style="color: red" <%}%>><%=alum.getCodigoId()%></td>
										<td <%if(promovido==true){%> style="color: red" <%}%>><%=alum.getNombre()+" "+alum.getApaterno()+" "+alum.getAmaterno()%></td>
									</tr>
							<%
								}	
							%>

					</table> 
				<%
					}
				%>
				
			</div>
		</div>
		
	</form>
</div>

<script>
	function refreshPlan() {

		jQuery('#PlanId').html('<option>Actualizando</option>');

		var ciclo = document.forma.ciclo.value;

		jQuery.get('getPlanes.jsp?ciclo=' + ciclo, function(data) {
			jQuery("#PlanId").html(data);
		});

	}
</script>
<%@ include file="../../cierra_elias.jsp"%>
