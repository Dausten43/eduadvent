<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Plan"  class="aca.plan.Plan" scope="page"/>
<jsp:useBean id="PlanLista"  class="aca.plan.PlanLista" scope="page"/>

<script>

	function Borrar( planId ){
		if(confirm("<fmt:message key="js.Confirma" />")==true){
			document.location="accion.jsp?Accion=2&PlanId="+planId;
	  	}
	}

	function cambiaPlan( ){
		document.frmPlan.submit();
	}
</script>

<%
	
	String strPlanId		= request.getParameter("PlanId");
	String escuelaId		= (String) session.getAttribute("escuela");
	int nivel 				= -1;
	
	ArrayList<aca.plan.Plan> lisPlan = PlanLista.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
	
%>

<div id="content">

	<h2><fmt:message key="planes.Planes" /></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="accion.jsp"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a> 
	</div>	
 
	<%
		for(aca.plan.Plan plan : lisPlan){
			
			if (Integer.parseInt(plan.getNivelId())!=nivel){
				nivel = Integer.parseInt(plan.getNivelId());
	%>
			
				</table>
				
			  	<div class="alert alert-info"> 
			    	<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel+"")%>
			  	</div>
			  
	 			<table class="table table-condensed table-bordered">  
			     	<tr> 
			       		<th style="width:3%;"><fmt:message key="aca.Operacion" /></th>
			       		<th style="width:10%;"><fmt:message key="aca.Clave" /></th>
				       	<th style="width:30%;"><fmt:message key="aca.Nombre" /></th>
				       	<th style="width:3%;"><fmt:message key="aca.Estado" /></th>
				       	<th style="width:3%;"><fmt:message key="aca.Titulo" /></th>
				   	</tr>
			<%} %>
	     	
	     	<tr> 
	      		<td>
	       			<a class="icon-pencil" href="accion.jsp?PlanId=<%=plan.getPlanId()%>"></a>
		      		<%if(aca.plan.PlanCurso.cuentaMaterias(conElias, plan.getPlanId())==0){%>
		        		<a class="icon-remove" href="javascript:Borrar('<%=plan.getPlanId()%>')"></a>
		      		<%}%> 
	      		</td>
	      		<td><%=plan.getPlanId()%></td>
	      		<td><%=plan.getPlanNombre() %></td>
	      		<td><%=plan.getEstado() %></td>
	      		<td><%=plan.getTitulo() %></td>
	     	</tr>
	<%}%>
    </table>
</div>

<%@ include file= "../../cierra_elias.jsp" %> 