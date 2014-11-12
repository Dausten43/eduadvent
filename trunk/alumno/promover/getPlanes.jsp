<%@ include file= "../../con_elias.jsp" %>
<%
	String cicloId = request.getParameter("ciclo")==null?"":request.getParameter("ciclo");	

	ArrayList<aca.plan.Plan> lisPlanes = new aca.plan.PlanLista().getListPlanPermiso(conElias, cicloId,"ORDER BY 1");


	for(aca.plan.Plan plan: lisPlanes){
		out.print(" <option value='"+plan.getPlanId()+"'>"+ plan.getPlanNombre()+"</option>");
	}
%>
<%@ include file= "../../cierra_elias.jsp" %> 