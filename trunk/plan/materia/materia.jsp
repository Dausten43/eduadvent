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
<jsp:useBean id="cicloGrupoCurso"  class="aca.ciclo.CicloGrupoCurso" scope="page" />
<%
	String escuelaId		= (String) session.getAttribute("escuela");
    String strPlanId		= request.getParameter("PlanId");
    if(strPlanId == null){
    	strPlanId = "Selecciona" ;
    }
    
    String unionId = "";
	
	String nivelId 		= aca.plan.Plan.getNivel(conElias,strPlanId);
	String titulo 		= aca.plan.Plan.getTitulo(conElias, strPlanId);
	
	int grado			= 0;
	
	// Lista de planes 
	ArrayList<aca.plan.Plan> lisPlan	= PlanLista.getListAll(conElias, escuelaId, " ORDER BY NIVEL_ID");
		
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

<form name="frmMateria" action="materia.jsp" method="post">
	<div class="well">		
	<select name="PlanId" id="PlanId" onchange='javascript:cambiaPlan()'>
	<option value = "Selecciona" selected> <fmt:message key="boton.SeleccionarPlan" /> </option>
<%
	for( int j=0;j<lisPlan.size();j++){
		aca.plan.Plan plan = (aca.plan.Plan) lisPlan.get(j);
		
		if (strPlanId==null&&j==0)
			strPlanId = plan.getPlanId();
		
		if (plan.getPlanId().equals(strPlanId))
			out.print(" <option value='"+plan.getPlanId()+"' Selected>"+ plan.getPlanNombre()+"</option>");
			
		else if(!plan.getEstado().equals("I"))
			out.print(" <option value='"+plan.getPlanId()+"'>"+ plan.getPlanNombre()+"</option>");
	}	
%>
	</select>
  	<% if(!strPlanId.equals("Selecciona")){%>
    	<a class="btn btn-primary" href="accion.jsp?Accion=1&CursoId=&PlanId=<%=strPlanId %>"> <i class="icon-plus  icon-white"></i> <fmt:message key="boton.Anadir" /></a>
    	
    	<%if( ((String) session.getAttribute("admin")).equals("B01P0002") ){ %>	
    		<a class="btn btn-primary" href="copiar.jsp?Accion=1&PlanId=<%=strPlanId %>"> <i class="icon-plus  icon-white"></i> <fmt:message key="boton.Copiar" /></a>
    	<%} %>
 	<%}%> 		   	
	</div>  
</form>

<table class="table table-condensed">  
  <tr> 
    <th width="5%"><fmt:message key="aca.Op" /></th>
    <th width="15%"><fmt:message key="aca.Clave" /></th>
    <th width="20%"><fmt:message key="aca.Nombre" /></th>  
    <th width="3%"><fmt:message key="aca.Tipo" /></th>  
    <th width="3%"><fmt:message key="aca.Hrs" /></th>    
    <!-- <th width="10%"><fmt:message key="aca.Tipo" /></th> -->
    <th width="7%"><fmt:message key="aca.NotaMin" /></th>
	<th width="7%"><fmt:message key="aca.Faltas" /></th>
	<th width="7%"><fmt:message key="aca.Conducta" /></th>
	<th width="3%"><fmt:message key="aca.Orden" /></th>
	<th width="3%"><fmt:message key="aca.Decimal" /></th>
	<th width="7%"><fmt:message key="aca.Estado" /></th>
	
	<%if (escuelaId.contains("H")){%>
	<th width="20%"><fmt:message key="aca.CursoBase" /></th>
	<%} %>
	
	<th width="9%"><fmt:message key="aca.TipoEval" /></th>
	
	<th width="7%">
	<%if (!escuelaId.contains("H")){%>
		<fmt:message key="aca.BoletaAlumno" />
	<%}else{%>
		Boletín
	<%} %>
	
	</th>	
	<%if (escuelaId.contains("H")){%>
	<th width="3%"><fmt:message key="aca.HabitosyActitudes" /></th>
	<%} %>
	
  </tr>
