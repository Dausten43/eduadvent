<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@page import="java.text.DecimalFormat"%>
<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloBloque"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.ciclo.CicloPromedio"%>
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
<jsp:useBean id="kardexProm" scope="page" class="aca.kardex.KrdxAlumProm" />
<jsp:useBean id="krdxAlumPromL" scope="page" class="aca.kardex.KrdxAlumPromLista" />
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso" />
<jsp:useBean id="planCursoLista" scope="page" class="aca.plan.PlanCursoLista" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="CicloExtraL" scope="page" class="aca.ciclo.CicloExtraLista"/>
<jsp:useBean id="kardexAlumnoExtra" scope="page" class="aca.kardex.KrdxAlumExtra" />
<jsp:useBean id="cicloExtra" scope="page" class="aca.ciclo.CicloExtra" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo"/>

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
	 * BORRA EXTRA 
	 */
	function borrarExtra(evaluacion){	
		if ( confirm("<fmt:message key="js.EsteProcesoEliminaElExtra" />")==true ){
			document.forma.Accion.value = "10";
			document.forma.submit();	
		}		
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
	 * BORRA EXTRA 2
	 */
	function borrarExtra2(evaluacion){	
		if ( confirm("<fmt:message key="js.EsteProcesoEliminaElExtra" />")==true ){
			document.forma.Accion.value = "11";
			document.forma.submit();	
		}		
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
	 * BORRA EXTRA 3
	 */
	function borrarExtra3(evaluacion){	
		if ( confirm("<fmt:message key="js.EsteProcesoEliminaElExtra" />")==true ){
			document.forma.Accion.value = "12";
			document.forma.submit();	
		}		
	}	
	
	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON EN LOS EXTRAORDINARIOS
	 */
	function guardarExtra(){
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
	 * PROMEDIAR CONDUCTA POR PROMEDIOS
	 */
	function promediarConductaProm(promedio){		
		if(confirm("<fmt:message key="js.PromediarConductaEvaluacion" />")==true){
			document.forma.Promedio.value = promedio;
			document.forma.Accion.value = "13";
			document.forma.submit();
		}
	}
	
	/*
	 * PROMEDIAR CONDUCTA POR EVALUACIONES
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
	
	/*
	 * EVALUAR DERIVADAS
	 */
	function evaluarDerivadas(bloque, evalId){		
		document.forma.Derivadas.value = "1";
		document.forma.DerivadasTrimestre.value = bloque;
		document.forma.EvalId.value = evalId;
		document.forma.submit();
	}

	function goExams(){
		document.formExams.submit();
	}
</script>
<%
	//FORMATOS ---------------------------->
	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato4	= new java.text.DecimalFormat("##0.0000;-##0.0000", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	formato4.setRoundingMode(java.math.RoundingMode.DOWN);

	java.text.DecimalFormat frmEntero 	= new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	
	java.math.MathContext MATH_CTX = new java.math.MathContext(8,RoundingMode.HALF_UP);
	
	//VARIABLES ---------------------------->
	String escuelaId 		= (String) session.getAttribute("escuela");
	String cicloId 			= (String) session.getAttribute("cicloId");
	String codigoId 		= (String) session.getAttribute("codigoId");
	
	boolean permitirCambiarElEstado = false; 
	boolean muestraBotonGuardarExtra = false;
	boolean muestraBotonGuardarExtra2 = false;
	boolean muestraBotonGuardarExtra3 = false;
	boolean muestraBotonGuardarExtra4 = false;
	boolean muestraBotonGuardarExtra5 = false;
	
	
	String evaluarDerivadas	= request.getParameter("Derivadas") == null?"0":request.getParameter("Derivadas");
	String deriTrimestre	= request.getParameter("DerivadasTrimestre") == null?"0":request.getParameter("DerivadasTrimestre");
	String evalId			= request.getParameter("EvalId") == null?"0":request.getParameter("EvalId");
	
	

	String accion 			= request.getParameter("Accion") == null?"0":request.getParameter("Accion");
	String cicloGrupoId	 	= request.getParameter("CicloGrupoId");
	String cursoId 			= request.getParameter("CursoId");
	String estado 			= request.getParameter("estado");
	String valor			= "0";
	
	String planId 			= aca.plan.PlanCurso.getPlanId(conElias, cursoId);
	String nivelId  		= aca.plan.Plan.getNivel(conElias, planId);
	String nivelEvaluacion 	= aca.ciclo.Ciclo.getNivelEval(conElias, cicloId);
	
	ciclo.mapeaRegId(conElias, cicloId);
	
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
	ArrayList<aca.ciclo.CicloGrupoEval> lisEvaluacion   = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
	
	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
			
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
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");
	ArrayList<aca.kardex.KrdxAlumExtra> lisKardexAlumnosExtra	= kardexAlumnoExtra.getAlumnoExtra(conElias, codigoId, cicloGrupoId, cursoId);
	
	//LISTA EXTRAS
	ArrayList<aca.ciclo.CicloExtra> lisTodosLosExtras			= cicloExtra.getTodosLosCiclosExtras(conElias, cicloId);
	
	//LISTA CURSOS DERIVADOS
	ArrayList<aca.plan.PlanCurso> listaMateriasDerivadas		= planCursoLista.getMateriasHijas(conElias, cursoId);
	
	// TREEMAP DE LAS NOTAS DE LAS EVALUACIONES DE LOS ALUMNOS
	java.util.TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexEvalLista.getTreeMateria(conElias,	cicloGrupoId, cursoId, "");
	
	//TREEMAP DE LOS PROMEDIOS DE LOS ALUMNOS EN LA MATERIA (de la vista de alum_prom)
	java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
	
/* ********************************** ACCIONES ********************************** */
	String msj = request.getParameter("msj")==null?"":request.getParameter("msj");	






//------------- GUARDA CALIFICACIONES DE UNA MATERIA DRIVADA ------------->
	if (evaluarDerivadas.equals("1")) {
		//System.out.println("CicloPromedio.getDecimales(conElias, "+cicloId+", "+deriTrimestre+")");
		String decimales = nivelEvaluacion.equals("P")?aca.ciclo.CicloPromedio.getDecimales(conElias, cicloId, deriTrimestre):aca.ciclo.CicloBloque.getDecimales(conElias, cicloId, evalId);
		String redondeo	= nivelEvaluacion.equals("P")?aca.ciclo.CicloPromedio.getRedondeo(conElias, cicloId, deriTrimestre):aca.ciclo.CicloBloque.getRedondeo(conElias, cicloId, evalId);
		String promedioId = deriTrimestre;
		boolean guardado = true;
		//System.out.println(decimales);
		//System.out.println("++"+redondeo+"++");
		
		
		if(!kardexEvalLista.checkMateriasHijas(conElias, cicloGrupoId, cursoId, deriTrimestre, "A", nivelEvaluacion, evalId)){ //CHECKS FOR MATERIAS HIJAS NO CERRADAS
			if(nivelEvaluacion.equals("P")){
				ArrayList<aca.kardex.KrdxAlumProm> listKAP = krdxAlumPromL.getListHijas(conElias, cicloGrupoId, cursoId, "ORDER BY CODIGO_ID, CURSO_ID");
				aca.ciclo.CicloPromedio cp = new aca.ciclo.CicloPromedio();
				cp.mapeaRegId(conElias, cicloId, promedioId);
				String alumno = "";
				java.math.MathContext mc;
				
				java.text.DecimalFormat frm = new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
				if(decimales.equals("1"))
					frm	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
				if(decimales.equals("2"))
					frm	= new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
				if(redondeo.equals("T")){
					frm.setRoundingMode(java.math.RoundingMode.DOWN);
					mc = new java.math.MathContext(4, RoundingMode.HALF_EVEN);
				}else{
					frm.setRoundingMode(java.math.RoundingMode.HALF_UP);
					mc = new java.math.MathContext(4, RoundingMode.HALF_UP);
				}

				BigDecimal sumaNota = new BigDecimal(0,mc), sumaValor = new BigDecimal(0,mc);
				
				for(aca.kardex.KrdxAlumProm z: listKAP){
					if(alumno.equals(""))
						alumno = z.getCodigoId();
					if(!alumno.equals(z.getCodigoId())){// Al cambiar de alumno se guarda el promedio en el curso base (materia madre)
						String total = frm.format(0.0d); 
						if(sumaNota.floatValue() > 0f && sumaValor.floatValue() > 0f)
							total = frm.format(sumaNota.divide(sumaValor,mc));
						
						kardexProm.setCodigoId(alumno);
						kardexProm.setCicloGrupoId(cicloGrupoId);
						kardexProm.setCursoId(cursoId);
						kardexProm.setPromedioId(promedioId);
						//System.out.println("total = "+total +"; Sin formato = "+(sumaNota.divide(sumaValor,8,RoundingMode.HALF_EVEN).doubleValue()));
						if(kardexProm.existeReg(conElias)){
							kardexProm.setNota(total);
							kardexProm.setValor(cp.getValor());
							if(!kardexProm.updateReg(conElias))
								guardado &= false;
						}else{
							kardexProm.setNota(total);
							kardexProm.setValor(cp.getValor());
							if(!kardexProm.insertReg(conElias))
								guardado &= false;
						}
						
						alumno = z.getCodigoId();
						sumaNota = new BigDecimal(0);
						sumaValor = new BigDecimal(0);
					}
					if(z.getPromedioId().equals(promedioId)){
						BigDecimal notaEnFormato = new BigDecimal(frm.format(new BigDecimal(Float.parseFloat(z.getNota()),mc)),mc);
						sumaNota = sumaNota.add((notaEnFormato.multiply(new BigDecimal(Float.parseFloat(z.getValor()),mc))));
						sumaValor = sumaValor.add(new BigDecimal(Float.parseFloat(z.getValor()),mc));
						//System.out.println("Nota = "+notaEnFormato+"; operacion = "+(notaEnFormato.multiply(new BigDecimal(Float.parseFloat(z.getValor()),mc)))+"; sumaNota = "+sumaNota+"; sumaValor = "+sumaValor);
					}
				}
				
				String total = frm.format(0.0d);
				if(sumaNota.floatValue() > 0f && sumaValor.floatValue() > 0f)
					total = frm.format(sumaNota.divide(sumaValor,mc).doubleValue());
				
				kardexProm.setCodigoId(alumno);
				kardexProm.setCicloGrupoId(cicloGrupoId);
				kardexProm.setCursoId(cursoId);
				kardexProm.setPromedioId(promedioId);
				//System.out.println("total = "+total +"; Sin formato = "+(sumaNota.divide(sumaValor,8,RoundingMode.HALF_EVEN).doubleValue()));
				if(kardexProm.existeReg(conElias)){
					kardexProm.setNota(total);
					kardexProm.setValor(cp.getValor());
					if(!kardexProm.updateReg(conElias))
						guardado &= false;
				}else{
					kardexProm.setNota(total);
					kardexProm.setValor(cp.getValor());
					if(!kardexProm.insertReg(conElias))
						guardado &= false;
				}
			}else{
				ArrayList<aca.kardex.KrdxAlumEval> listEval = kardexEvalLista.getListHija(conElias, cursoId, decimales, redondeo);
				for(aca.kardex.KrdxAlumEval evalua:  listEval){
					if(evalua.existeReg(conElias)){
						//System.out.println("update");
						if(!evalua.updateReg(conElias))
							guardado &= false;
					}
					else{
						if(!evalua.insertReg(conElias))
							guardado &= false;
						//System.out.println("Insert");
					}
				}
			}
			if(guardado){
%>
				<script>
					document.location = "evaluar.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&msj=Guardado";
				</script>
<%
			}else{
%>
				<script>
					document.location = "evaluar.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>&msj=ErrorAlPromediar";
				</script>
<%
			}

		}else{
		%>
		<script>
			alert("No estan cerradas las evaluaciones de la(s) materia(s) hija(s), por lo tanto no se realizó el cálculo");
		</script>
		<% 	
		}
	}

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
			msj = "Eliminado";
		} else {
			msj = "ErrorBorrar";
		}
		
		// Actualizar los promedios (CICLO_PROMEDIO)
		mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);
		
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
		} else {
			error = true;
		}
			
		//------------------- SI YA SE CERRARON TODAS LAS EVALUACIONES, ENTONCES CIERRA LA MATERIA (guarda las calificaciones del alumno y cambia el estado de la materia) ------------------->
		if (aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId)) {

			// Actualizar los promedios
			treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
			
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
			
			String notaExtra = request.getParameter("notaExtra"+cont)==null?"0":request.getParameter("notaExtra"+cont);		
 		
			if (!notaExtra.equals("")) {
				
				/* OBTIENE EL PROMEDIO ORDINARIO DEL ALUMNO **/
				double promOrd = 0;
				if (treeProm.containsKey(kardex.getCicloGrupoId()+kardex.getCursoId()+kardex.getCodigoId())){
					aca.vista.AlumnoProm alumProm = treeProm.get(kardex.getCicloGrupoId()+kardex.getCursoId()+kardex.getCodigoId());
					promOrd = Double.parseDouble(alumProm.getPromedio());
				}
				
				double promExtra = 0;
				String fecha = aca.util.Fecha.getHoy();
				
				//*******COMPROBAMOS QUE EXISTA EL CICLO EXTRA*********//
				cicloExtra.setCicloId(cicloId);
				cicloExtra.setOportunidad("1");
				
				if(cicloExtra.existeReg(conElias)){
					cicloExtra.mapeaRegId(conElias, cicloId, "1");
					
					double valorAnterior = Double.parseDouble(cicloExtra.getValorAnterior());
					double valorExtra    = Double.parseDouble(cicloExtra.getValorExtra());
					
					promExtra = ((Double.parseDouble(notaExtra)* valorExtra)/100) + ((promOrd * valorAnterior)/100);
					//System.out.println("Datos:"+(Double.parseDouble(notaExtra)* valorExtra)/100+":"+(promOrd * valorAnterior)/100 +":"+ formato2.format(promExtra));					
				}else{
					promExtra = Double.parseDouble(notaExtra);
				}
				
				kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
				kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
				kardexAlumnoExtra.setCursoId(cursoId);
				kardexAlumnoExtra.setOportunidad("1");
				kardexAlumnoExtra.setFecha(fecha);
				kardexAlumnoExtra.setNotaAnterior(Double.toString(promOrd));
				kardexAlumnoExtra.setNotaExtra(notaExtra);	
				kardexAlumnoExtra.setPromedio(formato2.format(promExtra));
				
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
					//System.out.println("Datos:"+notaExtra);
					/* OBTIENE EL PROMEDIO DEL EXTRAORDINARIO ANTERIOR (#1) **/
					double promAnt = Double.parseDouble(aca.kardex.KrdxAlumExtra.getPromedio(conElias, kardex.getCodigoId(), kardex.getCicloGrupoId(), kardex.getCursoId(), "1"));				
						
					double promExtra = 0;				
					String fecha = aca.util.Fecha.getHoy();
					
					//*******COMPROBAMOS QUE EXISTA EL CICLO EXTRA 2 *********//
					cicloExtra.setCicloId(cicloId);
					cicloExtra.setOportunidad("2");
					
					if(cicloExtra.existeReg(conElias)){		
						cicloExtra.mapeaRegId(conElias, cicloId, "2");
						double valorAnterior = Double.parseDouble(cicloExtra.getValorAnterior());
						double valorExtra    = Double.parseDouble(cicloExtra.getValorExtra());
						
						promExtra = ((Double.parseDouble(notaExtra)* valorExtra)/100) + ((promAnt * valorAnterior)/100);
						
					}else{
						promExtra = Double.parseDouble(notaExtra);
					}
					
					kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
					kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
					kardexAlumnoExtra.setCursoId(cursoId);
					kardexAlumnoExtra.setOportunidad("2");
					kardexAlumnoExtra.setFecha(fecha);
					kardexAlumnoExtra.setNotaAnterior(formato2.format(promAnt));
					kardexAlumnoExtra.setNotaExtra(notaExtra);	
					kardexAlumnoExtra.setPromedio(formato2.format(promExtra));
					
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
	//------------- BORRA CALIFICACIONES DE EXTRA ------------->
			else if (accion.equals("10")) { //Borrar Extraordinario
				conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
				boolean error = false;		
				int cont = 0;
				
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
						
						kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
						kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
						kardexAlumnoExtra.setCursoId(cursoId);
						kardexAlumnoExtra.setOportunidad("1");
						
						if(kardexAlumnoExtra.existeReg(conElias )){
							
							if(kardexAlumnoExtra.deleteReg(conElias)){
								//Eliminado correctamente
								msj = "Eliminado";
							}else{
								//error = true; break;
								msj = "ErrorBorrar";
							}
							
						}
					cont++;
				}
			
				conElias.setAutoCommit(true);//** END TRANSACTION **
				
				/* Refrescar lista */
				lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
			}
		//------------- BORRA CALIFICACIONES DE EXTRA 2 ------------->
			else if (accion.equals("11")) { //Borrar Extraordinario 2
				
				conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
				boolean error = false;		
				int cont = 0;
				
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
						
						kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
						kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
						kardexAlumnoExtra.setCursoId(cursoId);
						kardexAlumnoExtra.setOportunidad("2");
						
						if(kardexAlumnoExtra.existeReg(conElias )){
							
							if(kardexAlumnoExtra.deleteReg(conElias)){
								//Eliminado correctamente
								msj = "Eliminado";
							}else{
								//error = true; break;
								msj = "ErrorBorrar";
							}
							
						}
					cont++;
				}
					
				conElias.setAutoCommit(true);//** END TRANSACTION **
				
				/* Refrescar lista */
				lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
			}
		//------------- BORRA CALIFICACIONES DE EXTRA 3 ------------->
			else if (accion.equals("12")) { //Borrar Extraordinario 3
				conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
				boolean error = false;		
				int cont = 0;
				
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
						
						kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
						kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
						kardexAlumnoExtra.setCursoId(cursoId);
						kardexAlumnoExtra.setOportunidad("3");
						
						if(kardexAlumnoExtra.existeReg(conElias )){
							
							if(kardexAlumnoExtra.deleteReg(conElias)){
								//Eliminado correctamente
								msj = "Eliminado";
							}else{
								//error = true; break;
								msj = "ErrorBorrar";
							}
							
						}
					cont++;
				}
					
				conElias.setAutoCommit(true);//** END TRANSACTION **
				
				/* Refrescar lista */
				lisKardexAlumnos			= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
			}//------------- PROMEDIAR CONDUCTA DE TODAS LAS MATERIAS ------------->
			else if (accion.equals("13")) {
				
				String promedio = request.getParameter("Promedio");
				
				if (aca.kardex.KrdxAlumConducta.tieneEvaluacionesDeConducta(conElias, cicloGrupoId, promedio,"0")) {
						
						ArrayList<aca.kardex.KrdxAlumConducta> lisConducta = kardexConductaLista.getListAll(conElias,"WHERE CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND PROMEDIO_ID = " + promedio + " AND CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CONDUCTA = 'S') ORDER BY CODIGO_ID");
						
						if (lisConducta.size() > 0) {
							int error = 0;
							for (aca.kardex.KrdxCursoAct alumno : lisKardexAlumnos) { //Alumnos de este grupo
								//int sumaNotas = 0;
								//int cantidadMaterias = 0;
								BigDecimal sumaNotas = new BigDecimal("0.0");
								BigDecimal cantidadMaterias = new BigDecimal("0");
								for (aca.kardex.KrdxAlumConducta krdxConducta : lisConducta) { //Notas de todos los alumnos de este grupo de todas las materias
									if (krdxConducta.getCodigoId().equals(alumno.getCodigoId()) && Float.parseFloat(krdxConducta.getConducta()) > 0) {
										//sumaNotas += Float.parseFloat(krdxConducta.getConducta());
										//cantidadMaterias++;
										sumaNotas = sumaNotas.add( new BigDecimal(krdxConducta.getConducta()) );
										cantidadMaterias = cantidadMaterias.add(new BigDecimal("1"));
									}
								}
								
								kardexProm.mapeaRegId(conElias, alumno.getCodigoId(), cicloGrupoId, cursoId, promedio);
								
								kardexProm.setCodigoId(alumno.getCodigoId());
								kardexProm.setCicloGrupoId(cicloGrupoId);
								kardexProm.setCursoId(cursoId);
								kardexProm.setPromedioId(promedio);
								
								//if (cantidadMaterias == 0 || sumaNotas < 1){
								if( cantidadMaterias.compareTo(BigDecimal.ZERO) == 0 || sumaNotas.compareTo(new BigDecimal("1")) == -1 ){
									kardexProm.setNota("0");
								}else{
									//System.out.println(sumaNotas+":"+cantidadMaterias+":"+sumaNotas.divide(cantidadMaterias, 2, RoundingMode.HALF_UP));
									kardexProm.setNota( sumaNotas.divide(cantidadMaterias, 2, RoundingMode.HALF_UP ).toString());
								}
								
								if (kardexProm.existeReg(conElias)) {
								
									if (!kardexProm.updateReg(conElias)){
										error++;
									}
								} else {
									if (!kardexProm.insertReg(conElias)){
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
					
				} else {
					msj = "MaestroNoHaEvaluado";
				}
			 }
		
		pageContext.setAttribute("resultado", msj);
	
/* ********************************** END ACCIONES ********************************** */

	
	// TREEMAP DE LAS NOTAS DE LAS EVALUACIONES DE LOS ALUMNOS
	treeNota = kardexEvalLista.getTreeMateria(conElias,	cicloGrupoId, cursoId, "");
		
	//TREEMAP DE LOS PROMEDIOS DE LOS ALUMNOS EN LA MATERIA (de la vista de alum_prom)
	treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
	
	planCurso.mapeaRegId(conElias, cursoId);
	
	cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());		
%>

<!--  ********************************************** HTML MARKUP **********************************************  -->

<div id="content">
	<h3>
		<fmt:message key="aca.Evaluaciones" />		
		<small>
		( 
			<%=empPersonal.getNombre() + " " + empPersonal.getApaterno()+ " " + empPersonal.getAmaterno()%> | 
			<%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | 
			<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%> <%= cicloGrupo.getGrupo() %> | 
			<%=aca.plan.Plan.getNombrePlan(conElias, planId)%>
		 )
		</small>
		<span id="countMsg"></span>
	</h3>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>

	<div class="well" style="overflow:hidden;">
		<a href="cursos.jsp" class="btn btn-primary btn-mobile">
			<i class="icon-th-list icon-white"></i> <fmt:message key="aca.Cursos" />
		</a>		
		<a class="btn btn-mobile" target="_blank" href="tarjeta.jsp?Curso=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&CodigoId=<%=codigoId%>">
			<i class="icon-book"></i> <fmt:message key="aca.Tarjetas" />
		</a>
		
		<a class="btn btn-mobile" target="_blank" href="actamateria.jsp?Curso=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
			<i class="icon-print"></i> <fmt:message key="aca.Acta" />
		</a>
		
		<a class="btn btn-mobile" target="_blank" href="formatoAsistencia.jsp?CicloGrupoId=<%=cicloGrupoId%>&CursoId=<%=cursoId%>">
			<i class="icon-list-alt"></i> <fmt:message key="aca.Asistencia" />
		</a>
		<a data-toggle="modal" data-id="<%= cicloGrupoId %>" data-tipomsg="G" data-informacion="<%= aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %>-<%=cicloGrupo.getGrupoNombre() %> <%=cicloGrupo.getGrupo() %>"
							class="open-MensajeBox btn btn-warning" href="#mensajeBox" >Enviar Mensaje al Grupo</a>
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
	</div>
	
<!--  -------------------- TABLA DE EVALUACIONES -------------------- -->
<%
	int cont = 0;
	for (aca.ciclo.CicloPromedio promedio : lisPromedio){
%>
	<div class="alert alert-info">
		<fmt:message key="aca.Estrategia" />: [ <%= promedio.getNombre() %> ] &nbsp;&nbsp;
		<fmt:message key="aca.Valor" />: [<%= promedio.getValor() %>] &nbsp;
<%		
		if (planCurso.getAspectos().equals("S")){
			if (nivelEvaluacion.equals("P")){
%>		
		<a class="btn btn-mobile btn-success btn-mini" href="evaluarActitudesProm.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&PromedioId=<%=promedio.getPromedioId()%>">
			<i class="icon-star icon-white"></i>
		</a>
<%		 	
			}
		}

		boolean materiaMadreP = false;
		/* Busca si tiene materias derivadas y si encuentra alguna muestra el boton para promediarlas */
		if(listaMateriasDerivadas.size() > 0 && nivelEvaluacion.equals("P")){
			materiaMadreP = true;
%>
			<!-- CALCULA EL PROMEDIO LAS MATERIAS QUE TIENEN MATERIAS DERIVADAS --> 
			<button class="btn btn-info" onclick="javaScript:evaluarDerivadas(<%=promedio.getPromedioId() %>,'')">
				Promediar derivadas
			</button>			
<%	
		}
%>		
	</div>
		
	<table class="table table-fullcondensed table-bordered table-striped table-fontsmall">
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th><fmt:message key="aca.Descripcion" /></th>
					<th class="text-center"><fmt:message key="aca.Fecha" /></th>
					<th class="text-center"><fmt:message key="aca.Valor" /></th>
					<th class="text-center"><fmt:message key="aca.Decimal" /></th>
					<th class="text-center"><fmt:message key="aca.Estado" /></th>
					<th style="width:1%;"></th>
				</tr>
			</thead>
			<%
				for (aca.ciclo.CicloGrupoEval eval : lisEvaluacion) {
					if (eval.getPromedioId().equals(promedio.getPromedioId())){
						valor = eval.getValor();
						cont++;
			%>
					<tr>
						<td class="text-center" style="width:100px;"><%=cont%></td>
						<td>
							<%if (aca.ciclo.CicloGrupoActividad.tieneActividades(conElias, eval.getCicloGrupoId(), eval.getCursoId(), eval.getEvaluacionId())) {%>
								<a href="evaluarActividad.jsp?estado=<%=eval.getEstado()%>&CicloGrupoId=<%=eval.getCicloGrupoId()%>&CursoId=<%=eval.getCursoId()%>&EvaluacionId=<%=eval.getEvaluacionId()%>&BloqueId=<%=eval.getEvaluacionId()%>">
									<%=eval.getEvaluacionNombre()%>
								</a> 
							<%}else {
		 						if (cicloGrupoCurso.getEstado().equals("2") && eval.getEstado().equals("A") && !materiaMadreP) {%> 
									<a href="javascript:muestraInput('<%=eval.getEvaluacionId()%>');">
										<%=eval.getEvaluacionNombre()%>
									</a> 
									<%
									/* Busca si tiene materias derivadas y si encuentra alguna muestra el boton para promediarlas */
									if(listaMateriasDerivadas.size() > 0 && nivelEvaluacion.equals("E")){
%>
										<!-- CALCULA EL PROMEDIO LAS MATERIAS QUE TIENEN MATERIAS DERIVADAS --> 
										<button class="btn btn-info" onclick="javaScript:evaluarDerivadas(<%=promedio.getPromedioId() %>,<%=eval.getEvaluacionId()%> )">
											Promediar derivadas
										</button>			
<%	
									}	
%>		
								<%}else{%>
		 							<%=eval.getEvaluacionNombre() %>
		 						<%}%>
		 					<%}%>
<%		
							if (planCurso.getAspectos().equals("S")){
								if (nivelEvaluacion.equals("E")){
%>		
							<a class="btn btn-mobile btn-success btn-mini" href="evaluarActitudes.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&PromedioId=<%=eval.getPromedioId()%>&EvaluacionId=<%=eval.getEvaluacionId()%>">
								<i class="icon-star icon-white"></i>
							</a>
<%		 	
								}
							}	
%>		 					
						</td>
						<td class="text-center"><%=eval.getFecha()%></td>
						<td class="text-center"><%=eval.getValor()%>%</td>
						<td class="text-center"><%=aca.ciclo.CicloBloque.getDecimales(conElias, cicloId, eval.getEvaluacionId())%></td>
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
				<%	} %>	
			<%}%>
	</table>
<%	} %>	
<!--  -------------------- SECCION DE CONDUCTA Y FALTAS -------------------- -->	
	<div class="well text-center" style="overflow:visible;">
		<a class="btn btn-primary btn-mobile" href="#" id="btnExamenes">Exámenes</a> 
	<%
		if (planCurso.getFalta().equals("S")) {
			
			if (nivelEvaluacion.equals("E")){
	%>
			<a class="btn btn-mobile" href="evaluarFaltas.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
				<fmt:message key="maestros.RegistrodeAsistencia" />
			</a> 
	<%
			}else if (nivelEvaluacion.equals("P")){
	%>
				<a class="btn btn-mobile" href="evaluarFaltasProm.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
					<fmt:message key="maestros.RegistrodeAsistencia" />
				</a>
	<%			
			}
		}
	
	  	if (planCurso.getConducta().equals("S")){
	  		
	  		if (nivelEvaluacion.equals("E")){	  	
	%> 
			<a class="btn btn-mobile" href="evaluarConducta.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
				<fmt:message key="boton.EvaluarConducta" />
			</a> 
	<%
	  		}else if (nivelEvaluacion.equals("P")){
	%>
			<a class="btn btn-mobile" href="evaluarConductaProm.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
				<fmt:message key="boton.EvaluarConducta" />
			</a>
	<%	  			
	  		}
	  	}	
		
	  	if (escuelaId.contains("H")){
	  		
	  		if (nivelEvaluacion.equals("E")){	  		
	 %> 
	  		<a class="btn btn-mobile" href="evaluarActitudes.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
	  			Evaluar Aptitudes
	  		</a> 
	  <%
	  		}else if (nivelEvaluacion.equals("P")){
	  %>		
	  		<a class="btn btn-mobile" href="evaluarActitudesProm.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>">
	  			Evaluar Aptitudes
	  		</a>
	  <%		 	
	  		}
	  	}
	
		if (planCurso.getConducta().equals("P")) {
			
			if (nivelEvaluacion.equals("E")){
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
			}else if (nivelEvaluacion.equals("P")){
%>
			<div class="btn-group text-left btn-mobile">
            	<button style="width:100%;" class="btn dropdown-toggle" data-toggle="dropdown"><fmt:message key="aca.PromediarConducta" /> <span class="caret"></span></button>
                <ul class="dropdown-menu">
<%				cont = 0;				
				for (aca.ciclo.CicloPromedio prom : lisPromedio){
					cont++;
%>
					<li><a href="javascript:promediarConductaProm('<%=prom.getPromedioId()%>')"><%=prom.getNombre() %></a></li>	
<%				}%>
		   		</ul>
           	</div>
           	<div class="btn-group text-left btn-mobile">
            	<button style="width:100%;" class="btn dropdown-toggle" data-toggle="dropdown"><fmt:message key="aca.ReporteConducta" /> <span class="caret"></span></button>
                <ul class="dropdown-menu">
                <%
			  		for (aca.ciclo.CicloPromedio prom : lisPromedio) {
			  	%> 
					<li><a href="conductaProm.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>&PromedioId=<%=prom.getPromedioId()%>"><%=prom.getNombre()%></a></li>
				<%
					}
				%>
                </ul>
           	</div>
<%				
			}
		}
	%>
	</div>
	
<!--  -------------------- TABLA DE ALUMNOS -------------------- -->
	
	<form action="evaluar.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId %>" name="forma" method="post">
		<input type="hidden" name="Derivadas" />
		<input type="hidden" name="DerivadasTrimestre" />
		<input type="hidden" name="EvalId" />
		<input type="hidden" name="Accion" />
		<input type="hidden" name="Evaluacion" />
		<input type="hidden" name="Promedio" />

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
						<%}%>
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
					/*** MUESTRA EL PRIMER EXTRAORDINARIO ***/
					if(lisTodosLosExtras.size() >= 1){
						
						// Busca el valor de la nota anterior y extraordinaria en el ciclo
						String notaAnt 		= "0";
						String notaExtra	= "0"; 	
						cicloExtra.setCicloId(cicloId);
						cicloExtra.setOportunidad("1");						
						if(cicloExtra.existeReg(conElias)){
							cicloExtra.mapeaRegId(conElias, cicloId, "1");
							notaAnt 	= cicloExtra.getValorAnterior();
							notaExtra 	= cicloExtra.getValorExtra();
						}
						if ((cicloGrupoCurso.getEstado().equals("3"))||(aca.ciclo.CicloGrupoEval.estanTodasCerradas(conElias, cicloGrupoId, cursoId))) {%>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra(<%=lisKardexAlumnosExtra.size()%>);" title="Nota=<%=notaAnt%>%, Extra=<%=notaExtra%>%" >	
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%	}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >
								<fmt:message key="aca.Extra" />
							</a>
						</th>
					<%	}
					}
					
					/*** MUESTRA EL SEGUNDO EXTRAORDINARIO ***/
					if(lisTodosLosExtras.size() >= 2){
						if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){
							// Busca el valor de la nota anterior y extraordinaria en el ciclo
							String notaAnt 		= "0";
							String notaExtra	= "0"; 	
							cicloExtra.setCicloId(cicloId);
							cicloExtra.setOportunidad("2");						
							if(cicloExtra.existeReg(conElias)){
								cicloExtra.mapeaRegId(conElias, cicloId, "2");
								notaAnt 	= cicloExtra.getValorAnterior();
								notaExtra 	= cicloExtra.getValorExtra();
							}					
					%>
						
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra2(<%=lisKardexAlumnos.size()%>);" title="Extra1=<%=notaAnt%>%, Extra2=<%=notaExtra%>%" >
								<fmt:message key="aca.Extra" />&nbsp;2
							</a>
						</th>
					<%	}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;2
							</a>
						</th>
					<%	}
					}	
					
					/*** MUESTRA EL TERCER EXTRAORDINARIO ***/
					if(lisTodosLosExtras.size() >= 3){
						if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){
							// Busca el valor de la nota anterior y extraordinaria en el ciclo
							String notaAnt 		= "0";
							String notaExtra	= "0"; 	
							cicloExtra.setCicloId(cicloId);
							cicloExtra.setOportunidad("3");						
							if(cicloExtra.existeReg(conElias)){
								cicloExtra.mapeaRegId(conElias, cicloId, "3");
								notaAnt 	= cicloExtra.getValorAnterior();
								notaExtra 	= cicloExtra.getValorExtra();
							}		
					%>					
						
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra3(<%=lisKardexAlumnos.size()%>);" title="Extra2=<%=notaAnt%>%, Extra3=<%=notaExtra%>%">
								<fmt:message key="aca.Extra" />&nbsp;3
							</a>							
						</th>
					<%	}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key='boton.EvaluarExtra'/>" >	
								<fmt:message key="aca.Extra" />&nbsp;3
							</a>
						</th>
					<%	}
					}	
					
					/*** MUESTRA EL CUARTO EXTRAORDINARIO ***/
					if(lisTodosLosExtras.size() >= 4){
						if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){
							// Busca el valor de la nota anterior y extraordinaria en el ciclo
							String notaAnt 		= "0";
							String notaExtra	= "0"; 	
							cicloExtra.setCicloId(cicloId);
							cicloExtra.setOportunidad("4");						
							if(cicloExtra.existeReg(conElias)){
								cicloExtra.mapeaRegId(conElias, cicloId, "4");
								notaAnt 	= cicloExtra.getValorAnterior();
								notaExtra 	= cicloExtra.getValorExtra();
							}						
					%>
												
					<th class="text-center" style="width:4%;">
						<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra4(<%=lisKardexAlumnos.size()%>);" title="Extra3=<%=notaAnt%>%, Extra4=<%=notaExtra%>%" >
							<fmt:message key="aca.Extra" />&nbsp;4
						</a>
					</th>
					<%	}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;4
							</a>
						</th>
					<%	}
					}
					
					/*** MUESTRA EL QUINTO EXTRAORDINARIO ***/
					if(lisTodosLosExtras.size() >= 5){						
					
						if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ 
							// Busca el valor de la nota anterior y extraordinaria en el ciclo
							String notaAnt 		= "0";
							String notaExtra	= "0"; 	
							cicloExtra.setCicloId(cicloId);
							cicloExtra.setOportunidad("5");						
							if(cicloExtra.existeReg(conElias)){
								cicloExtra.mapeaRegId(conElias, cicloId, "5");
								notaAnt 	= cicloExtra.getValorAnterior();
								notaExtra 	= cicloExtra.getValorExtra();
							}
					%>
					<th class="text-center" style="width:4%;">
						<a class="btn btn-mini btn-danger" href="javascript:muestraInputExtra5(<%=lisKardexAlumnos.size()%>);" title="Extra4=<%=notaAnt%>%, Extra5=<%=notaExtra%>%" >
							<fmt:message key="aca.Extra" />&nbsp;5
						</a>
					</th>
					<%	}else{ %>
						<th class="text-center" style="width:4%;">
							<a class="btn btn-mini btn-danger" title="<fmt:message key="boton.EvaluarExtra" />" >	
								<fmt:message key="aca.Extra" />&nbsp;5
							</a>
						</th>
					<%	}
					}
					%>			
					
					<%if(cicloGrupoCurso.getEstado().equals("3")||cicloGrupoCurso.getEstado().equals("4")||cicloGrupoCurso.getEstado().equals("5")){ %>
						<th class="text-center" style="width:10%;">
								P.<fmt:message key="aca.Extra" />&nbsp;
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
						//System.out.println("No encontro el promedio de:" + kardex.getCodigoId());
					}
			%>
					<tr>
						<td class="text-center"><%=i+1%></td>
						<td class="text-center"><%=kardex.getCodigoId()%></td>
						<td>
							
							<!-- --------- ALUMNO Y MENSAJES --------- -->
							<a data-toggle="modal" title="Envia Mensaje" data-id="<%= kardex.getCodigoId()  %>" data-tipomsg="P" data-informacion="<%= aca.plan.PlanCurso.getCursoNombre(conElias, cursoId) %>-<%=cicloGrupo.getGrupoNombre() %> <%=cicloGrupo.getGrupo() %>"
							class="open-MensajeBox btn btn-default btn-mini" href="#mensajeBox" >
							<i class="icon-envelope icon-black"></i></a>
