<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="EscuelaL"  class="aca.catalogo.CatEscuelaLista" scope="page"/>
<jsp:useBean id="PlanL"  class="aca.plan.PlanLista" scope="page"/>
<jsp:useBean id="CursoL"  class="aca.plan.PlanCursoLista" scope="page"/>
<jsp:useBean id="Curso"  class="aca.plan.PlanCurso" scope="page"/>

<head>

<script>
	function Cambia( ){
		document.frmCopiar.Accion.value = "1";
		document.frmCopiar.submit();		
	}

	function Copiar() {
		if (document.frmCopiar.Escuela.value != "" && document.frmCopiar.Plan.value != "") {
			document.frmCopiar.Accion.value = "2";
			document.frmCopiar.submit();
		}
	}
	
	function Borrar() {
		if (confirm("¿Estás seguro de borrar todas las materias de este plan?")){
			document.frmCopiar.Accion.value = "3";
			document.frmCopiar.submit();
		}	
	}
</script>
</head>
<%
	// Declaración de variables
	String escuelaId 	= (String) session.getAttribute("escuela");
	String planId 		= request.getParameter("PlanId");
	String unionId 		= aca.catalogo.CatAsociacion.getUnionEscuela(conElias, escuelaId);
	
	String accion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");	
	int numAccion 		= Integer.parseInt(accion);	
	String strEscuela	= request.getParameter("Escuela")==null?"0":request.getParameter("Escuela");
	String strPlan		= request.getParameter("Plan")==null?"0":request.getParameter("Plan");
	String strResultado = "";
	int errorRow=0, existeRow=0; 
	
	ArrayList<aca.catalogo.CatEscuela> lisEscuela		= EscuelaL.getListUnion(conElias, unionId, "ORDER BY ESCUELA_NOMBRE");
	
		
	// Operaciones a realizar en la pantalla
	switch (numAccion) {

		case 1: { // Elegir el plan
			strResultado = "EligePlan";
			break;
		}

		case 2: { // Copiar las materias
			ArrayList<aca.plan.PlanCurso> lisCursos	= CursoL.getListCurso(conElias, strPlan, " ORDER BY GRADO, ORDEN");	
			for(int j = 0; j < lisCursos.size(); j++){
				aca.plan.PlanCurso curso = (aca.plan.PlanCurso) lisCursos.get(j);
				
				// Copiar las materias
				String claveCurso = curso.getCursoId().substring(6, 12);
				curso.setPlanId(planId);
				curso.setCursoId(planId+claveCurso);
				if (!curso.existeReg(conElias)){
					if (curso.insertReg(conElias)){						
					}else{
						errorRow++;
					}
				}else{
					existeRow++;
				}	
			}
			break;
		}
		
		case 3: { // Borrar las materias
			
			if (aca.plan.PlanCurso.deleteAllReg(conElias, planId)){
				conElias.commit();
			}else{
				errorRow++;
			}
		}
	}
	//System.out.println("Datos:"+errorRow+":"+existeRow);
		
	pageContext.setAttribute("resultado", strResultado);
%>
<body>
	<div id="content">
		<h2>Copiar materias ( <%=planId%> )</h2>
		<%
			if (!strResultado.equals("")) {
		%>
		<div class='alert alert-info'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>

		<div class="well" style="overflow: hidden;">
		<a href="materia.jsp?PlanId=<%=planId%>"class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
		
		<form name="frmCopiar" action="copiar.jsp" method="post">
		<input type="hidden" name="PlanId" value=<%=planId%>>
		<input type="hidden" name="Accion">
				
		<table class="table">
			<tr>
				<td colspan="4"><b>Copiar de:</b></td>
			</tr>	
			<tr>
				<td>
					Escuela:
					<select name="Escuela" id="Escuela" onchange='javascript:Cambia()'>
<%
			for( int j=0;j<lisEscuela.size();j++){
				aca.catalogo.CatEscuela esc = (aca.catalogo.CatEscuela) lisEscuela.get(j);
				if (strEscuela.equals("0")&&j==0) strEscuela = esc.getEscuelaId();
				
				if (esc.getEscuelaId().equals(strEscuela)){
					out.print(" <option value='"+esc.getEscuelaId()+"' Selected>"+ esc.getEscuelaNombre()+"</option>");
				}else{
					out.print(" <option value='"+esc.getEscuelaId()+"'>"+ esc.getEscuelaNombre()+"</option>");			
				}
			}
%>
					</select>&nbsp;
				</td>			
				<td>
					Plan:
					<select name="Plan" id="Plan" onchange='javascript:Cambia()'>
<%
			ArrayList<aca.plan.Plan> lisPlan	= PlanL.getListAll(conElias, strEscuela, " ORDER BY NIVEL_ID");
			for( int j=0;j<lisPlan.size();j++){
				aca.plan.Plan plan = (aca.plan.Plan) lisPlan.get(j);
				if (strPlan.equals("0")&&j==0) strPlan = plan.getPlanId();
				
				if (plan.getPlanId().equals(strPlan)){
					out.print(" <option value='"+plan.getPlanId()+"' Selected>"+ plan.getPlanNombre()+"</option>");
				}else{
					out.print(" <option value='"+plan.getPlanId()+"'>"+ plan.getPlanNombre()+"</option>");
				}
			}	
%>
					</select>
				</td>
				<td>Nivel: <%=aca.catalogo.CatNivel.getNivelNombre(conElias, aca.plan.Plan.getNivel(conElias, strPlan)) %> 
				<td>Materias: <%=aca.plan.Plan.getNumCursos(conElias, strPlan)%>
				</td>
			</tr>
			<tr>
				<td colspan="4"><b>Copiar para:</b></td>
			</tr>
			<tr>
				<td><%=aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></td>
				<td><%=planId%>:<%=aca.plan.Plan.getNombrePlan(conElias, planId)%></td>
				<td>Nivel: <%=aca.catalogo.CatNivel.getNivelNombre(conElias, aca.plan.Plan.getNivel(conElias, planId)) %>
				<td>Materias: <%=aca.plan.Plan.getNumCursos(conElias, planId)%>
			</tr>
		</table>
		</form>
		<div class="well" style="overflow: hidden;">
			&nbsp; <a class="btn btn-primary" href="javascript:Copiar()"><i class="icon-ok  icon-white"></i> <fmt:message key="boton.Copiar" /></a>
			&nbsp; <a class="btn btn-primary" href="javascript:Borrar()"><i class="icon-ok  icon-white"></i> <fmt:message key="boton.Borrar" /></a>
		</div>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>