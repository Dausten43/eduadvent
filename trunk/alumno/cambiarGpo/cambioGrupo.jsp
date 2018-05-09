<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.CicloGrupoActividad"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>

<jsp:useBean id="Alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumCiclo" scope="page" class="aca.alumno.AlumCiclo"/>
<jsp:useBean id="AlumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="CicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="CicloGrupoNuevo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="CicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="Curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="KardexCurso" scope="page" class="aca.kardex.KrdxCursoAct"/>
<jsp:useBean id="KardexAlumEval" scope="page" class="aca.kardex.KrdxAlumEval"/>
<jsp:useBean id="KardexFalta" scope="page" class="aca.kardex.KrdxAlumFalta"/>
<jsp:useBean id="KardexConducta" scope="page" class="aca.kardex.KrdxAlumConducta"/>

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
			document.frmCambio.TipoTraspaso.value = "5";
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
	
	function BorrarNotas(curso){
		if(confirm("<fmt:message key="js.ConfirmaBorradoNotas" />")){
			document.frmCambio.Accion.value = "1";
			document.frmCambio.TipoTraspaso.value = "0";
			document.frmCambio.Curso.value = curso;	 	
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
	msjCambio.put(1, "Se borrarán las calificaciones de las actividades del curso y se pasará la calificación final evaluación.");
	msjCambio.put(2, "Se dará de baja el curso.");
	msjCambio.put(3, "Esta materia ya está evaluada y el grupo de destino tiene actividades por lo que\n"
	         	   + "se necesitarán ingresar las calificaciones manualmente en el nuevo grupo.\n"
				   + "Para poder traspasar las demás materias es necesario borrar la calificación de esta y dar de baja.\n");
	msjCambio.put(4, "Esta materia tiene actividades calificadas en ambos grupos (actual y nuevo) por lo que\n"
      	   		   + "se necesitarán ingresar las calificaciones manualmente en el nuevo grupo.\n"
			   	   + "Para poder traspasar las demás materias es necesario borrar las calificaciones de las actividades de esta y dar de baja.\n");
	boolean TodoSalioBien			= false;
	
	Alumno.mapeaRegId(conElias, codigoAlumno); 							// Datos personales alumno
	AlumCiclo.mapeaRegId(conElias, codigoAlumno, cicloId, periodoId); 	// Datos de la inscripción del alumno
	AlumPlan.mapeaRegId(conElias, codigoAlumno, planAlumno);			// Datos del plan en el que está el alumno
	
	// Se obtiene el cicloGrupoId para mapear el CicloGrupo
	String	cicloGrupoIdActual 	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias,nivelAlumno,Alumno.getGrado(),Alumno.getGrupo(),cicloId,planAlumno);
	String  cicloGrupoIdNuevo	= request.getParameter("cicloGrupoIdNuevo")==null?"":request.getParameter("cicloGrupoIdNuevo").trim();
	
	CicloGrupo.mapeaRegId(conElias, cicloGrupoIdActual); 						// Datos del grupo de origen en el ciclo
	CicloGrupoNuevo.mapeaRegId(conElias, cicloGrupoIdNuevo); 					// Datos del grupo de destino en el ciclo

	//Datos antigüos
	String gradoAnterior	= Alumno.getGrado();
	String grupoAnterior	= Alumno.getGrupo();
	String maestroAnterior	= aca.empleado.EmpPersonal.getNombre(conElias, CicloGrupo.getMaestroBase(conElias, nivelAlumno, Alumno.getGrado(), Alumno.getGrupo(), cicloId), "NOMBRE");

	//Listado de los grupos del nivel del alumno. Es para desplegar las opciones de grupos.
	ArrayList<aca.catalogo.CatGrupo> lisGrupoAlta		= CatGrupoL.getListGruposAlta(conElias, cicloId, planAlumno, escuelaId, nivelAlumno, "ORDER BY NIVEL_ID, GRADO, GRUPO");
	
	// Crea un listado de los cursos que tiene cargado el alumno
	ArrayList<aca.kardex.KrdxCursoAct> listKrdxCursoAct = KardexCursoLista.getLisCursosAlumno(conElias, codigoAlumno, cicloGrupoIdActual, "ORDER BY CURSO_ID");
	
	// HashMap que tendrá las materias con problemas o modificaciones para mostrarlo en la tabla.
	Map<String, Integer> listMateriasCambios = new HashMap<String, Integer>();
	
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

// -------- CAMBIAR GRUPO ----------->
	if(accion.equals("3")){
		System.out.println("cicloGrupoIdActual: "+cicloGrupoIdActual+" cicloGrupoIdNuevo: "+cicloGrupoIdNuevo);
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		error 			= false;
		
		if(cicloGrupoIdNuevo.equals("")){
			error = true;
		}
		
		// Crea un listado de los cursos que tiene el grupo destino
		ArrayList<aca.ciclo.CicloGrupoCurso> listCursosNuevos = GrupoCursoL.getListMateriasGrupo(conElias, cicloGrupoIdNuevo, "ORDER BY CURSO_ID");
		
		if(!error && tipoTraspaso == 0){ // Si cargó bien el id del ciclo actual más al que se trapasará
			// En un ciclo for de cada materia se hará el traspaso
			for(aca.kardex.KrdxCursoAct curso: listKrdxCursoAct){
				//Se mapea con los datos del Grupo nuevo para ese curso en ese ciclo
				CicloGrupoCurso.mapeaRegId(conElias, cicloGrupoIdNuevo, curso.getCursoId());
				//Si alguna materia del grupo de origen no está en el grupo destino se pondrá como dado de baja
				if(CicloGrupoCurso.getCursoId().equals(curso.getCursoId())){
					// Crea listado de evaluaciones
					ArrayList<aca.kardex.KrdxAlumEval> listCursoEval = KardexCursoEvalLista.getListAlumMat(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), "ORDER BY EVALUACION_ID");
					// Checa si la materia tiene promedios
					if(aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId())){
						// Checa cada evaluación a ver cual esta calificada
						for(aca.kardex.KrdxAlumEval eval: listCursoEval){
							// Checa si la evaluación tiene calificaciones
							if(!eval.getNotaEval(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), Integer.parseInt(eval.getEvaluacionId())).equals("-")){
								// Checa si la evaluación tiene actividades
								if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdActual, curso.getCursoId(), eval.getEvaluacionId())){
									// Checa si la evaluación del otro grupo tiene actividades
									if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdNuevo, curso.getCursoId(), eval.getEvaluacionId())){
										// TABLA
										tipoTraspaso = 4;
										listMateriasCambios.put(curso.getCursoId(), 4);
										error = true;
									}else{
										// No Importa. Se traspasa y se borran las calificaciones de las actividades (msj)
										tipoTraspaso = tipoTraspaso<2?2:tipoTraspaso;
										listMateriasCambios.put(curso.getCursoId(), 1);
									}
								}else{
									// Checa si la evaluación del otro grupo tiene actividades
									if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdNuevo, curso.getCursoId(), eval.getEvaluacionId())){
										// No Se Puede. Se necesitan calificar las actividades del otro grupo (msj)
										tipoTraspaso = tipoTraspaso<3?3:tipoTraspaso;
										listMateriasCambios.put(curso.getCursoId(), 3);
										error = true;
									}else{
										// No Importa (Se traspasa sin problema)
										tipoTraspaso = tipoTraspaso<1?1:tipoTraspaso;
									}
								}
							}
						}//end for evaluaciones
					}
				}else{//Si la materia no se encuentra en el nuevo grupo
					tipoTraspaso = tipoTraspaso<2?2:tipoTraspaso;
					listMateriasCambios.put(curso.getCursoId(), 2);
				}
			}//end for curso
		}//end if not error on CicloGrupoId
		
		if(!error && tipoTraspaso != 2){
			
			for(aca.kardex.KrdxCursoAct curso: listKrdxCursoAct){
				//Se mapea con los datos del Grupo nuevo para ese curso en ese ciclo
				CicloGrupoCurso.mapeaRegId(conElias, cicloGrupoIdNuevo, curso.getCursoId());
				//Si alguna materia del grupo de origen no está en el grupo destino se pondrá como dado de baja
				if(CicloGrupoCurso.getCursoId().equals(curso.getCursoId())){
					// Crea listado de evaluaciones
					ArrayList<aca.kardex.KrdxAlumEval> listCursoEval = KardexCursoEvalLista.getListAlumMat(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), "ORDER BY EVALUACION_ID");
					//No tiene calificaciones (0) o no tienen actividades evaluadas (1) o se borrarán las actividades de origen (5)
					if(tipoTraspaso==0 || tipoTraspaso == 1 || tipoTraspaso == 5){
						
						if(tipoTraspaso==1 || tipoTraspaso == 5){ //Tiene calificaciones
							if(aca.kardex.KrdxCursoAct.getMatAlumTieneEval(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId())){
								for(aca.kardex.KrdxAlumEval eval: listCursoEval){
									KardexAlumEval.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), eval.getEvaluacionId());
									KardexAlumEval.setCicloGrupoId(cicloGrupoIdNuevo);
									if(!KardexAlumEval.existeReg(conElias)){
										if(KardexAlumEval.insertReg(conElias)){
											KardexAlumEval.setCicloGrupoId(cicloGrupoIdActual);
											if(!KardexAlumEval.deleteReg(conElias)){
												error = true; break;
											}
										}else{
											error = true; break;	
										}
									}
									if(tipoTraspaso == 5){
										//AQUÍ IRÁ EL CÓDIGO PARA BORRAR LAS ACTIVIDADES
										//Checa si tiene actividades
										if(CicloGrupoActividad.tieneActividades(conElias, cicloGrupoIdActual, curso.getCursoId(), eval.getEvaluacionId())){
											//Si tiene, crea una lista de ellas
											ArrayList<aca.kardex.KrdxAlumActiv> listActiv = KardexCursoActivLista.getListEvaluacion(conElias, cicloGrupoIdActual, curso.getCursoId(), eval.getEvaluacionId(), "ORDER BY ACTIVIDAD_ID");
											//Con ese método se intentan borran los registros de las actividades de ese alumno en ese grupo. Si no se borran hay error.
											if(!listActiv.get(0).deleteRegGrupo(conElias, codigoAlumno, cicloGrupoIdActual)){
												error = true;
												break;
											}
										}
									}
								}
								if(error) break;
							}
						}
						
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
								if(!curso.deleteReg(conElias)){
									error = true; break;
								}
							}else{
								error = true; break;	
							}
						}
						
						if(!error)
							TodoSalioBien = true;
					}
				}else{
					curso.setTipoCalId("6");
					if(!curso.updateReg(conElias)){
						error = true;
					}
				}
			}//end for curso
		}//Borrar al entregar
		
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
	
	/*
	 * Es necesario traspasar las calificaciones de las faltas y la conducta. No importa el tipo de trapaso que sea el traspaso de estos datos es de
	 * la misma manera para todas. Pero solo se debe de realizar una vez que todas las materias se traspasaron de forma correcta. De esta manera, al
	 * saber que todo salió bien, realiza este paso y, en teoría, nada debería de salir mal.
	 *
	 */
	 
	if(TodoSalioBien){
		conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
		error 			= false;
		
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
									if(!KardexFalta.deleteReg(conElias)){
										error = true;
										break;
									}//end if not delete
								}//end if insert
								else{
									error = true;
									break;
								}//end if not insert
							}//end if mapeó
						}//end if get Falta curso
						if(Curso.getConducta().equals("S")){
							//Traspasa la conducta si es que tiene
							KardexConducta.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), lisPromedio.get(i).getPromedioId(), lisBloque.get(t).getBloqueId());
							if(!KardexConducta.getConducta().equals("") && KardexConducta.getPromedioId().equals(lisBloque.get(t).getPromedioId())){
								KardexConducta.setCicloGrupoId(cicloGrupoIdNuevo);
								if(KardexConducta.insertReg(conElias)){
									KardexConducta.setCicloGrupoId(cicloGrupoIdActual);
									if(!KardexConducta.deleteReg(conElias)){
										error = true;
										break;
									}//end if not delete
								}//end if insert
								else{
									error = true;
									break;
								}//end if not insert
							}//end if mapeó
						}//end if get Conducta curso
					}//end for evaluación
				}
			}//end if nivelEvaluación
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
								if(!KardexFalta.deleteReg(conElias)){
									error = true;
									break;
								}//end if not delete
							}//end if insert
							else{ 
								error = true;
								break;
							}//end if not insert
						}//end if mapeó
					}//end if get Falta curso
					if(Curso.getConducta().equals("S")){
						//Traspasa la conducta si es que tiene
						KardexConducta.mapeaRegId(conElias, codigoAlumno, cicloGrupoIdActual, curso.getCursoId(), lisPromedio.get(i).getPromedioId(), "0");
						if(!KardexConducta.getConducta().equals("") && KardexConducta.getPromedioId().equals(lisPromedio.get(i).getPromedioId())){
							KardexConducta.setCicloGrupoId(cicloGrupoIdNuevo);
							if(KardexConducta.insertReg(conElias)){
								KardexConducta.setCicloGrupoId(cicloGrupoIdActual);
								if(!KardexConducta.deleteReg(conElias)){
									error = true;
									break;
								}//end if not delete
							}//end if insert
							else{ //if not insert
								error = true;
								break;
							}//end if get Conducta curso
						}//end if mapeó
					}
				}//end for evaluación
			}//end if nivelEvaluación
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
  	<% }else if(error){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%}} %>
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
			<%if(!accion.equals("") && !error && tipoTraspaso != 2){ %>
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
							System.out.println(grupo.getGrupo()+": "+CicloGrupoNuevo.getGrupo().equals(grupo.getGrupo()));
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
	<% if(tipoTraspaso == 3 || tipoTraspaso == 4){%>
   		
   		<table class="table table-bordered">
   			<tr>
	   			<th>Id</th>
	   			<th>Nombre</th>
	   			<th>Detalles</th>
	   			<th>¿Borrar calificación?</th>
	   		</tr>
	   		<%for(Map.Entry<String, Integer> matCambio : listMateriasCambios.entrySet() ){ 
	   			if(matCambio.getValue() > 2){
	   				Curso.mapeaRegId(conElias, matCambio.getKey());
	   		%>
	   			<tr class="danger">
	   				<td><%=Curso.getCursoId()%></td>
	   				<td><%=Curso.getCursoNombre()%></td>
	   				<td><%=msjCambio.get(matCambio.getValue()) %></td>
	   				<td>
						<a href="javascript:BorrarNotas('<%=Curso.getCursoId()%>')" title="<fmt:message key="boton.BorrarNotas" />">
							<fmt:message key="aca.Si" />
						</a>
  					</td>
	   			</tr>
	   		<%	}
	   		 }
	   		%>
   		</table>
   		
  	<% }if(tipoTraspaso == 2){%>
	  		<h4 class="center">Se realizarán los siguientes cambios:</h4>
	  		<table class="table table-bordered">
   			<tr>
	   			<th>Materia</th>
	   			<th>Cambio</th>
	   		</tr>
	  		<%for(Map.Entry<String, Integer> matCambio : listMateriasCambios.entrySet() ){ %>
   				<tr>
	   				<td><%=matCambio.getKey() %></td>
	   				<td><%=msjCambio.get(matCambio.getValue()) %></td>
	   			</tr>
	   		<%}%>
	   		</table>
			<center>
				<a class="btn btn-primary" href="javascript:confirmarCambio()" > Confirmar</a>
				<a class="btn btn-danger" href="javascript:cancelarCambio()" > Cancelar</a>
			</center>
	<%}%>
<%} %>

</div>

<%@ include file= "../../cierra_elias.jsp" %>