<%-- 					  		<a href="mensaje.jsp?CicloGrupoId=<%=cicloGrupoId%>&CursoId=<%=cursoId%>&CodigoEmpleado=<%=codigoId%>&CodigoId=<%=kardex.getCodigoId()%>"> --%>
					  			<%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>
<!-- 					  		</a>				  		 -->
					  		<%if(kardex.getTipoCalId().equals("6")){ %>
					  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
					  		<%} %>
						</td>
						
						
							<!-- --------- RECORRE LAS EVALUACIONES --------- -->
						<%
						int evalCerradas =0;	
						
						double promedioFinal = 0;
						double sumaValor = 0;
						String muestraPromedioFinal = "";
						int eval = 0;
						BigDecimal sumEval = new BigDecimal("0", MATH_CTX);;
						for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
							
							for(aca.ciclo.CicloBloque cicloBloque : lisBloque){					
								if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){			
									String strNota = "-";
									// Nota del alumno en la evaluacion
									double notaEval = 0;
									if (treeNota.containsKey(cicloGrupoId + cursoId + cicloBloque.getBloqueId() + kardex.getCodigoId())) {
										notaEval = Double.parseDouble(treeNota.get(cicloGrupoId+cursoId+cicloBloque.getBloqueId()+kardex.getCodigoId()).getNota());
										//System.out.println("nota eval " + notaEval);
										// Formato de la evaluacion
										strNota = formato0.format(notaEval);
										if (cicloBloque.getDecimales().equals("1")) 
											strNota = formato1.format(notaEval);
										
										if(escuelaId.startsWith("S")){
											DecimalFormat dfFinal = null;
											if(cicloBloque.getDecimales().equals("1")){
												dfFinal = new DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
											}else{
												dfFinal = new DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
											}
											if(cicloBloque.getRedondeo().equals("T")){
												dfFinal.setRoundingMode(java.math.RoundingMode.DOWN);
												strNota = dfFinal.format(notaEval);
											}else{
												dfFinal.setRoundingMode(java.math.RoundingMode.HALF_UP);
												strNota = dfFinal.format(notaEval);
											}
											
										}
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
								<td class="text-center"><div><%=strNota%></div>
									<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) -->
									<%if (!kardex.getTipoCalId().equals("6") && estadoEval.equals("A") ) { /* Si el alumno no se ha dado de baja puede editar su nota */
										int decimales = Integer.parseInt(cicloBloque.getDecimales());%>
										<div class="editar<%=cicloBloque.getBloqueId() %>" style="display:none;">
											<input 
												style="margin-bottom:0;text-align:center;" 
												class="input-mini onlyNumbers" 
												data-allow-decimal="<%=evaluaConPunto.equals("S")?"si":"no" %>"
												data-max-num="<%=escala %>"
												maxlength="<%=((int)Math.log10(escala)+1!=3?2:(int)Math.log10(escala)+1)+decimales%>"
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
								} // valida el bloque
							} //End for Bloques
							
							// Obtiene el promedio del alumno en las evaluaciones (tabla Krdx_Alum_Prom)
							double promEval = 0; 
							if (mapPromAlumno.containsKey(kardex.getCodigoId()+kardex.getCursoId()+cicloPromedio.getPromedioId())){
								promEval = Double.parseDouble(mapPromAlumno.get(kardex.getCodigoId()+kardex.getCursoId()+cicloPromedio.getPromedioId()).getNota());									
							}
							
							// Suma los valores de todos los promedios en ciclo_promedio para calcular la nota final
							// Considera solamente los evaluados
							if (promEval > 0){
								sumaValor += Double.parseDouble(cicloPromedio.getValor());
							}
							
							// Puntos del promedio
							double puntosEval = (promEval * Double.parseDouble(cicloPromedio.getValor())) / escalaEval;
							
							// Formato del promedio y los puntos (decimales usados)
							if(cicloPromedio.getRedondeo().equals("T"))
								formato1.setRoundingMode(java.math.RoundingMode.DOWN);
							else
								formato1.setRoundingMode(java.math.RoundingMode.HALF_UP);
							String promFormato		= formato1.format(promEval);
							String puntosFormato	= formato1.format(puntosEval);
							
							if (cicloPromedio.getDecimales().equals("0")){
								if(cicloPromedio.getRedondeo().equals("T"))
									formato0.setRoundingMode(java.math.RoundingMode.DOWN);
								else
									formato0.setRoundingMode(java.math.RoundingMode.HALF_UP);
								promFormato 		= formato0.format(promEval);
								puntosFormato 		= formato0.format(puntosEval);
							}else if (cicloPromedio.getDecimales().equals("2")){
								if(cicloPromedio.getRedondeo().equals("T"))
									formato2.setRoundingMode(java.math.RoundingMode.DOWN);
								else
									formato2.setRoundingMode(java.math.RoundingMode.HALF_UP);
								promFormato 		= formato2.format(promEval);
								puntosFormato 		= formato2.format(puntosEval);
							}
							sumEval = sumEval.add(new BigDecimal(promFormato, MATH_CTX), MATH_CTX);
							
							//puntosFormato = Double.toString((Double.parseDouble(puntosFormato) * 5)/Double.parseDouble(valor));
							// Inserta columna del promedio de las evaluaciones
							out.print("<td class='text-center' width='2%'  >"+promFormato+"</td>");
							
							// Inserta columna de los puntos
							out.print("<td class='text-center' width='2%'  >"+puntosFormato+"</td>");
							//System.out.println("prom "+ promedioFinal + " c " + puntosFormato );
							promedioFinal = promedioFinal + Double.parseDouble(puntosFormato);
							eval++;
							
						}//End for de promedio
						
						if (lisPromedio.size() > 1){
							//System.out.println("promedio final "+ promedioFinal + " " + sumaValor );
							double puntosEscala = 0;
							if (escalaEval == 5){
								//promedioFinal = (promedioFinal * 5)/sumaValor;
								promedioFinal = sumEval.divide(new BigDecimal(lisPromedio.size()+"", MATH_CTX), MATH_CTX).doubleValue();
								// HAQUE QUE SACAR ESTE VALOR DE LA BASE DE DATOS EN LUGAR DE ESTA MEXICANADA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
								if(promedioFinal < 1d){
									promedioFinal = 1d;
								}
							}else if (escalaEval == 10){
								promedioFinal = (promedioFinal * 10)/sumaValor;
								
							}
							if(escuelaId.substring(0, 1).equals("H"))
								muestraPromedioFinal = formato4.format(promedioFinal);
							else if(escuelaId.startsWith("S")){
								DecimalFormat dfFinal = null;
								if(ciclo.getDecimales().equals("1")){
									dfFinal = new DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));	
								}else{
									dfFinal = new DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
								}
								
								if(ciclo.getRedondeo().equals("T")){
									dfFinal.setRoundingMode(java.math.RoundingMode.DOWN);	
								}else{
									dfFinal.setRoundingMode(java.math.RoundingMode.HALF_UP);
								}
								
								muestraPromedioFinal = dfFinal.format(promedioFinal);
								
							}else{
								muestraPromedioFinal = formato1.format(promedioFinal);
							}
							
						
							//muestraPromedioFinal = Double.toString(Double.parseDouble(muestraPromedioFinal)/eval);
							out.print("<td class='text-center' width='2%'>"+muestraPromedioFinal+"</td>");						
						}
						
						String strExtra = "-";
						String strExtra2 = "-";
						String strExtra3 = "-";
						String strExtra4 = "-";
						String strExtra5 = "-";
						String promedioFinalExtra = "";

						float numExtra 	= 0;

						/*** HABILITAR PRIMER EXTRADORDINARIO ***/
						if(lisTodosLosExtras.size() >= 1){						
							
							strExtra = "-";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("1");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "1");
									strExtra 			= kardexAlumnoExtra.getNotaExtra();
									promedioFinalExtra 	= kardexAlumnoExtra.getPromedio();
 								} else {
 									strExtra = "-";
 								}																							
								
							}							
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
<%
								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("2");
