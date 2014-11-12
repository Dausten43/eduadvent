<%@ include file="../../con_elias.jsp"%>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.kardex.KrdxCursoImp"%>
<%@page import="aca.plan.Plan"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.catalogo.CatTipocal"%>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="kardex" scope="page" class="aca.kardex.KrdxCursoImp"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoImpLista"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="planLista" scope="page" class="aca.plan.PlanLista"/>

<%
	String codigoId = (String) session.getAttribute("codigoAlumno");
	String accion = request.getParameter("Accion");
	String escuelaId = (String) session.getAttribute("escuela");

	alumno.mapeaRegId(conElias, codigoId);
	
	if(accion == null)
		accion = "0";
	
	if(accion.equals("1")){
		String folio = request.getParameter("folio");
		kardex.mapeaRegId(conElias, codigoId, folio);
		kardex.deleteReg(conElias);
	}
%>
<head>

</head>
<body>
	<div id="content">
		
		<h2><fmt:message key="alumnos.CursosImportados"/><small><%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></small></h2>
	
		<div class="alert">
			<%=codigoId%> | <%=alumno.getNombre()%> <%=alumno.getApaterno()%> <%=alumno.getAmaterno()%> <br /> 
			<%=CatNivel.getGradoNombre(Integer.parseInt(alumno.getNivelId()))%> <%=alumno.getGrado()%>º <%=alumno.getGrupo()%>
		</div>
	
		<form>
			
					<td align="center"><b><fmt:message key="alumnos.CursosImportados"/></b></td>
				<a class="btn btn-small btn btn-info" href="accion.jsp"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir"/></a>
						<table width="100%" align="center" class="table table-condensed">
							<tr>
								<th>#</th>
								<th><fmt:message key="aca.Opcion"/></th>
								<th><fmt:message key="catalogo.Nivel"/></th>
								<th><fmt:message key="aca.CursoId"/></th>
								<th><fmt:message key="aca.NombreMateria"/></th>
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
								<th><fmt:message key="aca.Nota"/></th>
								<th><fmt:message key="aca.Fecha"/></th>
								<th><fmt:message key="aca.Condicion"/></th>
							</tr>
		<%
					ArrayList lisCursos = kardexLista.getListPersonal(conElias, codigoId,
					"ORDER BY B.PLAN_ID, B.GRADO, CURSO_NOMBRE(A.CURSO_ID)");
			ArrayList lisPlan = planLista.getListEscuela(conElias, escuelaId,	"ORDER BY NIVEL_ID");
			for (int i = 0; i < lisCursos.size(); i++) {
				kardex = (KrdxCursoImp) lisCursos.get(i);
		%>
							<tr>
								<td align="center"><%=kardex.getFolio()%></td>
								<td align="center">
									<img src="../../imagenes/editar.gif" onclick="location.href='update.jsp?folio=<%=kardex.getFolio() %>'" style="cursor:pointer;" />
									<img src="../../imagenes/no.gif" onclick="eliminar(<%=kardex.getFolio() %>);" style="cursor:pointer;" />
								</td>
		<%
				String planId = kardex.getCursoId().substring(0, 6);
				for (int j = 0; j < lisPlan.size(); j++) {
					plan = (Plan) lisPlan.get(j);
					if (plan.getPlanId().equals(planId)) {
		%>
								<td><%=plan.getPlanNombre()%> / <%=PlanCurso.getGradoCurso(conElias, kardex
												.getCursoId())%></td>
		<%
				}
				}
		%>
								<td><%=kardex.getCursoId()%></td>
								<td><%=PlanCurso.getCursoNombre(conElias, kardex
										.getCursoId())%></td>
								<td align="center"><%=kardex.getCal1()%></td>
								<td align="center"><%=kardex.getCal2()%></td>
								<td align="center"><%=kardex.getCal3()%></td>
								<td align="center"><%=kardex.getCal4()%></td>
								<td align="center"><%=kardex.getCal5()%></td>
								<td align="center"><%=kardex.getCal6()%></td>
								<td align="center"><%=kardex.getCal7()%></td>
								<td align="center"><%=kardex.getCal8()%></td>
								<td align="center"><%=kardex.getCal9()%></td>
								<td align="center"><%=kardex.getCal10()%></td>
								<td align="center"><%=kardex.getNota()%></td>
								<td align="center"><%=kardex.getFNota()%></td>
								<td align="center"><%=CatTipocal.getNombreCorto(conElias, kardex
										.getTipoCalId())%></td>
							</tr>
		<%
		}
		%>
						</table>
					</td>
				</tr>
			</table>
		</form>
			
	</div>

	<script>
		function eliminar(folio){
			if(confirm("<fmt:message key="aca.EliminarCurso"/>")){
				location.href='cursos.jsp?Accion=1&folio='+folio;
			}
		}
	</script>
</body>
<%@ include file= "../../cierra_elias.jsp" %>