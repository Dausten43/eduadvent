<jsp:useBean id="HorarioL" scope="page" class="aca.catalogo.CatHorarioLista"/>
<jsp:useBean id="HorarioPeriodoL" scope="page" class="aca.catalogo.CatHorarioPeriodoLista"/>
<jsp:useBean id="cicloGrupoHorarioL" scope="page" class="aca.ciclo.CicloGrupoHorarioLista"/>

<div class="well text-center" style="margin-bottom:0;">
	<a href="javascript:$('.horarios-container').slideToggle(500);" class="btn btn-info"><i class="icon-calendar icon-white"></i> <fmt:message key="aca.VerHorario" /></a>
</div>

<div class="horarios-container" style="margin-top:20px;display:none;">

	<%
		
		/* =========== HORARIOS =========== */ 
		
		/* Lista de horarios del grupo */
		ArrayList<aca.catalogo.CatHorario> horarios 		= HorarioL.getListHorariosGrupo(conElias, cicloGrupoId, "ORDER BY 1" );
		
	%>
		
	<%if(horarios.size()==0){ %>
		<div class="alert alert-danger" style="margin:0;"><fmt:message key="aca.NoTieneHorarios" /></div>
	<%}else{ %>
		
		<%
			ArrayList<String> materiasDeBaja = aca.kardex.KrdxCursoActLista.getMateriasDeBaja(conElias, cicloGrupoId, codigoAlumno, "");
		%>
		
		<%for(aca.catalogo.CatHorario horario : horarios){ %>
		
			<%
				/* =========== PERIODOS DEL HORARIO SELECCIONADO =========== */
				ArrayList<aca.catalogo.CatHorarioPeriodo> periodos 	= HorarioPeriodoL.getListAll(conElias, horario.getHorarioId(), "ORDER BY PERIODO_ID" );
				
				/* =========== HORARIO =========== */
				
				/* Salones en los que el grupo tiene horario */
				ArrayList<String> listSalones = cicloGrupoHorarioL.getListSalones(conElias, horario.getHorarioId(), cicloGrupoId);
				
				/* Donde tiene clases el grupo */
				java.util.HashMap<String, aca.ciclo.CicloGrupoHorario> mapHorarioMaestro = cicloGrupoHorarioL.getMapHorario(conElias, horario.getHorarioId(), cicloGrupoId);
			%>
			
			<div class="alert text-center" style="padding:8px 0;">
				<h4><%=horario.getHorarioNombre()%></h4>
			</div>
		
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
				<%for(aca.catalogo.CatHorarioPeriodo per: periodos){%>
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
				<%}%>
			</table>
		
		<%}%>
		
	<%}%>	

</div>

<script>
	$('.materia-info').popover({
		trigger: 'hover',
		placement: 'top',
		html: true,
	});	
	
	$(document).ready(function(){
		var checkbox = $('.checkbox');
		
		//Muestra solo las materias seleccionadas, las demas escondelas
		checkbox.each(function(){
			var $this = $(this);
			
			if( $this.is(':checked') == false ){
				$('.materia-'+$this.data('cursoid')).hide();
			}
		});
		
		checkbox.filter(':not([onclick])').on('click', function(){
			var $this = $(this);
			
			if( $this.is(':checked') ){
				$('.materia-'+$this.data('cursoid')).fadeIn(200);
			}else{
				$('.materia-'+$this.data('cursoid')).fadeOut(200);
			}
		})
		
	});
</script>
			





