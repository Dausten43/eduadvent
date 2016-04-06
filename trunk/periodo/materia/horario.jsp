<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="HorarioL" scope="page" class="aca.catalogo.CatHorarioLista"/>
<jsp:useBean id="HorarioPeriodoL" scope="page" class="aca.catalogo.CatHorarioPeriodoLista"/>
<jsp:useBean id="HorarioCicloL" scope="page" class="aca.catalogo.CatHorarioCicloLista"/>
<jsp:useBean id="EdificioL" scope="page" class="aca.catalogo.CatEdificioLista"/>
<jsp:useBean id="SalonL" scope="page" class="aca.catalogo.CatSalonLista"/>
<jsp:useBean id="cicloGrupoHorario" scope="page" class="aca.ciclo.CicloGrupoHorario"/>
<jsp:useBean id="cicloGrupoHorarioL" scope="page" class="aca.ciclo.CicloGrupoHorarioLista"/>

<%	
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	
	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String cursoId			= (String) request.getParameter("CursoId")==null?"":request.getParameter("CursoId").replace("$", "&");
	
	/* =========== HORARIOS =========== */ 
	
	/* Lista de horarios */
	ArrayList<aca.catalogo.CatHorario> horarios 		= HorarioL.getListAll(conElias, escuelaId, "ORDER BY 1" );
	
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
	
	/* =========== EDIFICIOS =========== */
	
	/* Lista de edificios de la escuela */
	ArrayList<aca.catalogo.CatEdificio> edificios      = EdificioL.getListAll(conElias, escuelaId, " ORDER BY EDIFICIO_NOMBRE ");
	
	/* Edificio seleccionado */
	String edificioId       	= (String) session.getAttribute("edificioId")==null?"-1":(String) session.getAttribute("edificioId");
	
	if(request.getParameter("edificioId")!=null){
		edificioId = request.getParameter("edificioId");
		session.setAttribute("edificioId", edificioId);
	}
	
	/* Verificar que el edificio este en la lista de la escuela seleccionado */
	encontrado = false;
	for(aca.catalogo.CatEdificio edificio: edificios){
		if(edificioId.equals(edificio.getEdificioId())){
			encontrado = true; break;
		}
	}
	if( encontrado == false ){
		if(edificios.size()>0){
			edificioId = edificios.get(0).getEdificioId();	
		}else{
			edificioId = "-1";
		}
		
		session.setAttribute("salonId", edificioId);
	}
	
	/* =========== SALONES =========== */
			
	/* Lista de salones del edificio */
	ArrayList<aca.catalogo.CatSalon> salones 	     	= SalonL.getListAll(conElias, edificioId, " ORDER BY SALON_NOMBRE ");
	
	/* Salon seleccionado */
	String salonId       	= (String) session.getAttribute("salonId")==null?"-1":(String) session.getAttribute("salonId");
	
	if(request.getParameter("salonId")!=null){
		salonId = request.getParameter("salonId");
		session.setAttribute("salonId", salonId);
	}
	
	/* Verificar que el salon este en la lista del edificio seleccionado */
	encontrado = false;
	for(aca.catalogo.CatSalon salon: salones){
		if(salonId.equals(salon.getSalonId())){
			encontrado = true; break;
		}
	}
	if( encontrado == false ){
		if(salones.size()>0){
			salonId = salones.get(0).getSalonId();
		}else{
			salonId = "-1";
		}
		session.setAttribute("salonId", salonId);
	}
	
	
	/* =========== PERIODOS DEL HORARIO SELECCIONADO =========== */
	ArrayList<aca.catalogo.CatHorarioPeriodo> periodos 	= HorarioPeriodoL.getListAll(conElias, horarioId, "ORDER BY PERIODO_ID" );
	
	
	
	/* =========== HORARIOS CON LOS QUE PUEDE CHOCAR =========== */
	
	/* Traer ciclos que comparten horario o salones */
	ArrayList<aca.catalogo.CatHorarioCiclo> listCiclos = HorarioCicloL.getListCiclo(conElias, escuelaId, cicloId, "");
	String ciclos = listCiclos.size()>0?"":"'"+cicloId+"'";
	
	for(aca.catalogo.CatHorarioCiclo folio : listCiclos){
		ciclos += folio.getCiclos();
	}
	
			
	/* El horario de otras materias en este mismo horario en este salon */
	java.util.HashMap<String, aca.ciclo.CicloGrupoHorario> mapHorarioOtrasMaterias = cicloGrupoHorarioL.getMapOtrasMaterias(conElias, escuelaId, cursoId, cicloGrupoId, horarioId, salonId, ciclos);
	
	/* Lista de los periodos registrados en este salón de otros horarios */
	ArrayList<String> listOtrosHorarios = cicloGrupoHorarioL.getListDeOtrosHorarios(conElias, escuelaId, horarioId, salonId, ciclos, "");

	
	
	/* =========== ACCIONES =========== */
			
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	
	if(accion.equals("1")){
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error 			= false;
		boolean horarioChoca 	= false;
		
					forPeriodos:
					for(aca.catalogo.CatHorarioPeriodo per: periodos){
						for(int dia=1; dia<8; dia++){
							String periodoSeleccionado = request.getParameter("periodoSeleccionado"+per.getPeriodoId()+"-"+dia);
							
							cicloGrupoHorario.setEscuelaId(escuelaId);
							cicloGrupoHorario.setCursoId(cursoId);
							cicloGrupoHorario.setCicloGrupoId(cicloGrupoId);
							cicloGrupoHorario.setSalonId(salonId);
							cicloGrupoHorario.setHorarioId(horarioId);
							cicloGrupoHorario.setDia(dia+"");
							cicloGrupoHorario.setPeriodoId(per.getPeriodoId());
							
							if(periodoSeleccionado!=null && periodoSeleccionado.equals("1")){//Esta seleccionado este periodo asi que guardalo
								if(!cicloGrupoHorario.existeReg(conElias)){//Solo si no existe guardalo, si existe pues ya no es necesario guardarlo
									
									/* ========= ASEGURARSE DE QUE NO CHOCA CON OTROS HORARIOS ========= */									
									int horaInicioActual	= Integer.parseInt( dia+per.getHoraInicio()+per.getMinInicio() );
									int horaFinalActual 	= Integer.parseInt( dia+per.getHorafin()+per.getMinfin() );
								
									for(String str : listOtrosHorarios){
										int horaInicioOtro		= Integer.parseInt( str.split("@@")[4] );
										int horaFinalOtro		= Integer.parseInt( str.split("@@")[5] );
										
										if ( 
												( horaInicioActual >= horaInicioOtro && horaInicioActual < horaFinalOtro ) ||
												( horaFinalActual > horaInicioOtro && horaFinalActual <= horaFinalOtro ) ||
												( horaInicioActual <= horaInicioOtro && horaFinalActual >= horaFinalOtro )
											){	
											horarioChoca = true; break forPeriodos;
										}
									}
									
									
									/* ========= ASEGURARSE DE QUE NO CHOCA CON OTRAS MATERIAS (CURSO_ID & CICLO_GRUPO_ID) DEL MISMO HORARIO ========= */
									boolean ocupadoPorOtrasMaterias = false;
									
									if(mapHorarioOtrasMaterias.containsKey(per.getPeriodoId()+"@"+dia)){
										horarioChoca = true; break forPeriodos;
									}
									
									
									/* Si llega hasta aqui significa que no choco, entonces guarda */
									if(cicloGrupoHorario.insertReg(conElias)){
										//Guardado correctamente
									}else{
										error = true; break forPeriodos;
									}	
									
								
								}
							}else{//No esta seleccionado este periodo
								
								if(cicloGrupoHorario.existeReg(conElias)){//Si existe y no lo ha seleccionado significa que lo quiere borrar
									if(cicloGrupoHorario.deleteReg(conElias)){
										//Eliminado correctamente
									}else{
										error = true; break forPeriodos;
									}
								}
								
							}
						}//End for dias
					}//End for periodos
					
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoGuardo";
		}else if(horarioChoca){
			conElias.rollback();
			msj = "HorarioChoca";
		}else{
			conElias.commit();
			msj = "Guardado";
		}
					
	}
	
	pageContext.setAttribute("resultado", msj);
	
	/* =========== MAPA =========== */
	
	/* El horario actual de la materia en este salon */
	java.util.HashMap<String, aca.ciclo.CicloGrupoHorario> mapActualHorario = cicloGrupoHorarioL.getMapActual(conElias, escuelaId, cursoId, cicloGrupoId, horarioId, salonId);