//Esta variable "promedioFinal" era antes "promedio" y se cambió porque
//la variable promedio tiene mal el cálculo porque a la hora de cerrar la evaluación
//no se pusieron en 0 las notas que no tenían nada ingresado. Así que hay que corregir
//el algoritmo de cerrar la evaluación
								if(promedio < notaAC && !kardexAlumnoExtra.existeReg(conElias)){
									muestraBotonGuardarExtra = true;
									
									if ( !strExtra.equals("") ){%>
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
								<%}%>
							</td>
							<%
						}
						
						/*** HABILITAR SEGUNDO EXTRADORDINARIO ***/
						if(lisTodosLosExtras.size() >= 2){											
							
								strExtra2 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra2.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("2");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "2");
										strExtra2 			= kardexAlumnoExtra.getNotaExtra();
										promedioFinalExtra 	= kardexAlumnoExtra.getPromedio();
	 								} else {
	 									strExtra2 = "-";
	 								}																							
									
								}
							%>
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra2 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 2 (ESCONDIDO POR DEFAULT) -->
<%
								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
								kardexAlumnoExtra.setCursoId(cursoId);
								kardexAlumnoExtra.setOportunidad("3");
								
								 if(promedio < notaAC && !kardexAlumnoExtra.existeReg(conElias)){
									muestraBotonGuardarExtra2 = true;
			
									 if ( !strExtra2.equals("") ) {%>
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
								<%}%>
								</td>
							<%
						}
						
						/*** HABILITAR TERCER EXTRADORDINARIO ***/
						if(lisTodosLosExtras.size() >= 3){								
							
								strExtra3 = "-";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra3.equals("")) {	

	 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
	 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
	 								kardexAlumnoExtra.setCursoId(cursoId);
	 								kardexAlumnoExtra.setOportunidad("3");

									if (kardexAlumnoExtra.existeReg(conElias)) {
										kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "3");
										strExtra3 = kardexAlumnoExtra.getNotaExtra();
										promedioFinalExtra 	= kardexAlumnoExtra.getPromedio();
	 								} else {
	 									strExtra3 = "-";
	 								}																							
									
								}
							%>
							
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra3 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO 3 (ESCONDIDO POR DEFAULT) -->
<%
								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
								kardexAlumnoExtra.setCursoId(cursoId);
								kardexAlumnoExtra.setOportunidad("4");
								
								 if(promedio < notaAC && !kardexAlumnoExtra.existeReg(conElias)){
									muestraBotonGuardarExtra3 = true;
									
									if ( !strExtra3.equals("") ) {%>
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
								<%}%>
								</td>	
						<%
						}
						
						/*** HABILITAR CUARTO EXTRADORDINARIO ***/
						if(lisTodosLosExtras.size() >= 4){					
						
							strExtra4 = "-";
							
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra4.equals("")) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("4");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "4");
									strExtra4 = kardexAlumnoExtra.getNotaExtra();
									promedioFinalExtra 	= kardexAlumnoExtra.getPromedio();
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
						}
						
						/*** HABILITAR QUINTO EXTRADORDINARIO ***/
						if(lisTodosLosExtras.size() >= 5){			
						
							strExtra5 = "-";
							
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra5.equals("")) {	

 								kardexAlumnoExtra.setCicloGrupoId(cicloGrupoId);
 								kardexAlumnoExtra.setCodigoId(kardex.getCodigoId());
 								kardexAlumnoExtra.setCursoId(cursoId);
 								kardexAlumnoExtra.setOportunidad("5");

								if (kardexAlumnoExtra.existeReg(conElias)) {
									kardexAlumnoExtra.mapeaRegId(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId, "5");
									strExtra5 = kardexAlumnoExtra.getNotaExtra();
									promedioFinalExtra 	= kardexAlumnoExtra.getPromedio();
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
						}
%>			
						<!-- --------- PROMEDIO DEL EXTRA ACTUAL MAS PROMEDIO --------- -->
<%
							boolean tieneExtra = aca.kardex.KrdxAlumExtra.tieneExtras(conElias, kardex.getCodigoId(), cicloGrupoId, cursoId);										 
						
							// Si esta en estado de evaluar extraordinarios y tiene notas en extra
							if(cicloGrupoCurso.getEstado().equals("3")||cicloGrupoCurso.getEstado().equals("4")||cicloGrupoCurso.getEstado().equals("5")){
								if (tieneExtra){				
%>
							<td class="text-center">
								<div><%=promedioFinalExtra %></div>
							</td>
<%								
								}else{
%>
							<td class="text-center">
								<div>-</div>
							</td>
<%								
								}
							}	
%>					</tr>
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
					for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
						
						for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
										
							if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){					
%>
							<td class="text-center">
								<div class="editar<%=cicloBloque.getBloqueId() %>" style="display:none;">
									<a tabindex="<%=lisKardexAlumnos.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarCalificaciones( '<%=cicloBloque.getBloqueId()%>' );"><fmt:message key="boton.Guardar" /></a> 
									<a tabindex="<%=lisKardexAlumnos.size()+1 %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarCalificaciones( '<%=cicloBloque.getBloqueId()%>' );"><fmt:message key="boton.Eliminar" /></a>
								</div>
							</td>
<%
							}
						}
						out.print("<td>&nbsp;</td>");
						out.print("<td>&nbsp;</td>");
					}	
