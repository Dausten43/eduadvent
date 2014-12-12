<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatTipocurso"%>
<jsp:useBean id="PlanLista"  class="aca.plan.PlanLista" scope="page"/>
<jsp:useBean id="PlanCursoLista"  class="aca.plan.PlanCursoLista" scope="page"/>
<jsp:useBean id="Curso"  class="aca.plan.PlanCurso" scope="page"/>
<jsp:useBean id="Plan"  class="aca.plan.Plan" scope="page"/>
<jsp:useBean id="PlanGrado"  class="aca.plan.PlanGrado" scope="page"/>
<jsp:useBean id="PlanGradoLista"  class="aca.plan.PlanGradoLista" scope="page"/>
<%
	String escuelaId		= (String) session.getAttribute("escuela");
    String strPlanId		= request.getParameter("PlanId");
    if(strPlanId == null){
    	strPlanId = "Selecciona" ;
    }
	
	String nivelId 		= aca.plan.Plan.getNivel(conElias,strPlanId);
	String titulo 		= aca.plan.Plan.getTitulo(conElias, strPlanId);
	
	int grado			= 0;
	
	ArrayList lisPlan	= PlanLista.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
		
%>
<head>        
	<script>
	
		function Borrar( cursoId ){
			if(confirm("<fmt:message key="js.Confirma" />")){
				document.location="accion.jsp?Accion=4&CursoId="+cursoId+"&PlanId=<%=strPlanId %>";
		  	}
		}
	
		function cambiaPlan( ){
			document.frmMateria.submit();
		}
		
	</script>
</head>
<body>
<div id="content">
<h2><fmt:message key="boton.Materias" /> </h2>
<div>
<a></a>
</div>

<form name="frmMateria" action="grado.jsp" method="post">
	<div class="well">		
	<select name="PlanId" id="PlanId" onchange='javascript:cambiaPlan()'>
	<option value = "Selecciona" selected> <fmt:message key="boton.SeleccionarPlan" /> </option>
<%
	for( int j=0;j<lisPlan.size();j++){
		aca.plan.Plan plan = (aca.plan.Plan) lisPlan.get(j);
		if (strPlanId==null&&j==0) strPlanId = plan.getPlanId();
		
		if (plan.getPlanId().equals(strPlanId)){
			out.print(" <option value='"+plan.getPlanId()+"' Selected>"+ plan.getPlanNombre()+"</option>");
		}else{
			out.print(" <option value='"+plan.getPlanId()+"'>"+ plan.getPlanNombre()+"</option>");
		}
	}	
%>
	</select>
  	   	
	</div>  
</form>

<table class="table table-condensed">  
  <tr> 
  	<th width="5%"><fmt:message key="aca.Operacion" /></th>
    <th width="5%"><fmt:message key="aca.Plan" /></th>
    <th width="8%"><fmt:message key="aca.Grado" /></th>
    <th width="28%"><fmt:message key="aca.Nombre" /></th>
  </tr>
<%
	ArrayList lisCurso		= new ArrayList();
	lisCurso			= PlanGradoLista.getListPlan(conElias, strPlanId, "");
	for(int i=0; i<lisCurso.size();i++){
		aca.plan.PlanGrado grados = (aca.plan.PlanGrado) lisCurso.get(i);
		
		if (Integer.parseInt(grados.getGrado())!=grado){
			grado = Integer.parseInt(grados.getGrado());	
%>
  <tr> 
    <td style="border:1px solid gray;" colspan="13" align="center">&nbsp;<strong><%=aca.catalogo.CatNivel.getGradoNombre(grado)+ titulo%></strong></td>
  </tr>
<%	} %>
  <tr> 
    <td align="center">
      <a class="icon-pencil" href="accion.jsp?Accion=5&PlanId=<%=grados.getPlanId()%>&Grado=<%=grados.getGrado()%>">
      </a>
      <a class="icon-remove" href="javascript:Borrar('<%=grados.getPlanId()%>')">
      </a> 
    </td>
    <td align="left"><%=grados.getPlanId() %></td>
    <td align="left"><%=grados.getGrado() %></td>
    <td align="center"><%=grados.getNombre()%></td>
  </tr>
<%	} %>  
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 