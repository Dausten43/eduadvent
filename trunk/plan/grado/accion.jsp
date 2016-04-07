<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="catNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<script>
	function Grabar(){
		if ( document.frmPlan.PlanNombre.value!="" ){
			document.frmPlan.Accion.value="1";
			document.frmPlan.submit();		
		}
	}
</script>

<%
	

	// Declaración de variables
	String planId	 		= request.getParameter("PlanId");
	String escuelaId		= (String) session.getAttribute("escuela");
	String salto			= "X";
	
	
	ArrayList<aca.catalogo.CatNivelEscuela> lisNiveles = catNivelL.getListEscuela(conElias, escuelaId, "ORDER BY NIVEL_ID");
	
	
	Plan.setPlanId(planId);
	if (Plan.existeReg(conElias)){
		Plan.mapeaRegId(conElias, planId);
	}else{
		planId = escuelaId + "-" + Plan.maximoReg(conElias, escuelaId);
	}


/* ********************************** ACCIONES ********************************** */

	
	String accion 			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj				= "";
	
//------------- GUARDAR ------------->
	if(accion.equals("1")){
		Plan.setPlanId(planId);
		Plan.setPlanNombre(request.getParameter("PlanNombre"));
		Plan.setNivelId(request.getParameter("Nivel"));
		Plan.setEstado(request.getParameter("Estado"));
		Plan.setEscuelaId(escuelaId);
		Plan.setValidaHorario(request.getParameter("ValidaHorario"));
		Plan.setTitulo(request.getParameter("Titulo"));
		
		if (Plan.existeReg(conElias) == false){
			if (Plan.insertReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}else{
			if (Plan.updateReg(conElias)){
				msj = "Modificado";
				Plan.mapeaRegId(conElias, planId); // mapeamos el registor que actualizamos
			}else{
				msj = "NoModifico";
			}
		}
	}
//------------- ELIMINAR ------------->
	else if(accion.equals("2")){
		if (Plan.existeReg(conElias) == true){
			if (Plan.deleteReg(conElias)){
				salto = "plan.jsp";
			}else{
				msj = "NoElimino";
			}	
		}else{
			msj = "NoExiste";
		}
	}

/* ********************************** END ACCIONES ********************************** */

	pageContext.setAttribute("resultado", msj);
%>


<div id="content">
	<h2>
		<fmt:message key="catalogo.AnadirPlan" />
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary" href="plan.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
 	<form action="accion.jsp?PlanId=<%=planId %>" method="post" name="frmPlan">
  		
  		<input type="hidden" name="Accion">  
  		
  		<fieldset>
  			<label for="PlanNombre"><fmt:message key="aca.Nombre" /></label>
  			<input name="PlanNombre" type="text" id="PlanNombre" value="<%=Plan.getPlanNombre()%>" maxlength="40" />
  		</fieldset>
  		
  		<fieldset>
  			<label for="Nivel"><fmt:message key="catalogo.Nivel" /></label>
  			<select name="Nivel" id="Nivel" <%if(Plan.planSiendoUsado(conElias, planId)){%>readonly title='<fmt:message key="aca.MateriasUsadasPlan" />'<%} %>>
			<%for(aca.catalogo.CatNivelEscuela catNivel : lisNiveles){%>
					<%
						if(Plan.planSiendoUsado(conElias, planId) && catNivel.getNivelId().equals(Plan.getNivelId()) == false ){
							continue;
						}
					%>
					<option value="<%=catNivel.getNivelId() %>" <%=catNivel.getNivelId().equals(Plan.getNivelId())?"selected":"" %>><%=catNivel.getNivelNombre() %></option>
					
			<%}%>
            	</select>
  		</fieldset>
        
        <fieldset>
        	<label for="ValidaHorario"><fmt:message key="aca.ValidaHorario" /></label>
        	<select name="ValidaHorario" id="ValidaHorario">
				<option value="N" <%if(Plan.getValidaHorario().equals("N"))out.print("selected");%>><fmt:message key="aca.Negacion" /></option>
				<option value="S" <%if(Plan.getValidaHorario().equals("S"))out.print("selected");%>><fmt:message key="aca.Si" /></option>
			</select>
        </fieldset>
        
        <fieldset>
        	<label for="Estado"><fmt:message key="aca.Estado" /></label>
        	<select name="Estado" id="Estado">
				<option value="A" <%if(Plan.getEstado().equals("A"))out.print("selected");%>><fmt:message key="aca.Activo" /></option>
				<option value="I" <%if(Plan.getEstado().equals("I"))out.print("selected");%>><fmt:message key="aca.Inactivo" /></option>
			</select>
        </fieldset>
        
        <fieldset>
        	<label for="Titulo"><fmt:message key="aca.Titulo" /></label>
        	<select name="Titulo" id="Titulo">
				<option value="Grado" <%if(Plan.getEstado().equals("Grado"))out.print("selected");%>><fmt:message key="aca.Grado" /></option>
				<option value="Semestre" <%if(Plan.getEstado().equals("Semestre"))out.print("selected");%>><fmt:message key="aca.Semestre" /></option>
			</select>
        </fieldset>
         
        <div class="well">
			<a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok  icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		</div>
	</form>
	
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>