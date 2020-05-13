<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.plan.Plan"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivel"/>
<jsp:useBean id="cicloGrupoCurso2" scope="page" class="aca.ciclo.CicloGrupoCurso"/>

<script>
	function Grabar(){
		document.forma.Accion.value="1";
		document.forma.submit();	
	}
	
	function cambiarEstado(CicloGrupoId, CursoId, i){
		document.forma.Accion.value="2";
		document.forma.CicloGrupoId.value=CicloGrupoId;
		document.forma.CursoId.value=CursoId;
		document.forma.i.value=i;
		document.forma.submit();
	}
</script>

<%
	String maestroId 	= (String)session.getAttribute("codigoEmpleado");
	boolean permitirCambiarElEstado = true;
	
	String mensaje 		= "";
	empPersonal.mapeaRegId(conElias, maestroId);
	
	String accion = request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	if(accion.equals("1")){//PRIVACIDAD ---------------------------->
		
		empPersonal.setPublicar(request.getParameter("privacidad"));
		if(empPersonal.updateReg(conElias)){
			mensaje="Guardado";
		}else{
			mensaje="NoGuardo";
		}

	}else if(accion.equals("2")){//CAMBIAR ESTADO ---------------------------->
		
		cicloGrupoCurso2.mapeaRegId(conElias, request.getParameter("CicloGrupoId"), request.getParameter("CursoId"));
		String i = request.getParameter("i");
		cicloGrupoCurso2.setEstado(request.getParameter("EstadoMat"+i));
		
		if(cicloGrupoCurso2.updateReg(conElias)){
			mensaje="Modificado";
		}else{
			mensaje="NoModifico";
		}
		
	}
	
	pageContext.setAttribute("resultado", mensaje);
	
	
	if (request.getParameter("Ciclo")!=null){
		 session.setAttribute("cicloId", request.getParameter("Ciclo"));
	}
	String cicloId 		= (String)session.getAttribute("cicloId");
	String maestro		= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	cicloGrupo.mapeaRegId(conElias, empPersonal.getCodigoId(), cicloId);
%>

<div id="content">
	<div>
		<h2><fmt:message key="aca.Cursos" /> <small><%="( "+maestro+" )" %></small></h2>
	</div>
	
	<% if (mensaje.equals("Eliminado") || mensaje.equals("Modificado") || mensaje.equals("Guardado") || mensaje.equals("MensajeEnviado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!mensaje.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
			<select id="Ciclo" onchange="location.href='cursos.jsp?Ciclo='+this.options[this.selectedIndex].value" class="input-xxlarge">
			<%
				boolean tieneCiclo = false;
				ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListCiclosEmpleadoCursos(conElias, maestroId, "ORDER BY CICLO_ID");
				for(aca.ciclo.Ciclo ciclo: lisCiclo){
							
						if(ciclo.getCicloId().equals(cicloId)){
							tieneCiclo = true;
						}
							
			%>
						<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId))out.print("selected"); %>>[<%=ciclo.getCicloId()%>]&nbsp;<%=ciclo.getCicloNombre() %> </option>
			<%
				}
				if(tieneCiclo == false){//
					cicloId = ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
					session.setAttribute("cicloId", cicloId);
				}
			%>
			</select>	
			
				<div class="pull-right" style="margin-right: 10px;">
					<%if(aca.ciclo.CicloGrupo.getEsMaestroPlantaEnCualquierCiclo(conElias, maestroId, cicloId)){%>
						<a href="grupo.jsp?CicloGrupoId=<%=cicloGrupo.getCicloGrupoId()%>" class="btn btn-primary btn-mobile">
							<i class="icon-th icon-white"></i> <fmt:message key="aca.Grupo" />
						</a>
					<%}%>
					
					<a href="horario.jsp" class="btn btn-info btn-mobile">
						<i class="icon-calendar icon-white"></i>
						<fmt:message key="aca.Horario" />
					</a>
					
					<a href="#myModal" data-toggle="modal" class="btn btn-info btn-mobile">
						<i class="icon-user icon-white"></i> <fmt:message key="aca.Privacidad" />
					</a>
				</div>
	</div>
	
	
	<form action="cursos.jsp" method="post" name="forma" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="CicloGrupoId">
		<input type="hidden" name="CursoId">
		<input type="hidden" name="i">
		
		<table class="table table-hover table-bordered">
					
