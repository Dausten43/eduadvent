<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="kardexEvalLista" scope="page"	class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="cicloBloqueList" scope="page" class="aca.ciclo.CicloBloqueLista" />
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloPromedio" scope="page" class="aca.ciclo.CicloPromedio"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>
<jsp:useBean id="GrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo"/>

<%@page import="java.util.TreeMap"%>
<%	
	
	if(request.getParameter("Ciclo")!=null){
		session.setAttribute("cicloId", request.getParameter("Ciclo"));
	}
	String cicloId 		= (String)session.getAttribute("cicloId");
	Ciclo.mapeaRegId(conElias, cicloId);
	String escuelaId	= (String) session.getAttribute("escuela");
	String empleadoId 	= (String) session.getAttribute("codigoId");
	String grupo 		= request.getParameter("Grupo")==null?"X":request.getParameter("Grupo");
	String cicloGrupoId = (String) request.getParameter("CicloGrupoId");
	
	String bloque 		= request.getParameter("bloque")==null?"0":request.getParameter("bloque");
	cicloBloque.mapeaRegId(conElias, cicloId, bloque);
	
	String promedioId	= request.getParameter("Promedio")==null?"0":request.getParameter("Promedio");
	CicloPromedio.mapeaRegId(conElias, cicloId, promedioId);
	if(promedioId.equals("0")){
		bloque = "0";
	}
	empPersonal.mapeaRegId(conElias, empleadoId);
	String maestro 		= empPersonal.getNombre()+" "+empPersonal.getApaterno()+" "+empPersonal.getAmaterno();

	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 		= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
	// Lista de bloques o evaluaciones
	ArrayList<aca.ciclo.CicloBloque> listBloques 		= cicloBloqueList.getListCiclo(conElias, cicloId, promedioId, "ORDER BY BLOQUE_ID");
	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap<String, aca.kardex.KrdxAlumEval> treeNota 		= kardexEvalLista.getTreeMateria(conElias, cicloGrupoId, "");
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);

	java.text.DecimalFormat frmCiclo 	= new java.text.DecimalFormat();
	java.text.DecimalFormat frmPromedio = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	java.math.MathContext mc = new java.math.MathContext(8,RoundingMode.HALF_UP);
	
	//checa cuantos decimales tiene el ciclo
	if(Ciclo.getDecimales().equals("0")){
		frmCiclo.applyPattern("###,##0;-###,##0");
	}else if(Ciclo.getDecimales().equals("1")){
		frmCiclo.applyPattern("###,##0.0;-###,##0.0");
	}
	
	if(Ciclo.getDecimales().equals("2")){
		frmCiclo.applyPattern("###,##0.00;-###,##0.00");
	}else if(Ciclo.getDecimales().equals("3")){
		frmCiclo.applyPattern("###,##0.000;-###,##0.000");
	}	
	
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
	<%// Despliega la lista de grupos que ha inscrito el alumno en este periodo
		ArrayList<String> grupos = aca.ciclo.CicloGrupoLista.getMaestroGrupos(conElias, cicloId, empleadoId);
		for(String group: grupos){
			if (grupo.equals("X")) { 
				grupo = group;
			}
			cicloGrupo.mapeaRegId(conElias, group);
		%>	<li <%if(grupo.equals(group))out.print("class='active'");%>>
			    <a href="grupo.jsp?&Grupo=<%=group %>">
			    	<%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, group) %><br />
			    	<span style="font-size:9px;"><%=aca.plan.Plan.getNombrePlan(conElias, cicloGrupo.getPlanId())%></span>
			    </a>
			</li>
		<%		
		}
		// Identifica y busca el grupo
		cicloGrupo.mapeaRegId(conElias, grupo);
	%>
	</ul>
	
	<div class="col-md-6" style="display:inline-block;margin-bottom:13px;padding:0px;">
		<form name="forma" method="POST">
			<select name="Promedio" id="Promedio" onchange='javascript:document.forma.submit();'>
				<option value="0" ><fmt:message key="boton.Todos" /></option>
				<%for (aca.ciclo.CicloPromedio prom : lisPromedio){%>
					<option value="<%=prom.getPromedioId() %>" <%if(prom.getPromedioId().equals(promedioId)){out.print("selected");} %>><%=prom.getNombre() %></option>
				<%}%>
			</select>
			
			<%if(!promedioId.equals("0")){ %>
			<select name="bloque" id="bloque" onchange='javascript:document.forma.submit();'>
				<option value="0"><fmt:message key="boton.Todos" /></option>
				<%for (aca.ciclo.CicloBloque bloq : listBloques){%>
					<option value="<%=bloq.getBloqueId() %>" <%if(bloq.getBloqueId().equals(bloque)){out.print("selected");} %>><%=bloq.getBloqueNombre() %></option>
				<%}%>
			</select>
			<%} %>
		</form>
	</div>
	
	<%
	int maxEval	= aca.ciclo.CicloGrupo.getMaxEval(conElias, cicloGrupo.getCicloGrupoId());
	if(maxEval>0){
		%>
		<div class="pagination" style="text-align:right;margin-bottom:13px;display:inline-block;float:right;">
		  	<ul>
		  		<li class="disabled"><a>Actas de Evaluaciones</a></li>
		  	<%for (int i=1; i<=maxEval;i++){%>
		    	<li><a target="_blank" href="<%="acta.jsp?Ciclo="+cicloId+"&Evaluacion="+i %>"><%=i %></a></li>
		    <%}%>
		  	</ul>
		</div>
		<%
	}
	%>

	<form>
	<%  //Lista de materias del grupo y despliegue del encabezado
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
		
	%>	<table class="table table-condensed table-nohover ">
			<tr>
			    <th width="2%">#</th>
			    <th width="7%"><fmt:message key="aca.Matricula"/></th>
				<th ><fmt:message key="aca.Nombres"/></th>
		<% // Coloca el encabezado de la tabla de promedios por materia
		for(int i = 0; i < lisMaterias.size(); i++){
			cicloGrupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
			// inicializa a cero el promedio y el numero de alumnos en cada materia
			promMaterias[i] = 0; alumMaterias[i] = 0; materias[i]="x";
			// Obtiene el nombre de la materia
			materias[i] = aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId());
			// Identifica si el maestro que ingreso es quien imparte la materia y coloca diferentes privilegios
			if(aca.ciclo.CicloGrupoCurso.daEsteCurso(conElias, cicloGrupoCurso.getCicloGrupoId(), cicloGrupoCurso.getCursoId(), empleadoId)){
			
		%>		<th width="3%">
					<a title="<%=materias[i] %> " 
					href="evaluar.jsp?CursoId=<%=cicloGrupoCurso.getCursoId() %>&CicloGrupoId=<%=cicloGrupoCurso.getCicloGrupoId() %>">	
						<div style="width:100%;height:100%;text-align:center;">
						<%=i+1 %>
						</div>
					</a>
				</th>
		<%	}else{
		%> 		<th width="3%">
					<div style="width:100%;height:100%;text-align:center;" title="<%=materias[i] %> ">
						<%=i+1 %>
					</div>
				</th>
		<% 	}
		}
		%> 		<th style="text-align:center;"><fmt:message key="aca.Promedio"/></th>
			</tr>
	<%
	
		String materia 		= "";
		
		BigDecimal promGral= new BigDecimal(0,mc);
		BigDecimal prom1= new BigDecimal(0,mc);
		BigDecimal prom2= new BigDecimal(0,mc);
		BigDecimal prom3= new BigDecimal(0,mc);
		
		int todos=0, tipo1=0, tipo2=0, tipo3=0;
		String tipoCurso 	= "";
		String promMateria 	= "";
		String promGrupo 	= "";
		/*
			Despliega la matricula, nombre y promedio del alumno en cada materia, además calcula el promedio de la materia.
		*/
		String alumno 	= "";
		String nota		= "";
		BigDecimal prom = new BigDecimal(0,mc);
		int escalaEval 			= aca.ciclo.Ciclo.getEscala(conElias, cicloId );
		
		for(int j = 0; j < lisAlumnos.size(); j++){		
			alumno = (String) lisAlumnos.get(j);
			String nombreAlumno = aca.alumno.AlumPersonal.getNombre(conElias, alumno, "APELLIDO");
			String strNota 			= "-";
			BigDecimal promAlum = new BigDecimal("0", mc);
			int numMaterias = 0;
	%> 		<tr>
			  	<td align="center"><%=j+1%></td>
			  	<td align="center"><%=alumno%></td>
			  	<td>
			  		<a href="notas.jsp?CicloGrupoId=<%=cicloGrupo.getCicloGrupoId() %>&CodigoAlumno=<%=alumno %>">
			  			<%=nombreAlumno %>
			  		</a>
			  	</td>
	<%		for(int i = 0; i < lisMaterias.size(); i++){
				cicloGrupoCurso = (aca.ciclo.CicloGrupoCurso) lisMaterias.get(i);
				String punto = aca.plan.PlanCurso.getPunto(conElias, cicloGrupoCurso.getCursoId());
				// Si el alumno tiene la materia
				if (treeCurso.containsKey(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+alumno)){
					aca.kardex.KrdxCursoAct kardex = (aca.kardex.KrdxCursoAct) treeCurso.get(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+alumno);
					aca.plan.PlanCurso curso = new aca.plan.PlanCurso();
					curso.mapeaRegId(conElias, kardex.getCursoId());
					nota = "0"; 
					prom = new BigDecimal(0, mc); 
					strNota = "-";
					// Si tiene la materia cuenta el alumno para promediar
					alumMaterias[i]++;
					/*   Si se quiere el promedio gral. hasta el momento   */
					if(promedioId.equals("0")){ 
						// Si está en proceso de evaluación o dado de baja
						if(kardex.getTipoCalId().equals("1")||kardex.getTipoCalId().equals("6")){
							if (treeProm.containsKey(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+kardex.getCodigoId())){
								aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(cicloGrupo.getCicloGrupoId()+cicloGrupoCurso.getCursoId()+alumno);
								prom = new BigDecimal(alumProm.getPromedio(),mc).add(new BigDecimal(alumProm.getPuntosAjuste(), mc), mc);
								if(escuelaId.contains("S")){
									prom = new BigDecimal(alumProm.getPuntosAlum(), mc).add(new BigDecimal(alumProm.getPuntosAjuste(), mc), mc);
									if(escalaEval==10){
										prom = prom.divide(new BigDecimal(10, mc));
									}
								}
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
						
						if(Ciclo.getRedondeo().equals("T")){
							nota = new BigDecimal(nota).setScale(Integer.valueOf(Ciclo.getDecimales()), RoundingMode.DOWN).toString();
						} else{
							nota = new BigDecimal(nota).setScale(Integer.valueOf(Ciclo.getDecimales()), RoundingMode.HALF_UP).toString();
						}
						
						// Seccion para promediar de acuerdo al tipo de materia(Oficial, no oficial e ingles)
						// Pendiente de implementar en la presentación de los datos
						tipoCurso = curso.getTipocursoId();
						if (nota!=null && !nota.equals("0")){
							if ( tipoCurso.equals("1")){
								tipo1++;
								prom1 = prom1.add(new BigDecimal(nota),mc);
							}else if(tipoCurso.equals("2")){
								tipo2++;
								prom2 = prom2.add(new BigDecimal(nota),mc);
							}else if(tipoCurso.equals("3")){
								tipo3++;
								prom3 = prom3.add(new BigDecimal(nota),mc);
							}
							promMaterias[i] += Double.valueOf(nota).doubleValue();
						}
					}
					
					/*   Si se selecciona algun periodo de evaluación (Promedios)    */
					else if(bloque.equals("0")){
						if(mapPromAlumno.containsKey(alumno+cicloGrupoCurso.getCursoId()+promedioId)){
							strNota = mapPromAlumno.get(alumno+cicloGrupoCurso.getCursoId()+promedioId).getNota();
							if(CicloPromedio.getRedondeo().equals("T")){
								nota = new BigDecimal(strNota).setScale(Integer.valueOf(CicloPromedio.getDecimales()), RoundingMode.DOWN).toString();
							} else{
								nota = new BigDecimal(strNota).setScale(Integer.valueOf(CicloPromedio.getDecimales()), RoundingMode.HALF_UP).toString();
							}
						}
						promMaterias[i] += Double.valueOf(nota).doubleValue();
					}
					/*  Si se selecciona algun periodo de evaluación (Bloques)   */
					else if(!bloque.equals("0")){
						if (treeNota.containsKey(cicloGrupoId + cicloGrupoCurso.getCursoId() + bloque + alumno)) {
							aca.kardex.KrdxAlumEval krdxEval = (aca.kardex.KrdxAlumEval) treeNota.get(cicloGrupoId + cicloGrupoCurso.getCursoId() + bloque + alumno);
							if(cicloBloque.getRedondeo().equals("T")){
								nota = new BigDecimal(krdxEval.getNota()).setScale(Integer.valueOf(cicloBloque.getDecimales()), RoundingMode.DOWN).toString();
							} else{
								nota = new BigDecimal(krdxEval.getNota()).setScale(Integer.valueOf(cicloBloque.getDecimales()), RoundingMode.HALF_UP).toString();
							}
						}
						if(!nota.equals("-")){
							strNota = nota;
						}
						promMaterias[i] += Double.valueOf(nota).doubleValue();
					}
	%>						<td>
								<div style="width:100%;height:100%;text-align:center;" title="<%=materias[i] %> ">
									<%= nota %>
								</div>
							</td>
	<% 				//Calcula el promedio del alumno
					if(curso.getCursoBase().equals("-") && curso.getBoleta().equals("S")){ // Si es materia madre y se muestra en boleta
						promAlum = promAlum.add(new BigDecimal(nota, mc), mc);
						numMaterias++;
					}
					
				}else{
	%> 						<td>
								<div style="width:100%;height:100%;text-align:center;" title="<%=materias[i] %> ">
								X
								</div>
							</td>
	<%			}
			} // fin de for de lista de materias
			if(numMaterias != 0){
				String redondeo = "A";
				int decimales = 0;
				if(promedioId.equals("0")){
					redondeo = Ciclo.getRedondeo();
					decimales = Integer.valueOf(Ciclo.getDecimales());
				} else if(bloque.equals("0")){
					redondeo = CicloPromedio.getRedondeo();
					decimales = Integer.valueOf(CicloPromedio.getDecimales());
				} else if(!bloque.equals("0")){
					redondeo = cicloBloque.getRedondeo();
					decimales = Integer.valueOf(cicloBloque.getDecimales());
				}
				promAlum = promAlum.divide(new BigDecimal(numMaterias+"", mc), mc);
				if(redondeo.equals("T")){
					promAlum = new BigDecimal(promAlum.toString()).setScale(decimales, RoundingMode.DOWN);
				} else{
					promAlum = new BigDecimal(promAlum.toString()).setScale(decimales, RoundingMode.HALF_UP);
				}
			}
	%> 						<td>
								<div 
									style="width:100%;height:100%;text-align:center;"
									title="<%=nombreAlumno%>"
								><%=promAlum%>
								</div>
							</td>
						</tr>
	<%		
		} // fin de for de Alumnos del grupo	
%>					<tr>
							<th colspan="3"><fmt:message key="aca.Promedio"/></th>		
	<%				int totMaterias=lisMaterias.size();
					for(int i = 0; i < lisMaterias.size(); i++){
						if(alumMaterias[i]!=0){
							promMaterias[i] 	= promMaterias[i]/alumMaterias[i];
						}
						else{
							promMaterias[i] 	= 0;
						}
						promMateria 		= frmPromedio.format(promMaterias[i]);
						
						if (Double.parseDouble(promMateria) < 1){ 
							totMaterias--;
						}else{
							promGral = new BigDecimal(promMateria);
						}	
						
	%>						<th>
								<div 
									style="width:100%;height:100%;text-align:center;"
									title="<%=materias[i]%>"
								>
								<%=promMateria%>
								</div>
							</th>
	<%				}
					if(totMaterias!=0){
						promGral= promGral.divide(new BigDecimal(totMaterias),mc);
						
					}
					else{
						promGral 		= new BigDecimal(0);
					}
					promGrupo 		= frmPromedio.format(promGral);
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