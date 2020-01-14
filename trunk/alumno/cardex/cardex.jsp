<%@page import="aca.ciclo.CicloBloque"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="AlumPlanL" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="AlumCicloL" scope="page" class="aca.alumno.AlumCicloLista"/>
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="AlumnoCursoL" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista" />
<%	
	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.text.DecimalFormat formato4	= new java.text.DecimalFormat("##0.0000;-##0.0000", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	java.math.MathContext mc = new java.math.MathContext(4, RoundingMode.HALF_EVEN);

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	
	String planId			= request.getParameter("plan")==null?aca.alumno.AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
	String nivel			= aca.plan.Plan.getNivel(conElias, planId);
	String nivelNombre		= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel);
	String nivelTitulo		= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivel).toUpperCase();
	String unionId			= aca.catalogo.CatEscuela.getUnionId(conElias, escuelaId);
	boolean existeAlumno 	= false;
	 
	
	/* Planes de estudio del alumno */
	ArrayList<aca.alumno.AlumPlan> lisPlan						= AlumPlanL.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");
	
	/* Ciclos en los que el alumno ha estudiado */
	ArrayList<aca.alumno.AlumCiclo> lisCiclos					= AlumCicloL.listCiclosConMaterias(conElias, codigoId, planId, "1,2,3,4,5", " ORDER BY CICLO_ID");
	
	//Map de materias del plan seleccionado
	java.util.HashMap<String, aca.plan.PlanCurso> mapCurso		= aca.plan.PlanCursoLista.mapPlanCursos(conElias, planId);
	
	/* Array de Esquema o calculo de promedio */
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio				= new ArrayList<aca.ciclo.CicloPromedio>();
	
	/* Array de Bloques de la materia */
	ArrayList<aca.ciclo.CicloBloque> lisBloque					= new ArrayList<aca.ciclo.CicloBloque>();
	
	/* Notas el alumno en las materias */
	ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso 			= new ArrayList<aca.vista.AlumnoCurso>();
	
	// Map de evaluaciones del alumno en Ciclo_Grupo_Eval
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalAlumno(conElias, codigoId);
	
	//Map de evaluaciones del alumno en Krdx_Alum_Eval
	java.util.HashMap<String, aca.kardex.KrdxAlumEval> mapEval	= aca.kardex.KrdxAlumEvalLista.mapEvalAlumno(conElias, codigoId);
	
	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalSuma				= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotas(conElias, codigoId);
	
	//Map que cuenta las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalCuenta				= aca.kardex.KrdxAlumEvalLista.mapEvalCuentaNotas(conElias, codigoId);
	
	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalSumaTot			= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotasTot(conElias, codigoId);
		
	//Map que cuenta las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalCuentaTot			= aca.kardex.KrdxAlumEvalLista.mapEvalCuentaNotasTot(conElias, codigoId);
		
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromAlumno(conElias, codigoId);
	
	// Verifica si existe el alumno
	AlumPersonal.setCodigoId(codigoId);
	if (AlumPersonal.existeReg(conElias)){
		existeAlumno = true;
	}else{
		existeAlumno = false;
	}
%>
	
<div id="content">
	
	<%if(!existeAlumno){%>
	<div class="alert">
		<fmt:message key="aca.NoAlumnoSeleccionado" />
	</div>
	<%}else{ %>
	
	<h2><%=codigoId %> | <%= aca.alumno.AlumPersonal.getNombre(conElias, codigoId, "NOMBRE")%></h2>
	
	<div class="well">	
		<select name="plan" id="plan" onchange="location.href='cardex.jsp?plan='+this.options[this.selectedIndex].value;" class="input-xxlarge">
			<%for(aca.alumno.AlumPlan alPlan : lisPlan){%>
				<option value="<%=alPlan.getPlanId() %>" <%if(planId.equals(alPlan.getPlanId())){out.print("selected");} %>><%=aca.plan.Plan.getNombrePlan(conElias, alPlan.getPlanId())%></option>
			<%}%>
		</select>
	</div>	
<%	
		for(aca.alumno.AlumCiclo ciclo : lisCiclos){
			
			//Nombre del ciclo escolar 
			String cicloNombre 	= aca.ciclo.Ciclo.getCicloNombre(conElias, ciclo.getCicloId());
			
			// Nombre del grado
			String gradoNombre	= aca.catalogo.CatNivel.getGradoNombre( Integer.parseInt(ciclo.getGrado()) )+" "+nivelTitulo;
			
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
			
			// Tipo de redondeo en el ciclo
			String redondeoCiclo = aca.ciclo.Ciclo.getRedondeo(conElias, ciclo.getCicloId());			
%>			
	<div class="alert alert-info"><%= cicloNombre %> - <%= nivelNombre %> - <%= gradoNombre %> "<%= ciclo.getGrupo() %>"</div>
				
	<table class="table table-condensed table-bordered">
		<thead>
			<tr>
				<th width="2%">#</th>
			    <th width="20%"><fmt:message key="aca.NombreMateria"/></th>
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
				out.print("<th class='text-center' width='2%' title='Puntos'>Puntos</th>");				
			}
			if (lisPromedio.size() > 1){
				out.print("<th class='text-center' width='2%' title='Nota' >Nota</th>");	
			}
%>						
				<th class="text-center" width="5%"><fmt:message key="aca.FechaNota"/></th>
				<th class="text-center" width="5%"><fmt:message key="aca.Extra"/></th>
				<th class="text-center" width="10%"><fmt:message key="aca.FechaExtra"/></th>
			</tr>
		</thead>
<%
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
					
					out.print("<tr class='alert alert-success'>");
					out.print("<td colspan='2'>Promedio:</td>");
					
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
								out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promEval)+"</td>");
							}
						}						
						if (numProm > 0) promCiclo = promCiclo / numProm;
						
						// Tipo de redondeo en el ciclo "A"=Arriba y "T"=Truncado 
						if (redondeoCiclo.equals("T")){
							String promConRedondeo = aca.ciclo.Ciclo.numRedondeo(conElias, String.valueOf(promCiclo), 2, "T");
							promCiclo = Double.parseDouble(promConRedondeo);
						}
						// Inserta columna del promedio de las evaluaciones
						out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promCiclo)+"</td>");
					}
					
					// Completa las columnas del renglon de promedio  
					out.print("<td colspan='20'></td>");
				}
				
				// Tipo de curso
				tipoCurso = curso.getTipocursoId();
