<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoActividad"%>
<%@page import="java.math.MathContext"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Map"%>

<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumCiclo" scope="page" class="aca.alumno.AlumCiclo"/>
<jsp:useBean id="AlumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="CicloGrupoNuevo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="CicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupoEvaluacion" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<jsp:useBean id="cicloGrupoActividad" scope="page" class="aca.ciclo.CicloGrupoActividad"/>
<jsp:useBean id="Curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="KardexCurso" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="KardexAlumActiv" scope="page" class="aca.kardex.KrdxAlumActiv"/>
<jsp:useBean id="KardexAlumEval" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="KardexFalta" scope="page" class="aca.kardex.KrdxAlumFalta"/>
<jsp:useBean id="KardexConducta" scope="page" class="aca.kardex.KrdxAlumConducta"/>

<!-- LISTAS -->
<jsp:useBean id="KardexCursoEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="KardexCursoActivLista" scope="page" class="aca.kardex.KrdxAlumActivLista"/>
<jsp:useBean id="KardexCursoLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="GrupoCursoL" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="CatGrupoL" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="PromedioLista" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="BloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>

<script>
	function confirmarCambio(){
		if(confirm("¿Estás seguro?")){
			document.frmCambio.Accion.value = "3";
			document.frmCambio.TipoTraspaso.value = "-1";
			document.frmCambio.submit();
		}
	}

	function cancelarCambio(){
		document.frmCambio.Accion.value = "";
		document.frmCambio.TipoTraspaso.value = "0";
		document.frmCambio.submit();	
	}
	
	function cambiarGrupo(){
		if(confirm("¿Estás seguro de cambiar de grupo al alumno?")){
			document.frmCambio.Accion.value = "3";
			document.frmCambio.TipoTraspaso.value = "0";
			document.frmCambio.submit();	
		}
	}
</script>

<%
	
	String escuelaId 				= (String) session.getAttribute("escuela");
	String cicloId 					= (String) session.getAttribute("cicloId");
	String periodoId				= aca.ciclo.CicloPeriodo.periodoActual(conElias, cicloId);
	if(periodoId.equals("0")){	periodoId="1"; }
	String nivelEvaluacion 			= aca.ciclo.Ciclo.getNivelEval(conElias, cicloId);
	
	String codigoAlumno				= (String) session.getAttribute("codigoAlumno");
	String planAlumno				= aca.alumno.AlumPlan.getPlanActual(conElias,codigoAlumno);
	String nivelAlumno				= String.valueOf(aca.alumno.AlumPlan.getNivelAlumno(conElias,codigoAlumno));
	
	String accion 					= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj  					= "";
	boolean error					= false;
	int tipoTraspaso				= request.getParameter("TipoTraspaso")==null?0:Integer.parseInt(request.getParameter("TipoTraspaso"));
	
	Map<Integer, String> msjCambio 	= new HashMap<Integer, String>();
	msjCambio.put(0, "No relizará ningun cambio. Materia sin calificaciones.");
	msjCambio.put(1, "No relizará ningun cambio. Las calificaciones se traspasarán sin problemas.");
	msjCambio.put(2, "Las actividades calificadas del alumno se borrarán y se pasará únicamente la calificacion de la evaluación.");
	msjCambio.put(3, "Se creará una actividad nueva en el grupo de destino con el valor del promedio de la evaluación en el grupo de origen.");
	msjCambio.put(4, "Se creará una actividad nueva en el grupo de destino con el valor del promedio de las actividades en el grupo de origen.");
	msjCambio.put(5, "Se dará de Baja. Materia en Grupo Origen no está en Grupo Destino.");
	msjCambio.put(6, "No se inscribirá. Materia en Grupo Destino no está en Grupo Origen.");
	msjCambio.put(7, "No se puede traspasar a un grupo con actividades mientras que el periodo está abierto");
	boolean TodoSalioBien			= false;
	
	Alumno.mapeaRegId(conElias, codigoAlumno); 							// Datos personales alumno
	AlumCiclo.mapeaRegId(conElias, codigoAlumno, cicloId, periodoId); 	// Datos de la inscripción del alumno
	AlumPlan.mapeaRegId(conElias, codigoAlumno, planAlumno);			// Datos del plan en el que está el alumno
	
	// Se obtiene el cicloGrupoId para mapear el CicloGrupo
	String	cicloGrupoIdActual 	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias,nivelAlumno,Alumno.getGrado(),Alumno.getGrupo(),cicloId,planAlumno);
	String  cicloGrupoIdNuevo	= request.getParameter("cicloGrupoIdNuevo")==null?"":request.getParameter("cicloGrupoIdNuevo").trim();
	
	CicloGrupo.mapeaRegId(conElias, cicloGrupoIdActual); 						// Datos del grupo de origen en el ciclo
	CicloGrupoNuevo.mapeaRegId(conElias, cicloGrupoIdNuevo); 					// Datos del grupo de destino en el ciclo

	//Datos antiguos
	String gradoAnterior	= Alumno.getGrado();
	String grupoAnterior	= Alumno.getGrupo();
	String maestroAnterior	= aca.empleado.EmpPersonal.getNombre(conElias, CicloGrupo.getMaestroBase(conElias, nivelAlumno, Alumno.getGrado(), Alumno.getGrupo(), cicloId), "NOMBRE");
	
	// Variables para el traspaso por actividad
	MathContext MATH_CTX  = new MathContext(12,RoundingMode.HALF_UP);
	BigDecimal notaMinima = BigDecimal.ZERO;
	notaMinima = notaMinima.add(new BigDecimal(aca.catalogo.CatNivelEscuela.getNotaMinima(conElias, nivelAlumno, escuelaId ),MATH_CTX),MATH_CTX); 
	int escala 			  = 0;
	int escalaCiclo				= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */	
	
	// En Panama respetamos la configuracion del sistema, en México y Dominicana evaluacion de 0-100 pero promediamos en 10
	if (!escuelaId.substring(0,1).equals("H")) 
		escala = 100;
	else
		escala = escalaCiclo;
	
	//Listado de los grupos del nivel del alumno. Es para desplegar las opciones de grupos.
	ArrayList<aca.catalogo.CatGrupo> lisGrupoAlta		= CatGrupoL.getListGruposAlta(conElias, cicloId, planAlumno, escuelaId, nivelAlumno, "ORDER BY NIVEL_ID, GRADO, GRUPO");
	
	// Crea un listado de los cursos que tiene cargado el alumno
	ArrayList<aca.kardex.KrdxCursoAct> listKrdxCursoAct = KardexCursoLista.getLisCursosAlumno(conElias, codigoAlumno, cicloGrupoIdActual, "ORDER BY CURSO_ID");

	// HashMap que tendrá las materias con problemas o modificaciones para mostrarlo en la tabla.
	Map<String, TreeMap<String, Integer>> listMateriasTraspaso = new HashMap<String, TreeMap<String, Integer>>();
	