%>					
					<%
					if(lisTodosLosExtras.size() >= 1 && muestraBotonGuardarExtra){
					%>
					<td>&nbsp;</td>
					<!-- BOTON DE NOTA EXTRA -->
					<td class="text-center">
						<div class="editarExtra" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra();"><fmt:message key="boton.Guardar" /></a> 	
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarExtra();"><fmt:message key="boton.Eliminar" /></a>
						</div>
					</td>
					<%
					}else{
						out.print("<td>&nbsp;</td>");
						out.print("<td>&nbsp;</td>");
					}
					
					if(lisTodosLosExtras.size() >= 2 && muestraBotonGuardarExtra2){
					%>
					<!-- BOTON DE NOTA EXTRA 2 -->
					<td class="text-center">
						<div class="editarExtra2" style="display:none;">
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra2();"><fmt:message key="boton.Guardar" /></a> 
							<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarExtra2();"><fmt:message key="boton.Eliminar" /></a>
						</div>
					</td>
					<%
					}else{
						out.print("<td>&nbsp;</td>");
						out.print("<td>&nbsp;</td>");
					}
					
					if(lisTodosLosExtras.size() >= 3 && muestraBotonGuardarExtra3){
					%>	
					
					<!-- BOTON DE NOTA EXTRA 3 -->
						<td class="text-center">
							<div class="editarExtra3" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra3();"><fmt:message key="boton.Guardar" /></a> 
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarExtra3();"><fmt:message key="boton.Eliminar" /></a>
							</div>
						</td>
					<%
					}
					
					if(lisTodosLosExtras.size() >= 4 && muestraBotonGuardarExtra4){
					%>	
					<!-- BOTON DE NOTA EXTRA 4 -->
						<td class="text-center">
							<div class="editarExtra4" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra4();"><fmt:message key="boton.Guardar" /></a> 
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarExtra4();"><fmt:message key="boton.Eliminar" /></a>
							</div>
						</td>
					<%
					}
					
					if(lisTodosLosExtras.size() >= 5 && muestraBotonGuardarExtra5){
					%>
					<!-- BOTON DE NOTA EXTRA 5 -->
						<td class="text-center">
							<div class="editarExtra5" style="display:none;">
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-primary btn-block" type="button" href="javascript:guardarExtra5();"><fmt:message key="boton.Guardar" /></a> 
								<a tabindex="<%=lisKardexAlumnosExtra.size() %>" class="btn btn-danger btn-block" type="button" href="javascript:borrarExtra5();"><fmt:message key="boton.Eliminar" /></a>
							</div>
						</td>						
					<%	
					} 
					%>				
				</tr>
		</table>
	</form>
