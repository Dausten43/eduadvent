<%@page import="aca.kardex.KrdxAlumExtra"%>
<%@page import="aca.kardex.KrdxAlumActiv"%>
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
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>

<jsp:useBean id="CicloExtraL" scope="page" class="aca.ciclo.CicloExtraLista"/>
<jsp:useBean id="kardexAlumnoExtra" scope="page" class="aca.kardex.KrdxAlumExtra" />
<jsp:useBean id="cicloExtra" scope="page" class="aca.ciclo.CicloExtra" />

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
	 * CERRAR EVALUACION
	 */
	function cerrarEvaluacion(evaluacion, notasConCero){
		if(confirm("<fmt:message key="js.CerrarEvaluacion"/>")==true){
	  		if(notasConCero == 'NO' || confirm("<fmt:message key="js.FaltanNotasPorIngresar"/>")){
	  			document.forma.Evaluacion.value = evaluacion;
				document.forma.Accion.value = "3";
				document.forma.submit();	
	  		}	
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
	 * ABRIR INPUTS PARA EDITAR LOS EXTRAORDINARIOS 3
	 */
	function muestraInputExtra3(evaluacionId){
		var editar = $('.editarExtra3');//Busca los inputs
		
		editar.each(function(){
			var $this = $(this);
			
			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON EN LOS EXTRAORDINARIOS
	 */
	function guardarExtra( ){
		document.forma.Accion.value = "5";
		document.forma.submit();
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON EN LOS EXTRAORDINARIOS 2
	 */
	function guardarExtra2(){
		document.forma.Accion.value = "8";
		document.forma.submit();
	}
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON EN LOS EXTRAORDINARIOS 3
	 */
	function guardarExtra3( ){
		document.forma.Accion.value = "9";
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
	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0");
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00");

	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0");
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	
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
	
	//CONDICIONES DE LAS NOTAS ---------------------------->
	String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
	float notaAC 				= Float.parseFloat(aca.plan.PlanCurso.getNotaAC(conElias, cursoId)); /* La nota con la que se acredita el cursoId */	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	float notaMinima			= Float.parseFloat(aca.catalogo.CatNivelEscuela.getNotaMinima(conElias, nivelId, escuelaId )); /* La nota minima que puede sacar un alumno, depende del nivel de la escuela */
	if (escala == 100){ //Si la escala es 100, entonces la nota minima debe multiplicarse por 10, por ejemplo en vez de 5 que sea 50
		notaMinima = notaMinima * 10;	
	}
	
	// Escala para la columna de puntos
	int escalaEval 			= escala;
	
	//INFORMACION DEL MAESTRO
	empPersonal.mapeaRegId(conElias, codigoId);
	
	//LISTA DE EVALUACIONES EN LA MATERIA
	ArrayList<aca.ciclo.CicloGrupoEval> lisEvaluacion 	= cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	
	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
		
	// Lista de evaluaciones o bloques en el ciclo
	ArrayList<aca.ciclo.CicloBloque> lisBloque 			= CicloBloqueL.getListCiclo(conElias, cicloId, " ORDER BY BLOQUE_ID");
	
	// Map de evaluaciones del alumno en Ciclo_Grupo_Eval
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalCurso(conElias, cicloGrupoId, cursoId);
	
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);	
	
	//SI LA MATERIA TIENE ESTADO DE 'MATERIA CREADA' ENTONCES CAMBIALO A 'MATERIA EN EVALUACION'
	if ( estadoMateria.equals("1") ) {
		cicloGrupoCurso.setEstado("2");
		cicloGrupoCurso.updateReg(conElias);
	}
	
	//LISTA DE ALUMNOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");	
	ArrayList<aca.kardex.KrdxAlumExtra> lisKardexAlumnosExtra	= kardexAlumnoExtra.getAlumnoExtra(conElias, codigoId, cicloGrupoId, cursoId);
	
	//LISTA EXTRAS
	ArrayList<aca.ciclo.CicloExtra> lisTodosLosExtras					= cicloExtra.getTodosLosCiclosExtras(conElias, cicloId);
	
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
					//--------VERIFICAR LA NOTAMINIMA PARA EL NIVEL----------
					if (Float.parseFloat(nota) < notaMinima) {
						nota = notaMinima + "";
					}
					//------FIN VERIFICAR LA NOTAMINIMA PARA EL NIVEL--------
					
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
		
		mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);
	}
//------------- BORRA CALIFICACIONES DE UNA EVALUACION ------------->
	else if (accion.equals("2")) {
		if (aca.kardex.KrdxAlumEval.deleteNotasEval(conElias, cicloGrupoId, cursoId, request.getParameter("Evaluacion"))) {
			conElias.commit();
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
	
		//**************** RECALCULAR EL PROMEDIO DE LAS ACTIVIDADES DE LA EVALUACION QUE SE VA A CERRAR (SI ES QUE TIENE) ****************
	
		if(aca.ciclo.CicloGrupoActividad.tieneActividades(conElias, cicloGrupoId, cursoId, evaluacion)){
			/* Actividades del alumno */
			ArrayList<aca.kardex.KrdxAlumActiv> lisKrdxActiv		= krdxAlumActivL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacion, "ORDER BY ALUM_APELLIDO(CODIGO_ID), ACTIVIDAD_ID");
			/* Actividades definidas en el metodo de evaluacion */
			ArrayList<aca.ciclo.CicloGrupoActividad> lisActividad	= cicloGrupoActividadL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacion, "ORDER BY ACTIVIDAD_ID, ACTIVIDAD_NOMBRE");
						
			//RECORRE A LOS ALUMNOS
			for(aca.kardex.KrdxCursoAct krdxCursoAct: lisKardexAlumnos){ 
				
				BigDecimal valorActividadesTotal = new BigDecimal("0");
				for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
					for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
						if(krdxAlumActiv.getCodigoId().equals(krdxCursoAct.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){
							//valorActividadesTotal += Double.parseDouble( cicloGrupoActividad.getValor() );
							valorActividadesTotal = valorActividadesTotal.add( new BigDecimal(cicloGrupoActividad.getValor()) );
						}
					}
				}
				
				//float promedioActividades = 0f;
				BigDecimal promedioActividades = new BigDecimal("0");
				for(aca.ciclo.CicloGrupoActividad cicloGrupoActividad : lisActividad){
					for(aca.kardex.KrdxAlumActiv krdxAlumActiv : lisKrdxActiv){
						if(krdxAlumActiv.getCodigoId().equals(krdxCursoAct.getCodigoId()) && krdxAlumActiv.getActividadId().equals(cicloGrupoActividad.getActividadId())){								
							//promedioActividades += (Float.parseFloat(krdxAlumActiv.getNota())*Float.parseFloat(cicloGrupoActividad.getValor()))/valorActividadesTotal;
							promedioActividades = promedioActividades.add( new BigDecimal(krdxAlumActiv.getNota()).multiply(new BigDecimal(cicloGrupoActividad.getValor())).divide(valorActividadesTotal, 1, RoundingMode.DOWN) );
						}
					}
				}
				
				/* Quitar decimales, por ejemplo (88.6 a 88) (80.1 a 80) */
				promedioActividades = new BigDecimal( frmEntero.format(promedioActividades) ); 
				
				//--------COMPROBAR SI LA ESCALA ES 10----------
				
				if( escala == 10 ){
					/* Convirtiendo la escala de 100 a 10 (ya que las actividades se evaluan de 0 a 100) */
					promedioActividades = promedioActividades.divide(new BigDecimal("10"), 1, RoundingMode.DOWN);
				}
				
				//--------COMPROBAR SI TIENEN PUNTO DECIMAL----------
				
				if(evaluaConPunto.equals("N")){
					/* Si tiene una nota reprobatoria entonces el redondeo es hacia abajo, por ejemplo: (5.9 a 5) (5.6 a 5) (4.9 a 4)  */
					if( promedioActividades.compareTo( new BigDecimal(notaAC) ) == -1 ){// promedioActividades<notaAC
						promedioActividades = new BigDecimal( frmEntero.format( promedioActividades.setScale(0, RoundingMode.DOWN) ) );
					}
					/* Si tiene una nota aprobatoria entonces el redondeo es normal, por ejemplo: (6.4 a 6) (6.6 a 7)  */
					else{
						promedioActividades = new BigDecimal( frmEntero.format( promedioActividades.setScale(0, RoundingMode.HALF_UP) ) );
					}
				}	
						
				//--------VERIFICAR LA NOTAMINIMA PARA EL NIVEL----------
				
				if( promedioActividades.compareTo( new BigDecimal(notaMinima) ) == -1 ){// promedioActividades<notaMinima
					promedioActividades = new BigDecimal(notaMinima);
				}
				
				//--------GUARDAR PROMEDIO DE LAS ACTIVIDADES EN LA EVALUACION----------
				
				kardexEval.setCodigoId(krdxCursoAct.getCodigoId());
				kardexEval.setCicloGrupoId(cicloGrupoId);
				kardexEval.setCursoId(cursoId);
				kardexEval.setEvaluacionId(evaluacion);
			
				if(kardexEval.existeReg(conElias)){
					kardexEval.mapeaRegId(conElias, krdxCursoAct.getCodigoId(), cicloGrupoId, cursoId, evaluacion);
					kardexEval.setNota(promedioActividades +"");
					if(kardexEval.updateReg(conElias)){
						//Actualizo correctamente
					}else{
						error = true; break;
					}
				}else{
					kardexEval.setNota( promedioActividades +"");
					if(kardexEval.insertReg(conElias)){
						//Inserto correctamente
					}else{
						error = true; break;
					}
				}
					
					
			}//End for alumnos
				
		}else{
			//NO TIENE ACTIVIDADES
		}
				
		//**************** END RECALCULAR EL PROMEDIO DE LAS ACTIVIDADES DE LA EVALUACION QUE SE VA A CERRAR (SI ES QUE TIENE) ****************		
		
		//**************** CERRAR EVALUACION ****************
		if(error == false){
		
			cicloGrupoEval.mapeaRegId(conElias, cicloGrupoId, cursoId, evaluacion);
			cicloGrupoEval.setEstado("C");
	
			if (cicloGrupoEval.updateReg(conElias)) {
				lisEvaluacion = cicloGrupoEvalLista.getArrayList( conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
			} else {
				error = true;
			}
			
			//------------------- SI YA SE CERRARON TODAS LAS EVALUACIONES, ENTONCES CIERRA LA MATERIA (guarda las calificaciones del alumno y cambia el estado de la materia) ------------------->
			if (aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId)) {
				java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
				
				boolean todosPasan = true;				
	
				int i = 0;
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
					double promedio = 0.0;
					
					if (treeProm.containsKey(cicloGrupoId + cursoId	+ kardex.getCodigoId())) {
						aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId + cursoId + kardex.getCodigoId());
						promedio = Double.parseDouble(alumProm.getPromedio().replaceAll(",",".")); 
					}
					
					/* Guardar promedio del alumno en krdx_curso_act */
					kardex.setNota(frmDecimal.format(promedio));
					kardex.setFNota(aca.util.Fecha.getHoy());
					
					//ACREDITO EL ORDINARIO
					if (promedio >= notaAC) {
						kardex.setTipoCalId("2");
						todosPasan &= true;
					}
					//NO ACREDITO EL ORDINARIO
					else{
						kardex.setTipoCalId("3");
						todosPasan &= false;
					}
					
					if(kardex.updateReg(conElias)){
						//Actualizo correctamente
					}else{
						error = true; break;
					}
					
					i++;
				}
				
				if (todosPasan){
					cicloGrupoCurso.setEstado("4"); //MATERIA CERRADA
				}else{
					cicloGrupoCurso.setEstado("3");	//MATERIA EN EXTRAORDINARIO, YA QUE NO TODOS PASARON
				}
				
				if(cicloGrupoCurso.updateReg(conElias)){
					//Se actualizo el estado correctamente
				}else{
					error = true;
				}
			}//End cerraron todas las evaluaciones
		
		}//End error
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
		// Actualizar el map de evaluaciones
		mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalCurso(conElias, cicloGrupoId, cursoId);
	}