/*************************** ACCIONES ****************************/
// -------- BORRAR NOTAS ----------->
	if(accion.equals("1")){
		KardexCurso.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, request.getParameter("Curso"));
		boolean tieneEval	= aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoAlumno, cicloGrupoIdActual, KardexCurso.getCursoId());
		boolean tieneActiv  = aca.kardex.KrdxCursoAct.getMatAlumTieneActiv(conElias, codigoAlumno, cicloGrupoIdActual, KardexCurso.getCursoId());
		
		conElias.setAutoCommit(false);
		
		if (KardexCurso.existeReg(conElias) ){			
			if (tieneActiv){
				if (aca.kardex.KrdxAlumActiv.deleteRegMateria(conElias, codigoAlumno, cicloGrupoIdActual, KardexCurso.getCursoId()))
					tieneActiv = false;
			}
			
			if (tieneEval && !tieneActiv){
				if (aca.kardex.KrdxAlumEval.deleteRegMateria(conElias, codigoAlumno, cicloGrupoIdActual, KardexCurso.getCursoId()))
					tieneEval = false;
			}
			
			if (!tieneActiv && !tieneEval){
				conElias.commit();					 
				msj = "EvaluacionesBorradas";
			}else{
				msj = "ImposibleBorrarEval";					
			}
		}
		
		conElias.setAutoCommit(true);
		
		//Cada vez que borre las calificaciones intentará traspasar al alumno 
		accion = "3";
	}

// Dejé libre la acción número dos por si fuere necesario agregar alguna otra de menor precedencia que el traspaso.