<!-- MODAL -->
		<div id="mensajeBox" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		    <h3 id="myModalLabel"><fmt:message key="boton.EscribirMensaje" /></h3>
		  </div>
		  <div class="modal-body ">
		  <form id="formSendMsg" method="post">
		  		<label for="asunto">Asunto</label>
		  		<input type="text" name="asunto" id="asunto">
		        <textarea name="Comentario"  class="boxsizingBorder" id="Comentario" style="width:100%;height:80px;margin:0;" placeholder="Escribe tu Mensaje Aqui"></textarea>
		        <input type="hidden" id="destino" value="">
		        <input type="hidden" id="complemento" value="">
		        <input type="hidden" id="tipo_destino" value="">
		        <input type="hidden" id="envia" value="<%= codigoId %>">
		        <input type="hidden" id="envia_mensaje" name="envia_mensaje" value="true">	
				<input type="file" name="adjunto" id="adjunto">
		   </form>
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
		    <a class="btn btn-primary" href="javascript:enviaMsg()"><i class="icon-envelope icon-white"></i> <fmt:message key="boton.EnviarMensaje" /></a>
		  </div>
		</div>
	<!-- END MODAL -->
		<!-- nuevo modal -->

<div class="modal fade" id="enviadoMsg" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Aviso</h4>
        </div>
        <div class="modal-body">
          <p>Su mensaje fue enviado correctamente.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>