%>

<div id="content">

	<h2><fmt:message key="aca.Horario" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
			<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)  %>
			| 
			<%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %> 
	</div>
	
	<div class="well">
		<a href="materia.jsp" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<%if(horarios.size()==0){ %>
		<div class="alert alert-danger"><fmt:message key="aca.LaEscuelaNoTieneHorarios" /></div>
	<%}if(edificios.size()==0){%>	
		<div class="alert alert-danger"><fmt:message key="aca.LaEscuelaNoTieneEdificios" /></div>
	<%}if(salones.size()==0){ %>
		<div class="alert alert-danger"><fmt:message key="aca.LaEscuelaNoTieneSalones" /></div>
	<%}else{ %>
	
	
		<form action="horario.jsp?CicloGrupoId=<%=cicloGrupoId %>&CursoId=<%=cursoId %>" method="post" name="forma">
		
			<input type="hidden" name="Accion" />
			
			<!-- ============================ PARAMETROS ============================ -->
			
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
					<div class="span3">
						<label for="edificioId"><fmt:message key="aca.Edificio" />:</label>
						<select name="edificioId" id="edificioId" style="width:100%;" onchange="document.forma.submit();">
							<%for(aca.catalogo.CatEdificio edificio: edificios){ %>
								<option value="<%=edificio.getEdificioId() %>" <%if(edificio.getEdificioId().equals(edificioId)){out.print("selected");} %>><%=edificio.getEdificioNombre() %></option>
							<%} %>
						</select>
					</div>
					<div class="span3">
						<label for="salonId"><fmt:message key="aca.Salon" />:</label>
						<select name="salonId" id="salonId" style="width:100%;" onchange="document.forma.submit();">
							<%for(aca.catalogo.CatSalon salon: salones){ %>
								<option value="<%=salon.getSalonId() %>" <%if(salon.getSalonId().equals(salonId)){out.print("selected");} %>><%=salon.getSalonNombre() %></option>
							<%} %>
						</select>
					</div>
				</div>
			</div>
			
			<!-- ============================ HORARIO ============================ -->
			
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
							
									<%
										/* VERIFICAR QUE LAS HORAS DE ESTE PERIODO NO CHOQUEN CON LAS HORAS DE OTRO HORARIO EN ESTE SALON */
										boolean ocupadoEnOtroHorario = false; 
										
										int horaInicioActual	= Integer.parseInt( dia+per.getHoraInicio()+per.getMinInicio() );
										int horaFinalActual 	= Integer.parseInt( dia+per.getHorafin()+per.getMinfin() );
										
										String horario 			= "";
										String curso			= "";
										String cicloGrupo 		= "";
										String ciclo 			= "";
									
										for(String str : listOtrosHorarios){
											String cursoIdOtro 		= str.split("@@")[0];
											String cicloGrupoIdOtro = str.split("@@")[1];
											String horarioIdOtro 	= str.split("@@")[2];
											String diaOtro 			= str.split("@@")[3];
											int horaInicioOtro		= Integer.parseInt( str.split("@@")[4] );
											int horaFinalOtro		= Integer.parseInt( str.split("@@")[5] );
											
											if ( 
													( horaInicioActual >= horaInicioOtro && horaInicioActual < horaFinalOtro ) ||
													( horaFinalActual > horaInicioOtro && horaFinalActual <= horaFinalOtro ) ||
													( horaInicioActual <= horaInicioOtro && horaFinalActual >= horaFinalOtro )
												){	
												ocupadoEnOtroHorario 	= true;
												horario 				= horarioIdOtro;
												curso   				= cursoIdOtro;
												cicloGrupo 				= cicloGrupoIdOtro;
												ciclo 					= cicloGrupo.substring(0, 8);
											}
										}	
									%>
									
									<%if(ocupadoEnOtroHorario){ %>
									
										<!-- ESPACIO OCUPADO POR OTRA MATERIA EN OTRO HORARIO -->
										
										<td>
											<span class="materia-info" data-content="
																						<strong><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, aca.ciclo.CicloGrupo.getNivelGrupo(conElias, cicloGrupo) ) %></strong> 
																						- 
																						<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupo) %>
																						<br>
																						<%if(!ciclo.equals(cicloId)){ %> <!-- Si la materia pertenece a otro ciclo entonces muestra a que ciclo pertenece -->
																							<div style='text-align:center;margin-top:8px;'><strong><small><%=aca.ciclo.Ciclo.getCicloNombre(conElias, ciclo ) %></small></div>
																						<%}%>
																					">
												<%=aca.plan.PlanCurso.getCursoNombre(conElias, curso) %>
											</span>
											<strong><%=aca.catalogo.CatHorario.getHorarioNombre(conElias, horario) %></strong>
										</td>
										
									
									<%}else if(mapHorarioOtrasMaterias.containsKey(per.getPeriodoId()+"@"+dia)){ %>
										
										<!-- ESPACIO OCUPADO POR OTRA MATERIA EN ESTE HORARIO EN ESTE SALON -->
										<%
											String cicloMateria = mapHorarioOtrasMaterias.get(per.getPeriodoId()+"@"+dia).getCicloGrupoId().substring(0, 8);
										%>
										<td>
											<span class="materia-info" data-content="
																						<strong><%= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, aca.ciclo.CicloGrupo.getNivelGrupo(conElias, mapHorarioOtrasMaterias.get(per.getPeriodoId()+"@"+dia).getCicloGrupoId()) ) %></strong> 
																						- 
																						<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, mapHorarioOtrasMaterias.get(per.getPeriodoId()+"@"+dia).getCicloGrupoId())  %>
																						<br>
																						<%if(!cicloMateria.equals(cicloId)){ %> <!-- Si la materia pertenece a otro ciclo entonces muestra a que ciclo pertenece -->
																							<div style='text-align:center;margin-top:8px;'><strong><small><%=aca.ciclo.Ciclo.getCicloNombre(conElias, cicloMateria ) %></small></strong></div>
																						<%}%>
																					">
												<%=aca.plan.PlanCurso.getCursoNombre(conElias, mapHorarioOtrasMaterias.get(per.getPeriodoId()+"@"+dia).getCursoId()) %>
											</span>
										</td>
										
									<%}else{ %>
									
										<!-- ESPACIO DISPONIBLE -->
									
										<td class="periodoDisponible" data-periodo-dia="<%=per.getPeriodoId()%>-<%=dia%>">
											<!-- Si ya esta guardado -->
											<%if(mapActualHorario.containsKey(per.getPeriodoId()+"@"+dia)){ %>
												<i class="icon-ok"></i>
												<input type="hidden" value="1" name="periodoSeleccionado<%=per.getPeriodoId()%>-<%=dia%>" />
											<%} %>
										</td>
										
									<%} %>
							<%}%>
						</tr>
				<%
					}
				%>	
			</table>
			
			<!-- ============================ END HORARIO ============================ -->
			
			<div class="well">
				<a href="javascript:guardar();" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
			</div>
			
		</form>	
		
	<%}//End else %>
	
</div>

<script>
	$('.periodoDisponible').on('click', function(){
		var $this = $(this);
		
		if( $this.find('.icon-ok').length > 0 ){ /* clear the td */
			$this.html('');	
		}else{ /* Add the icon and put the input in the td */
			var html = '<i class="icon-ok"></i>' + '<input type="hidden" value="1" name="periodoSeleccionado'+$this.data('periodo-dia')+'" />';
			
			$this.html(html);
		}
	})
	
	function guardar(){
		document.forma.Accion.value="1";
		document.forma.submit();
	}
	
	$('.materia-info').popover({
		trigger: 'hover',
		placement: 'top',
		html: true,
	});
	
</script>


<%@ include file= "../../cierra_elias.jsp" %>