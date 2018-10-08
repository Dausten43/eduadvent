<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.plan.Plan"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.catalogo.CatTipocal"%>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoImp"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoImpLista"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="planLista" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="planCursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="tipocal" scope="page" class="aca.catalogo.CatTipocal"/>
<jsp:useBean id="tipocalLista" scope="page" class="aca.catalogo.CatTipocalLista"/>
<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<head>
<script type="text/javascript">
	function revisa(numMaterias){
		var tieneAlgunaSeleccionada = false;
		var faltaAlgunCampo = false;
		var notaEsNumero = true;
		for(var i = 0; i < numMaterias; i++){
			var aplicar = document.getElementById("aplicar"+i);
			if(aplicar.checked){
				tieneAlgunaSeleccionada = true;
				if(document.getElementById("nota"+i).value == "" || document.getElementById("fecha"+i).value == ""){
					faltaAlgunCampo = true;
				}else{
					if(!(document.getElementById("nota"+i).value >= 0)){
						notaEsNumero = false;
					}
				}
			}
		}
		
		
		
		
		if(!tieneAlgunaSeleccionada){
			alert("Para guardar necesita seleccionar \"Aplicar\" de la fila a guardar");
		}else if(tieneAlgunaSeleccionada){
			if(faltaAlgunCampo){
				alert("Llene los campos obligatorios (*) para poder guardar");
			}else{
				if(notaEsNumero){
					document.forma.numMaterias.value = numMaterias;
					document.forma.submit();
				}else{
					alert("La nota debe ser un número positivo");
				}
				
			}
		}
	}
</script>
</head>
<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String planId 		= request.getParameter("plan");
	String accion 		= request.getParameter("Accion");
	String mensaje 		= "";

	alumno.mapeaRegId(conElias, codigoId);
	System.out.println("codigo"+codigoId);
	if(planId == null){
		alumPlan.mapeaRegActual(conElias, codigoId);
		planId = alumPlan.getPlanId();
	}
	System.out.println("Plan:"+planId);
	if(accion == null)
		accion = "0";
	boolean guardo = true;
	if(accion.equals("1")){ //Guardar las materias
		int numMaterias = Integer.parseInt(request.getParameter("numMaterias"));
		
		for(int i = 0; i < numMaterias; i++){
			String cursoId = request.getParameter("aplicar"+i);
			if(cursoId != null){
				kardex.setCodigoId(codigoId);
				kardex.setCursoId(cursoId);
				kardex.setCal1(request.getParameter("b1"+i));
				kardex.setCal2(request.getParameter("b2"+i));
				kardex.setCal3(request.getParameter("b3"+i));
				kardex.setCal4(request.getParameter("b4"+i));
				kardex.setCal5(request.getParameter("b5"+i));
				kardex.setCal6(request.getParameter("b6"+i));
				kardex.setCal7(request.getParameter("b7"+i));
				kardex.setCal8(request.getParameter("b8"+i));
				kardex.setCal9(request.getParameter("b9"+i));
				kardex.setCal10(request.getParameter("b10"+i));
				kardex.setNota(request.getParameter("nota"+i));
				kardex.setFNota(request.getParameter("fecha"+i));
				kardex.setTipoCalId(request.getParameter("tipocal"+i));
				kardex.setComentario(request.getParameter("comentario"+i));
				kardex.setNotaExtra(request.getParameter("notaExtra"+i));
				kardex.setFExtra(request.getParameter("fechaExtra"+i));
				kardex.setFolio(kardex.getNuevoFolio(conElias, codigoId));
			
				if(!kardex.insertReg(conElias)){
					guardo &= false;
				}
				
			}
		}
		if(guardo)
			mensaje = "Guard&oacte; correctamente!!!";
	}
	
%>
<body>
<form name="forma" id="forma" action="accion.jsp?Accion=1" method="POST">
	<input type="hidden" name="numMaterias" value=""/>
	<table align="center" width="95%">
