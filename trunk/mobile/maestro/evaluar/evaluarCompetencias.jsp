<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista" />
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />

<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval" />
<jsp:useBean id="cicloGrupoActividadL" scope="page" class="aca.ciclo.CicloGrupoActividadLista"/>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="krdxAlumActivL" scope="page" class="aca.kardex.KrdxAlumActivLista"/>
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="kardexConductaLista" scope="page" class="aca.kardex.KrdxAlumConductaLista" />
<jsp:useBean id="kardexEval" scope="page" class="aca.kardex.KrdxAlumEval" />
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso" />

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
	 * ABRIR INPUTS PARA EDITAR LAS NOTAS
	 */
	function muestraInputPromedio(){
		var editar = $('.editarPromedio');//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON
	 */
	function guardarCalificaciones(evaluacion){
		document.forma.Evaluacion.value = evaluacion;
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
	
	/*
	 * BORRA TODAS LAS NOTAS DE UNA EVALUACION
	 */
	function borrarCalificaciones(evaluacion){	
		if ( confirm("<fmt:message key="js.EsteProcesoEliminaTodasLasNotas" />")==true ){
			document.forma.Evaluacion.value = evaluacion;
			document.forma.Accion.value = "2";
			document.forma.submit();	
		}		
	}	
	
	/*
	 * GUARDA EL PROMEDIO
	 */
	function guardarPromedio(){
		document.forma.Accion.value = "7";
		document.forma.submit();
	}
	
	
	/*
	 * CERRAR EVALUACION
	 */
	function cerrarEvaluacion(evaluacion){
		if(confirm("<fmt:message key="js.CerrarEvaluacion"/>")==true){
  			document.forma.Evaluacion.value = evaluacion;
			document.forma.Accion.value = "3";
			document.forma.submit();	
	  	}
	}
	
	/*
	 * ABRIR EVALUACION
	 */
	function abrirEvaluacion(evaluacion){
		if(confirm("<fmt:message key="js.AbrirEvaluacion" />")==true){
	  		document.forma.Evaluacion.value = evaluacion;
			document.forma.Accion.value = "4";
			document.forma.submit();
	  	}
	}
	
	/*
	 * CERRAR MATERIA
	 */
	function cerrarMateria(){
		if(confirm("<fmt:message key="js.CerrarMateria"/>")==true){
			document.forma.Accion.value = "8";
			document.forma.submit();	
	  	}
	}
	
	/*
	 * ABRIR INPUTS PARA EDITAR LOS EXTRAORDINARIOS
	 */
	function muestraInputExtra(evaluacionId){
		var editar = $('.editarExtra');//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * ABRIR INPUTS PARA EDITAR LOS EXTRAORDINARIOS 2
	 */
	function muestraInputExtra2(evaluacionId){
		var editar = $('.editarExtra2');//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON EN LOS EXTRAORDINARIOS
	 */
	function guardarExtra(cantidadAlumnos){
		document.forma.Accion.value = "5";
		document.forma.submit();
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON EN LOS EXTRAORDINARIOS 2
	 */
	function guardarExtra2(cantidadAlumnos){
		document.forma.Accion.value = "8";
		document.forma.submit();
	}
	
	/*
	 * PROMEDIAR CONDUCTA
	 */
	function promediarConducta(evaluacion){
		if(confirm("<fmt:message key="js.PromediarConductaEvaluacion" />")==true){
			document.forma.Evaluacion.value = evaluacion;
			document.forma.Accion.value = "6";
			document.forma.submit();
		}
	}
	
	/*
	 * CERRAR EXTRA
	 */
	function cerrarExtra(){
		document.forma.Accion.value = "7";
		document.forma.submit();
	}
	
</script>

<%
	
	//FORMATOS ---------------------------->
	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0");
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String codigoId 		= (String) session.getAttribute("codigoEmpleado");
	boolean permitirCambiarElEstado = true;
	

	String accion 			= request.getParameter("Accion") == null?"0":request.getParameter("Accion");
	String cicloGrupoId	 	= request.getParameter("CicloGrupoId");
	String cursoId 			= request.getParameter("CursoId");
	String estado 			= request.getParameter("estado");
	
	String planId 			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String nivelId  		= aca.plan.Plan.getNivel(conElias, planId);
	
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
	String estadoMateria    = cicloGrupoCurso.getEstado(); /* 1 = Materia creada, 2 = Materia en evaluacion, 3 = Materia en extraordinario, 4 = Materia cerrada */
	
	//INFORMACION DEL MAESTRO
	empPersonal.mapeaRegId(conElias, codigoId);
	
	//LISTA DE EVALUACIONES EN LA MATERIA
	ArrayList<aca.ciclo.CicloGrupoEval> lisEvaluacion = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	
	
	//SI LA MATERIA TIENE ESTADO DE 'MATERIA CREADA' ENTONCES CAMBIALO A 'MATERIA EN EVALUACION'
	if ( estadoMateria.equals("1") ) {
		cicloGrupoCurso.setEstado("2");
		cicloGrupoCurso.updateReg(conElias);
	}
	
	//LISTA DE ALUMNOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	

	
	
/* ********************************** ACCIONES ********************************** */
	String msj = "";	

//------------- GUARDA CALIFICACIONES DE UNA EVALUACION ------------->
	if (accion.equals("1")) {
		String evaluacion 		= request.getParameter("Evaluacion");
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;
		
		int cont = 0;
		for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {/* Recorre cada alumno para guardarle su nota en cierta evaluacion */
			
			kardexEval.setCodigoId(kardex.getCodigoId());
			kardexEval.setCicloGrupoId(cicloGrupoId);
			kardexEval.setCursoId(cursoId);
			kardexEval.setEvaluacionId(evaluacion);
			String nota = request.getParameter("nota" + cont + "-" + evaluacion);
			
			if (nota != null) {
				if (nota.equals("")){//Si no tiene nota entonces eliminala si es que existe, si no pues ignora esa nota 
					
					if(kardexEval.existeReg(conElias)){
						if(kardexEval.deleteReg(conElias)){
							//Elimino correctamente
						}else{
							error = true; break;
						}	
					}
					
				}else{//Si tiene nota entonces guardarla
					
					if (kardexEval.existeReg(conElias)) {
						kardexEval.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, evaluacion);
						kardexEval.setNota(nota);
						if(kardexEval.updateReg(conElias)){
							//Actualizado correctamente
						}else{
							error = true; break;
						}
					} else {
						kardexEval.setNota(nota);
						if(kardexEval.insertReg(conElias)){
							//Insertado correctamente
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
//------------- BORRA CALIFICACIONES DE UNA EVALUACION ------------->
	else if (accion.equals("2")) {
		if (aca.kardex.KrdxAlumEval.deleteNotasEval(conElias, cicloGrupoId, cursoId, request.getParameter("Evaluacion"))) {
			msj = "Eliminado";
		} else {
			msj = "ErrorBorrar";
		}
	}
//------------- CERRAR EVALUACION ------------->
	else if(accion.equals("3")){
				
		String evaluacion = request.getParameter("Evaluacion");
		
		conElias.setAutoCommit(false);//** END TRANSACTION **
		boolean error = false;
	
		//**************** CERRAR EVALUACION ****************
		
		cicloGrupoEval.mapeaRegId(conElias, cicloGrupoId, cursoId, evaluacion);
		cicloGrupoEval.setEstado("C");

		if (cicloGrupoEval.updateReg(conElias)) {
			lisEvaluacion = cicloGrupoEvalLista.getArrayList( conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
		}else{
			error = true;
		}
				
		//**************** END CERRAR EVALUACION ****************
		
		
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
//------------- ABRIR EVALUACION ------------->	
	else if(accion.equals("4")){	
		cicloGrupoEval.mapeaRegId(conElias, cicloGrupoId, cursoId, request.getParameter("Evaluacion"));
		cicloGrupoEval.setEstado("A");
		cicloGrupoEval.updateReg(conElias);
		if(!cicloGrupoCurso.getEstado().equals("2")){
			cicloGrupoCurso.setEstado("2");
			if(cicloGrupoCurso.updateReg(conElias)){
				msj = "Guardado";
			}else{
				msj = "NoGuardo";
			}
		}
		
		// Lista de evaluaciones de la materia
		lisEvaluacion = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	}

//------------- PROMEDIAR CONDUCTA DE TODAS LAS MATERIAS ------------->
	else if (accion.equals("6")) {
		
		String evaluacion = request.getParameter("Evaluacion");
		
		if (aca.kardex.KrdxAlumConducta.tieneEvaluacionesDeConducta(conElias, cicloGrupoId, evaluacion)) {
			if (aca.ciclo.CicloGrupoEval.conductaBimestralCerrada(conElias, cicloGrupoId, evaluacion)) { //La evaluacion de todas las materias estan cerradas...
				
				ArrayList<aca.kardex.KrdxAlumConducta> lisConducta = kardexConductaLista.getListAll(conElias,"WHERE CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND EVALUACION_ID = " + evaluacion + " AND CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CONDUCTA = 'S') ORDER BY CODIGO_ID");
				
				if (lisConducta.size() > 0) {
					int error = 0;
					for (aca.kardex.KrdxCursoAct alumno : lisKardexAlumnos) { //Alumnos de este grupo
						int sumaNotas = 0;
						int cantidadMaterias = 0;
						for (aca.kardex.KrdxAlumConducta krdxConducta : lisConducta) { //Notas de todos los alumnos de este grupo de todas las materias
							if (krdxConducta.getCodigoId().equals(alumno.getCodigoId()) && Float.parseFloat(krdxConducta.getConducta()) > 0) {
								sumaNotas += Float.parseFloat(krdxConducta.getConducta());
								cantidadMaterias++;
							}
						}
						
						kardexEval.mapeaRegId(conElias, alumno.getCodigoId(), cicloGrupoId, cursoId, evaluacion);
						
						kardexEval.setCodigoId(alumno.getCodigoId());
						kardexEval.setCicloGrupoId(cicloGrupoId);
						kardexEval.setCursoId(cursoId);
						kardexEval.setEvaluacionId(evaluacion);
						
						if (cantidadMaterias == 0 || sumaNotas < 1){
							kardexEval.setNota("0");
						}else{
							kardexEval.setNota(String.valueOf(frmDecimal.format(sumaNotas / ((float) cantidadMaterias))));
						}
						
						if (kardexEval.existeReg(conElias)) {
							if (!kardexEval.updateReg(conElias)){
								error++;
							}
						} else {
							if (!kardexEval.insertReg(conElias)){
								error++;	
							}
						}
					}
					if (error == 0){
						msj = "Guardado";	
					}else{
						msj = "ErrorAlPromediar";
					}
				} else {
					msj = "MaestroNoHaEvaluado";
				}

				lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
				
			}else{			
				msj = "NoSePuedePromediarConducta";
			}
		} else {
			msj = "MaestroNoHaEvaluado";
		}
	}
//------------- PROMEDIAR CONDUCTA DE TODAS LAS MATERIAS ------------->
	else if (accion.equals("7")) {
		
		conElias.setAutoCommit(false);//** END TRANSACTION **
		boolean error = false;
		
		int i = 0;
		for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
			
			String nota = request.getParameter("promedio" + i );
			
			/* Guardar promedio del alumno en krdx_curso_act */
			kardex.setNota(nota);
			kardex.setFNota(aca.util.Fecha.getHoy());
			
			kardex.setTipoCalId("2");
			
			if(kardex.updateReg(conElias)){
				//Actualizo correctamente
			}else{
				error = true; break;
			}
			
			i++;
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

//------------- PROMEDIAR CONDUCTA DE TODAS LAS MATERIAS ------------->
	else if (accion.equals("8")) {

		conElias.setAutoCommit(false);//** END TRANSACTION **
		boolean error = false;
		
		//------------------- CERRAR MATERIA ------------------->
		if (aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId)) {
				
			for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
				
				kardex.setTipoCalId("2");
				if(kardex.updateReg(conElias)){
					//Actualizo correctamente
				}else{
					error = true; break;
				}
			}
			
			cicloGrupoCurso.setEstado("4"); //MATERIA CERRADA
			
			if(cicloGrupoCurso.updateReg(conElias)){
				//Se actualizo el estado correctamente
			}else{
				error = true;
			}
		}//End cerraron todas las evaluaciones
		
		
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
	
/* ********************************** END ACCIONES ********************************** */

	
	
	

	// TREEMAP DE LAS NOTAS DE LAS EVALUACIONES DE LOS ALUMNOS
	java.util.TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexEvalLista.getTreeMateria(conElias,	cicloGrupoId, cursoId, "");
		
	//TREEMAP DE LOS PROMEDIOS DE LOS ALUMNOS EN LA MATERIA (de la vista de alum_prom)
	java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
	
%>

<!--  ********************************************** HTML MARKUP **********************************************  -->

<div id="content">
	<h2>
		<fmt:message key="aca.Evaluaciones" /> 
		
		<%if (cicloGrupoCurso.getEstado().equals("1")){%>
			<span class='label label-info'><fmt:message key="aca.MateriaCreada" /></span>
		<%}else if (cicloGrupoCurso.getEstado().equals("2")){%>
			<span class='label label-success'><fmt:message key="aca.MateriaEnEvaluacion" /></span>
		<%}else if (cicloGrupoCurso.getEstado().equals("3")){%>
			<span class='label label-important'><fmt:message key="aca.MateriaEnExtraordinario" /></span>
			<a style="margin:0;display:inline-block;vertical-align:baseline;" class="btn btn-primary btn-mini" type="button" href="javascript:cerrarExtra();">Cerrar extra</a>
		<%}else if (cicloGrupoCurso.getEstado().equals("4")){%>
			<span class='label label-inverse'><fmt:message key="aca.MateriaCerrada" /></span>
		<%}%>
		
		<small><%=empPersonal.getNombre() + " " + empPersonal.getApaterno()+ " " + empPersonal.getAmaterno()%></small>
	</h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="alert alert-info">
		<h4><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%></h4>
		<small><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></small> 
	</div>
	
	<div class="well">
		<a href="cursos.jsp" class="btn btn-primary btn-mobile">
			<i class="icon-th-list icon-white"></i> <fmt:message key="aca.Cursos" />
		</a>
		
		<a class="btn btn-mobile" target="_blank" href="tarjeta.jsp?Curso=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&CodigoId=<%=codigoId%>">
			<i class="icon-book"></i> <fmt:message key="aca.TarjetasDeAlumnos" />
		</a>
		
		<a class="btn btn-mobile" target="_blank" href="actamateria.jsp?Curso=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
			<i class="icon-print"></i> <fmt:message key="aca.ImprimirActa" />
		</a>
		
		<a class="btn btn-mobile" target="_blank" href="formatoAsistencia.jsp?CicloGrupoId=<%=cicloGrupoId%>&CursoId=<%=cursoId%>">
			<i class="icon-list-alt"></i> <fmt:message key="aca.FormatoAsistencia" />
		</a>
	</div>
	
<!--  -------------------- TABLA DE EVALUACIONES -------------------- -->
	
	<table class="table table-condensed table-bordered table-striped">
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th><fmt:message key="aca.Descripcion" /></th>
					<th class="text-center"><fmt:message key="aca.Fecha" /></th>
					<th class="text-center"><fmt:message key="aca.Valor" /></th>
					<th class="text-center"><fmt:message key="aca.Estado" /></th>
					<th style="width:1%;"></th>
				</tr>
			</thead>
			<%
				int cont = 0;
				for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
					cont++;
			%>
					<tr>
						<td class="text-center"><%=cont%></td>
						<td>
	 						<%if (cicloGrupoCurso.getEstado().equals("2") && eval.getEstado().equals("A")) {%> 
								<a href="javascript:muestraInput('<%=eval.getEvaluacionId()%>');">
									<%=eval.getEvaluacionNombre()%>
								</a>
							<%}else{%>
	 							<%=eval.getEvaluacionNombre() %>
	 						<%}%>
	 						
	 						<%if (aca.ciclo.CicloGrupoActividad.tieneActividades(conElias, eval.getCicloGrupoId(), eval.getCursoId(), eval.getEvaluacionId())) {%>
								<a style="float:right;" class="btn btn-mini btn-info" href="evaluarActividadCompetencias.jsp?estado=<%=eval.getEstado()%>&CicloGrupoId=<%=eval.getCicloGrupoId()%>&CursoId=<%=eval.getCursoId()%>&EvaluacionId=<%=eval.getEvaluacionId()%>">
									<fmt:message key="aca.Actividades" />
								</a> 
							<%}%> 
						</td>
						<td class="text-center"><%=eval.getFecha()%></td>
						<td class="text-center"><%=eval.getValor()%>%</td>
						<td class="text-center">
							<%if (eval.getEstado().equals("A")) {%>
								<span class="label label-success"><fmt:message key="aca.Abierto" /></span>								
							<%}else if (eval.getEstado().equals("C")) {%> 					
								<span class="label label-inverse"><fmt:message key="aca.Cerrado" /></span>
							<%}%>
						</td>
						<td>
							<%if (eval.getEstado().equals("A")) {
								String notasConCero = "SI";
								if (aca.ciclo.CicloGrupoEval.tieneNotasConCero(conElias, cicloGrupoId, cursoId, eval.getEvaluacionId()).equals(lisKardexAlumnos.size()+"")) {
									notasConCero = "NO";
								}
							%>
								<a title="<fmt:message key="boton.CerrarEvaluacion" />" class="btn btn-success btn-mini"  href="javascript:cerrarEvaluacion('<%=eval.getEvaluacionId()%>');">
									<i class="icon-ok icon-white"></i>
								</a> 
							<%} %>
							
							<%if (eval.getEstado().equals("C") && permitirCambiarElEstado) {%>
								<a title="<fmt:message key="boton.AbrirEvaluacion" />" class="btn btn-success btn-mini"  href="javascript:abrirEvaluacion('<%=eval.getEvaluacionId()%>');">
									<i class="icon-pencil icon-white"></i>
								</a>  
							<%}else if(eval.getEstado().equals("C")){%>
								<a title="<fmt:message key="boton.EvaluacionCerrada" />" class="btn btn-inverse btn-mini disabled" >
									<i class="icon-ok icon-white"></i>
								</a>
							<%} %> 	
						</td>
					</tr>
			<%}%>
			
			<%if (aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId) && cicloGrupoCurso.getEstado().equals("4") == false) { %>
				<tr>
					<td colspan="6" class="text-right">
						<a href="javascript:cerrarMateria();" class="btn btn-success"><fmt:message key="aca.CerrarMateria" /></a>
					</td>
				</tr>
			<%} %>
	</table>
	
<!--  -------------------- SECCION DE CONDUCTA Y FALTAS -------------------- -->
	<%
		planCurso.mapeaRegId(conElias, cursoId);
	%>
	<div class="well text-center" style="overflow:visible;">
	<%
		if (planCurso.getFalta().equals("S")) {
	%>
			<a class="btn btn-mobile" href="evaluarFaltas.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
				<fmt:message key="maestros.RegistrodeFaltas" />
			</a> 
	<%
		}
	  	if (planCurso.getConducta().equals("S")){
	%> 
			<a class="btn btn-mobile" href="evaluarConducta.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
				<fmt:message key="boton.EvaluarConducta" />
			</a> 
	<%
		}
	
		if (planCurso.getConducta().equals("P")) {
	%>
			<div class="btn-group text-left btn-mobile">
            	<button style="width:100%;" class="btn dropdown-toggle" data-toggle="dropdown"><fmt:message key="aca.PromediarConducta" /> <span class="caret"></span></button>
                <ul class="dropdown-menu">
					<%cont = 0;
					  for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
						cont++;
						if (cicloGrupoCurso.getEstado().equals("2") && eval.getEstado().equals("A")) {%>
							<li><a href="javascript:promediarConducta('<%=eval.getEvaluacionId()%>')"><%=eval.getEvaluacionNombre() %></a></li>
						<%} else {%> 
							<li class="disabled"><a href=""><%=eval.getEvaluacionNombre() %></a></li>
						<%}%>
					<%}%>
		   		</ul>
           	</div>
		  	
		  	<div class="btn-group text-left btn-mobile">
            	<button style="width:100%;" class="btn dropdown-toggle" data-toggle="dropdown"><fmt:message key="aca.ReporteConducta" /> <span class="caret"></span></button>
                <ul class="dropdown-menu">
                  	<%
			  			for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
			  		%> 
							<li><a href="conducta.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&EvaluacionId=<%=eval.getEvaluacionId()%>"><%=eval.getEvaluacionNombre() %></a></li>
					<%
						}
					%>
                </ul>
           	</div>
	<%
		}
	%>
	</div>
	
<!--  -------------------- TABLA DE ALUMNOS -------------------- -->
	
	<form action="evaluarCompetencias.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" name="forma" method="post">
	
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Evaluacion" />

		<table class="table table-condensed table-bordered table-striped">
			
			<thead>			
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.NombreDelAlumno" /></th>
					
					<!-- --------- RECORRE LAS EVALUACIONES --------- -->
					<%
						cont = 0;
						for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
							cont++;
					%>
							<th style="width:4%;" class="text-center" title="<%=eval.getEvaluacionNombre()%>"><%=cont%></th>
					<%
						}
					%>
					<th style="width:4%;" class="text-center">
						<%if (cicloGrupoCurso.getEstado().equals("2")) {%> 
							<a href="javascript:muestraInputPromedio();">
						<%} %>
							<fmt:message key="aca.Promedio" />
						</a>
					</th>
				</tr>
			</thead>
			
			
			
			
			<%
				// Recorre la lista de Alumnos en la materia
				int i = 0;
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
			%>
					<tr>
						<td class="text-center"><%=i+1%></td>
						<td class="text-center"><%=kardex.getCodigoId()%></td>
						<td>
							
							<!-- --------- ALUMNO Y MENSAJES --------- -->
						<%
							/*
							 *	¿Tiene Mensajes?
							 */
							int cantidadMensajes = Integer.parseInt(aca.alumno.AlumMensaje.mensajesNoLeidosPorAlumno(conElias, cicloGrupoId, cursoId, kardex.getCodigoId()));
							if(cantidadMensajes>0){
						%>
								<span class="badge badge-important"><%=cantidadMensajes %></span>
						<%
							}
						%>
					  		<a href="mensaje.jsp?CicloGrupoId=<%=cicloGrupoId%>&CursoId=<%=cursoId%>&CodigoEmpleado=<%=codigoId%>&CodigoId=<%=kardex.getCodigoId()%>">
					  			<%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>
					  		</a>
					  							  		
					  		<%if(kardex.getTipoCalId().equals("6")){ %>
					  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
					  		<%} %>
						</td>
						
						
							<!-- --------- RECORRE LAS EVALUACIONES --------- -->
						<%
							for (aca.ciclo.CicloGrupoEval eval: lisEvaluacion) {
								String strNota = "-";
	
								if (treeNota.containsKey(cicloGrupoId + cursoId + eval.getEvaluacionId() + kardex.getCodigoId())) {
									kardexEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + cursoId + eval.getEvaluacionId() + kardex.getCodigoId());
								
									if (kardexEval.getCodigoId().equals( kardex.getCodigoId()) && eval.getEvaluacionId().equals( kardexEval.getEvaluacionId()) && !kardexEval.getNota().equals("0")) {
	
										strNota = frmEntero.format(Double.parseDouble(kardexEval.getNota())).replaceAll(",", ".");
									}
								}
						%>
								<td class="text-center">
									
									<div>
										<%=aca.catalogo.CatEsquema.getCaracter(strNota) %>
									</div>
									
									<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) -->
									<%if (!kardex.getTipoCalId().equals("6") && eval.getEstado().equals("A") ) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
										<div class="editar<%=eval.getEvaluacionId() %>" style="display:none;">
											<select tabindex="<%=i+1%>" name="nota<%=i%>-<%=eval.getEvaluacionId()%>" id="nota<%=i%>-<%=eval.getEvaluacionId()%>" class="input-mini" style="margin:0;">
												<option value="10" <%if(strNota.equals("10")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("10") %></option>
												<option value="5" <%if(strNota.equals("5")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("5") %></option>
												<option value="0" <%if(strNota.equals("0")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("0") %></option>
											</select>
										</div>
									<%}%>
									
								</td>
						<%
							}//End for evaluaciones
						%>
							
							<!-- --------- PROMEDIO --------- -->
						<%						
							String strPromedio = frmEntero.format(Double.parseDouble(kardex.getNota()));
						%>
							
							<td class="text-center">
							
								<div>									
									<%=aca.catalogo.CatEsquema.getCaracter(strPromedio) %>
								</div>
								
								<!-- INPUT PARA EDITAR EL PROMEDIO (ESCONDIDO POR DEFAULT) -->
								<%if (cicloGrupoCurso.getEstado().equals("2")) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
									<div class="editarPromedio" style="display:none;">
										<select tabindex="<%=i+1%>" name="promedio<%=i%>" id="promedio<%=i%>" class="input-mini" style="margin:0;">
											<option value="10" <%if(strPromedio.equals("10")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("10") %></option>
											<option value="5" <%if(strPromedio.equals("5")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("5") %></option>
											<option value="0" <%if(strPromedio.equals("0")){out.print("selected");} %>><%=aca.catalogo.CatEsquema.getCaracter("0") %></option>
										</select>
									</div>
								<%}%>
							</td>
				</tr>
				<%
						i++;
					} // end for lista de alumnos
				%>
				
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<!-- BOTONES PARA EDITAR LAS NOTAS (ESCONDIDOS POR DEFAULT) -->
					<%
					for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
					%>
						<td class="text-center">
							<div class="editar<%=eval.getEvaluacionId() %>" style="display:none;">
								<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarCalificaciones( '<%=eval.getEvaluacionId()%>' );"><fmt:message key="boton.Guardar" /></a> 
								<a tabindex="<%=lisKardexAlumnos.size()+1 %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarCalificaciones( '<%=eval.getEvaluacionId()%>' );"><fmt:message key="boton.Eliminar" /></a>
							</div>
						</td>
					<%
					}
					%>
					<td>
						<!-- BOTONES PARA EDITAR EL PROMEDIO (ESCONDIDOS POR DEFAULT) -->
						<div class="editarPromedio" style="display:none;">
							<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarPromedio();"><fmt:message key="boton.Guardar" /></a> 
						</div>
					</td>
				</tr>
		</table>
	</form>


</div>




<%@ include file="../../cierra_elias.jsp"%>