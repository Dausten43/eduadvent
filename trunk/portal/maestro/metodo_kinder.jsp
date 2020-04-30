<%@page import="java.util.Map"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.preescolar.UtilPreescolar"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.text.*"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.kardex.KrdxAlumActiv"%>
<%@page import="aca.kardex.KrdxAlumEval"%>

<jsp:useBean id="GrupoEvalL" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupoActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista" />
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval" />
<jsp:useBean id="cicloGrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad" />
<jsp:useBean id="ArchivosEnviadosLista" scope="page" class="aca.kardex.KrdxAlumArchivoLista" />
<jsp:useBean id="promedioL" scope="page" class="aca.ciclo.CicloPromedioLista" />

<%
	String codigoId			= session.getAttribute("codigoId").toString();
	String escuelaId		= session.getAttribute("escuela").toString();
	String cicloId 			= session.getAttribute("cicloId").toString();	
	
	if (request.getParameter("CicloGrupoId")!=null){
		session.setAttribute("cicloGrupoId", request.getParameter("CicloGrupoId"));
		session.setAttribute("cursoId", request.getParameter("CursoId"));
	}
	
	String cicloGrupoId 		= (String) session.getAttribute("cicloGrupoId");
	String cursoId 				= (String) session.getAttribute("cursoId");
	
	String resultado			= "";
	
	UtilPreescolar up = new UtilPreescolar();
	Map<String, Integer> contadorTareasPEA = new HashMap();
	
	contadorTareasPEA.putAll(up.getNumeroTareas(cicloGrupoId, cursoId, cicloId));
	
	up.close();
	
	ArrayList<aca.ciclo.CicloPromedio> listPromedio 		= promedioL.getListPromedioCiclo(conElias, cicloId," ORDER BY ORDEN");
	ArrayList<aca.ciclo.CicloGrupoEval> listEstrategias 	= new ArrayList();
	//System.out.println(cicloGrupoId + " " + cursoId);
	
	ArrayList<aca.ciclo.CicloGrupoActividad> lisActividad 	= cicloGrupoActividadL.getListGrupo(conElias, cicloGrupoId, cursoId, "ORDER BY EVALUACION_ID, ACTIVIDAD_ID");
	
	DecimalFormat getformato  	= new DecimalFormat("##0.00;(##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	empPersonal.mapeaRegId(conElias, codigoId);
	
	int modulos					= aca.ciclo.Ciclo.getModulos(conElias, aca.ciclo.CicloGrupo.getCicloId(conElias, cicloGrupoId));
%>
<script>
	function borrarAct(EvaluacionId, ActividadId) {
		if (confirm("<fmt:message key="js.EliminarActividadYEvaluacion" />")) {
			document.location.href = "actividad.jsp?Accion=3&EvaluacionId=" + EvaluacionId + "&ActividadId=" + ActividadId;
		}
	}
	function borrarEval(EvaluacionId) {
		if (confirm("<fmt:message key="js.EliminarEvaluacion" />")) {
			document.location.href = "estrategia.jsp?Accion=3&EvaluacionId=" + EvaluacionId;
		}
	}
</script>

<div id="content">
	<h2>
		<fmt:message key="aca.MetodoEval" />
		<span class="label label-info"><fmt:message key="aca.SoloPuedeTener" /> <%=modulos %> <fmt:message key="aca.EvaluacionesMin" /></span>
		<small><%=aca.empleado.EmpPersonal.getNombre(conElias,codigoId, "NOMBRE")%></small>
	</h2>	
	<div class="well"> 
			  <a class="btn btn-primary" href="cursos.jsp"><i class="icon icon-th-list icon-white"></i> <fmt:message key="maestros.Cursos" /></a>
			  <a class="btn btn-primary" href="altaTareasK.jsp?ciclo_id=<%= cicloId %>&curso_id=<%= cursoId %>&ciclo_grupo_id=<%= cicloGrupoId %>"><i class="icon icon-pencil icon-white"></i> <fmt:message key="aca.CrearActividades" /></a>
			  &nbsp;&nbsp;<strong>Plan: </strong><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoId))%>
			  &nbsp;&nbsp;<strong>Materia: </strong> <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%>
			  &nbsp;&nbsp;<strong>Grado: </strong><%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%>
	</div>	