//------------- GUARDA LOS EXTRAORDINARIOS ------------->	
	else if (accion.equals("5")) { //Guardar Extraordinarios
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;		
		int cont = 0;
		
		for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
		
 		// TREEMAP DE LAS NOTAS DE LAS EVALUACIONES DE LOS ALUMNOS
 		java.util.TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexEvalLista.getTreeMateria(conElias,	cicloGrupoId, cursoId, "");
		
 		int evalCerradas = 0;
 		double promEval = 0;
		
 		for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
			
  			for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
			
 				if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){			
 					String strNota = "-";
 					// Nota del alumno en la evaluacion
 					double notaEval = 0;
 					if (treeNota.containsKey(cicloGrupoId + cursoId + cicloBloque.getBloqueId() + kardex.getCodigoId())) {
 						notaEval = Double.parseDouble(treeNota.get(cicloGrupoId+cursoId+cicloBloque.getBloqueId()+kardex.getCodigoId()).getNota());
						
 						// Formato de la evaluacion
 						strNota = formato0.format(notaEval);
 						if (cicloBloque.getDecimales().equals("1")) 
 							strNota = formato1.format(notaEval);
 					}									
 					// Verifica si la nota de la evaluacion es temporal o definitiva(abierta o cerrada)
 					String estadoEval = "A";									
					if (mapEvalCiclo.containsKey(cicloGrupoId+kardex.getCursoId()+cicloBloque.getBloqueId())){
 						estadoEval 	= mapEvalCiclo.get(cicloGrupoId+kardex.getCursoId()+cicloBloque.getBloqueId()).getEstado();										
 					}
 					// Color de la evaluacion
 					String colorEval = "color:blue;";
 					if (estadoEval.equals("C")){
 						evalCerradas++;
 						colorEval = "color:black;";
 					}
 		 
  				}
				
  			} // End for evaluaciones
			
 			// Obtiene el promedio del alumno en las evaluaciones (tabla Krdx_Alum_Prom) 
 			if (mapPromAlumno.containsKey(kardex.getCodigoId()+kardex.getCursoId()+cicloPromedio.getPromedioId())){
 				promEval = Double.parseDouble(mapPromAlumno.get(kardex.getCodigoId()+kardex.getCursoId()+cicloPromedio.getPromedioId()).getNota());									
 			}
			
 			// Puntos del promedio
 			double puntosEval = (promEval * Double.parseDouble(cicloPromedio.getValor())) / escalaEval;
			
 			// Formato del promedio y los puntos (decimales usados)
 			String promFormato		= formato1.format(promEval);
 			String puntosFormato	= formato1.format(puntosEval);
 			if (cicloPromedio.getDecimales().equals("0")){
 				promFormato 		= formato0.format(promEval);
 				puntosFormato 		= formato0.format(puntosEval);
 			}else if (cicloPromedio.getDecimales().equals("2")){
 				promFormato 		= formato2.format(promEval);
 				puntosFormato 		= formato2.format(puntosEval);
 			}	
			
 		}//End for de promedio	
			
			String notaExtra = request.getParameter("notaExtra"+cont)==null?"0":request.getParameter("notaExtra"+cont);
			
			if (!notaExtra.equals("")) {
					
				String promedio = "";
				String fecha = aca.util.Fecha.getHoy();
				
				//*******COMPROBAMOS QUE EXISTA EL CICLO EXTRA*********//
				cicloExtra.setCicloId(cicloId);
				cicloExtra.setOportunidad("1");
				
				if(cicloExtra.existeReg(conElias)){
					
					double valorPromedio = Double.parseDouble(cicloExtra.getCicloExtra(conElias, cicloId, "1").get(0).getValorAnterior());
					double valorExtra    = Double.parseDouble(cicloExtra.getCicloExtra(conElias, cicloId, "1").get(0).getValorExtra());
				
					//promedio = Double.toString( ((Double.parseDouble(notaExtra)* valorExtra)/100)+((Double.parseDouble(kardex.getNota())* valorPromedio)/100)   );
					promedio = Double.toString( ((Double.parseDouble(notaExtra)* valorExtra)/100)+((promEval* valorPromedio)/100)   );
				
				}
				
				kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
				kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
				kardexAlumnoExtra.setCursoId(cursoId);
				kardexAlumnoExtra.setOportunidad("1");
				kardexAlumnoExtra.setFecha(fecha);
				kardexAlumnoExtra.setNotaAnterior(Double.toString(promEval));
				kardexAlumnoExtra.setNotaExtra(notaExtra);	
				kardexAlumnoExtra.setPromedio(promedio);
				
				if(kardexAlumnoExtra.existeReg(conElias )){
					if(kardexAlumnoExtra.updateReg(conElias)){
						//Actualizado correctamente
					}else{
						//error = true; break;
					}
					
				}else {
					kardexAlumnoExtra.insertReg(conElias);
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
		
		/* Refrescar lista */
		lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
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
						//int sumaNotas = 0;
						//int cantidadMaterias = 0;
						BigDecimal sumaNotas = new BigDecimal("0");
						BigDecimal cantidadMaterias = new BigDecimal("0");
						for (aca.kardex.KrdxAlumConducta krdxConducta : lisConducta) { //Notas de todos los alumnos de este grupo de todas las materias
							if (krdxConducta.getCodigoId().equals(alumno.getCodigoId()) && Float.parseFloat(krdxConducta.getConducta()) > 0) {
								//sumaNotas += Float.parseFloat(krdxConducta.getConducta());
								//cantidadMaterias++;
								sumaNotas = sumaNotas.add( new BigDecimal(krdxConducta.getConducta()) );
								cantidadMaterias = cantidadMaterias.add(new BigDecimal("1"));
							}
						}
						
						kardexEval.mapeaRegId(conElias, alumno.getCodigoId(), cicloGrupoId, cursoId, evaluacion);
						
						kardexEval.setCodigoId(alumno.getCodigoId());
						kardexEval.setCicloGrupoId(cicloGrupoId);
						kardexEval.setCursoId(cursoId);
						kardexEval.setEvaluacionId(evaluacion);
						
						//if (cantidadMaterias == 0 || sumaNotas < 1){
						if( cantidadMaterias.compareTo(BigDecimal.ZERO) == 0 || sumaNotas.compareTo(new BigDecimal("1")) == -1 ){
							kardexEval.setNota("0");
						}else{
							kardexEval.setNota( sumaNotas.divide(cantidadMaterias, 1, RoundingMode.DOWN)+"" );
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
						conElias.commit();
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
  
//------------- CERRAR EXTRAORDINARIO ------------->
	else if (accion.equals("7")) {
		cicloGrupoCurso.setEstado("4"); //MATERIA CERRADA
		
		if(cicloGrupoCurso.updateReg(conElias)){
			msj = "Guardado";
		}else{
			msj = "NoGuardo";
		}
	}
//------------- GUARDA LOS EXTRAORDINARIOS 2 ------------->	
	else if (accion.equals("8")) { //Guardar Extraordinarios
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		boolean error = false;		
		int cont = 0;
		
		for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
		
			String notaExtra = request.getParameter("notaExtra2"+cont)==null?"0":request.getParameter("notaExtra2"+cont);
			
			if (!notaExtra.equals("")) {
					
				String promedio = "";
				String fecha = aca.util.Fecha.getHoy();
				
				//*******COMPROBAMOS QUE EXISTA EL CICLO EXTRA 2 *********//
				cicloExtra.setCicloId(cicloId);
				cicloExtra.setOportunidad("2");
				
				if(cicloExtra.existeReg(conElias)){
					
					double valorPromedio = Double.parseDouble(cicloExtra.getCicloExtra(conElias, cicloId, "2").get(0).getValorAnterior());
					double valorExtra    = Double.parseDouble(cicloExtra.getCicloExtra(conElias, cicloId, "2").get(0).getValorExtra());
					
					kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
				
					promedio = Double.toString( ((Double.parseDouble(notaExtra)* valorExtra)/100)+((Double.parseDouble(kardexAlumnoExtra.getPromedio())* valorPromedio)/100)   );
				}
				
				kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
				kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
				kardexAlumnoExtra.setCursoId(cursoId);
				kardexAlumnoExtra.setOportunidad("2");
				kardexAlumnoExtra.setFecha(fecha);
				kardexAlumnoExtra.setNotaAnterior(promedio);
				kardexAlumnoExtra.setNotaExtra(notaExtra);	
				kardexAlumnoExtra.setPromedio(promedio);
				
				if(kardexAlumnoExtra.existeReg(conElias )){
					if(kardexAlumnoExtra.updateReg(conElias)){
						//Actualizado correctamente
					}else{
						//error = true; break;
					}
					
				}else {
					kardexAlumnoExtra.insertReg(conElias);
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
		
		/* Refrescar lista */
		lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	}	
		
	//------------- GUARDA LOS EXTRAORDINARIOS 3 ------------->	
		else if (accion.equals("9")) { //Guardar Extraordinarios
			
			conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
			boolean error = false;		
			int cont = 0;
			
			for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
			
				String notaExtra = request.getParameter("notaExtra3"+cont)==null?"0":request.getParameter("notaExtra3"+cont);
				
				if (!notaExtra.equals("")) {
						
					String promedio = "";
					String fecha = aca.util.Fecha.getHoy();
					
					//*******COMPROBAMOS QUE EXISTA EL CICLO EXTRA 3*********//
					cicloExtra.setCicloId(cicloId);
					cicloExtra.setOportunidad("3");
					
					if(cicloExtra.existeReg(conElias)){
						
						double valorPromedio = Double.parseDouble(cicloExtra.getCicloExtra(conElias, cicloId, "3").get(0).getValorAnterior());
						double valorExtra    = Double.parseDouble(cicloExtra.getCicloExtra(conElias, cicloId, "3").get(0).getValorExtra());
						
						kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
					
						promedio = Double.toString( ((Double.parseDouble(notaExtra)* valorExtra)/100)+((Double.parseDouble(kardexAlumnoExtra.getPromedio())* valorPromedio)/100)   );
					}
					
					kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
					kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
					kardexAlumnoExtra.setCursoId(cursoId);
					kardexAlumnoExtra.setOportunidad("3");
					kardexAlumnoExtra.setFecha(fecha);
					kardexAlumnoExtra.setNotaAnterior(promedio);
					kardexAlumnoExtra.setNotaExtra(notaExtra);	
					kardexAlumnoExtra.setPromedio(promedio);
					
					if(kardexAlumnoExtra.existeReg(conElias )){
						if(kardexAlumnoExtra.updateReg(conElias)){
							//Actualizado correctamente
						}else{
							//error = true; break;
						}
						
					}else {
						kardexAlumnoExtra.insertReg(conElias);
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
			
			/* Refrescar lista */
			lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
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
		<h5><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%> <small><%=aca.plan.Plan.getNombrePlan(conElias, planId)%></small> </h5>
		
	</div>
	
	<div class="well" style="overflow:hidden;">
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
<%
	int cont = 0;
	for (aca.ciclo.CicloPromedio promedio : lisPromedio){
%>	
	
	<div class="alert alert-info">
		<fmt:message key="aca.Estrategia" />: [ <%= promedio.getNombre() %> ] &nbsp;&nbsp; <fmt:message key="aca.Valor" />: [<%= promedio.getValor() %>]
	</div>
		
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

			for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
				
				if (eval.getPromedioId().equals( promedio.getPromedioId())){
					
					cont++;					
			%>
					<tr>
						<td class="text-center" style="width:100px;"><%=cont%></td>
						<td>
							<%if (aca.ciclo.CicloGrupoActividad.tieneActividades(conElias, eval.getCicloGrupoId(), eval.getCursoId(), eval.getEvaluacionId())) {%>
								<a href="evaluarActividad.jsp?estado=<%=eval.getEstado()%>&CicloGrupoId=<%=eval.getCicloGrupoId()%>&CursoId=<%=eval.getCursoId()%>&EvaluacionId=<%=eval.getEvaluacionId()%>">
									<%=eval.getEvaluacionNombre()%>
								</a> 
							<%} else {%>
		 						<%if (cicloGrupoCurso.getEstado().equals("2") && eval.getEstado().equals("A")) {%> 
									<a href="javascript:muestraInput('<%=eval.getEvaluacionId()%>');">
										<%=eval.getEvaluacionNombre()%>
									</a> 
								<%}else{%>
		 							<%=eval.getEvaluacionNombre() %>
		 						<%}%>
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
								<a title="<fmt:message key="boton.CerrarEvaluacion" />" class="btn btn-success btn-mini"  href="javascript:cerrarEvaluacion('<%=eval.getEvaluacionId()%>', '<%=notasConCero%>');">
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
		<%}%>
	</table>
<%	} %>		
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
		} if(planCurso.getTardanza().equals("S")){
	%> 
			<a class="btn btn-mobile" href="evaluarTardanzas.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
				<fmt:message key="maestros.RegistrodeTardanzas" />
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
	
	<form action="evaluar.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" name="forma" method="post">
	
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Evaluacion" />

		<table class="table table-condensed table-bordered table-striped">
			
			<thead>
				<tr>
					<td colspan="27" class="text-center alert">
						<span title="<%=aca.ciclo.Ciclo.getCicloNombre(conElias, cicloId) %>">
							<fmt:message key="aca.SeEvalua" /> <strong><%=frmEntero.format(notaMinima)%> <fmt:message key="aca.RangoA" /> <%=escala%></strong>
						</span>  
						
						<fmt:message key="aca.YSeAcreditaCon" /> <strong><%=notaAC %></strong>
						
						&nbsp;&nbsp;
						|
						&nbsp;&nbsp;
						
						<%if(evaluaConPunto.equals("S")){%>
							<fmt:message key="aca.EvaluacionConDecimales" />
						<%}else{%>
							<fmt:message key="aca.EvaluacionConEnteros" />
						<%} %>
					</td>
				</tr>
			
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.NombreDelAlumno" /></th>
					
					<!-- --------- RECORRE LAS EVALUACIONES --------- -->
					
					<%						
					for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
						for(aca.ciclo.CicloBloque cicloBloque : lisBloque){							
							if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){								
								// Inserta columnas de evaluaciones							
								out.print("<th class='text-center' width='2%' title='"+cicloBloque.getBloqueNombre()+"'>"+cicloBloque.getCorto()+"</th>");					
								
							}
						}						
						// Inserta columna del promedio de las evaluaciones
						out.print("<th class='text-center' width='2%' title='"+cicloPromedio.getNombre()+"'>"+cicloPromedio.getCorto()+"</th>");
%>				
						<th class='text-center' width='2%' title='<%= cicloPromedio.getValor() %>%'><fmt:message key='aca.Puntos'/></th>
<%
					}
					if (lisPromedio.size() > 1){
%>				
						<th class='text-center' width='2%'><fmt:message key='aca.Nota'/></th>
<%					
					}
%>		

<%					
					if(lisTodosLosExtras.size() == 5){
						
					if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra2(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<fmt:message key="aca.Extra" />&nbsp;2
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;2
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra3(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<fmt:message key="aca.Extra" />&nbsp;3
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;3
							</a>
						</th>
					<%}
						
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
					<th class="text-center" style="width:4%;">
						<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra4(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
							<fmt:message key="aca.Extra" />&nbsp;4
						</a>
					</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;4
							</a>
						</th>
					<%}
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
					<th class="text-center" style="width:4%;">
						<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra5(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
							<fmt:message key="aca.Extra" />&nbsp;5
						</a>
					</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;5
							</a>
						</th>
					<%}
					
						//***************** CUATRO PORTUNIDADADES *********************//
					} else if(lisTodosLosExtras.size() == 4){
						
					if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra2(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<fmt:message key="aca.Extra" />&nbsp;2
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;2
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra3(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<fmt:message key="aca.Extra" />&nbsp;3
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;3
							</a>
						</th>
					<%}
						
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
					<th class="text-center" style="width:4%;">
						<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra4(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
							<fmt:message key="aca.Extra" />&nbsp;4
						</a>
					</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;4
							</a>
						</th>
					<%}
						
					//***************** TRES PORTUNIDADADES *********************//
					} else if(lisTodosLosExtras.size() == 3){
						
					if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(0).getOportunidadNombre() %>
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(0).getOportunidadNombre() %>
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra2(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<%=lisTodosLosExtras.get(1).getOportunidadNombre() %>
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(1).getOportunidadNombre() %>
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra3(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<%=lisTodosLosExtras.get(2).getOportunidadNombre() %>
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(2).getOportunidadNombre() %>
							</a>
						</th>
					<%}	
					
					//***************** DOS PORTUNIDADADES *********************//
					} else if(lisTodosLosExtras.size() == 2){
						
					if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(0).getOportunidadNombre() %>
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(0).getOportunidadNombre() %>
							</a>
						</th>
					<%} 
					
					if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra2(<%=lisKardexAlumnos.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >
								<%=lisTodosLosExtras.get(1).getOportunidadNombre() %>
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(1).getOportunidadNombre() %>
							</a>
						</th>
					<%} 
						
					//***************** UNA PORTUNIDADAD *********************//
					} else if(lisTodosLosExtras.size() == 1){
						
					if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
							<th class="text-center" style="width:4%;">
								<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >	
									<%=lisTodosLosExtras.get(0).getOportunidadNombre() %>
								</a>
							</th>
					<% }else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<%=lisTodosLosExtras.get(0).getOportunidadNombre() %>
							</a>
						</th>
					<%} 
						
					//***************** NO REGISTRRAON PORTUNIDADADES *********************//
					} else {
						
					if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%} 
						
					}
%>				
					
					<%if(cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:10%;">
								Promedio <fmt:message key="aca.Extra" />&nbsp;
						</th>
					<%} %>	
				</tr>
			</thead>			
			<%
				// Recorre la lista de Alumnos en la materia
				int i = 0;
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
	
					double promedio = 0.0;
					if (treeProm.containsKey(cicloGrupoId + cursoId + kardex.getCodigoId())) {
						aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId + cursoId + kardex.getCodigoId());
						promedio = Double.parseDouble(alumProm.getPromedio());
					} else {
						System.out.println("No encontro el promedio de:" + kardex.getCodigoId());
					}
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
						int evalCerradas =0;
						
						double promedioFinal = 0;
						String muestraPromedioFinal = "";
						
						for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
							
							for(aca.ciclo.CicloBloque cicloBloque : lisBloque){					
								if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){			
									String strNota = "-";
									// Nota del alumno en la evaluacion
									double notaEval = 0;
									if (treeNota.containsKey(cicloGrupoId + cursoId + cicloBloque.getBloqueId() + kardex.getCodigoId())) {
										notaEval = Double.parseDouble(treeNota.get(cicloGrupoId+cursoId+cicloBloque.getBloqueId()+kardex.getCodigoId()).getNota());
										
										// Formato de la evaluacion
										strNota = formato0.format(notaEval);
										if (cicloBloque.getDecimales().equals("1")) 
											strNota = formato1.format(notaEval);
									}									
									// Verifica si la nota de la evaluacion es temporal o definitiva(abierta o cerrada)
									String estadoEval = "A";									
									if (mapEvalCiclo.containsKey(cicloGrupoId+kardex.getCursoId()+cicloBloque.getBloqueId())){
										estadoEval 	= mapEvalCiclo.get(cicloGrupoId+kardex.getCursoId()+cicloBloque.getBloqueId()).getEstado();										
									}
									// Color de la evaluacion
									String colorEval = "color:blue;";
									if (estadoEval.equals("C")){
										evalCerradas++;
										colorEval = "color:black;";
									}
						%>
								<td class="text-center" style="<%=colorEval%>"><div><%=strNota%></div>
									<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) -->
									<% /*System.out.println("Datos:"+cicloBloque.getBloqueId()+":"+estadoEval+":"+kardex.getCodigoId());*/ %>
									<%if (!kardex.getTipoCalId().equals("6") && estadoEval.equals("A") ) { /* Si el alumno no se ha dado de baja y puede editar su nota */ %>
										<div class="editar<%=cicloBloque.getBloqueId()%>" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-allow-decimal="<%=evaluaConPunto.equals("S")?"si":"no" %>"
											data-max-num="<%=escala %>"
											type="text" 
											tabindex="<%=i+1%>" 
											name="nota<%=i%>-<%=cicloBloque.getBloqueId()%>"
											id="nota<%=i%>-<%=cicloBloque.getBloqueId()%>" 
											value="<%=strNota.equals("-")?"":strNota %>" 
										/>
										</div>
									<%}%>
									
								</td>
						<%
								}
							} // End for evaluaciones
							
							// Obtiene el promedio del alumno en las evaluaciones (tabla Krdx_Alum_Prom)
							double promEval = 0; 
							if (mapPromAlumno.containsKey(kardex.getCodigoId()+kardex.getCursoId()+cicloPromedio.getPromedioId())){
								promEval = Double.parseDouble(mapPromAlumno.get(kardex.getCodigoId()+kardex.getCursoId()+cicloPromedio.getPromedioId()).getNota());									
							}
							
							// Puntos del promedio
							double puntosEval = (promEval * Double.parseDouble(cicloPromedio.getValor())) / escalaEval;
							
							// Formato del promedio y los puntos (decimales usados)
							String promFormato		= formato1.format(promEval);
							String puntosFormato	= formato1.format(puntosEval);
							
							if (cicloPromedio.getDecimales().equals("0")){
								promFormato 		= formato0.format(promEval);
								puntosFormato 		= formato0.format(puntosEval);
							}else if (cicloPromedio.getDecimales().equals("2")){
								promFormato 		= formato2.format(promEval);
								puntosFormato 		= formato2.format(puntosEval);
							}	
							
							// Inserta columna del promedio de las evaluaciones
							out.print("<td class='text-center' width='2%'  >"+promFormato+"</td>");
							
							// Inserta columna de los puntos
							out.print("<td class='text-center' width='2%'  >"+puntosFormato+"</td>");
							
							promedioFinal = promedioFinal + Double.parseDouble(puntosFormato);
						
							muestraPromedioFinal = formato1.format(promedioFinal);
							
						}//End for de promedio
						if (lisPromedio.size() > 1){
							out.print("<td class='text-center' width='2%'>"+muestraPromedioFinal+"</td>");
						}
%>											
						
<% 
						String strExtra = "-";
						String strExtra2 = "-";
						String strExtra3 = "-";
						String strExtra4 = "-";
						String strExtra5 = "-";


						if(lisTodosLosExtras.size() == 5){
							// CINCO OPORTUNIDADES //
							// ************* 	EXTRAORDINARIO *************//	
							
							float numExtra 	= 0;
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									strExtra = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra = "-";
 								}																							
								
							}							
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ){%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala%>"
											type="text" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
							<%
							
							// ************* 	EXTRAORDINARIO 2 *************//	
							
							
								strExtra2 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("2");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
										strExtra2 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra2 = "-";
	 								}																							
									
								}
							%>
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra2 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 2 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra2.equals("") ) {%>
										<div class="editarExtra2" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="text" 
												tabindex="<%=i+1%>" 
												name="notaExtra2<%=i%>"
												id="notaExtra2<%=i%>" 
												value="<%=strExtra2.equals("-")?"":strExtra2 %>" 
											/>
										</div>
									<%}%>
								</td>
							<%
							
							// ************* 	EXTRAORDINARIO 3 *************//	
							
								strExtra3 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra3.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("3");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "3");
										strExtra3 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra3 = "-";
	 								}																							
									
								}
							%>
							
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra3 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 3 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra3.equals("") ) {%>
										<div class="editarExtra3" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="text" 
												tabindex="<%=i+1%>" 
												name="notaExtra3<%=i%>"
												id="notaExtra3<%=i%>" 
												value="<%=strExtra3.equals("-")?"":strExtra3 %>" 
											/>
										</div>
									<%}%>
								</td>	
						<%
						
						// ************* 	EXTRAORDINARIO 4 *************//	
						
						
							strExtra4 = "-";
							
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra3.equals("")) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("4");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "4");
									strExtra4 = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra4 = "-";
 								}																							
								
							}
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra4 %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 4 (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra4.equals("") ) {%>
									<div class="editarExtra4" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers"
											data-max-num="<%=escala %>" 
											type="text" 
											tabindex="<%=i+1%>" 
											name="notaExtra4<%=i%>"
											id="notaExtra4<%=i%>" 
											value="<%=strExtra4.equals("-")?"":strExtra4 %>" 
										/>
									</div>
								<%}%>
							</td>
						<%
						
						// ************* 	EXTRAORDINARIO 5 *************//	
						
							strExtra5 = "-";
							
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra4.equals("")) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("5");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "5");
									strExtra5 = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra5 = "-";
 								}																							
								
							}
						%>
						
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra5 %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 5 (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra5.equals("") ) {%>
									<div class="editarExtra5" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers"
											data-max-num="<%=escala %>" 
											type="text" 
											tabindex="<%=i+1%>" 
											name="notaExtra5<%=i%>"
											id="notaExtra5<%=i%>" 
											value="<%=strExtra5.equals("-")?"":strExtra5 %>" 
										/>
									</div>
								<%}%>
							</td>	
					<%
							
						}else if(lisTodosLosExtras.size() == 4){
							// CUATRO OPORTUNIDADES //
							// ************* 	EXTRAORDINARIO   *************//	
							
							float numExtra 	= 0;
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									strExtra = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra = "-";
 								}																							
								
							}							
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ){%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala%>"
											type="text" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
							<%
							
							// ************* 	EXTRAORDINARIO 2 *************//	
							
							
								strExtra2 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("2");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
										strExtra2 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra2 = "-";
	 								}																							
									
								}
							%>
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra2 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 2 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra2.equals("") ) {%>
										<div class="editarExtra2" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="text" 
												tabindex="<%=i+1%>" 
												name="notaExtra2<%=i%>"
												id="notaExtra2<%=i%>" 
												value="<%=strExtra2.equals("-")?"":strExtra2 %>" 
											/>
										</div>
									<%}%>
								</td>
							<%
							
							// ************* 	EXTRAORDINARIO 3 *************//	
							
								strExtra3 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra3.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("3");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "3");
										strExtra3 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra3 = "-";
	 								}																							
									
								}
							%>
							
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra3 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 3 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra3.equals("") ) {%>
										<div class="editarExtra3" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="text" 
												tabindex="<%=i+1%>" 
												name="notaExtra3<%=i%>"
												id="notaExtra3<%=i%>" 
												value="<%=strExtra3.equals("-")?"":strExtra3 %>" 
											/>
										</div>
									<%}%>
								</td>	
						<%
						
						// ************* 	EXTRAORDINARIO 4 *************//	
						
						
							strExtra4 = "-";
							
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra3.equals("")) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("4");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "4");
									strExtra4 = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra4 = "-";
 								}																							
								
							}
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra4 %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 4 (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra4.equals("") ) {%>
									<div class="editarExtra4" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers"
											data-max-num="<%=escala %>" 
											type="text" 
											tabindex="<%=i+1%>" 
											name="notaExtra4<%=i%>"
											id="notaExtra4<%=i%>" 
											value="<%=strExtra4.equals("-")?"":strExtra4 %>" 
										/>
									</div>
								<%}%>
							</td>
						<%	
							
							
						
							
						}else if(lisTodosLosExtras.size() == 3){
							// TRES OPORTUNIDADES //
							// ************* 	EXTRAORDINARIO   *************//	
							
							float numExtra 	= 0;
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									
									if(kardexAlumnoExtra.getNotaExtra().equals("")){
										strExtra = "-";
									}else{
										strExtra = kardexAlumnoExtra.getNotaExtra();
									}
									
 								} else {
 									strExtra = "-";
 								}																							
						
							}							
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
						<%
						String tipoInput1 = "hidden";						 
						if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
							tipoInput1 = "text";
						}
						%>		
							<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ){%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala%>"
											type="<%=tipoInput1%>" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
							<%
							
							// ************* 	EXTRAORDINARIO 2 *************//	
							
							
								strExtra2 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("2");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
										strExtra2 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra2 = "-";
	 								}																							
									
								}
							%>
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra2 %></div>
							<%
							String tipoInput2 = "hidden";						 
							if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
								tipoInput2 = "text";
							}
							%>		
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 2 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra2.equals("") ) {%>
										<div class="editarExtra2" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="<%=tipoInput2%>" 
												tabindex="<%=i+1%>" 
												name="notaExtra2<%=i%>"
												id="notaExtra2<%=i%>" 
												value="<%=strExtra2.equals("-")?"":strExtra2 %>" 
											/>
										</div>
									<%}%>
								</td>
							<%
							
							// ************* 	EXTRAORDINARIO 3 *************//	
							
								strExtra3 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra3.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("3");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "3");
										strExtra3 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra3 = "-";
	 								}																							
									
								}
							%>
							
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra3 %></div>
							<%
						String tipoInput3 = "hidden";						 
						if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
							tipoInput3 = "text";
						}
						%>		
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 3 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra3.equals("") ) {%>
										<div class="editarExtra3" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="<%=tipoInput3%>" 
												tabindex="<%=i+1%>" 
												name="notaExtra3<%=i%>"
												id="notaExtra3<%=i%>" 
												value="<%=strExtra3.equals("-")?"":strExtra3 %>" 
											/>
										</div>
									<%}%>
								</td>	
						<%	
						}else if(lisTodosLosExtras.size() == 2){
							// DOS OPORTUNIDADES //
							// ************* 	EXTRAORDINARIO   *************//	
							
							float numExtra 	= 0;
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									strExtra = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra = "-";
 								}																							
								
							}							
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
						<%
						String tipoInput1 = "hidden";						 
						if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
							tipoInput1 = "text";
						}
						%>		
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ){%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala%>"
											type="<%=tipoInput1%>" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
							<%
							
							// ************* 	EXTRAORDINARIO 2 *************//	
							
							
								strExtra2 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("2");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
										strExtra2 = kardexAlumnoExtra.getNotaExtra();
	 								} else {
	 									strExtra2 = "-";
	 								}																							
									
								}
							%>
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra2 %></div>
							<%
							String tipoInput2 = "hidden";						 
							if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
								tipoInput2 = "text";
							}
							%>		
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 2 (ESCONDIDO POR DEFAULT) -->
									<%if ( !strExtra2.equals("") ) {%>
										<div class="editarExtra2" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers"
												data-max-num="<%=escala %>" 
												type="<%=tipoInput2%>" 
												tabindex="<%=i+1%>" 
												name="notaExtra2<%=i%>"
												id="notaExtra2<%=i%>" 
												value="<%=strExtra2.equals("-")?"":strExtra2 %>" 
											/>
										</div>
									<%
									}
									%>
								</td>
							<%	
	
						}else if(lisTodosLosExtras.size() == 1){
							// ************* 	EXTRAORDINARIO   *************//	
							
							float numExtra 	= 0;
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									
									strExtra = kardexAlumnoExtra.getNotaExtra();
							
 								} else {
 									strExtra = "-";
 								}																							
								
							}
							
						%>
							<td class="text-center">
							<div id="extra<%=i%>"><%=strExtra %></div>
						<%
						String tipoInput1 = "hidden";						 
						if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
							tipoInput1 = "text";
						}
						%>				
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ){%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala%>"
											type="<%=tipoInput1%>" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
							<%	
						}else{
						%>
						
							<!-- SI NO REGISTRO NINGUNA OPORTUNIDAD  --> 
							<!-- ************* 	EXTRAORDINARIO   *************	 --> 
						<%	
							float numExtra 	= 0;
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									strExtra = kardexAlumnoExtra.getNotaExtra();
 								} else {
 									strExtra = "-";
 								}																							
								
							}							
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
						<%
						String tipoInput = "hidden";						 
						if(aca.kardex.KrdxCursoAct.getAlumnoReprobado(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId)){							
							tipoInput = "text";
						}
						%>		
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ){%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala%>"
											type="<%=tipoInput%>" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
							<%	
						}
						%>	
						
						<!-- --------- PROMEDIO DEL EXTRA ACTUAL MAS PROMEDIO --------- -->
							<%
							String promedioFinalExtra = "";
							String alumnosEnExtra = aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId); 
							
							if(Integer.parseInt(alumnosEnExtra) > 0 && cicloGrupoCurso.getEstado().equals("3")){ %>
								<td class="text-center">
								<%if ( strExtra == "-") {%>
									<div id="extra<%=i%>"><%="-"%></div>
								<%
								} else if ( strExtra5 != "-") {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "5");
									promedioFinalExtra = kardexAlumnoExtra.getPromedio();
								%>
									<div id="extra<%=i%>"><%=promedioFinalExtra %></div>
								<%} else if (strExtra4 != "-" ) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "4");
									promedioFinalExtra = kardexAlumnoExtra.getPromedio();
								%>
									<div id="extra<%=i%>"><%=promedioFinalExtra %></div>
								<%} else if ( strExtra3 != "-") {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "3");
									promedioFinalExtra = kardexAlumnoExtra.getPromedio();
								%>
									<div id="extra<%=i%>"><%=promedioFinalExtra %></div>
								<%} else if (strExtra2 != "-" ) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
									promedioFinalExtra = kardexAlumnoExtra.getPromedio();
								%>
									<div id="extra<%=i%>"><%=promedioFinalExtra %></div>
								<%} else if ( strExtra != "-" ) {	
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									promedioFinalExtra = kardexAlumnoExtra.getPromedio();
								%>
									<div id="extra<%=i%>"><%=promedioFinalExtra %></div>
								<%} %>									
							
								</td>
							<%}else { %>	
								<td class="text-center">
									<div id="extra<%=i%>"><%="-"%></div>
								</td>
							<%} %>		
							
													
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
					<td>&nbsp;</td>
					
					<%
					if(lisTodosLosExtras.size() == 5){
					%>
					<td>&nbsp;</td>
					<!-- BOTON DE NOTA EXTRA -->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
						</div>
					</td>
					
					<!-- BOTON DE NOTA EXTRA 2 -->
						<td class="text-center">
							<div class="editarExtra2" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra2();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
					
					<!-- BOTON DE NOTA EXTRA 3 -->
						<td class="text-center">
							<div class="editarExtra3" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra3();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
					<!-- BOTON DE NOTA EXTRA 4 -->
						<td class="text-center">
							<div class="editarExtra4" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra4();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
					
					<!-- BOTON DE NOTA EXTRA 5 -->
						<td class="text-center">
							<div class="editarExtra5" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra5();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
						<td>&nbsp;</td>
					<%	
					}else if(lisTodosLosExtras.size() == 4){
					%>	
					<td>&nbsp;</td>
					<!-- BOTON DE NOTA EXTRA -->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
						</div>
					</td>
					
					<!-- BOTON DE NOTA EXTRA 2 -->
						<td class="text-center">
							<div class="editarExtra2" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra2();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
					
					<!-- BOTON DE NOTA EXTRA 3 -->
						<td class="text-center">
							<div class="editarExtra3" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra3();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
					<!-- BOTON DE NOTA EXTRA 4 -->
						<td class="text-center">
							<div class="editarExtra4" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra4();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
						<td>&nbsp;</td>
					<%
					}if(lisTodosLosExtras.size() == 3){
					%>	
					<td>&nbsp;</td>
					<!-- BOTON DE NOTA EXTRA -->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
						</div>
					</td>
					
					<!-- BOTON DE NOTA EXTRA 2 -->
						<td class="text-center">
							<div class="editarExtra2" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra2();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
					
					<!-- BOTON DE NOTA EXTRA 3 -->
						<td class="text-center">
							<div class="editarExtra3" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra3();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
						<td>&nbsp;</td>
					<%
					}if(lisTodosLosExtras.size() == 2){
					%>
					<td>&nbsp;</td>
					<!-- BOTON DE NOTA EXTRA -->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
						</div>
					</td>
					
					<!-- BOTON DE NOTA EXTRA 2 -->
						<td class="text-center">
							<div class="editarExtra2" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra2();"><fmt:message key="boton.Guardar" /></a> 
							</div>
						</td>
						<td>&nbsp;</td>
					<%	
					}if(lisTodosLosExtras.size() == 1){
					%>
					<!-- BOTON DE NOTA EXTRA -->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
						</div>
					</td>
					<td>&nbsp;</td>
					<%
					}  if(lisTodosLosExtras.size() < 1){
					%>
					<td>&nbsp;</td>
					<!-- BOTON DE NOTA EXTRA  CUANDO NO ASIGNAN NINGUN EXTRA-->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
						</div>
					</td>
					<td>&nbsp;</td>
					<%
 					}
					%> 
										
					<td>&nbsp;</td>
				</tr>
		</table>
	</form>


</div>




<%@ include file="../../cierra_elias.jsp"%>