<%@page import="aca.kardex.KrdxAlumEval"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="KrdxCursoAct" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="CatTipocal" scope="page" class="aca.catalogo.CatTipocal"/>

<script>
	function recarga(){
		document.forma.submit();
	}
	
	function Grabar(grupo,curso){
		document.frmCurso.Accion.value = "1";
		document.frmCurso.Grupo.value = grupo;
		document.frmCurso.Curso.value = curso;
		document.frmCurso.submit();
	}
		
	function Borrar(grupo,curso){
		document.frmCurso.Accion.value = "2";
		document.frmCurso.Grupo.value = grupo;
		document.frmCurso.Curso.value = curso;	 	
		document.frmCurso.submit();
	}
		
	function BorrarNotas(grupo,curso){
		if(confirm("<fmt:message key="js.ConfirmaBorradoNotas" />")){
			document.frmCurso.Accion.value = "3";
			document.frmCurso.Grupo.value = grupo;
			document.frmCurso.Curso.value = curso;	 	
			document.frmCurso.submit();
		}	
	}
	
	function BorrarCiclo(ciclo){
		if(confirm("<fmt:message key="js.ConfirmaBorradoNotas" />")){
			location.href="altaBaja.jsp?BorrarCiclo=1&cicloBorrar="+ciclo;
		}	
	}
</script>

<%	
	
	String escuelaId 				= (String) session.getAttribute("escuela");
	String codigoId 				= (String) session.getAttribute("codigoAlumno");	
	String cicloId					= (String) session.getAttribute("cicloAlumnoId");
	String planAlumno				= aca.alumno.AlumPlan.getPlanActual(conElias,codigoId);
	
	AlumPersonal.mapeaRegId(conElias, codigoId);
	
	if(request.getParameter("BorrarCiclo") != null){//Borrar Ciclo
		ArrayList<String> grupos = aca.kardex.KrdxCursoActLista.getAlumGrupos(conElias, codigoId, request.getParameter("cicloBorrar"));
		if(grupos.size()==0){
			aca.alumno.AlumCiclo.updateEstado(conElias, codigoId, request.getParameter("cicloBorrar"), "M");
		}
	}
	
	
	/* ==== TRAER CICLO CORRECTO ==== */
	ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListCiclosAlumInscrito(conElias, codigoId, "ORDER BY CICLO_ID");
	
	if(request.getParameter("cicloId") != null){/* Si esta cambiando de ciclo */
		cicloId = request.getParameter("cicloId");
		session.setAttribute("cicloAlumnoId", cicloId);
	}
	
	boolean encontrado = false;
	for(aca.ciclo.Ciclo ciclo : lisCiclo){
		if( ciclo.getCicloId().equals(cicloId) ){
			encontrado = true; break;
		}
	}
	if( encontrado == false && lisCiclo.size() > 0 ){
		cicloId = lisCiclo.get(0).getCicloId();
		session.setAttribute("cicloAlumnoId", cicloId);
	}
	
/* ********************************** ACCIONES ********************************** */

	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");		
	String mensaje 		= "";

//------------- GUARDAR MATERIA ------------->
	if(accion.equals("1")){
		
		KrdxCursoAct.setCodigoId( codigoId );
		KrdxCursoAct.setCicloGrupoId(request.getParameter("Grupo"));
		KrdxCursoAct.setCursoId(request.getParameter("Curso"));
		
		if (!KrdxCursoAct.existeReg(conElias) ){
			KrdxCursoAct.setTipoCalId("1");
			KrdxCursoAct.setNota("-1");
			if (KrdxCursoAct.insertRegMateria(conElias)){
				conElias.commit();
				mensaje = "MateriaGrabada";
			}else{
				mensaje = "ErrorGrabarMateria";
			}
		}else{
			mensaje = "MateriaYaAsignada";
		}
		
	}