<%
	double sumaPromedioGrupo 	= 0D;
	
	int numPromedios			= 0;
	float sumValorPromedios 	= 0;
	
	int numEvaluaciones 		= 0;
	float sumValorEvaluaciones 	= 0;
	
	for(aca.ciclo.CicloPromedio promedios : listPromedio){
		numPromedios++;
		sumValorPromedios += Float.parseFloat(promedios.getValor()); 
		%>
			<div class="alert alert-success"><h4>N1. <%=promedios.getNombre() %> (Valor: <%=promedios.getValor() %>)<h4></div>
<%	
		listEstrategias = GrupoEvalL.getArrayListPorPromedio(conElias, cicloGrupoId, cursoId, promedios.getPromedioId(), "ORDER BY ORDEN");		
%> 
			<!--  div class="well" -->
				<!-- a class="btn btn-primary" href="estrategia.jsp?Accion=1&CicloGrupoId=<%=cicloGrupoId%>&CursoId=<%=cursoId%>"> -->
					<!-- i class="icon-plus icon-white"></i> <fmt:message key="boton.AnadirEvaluacion" />  -->
				<!-- </a> -->
			<!-- </div> -->
<%
	

		for (int i = 0; i < listEstrategias.size(); i++) {
			aca.ciclo.CicloGrupoEval evaluacion = (aca.ciclo.CicloGrupoEval) listEstrategias.get(i);
			
			double tmpPromedioEval = aca.ciclo.CicloGrupoEval.promedioEstrategia(conElias, cicloGrupoId, cursoId, evaluacion.getEvaluacionId());
			sumaPromedioGrupo += tmpPromedioEval;
			numEvaluaciones++;
			sumValorEvaluaciones += Float.parseFloat(evaluacion.getValor());			
%>			
			<div class="alert alert-info">
			
				<h5> N2. 
					<%=evaluacion.getEvaluacionNombre()%> <small><%if(evaluacion.getEstado().equals("A")){%><fmt:message key="aca.Abierto" /><%}else{%><fmt:message key="aca.Cerrado" /><%}%></small>
					<% 
						if (evaluacion.getEstado().equals("A") && escuelaId.equals("A17")) { 
					%> 
							<a href="estrategia.jsp?Accion=0&EvaluacionId=<%=evaluacion.getEvaluacionId()%>"><i class="icon-pencil"></i></a> 
					<% 
							if (!aca.ciclo.CicloGrupoActividad.tieneActividades(conElias, cicloGrupoId, cursoId, evaluacion.getEvaluacionId()) && false) { %> 			
								<a style="cursor:pointer;" onclick="borrarEval('<%=evaluacion.getEvaluacionId()%>');" >	<i class="icon-remove "></i> </a>
					<% 		
							} 
						}
					%> 
					<span class="pull-right">
						<fmt:message key="aca.Valor" />: <%=evaluacion.getValor()%>% &nbsp; &nbsp;
						( <span style="font-size:12px;"><fmt:message key="aca.Promedio" />: <%=getformato.format(tmpPromedioEval)%></span> )
					</span>
					<small>( <%=evaluacion.getFecha()%> )</small>
				</h5>				
<%
				boolean actividades = false;
				boolean entro = false;
				float sumaActividades = 0;
%>	
			</div>
			
			<div class="row"  style="margin-left:40px;">
			
			<div class="span9">
				<div class="alert">
					<h6>N3. 
						<fmt:message key="aca.Periodos" />
						&nbsp;
						<%if( aca.ciclo.Ciclo.getEditarActividad(conElias, cicloId).equals("SI") ){ %>
							<a class="btn btn-mini" href="actividad.jsp?Accion=1&CicloGrupoId=<%=cicloGrupoId%>&CursoId=<%=cursoId%>&EvaluacionId=<%= evaluacion.getEvaluacionId()%>">
								<i class="icon-plus"></i> <fmt:message key="boton.AnadirActividad" />
							</a>
						<%} %>
					</h6>
				</div>
			
	
<%
				for (int j = 0; j < lisActividad.size(); j++) {
					aca.ciclo.CicloGrupoActividad act = (aca.ciclo.CicloGrupoActividad) lisActividad.get(j);
					if (act.getEvaluacionId().equals(evaluacion.getEvaluacionId())) {
						sumaActividades = sumaActividades + Float.parseFloat(act.getValor());
						if (!entro) {
							actividades = true;
							entro = true;
%>							
						<table class="table table-condensed table-bordered">
							<tr>
								<th><fmt:message key="aca.Periodo" /></th>
								<th><fmt:message key="aca.ActividadesTrimestre" /></th>
								<th><fmt:message key="aca.Valor" /> </th> 
								<th><fmt:message key="aca.Etiqueta" /> </th>
								<th><fmt:message key="aca.Mostrar" /> </th>
								<th><fmt:message key="aca.ArchivosEnviados" /></th>							
							</tr>
<%
						}
%>
							<tr>
								<td>
									<%=act.getActividadNombre()%>
									<%if( aca.ciclo.Ciclo.getEditarActividad(conElias, cicloId).equals("SI") ){ %>
													<%
														if (!aca.ciclo.CicloGrupoEval.getEstado(conElias, cicloGrupoId, cursoId, Integer.parseInt(evaluacion.getEvaluacionId())).equals("C")) {
													%> 
															<a href="actividad.jsp?Accion=4&EvaluacionId=<%=act.getEvaluacionId()%>&ActividadId=<%=act.getActividadId()%>&Valor=<%=act.getValor()%>">
																<i class="icon-pencil"></i>
															</a> 
													<%
															if (!KrdxAlumActiv.tieneNotas(conElias, cicloGrupoId, cursoId, act.getEvaluacionId(), act.getActividadId())) {
													%> 
																<i class="icon-remove" onclick="borrarAct('<%=act.getEvaluacionId()%>','<%=act.getActividadId()%>');" ></i> 
													<%
															}
														}
													%>
									<%} %>	
								</td>
<%
								String fecha = act.getFecha();
								int contadorActividades = contadorTareasPEA.containsKey(promedios.getPromedioId() + "-" + evaluacion.getEvaluacionId() + "-" + act.getActividadId()) ? 
										 contadorTareasPEA.get(promedios.getPromedioId() + "-" + evaluacion.getEvaluacionId() + "-" + act.getActividadId()) : 0;  
										
%>
								<td><%= contadorActividades  %></td>
								<td><%=act.getValor()%>%</td>
								<td><%= aca.catalogo.CatActividadEtiqueta.getNombreEtiqueta(conElias, aca.catalogo.CatEscuela.getUnionId(conElias, (String)session.getAttribute("escuela")), act.getEtiquetaId()) %></td>
								<td><%= act.getMostrar().equals("S")?"SI":"NO" %></td>
<%
								ArrayList<aca.kardex.KrdxAlumArchivo> archivosEnviandos = ArchivosEnviadosLista.getListArchivosEnviados(conElias, cicloGrupoId, cursoId, act.getEvaluacionId(), act.getActividadId(), " ORDER BY FECHA");
								int archivosEnviados = archivosEnviandos.size();
								if (archivosEnviados > 0) {
%>
									<td>
										<a href="calificarTareas.jsp?cicloGrupoId=<%=cicloGrupoId%>&cursoId<%=cursoId%>&evaluacionId=<%=act.getEvaluacionId()%>&actividadId=<%=act.getActividadId()%>&fechaEntrega=<%=fecha%>">
											<span class="badge badge-info"><%=archivosEnviados%></span>
										</a>
									</td>
<%
								} else {
%>
								<td><%=archivosEnviados%></td>
<%
								}
%>
							</tr>

<%
					} // fin de pinta las actividades
%>
<%
				}// for de actividades 
%>
			</table>
	
<%
			//if (actividades){
				if (false){
%>
					<div class="alert">
						<fmt:message key="aca.SumaDeActividades" /> <%=sumaActividades%>%
						<br>
					<%
						if (actividades && sumaActividades < 100) {
					%>
							<strong class="alert-danger"><fmt:message key="aca.Falta" /> <%=100 - sumaActividades%>%</strong>
					<%
						}
					%>
					</div>
<%
			}
%>
			</div>
		</div>
<%			

		}
	}// for de estrategias
%>	
	<hr>	
	<div class="alert alert-success">
		<h4>
			<fmt:message key="aca.TotalEstrategiasDeMateria" /> <%=numEvaluaciones%> <%if(numEvaluaciones==1){%><fmt:message key='aca.Estrategia'/><%}else{%><fmt:message key='aca.Estrategias'/><%}%>
			<span style="float:right;">
				<fmt:message key="aca.ValorTotal" />: <%=sumValorPromedios%>%
			</span>
		</h4>
	</div>

</div>

<%@ include file="../../cierra_elias.jsp"%>
