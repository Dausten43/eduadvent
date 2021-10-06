<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="Plan"  class="aca.plan.Plan" scope="page"/>
<jsp:useBean id="PlanLista"  class="aca.plan.PlanLista" scope="page"/>
<jsp:useBean id="PermisoLista" scope="page" class="aca.ciclo.CicloPermisoLista"/>

<script>	
	function cargaPlan(plan, event){
		console.log("seleccionaPlan.jsp?Accion=1&PlanId="+plan);
		event.preventDefault();
		document.location.href="seleccionaPlan.jsp?Accion=1&PlanId="+plan;
	}
</script>
<%
	String escuelaId		= (String) session.getAttribute("escuela");	
	if(request.getParameter("Ciclo")!=null){
		session.setAttribute("cicloId", request.getParameter("Ciclo"));	
	}		
	String cicloId			= (String) session.getAttribute("cicloId");
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");	
	
	boolean currentCicloIsActive = false;
	for(aca.ciclo.Ciclo ciclo: lisCiclo) {
		if(currentCicloIsActive) {			
			break;
		}
		else {			
			if(ciclo.getCicloId().equals(cicloId)) {
				currentCicloIsActive = true;				
			}
		}
	}
	if(!currentCicloIsActive && lisCiclo.size() > 0) {
		cicloId = lisCiclo.get(0).getCicloId();
		session.setAttribute("cicloId", cicloId);
	}
	
	String strPlanId		= request.getParameter("PlanId");
	String accion			= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	
	ArrayList<aca.plan.Plan> lisPlan				= PlanLista.getListEscuela(conElias, escuelaId, "AND ESTADO = 'A' ORDER BY NIVEL_ID");
	ArrayList<aca.ciclo.CicloPermiso> lisPermiso	= PermisoLista.getListConPermiso(conElias, cicloId, "ORDER BY CICLO_ID, NIVEL_ID");
	
	String salto = "";	
	if(accion.equals("1")){ //Carga en session el planId
		session.setAttribute("planId", strPlanId);		
		salto = "materia.jsp";
	}
%>

<div id="content">

	<h2><fmt:message key="planes.Planes" /></h2>
	
	<form name="frmCiclo" action="seleccionaPlan.jsp" method="post">
		<input type="hidden" name="Accion">
		<div class="well">
			 	<select name="Ciclo" id="Ciclo" onchange="document.frmCiclo.submit();" class="input-xxlarge">
				<%		
					for(aca.ciclo.Ciclo ciclo: lisCiclo){
				%>
						<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId)){out.print("selected");} %>><%=ciclo.getCicloNombre() %></option>
				<%
					}	
				%>
			  </select>
		</div>
	
	
		<%
			
			for(int i=0; i<lisPermiso.size();i++){
				aca.ciclo.CicloPermiso permiso = (aca.ciclo.CicloPermiso) lisPermiso.get(i);
		%>
				</table>
			  	<div class="alert alert-info">
					<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, permiso.getNivelId())%>
			  	</div>		
				<table class="table table-condensed table-bordered table-striped table-hover">
					<thead>
						<tr> 
							<th style="width:10%;"><fmt:message key="aca.Codigo" /></th>
				    		<th><fmt:message key="aca.Nombre" /></th>
				  		</tr>
				  		<tr></tr>
				  	</thead>
		<%		
				for (aca.plan.Plan plan: lisPlan){
					if (plan.getNivelId().equals(permiso.getNivelId())){
		%>  
					<tr> 
						<td><%=plan.getPlanId() %></td>
					 	<td>
					  		<a onclick="cargaPlan('<%=plan.getPlanId()%>', event);" href=""><%=plan.getPlanNombre()%></a>
					  	</td>
					</tr>
		<%	
					}
				}	
		%>
	   			</table>
		<%
			} 
		%>
	</form>
</div>
<%	
	// Salto de pagina
	if (salto.length()>0){%>
	<meta http-equiv="refresh" content="0; url=<%=salto%>">
<%	} %>

<%@ include file= "../../cierra_elias.jsp" %> 