// -------- CAMBIAR GRUPO ----------->
	if(accion.equals("3")){
		
		if(cicloGrupoIdNuevo.equals("")){
			error = true;
		}
		
		// Si cargó bien el id del ciclo actual más al que se trapasará
		if(!error){
			// Crea un listado de los cursos que tiene el grupo destino
			ArrayList<aca.ciclo.CicloGrupoCurso> listCursosNuevos = GrupoCursoL.getListMateriasGrupo(conElias, cicloGrupoIdNuevo, "ORDER BY CURSO_ID");
			// Se crea una nueva lista de los id de los cursos para hacer les el contains
			ArrayList<String> listIdCursos = new ArrayList<String>();
			// Se rellena el listado de los Ids
			for(aca.kardex.KrdxCursoAct krdxCurso: listKrdxCursoAct){
				listIdCursos.add(krdxCurso.getCursoId());
			}
			// Se hace el chequeo de las materias en origen y destino
			for(aca.ciclo.CicloGrupoCurso cicloGrupo: listCursosNuevos){
				if(!listIdCursos.contains(cicloGrupo.getCursoId())){
					// Si la lista de Ids no lo contiene, es una materia que está en el destino y no el origen (6).
					tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<6?6:tipoTraspaso):tipoTraspaso;
					listMateriasTraspaso.put(cicloGrupo.getCursoId(), new TreeMap<String, Integer>()
						{{
							this.put("0", 6);
						}}
					);
				}
			}
			
			// El traspaso se realizará materia por materia detrno de un ciclo for
			for(aca.kardex.KrdxCursoAct curso: listKrdxCursoAct){
				//Se mapea con los datos del Grupo nuevo para ese curso en ese ciclo
				CicloGrupoCurso.mapeaRegId(conElias, cicloGrupoIdNuevo, curso.getCursoId());
				//Checa que exista esa materia en el Grupo nuevo 
				if(CicloGrupoCurso.getCursoId().equals(curso.getCursoId())){
					// Crea listado de evaluaciones
					ArrayList<aca.kardex.KrdxAlumEval> listCursoEval = KardexCursoEvalLista.getListAlumMat(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), "ORDER BY EVALUACION_ID");
					// Checa si la materia tiene promedios
					if(aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId())){
						// Checa cada evaluación a ver cual esta calificada
						Map<String, Integer> dicTempEval = new HashMap<String, Integer>();
						for(aca.kardex.KrdxAlumEval eval: listCursoEval){
							// Checa si la evaluación tiene calificaciones
							if(!eval.getNotaEval(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), Integer.parseInt(eval.getEvaluacionId())).equals("-")){
								// Checa si la evaluación tiene actividades
								if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdActual, curso.getCursoId(), eval.getEvaluacionId())){
									// Checa si la evaluación del otro grupo tiene actividades
									if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdNuevo, curso.getCursoId(), eval.getEvaluacionId())){
										// Obtiene el estado de la evaluación
										String estadoEval = cicloGrupoEvaluacion.getEstado(conElias, cicloGrupoIdNuevo, curso.getCursoId(), Integer.parseInt(eval.getEvaluacionId()));
										// Checa que esté cerrada
										if(estadoEval.equals("C")){
											// Si está cerrada le asigna el tipo de traspaso
											tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<4?4:tipoTraspaso):tipoTraspaso;
											dicTempEval.put(eval.getEvaluacionId(), 4);
										}else{
											// Si no está cerrada no se puede realizar el traspaso
											tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<7?7:tipoTraspaso):tipoTraspaso;
											dicTempEval.put(eval.getEvaluacionId(), 7);
										}
									}else{
										// No Importa. Se traspasa y se borran las calificaciones de las actividades
										tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<2?2:tipoTraspaso):tipoTraspaso;
										dicTempEval.put(eval.getEvaluacionId(), 2);
									}
								}else{
									// Checa si la evaluación del otro grupo tiene actividades
									if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdNuevo, curso.getCursoId(), eval.getEvaluacionId())){
										// Obtiene el estado de la evaluación
										String estadoEval = cicloGrupoEvaluacion.getEstado(conElias, cicloGrupoIdNuevo, curso.getCursoId(), Integer.parseInt(eval.getEvaluacionId()));
										// Checa que esté cerrada
										if(estadoEval.equals("C")){
											// Si está cerrada le asigna el tipo de traspaso
											tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<3?3:tipoTraspaso):tipoTraspaso;
											dicTempEval.put(eval.getEvaluacionId(), 3);
										}else{
											// Si no está cerrada no se puede realizar el traspaso
											tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<7?7:tipoTraspaso):tipoTraspaso;
											dicTempEval.put(eval.getEvaluacionId(), 7);
										}
									}else{
										// No Importa (Se traspasa sin problema)
										tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<1?1:tipoTraspaso):tipoTraspaso;
										dicTempEval.put(eval.getEvaluacionId(), 1);
									}
								}
							}
						}//finaliza for de evaluaciones
						listMateriasTraspaso.put(curso.getCursoId(), new TreeMap<String, Integer>(dicTempEval));
					}else{
						// Si la materia no tiene calificaciones
						tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<0?0:tipoTraspaso):tipoTraspaso;
						listMateriasTraspaso.put(curso.getCursoId(), new TreeMap<String, Integer>()
							{{
								this.put("0", 0);
							}}
						);
					}
				}else{
					//Si la materia no se encuentra en el nuevo grupo
					tipoTraspaso = tipoTraspaso!=-1?(tipoTraspaso<5?5:tipoTraspaso):tipoTraspaso;
					listMateriasTraspaso.put(curso.getCursoId(), new TreeMap<String, Integer>()
						{{
							this.put("0", 5);
						}}
					);
				}
			}//finaliza for de curso
		}//finaliza si es que no hubo error en CicloGrupoId
		
		/*
		 *
		 * Aquí va el traspaso por materia:
		 *  Tipos de traspaso (int):
		 *	 	 0 => Curso sin Calificación.
		 *		 1 => De Evaluación a Evaluación
		 *		 2 => De Actividad a Evaluación
		 *		 3 => De Evaluación a Actividad
		 *		 4 => De Actividad a Actividad
		 *		 5 => Materia en Grupo Origen no está en Grupo Destino
		 *		 6 => Materia en Grupo Destino no está en Grupo Origen
		 * 		 7 => La materia tiene actividades en el Grupo Destino en evaluaciones sin cerrar.
		 *
		 */
		
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		error 			= false;
		 
		// Primero se deben de confirmar los cambios a menos de que no requiera cambios
		if(tipoTraspaso < 2){
		 
			// El traspaso se realiza por cada materia en listMateriaTraspaso
			for(Map.Entry<String, TreeMap<String, Integer>> materia: listMateriasTraspaso.entrySet()){
				aca.kardex.KrdxCursoAct curso = new aca.kardex.KrdxCursoAct();
				
				TreeMap<String, Integer> listTiposEval = materia.getValue();
				// Este tipo se usa para saber si el tipo de traspaso es por materia (!-1) o por evaluación (-1)
				int tipo = -1;
				try{
					// Intenta obtener el tipo de traspaso si es por materia
					// Si no tiene nada con la llave "0" es que es por evaluación
					tipo = materia.getValue().get("0");
				}catch(Exception ex){
					tipo = -1;
				}
				
				// Se obtiene el objeto Materia con la que se trabajará
				for(aca.kardex.KrdxCursoAct krdxCurso: listKrdxCursoAct){
					if(krdxCurso.getCursoId().equals(materia.getKey())){
						curso = krdxCurso;
						break;
					}
				}
				
				// Si la materia no está en el origen no realiza nada
				if(tipo==6)
					continue;

				// Si la materia no está en el destino la da de baja
				if(tipo==5){
					curso.setTipoCalId("6");
					
					if(curso.updateReg(conElias)){
						// Se actualizó correctamente el registro
					}else{
						error = true;
					}
					continue;
				}
				
				
				// El traspaso de calificaciones lo realiza por evaluación
				for(Map.Entry<String, Integer> eval: listTiposEval.entrySet()){
					// OBTENER PROMEDIO
					String evalId = eval.getKey();
					int evalTipo = eval.getValue();
					
					if(evalTipo>=1 && evalTipo<=4){
						KardexAlumEval.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), evalId);
						KardexAlumEval.setCicloGrupoId(cicloGrupoIdNuevo);
						// Checa que no exista el registro en el nuevo grupo
						if(!KardexAlumEval.existeReg(conElias)){ 
							// Inserta la evaluación en el grupo nuevo
							if(KardexAlumEval.insertReg(conElias)){ 
								KardexAlumEval.setCicloGrupoId(cicloGrupoIdActual);
								// Borra la evaluación en el grupo pasado
								if(KardexAlumEval.deleteReg(conElias)){ 
									// Todo salió bien hasta este punto
								}else{
									error = true; break;
								}
							}else{
								error = true; break;	
							}
						}
					}
					
					//BORRAR LAS ACTIVIDADES
					if(evalTipo==2 || evalTipo==4){
						//Checa si tiene actividades
						if(aca.kardex.KrdxAlumActiv.getNumActividades(conElias, cicloGrupoIdActual, curso.getCursoId(), evalId, codigoAlumno) > 0){
							//Si tiene, crea una lista de ellas
							ArrayList<aca.kardex.KrdxAlumActiv> listActiv = KardexCursoActivLista.getListEvaluacion(conElias, cicloGrupoIdActual, curso.getCursoId(), evalId, "ORDER BY ACTIVIDAD_ID");
							//Con ese método se intentan borran los registros de las actividades de ese alumno en ese grupo. Si no se borran hay error.
							System.out.println(listActiv.size()); // CONTINUAR //
							if(listActiv.get(0).deleteRegGrupo(conElias, codigoAlumno, cicloGrupoIdActual)){
								// Todo salió bien hasta aquí
							}else{
								error = true;
								break;
							}
						}
					}
					
					
					if(evalTipo==1 || evalTipo==2){
						//TRASPASAR EVALUACIÓN
					}else if(evalTipo==3 || evalTipo==4){
						// CREAR ACTIVIDAD
						//Procesamos la nota si no es Panamá
						BigDecimal calTmp = new BigDecimal(KardexAlumEval.getNota(), MATH_CTX);
						if (escuelaId.substring(0,1).equals("H")){
							// calTmp = calTmp.multiply(new BigDecimal("100", MATH_CTX).divide(new BigDecimal(escala, MATH_CTX), MATH_CTX));
							
							/* 
							 * Panamá califica del 1 - 5 tanto a nivel evaluación como a nivel de actividades.
							 * Falta checar como evaluar con diferentes tipos de evaluación. O sea, entender
							 * como es que funciona la escala del ciclo.
							 *
							 */
							 
							// Si es menor a la nota mínima se le asigna esta
							if(calTmp.compareTo(notaMinima) < 0) 
								calTmp = notaMinima;
						}else{
							calTmp = calTmp.multiply(new BigDecimal("10", MATH_CTX));
						}
						
					    cicloGrupoActividad.setCicloGrupoId(cicloGrupoIdNuevo);
						cicloGrupoActividad.setCursoId(curso.getCursoId());
						cicloGrupoActividad.setEvaluacionId(evalId);
						cicloGrupoActividad.setTipoactId("-1");	
						cicloGrupoActividad.setActividadId("-1");
						if(cicloGrupoActividad.existeReg(conElias)){
							/*
							 * Si la actividad ya fue creada antes
							 * solo se agregará la calificación a esa.
							 *
							 */
							KardexAlumActiv.setActividadId("-1");
							KardexAlumActiv.setCicloGrupoId(cicloGrupoIdNuevo);
							KardexAlumActiv.setCodigoId(codigoAlumno);
							KardexAlumActiv.setCursoId(curso.getCursoId());
							KardexAlumActiv.setEvaluacionId(evalId);
							KardexAlumActiv.setNota(calTmp.toString());
							if(KardexAlumActiv.insertReg(conElias)){
								// Se inserto la calificacion correctamente
							}else{
								error = true; break;
							}
						}else{
							/*
							 * Si la actividad ya no fue creada antes
							 * solo se agregará la calificación a esa.
							 *
							 */
							cicloGrupoActividad.setEvaluacionId(evalId);
							cicloGrupoActividad.setActividadNombre("Evaluación por traspaso");
							cicloGrupoActividad.setValor("100");
							cicloGrupoActividad.setMostrar("N");
							cicloGrupoActividad.setEtiquetaId(null);
							if(cicloGrupoActividad.insertReg(conElias)){
								// Se insertó correctamente
								KardexAlumActiv.setActividadId("-1");
								KardexAlumActiv.setCicloGrupoId(cicloGrupoIdNuevo);
								KardexAlumActiv.setCodigoId(codigoAlumno);
								KardexAlumActiv.setCursoId(curso.getCursoId());
								KardexAlumActiv.setEvaluacionId(evalId);
								KardexAlumActiv.setNota(calTmp.toString());
								if(KardexAlumActiv.insertReg(conElias)){
									// Se inserto la calificacion correctamente
								}else{
									error = true; break;
								}
							}else{
								error = true; break;
							}
						}
					}
				}//Termina for evaluacion
				
				//Se modifican los datos personales del alumno
				Alumno.setGrupo(CicloGrupoNuevo.getGrupo());
				if(!Alumno.updateReg(conElias)){
					error = true; break;
				}
				
				//Se modifican los datos del alumno en el ciclo
				AlumCiclo.setGrupo(CicloGrupoNuevo.getGrupo());
				if(!AlumCiclo.updateReg(conElias)){
					error = true; break;
				}
				
				//Se modifican los datos del alumno en el plan
				AlumPlan.setGrupo(CicloGrupoNuevo.getGrupo());
				if(!AlumPlan.updateReg(conElias)){
					error = true; break;
				}
				
				//Se modifica el enlace del alumno a la materia
				curso.setCicloGrupoId(cicloGrupoIdNuevo);
				if(!curso.existeReg(conElias)){
					if(curso.insertReg(conElias)){
						curso.setCicloGrupoId(cicloGrupoIdActual);
						if(curso.deleteReg(conElias)){
							// Actualización exitosa
						}else{
							error = true; break;
						}
					}else{
						error = true; break;	
					}
				}
			}
			 
			//COMMIT OR ROLLBACK TO DB
			if(!error){
				TodoSalioBien = true;
			}
			
			/*
			 * Es necesario traspasar las calificaciones de las faltas y la conducta. 
			 * No importa el tipo de trapaso que sea el traspaso de estos datos es de
			 * la misma manera para todas. Pero solo se debe de realizar una vez que 
			 * todas las materias se traspasaron de forma correcta. De esta manera, al
			 * saber que todo salió bien, realiza este paso y, en teoría, nada debería 
			 * de salir mal.
			 *
			 */
			 
			if(TodoSalioBien){
				
				//Lista de promedios	
				ArrayList<aca.ciclo.CicloPromedio> lisPromedio = PromedioLista.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
				
				for(aca.kardex.KrdxCursoAct curso: listKrdxCursoAct){
					Curso.mapeaRegId(conElias, curso.getCursoId());
					// Se traspasan las faltas y conducta
					if(nivelEvaluacion.equals("E")){ 				/* Si es por Evaluación */
						for(int i = 0; lisPromedio.size() > i; i++){
							ArrayList<aca.ciclo.CicloBloque> lisBloque = BloqueLista.getListCiclo(conElias, cicloId, lisPromedio.get(i).getPromedioId(), "ORDER BY BLOQUE_ID");
							for(int t = 0; lisBloque.size() > t; t++){
								//Checa si evalua asistencias
								if(Curso.getFalta().equals("S")){
									//Traspasa las faltas si tiene
									KardexFalta.setFalta("");
									KardexFalta.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), lisPromedio.get(i).getPromedioId(), lisBloque.get(t).getBloqueId());
									if(!KardexFalta.getFalta().equals("") && KardexFalta.getPromedioId().equals(lisBloque.get(t).getPromedioId())){
										KardexFalta.setCicloGrupoId(cicloGrupoIdNuevo);
										if(KardexFalta.insertReg(conElias)){
											KardexFalta.setCicloGrupoId(cicloGrupoIdActual);
											if(KardexFalta.deleteReg(conElias)){
												// Borrado exitoso.
											}else{
												error = true;
												break;
											}
										}else{
											error = true;
											break;
										}
									}//finaliza if mapeó
								}
								//Checa si evalua conducta
								if(Curso.getConducta().equals("S")){
									//Traspasa la conducta si es que tiene
									KardexConducta.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), lisPromedio.get(i).getPromedioId(), lisBloque.get(t).getBloqueId());
									if(!KardexConducta.getConducta().equals("") && KardexConducta.getPromedioId().equals(lisBloque.get(t).getPromedioId())){
										KardexConducta.setCicloGrupoId(cicloGrupoIdNuevo);
										if(KardexConducta.insertReg(conElias)){
											KardexConducta.setCicloGrupoId(cicloGrupoIdActual);
											if(KardexConducta.deleteReg(conElias)){
												// Borrado exitoso
											}else{
												error = true;
												break;
											}
										}else{
											error = true;
											break;
										}
									}//finaliza if mapeó
								}
							}//finaliza for evaluaciones
						}
					}
					else if(nivelEvaluacion.equals("P")){			/* Si es por Promedio */
						for(int i = 0; lisPromedio.size() > i; i++){
							//Checa si evalua asistencias
							if(Curso.getFalta().equals("S")){
								//Traspasa las faltas si tiene
								KardexFalta.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), lisPromedio.get(i).getPromedioId(), "0");
								if(!KardexFalta.getFalta().equals("") && KardexFalta.getPromedioId().equals(lisPromedio.get(i).getPromedioId())){
									KardexFalta.setCicloGrupoId(cicloGrupoIdNuevo);
									if(KardexFalta.insertReg(conElias)){
										KardexFalta.setCicloGrupoId(cicloGrupoIdActual);
										if(KardexFalta.deleteReg(conElias)){
											// Se borró exitosamente
										}else{
											error = true;
											break;
										}
									}else{ 
										error = true;
										break;
									}
								}//finaliza if mapeó
							}
							//Checa si evalua conducta
							if(Curso.getConducta().equals("S")){
								//Traspasa la conducta si es que tiene
								KardexConducta.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), lisPromedio.get(i).getPromedioId(), "0");
								if(!KardexConducta.getConducta().equals("") && KardexConducta.getPromedioId().equals(lisPromedio.get(i).getPromedioId())){
									KardexConducta.setCicloGrupoId(cicloGrupoIdNuevo);
									if(KardexConducta.insertReg(conElias)){
										KardexConducta.setCicloGrupoId(cicloGrupoIdActual);
										if(KardexConducta.deleteReg(conElias)){
											// Borrado exitoso
										}else{
											error = true;
											break;
										}
									}else{
										error = true;
										break;
									}
								}//finaliza if mapeó
							}
						}//finaliza for evaluaciones
					}
				}
			}
			
			//COMMIT OR ROLLBACK TO DB
			if(error){
				conElias.rollback();
				msj = "NoPosibleCompletar";
			}else{
				conElias.commit();
				msj = "DatosModificados";
			}
			conElias.setAutoCommit(true);//** END TRANSACTION **	
		}
	}
	
	pageContext.setAttribute("resultado", msj);
