<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="krdxAlumFaltaL" scope="page" class="aca.kardex.KrdxAlumFaltaLista" />
<jsp:useBean id="krdxAlumFalta" scope="page" class="aca.kardex.KrdxAlumFalta" />
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>

<script>
	/*
	 * ABRIR INPUTS PARA EDITAR LAS NOTAS
	 */
	function muestraInput(evaluacionId){
		var editar = $('.editar'+evaluacionId);//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON
	 */
	function guardarCalificaciones(promedio){
		document.forma.Promedio.value = promedio;
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("##0;(##0)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoId");	
	String cicloId 			= (String) session.getAttribute("cicloId");

	String cicloGrupoId 	= request.getParameter("CicloGrupoId");
	String cursoId 			= request.getParameter("CursoId");
	String planId			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	
	String nivelEvaluacion 	= aca.ciclo.Ciclo.getNivelEval(conElias, cicloId);
	
	empPersonal.mapeaRegId(conElias, codigoId);	
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	
	//Lista de promedios	
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");	
	
	// Lista de alumnos en la materia
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos	= kardexLista.getListAll(conElias,escuelaId, "AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");


	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 		= "";
	
	if (accion.equals("1")) { //Guardar Faltas
		String promedio = request.getParameter("Promedio");
	
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		int cont = 0;
		for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
			krdxAlumFalta.setCodigoId(kardex.getCodigoId());
			krdxAlumFalta.setCicloGrupoId(cicloGrupoId);
			krdxAlumFalta.setCursoId(cursoId);
			krdxAlumFalta.setPromedioId(promedio);
			krdxAlumFalta.setEvaluacionId("0");			
			
			String falta 		= request.getParameter("falta" + cont + "-" + promedio);
			String tardanza 	= request.getParameter("tardanza" + cont + "-" + promedio);
			
			if (falta != null && tardanza != null){				
			
				//Si no tiene nota entonces eliminala si es que existe, si no pues ignora esa nota
				if (falta.equals("") && tardanza.equals("")){
					
					if(krdxAlumFalta.existeReg(conElias)){
						
						if(krdxAlumFalta.deleteReg(conElias)){
							//Elimino correctamente
						}else{
							error = true; break;
						}	
					}
					
				//Si tiene nota entonces guardarla	
				}else{
					
					// Valida Falta
					krdxAlumFalta.setFalta(falta);
					if(falta.equals("") || falta.isEmpty())
						krdxAlumFalta.setFalta("0");
					
					// Valida Tardanza
					krdxAlumFalta.setTardanza(tardanza);					
					if(tardanza.equals("") || tardanza.isEmpty())
						krdxAlumFalta.setTardanza("0");
						
					if (krdxAlumFalta.existeReg(conElias)) {
						
						if(krdxAlumFalta.updateReg(conElias)){
							//Modificado correctamente
						}else{
							error = true; break;
						}
					} else {
						if(krdxAlumFalta.insertReg(conElias)){
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

	ArrayList<aca.kardex.KrdxAlumFalta> lisKardexFalta = krdxAlumFaltaL.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID), EVALUACION_ID");

	planCurso.mapeaRegId(conElias, cursoId);
%>

<div id="content">
	<h3>
	<fmt:message key="maestros.RegistrodeFaltas" />
	<small>(&nbsp;
		<%=empPersonal.getNombre() + " " + empPersonal.getApaterno() + " " + empPersonal.getAmaterno()%> |&nbsp;
		<%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%> |&nbsp;
		<%=aca.plan.Plan.getNombrePlan(conElias, planId)%>
	&nbsp;)</small>
	</h3>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>	
	<%
	cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());		
	
	String url = "evaluar.jsp";
	if(aca.catalogo.CatEsquemaLista.getEsquemaEvaluacion(conElias, (String) session.getAttribute("escuela"), cicloGrupo.getGrado() ,cicloGrupoCurso.getCursoId()).equals("C")){/* SI EVALUA POR COMPETENCIA */
		url = "evaluarCompetencias.jsp";
	}
	%>
	<div class="well">
		<a class="btn btn-primary btn-mobile" href="<%=url %>?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<!--  ------------- TABLA DE PROMEDIOS O EVALUACIONES ----------------- -->
	
	<table class="table table-condensed table-bordered table-striped">
		<tr>
			<th class="text-center">#</th>
			<th><fmt:message key="aca.Descripcion" /></th>
		</tr>
		<%
			int cont = 0;			
			for (aca.ciclo.CicloPromedio prom : lisPromedio) {		
				cont++;
		%>
			<tr>
				<td class="text-center"><%=cont%></td>
				<td>					 
					<a href="javascript:muestraInput('<%=prom.getPromedioId()%>');">
						<%=prom.getNombre()%>
					</a>				
				</td>				
			</tr>
		<%	
			}	
		%>
	</table>
	
	<!--  -------------------- TABLA DE ALUMNOS -------------------- -->
	
	<form action="evaluarFaltasProm.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" name="forma" method="post">
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Promedio" />
			
		<table class="table table-condensed table-bordered table-striped">
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.NombreDelAlumno" /></th>
						<%
						cont = 0;
						for (aca.ciclo.CicloPromedio prom : lisPromedio) {
							cont++;
						%>
							<th style="width:3%;" class="text-center" title="<%=prom.getNombre()%>(Falta)"><%=cont%>F</th>							
							<th style="width:3%;" class="text-center" title="<%=prom.getNombre()%>(Tardanza)"><%=cont%>T</th>
						<%}%>
					<th class="text-center"><fmt:message key="aca.Total" />(F)</th>
					<th class="text-center"><fmt:message key="aca.Total" />(T)</th>
				</tr>
			</thead>
			<%
			int i = 0;
			for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
			%>
				<tr>
					<td class="text-center"><%=i+1%></td>
					<td class="text-center"><%=kardex.getCodigoId()%></td>
					<td>
						<%=aca.alumno.AlumPersonal.getNombre(conElias,kardex.getCodigoId(), "APELLIDO")%>
						
						<%if(kardex.getTipoCalId().equals("6")){ %>
				  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
				  		<%} %>
					</td>
					<%
						float sumaFaltas 	= 0;
						float sumaTardanzas = 0;
						for (aca.ciclo.CicloPromedio prom : lisPromedio) {
							
							String faltas 		= "-";
							String tardanzas 	= "-";
							for (aca.kardex.KrdxAlumFalta kardexAlumFalta: lisKardexFalta) {
								if ( kardexAlumFalta.getCodigoId().equals(kardex.getCodigoId()) && 
									prom.getPromedioId().equals(kardexAlumFalta.getPromedioId()) &&
									kardexAlumFalta.getEvaluacionId().equals("0")
									){
									faltas = kardexAlumFalta.getFalta();
									sumaFaltas += Float.parseFloat(kardexAlumFalta.getFalta());
									tardanzas = kardexAlumFalta.getTardanza();
									sumaTardanzas += Float.parseFloat(kardexAlumFalta.getTardanza());
								}
							}
					%>
							<td class="text-center">
								<div><%=faltas %></div>
								
								<%if (!kardex.getTipoCalId().equals("6")) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
									<div class="editar<%=prom.getPromedioId() %>" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-allow-decimal="no"
											type="text" 
											tabindex="<%=i+1%>" 
											name="falta<%=i%>-<%=prom.getPromedioId()%>"
											id="falta<%=i%>-<%=prom.getPromedioId()%>" 
											value="<%=faltas.equals("-")?"":faltas %>" 
										/>
									</div>
								<%}%>
							</td>							
							<td class="text-center">
								<div><%=tardanzas%></div>
								
								<%if (!kardex.getTipoCalId().equals("6")) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
									<div class="editar<%=prom.getPromedioId() %>" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-allow-decimal="no"
											type="text" 
											tabindex="<%=i+1%>" 
											name="tardanza<%=i%>-<%=prom.getPromedioId()%>"
											id="tardanza<%=i%>-<%=prom.getPromedioId()%>" 
											value="<%=tardanzas.equals("-")?"":tardanzas %>" 
										/>
									</div>
								<%}%>
							</td>
					<%
						}
						
						String totalFaltas = "-";
						if(sumaFaltas != 0){
							totalFaltas = getformato.format(sumaFaltas).replace(',','.');
						}
						String totalTardanzas = "-";
						if(sumaTardanzas != 0){
							totalTardanzas = getformato.format(sumaTardanzas).replace(',','.');
						}
					%>	
						
						<td class="text-center"><%=totalFaltas %></td>
						<td class="text-center"><%=totalTardanzas %></td>
				</tr>
			<%
				i++;
			}
			%>
			
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<%for (aca.ciclo.CicloPromedio prom :  lisPromedio) {%>
					<td class="text-center" colspan="2">
						<div class="editar<%=prom.getPromedioId() %>" style="display:none;">
							<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarCalificaciones( '<%=prom.getPromedioId()%>' );"><fmt:message key="boton.Guardar" /></a> 
						</div>
					</td>
								
				<%}%>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			
		</table>
	</form>
</div>
<script>
$('body').on('keydown', 'input, select, textarea', function(e) {
    var self = $(this)
      , form = self.parents('form:eq(0)')
      , focusable
      , next
      ;
    if (e.keyCode == 13) {
        focusable = form.find('input,a,select,button,textarea').filter(':visible');
        next = focusable.eq(focusable.index(this)+1);
        if (next.length) {
            next.focus();
        } else {
            form.submit();
        }
        return false;
    }
});
</script>
<%@ include file="../../cierra_elias.jsp"%>