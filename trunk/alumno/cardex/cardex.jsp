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
<%	
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0");
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00");

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoAlumno");
	
	String planId			= request.getParameter("plan")==null?aca.alumno.AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
	String nivel			= aca.plan.Plan.getNivel(conElias, planId);
	String nivelNombre		= aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel);
	String nivelTitulo		= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivel).toUpperCase();
	boolean existeAlumno 	= false;			
	
	/* Planes de estudio del alumno */
	ArrayList<aca.alumno.AlumPlan> lisPlan					= AlumPlanL.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");
	
	/* Ciclos en los que el alumno ha estudiado */
	ArrayList<aca.alumno.AlumCiclo> lisCiclos				= AlumCicloL.listCiclosConMaterias(conElias, codigoId, planId, "1,2,3,4,5", " ORDER BY CICLO_ID");
	
	//Map de materias del plan seleccionado
	java.util.HashMap<String, aca.plan.PlanCurso> mapCurso	= aca.plan.PlanCursoLista.mapPlanCursos(conElias, planId);
	
	/* Array de Esquema o calculo de promedio */
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio			= new ArrayList<aca.ciclo.CicloPromedio>();
	
	/* Array de Bloques de la materia */
	ArrayList<aca.ciclo.CicloBloque> lisBloque				= new ArrayList<aca.ciclo.CicloBloque>();
	
	/* Notas el alumno en las materias */
	ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso 		= AlumnoCursoL.getListAlumCurso(conElias, codigoId, " ORDER BY TIPO_CURSO_ID(CURSO_ID), ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	
	//Map de evaluaciones del alumno
	java.util.HashMap<String, aca.kardex.KrdxAlumEval> mapEval		= aca.kardex.KrdxAlumEvalLista.mapEvalAlumno(conElias, codigoId);
	
	//Map que suma las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalSuma			= aca.kardex.KrdxAlumEvalLista.mapEvalSumaNotas(conElias, codigoId);
	
	//Map que cuenta las notas de un alumno en un bloque o bimestre (por cada tipo de curso)
	java.util.HashMap<String, String> mapEvalCuenta			= aca.kardex.KrdxAlumEvalLista.mapEvalCuentaNotas(conElias, codigoId);
	
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
			String grado 		= aca.catalogo.CatNivel.getGradoNombre( Integer.parseInt(ciclo.getGrado()) )+" "+nivelTitulo;
			
			// Clave del grupo donde se inscribio el alumno
			String cicloGrupoId	= aca.ciclo.CicloGrupo.getCicloGrupoId(conElias, ciclo.getNivel(), ciclo.getGrado(), ciclo.getGrupo(), ciclo.getCicloId(), planId);
			
			// Lista de promedios en el ciclo
			lisPromedio 		= CicloPromedioL.getListCiclo(conElias, ciclo.getCicloId(), " ORDER BY PROMEDIO_ID");
			
			// Lista de evaluaciones o bloques en el ciclo
			lisBloque 			= CicloBloqueL.getListCiclo(conElias, ciclo.getCicloId(), "ORDER BY BLOQUE_ID");			
%>			
	<div class="alert alert-info"><%= cicloNombre %> - <%= nivelNombre %> - <%= grado %> "<%= ciclo.getGrupo() %>"</div>
				
	<table class="table table-condensed table-bordered">
		<thead>
			<tr>
				<th width="2%">#</th>
			    <th width="6%"><fmt:message key="aca.Materia"/></th>
			    <th width="20%"><fmt:message key="aca.NombreMateria"/></th>
<%
			for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					
				for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
					if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
						// Inserta columnas de evaluaciones
						out.print("<th class='text-center' width='1%' title='"+cicloBloque.getBloqueNombre()+"'>"+cicloBloque.getBloqueId()+"</th>");		
					}
				}			
				// Inserta columna del promedio de las evaluaciones
				out.print("<th class='text-center' width='1%' title='"+cicloPromedio.getNombre()+"'>"+cicloPromedio.getCorto()+"</th>");
%>
				<th class="text-center" width="5%"><fmt:message key="aca.Nota"/></th>
				<th class="text-center" width="5%"><fmt:message key="aca.FechaNota"/></th>
				<th class="text-center" width="5%"><fmt:message key="aca.Extra"/></th>
				<th class="text-center" width="5%"><fmt:message key="aca.FechaExtra"/></th>
			</tr>
		</thead>
<%							
			}
			String tipoCurso = "0";
			int row = 0, cont=0;
			for (aca.vista.AlumnoCurso alumCurso : lisAlumnoCurso){
				cont++;
				//Verifica que la materia sea del grupo de materias que registró en el ciclo escolar
				if (alumCurso.getCicloGrupoId().equals(cicloGrupoId)){	
					row++;
					aca.plan.PlanCurso curso = new aca.plan.PlanCurso();
					if (mapCurso.containsKey(alumCurso.getCursoId())){
						curso = mapCurso.get(alumCurso.getCursoId());						
						// Asigna el tipo de curso de la materia actual						
					}
					
					// Poner Totales
					if (!tipoCurso.equals(curso.getTipocursoId()) && !tipoCurso.equals("0")){
						
						out.print("<tr class='alert alert-success'>");
						out.print("<td colspan='3'>Promedio:</td>");
						
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
									}
									// Inserta columnas de evaluaciones
									out.print("<td class='text-center' width='1%' title=''>"+formato2.format(promEval)+"</td>");
								}
							}			
							// Inserta columna del promedio de las evaluaciones
							out.print("<td class='text-center' width='1%' title=''>-</td>");
						}
						
						// Completa las columnas del renglon de promedio  
						out.print("<td colspan='20'></td>");
					}
					
					// Tipo de curso
					tipoCurso = curso.getTipocursoId();
%>
		<tr> 
		    <td><%=row %></td>
		    <td><%=alumCurso.getCursoId()%></td>
		    <td><%=curso.getCursoNombre()%>-<%= curso.getTipocursoId()%></td>
<%
					for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
							
						for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
							if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
								double notaEval = 0;
								if (mapEval.containsKey(codigoId+cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId())){
									notaEval = Double.parseDouble(mapEval.get(codigoId+cicloGrupoId+alumCurso.getCursoId()+cicloBloque.getBloqueId()).getNota());
								}
								// Inserta columnas de evaluaciones
								out.print("<td class='text-center' width='1%' title=''>"+notaEval+"</td>");
							}
						}			
						// Inserta columna del promedio de las evaluaciones
						out.print("<td class='text-center' width='1%' title=''>-</td>");
					}	
%>
			<td class="text-center" width="5%">-</td>
			<td class="text-center" width="5%">-</td>
			<td class="text-center" width="5%">-</td>
			<td class="text-center" width="5%">-</td>
		</tr>				
<%						
				}else{
					// Poner promedio general
					
					
				}
			}
%>
	</table>	
<%		} // for de ciclos
	} // Si existe el alumno
%>	
</div>

<%@ include file="../../cierra_elias.jsp" %>