//------------- ELIMINAR MATERIA ------------->	
	else if(accion.equals("2")){
		KrdxCursoAct.setCodigoId( codigoId );
		KrdxCursoAct.setCicloGrupoId(request.getParameter("Grupo"));
		KrdxCursoAct.setCursoId(request.getParameter("Curso"));
		if (KrdxCursoAct.existeReg(conElias) ){
			boolean tieneEval	= aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoId, KrdxCursoAct.getCicloGrupoId(), KrdxCursoAct.getCursoId());
			boolean tieneActiv  = aca.kardex.KrdxCursoAct.getMatAlumTieneActiv(conElias, codigoId, KrdxCursoAct.getCicloGrupoId(), KrdxCursoAct.getCursoId());
			if (!tieneEval&&!tieneActiv){
				if (KrdxCursoAct.deleteReg(conElias)){
					mensaje = "MateriaBorrada";
				}
			}else{
				if (tieneEval&&tieneActiv){
					mensaje = "ErrorPorActividades";
				}else{
					mensaje = "ErrorPorEvaluaciones";	
				}
			}
		}
	}
//------------- ELIMINAR ACTIVIDADES Y EVALUACIONES ------------->
	else if(accion.equals("3")){
		KrdxCursoAct.setCodigoId( codigoId );
		KrdxCursoAct.setCicloGrupoId(request.getParameter("Grupo"));
		KrdxCursoAct.setCursoId(request.getParameter("Curso"));
		boolean tieneEval	= aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoId,KrdxCursoAct.getCicloGrupoId(), KrdxCursoAct.getCursoId());
		boolean tieneActiv  = aca.kardex.KrdxCursoAct.getMatAlumTieneActiv(conElias, codigoId,KrdxCursoAct.getCicloGrupoId(), KrdxCursoAct.getCursoId());
		
		conElias.setAutoCommit(false);
		
		if (KrdxCursoAct.existeReg(conElias) ){			
			if (tieneActiv){
				if (aca.kardex.KrdxAlumActiv.deleteRegMateria(conElias, codigoId, KrdxCursoAct.getCicloGrupoId(), KrdxCursoAct.getCursoId()))
					tieneActiv = false;
			}
			
			if (tieneEval && !tieneActiv){
				if (aca.kardex.KrdxAlumEval.deleteRegMateria(conElias, codigoId, KrdxCursoAct.getCicloGrupoId(), KrdxCursoAct.getCursoId()))
					tieneEval = false;
			}
			
			if (!tieneActiv && !tieneEval){
				conElias.commit();					 
				mensaje = "EvaluacionesBorradas";
			}else{
				mensaje = "ImposibleBorrarEval";					
			}
		}
		
		conElias.setAutoCommit(true);
	}
//------------- ACTIVAR MATERIA (DAR DE ALTA) ------------->
	else if(accion.equals("4")){
		KrdxCursoAct.mapeaRegId(conElias, codigoId, request.getParameter("Grupo"), request.getParameter("Curso"));
		KrdxCursoAct.setTipoCalId("1");
		if (KrdxCursoAct.existeReg(conElias) ){				
			if(KrdxCursoAct.updateReg(conElias)){
				mensaje = "AltaDeMateria";	
			}else{
				mensaje = "ErrorAltaDeMateria";
			}
			
		}
		else{
			mensaje = "ErrorAltaDeMateria";
		}
	}
//------------- DAR DE BAJA MATERIA ------------->
	else if(accion.equals("5")){
		KrdxCursoAct.mapeaRegId(conElias, codigoId, request.getParameter("Grupo"), request.getParameter("Curso"));
		KrdxCursoAct.setTipoCalId("6");
		if (KrdxCursoAct.existeReg(conElias) ){				
			if(KrdxCursoAct.updateReg(conElias)){
				mensaje = "BajaDeMateria";	
			}else{
				mensaje = "ErrorBajaDeMateria";	
			}
		}
		else{
			mensaje = "ErrorBajaDeMateria";
		}
	}
		
		
/* ********************************** END ACCIONES ********************************** */
		
	pageContext.setAttribute("mensaje", mensaje);

%>

