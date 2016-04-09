<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="java.util.HashMap"%>

<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="CicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="CicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="CicloBloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<%	
	String cicloId			= (String) session.getAttribute("cicloId");
	String empleadoId		= request.getParameter("EmpleadoId");
	String nivelId			= request.getParameter("NivelId");
	String accion 			= request.getParameter("Accion")==null ? "" : request.getParameter("Accion");
	
	ArrayList<aca.ciclo.CicloGrupoCurso> lisMaterias = GrupoCursoLista.getListMateriasEmpleadoxNivel(conElias, cicloId, empleadoId, nivelId, " ORDER BY ORDEN_NGG(CICLO_GRUPO_ID)");
	ArrayList<aca.ciclo.CicloBloque> listaBoques = CicloBloqueLista.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
	
	String mensaje = "";
	String mensajeError = "";
	boolean materiaCerrada= Boolean.parseBoolean(request.getParameter("Cerradas"));
	
	if(accion.equals("1")&&request.getParameter("Cerradas")!=null&&request.getParameter("EvaluacionId")!=null){
		conElias.setAutoCommit(false);
		boolean error = false;
		boolean matCerrada = Boolean.parseBoolean(request.getParameter("Cerradas"));
		String evaluacion = request.getParameter("EvaluacionId");
 		for(aca.ciclo.CicloGrupoCurso materia : lisMaterias){
 			CicloGrupoEval.mapeaRegId(conElias, materia.getCicloGrupoId(), materia.getCursoId(), evaluacion);
 			if(matCerrada&&CicloGrupoEval.getEstado().equals("C")) CicloGrupoEval.setEstado("A");
 			else if(!matCerrada&&CicloGrupoEval.getEstado().equals("A")) CicloGrupoEval.setEstado("C");
			if(!CicloGrupoEval.updateReg(conElias)){
				error = true;
				break;
			}
 		}
		if(error){
			mensajeError = "ErrorActualizarEvaluacion";
			conElias.rollback();
		}
		else{
			mensaje = "Evaluacion";
		}
		conElias.setAutoCommit(true);
	}
	pageContext.setAttribute("mensajeError",mensajeError);
	pageContext.setAttribute("mensaje",mensaje);
%>
<body>
<div id="content">
<h2><fmt:message key="maestros.MateriasporProfesor" /></h2>
<div class="well" style="overflow: hidden;">
<a href="reporte.jsp?NivelId=<%=nivelId %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
</div>
<div class="alert alert-info"><fmt:message key="aca.Maestro" />: <%=aca.empleado.EmpPersonal.getNombre(conElias,empleadoId, "APELLIDO")%></div>
	
<h4><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivelId) %></h4>
				<table width="100%"  align="center" class="table table-condensed">
					<tr>
					    <th>#</th>
					    <th><fmt:message key="aca.Gdo" /></th>
					    <th><fmt:message key="aca.Gpo" /></th>
					    <th><fmt:message key="aca.Materia" /></th>
					    <th># <fmt:message key="aca.Alumnos" /></th>
					<%	for(aca.ciclo.CicloBloque bloque : listaBoques){ %>
							<th><%=bloque.getBloqueId() %>° <fmt:message key="aca.Eval" /><div id="btn<%=bloque.getBloqueId() %>"></div></th>
					<%	} %>
					</tr>
				<%
					HashMap<String, Boolean> mapaListos = new HashMap<String, Boolean>();
					for(int i=0; i<lisMaterias.size(); i++){
						aca.ciclo.CicloGrupoCurso grupoCurso = lisMaterias.get(i);
						CicloGrupo.mapeaRegId(conElias, grupoCurso.getCicloGrupoId());
		
						int numAlumnos 	= Integer.parseInt(aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId()));
						
						ArrayList<String> listaStatusCursosEvaluados = new ArrayList<String>();
						for(aca.ciclo.CicloBloque bloque : listaBoques){
							String bim="";
							CicloGrupoEval.mapeaRegId(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(), bloque.getBloqueId());
							if(CicloGrupoEval.getEstado().equals("C")) bim="Listo";
							else if(aca.kardex.KrdxAlumEval.tieneEvaluaciones(conElias, grupoCurso.getCicloGrupoId(), grupoCurso.getCursoId(), bloque.getBloqueId())) bim="Evalua";
							else bim="-";
							listaStatusCursosEvaluados.add(bim);
							
							if(bim.equals("Listo")&&!mapaListos.containsKey(bloque.getBloqueId())) mapaListos.put(bloque.getBloqueId(), true);
							if(!bim.equals("Listo")) mapaListos.put(bloque.getBloqueId(), false);
						}
					%>
					  	<tr class="tr2">
					    	<td align="center"><strong><%=i+1%></strong></td>    
						    <td align="center"><%=CicloGrupo.getGrado()%></td>
						    <td align="center"><%=CicloGrupo.getGrupo()%></td>
						    <td align="left"><strong><%= aca.plan.PlanCurso.getCursoNombre(conElias, grupoCurso.getCursoId())%></strong></td>
						    <td align="center"><%=numAlumnos%></td>
					    <%	for(String statusCursosEval : listaStatusCursosEvaluados){ %>
								<td align="center"><%=statusCursosEval %></td>
						<%	} %>
					  	</tr>
				<% 	}
					
					for(aca.ciclo.CicloBloque bloque : listaBoques){ %>
						<script>
							document.getElementById('btn<%=bloque.getBloqueId()%>').innerHTML='<input onclick=\'document.location.href=\"repMaterias.jsp?Accion=1&EmpleadoId=<%=empleadoId%>&EvaluacionId=<%=bloque.getBloqueId()%>&NivelId=<%=nivelId%>&Cerradas=<%=mapaListos.get(bloque.getBloqueId())%>\"\' style=\'cursor:pointer;\' type=\'button\' class=\'btn btn-primary\' value=\'<%=mapaListos.get(bloque.getBloqueId())?"Abrir":"Cerrar" %>\'>';
						</script>
				<%	} %>
				</table>
				
		<table>
			<%  
	if(!mensajeError.equals("")){
%>
		<div class="alert alert-danger"><fmt:message key="aca.${mensajeError}" /></div> 
<%	
	}
%>
<%  
	if(!mensaje.equals("")){
%>
		<div class="alert"><fmt:message key="aca.${mensaje}" /><%=materiaCerrada?"abierto":"cerrado" %></div> 
<%	
	}
%>
		
	</table>
	</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 