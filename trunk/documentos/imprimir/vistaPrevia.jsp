<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="AlumConstancia" scope="page" class="aca.alumno.AlumConstancia"/>
<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="Fecha" scope="page" class="aca.util.Fecha" />
<jsp:useBean id="alumPlanLista" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="CursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>
<jsp:useBean id="CatNivelEscuelaListaU" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="AlumnoCursoL" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="AlumCicloL" scope="page" class="aca.alumno.AlumCicloLista"/>
<%
	String escuelaId 			= (String) session.getAttribute("escuela");
	String constanciaId         = request.getParameter("constanciaId");
	String codigoId      		= request.getParameter("codigoId");
	String cicloId 				= (String) session.getAttribute("cicloId");
	String planId				= request.getParameter("plan")==null?aca.alumno.AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
	String salto				= "X";
	
	String nivel			= aca.plan.Plan.getNivel(conElias, planId);
	String nivelNombre		= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel);
	String nivelTitulo		= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivel).toUpperCase();
	
	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	
	//Map de materias del plan seleccionado
	java.util.HashMap<String, aca.plan.PlanCurso> mapCurso		= aca.plan.PlanCursoLista.mapPlanCursos(conElias, planId);
	
	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalSuma				= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotas(conElias, codigoId);
	
	//Map que cuenta las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalCuenta				= aca.kardex.KrdxAlumEvalLista.mapEvalCuentaNotas(conElias, codigoId);
	
	//Map de evaluaciones del alumno en Krdx_Alum_Eval
		java.util.HashMap<String, aca.kardex.KrdxAlumEval> mapEval	= aca.kardex.KrdxAlumEvalLista.mapEvalAlumno(conElias, codigoId);
	
	// Map de evaluaciones del alumno en Ciclo_Grupo_Eval
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalAlumno(conElias, codigoId);
	
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromAlumno(conElias, codigoId);
	
	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalSumaTot			= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotasTot(conElias, codigoId);
	
	//Map que cuenta las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalCuentaTot			= aca.kardex.KrdxAlumEvalLista.mapEvalCuentaNotasTot(conElias, codigoId);
	
	
	AlumPersonal.mapeaRegId(conElias, codigoId);
	escuela.mapeaRegId(conElias, escuelaId);
	
	/* Planes de estudio del alumno */
	ArrayList<aca.alumno.AlumPlan> lisPlan			= alumPlanLista.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");
	
	/* Array de Bloques de la materia */
	ArrayList<aca.ciclo.CicloBloque> lisBloque		= new ArrayList<aca.ciclo.CicloBloque>();
	
	/* Materias o cursos del plan de estudio del alumno */
	ArrayList<aca.plan.PlanCurso> lisCurso 			= CursoLista.getListCurso(conElias, planId," AND (CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_IMP WHERE CODIGO_ID = '"+codigoId+"') OR CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"')) ORDER BY GRADO, TIPOCURSO_ID, ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE");
	
	/* Notas de alumno en las materias */
	ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso = AlumnoCursoL.getListAll(conElias, escuelaId, "AND CODIGO_ID = '"+codigoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	
	//TreeMap de los promedios del alumno en la materia
	java.util.HashMap<String, aca.vista.AlumnoProm> mapProm 				= AlumPromLista.mapAlumProm(conElias, codigoId,"");	
	
	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
	
	/* Ciclos en los que el alumno ha estudiado */
	ArrayList<aca.alumno.AlumCiclo> lisCiclos					= AlumCicloL.listCiclosConMaterias(conElias, codigoId, planId, "1,2,3,4,5", " ORDER BY CICLO_ID");
	
	java.util.HashMap<String, aca.catalogo.CatNivelEscuela> mapNomNivel 	= CatNivelEscuelaListaU.mapNivelesEscuela(conElias, escuelaId);
	
	if(constanciaId == null){
		salto = "documento.jsp";
	}

	AlumConstancia.mapeaRegId(conElias, constanciaId, escuelaId);
	
	/*
	/* NOMBRE GRADO 
	*/
	//String gradoNombre = AlumPersonal.getGrado();
// 	if(AlumPersonal.getGrado().equals("1")){
// 		gradoNombre = "Primer";
// 	}else if(AlumPersonal.getGrado().equals("2")){ 
// 		gradoNombre = "Segundo";
// 	}else if(AlumPersonal.getGrado().equals("3")){
// 		gradoNombre = "Tercer";
// 	}else if(AlumPersonal.getGrado().equals("4")){
// 		gradoNombre = "Cuarto";
// 	}else if(AlumPersonal.getGrado().equals("5")){
// 		gradoNombre = "Quinto";
// 	}else if(AlumPersonal.getGrado().equals("6")){
// 		gradoNombre = "Sexto";
// 	}else if(AlumPersonal.getGrado().equals("7")){
// 		gradoNombre = "Septimo";
// 	}
	
	/* FORMATEAR TEXTO */
	String nivelNombreCorto = aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, AlumPersonal.getNivelId());
	//String grado            = gradoNombre + " " + aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, AlumPersonal.getNivelId());
	String grado            = "";
	String ciudad           = aca.catalogo.CatCiudad.getCiudad(conElias, escuela.getPaisId(), escuela.getEstadoId(), escuela.getCiudadId());
	String estado 			= aca.catalogo.CatEstado.getEstado(conElias, escuela.getPaisId(), escuela.getEstadoId());
	
	String dia  			= aca.util.NumberToLetter.convertirLetras( Integer.parseInt(Fecha.getDia(aca.util.Fecha.getHoy())) );
	String mes  			= Fecha.getMesNombre( aca.util.Fecha.getHoy() );
	String year  			= aca.util.NumberToLetter.convertirLetras( Integer.parseInt(Fecha.getYear(aca.util.Fecha.getHoy())) );
	
	int block 					= 0;
	int gradoTemp				= 0;
	
	
	/* CALIFICACIONES */
	String calificaciones = "";	
	int count 			= 0;			
	String prom 		= "-";
	//String ciclo 		= "-";
	String check 		= "-";
	String cicloCheck	= "-";
	String fecha		= "-";
	String aFinal		= "-";	
	
	
	
	for(aca.alumno.AlumCiclo ciclo : lisCiclos){
		
		//Nombre del ciclo escolar 
		String cicloNombre 	= aca.ciclo.Ciclo.getCicloNombre(conElias, ciclo.getCicloId());
		
		// Nombre del grado
		String gradoNombre	= aca.catalogo.CatNivel.getGradoNombre( Integer.parseInt(ciclo.getGrado()) )+" "+nivelTitulo;
		
		grado = gradoNombre;
		
		// Escala
		int escalaEval = aca.ciclo.Ciclo.getEscala(conElias, ciclo.getCicloId());
		
		// Clave del grupo donde se inscribio el alumno
		String cicloGrupoId	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, ciclo.getNivel(), ciclo.getGrado(), ciclo.getGrupo(), ciclo.getCicloId(), planId);
		
		/* Lista de materias del alumno*/
		lisAlumnoCurso 		= AlumnoCursoL.getListAlumCurso(conElias, codigoId, cicloGrupoId, " ORDER BY TIPO_CURSO_ID(CURSO_ID), ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
		
		// Lista de promedios en el ciclo
		lisPromedio 		= CicloPromedioL.getListCiclo(conElias, ciclo.getCicloId(), " ORDER BY PROMEDIO_ID");
		
		// Lista de evaluaciones o bloques en el ciclo
		lisBloque 			= CicloBloqueL.getListCiclo(conElias, ciclo.getCicloId(), " ORDER BY BLOQUE_ID");	
		
					calificaciones += 							
							"<table border='1'> <caption style='margin-bottom:10px;'> <b><font size='3'> "+
							cicloNombre	+" - "+
							nivelNombre +" - "+
							gradoNombre + " "+
							ciclo.getGrupo()+
							"</caption></b></font>"+
							"<thead><tr>"+
							"<th width='1%'>#</th>"+	
							" <th width='35%'>Nombre Materia</th>"; //<fmt:message key='aca.NombreMateria'/>
							
		for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
			
			for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
				if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
					// Inserta columnas de evaluaciones
					
					calificaciones += "<th class='text-center' width='2%' title='"+cicloBloque.getBloqueNombre()+"'>"+cicloBloque.getCorto()+"</th>";
				}
			}			
			// Inserta columna del promedio de las evaluaciones
			calificaciones +="<th class='text-center' width='2%' title="+cicloPromedio.getNombre()+ ">" +cicloPromedio.getCorto()+"</th>"+
			 					"<th class='text-center' width='2%' title='Puntos'>Puntos</th>";
		}
		
		if (lisPromedio.size() > 1){
					calificaciones +="<th class='text-center' width='2%'>Nota</th>";
		}
		
					calificaciones += "<th class='text-center' width='10%'>"+
										"Fecha"+ //<fmt:message key=aca.FechaNota/>
										"</th>"+
												
						//"<th class='text-center' width='5%'><fmt:message key='aca.Extra'/></th>"+
						//"<th class='text-center' width='10%'><fmt:message key='aca.FechaExtra'/></th>"+
						"</tr></thead>";
						
						
	
						
						
		String tipoCurso = "0";			
		int row = 0;
		for (aca.vista.AlumnoCurso alumCurso : lisAlumnoCurso){				
			row++;
			
			aca.plan.PlanCurso curso = new aca.plan.PlanCurso();
			// Si el alumno tiene el curso
			if (mapCurso.containsKey(alumCurso.getCursoId())){
				curso = mapCurso.get(alumCurso.getCursoId());				
			}
			
			// Poner Totales
			if (!tipoCurso.equals(curso.getTipocursoId()) && !tipoCurso.equals("0")){
			
					calificaciones += "<tr>"+
								"<td colspan='2'><b>Promedio:<b></td>";

				
				double promCiclo 	= 0;
				int numProm 		= 0;
				for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					
					for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
						if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
							double sumaEval = 0;
							if (mapEvalSuma.containsKey(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId())){
								sumaEval = Double.parseDouble(mapEvalSuma.get(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId()));
							}
							double cuentaEval = 0;
							if (mapEvalCuenta.containsKey(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId())){
								cuentaEval = Double.parseDouble(mapEvalCuenta.get(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId()));
							}
							double promEval = 0;
							if (cuentaEval>0 && sumaEval>0){
								promEval = sumaEval/cuentaEval;
								numProm++;
								promCiclo += promEval;
							}
							// Inserta columnas de evaluaciones
						calificaciones += "<td class='text-center' width='2%' title=''><b>"+formato2.format(promEval)+"</b></td>";
						}
					}
					if (numProm > 0) promCiclo = promCiclo / numProm;
					// Inserta columna del promedio de las evaluaciones
						calificaciones +="<td class='text-center' width='2%' title=''><b>"+formato2.format(promCiclo)+"</b></td>";
					
					
				}
				
				// Completa las columnas del renglon de promedio  
						calificaciones += "<td colspan='20'></td>";
			}
			
			// Tipo de curso
			tipoCurso = curso.getTipocursoId();
			
						calificaciones +="<tr>"+
											"<td width='1%' align='center' 'title="+alumCurso.getCursoId()+">"+row+"</td>"+
													"<td width='35%'>"+curso.getCursoNombre()+"</td>";
													
				for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					int evalCerradas = 0;
					for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
						if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
							
							// Nota del alumno en la evaluacion
							double notaEval = 0;
							if (mapEval.containsKey(codigoId+cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId())){
								notaEval = Double.parseDouble(mapEval.get(codigoId+cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getNota());
							}
							// Verifica si la nota de la evaluacion es temporal o definitiva(abierta o cerrada)
							String estadoEval = "A";
							String nombreEval = "-";
							if (mapEvalCiclo.containsKey(cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId())){
								estadoEval 	= mapEvalCiclo.get(cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getEstado();
								nombreEval 	= mapEvalCiclo.get(cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getEvaluacionNombre();
							}
							// Color de la evaluacion
							String colorEval = "color:blue;";
							if (estadoEval.equals("C")){
								evalCerradas++;
								colorEval = "color:black;";
							}
							
							// Formato de la evaluacion
							String notaFormato = formato0.format(notaEval);
							if (cicloBloque.getDecimales().equals("1")) 
								notaFormato = formato1.format(notaEval);
							
							// Inserta columnas de evaluaciones
							calificaciones +="<td class='text-center' width='1%' title='' style='"+colorEval+"'>"+notaFormato+"</td>";
						}
					}
					
					// Obtiene el promedio del alumno en las evaluaciones (tabla Krdx_Alum_Prom)
					double promEval = 0; 
					if (mapPromAlumno.containsKey(cicloGrupoId+alumCurso.getCursoId()+cicloPromedio.getPromedioId())){
						promEval = Double.parseDouble(mapPromAlumno.get(cicloGrupoId+alumCurso.getCursoId()+cicloPromedio.getPromedioId()).getNota());
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
					
					// Color del promedio
					String colorProm = "color:blue;";
					if (evalCerradas>0 && evalCerradas == lisBloque.size()){
						colorProm = "color:black;";
					}
					
					// Inserta columna del promedio de las evaluaciones
							calificaciones += "<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+promFormato+"</td>";
					
					// Puntos del promedio
							calificaciones += "<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+formato0.format(Double.parseDouble(promFormato) * Double.parseDouble(cicloPromedio.getValor()) / escalaEval)+"</td>";

					//System.out.println("promedio"+ cicloPromedio.getValor()+ "escala"+ escalaEval);
					
					// Inserta columna de los puntos
					//out.print("<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+puntosFormato+"</td>");
				}
				if (lisPromedio.size() > 1){
					
							calificaciones += "<td class='text-center' width='2%'>"+alumCurso.getNota()+"</td>";
				}

							//calificaciones += "<td class='text-center' width='5%'>";
				
						if(alumCurso.getFNota() == null) 
							
							calificaciones += "<td class='text-center' width='10%'></td></tr>";
						else calificaciones += "<td class='text-center' width='10%'>"+alumCurso.getFNota() + "</td></tr>";
						/*	
						calificaciones += "<td class='text-center' width='5%'>";
											
						if(alumCurso.getNotaExtra() == null) 
							calificaciones += "-";
						
						else calificaciones += alumCurso.getNotaExtra(); 
						
						calificaciones += "<td class='text-center' width='5%'>";
						
			if(alumCurso.getFExtra() == null) 
						calificaciones += "-1";
						else calificaciones += alumCurso.getFExtra()+ "</td> </tr>";*/
				
		}				
						
			// Colocar el promedio del ultimo tipo de curso
						calificaciones +="<tr>"+
											"<td colspan='2'><b>Promedio:</b></td>";
		
		double promCiclo 	= 0;
		int numProm 		= 0;
		for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
			
			for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
				if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
					double sumaEval = 0;
					if (mapEvalSuma.containsKey(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId())){
						sumaEval = Double.parseDouble(mapEvalSuma.get(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId()));
					}
					double cuentaEval = 0;
					if (mapEvalCuenta.containsKey(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId())){
						cuentaEval = Double.parseDouble(mapEvalCuenta.get(cicloGrupoId+tipoCurso+cicloBloque.getBloqueId()));
					}
					double promEval = 0;
					if (cuentaEval>0 && sumaEval>0){
						promEval = sumaEval/cuentaEval;
						numProm++;
						promCiclo += promEval;
					}								
					// Inserta columnas de evaluaciones
					calificaciones +="<td class='text-center' width='2%' title=''><b>"+formato2.format(promEval)+"</b></td>";
				}
			}
			
			if (numProm > 0) promCiclo = promCiclo / numProm;
			// Inserta columna del promedio de las evaluaciones
					calificaciones +="<td class='text-center' width='2%' title=''><b>"+formato2.format(promCiclo)+"</b></td>";
		}
		// Completa las columnas del renglon de promedio  
					calificaciones +="<td colspan='20'></td>";
				
		// Poner promedio general
		
		// Colocar el promedio del ultimo tipo de curso
					calificaciones +="<tr>"+
							"<td colspan='2'><b>Promedio General:</b></td>";
		
		
		promCiclo 	= 0;
		numProm 	= 0;
		for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
			
			for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
				if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
					double sumaEval = 0;
					if (mapEvalSumaTot.containsKey(cicloGrupoId+cicloBloque.getBloqueId())){
						sumaEval = Double.parseDouble(mapEvalSumaTot.get(cicloGrupoId+cicloBloque.getBloqueId()));
					}
					double cuentaEval = 0;
					if (mapEvalCuentaTot.containsKey(cicloGrupoId+cicloBloque.getBloqueId())){
						cuentaEval = Double.parseDouble(mapEvalCuentaTot.get(cicloGrupoId+cicloBloque.getBloqueId()));
					}
					double promEval = 0;
					if (cuentaEval>0 && sumaEval>0){
						promEval = sumaEval/cuentaEval;
						numProm++;
						promCiclo += promEval;
					}
					// Inserta columnas de evaluaciones
					calificaciones += "<td class='text-center' width='2%' title=''><b>"+formato2.format(promEval)+"</b></td>";
				}
			}
			
			if (numProm > 0) promCiclo = promCiclo / numProm;
			// Inserta columna del promedio de las evaluaciones
					calificaciones += "<td class='text-center' width='2%' title=''><b>"+formato2.format(promCiclo)+"</b></td>";
		}
		// Completa las columnas del renglon de promedio  
					calificaciones += "<td colspan='20'></td></table><br>";
		}	
	
	/* END CALIFICACIONES */
	
	
	String constanciaHTML = AlumConstancia.getConstancia();
	
	constanciaHTML = constanciaHTML.replaceAll("#Escuela", aca.catalogo.CatEscuela.getNombre(conElias, escuelaId).trim());
	constanciaHTML = constanciaHTML.replaceAll("#Codigo", codigoId.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Nombre", AlumPersonal.getNombre().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Paterno", AlumPersonal.getApaterno().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Materno", AlumPersonal.getAmaterno().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Curp", AlumPersonal.getCurp().trim());
	constanciaHTML = constanciaHTML.replaceAll("#CIP", AlumPersonal.getCurp().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Nivel", nivelNombreCorto.toLowerCase().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Grado", grado.toLowerCase().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Grupo", AlumPersonal.getGrupo().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Ciudad", ciudad.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Estado", estado.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Fecha", aca.util.Fecha.getHoy().trim());
	constanciaHTML = constanciaHTML.replaceAll("#Dia", dia.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Mes", mes.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Year", year.trim());
	constanciaHTML = constanciaHTML.replaceAll("#Foto", "<img src='imagen.jsp?mat="+codigoId.trim()+"'/>");
	constanciaHTML = constanciaHTML.replaceAll("#Calificaciones", calificaciones);
	
	
	
%>

<link rel="stylesheet" href="../../js-plugins/ckeditor/contents.css"></link>

<div id="content">
	
	<%=constanciaHTML %>
	
</div>	


<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp" %>