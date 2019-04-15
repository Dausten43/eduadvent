<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="HorarioL" scope="page" class="aca.catalogo.CatHorarioLista"/>
<jsp:useBean id="HorarioPeriodoL" scope="page" class="aca.catalogo.CatHorarioPeriodoLista"/>
<jsp:useBean id="cicloGrupoHorarioL" scope="page" class="aca.ciclo.CicloGrupoHorarioLista"/>
<jsp:useBean id="HorarioCicloL" scope="page" class="aca.catalogo.CatHorarioCicloLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/>

<%
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoId");
	
	alumPersonal.mapeaRegId(conElias, codigoId);
	alumPlan.mapeaRegActual(conElias, codigoId);
	cicloGrupo.mapeaRegId(conElias, alumPersonal.getNivelId(), alumPersonal.getGrado(), alumPersonal.getGrupo(), cicloId, alumPlan.getPlanId());
	
	String cicloGrupoId = cicloGrupo.getCicloGrupoId();
	
	/* =========== HORARIOS =========== */ 
	
	/* Lista de horarios */
	ArrayList<aca.catalogo.CatHorario> horarios 		= HorarioL.getListHorariosAlumno(conElias, codigoId, cicloGrupoId, "ORDER BY 1" );
	
	/* Horario seleccionado */
	String horarioId       	= (String) session.getAttribute("horarioId")==null?"-1":(String) session.getAttribute("horarioId");
	
	if(request.getParameter("horarioId")!=null){
		horarioId = request.getParameter("horarioId");
		session.setAttribute("horarioId", horarioId);
	}
	
	/* Verificar que el horario este en la lista de los horarios seleccionados */
	boolean encontrado = false;
	for(aca.catalogo.CatHorario horario: horarios){
		if(horarioId.equals(horario.getHorarioId())){
			encontrado = true; break;
		}
	}
	if( encontrado == false ){
		if(horarios.size()>0){
			horarioId = horarios.get(0).getHorarioId();
		}else{
			horarioId = "-1";
		}
		
		session.setAttribute("horarioId", horarioId);
	}
	
	/* =========== PERIODOS DEL HORARIO SELECCIONADO =========== */
	ArrayList<aca.catalogo.CatHorarioPeriodo> periodos 	= HorarioPeriodoL.getListAll(conElias, horarioId, "ORDER BY PERIODO_ID" );
	
	/* =========== HORARIO DEL ALUMNO =========== */
	
	/* Salones en los que el alumno tiene horario */
	ArrayList<String> listSalones = cicloGrupoHorarioL.getListSalonesAlumno(conElias, horarioId, codigoId, cicloGrupoId);
	
	/* Donde tiene clases el alumno */
	java.util.HashMap<String, aca.ciclo.CicloGrupoHorario> mapHorarioMaestro = cicloGrupoHorarioL.getMapHorarioAlumno(conElias, horarioId, codigoId, cicloGrupoId);
	
	ArrayList<String> materiasDeBaja = aca.kardex.KrdxCursoActLista.getMateriasDeBaja(conElias, cicloGrupoId, codigoId, "");
	
%>

<div id="content">

	<h2><fmt:message key="aca.Horario" /></h2>
	
	<div class="well">
		<a href="materias.jsp" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<%if(horarios.size()==0){ %>
		<div class="alert alert-danger"><fmt:message key="aca.NoTieneHorarios" /></div>
	<%}else{ %>
		
		
		<form action="horario.jsp" method="post" name="forma">
			
			<div class="alert">
				<label for="horarioId"><fmt:message key="aca.Horario" />:</label>
				<select name="horarioId" id="horarioId" onchange="document.forma.submit();" class="input-xlarge">
				<%
					for(aca.catalogo.CatHorario horario: horarios){
				%>
						<option value="<%=horario.getHorarioId() %>" <%if(horario.getHorarioId().equals(horarioId)){out.print("selected");} %>><%=horario.getHorarioNombre() %></option>
				<%
					}
				%>
				</select>
			</div>
			
		</form>
		
		
		<table class="table table-bordered table-condensed table-striped horario">
				<thead>
					<tr>
						<th><fmt:message key="aca.Hora"/></th>
						<th><fmt:message key="aca.Domingo"/></th>
						<th><fmt:message key="aca.Lunes"/></th>
						<th><fmt:message key="aca.Martes"/></th>
						<th><fmt:message key="aca.Miercoles"/></th>
						<th><fmt:message key="aca.Jueves"/></th>
						<th><fmt:message key="aca.Viernes"/></th>
						<th><fmt:message key="aca.Sabado"/></th>
					</tr>
				</thead>
				<%
					for(aca.catalogo.CatHorarioPeriodo per: periodos){
				%>
						<tr>
							<td><%=per.getHoraInicio() %>:<%=per.getMinInicio() %> - <%=per.getHorafin() %>:<%=per.getMinfin() %></td>
							<%for(int dia=1; dia<8; dia++){%>
								<td>
									
									<%for(String salonId : listSalones){%>
										
											<%if(mapHorarioMaestro.containsKey(salonId+"@"+per.getPeriodoId()+"@"+dia)){ %>
											
											<%
												boolean baja = false;
												if( materiasDeBaja.contains(mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCursoId()) ){
													baja = true;
												}
											%>
											
												<strong <%if(baja){ %> style="color: #b94a48;" <%} %>
																		class="materia-info materia-<%=mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCursoId()%>" 
																		data-content="
																						<strong><fmt:message key='aca.Salon' />:</strong> <%= aca.catalogo.CatSalon.getSalonNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId()) %>
																						<br>
																						<strong><fmt:message key='aca.Edificio' />:</strong> <%= aca.catalogo.CatSalon.getEdificioNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId()) %>
																						<br>
																						<%if(baja){ %>
																							<span class='label label-important' style='margin-top:8px;'><fmt:message key='aca.Baja' /></span>
																						<%} %>
																						<%if(!mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId().substring(0, 8).equals(cicloId)){ %> <!-- Si la materia pertenece a otro ciclo entonces muestra a que ciclo pertenece -->
																							<div style='text-align:center;margin-top:8px;'><strong><small><%=aca.ciclo.Ciclo.getCicloNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId().substring(0, 8) ) %></small></div>
																						<%}%> 
																					  ">
													<%=aca.plan.PlanCurso.getCursoNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCursoId()) %>
											</strong>
											<%} %>
										
									<%} %>
									
								</td>
							<%} %>
						</tr>
				<%	} %>
		</table>
		
	<%} %>
	
</div>

<script>
	$('.materia-info').popover({
		trigger: 'hover',
		placement: 'top',
		html: true,
	});
	

	jQuery('.materias').addClass('active');
</script>


<%@ include file= "../../cierra_elias.jsp" %>