%>
<style>
.col, .well{
	width: 40%;
	float: left;
}
.center{
	text-align: center !important;
}
.danger{
	color: red;
}
</style>
<div id="content">
<%if(!Alumno.existeReg(conElias, codigoAlumno)){ %>
	<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
	</div>
<%}else{%>
	<h2><fmt:message key="aca.CambiarGrupo" /></h2>
	<% 
	if(tipoTraspaso != 2){
		if (!error && msj.equals("DatosModificados")){%>
   		  <div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<%  }else if(error && msj.equals("NoPosibleCompletar")){%>
  		  <div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%  }
	} %>
	<form action="cambioGrupo.jsp" method="post" name="frmCambio" id="frmCambio" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="Grupo">
		<input type="hidden" name="TipoTraspaso" value="<%=tipoTraspaso%>">
		<input type="hidden" name="Curso">
		<div class="container">
			<div class="col">
				<h4><%= Alumno.getCodigoId() %> | <%= Alumno.getNombre()+" "+Alumno.getApaterno()+" "+Alumno.getAmaterno() %></h4>
				<p>
					<strong><fmt:message key="aca.Tutor"/>: <%=aca.empleado.EmpPersonal.getNombre(conElias, CicloGrupo.getMaestroBase(conElias, nivelAlumno, Alumno.getGrado(), Alumno.getGrupo(), cicloId), "NOMBRE") %></strong>
				</p>
				<p>
					<strong><fmt:message key="aca.Ciclo" />: <%= AlumCiclo.getCicloId() %></strong>
				</p>
				<p>
					<strong><fmt:message key="aca.Grado" />: <%= Alumno.getGrado() %></strong>
				</p>
				<p>
					<strong><fmt:message key="aca.Grupo" />: <%= Alumno.getGrupo() %></strong>
				</p>
				<!-- **PUEDE SER ÚTIL PARA CHEQUEOS
					<p>
						<strong>cicloGrupoIdActual: <%= cicloGrupoIdActual %>
					</p>
					<p>
						<strong>cicloGrupoIdNuevo: <%= cicloGrupoIdNuevo %>
					</p>
				  -->
			</div>
			<%if(!accion.equals("") && !error && !msj.equals("")){ %>
				<div class="well" style="padding:0px 10px;">
					<h4>Datos Anteriores:</h4>
					<p>
						<strong><fmt:message key="aca.Tutor"/>: <%=maestroAnterior %></strong>
					</p>
					<p>
						<strong><fmt:message key="aca.Grado" />: <%= gradoAnterior %></strong>
					</p>
					<p>
						<strong><fmt:message key="aca.Grupo" />: <%= grupoAnterior %></strong>
					</p>
				</div>
			<%} %>
			<div class="col">
				<select name="cicloGrupoIdNuevo" class="input-mini" style='margin-top:10px'>
				<%	
					int numCursos=0; int numAlumnos = 0;
					for(int i = 0; i < lisGrupoAlta.size(); i++){
						aca.catalogo.CatGrupo grupo = (aca.catalogo.CatGrupo) lisGrupoAlta.get(i);			
						String cicloGrupoId 	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, nivelAlumno, grupo.getGrado(), grupo.getGrupo(), cicloId, planAlumno);
						numCursos 		= aca.ciclo.CicloGrupoCurso.numCursosGrupo(conElias, cicloGrupoId);
						numAlumnos 		= aca.kardex.KrdxCursoAct.cantidadAlumnos(conElias, cicloGrupoId);
						if ((numCursos!=0 || numAlumnos!=0) && Alumno.getGrado().equals(grupo.getGrado()) && !Alumno.getGrupo().equals(grupo.getGrupo())){	
				%>    	
			      	  		<option value="<%=cicloGrupoId %>" <%if(CicloGrupoNuevo.getGrupo().equals(grupo.getGrupo())) out.print("selected");%>><%=grupo.getGrupo()%></option>
				<%		}
					}	
				%>
				</select>
				<a class="btn btn-primary" href="javascript:cambiarGrupo()" > Seleccionar</a>
			</div>
		</div>
	</form>
	<% if(tipoTraspaso >= 7){%>
   		<h4 class="center">El periodo de evaluación del grupo de destino debe de estar cerrado para traspasar a una materia con actividades.</h4>
   		<h5 class="center danger">Es necesario cerrar los periodos de evaluación correspondientes en cada materia.</h5>
   		<table class="table table-bordered">
   			<tr>
	   			<th width="100px">Id</th>
	   			<th>Nombre</th>
	   			<th>Evaluación</th>
	   			<!-- ÚTILES PARA TESTING -->
	   			<!-- <th>Id Evaluación</th> -->
	   			<!-- <th>Tipo traspaso</th> -->
	   		</tr>
	   		<%for(Map.Entry<String, TreeMap<String, Integer>> matCambio : listMateriasTraspaso.entrySet() ){
				int tipo = -1;
				try{
					tipo = matCambio.getValue().get("0");
				}catch(Exception ex){
					for(Map.Entry<String, Integer> eval: matCambio.getValue().entrySet()){
						if(eval.getValue() >= 7){
							Curso.mapeaRegId(conElias, matCambio.getKey());
							%>
								<tr class="danger">
					   				<td><%=Curso.getCursoId()%></td>
					   				<td><%=Curso.getCursoNombre()%></td>
					   				<td><%=aca.ciclo.CicloGrupoEval.getNombreEstrategia(conElias, cicloGrupoIdActual, matCambio.getKey(), eval.getKey()) %></td>
					   				<!-- ÚTILES PARA TESTING -->
					   				<%-- <td><%=eval.getKey() %></td> --%>
					   				<%-- <td><%=matCambio.getValue() %></td> --%>
					   			</tr>
							<%
						}
					}
					tipo = -1;
				}
	   		 }
	   		%>
   		</table>
   		
  	<% }if(tipoTraspaso > 2 && tipoTraspaso < 7){%>
	  		<h4 class="center">Se realizarán los siguientes cambios:</h4>
	  		<table class="table table-bordered">
   			<tr>
	   			<th>Id</th>
	   			<th>Materia</th>
	   			<th>Periodo</th>
	   			<th>Acción</th>
	   			<!-- ÚTILES PARA TESTING -->
	   			<!-- <th># Cambio</th> -->
	   		</tr>
	  		<%for(Map.Entry<String, TreeMap<String, Integer>> matCambio : listMateriasTraspaso.entrySet() ){ 
	  			Curso.mapeaRegId(conElias, matCambio.getKey());
	  			for(Map.Entry<String, Integer> listEval: matCambio.getValue().entrySet()){
	  		%>
   				<tr>
	   				<td><%=matCambio.getKey() %></td>
	   				<td><%=Curso.getCursoNombre()%></td>
	   				<td><%=aca.ciclo.CicloGrupoEval.getNombreEstrategia(conElias, cicloGrupoIdActual, matCambio.getKey(), listEval.getKey()) %></td>
	   				<td><%=msjCambio.get(listEval.getValue()) %></td>
	   				<!-- ÚTILES PARA TESTING -->
	   				<%-- <td><%=listEval.getKey() %> || <%=listEval.getValue() %></td> --%>
	   			</tr>
	   		<%	}
	  		}%>
	   		</table>
			<center>
				<a class="btn btn-primary" href="javascript:confirmarCambio()" > Confirmar</a>
				<a class="btn btn-danger" href="javascript:cancelarCambio()" > Cancelar</a>
			</center>
	<%}%>
<%} %>

</div>

<%@ include file= "../../cierra_elias.jsp" %>