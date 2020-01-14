<%@ page import="java.text.*"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexConducta" scope="page" class="aca.kardex.KrdxAlumConducta" />
<jsp:useBean id="kardexConductaLista" scope="page" class="aca.kardex.KrdxAlumConductaLista" />
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso" />

<script>
	/*
	 * ABRIR INPUTS PARA EDITAR LAS NOTAS
	 */
	function muestraInput(promedioId){
		var editar = $('.editar'+promedioId);//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON
	 */
	function guardarCalificaciones(promedio, evaluacion){
		document.forma.Promedio.value = promedio;
		document.forma.Evaluacion.value = evaluacion;
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%
	//FORMATOS ---------------------------->
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoEmpleado");
	
	String cicloGrupoId	= request.getParameter("CicloGrupoId");
	String cursoId 		= request.getParameter("CursoId");
	String cicloId 		= (String) session.getAttribute("cicloId");
	String planId 		= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	
	String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	
	empPersonal.mapeaRegId(conElias, codigoId);	
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	
	ArrayList<aca.ciclo.CicloGrupoEval> lisEvaluacion 	= cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos	= kardexLista.getListAll(conElias,escuelaId, "AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");
	
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";
	
	if(accion.equals("1")){ //Guardar Conducta
		String promedio			= request.getParameter("Promedio");
		String evaluacion		= request.getParameter("Evaluacion");
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
	
		int cont = 0;
		for(aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos){

			kardexConducta.setCodigoId(kardex.getCodigoId());
			kardexConducta.setCicloGrupoId(cicloGrupoId);
			kardexConducta.setCursoId(cursoId);
			kardexConducta.setPromedioId(promedio);
			kardexConducta.setEvaluacionId(evaluacion);
			
			String conducta = request.getParameter("conducta"+cont+"-"+evaluacion);
			
			if(conducta != null){
				if(conducta.equals("")){//Si no tiene nota entonces eliminala si es que existe, si no pues ignora esa nota
					
					if(kardexConducta.existeReg(conElias)){
						if(kardexConducta.deleteReg(conElias)){
							//Elimino correctamente
						}else{
							error = true; break;
						}	
					}
					
				}else{//Si tiene nota entonces guardarla
					
					kardexConducta.setConducta(conducta);

					if (kardexConducta.existeReg(conElias)) {
						if(kardexConducta.updateReg(conElias)){
							//Modificado correctamente
						}else{
							error = true; break;
						}
					} else {
						if(kardexConducta.insertReg(conElias)){
							//Guardado correctamente
						}else{
							error = true; break;
						}
					}
					
				}
			}
			
			cont++;
		}
		
		
		//COMMIT OR ROLLBACK TO DB
		if(error){
			conElias.rollback();
			msj = "NoGuardo";
		}else{
			conElias.commit();
			msj = "Guardado";
		}
		
		conElias.setAutoCommit(true);//** END TRANSACTION **
				
	}
	
	pageContext.setAttribute("resultado", msj);

	ArrayList<aca.kardex.KrdxAlumConducta> lisKardexConducta = kardexConductaLista.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID), EVALUACION_ID");

	planCurso.mapeaRegId(conElias, cursoId);
	
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapConducta = aca.ciclo.CicloGrupoEvalLista.getMapConducta(conElias, cicloGrupoId, cursoId, planId );

	
%>

<div id="content">
	<h2><fmt:message key="maestros.RegistroConducta" /> <small><%=empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno()%></small></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="alert alert-info">
		<h4><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%></h4>
		<small><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></small> 
	</div>
	
	<%
	cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());		
	String url = "evaluar.jsp";
	if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacion(conElias, (String) session.getAttribute("escuela"), cicloGrupo.getGrado() ,cicloGrupoCurso.getCursoId()).equals("C")){/* SI EVALUA POR COMPETENCIA */
		url = "evaluarCompetencias.jsp";
	}
	%>
	<div class="well">
		<a href="<%=url %>?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>" class="btn btn-primary btn-mobile"><i class="icon-arrow-left icon-white"></i><fmt:message key="boton.Regresar" /></a>
	</div>
	
	<!--  -------------------- TABLA DE EVALUACIONES -------------------- -->
	
	<table class="table table-condensed table-bordered table-striped">
		<tr>
			<th class="text-center">#</th>
			<th><fmt:message key="aca.Descripcion" /></th>
			<th><fmt:message key="aca.Fecha" /></th>
			<th class="text-center"><fmt:message key="aca.Estado" /></th>
		</tr>
		<%
			int cont = 0;
			for(aca.ciclo.CicloGrupoEval eval : lisEvaluacion){
				cont++;
									
				boolean evaluarConducta = false;
				
				if(mapConducta.size()>0){
					
					if(mapConducta.containsKey(eval.getEvaluacionId())){
						String edo = mapConducta.get(eval.getEvaluacionId()).getEstado();
						if(edo.equals("A")){
							evaluarConducta = true;
						}
					}	
				}
		%>
				
				<tr>
					<td class="text-center"><%=cont%></td>
					<td>
						<% if(cicloGrupoCurso.getEstado().equals("2") && eval.getEstado().equals("A") && evaluarConducta){%> 
							<a href="javascript:muestraInput('<%=eval.getEvaluacionId()%>');"> 
								<%=eval.getEvaluacionNombre()%>
							</a> 
						<%}else{%>
							<%=eval.getEvaluacionNombre()%>
						<%}%>
					</td>
					<td><%=eval.getFecha()%></td>
					<td class="text-center">
						<%if (eval.getEstado().equals("A") && evaluarConducta) {%>
							<span class="label label-success"><fmt:message key="aca.Abierto" /></span>								
						<%}else if (eval.getEstado().equals("C") || evaluarConducta==false) {%> 					
							<span class="label label-inverse" <%if(evaluarConducta==false){%>title="<fmt:message key="maestros.LaMateriaYaFueCerrada" />"<%}%>><fmt:message key="aca.Cerrado" /></span>
						<%}%>
					</td>
				</tr>
		<%
			}
		%>
	</table>
	
	<!--  -------------------- TABLA DE ALUMNOS -------------------- -->
	
	<form action="evaluarConducta.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" name="forma" method="post">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Evaluacion" />
		<input type="hidden" name="Promedio" />
		
		<table class="table table-condensed table-bordered table-striped">
			
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.NombreDelAlumno" /></th>
						<%
							cont = 0;
							for(aca.ciclo.CicloGrupoEval eval : lisEvaluacion){
								cont++;
						%>
							<th style="width:3%;" class="text-center" title="<%=eval.getEvaluacionNombre()%>"><%=cont%></th>
						<%
							}
						%>
					<th class="text-center"><fmt:message key="aca.Promedio" /></th>
				</tr>
			</thead>
			
			<%
			int i = 0;
			for(aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos){
			%>
				<tr>
					<td class="text-center"><%=i+1%></td>
					<td class="text-center"><%=kardex.getCodigoId()%></td>
					<td>
						<%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>
						
						<%if(kardex.getTipoCalId().equals("6")){ %>
				  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
				  		<%} %>
					</td>
					<%
						float sumaConducta = 0;
						int cantidadEvaluaciones = 0;
						for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
									
							String conducta = "-";
							
							for (aca.kardex.KrdxAlumConducta kardexConductaAlumno: lisKardexConducta) {
								if ( kardexConductaAlumno.getCodigoId().equals(kardex.getCodigoId()) &&
										eval.getPromedioId().equals(kardexConductaAlumno.getPromedioId())&&
										eval.getEvaluacionId().equals(kardexConductaAlumno.getEvaluacionId()) ) {					
								
									// Verifica si la materia evalua con decimales
									if (evaluaConPunto.equals("S")) {
										conducta = frmDecimal.format(Double.parseDouble(kardexConductaAlumno.getConducta())).replaceAll(",", ".");
									} else {
										conducta = frmEntero.format(Double.parseDouble(kardexConductaAlumno.getConducta())).replaceAll(",", ".");
									}
									
									sumaConducta += Float.parseFloat(kardexConductaAlumno.getConducta());
									cantidadEvaluaciones++;
								}
							}
					%>
							<td class="text-center">
								<div><%=conducta %></div>
								
								<%if (!kardex.getTipoCalId().equals("6") && eval.getEstado().equals("A") ) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
									<div class="editar<%=eval.getEvaluacionId() %>" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-allow-decimal="<%=evaluaConPunto.equals("S")?"si":"no" %>"
											data-max-num="<%=escala %>"
											type="text" 
											tabindex="<%=i+1%>" 
											name="conducta<%=i%>-<%=eval.getEvaluacionId()%>"
											id="conducta<%=i%>-<%=eval.getEvaluacionId()%>" 
											value="<%=conducta.equals("-")?"":conducta %>" 
										/>
									</div>
								<%}%>
							</td>
					<%
						}
						
						String total = "-";
						if(sumaConducta != 0){
							total = frmDecimal.format((double)sumaConducta/(double)cantidadEvaluaciones).replace(',','.');
						}
					%>
					
						<td class="text-center"><%=total %></td>
				</tr>
			<%
				i++;
			}
			%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<%for (aca.ciclo.CicloGrupoEval eval :  lisEvaluacion) {%>
					<td class="text-center">
						<div class="editar<%=eval.getEvaluacionId() %>" style="display:none;">
							<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarCalificaciones( '<%=eval.getPromedioId()%>','<%=eval.getEvaluacionId()%>' );"><fmt:message key="boton.Guardar" /></a> 
						</div>
					</td>
								
				<%}%>
				<td>&nbsp;</td>
			</tr>
			
		</table>
	</form>
</div>


<%@ include file="../../cierra_elias.jsp"%>