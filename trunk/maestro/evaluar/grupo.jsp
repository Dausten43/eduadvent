<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>
<jsp:useBean id="GrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<%	

	java.text.DecimalFormat frmDecimal 	= new java.text.DecimalFormat("###,##0.0;-###,##0.0");
	java.text.DecimalFormat frmDecimal2 = new java.text.DecimalFormat("###,##0.00;-###,##0.00");
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);
	
	String escuelaId	= (String) session.getAttribute("escuela");
	String empleadoId 	= (String) session.getAttribute("codigoEmpleado");
	
	
	if(request.getParameter("Ciclo")!=null){
		session.setAttribute("cicloId", request.getParameter("Ciclo"));
	}
	String cicloId 		= (String)session.getAttribute("cicloId");
	
	String grupo 		= request.getParameter("Grupo")==null?"X":request.getParameter("Grupo");
	
	empPersonal.mapeaRegId(conElias, empleadoId);
	String maestro 		= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();
	
	
%>
<div id="content">
	<h2><fmt:message key="maestros.EvaluacionesporGrupos"/></h2>
	<div class="well">
	
		<select id="Ciclo" onchange="location.href='grupo.jsp?Ciclo='+this.options[this.selectedIndex].value" class="input-xxlarge">
			<%
				boolean tieneCiclo = false;
				ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListCiclosEmpleadoPlanta(conElias, empleadoId, "ORDER BY CICLO_ID");
				for(aca.ciclo.Ciclo ciclo: lisCiclo){
						if(ciclo.getCicloId().equals(cicloId)){
							tieneCiclo = true;
						}
			%>
						<option value="<%=ciclo.getCicloId() %>" <%if(ciclo.getCicloId().equals(cicloId))out.print("selected");%> ><%=ciclo.getCicloNombre() %></option>
			<%	
				} 
				
				if(tieneCiclo == false){
					cicloId = ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
					session.setAttribute("cicloId", cicloId);
				}
			%>
		</select>
		
		<a style="float:right;" href="cursos.jsp" class="btn btn-primary"><i class="icon-th-list icon-white"></i> Cursos</a>
		
	</div>
	
	
	<ul class="nav nav-tabs">
	<%		
		// Despliega la lista de grupos que ha inscrito el alumno en este periodo
		ArrayList<String> grupos = aca.ciclo.CicloGrupoLista.getMaestroGrupos(conElias, cicloId, empleadoId);
		
		for(String group: grupos){
			if (grupo.equals("X")) { 
				grupo = group;
			}
			cicloGrupo.mapeaRegId(conElias, group);
	%>
			<li <%if(grupo.equals(group))out.print("class='active'");%>>
			    <a href="grupo.jsp?&Grupo=<%=group %>">
			    	<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, group) %>
			    	<br />
			    	<span style="font-size:9px;"><%=aca.plan.Plan.getNombrePlan(conElias, cicloGrupo.getPlanId())%></span>
			    </a>
			</li>
	<%		
		}
		
		// Identifica y busca el grupo
		cicloGrupo.mapeaRegId(conElias, grupo);
	%>
	</ul>
	
	<%
	
	int maxEval	= aca.ciclo.CicloGrupo.getMaxEval(conElias, cicloGrupo.getCicloGrupoId());
	if(maxEval>0){
	%>
		<div class="pagination" style="text-align:right;margin-bottom:13px;">
		  	<ul>
		  			<li class="disabled"><a>Actas de Evaluaciones</a></li>
		  	<%
		  		for (int i=1; i<=maxEval;i++){	
		  	%>
		    		<li><a target="_blank" href="<%="acta.jsp?Ciclo="+cicloId+"&Evaluacion="+i %>"><%=i %></a></li>
		    <%
		  		}
		    %>
		  	</ul>
		</div>
	<%
	}
	%>
	

	
	<form>
		
	<%
		//Lista de materias del grupo y despliegue del encabezado
		ArrayList<aca.ciclo.CicloGrupoCurso> lisMaterias = cicloGrupoCursoLista.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_ID");
		
		//Lista de alumnos inscritos en el grupo
		ArrayList<String> lisAlumnos = kardexLista.getListAlumnosGrupo(conElias, cicloGrupo.getCicloGrupoId());	
		
		// lista de los Promedios del alumno en cada materias(calcula el promedio cuando la materia esta en proceso de evaluacion)
		java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm 	= AlumPromLista.getTreeCurso(conElias, cicloGrupo.getCicloGrupoId(),"");
		
		//lista de cursos del alumno y sus notas al cierre de la materia (determina el promedio cuando se cerro la materia)
		java.util.TreeMap<String, aca.kardex.KrdxCursoAct> treeCurso 	= kardexLista.getTreeAlumnoCurso(conElias, cicloGrupo.getCicloGrupoId(),"");
	

		// Almacena el nombre de las materias del grupo
		String materias[] = new String[lisMaterias.size()];
		
		//Almacena los promedios por materia
		double promMaterias[] = new double[lisMaterias.size()];
		
		//Almacena el total de alumnos por materia
		double alumMaterias[] = new double[lisMaterias.size()];
		
	%>		
		<table class="table table-condensed table-nohover ">
			<tr>
			    <th width="2%">#</th>
			    <th width="7%"><fmt:message key="aca.Matricula"/></th>
				<th ><fmt:message key="aca.Nombres"/></th>
			
		<%
			// Coloca el encabezado de la tabla de promedios por materia
			for(int i = 0; i < lisMaterias.size(); i++){
				cicloGrupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
				
				// inicializa a cero el promedio y el numero de alumnos en cada materia
				promMaterias[i] = 0; alumMaterias[i] = 0; materias[i]="x";
				
				// Obtiene el nombre de la materia
				materias[i] = aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
				
				// Identifica si el maestro que ingreso es quien imparte la materia y coloca diferentes privilegios
				if(aca.ciclo.CicloGrupoCurso.daEsteCurso(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), empleadoId)){
		%>
				<th width="3%">
					<a
						title="<%=materias[i] %> "
						href="evaluar.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>"
					>	
						<div style="width:100%;height:100%;text-align:center;">
						<%=i+1 %>
						</div>
					</a>
				</th>
		<%
				}else{
		%>
				<th width="3%">
					<div 
						style="width:100%;height:100%;text-align:center;"
						title="<%=materias[i] %> "
					>
						<%=i+1 %>
					</div>
				</th>
		<%
				}
			}	
		%>
				<th style="text-align:center;"><fmt:message key="aca.Promedio"/></th>
			</tr>
						
	<%
	
	String materia 		= "";
	
	double promGral=0, prom1=0, prom2=0, prom3=0;
	int todos=0, tipo1=0, tipo2=0, tipo3=0;
	String tipoCurso 	= "";
	String promMateria 	= "";
	String promGrupo 	= "";
	
	
	
	
		/*
			Despliega la matricula, nombre y promedio del alumno en cada materia, además calcula el promedio de la materia.
		*/
		String alumno 	= "";
		String nota		= "";
		double prom 	= 0.0;
		
		for(int j = 0; j < lisAlumnos.size(); j++){		
			alumno = (String) lisAlumnos.get(j);
			String nombreAlumno = aca.alumno.AlumPersonal.getNombre(conElias, alumno, "APELLIDO");
			
			// Calcula el promedio del alumno
			double promAlum = 0;
			int numMaterias = 0;
		
	%>
						<tr>
						  	<td align="center"><%=j+1%></td>
						  	<td align="center"><%=alumno%></td>
						  	<td>
						  		<a href="notas.jsp?CicloGrupoId=<%=cicloGrupo.getCicloGrupoId() %>&CodigoAlumno=<%=alumno %>">
						  			<%=nombreAlumno %>
						  		</a>
						  	</td>
	<%		
			for(int i = 0; i < lisMaterias.size(); i++){
				cicloGrupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
				
				// Si el alumno tiene la materia
				if (treeCurso.containsKey(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+alumno)){
					aca.kardex.KrdxCursoAct kardex = (aca.kardex.KrdxCursoAct) treeCurso.get(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+alumno);
					
					nota = "0"; prom = 0;
					
					// Si tiene la materia cuenta el alumno para promediar
					alumMaterias[i]++;
					
					// Si está en proceso de evaluación
					if(kardex.getTipoCalId().equals("1")){
						if (treeProm.containsKey(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+kardex.getCodigoId())){
							aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+alumno);
							prom = Double.parseDouble(alumProm.getPromedio())+Double.parseDouble(alumProm.getPuntosAjuste());
							nota =  String.valueOf(prom);
						}
						if(nota.trim().equals("0.0")||nota.trim().equals("0.5")) nota = "0";					
						
					// Si ya esta cerrado el ordinario	
					}else if(kardex.getTipoCalId().equals("2") || kardex.getTipoCalId().equals("3")){
						nota = kardex.getNota();
					
					// Si tiene nota extraordinaria	
					}else if(kardex.getTipoCalId().equals("4") || kardex.getTipoCalId().equals("5")){
						nota = kardex.getNotaExtra();
					}
					// Seccion para promediar de acuerdo al tipo de materia(Oficial, no oficial e ingles)
					// Pendiente de implementar en la presentación de los datos
					tipoCurso = aca.plan.PlanCurso.getTipocurso(conElias,kardex.getCursoId());
					if (nota!=null && !nota.equals("0")){
						if ( tipoCurso.equals("1")){
							tipo1++;
							prom1 += Double.valueOf(nota).doubleValue();
						}else if(tipoCurso.equals("2")){
							tipo2++;
							prom2 += Double.valueOf(nota).doubleValue();
						}else if(tipoCurso.equals("3")){
							tipo3++;
							prom3 += Double.valueOf(nota).doubleValue();
						}
						promMaterias[i] += Double.valueOf(nota).doubleValue();
					}
					//System.out.println("Datos:"+lisMaterias.size()+":"+alumno+":"+materias[i]+":"+nota);
	%>
							<td>
								<div 
									style="width:100%;height:100%;text-align:center;"
									title="<%=materias[i] %> "
								>
								<%=frmDecimal.format(Double.valueOf(nota))%>
								</div>
							</td>
	<%				
					//Calcula el promedio del alumno
					promAlum += Double.valueOf(nota);
					numMaterias++;
					
				}else{
	%>				
							<td>
								<div 
									style="width:100%;height:100%;text-align:center;"
									title="<%=materias[i] %> "
								>
								X
								</div>
							</td>
	<%						
				}
			} // fin de for de lista de materias
			promAlum = promAlum/numMaterias;
	%>
							<td>
								<div 
									style="width:100%;height:100%;text-align:center;"
									title="<%=nombreAlumno%>"
								>
								<%=frmDecimal.format(promAlum)%>
								</div>
							</td>
						</tr>
	<%		
		} // fin de for de Alumnos del grupo	
	%>
						
						<tr>
							<th colspan="3"><fmt:message key="aca.Promedio"/></th>
							
						
	<%				
					int totMaterias=lisMaterias.size();
					for(int i = 0; i < lisMaterias.size(); i++){
						if(alumMaterias[i]!=0){
							promMaterias[i] 	= promMaterias[i]/alumMaterias[i];
						}
						else{
							promMaterias[i] 	= 0;
						}
						promMateria 		= frmDecimal2.format(promMaterias[i]);
						
						if (Double.parseDouble(promMateria) < 1){ 
							totMaterias--;
						}else{
							promGral 			+=  Double.valueOf(promMateria).doubleValue();
						}	
						
	%>
							<th>
								<div 
									style="width:100%;height:100%;text-align:center;"
									title="<%=materias[i]%>"
								>
								<%=promMateria%>
								</div>
							</th>
	<%				}
					if(totMaterias!=0){
						promGral 		= promGral / totMaterias;
					}
					else{
						promGral 		= 0;
					}
					promGrupo 		= frmDecimal2.format(promGral);
	%>										
						<th>
							<div 
								style="width:100%;height:100%;text-align:center;"
								title="Promedio General"
							>
							<%=promGrupo%>
							</div>
						</th>
					  </tr>					
					</table>
				
			
		
				<br>
				
				<hr />
				<h2><fmt:message key="aca.Materias"/></h2>
		
		
			 
					<table class="table table-condensed table-nohover">
						<tr>
							<th>#</th>
							<th><fmt:message key="aca.Materia"/></th>
							<th><fmt:message key="maestros.MaestroPlaneacionMeto"/></th>
							<th><fmt:message key="maestros.Evaluaciones"/></th>
						</tr>
	<%
			for(int i = 0; i < lisMaterias.size(); i++){
				
				cicloGrupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
				materia	= aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
				
				if(aca.ciclo.CicloGrupoCurso.daEsteCurso(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), empleadoId)){
	%>
						<tr>
							<td> <%=i+1 %></td>
							<td><a href="evaluar.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>"><%=materia%></a></td>
							<td>
							  <a href="modulo.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>"><fmt:message key="maestros.Planeacion"/></a>&nbsp;
	<% 
					String metodo = aca.catalogo.CatNivel.getMetodo(conElias, aca.catalogo.CatNivel.getNivelId(conElias, cicloGrupoCurso.getCursoId()));				
					if(metodo.equals("S")){
	%>							
					  <a href="metodo.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&Materia=<%=materia%>&Maestro=<%=maestro%>&Ciclo=<%=cicloId %>"><fmt:message key="maestros.Metodologia"/></a>
	<% 
					}else{
	%>
					  <a href="metodologia.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>&Materia=<%=materia%>&Maestro=<%=maestro%>&Ciclo=<%=cicloId %>"><fmt:message key="maestros.Metodologia"/></a>	
	<%					
					}
	%>						  						  						  
							</td>				
	<%
				}else{
	%>
						<tr>
							<td><%=i+1 %></td>
							<td><%=materia %></td>
							<td> <%=cicloGrupoCurso.getEmpleadoId()%> | <%= aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(),"NOMBRE") %></td>
	<%			}	%>
							<td>
							    <a target="_blank" href="actamateria.jsp?CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId()%>&Curso=<%=cicloGrupoCurso.getCursoId()%>"><fmt:message key="aca.ImprimirActa"/></a>					
							</td>						  
						</tr>	
	<%		}	%>
					</table>
	</form>
	
	
	
</div>


<%@ include file="../../cierra_elias.jsp" %>