<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="kardexEvalLista" scope="page" class="aca.kardex.KrdxAlumEvalLista"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>


<script>
	function materia(cicloGrupoId,cursoId){
		document.location.href="materia.jsp?CicloGrupoId="+cicloGrupoId+"&CursoId="+cursoId;
	}
</script>
<%	
	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0");
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00");	

	String cicloGrupoId		= (String) request.getParameter("CicloGrupoId");
	String cursoId			= (String) request.getParameter("CursoId");
	String cicloId			= (String) session.getAttribute("cicloId");	
	
	// Escala
	int escalaEval 			= 100;  //aca.ciclo.Ciclo.getEscala(conElias, cicloId );
	int evalcerradas		= 0;
	
	ArrayList<aca.kardex.KrdxCursoAct> lisAlum				= CursoActLista.getListAlumMat(conElias, cicloGrupoId, cursoId, " ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	
	Grupo.setCicloGrupoId(cicloGrupoId);
	Grupo.mapeaRegId(conElias, cicloGrupoId);
	
	// TreeMap para obtener la nota de un alumno en la materia
	java.util.TreeMap<String, aca.kardex.KrdxAlumEval> treeNota		= kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, cursoId, "");
	
	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
		
	// Lista de evaluaciones o bloques en el ciclo
	ArrayList<aca.ciclo.CicloBloque> lisBloque 			= CicloBloqueL.getListCiclo(conElias, cicloId, " ORDER BY BLOQUE_ID");
	
	// Map de evaluaciones del alumno en Ciclo_Grupo_Eval
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalCurso(conElias, cicloGrupoId, cursoId);
	
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);	
%>

<div id="content">
	<h2><fmt:message key="maestros.EvaluaciondelSemestre" /></h2>
	
	<div class="alert alert-info">
		<%=aca.plan.PlanCurso.getCursoNombre(conElias,cursoId)%>
	</div>
	
	<div class="well">
		<a href="materias.jsp?CicloGrupoId=<%=cicloGrupoId %>" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<table class="table table-condensed table-striped table-bordered">
  	<thead>
		<tr>
	       	<th width="2%" align="center">#</th>
	   		<th width="4%" align="center"><fmt:message key="aca.Matricula" /></th>
	   		<th width="24%" align="center"><fmt:message key="aca.NombreDelAlumno" /></th>
<%
			for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					
				for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
					if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
						// Inserta columnas de evaluaciones
						out.print("<th class='text-center' width='2%' title='"+cicloBloque.getBloqueNombre()+"'>"+cicloBloque.getCorto()+"</th>");
					}
				}			
				// Inserta columna del promedio de las evaluaciones
				out.print("<th class='text-center' width='2%' >"+cicloPromedio.getCorto()+"</th>");
%>				
				<th class='text-center' width='2%' ><fmt:message key='aca.Puntos'/></th>
<%				
			}
			if (lisPromedio.size() > 1){
%>				
				<th class='text-center' width='2%'><fmt:message key='aca.Nota'/></th>
<%					
			}			
%>
		</tr>
	</thead>
		<%
			double totalGeneral = 0;
			int cont = 0;
			for (aca.kardex.KrdxCursoAct alumno : lisAlum){
				cont++;
		%>
		<tr>
    		<td><%=cont%></td>
    		<td><%=alumno.getCodigoId()%></td>
    		<td><%=aca.alumno.AlumPersonal.getNombre(conElias,alumno.getCodigoId(),"APELLIDO")%></td>
<%
				for(aca.ciclo.CicloPromedio cicloPromedio : lisPromedio){
					int evalCerradas = 0;
					for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
						if (cicloBloque.getPromedioId().equals(cicloPromedio.getPromedioId())){
							
							// Nota del alumno en la evaluacion
							double notaEval = 0;
							if (treeNota.containsKey(cicloGrupoId+cursoId+cicloBloque.getBloqueId()+ alumno.getCodigoId())){
								notaEval = Double.parseDouble(treeNota.get(cicloGrupoId+cursoId+cicloBloque.getBloqueId()+alumno.getCodigoId()).getNota());
							}
							// Verifica si la nota de la evaluacion es temporal o definitiva(abierta o cerrada)
							String estadoEval = "A";							
							if (mapEvalCiclo.containsKey(cicloGrupoId+alumno.getCursoId()+cicloBloque.getBloqueId())){
								estadoEval 	= mapEvalCiclo.get(cicloGrupoId+alumno.getCursoId()+cicloBloque.getBloqueId()).getEstado();								
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
%>
							<td class='text-center' width='1%'  style='<%=colorEval%>'>
									<%= notaFormato %>
							</td>
<%						
						}
					}
					
					// Obtiene el promedio del alumno en las evaluaciones (tabla Krdx_Alum_Prom)
					double promEval = 0; 
					if (mapPromAlumno.containsKey(alumno.getCodigoId()+alumno.getCursoId()+cicloPromedio.getPromedioId())){
						promEval = Double.parseDouble(mapPromAlumno.get(alumno.getCodigoId()+alumno.getCursoId()+cicloPromedio.getPromedioId()).getNota());											}
					
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
				}
				if (lisPromedio.size() > 1){
					out.print("<td class='text-center' width='2%'>"+alumno.getNota()+"</td>");
				}				
%>
	 		</tr>
<%
			}
%>	 		
	</table>

</div>


<%@ include file= "../../cierra_elias.jsp" %> 