<%
	if(!mensaje.equals("")){
%>
		<tr><td align="center">Guardó Correctamente</td></tr>
		<tr><td align="center"><a href="cursos.jsp">Regresar a Listado</a></td></tr>
<%
	}else{
%>
		<tr>
			<td align="center">[<%=codigoId %>] [<%=alumno.getNombre() %> <%=alumno.getApaterno() %> <%=alumno.getAmaterno() %>] -- [<%=CatNivel.getGradoNombre(Integer.parseInt(alumno.getNivelId())) %>] [<%=alumno.getGrado() %>º <%=alumno.getGrupo() %>]</td>
		</tr>
		<tr>
			<td align="center">
				<select id="plan" onchange="location.href='accion.jsp?plan='+this.options[this.selectedIndex].value;">
<%
		ArrayList lisPlanes = planLista.getListAll(conElias, escuelaId, "ORDER BY NIVEL_ID");
		for(int i = 0; i < lisPlanes.size(); i++){
			plan = (Plan) lisPlanes.get(i);
%>
					<option value="<%=plan.getPlanId() %>" <%if(planId.equals(plan.getPlanId())) out.print("selected=\"selected\""); %>><%=plan.getPlanNombre() %></option>
<%
		}
%>
				</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<table class="table table-fullcondensed table-fontsmall table-nohover">
<%
		ArrayList lisCursos = planCursoLista.getListCurso(conElias, planId, "AND CURSO_ID NOT IN (SELECT CURSO_ID FROM KRDX_CURSO_IMP WHERE CODIGO_ID = '"+codigoId+"') ORDER BY GRADO, CURSO_NOMBRE");
		ArrayList lisTipocal = tipocalLista.getListAll(conElias, "ORDER BY TIPOCAL_ID");
		String semestre = "0";
		for(int i = 0; i < lisCursos.size(); i++){
			planCurso = (PlanCurso) lisCursos.get(i);
			if(!semestre.equals(planCurso.getGrado())){
%>
					<tr>
						<td colspan="13"><font size="2"><b>Grado <%=planCurso.getGrado() %></b></font></td>
					</tr>
					<tr>
						<th><fmt:message key="aca.Aplicar"/>*</th>
						<th><fmt:message key="aca.Materia"/></th>
						<th>1</th>
						<th>2</th>
						<th>3</th>
						<th>4</th>
						<th>5</th>
						<th>6</th>
						<th>7</th>
						<th>8</th>
						<th>9</th>
						<th>10</th>
						<th><fmt:message key="aca.Nota"/>*</th>
						<th><fmt:message key="aca.Fecha"/>*</th>
						<th><fmt:message key="aca.NotaExtra"/></th>
						<th><fmt:message key="aca.FechaExtra"/></th>
						<th><fmt:message key="aca.Condicion"/>*</th>
						<th><fmt:message key="aca.Comentario"/></th>
					</tr>
<%
				semestre = planCurso.getGrado();
			}
%>
					<tr>
						<td align="center"><input type="checkbox" name="aplicar<%=i %>" id="aplicar<%=i %>" value="<%=planCurso.getCursoId() %>" /></td>
						<td><%=planCurso.getCursoNombre() %></td>
						<td><input type="text" size="2" name="b1<%=i %>" id="b1<%=i %>" /></td>
						<td><input type="text" size="2" name="b2<%=i %>" id="b2<%=i %>" /></td>
						<td><input type="text" size="2" name="b3<%=i %>" id="b3<%=i %>" /></td>
						<td><input type="text" size="2" name="b4<%=i %>" id="b4<%=i %>" /></td>
						<td><input type="text" size="2" name="b5<%=i %>" id="b5<%=i %>" /></td>
						<td><input type="text" size="2" name="b6<%=i %>" id="b6<%=i %>" /></td>
						<td><input type="text" size="2" name="b7<%=i %>" id="b7<%=i %>" /></td>
						<td><input type="text" size="2" name="b8<%=i %>" id="b8<%=i %>" /></td>
						<td><input type="text" size="2" name="b9<%=i %>" id="b9<%=i %>" /></td>
						<td><input type="text" size="2" name="b10<%=i %>" id="b10<%=i %>" /></td>
						<td><input type="text" size="2" name="nota<%=i %>" id="nota<%=i %>" /></td>
						<td><input type="text" size="7" name="fecha<%=i %>" id="fecha<%=i %>" /></td>
						<td><input type="text" size="5" value="0" name="notaExtra<%=i %>" id="notaExtra<%=i %>" /></td>
						<td><input type="text" size="7" value="0" name="fechaExtra<%=i %>" id="fechaExtra<%=i %>" /></td>
						<td>
							<select name="tipocal<%=i %>">
<%
			for(int j = 0; j < lisTipocal.size(); j++){
				tipocal = (CatTipocal) lisTipocal.get(j);
%>
								<option value="<%=tipocal.getTipocalId() %>"><%=tipocal.getTipocalCorto() %></option>
<%
			}
%>
							</select>
						</td>
						<td><input type="text" name="comentario<%=i %>" id="comentario<%=i %>" /></td>
					</tr>
<%
		}
%>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center"><input type="button"  value="Guardar" onclick="revisa(<%=lisCursos.size()%>);"/></td>
		</tr>
<%
	}
%>
	</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %>