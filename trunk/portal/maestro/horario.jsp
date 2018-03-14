<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="HorarioL" scope="page" class="aca.catalogo.CatHorarioLista"/>
<jsp:useBean id="HorarioPeriodoL" scope="page" class="aca.catalogo.CatHorarioPeriodoLista"/>
<jsp:useBean id="cicloGrupoHorarioL" scope="page" class="aca.ciclo.CicloGrupoHorarioLista"/>
<jsp:useBean id="HorarioCicloL" scope="page" class="aca.catalogo.CatHorarioCicloLista"/>

<%
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String codigoId 		= (String) session.getAttribute("codigoId");
	
	String maestroId 	= (String)session.getAttribute("codigoEmpleado");
	empPersonal.mapeaRegId(conElias, maestroId);
	String maestro			= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	
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
	String tmpF = "";
	
	
	for(aca.catalogo.CatHorarioCiclo folio : listCiclos){
		
		if(tmpF.equals("")){
			ciclos += folio.getCiclos();
		}else if(!tmpF.equals(folio.getCiclos())){
			ciclos +=","+folio.getCiclos();
		}else{
			ciclos += folio.getCiclos();
		}
		tmpF 	= folio.getFolio();
	}
		
	/* Salones en los que el maestro tiene horario */
	ArrayList<String> listSalonesMaestro = cicloGrupoHorarioL.getListSalonesMaestro(conElias, horarioId, codigoId, ciclos);
	
	/* Donde da clases el maestro */
	java.util.HashMap<String, aca.ciclo.CicloGrupoHorario> mapHorarioMaestro = cicloGrupoHorarioL.getMapHorarioMaestro(conElias, horarioId, codigoId, ciclos);
	
%>

<div id="content">

	<h2><fmt:message key="aca.Horario" /><small> ( <%=codigoId%> - <%=maestro%> - <%=cicloId%> )</small></h2>
	<form name="forma" action="horario.jsp">
		<div class="well">
			<a href="cursos.jsp" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i> 
				<fmt:message key="boton.Regresar" />
		    </a> &nbsp;&nbsp;<fmt:message key="aca.Horario" />:&nbsp;&nbsp;
		    <select name="horarioId" id="horarioId" style="width:360px;margin-bottom:0px;" onchange="document.forma.submit();">
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
	<%if(horarios.size()==0){ %>
		<div class="alert alert-danger"><fmt:message key="aca.NoTieneHorarios" /></div>
	<%}else{  %>
		
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
				<tbody>
				<%
					for(aca.catalogo.CatHorarioPeriodo per: periodos){
				%>
					<tr>
						<td><%=per.getHoraInicio() %>:<%=per.getMinInicio() %> - <%=per.getHorafin() %>:<%=per.getMinfin() %></td>
				<%		for(int dia=1; dia<8; dia++){ %>
						<td>
									
				<%			for(String salonId : listSalonesMaestro){ %>
										
				<%				if(mapHorarioMaestro.containsKey(salonId+"@"+per.getPeriodoId()+"@"+dia)){ 
									//System.out.println("test");%>
									<strong class="materia-info" data-content="
										<strong><fmt:message key='aca.Salon' />:</strong> <%= aca.catalogo.CatSalon.getSalonNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId()) %>
										<br>
										<strong><fmt:message key='aca.Edificio' />:</strong> <%= aca.catalogo.CatSalon.getEdificioNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId()) %>
										<br>
										<strong><fmt:message key='aca.Grupo' />:</strong> <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId())  %>
										<br>
								<%	if(!mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId().substring(0, 8).equals(cicloId)){ %> <!-- Si la materia pertenece a otro ciclo entonces muestra a que ciclo pertenece -->
										<div style='text-align:center;margin-top:8px;'><strong><small><%=aca.ciclo.Ciclo.getCicloNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId().substring(0, 8) ) %></small></div>
								<%	}%> 
									">
									<%=aca.plan.PlanCurso.getCursoNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCursoId())%>
										<br>
									<%="("+aca.catalogo.CatSalon.getSalonNombre(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getSalonId())+" - "
									+aca.ciclo.CicloGrupo.getGradoGrupo(conElias, mapHorarioMaestro.get(salonId+"@"+per.getPeriodoId()+"@"+dia).getCicloGrupoId())+")" %>
									</strong>
							<%	} %>
										
						<%	} %>
									
						</td>
						<%} %>
					</tr>
				<%	} %>
				</tbody>
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