<!-- end nuevo modal -->	
</div>
<form action="/exam/test/maestro/listado_eval" target="_blank" name="formExams" method="POST">
	<input type="hidden" value="-1" name="actividadId"/>
	<input type="hidden" value="<%=cursoId %>" name="cursoId"/>
	<input type="hidden" value="<%=cicloGrupoId %>" name="cicloGpoId"/>
</form>
<script type="text/javascript">

document.addEventListener("DOMContentLoaded", function(){
	document.getElementById('btnExamenes').addEventListener('click', goExams);
});

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

function enviaMsg(){
	
	var datadata = 'envia_mensaje=true&envia='+$('#envia').val()
	+'&tipo_destino='+$('#tipo_destino').val()+'&destino='+$('#destino').val()
	+'&asunto='+$('#asunto').val()+' '+$('#complemento').val()+'&mensaje='
	+$('#Comentario').val();
	$.ajax({
		url : '../../mensajes/accionMensajes.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			var idmsg = parseInt(output);
			if ($('#formSendMsg #adjunto').get(0).files.length === 0) {
				console.log(output + ' no tiene adjunto ' + idmsg );
			}else{
				console.log(output + ' tiene adjunto ' + idmsg );
				if(idmsg>=0)
					enviaMsgNFile(idmsg);
			}
		
			$('#mensajeBox').modal('toggle');
			$('#enviadoMsg').modal('show'); 
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});

}
		
		function enviaMsgNFile(idmsg) {
			
			var formData = new FormData(document.getElementById("formSendMsg"));
		    formData.append("dato", "valor");
		    formData.append("idmsg", idmsg);
		    //formData.append(f.attr("name"), $(this)[0].files[0]);
		    $.ajax({
		        url: "../../mensajes/uploadFile.jsp",
		        type: "post",
		        dataType: false,
		        data: formData,
		        cache: false,
		        contentType: false,
		 		processData: false
		    })
		        .done(function(res){
		            $("#mensaje").html("Respuesta: " + res);
		        });
		
		}