<%

			ArrayList<aca.ciclo.CicloGrupoCurso> lisCursos = cicloGrupoCursoLista.getListAll(conElias, "WHERE EMPLEADO_ID = '"+maestroId+"' AND CICLO_GRUPO_ID LIKE '"+cicloId+"%' ORDER BY ORDEN_NGG(CICLO_GRUPO_ID), ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
			int i = 0;
			for(aca.ciclo.CicloGrupoCurso cicloGrupoCurso: lisCursos){
				
				cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());		
				
				String materia = PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
				
				String url = "evaluar.jsp";
				if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacion(conElias, (String) session.getAttribute("escuela"), cicloGrupo.getGrado() ,cicloGrupoCurso.getCursoId()).equals("C")){/* SI EVALUA POR COMPETENCIA */
					url = "evaluarCompetencias.jsp";
				}
				
				Integer nivelPlan = new Integer(Plan.getNivel(conElias, cicloGrupo.getPlanId()));
		%>
				<tr>
					<td style="cursor:pointer;padding:20px;" onclick="location.href='<%=url%>?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&randomString=<%=aca.util.RandomString.getRandomString() %>'">
						<h4 style="margin-top:0;">
							<%
								/*
								 *	Â¿Tiene Mensajes?
								 */
								int cantidadMensajes = Integer.parseInt(aca.alumno.AlumMensaje.mensajesNoLeidosPorMateria(conElias, cicloGrupo.getCicloGrupoId(), cicloGrupoCurso.getCursoId()));
								if(cantidadMensajes>0){
							%>
								<span class="badge badge-important"><%=cantidadMensajes %></span>
							<%
								}
							%>
							<%=materia%>
						</h4>
						<p>
							<%=Plan.getNombrePlan(conElias, cicloGrupo.getPlanId()) %> | 
						 	<strong><%=cicloGrupo.getGrupoNombre() %> <%=cicloGrupo.getGrupo() %></strong> 
						</p>
						<div >
							<a class="btn btn-info btn-mini stopPropagation" href="foros.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>">Foro</a>
							<a class="btn btn-primary btn-mini stopPropagation" href="lista.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>"><fmt:message key="maestros.Lista" /></a>
							<a class="btn btn-primary btn-mini stopPropagation" href="modulo.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>"><fmt:message key="maestros.Planeacion" /></a> 
							<a class="btn btn-success btn-mini stopPropagation" target="_blank" href="tarjeta.jsp?Curso=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&Materia=<%=materia %>&Maestro=<%=maestro%>"> <%=KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId() ) %> <fmt:message key="aca.Alumnos" /></a>
						<% 	String metodo = aca.catalogo.CatNivel.getMetodo(conElias, aca.catalogo.CatNivel.getNivelId(conElias, cicloGrupoCurso.getCursoId()));			  
							if(metodo.equals("S")){
								if(nivelPlan.compareTo(new Integer(2))<0 && cicloId.startsWith("H")){
									%>	
											<a class="btn btn-mini stopPropagation" href="metodo_kinder.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId()%>&Materia=<%=materia %>&Maestro=<%=maestro%>"> <fmt:message key="aca.MetodoEval" /></a>
									<%
											}else{
									%>
								<a class="btn btn-mini stopPropagation" href="metodo.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId()%>&Materia=<%=materia %>&Maestro=<%=maestro%>"> <fmt:message key="aca.MetodoEval" /></a>
						<% 	
											}
							}else{ 
						%>
								<a class="btn btn-mini stopPropagation" href="metodologia.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId()%>&Materia=<%=materia%>&Maestro=<%=maestro%>"><fmt:message key="aca.MetodoEval" /></a>
						<%	
							}
							
							if(permitirCambiarElEstado){
						%>
						
							<select class="stopPropagation" style="margin-bottom:0;" id="EstadoMat<%=i%>" name="EstadoMat<%=i%>" onchange="cambiarEstado('<%=cicloGrupoCurso.getCicloGrupoId()%>','<%=cicloGrupoCurso.getCursoId()%>','<%=i%>');">
								<option value="1" <%if(cicloGrupoCurso.getEstado().equals("1")){out.print("selected");} %>><fmt:message key="aca.Creada" /></option>
								<option value="2" <%if(cicloGrupoCurso.getEstado().equals("2")){out.print("selected");} %>><fmt:message key="boton.EvaluarOrdinario" /></option>
								<option value="3" <%if(cicloGrupoCurso.getEstado().equals("3")){out.print("selected");} %>><fmt:message key="boton.EvaluarExtra" /></option>
								<option value="4" <%if(cicloGrupoCurso.getEstado().equals("4")){out.print("selected");} %>><fmt:message key="boton.MateriaCerrada" /></option>
						    </select>
						    
						    <%} %>
						
							<div class="pull-right">
								<%if (cicloGrupoCurso.getEstado().equals("1")){%>
									<span class='label label-info'><fmt:message key="aca.MateriaCreada" /></span>
								<%}else if (cicloGrupoCurso.getEstado().equals("2")){%>
									<span class='label label-success'><fmt:message key="aca.MateriaEnEvaluacion" /></span>
								<%}else if (cicloGrupoCurso.getEstado().equals("3")){%>
									<span class='label label-important'><fmt:message key="aca.MateriaEnExtraordinario" /></span>
								<%}else if (cicloGrupoCurso.getEstado().equals("4")){%>
									<span class='label label-inverse'><fmt:message key="aca.MateriaCerrada" /></span>
								<%}%>
							</div>
						</div>
					</td>
				</tr>
		<%			i++;
				} %>
		</table>
	
	
	
	
	
	<!-- POPUP DE PRIVACIDAD -->
	
		<!-- MODAL -->
			<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			  <div class="modal-header">
			    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
			    <h4 id="myModalLabel"><fmt:message key="aca.Privacidad" /></h4>
			  </div>
			  <div class="modal-body ">
			  		
			  		
			  		<fmt:message key="portal.MensajePermiso" />
			  		&nbsp;
			        <select style="margin-bottom: 0px;" class="input-mini" id="privacidad" name="privacidad">
						<option value="S" <%if(empPersonal.getPublicar().equals("S"))out.print("selected");%>> <fmt:message key="aca.Si" /> </option>
						<option value="N" <%if(empPersonal.getPublicar().equals("N"))out.print("selected");%>> No </option>
					</select>
					
				</div>
			  <div class="modal-footer">
			  	<button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
				<a class="btn btn-primary" onclick="Grabar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
			  </div>
			</div>
		<!-- END MODAL -->
		
	
	<!-- END POPUP DE PRIVACIDAD -->

	</form>	
</div>

<script>
	//Stop propagation
	$('.stopPropagation').on('click', function(e){
	    e.stopPropagation();
	});
</script>

<%@ include file= "../../cierra_elias.jsp" %>