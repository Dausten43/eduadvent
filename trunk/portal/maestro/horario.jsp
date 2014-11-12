<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="HorarioL" scope="page" class="aca.catalogo.CatHorarioLista"/>
<jsp:useBean id="HorarioPeriodoL" scope="page" class="aca.catalogo.CatHorarioPeriodoLista"/>
<jsp:useBean id="cicloGrupoHorarioL" scope="page" class="aca.ciclo.CicloGrupoHorarioLista"/>
<jsp:useBean id="HorarioCicloL" scope="page" class="aca.catalogo.CatHorarioCicloLista"/>

<%
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String codigoId 		= (String) session.getAttribute("codigoId");
	
	
	/* =========== HORARIOS =========== */ 
	
	/* Lista de horarios */
	ArrayList<aca.catalogo.CatHorario> horarios 		= HorarioL.getListHorariosMaestro(conElias, codigoId, cicloId, "ORDER BY 1" );
	
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
	
	/* =========== HORARIO DEL MAESTRO =========== */
	
	/* Traer ciclos que comparten horario o salones */
	ArrayList<aca.catalogo.CatHorarioCiclo> listCiclos = HorarioCicloL.getListCiclo(conElias, escuelaId, cicloId, "");
	String ciclos = listCiclos.size()>0?"":"'"+cicloId+"'";
	
	for(aca.catalogo.CatHorarioCiclo folio : listCiclos){
		ciclos += folio.getCiclos();
	}
		
	/* Salones en los que el maestro tiene horario */
	ArrayList<String> listSalonesMaestro = cicloGrupoHorarioL.getListSalonesMaestro(conElias, horarioId, codigoId, ciclos);
	
	/* Donde da clases el maestro */
	java.util.HashMap<String, aca.ciclo.CicloGrupoHorario> mapHorarioMaestro = cicloGrupoHorarioL.getMapHorarioMaestro(conElias, horarioId, codigoId, ciclos);
	
%>

<div id="content">

	<h2><fmt:message key="aca.Horario" /></h2>
	
	<div class="well">
		<a href="cursos.jsp" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<%if(horarios.size()==0){ %>
		<div class="alert alert-danger"><fmt:message key="aca.NoTieneHorarios" /></div>
	<%}else{ %>
		
		
		<form action="horario.jsp" method="post" name="forma">
			
			<div class="alert">
				<div class="row">
					<div class="span3">
						<label for="horarioId"><fmt:message key="aca.Horario" />:</label>
						<select name="horarioId" id="horarioId" style="width:100%;" onchange="document.forma.submit();">
						<%
							for(aca.catalogo.CatHorario horario: horarios){
						%>
								<option value="<%=horario.getHorarioId() %>" <%if(horario.getHorarioId().equals(horarioId)){out.print("selected");} %>><%=horario.getHorarioNombre() %></option>
						<%
							}
						%>
						</select>
					</div>
				</div>
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
									
									<%for(String salonId : listSalonesMaestro){%>
										
											<%if(mapHorarioMaestro.containsKey(salonId+"@"+per.getPeriodoId()+"@"+dia)){ %>
												<strong class="materia-info" data-content="
																							<strong><fmt:message key='aca.Salon' />:</strong> <%= aca.catalogo.CatSalon.getSalonNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId()) %>
																							<br>
																							<strong><fmt:message key='aca.Edificio' />:</strong> <%= aca.catalogo.CatSalon.getEdificioNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId()) %>
																							<br>
																							<strong><fmt:message key='aca.Grupo' />:</strong> <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId())  %>
																							<br>
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
</script>


<%@ include file= "../../cierra_elias.jsp" %>