%>
		<tr> 
		    <td width="2%" title='<%=alumCurso.getCursoId()%>'><%=row %></td>
		    <td width="20%"><%=curso.getCursoNombre()%></td>
<%
				double promedioFinal = 0;
				
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
								out.print("<td class='text-center' width='1%' title='' style='"+colorEval+"'>"+notaFormato+"</td>");
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
						out.print("<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+promFormato+"</td>");
						
						// Puntos del promedio						
						out.print("<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+formato1.format(Double.parseDouble(promFormato) * Double.parseDouble(cicloPromedio.getValor()) / escalaEval)+"</td>");
						//System.out.println("promedio"+ cicloPromedio.getValor()+ "escala"+ escalaEval);
						
						// Inserta columna de los puntos
						//out.print("<td class='text-center' width='2%' title='' style='"+colorProm+"'>"+puntosFormato+"</td>");
					}

					java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias, cicloGrupoId,"");
					aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupoId+alumCurso.getCursoId()+codigoId);
					BigDecimal promFinalCurso = new BigDecimal(alumProm.getPromedio(), mc).add(new BigDecimal(alumProm.getPuntosAjuste(), mc), mc);

					String promConRedondeo = aca.ciclo.Ciclo.numRedondeo(conElias, String.valueOf(promFinalCurso), Integer.parseInt(aca.ciclo.Ciclo.getDecimales(conElias, ciclo.getCicloId())), redondeoCiclo);

					if (lisPromedio.size() > 1){
						out.print("<td class='text-center' width='2%'>"+promConRedondeo+"</td>");
					}
%>
			<td class="text-center" width="5%"><%if(alumCurso.getFNota() == null) out.print("-"); else out.print(alumCurso.getFNota()); %></td>
			<td class="text-center" width="5%"><%if(alumCurso.getNotaExtra() == null) out.print("-"); else out.print(alumCurso.getNotaExtra()); %></td>
			<td class="text-center" width="5%"><%if(alumCurso.getFExtra() == null) out.print("-"); else out.print(alumCurso.getFExtra()); %></td>
		</tr>	
<%						
			}
			
			// Colocar el promedio del ultimo tipo de curso
			out.print("<tr class='alert alert-success'>");
			out.print("<td colspan='2'>Promedio:</td>");
			
			double promCiclo 	= 0;
			int numProm 		= 0;
			
			double promedioFinal = 0;
			
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
						out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promEval)+"</td>");
					}	
				}
					
				if (numProm > 0) promCiclo = promCiclo / numProm;
				
				// Tipo de redondeo en el ciclo "A"=Arriba y "T"=Truncado 
				if (redondeoCiclo.equals("T")){
					String promConRedondeo = aca.ciclo.Ciclo.numRedondeo(conElias, String.valueOf(promCiclo), 2, "T");
					promCiclo = Double.parseDouble(promConRedondeo);
				}				
				
				// Inserta columna del promedio de las evaluaciones
				out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promCiclo)+"</td>");
			}
			// Completa las columnas del renglon de promedio  
			out.print("<td colspan='20'></td>");
					
			// Poner promedio general
			
			// Colocar el promedio del ultimo tipo de curso
			out.print("<tr class='alert alert-success'>");
			
			out.print("<td colspan='2'>Promedio General:</td>");
			
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
						out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promEval)+"</td>");
					}
				}
				
				if (numProm > 0) promCiclo = promCiclo / numProm;
				
				// Tipo de redondeo en el ciclo "A"=Arriba y "T"=Truncado 
				if (redondeoCiclo.equals("T")){
					int decimales = 2;
					if (unionId.equals("8")) decimales = 4;
					String promConRedondeo = aca.ciclo.Ciclo.numRedondeo(conElias, String.valueOf(promCiclo), decimales, "T");
					promCiclo = Double.parseDouble(promConRedondeo);
				}
				
				// Inserta columna del promedio de las evaluaciones
				if (!unionId.equals("8")){
					out.print("<td class='text-center' width='2%' title=''>"+formato2.format(promCiclo)+"</td>");
				}else{
					out.print("<td class='text-center' width='2%' title=''>"+formato4.format(promCiclo)+"</td>");
				}
				
			}
			// Completa las columnas del renglon de promedio  
			out.print("<td colspan='20'></td>");
%>
	</table>	
<%		} // for de ciclos
	} // Si existe el alumno
%>	
</div>

<%@ include file="../../cierra_elias.jsp" %>