<div id="content">
	
	<%if(!AlumPersonal.existeReg(conElias)){ %>
		<div class="alert">
			<fmt:message key="aca.NoAlumnoSeleccionado" />
		</div>
	<%}else if(lisCiclo.size()==0){ %>
		<div class="alert">
			<fmt:message key="aca.ciclosNoDisponibles" />
		</div>
	<%}else{ %>
		
		<%		
			String grupo 		= request.getParameter("Grupo")==null?"":request.getParameter("Grupo");
			String plan			= aca.kardex.KrdxCursoAct.getAlumPlan(conElias, codigoId, cicloId);
		%>
		
		<h2>
			<fmt:message key="altaBaja.AltaBaja" />
		</h2>
		
		<div class="well" style="background:white;"> 
			
			<div class="row">
				<div class="span1">
					<img src="../../parametros/foto/foto.jsp?mat=<%=codigoId%>" width="100">
				</div>
				
				<div class="span6">
						<strong style="font-size: 19px;"><fmt:message key="aca.DatosActuales" /></strong> <br />
						<strong><fmt:message key="aca.Alumno" />:</strong> <%=codigoId%> | <%=AlumPersonal.getNombre()+" "+AlumPersonal.getApaterno()+" "+AlumPersonal.getAmaterno() %> <br />
						<strong><fmt:message key="aca.Plan" />:</strong>  <%= aca.plan.Plan.getNombrePlan(conElias,planAlumno)%> <br />
						<strong><fmt:message key="catalogo.Nivel" />:</strong>  <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, AlumPersonal.getNivelId())%> <br /> 
						<strong><fmt:message key="aca.Grado" />:</strong>  <%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(AlumPersonal.getGrado()))%> "<%=AlumPersonal.getGrupo()%>" <br /> 
				</div>
			</div>
	  	</div>

		
		<form name="forma" method="post" action="altaBaja.jsp">
			<div class="well">	
				<select name="cicloId" onchange="javascript:recarga()" class="input-xxlarge">		
					<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
						<option value="<%=ciclo.getCicloId()%>"<%if(ciclo.getCicloId().equals(cicloId)) out.print("selected");%>><%=ciclo.getCicloNombre()%></option>
					<%}%>
				</select>
			</div>  
		</form>

			
		
		<%
			ArrayList<String> grupos = aca.kardex.KrdxCursoActLista.getAlumGrupos(conElias, codigoId, cicloId);
		
			if(grupos.size()==0){
		%>
				<div class="well">
					<a href="javascript:BorrarCiclo('<%=cicloId %>');" class="btn btn-danger"><i class="icon-remove icon-white"></i> <fmt:message key="aca.DesinscribirDelCiclo" /></a>
				</div>
		<%
			}else{
		%>
		
				<ul class="nav nav-tabs">
					<%		
						for(String str : grupos){
							if(grupo.equals("")){
								grupo = str;
							}
					%>
							<li <%if(grupo.equals(str)){%>class="active"<%}%>>
						    	<a href="altaBaja.jsp?Grupo=<%=str%>"><%=str%></a>
						  	</li>
					<%
						}
					%>
				</ul>
				
				<%
					Grupo.mapeaRegId(conElias, grupo);
					
					ArrayList<aca.ciclo.CicloGrupoCurso> lisMaterias		= GrupoCursoLista.getAlumCursosAsignados(conElias, Grupo.getCicloGrupoId(), codigoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
					ArrayList<aca.ciclo.CicloGrupoCurso> lisMateriasDisp	= GrupoCursoLista.getAlumCursosDisponibles(conElias, Grupo.getCicloGrupoId(), codigoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");	
				%>
		
				<form name="frmCurso" method="post" action="altaBaja.jsp">
					<input type="hidden" name="Accion">
					<input type="hidden" name="Grupo">
					<input type="hidden" name="Curso">
					
					<div class="alert alert-info">
						<strong><fmt:message key="aca.Plan" />:</strong>  <%= aca.plan.Plan.getNombrePlan(conElias,Grupo.getPlanId())%> <br />
						<strong><fmt:message key="catalogo.Nivel" />:</strong>  <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, Grupo.getNivelId())%> <br /> 
						<strong><fmt:message key="aca.Grado" />:</strong>  <%=aca.catalogo.CatNivel.getGradoNombreCorto(Integer.parseInt(Grupo.getGrado().equals("")?"-1":Grupo.getGrado()))%> "<%=Grupo.getGrupo()%>" <br /> 
					</div>
					
					<div class="row">
					
						<div class="span6">
							<table class="table table-condensed table-bordered">
					    		<tr>
						  			<td colspan="5" class="text-center alert">
						  				<fmt:message key="aca.MateriasAsignadas" />
						  			</td>
								</tr>
								<tr>
									<th><fmt:message key="aca.Opcion" /></th>					
								  	<th><fmt:message key="aca.Materia" /></th>
								  	<th><fmt:message key="aca.Profesor" /></th>
								  	<th><fmt:message key="aca.Evaluo" /></th>
								  	<th><fmt:message key="aca.Estado" /></th>
								</tr>
								<%		
									for(aca.ciclo.CicloGrupoCurso materia : lisMaterias){
				
										boolean tieneEval	= aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoId, materia.getCicloGrupoId(), materia.getCursoId());
										KrdxCursoAct.mapeaRegId(conElias, codigoId, materia.getCicloGrupoId(), materia.getCursoId());
										CatTipocal.mapeaRegId(conElias, KrdxCursoAct.getTipoCalId());
								%>
										<tr>
					 	  					<td>
					 	  						<%if (!tieneEval){%>
					 	    						<a href="javascript:Borrar('<%=materia.getCicloGrupoId()%>','<%=materia.getCursoId()%>')" title="<fmt:message key="aca.BorrarMateria" />">
														<i class="icon-remove"></i>
													</a>
					 	  						<%}
					 	  						if(KrdxCursoAct.getTipoCalId().equals("6")){%>
					 								<a title="Dar de alta" href="altaBaja.jsp?Accion=4&Grupo=<%=materia.getCicloGrupoId()%>&Curso=<%=materia.getCursoId()%>">
					 		  							<i class="icon-thumbs-up"></i>
				 		  							</a>
					 	  						<%}
					 	  						if (!KrdxCursoAct.getTipoCalId().equals("6")){%>
						 							<a title="Dar de baja" href="altaBaja.jsp?Accion=5&Grupo=<%=materia.getCicloGrupoId()%>&Curso=<%=materia.getCursoId()%>">
						 		  						<i class="icon-thumbs-down"></i>
					 		  						</a>
					 	  						<%}%>
						  					</td>
						  					<td><%=aca.plan.PlanCurso.getCursoNombre(conElias, materia.getCursoId())%></td>
						  					<td><%=aca.empleado.EmpPersonal.getNombre(conElias, materia.getEmpleadoId(), "NOMBRE")%></td>
						  					<td>
												<%if (tieneEval){%>
													<a href="javascript:BorrarNotas('<%=materia.getCicloGrupoId()%>','<%=materia.getCursoId()%>')" title="<fmt:message key="boton.BorrarNotas" />">
														<fmt:message key="aca.Si" />
													</a>
												<%}else{%> 
													<fmt:message key="aca.Negacion" />
												<%}%>
						  					</td>
						  					<td><%=CatTipocal.getTipocalNombre() %></td>
										</tr>
								<%		
									} 
								%>
					  		</table>		
						</div>
						
						<div class="span6">
							<table class="table table-condensed table-bordered">
					    		<tr>
						  			<td colspan="4" class="text-center alert">
						  				<fmt:message key="aca.MateriasDisponibles" />
						  			</td>
								</tr>
								<tr>
						  			<th><fmt:message key="aca.Opcion" /></th>
						  			<th><fmt:message key="aca.Materia" /></th>
						  			<th><fmt:message key="aca.Profesor" /></th>
								</tr>
								<%for(aca.ciclo.CicloGrupoCurso materia : lisMateriasDisp){%>
									<tr>
					 	  				<td>			
											<a href="javascript:Grabar('<%=materia.getCicloGrupoId()%>','<%=materia.getCursoId()%>')">
												<fmt:message key="aca.AgregarMateria" />
											</a>
						  				</td>
						  				<td><%=aca.plan.PlanCurso.getCursoNombre(conElias, materia.getCursoId())%></td>
						  				<td><%=aca.empleado.EmpPersonal.getNombre(conElias, materia.getEmpleadoId(), "NOMBRE")%></td>				
									</tr>
								<%}%>
							</table>
						</div>
					
					</div>
				
				</form>
			<%} %>
	<%}%>
</div>

<%@ include file= "../../cierra_elias.jsp" %>