<%
	
	ArrayList<aca.plan.PlanCurso> lisCurso		= PlanCursoLista.getListCurso(conElias, strPlanId, " ORDER BY GRADO, ORDEN");

	for(int i=0; i<lisCurso.size();i++){
		aca.plan.PlanCurso curso = (aca.plan.PlanCurso) lisCurso.get(i);
		
		String boleta = "";
		if(curso.getBoleta()==null){
			boleta = "No";
		}else if(curso.getBoleta().equals("N")){
			boleta = "No";
		}else if(curso.getBoleta().equals("S")){
			boleta = "Si";
		}
		String cursoBase = "-";
		if (curso.getCursoBase()!=null && !curso.getCursoBase().equals("-")){
			cursoBase = aca.plan.PlanCurso.getCursoNombre(conElias, curso.getCursoBase());
		}
		
		if (Integer.parseInt(curso.getGrado())!=grado){
				
			grado = Integer.parseInt(curso.getGrado());	
			String nombreGrado = aca.catalogo.CatEsquema.getNombreGrado(conElias, escuelaId, nivelId, curso.getGrado());
			if (nombreGrado.equals("X")) nombreGrado = aca.catalogo.CatNivel.getGradoNombre(grado)+ " "+titulo.toUpperCase();
			
%>
  <tr> 
    <td style="border:1px solid gray;" colspan="16" align="center">&nbsp;<strong><%=nombreGrado%></strong></td>
  </tr>
<%	}
		
		%>
  <tr> 
    <td align="center">
      <a class="icon-pencil" href="accion.jsp?Accion=5&CursoId=<%=curso.getCursoId().replaceAll("&", "}") %>&PlanId=<%=strPlanId %>&nivelId=<%=nivelId%>">
      </a>
     <%
     cicloGrupoCurso.setCursoId(curso.getCursoId());
     if(!cicloGrupoCurso.existeRegCursoId(conElias)){
	 %>
	 <a class="icon-remove" href="javascript:Borrar('<%=curso.getCursoId().replaceAll("&", "}") %>')">
     </a>
     <%} %>
    </td>
    <td align="left"><%=curso.getCursoId() %></td>
    <td align="left"><%=curso.getCursoNombre() %></td>   
    <td align="center"><%if (curso.getTipocursoId().equals("1")){%><fmt:message key='aca.Oficial' />
    					<%}else if (curso.getTipocursoId().equals("2")){%><fmt:message key='aca.NoOficial' />
    					<%}else if (curso.getTipocursoId().equals("3")){%><fmt:message key='aca.Ingles' />
    					<%} %> 
    <td align="center"><%=curso.getHoras()%></td>    
    <!-- Esto es un comentario -->
    <!-- <td align="center"><%=CatTipocurso.getNombre(conElias, curso.getTipocursoId())%></td>  --> 
    
    <td align="center"><%=curso.getNotaAc() %></td>
	<td align="center"><%=curso.getFalta() %></td>
	<td align="center"><%=curso.getConducta() %></td>
	<td align="center"><%=curso.getOrden() %></td>
	<td align="center"><%=curso.getPunto().equals("S")?"SI":"NO"%></td>
	<td align="center"><%=curso.getEstado().equals("A")?"Activo":"Inactivo"%></td>
	<%if (escuelaId.contains("H")){%>
	<td align="left"><%=cursoBase%></td>
	<%} %> 
	<td align="center"><%=curso.getTipoEvaluacion().equals("C")?"Calculado":"Pase"%></td>
	<td align="center"><%=boleta%></td>
    
    <%if (escuelaId.contains("H")){%>					
	<td align="center"><%=curso.getAspectos()%></td>
	<%} %> 
	 
  </tr>
<%	} %>  
</table>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 