<!--
$(document).on("click", ".open-MensajeBox", function () {
    var destinatario = $(this).data('id');
    var complemento = $(this).data('informacion');
    var tipo_destino = $(this).data('tipomsg');
    
    $(".modal-body #destino").val( destinatario );
    $(".modal-body #complemento").val( complemento );
    $(".modal-body #tipo_destino").val( tipo_destino );
    // As pointed out in comments, 
    // it is superfluous to have to manually call the modal.
    // $('#addBookDialog').modal('show');
});

$(function(){
	var suma = 0;
	var codigoid = '<%= codigoId %>'
	var escuela = '<%=  (String) session.getAttribute("escuela") %>';
	var tipodestino = '\'P\',\'A\',\'G\'';
	var datadataA = 'cuenta_msgs=true&destino=\''+codigoid+'\',\''+escuela+'\'&tipodestino='+tipodestino;
	console.log(datadataA);
	$.ajax({
		url : '../../mensajes/accionMensajes.jsp',
		type : 'post',
		data : datadataA,
		success : function(output) {
			suma += $.isNumeric(output) ? parseInt(output) : 0;
			if(suma>0){
				$('#countMsg').html('<div class="pull-right"><a href="mensaje.jsp" class="btn btn-warning btn-mini">'+ suma + ' Mensajes Nuevos</a></div>');
			}else{
				$('#countMsg').html('<div class="pull-right"><a href="mensaje.jsp" class="btn btn-warning  btn-mini">Revisar Mensajes</a></div>');
			}
			
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});
});
	
	
//-->
</script>
<%@ include file="../../cierra_elias.jsp"%>