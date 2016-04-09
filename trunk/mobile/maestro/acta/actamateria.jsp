<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@page import="aca.catalogo.CatNivel"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.kardex.KrdxAlumEval"%>
<%@page import="aca.util.Fecha"%>
<%@page import="aca.empleado.EmpPersonal"%>
<%@page import="aca.ciclo.CicloGrupoEval"%>
<%@page import="java.text.*"%>
<%@page import="java.util.TreeMap"%>

<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval" />
<jsp:useBean id="cicloGrupoEvalLista" scope="page" class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="KrdxAlumEval" scope="page" class="aca.kardex.KrdxAlumEval" />
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan" />
<jsp:useBean id="kardexLista" scope="page" class="aca.kardex.KrdxAlumEvalLista" />
<jsp:useBean id="krdxCursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="fecha" scope="page" class="aca.util.Fecha" />
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.CicloBloqueLista" />
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista" />
<jsp:useBean id="CicloPromedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>
<jsp:useBean id="CicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<%
	DecimalFormat frmDecimal = new DecimalFormat("###,##0.0;(###,##0.0)");
	DecimalFormat frmEntero = new DecimalFormat("###,##0;(###,##0)");
	
	frmDecimal.setRoundingMode(java.math.RoundingMode.DOWN);

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoEmpleado");
	String escuelaNom 		= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId);
	String cicloId 			= (String) session.getAttribute("cicloId");

	String cicloGrupoId = request.getParameter("CicloGrupoId");
	String cursoId = request.getParameter("CursoId");
	


	double[] prom = new double[10];
	double promTmp = 0;
	double promGral = 0;

	Escuela.mapeaRegId(conElias, escuelaId);
	empPersonal.mapeaRegId(conElias, codigoId);
	cicloGrupo.mapeaRegId(conElias, cicloGrupoId);
	cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);

	String estadoNombre = aca.catalogo.CatEstado.getEstado(conElias, Escuela.getPaisId(), Escuela.getEstadoId());
	String ciudadNombre = aca.catalogo.CatCiudad.getCiudad(conElias, Escuela.getPaisId(), Escuela.getEstadoId(), Escuela.getCiudadId());
	float notaAC 		= Float.parseFloat(aca.plan.PlanCurso.getNotaAC(conElias, cursoId)); /* La nota con la que se acredita el cursoId */


	// Lista de promedios en el ciclo
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio 			= CicloPromedioL.getListCiclo(conElias, cicloId, " ORDER BY PROMEDIO_ID");
	
	// Lista de evaluaciones o bloques en el ciclo
	ArrayList<aca.ciclo.CicloBloque> lisBloque 				= CicloBloqueL.getListCiclo(conElias, cicloId, " ORDER BY BLOQUE_ID");

	// TreeMap para verificar si el alumno lleva la materia
	TreeMap<String, aca.kardex.KrdxCursoAct> treeAlumCurso 	= krdxCursoActLista.getTreeAlumnoCurso(conElias, cicloGrupoId, "");

	// TreeMap para obtener la nota de un alumno en la materia
	TreeMap<String, aca.kardex.KrdxAlumEval> treeNota = kardexLista.getTreeMateria(conElias, cicloGrupoId, "");
	
	//LISTA DE ALUMNOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos		= krdxCursoActL.getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
	
	// Map de evaluaciones del alumno en Ciclo_Grupo_Eval
	java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapEvalCiclo	= aca.ciclo.CicloGrupoEvalLista.mapEvalCurso(conElias, cicloGrupoId, cursoId);
	
	//Map de promedios del alumno en cada materia
	java.util.HashMap<String, aca.kardex.KrdxAlumProm> mapPromAlumno	= aca.kardex.KrdxAlumPromLista.mapPromGrupo(conElias, cicloGrupoId);	
	
	java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm = AlumPromLista.getTreeCurso(conElias,	cicloGrupoId, cursoId, "");
	String evaluaConPunto		= aca.plan.PlanCurso.getPunto(conElias, cursoId); /* Evalua con punto decimal el cursoId */
	
	java.text.DecimalFormat formato0	= new java.text.DecimalFormat("##0;-##0");
	java.text.DecimalFormat formato1	= new java.text.DecimalFormat("##0.0;-##0.0");
	java.text.DecimalFormat formato2	= new java.text.DecimalFormat("##0.00;-##0.00");
	
	int escala 					= aca.ciclo.Ciclo.getEscala(conElias, cicloId); /* La escala de evaluacion del ciclo (10 o 100) */
	
	// Escala para la columna de puntos
	int escalaEval 			= 100;	
%>

<link rel="stylesheet" href="../../css/print.css" media="print">

<div id="content">	
	
		<table class="table table-condensed table-bordered">
			<tr>
				<td colspan="2" width="50%"> <h5> <fmt:message key="aca.DocOficialParaEvaluaciones"/> </h5> </td>
				<td width="50%" style="text-align: right;"> <h5> N°: <%=cicloGrupo.getCicloGrupoId()%> </h5> </td>
			</tr>
			<tr>
				<td colspan="2"><%= escuelaNom %></td>
				<td rowspan="6" style="text-align: center;">
					<b><fmt:message key="aca.Observaciones"/>:</b>
					<fmt:message key="aca.NotaMinimaAprobatoria"/> <%=notaAC%>.<br> 
					<%=ciudadNombre%>, <%=estadoNombre%>
					. <fmt:message key="aca.ALaFecha"/> <%=fecha.getFechaTexto(aca.util.Fecha.getHoy())%>
					<br> <br> _______________________________________<br>
					<b><fmt:message key="aca.SecretarioAcademico"/></b>
					<br> <br> _______________________________________<br> 
					<b><fmt:message key="aca.Profesor"/>:</b>
					<%=empPersonal.getNombre()%> <%=empPersonal.getApaterno()%> <%=empPersonal.getAmaterno()%>
					
				</td>
			</tr>
			<tr>
				<td colspan="2"><%=aca.plan.Plan.getNombrePlan(conElias, cicloGrupo.getPlanId())%></td>
			</tr>
			<tr>
				<td><div><fmt:message key="aca.Materia"/>:</div></td>
				<td><%=PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId())%></td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Grado"/>:</td>
				<td><%=cicloGrupo.getGrado()%>º</td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Grupo"/>:</td>
				<td><%=cicloGrupo.getGrupo()%></td>
			</tr>
			<tr>
				<td><fmt:message key="aca.Profesor"/>:</td>
				<td><%=empPersonal.getNombre()%>&nbsp;<%=empPersonal.getApaterno()%>&nbsp;<%=empPersonal.getAmaterno()%></td>
			</tr>
		</table>
				
				
		<table class="table table-condensed table-bordered">
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<%
					ArrayList<aca.ciclo.CicloGrupoEval> lisEval = cicloGrupoEvalLista.getArrayList(conElias, cicloGrupoId, cursoId, "ORDER BY ORDEN");
						for (int i = 0; i < lisEval.size(); i++) {
							cicloGrupoEval = (CicloGrupoEval) lisEval.get(i);
				%>
				<td style="text-align: center;">
					<%
						if (cicloGrupoEval.getEstado().equals("C")) {
					%> 
						<i class="icon-ok"></i>
					<%
						} else {
					%> 
						<i class="icon-folder-open"></i>
					<%
						}
					%>
				</td>
				<%
					}
				%>
			</tr>
			<tr>
				<th   width='2%' style="text-align:center;">#</th>
				<th   width='2%' style="text-align:center;"><fmt:message key="aca.Codigo"/></th>
				<th  width='10%'><fmt:message key="aca.NombreDelAlumno"/></th>
				
					
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
%>					
					
					<th class="text-center" style="width:4%;">
							<fmt:message key="aca.Extra" />
					</th>
					
					<%if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
						<th class="text-center" style="width:4%;">
								<fmt:message key="aca.Extra" />&nbsp;2
						</th>
					<%} %>

				</tr>
				
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
							
							<!-- --------- ALUMNO --------- -->

					  		
					  			<%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>
					
					  							  		
					  		<%if(kardex.getTipoCalId().equals("6")){ %>
					  			<span class="label label-important" title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />" ><fmt:message key="aca.Baja" /></span>
					  		<%} %>
						</td>
						
						
							<!-- --------- RECORRE LAS EVALUACIONES --------- -->
						<%
						int evalCerradas =0;						
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
								<td class="text-center"><div><%=strNota%></div>
									
									<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) -->
									<%if (!kardex.getTipoCalId().equals("6") && estadoEval.equals("A") ) { /* Si el alumno no se ha dado de baja puede editar su nota */ %>
										<div class="editar<%=cicloBloque.getBloqueId() %>" style="display:none;">
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
								} // valida el bloque
							} //End for Bloques
							
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
							
						} //End for Promedios
						%>				
							<!-- --------- EXTRAORDINARIO --------- -->
						<%
							float numExtra 	= 0;
							String strExtra = "";
							if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && promedio < notaAC) {	
								if (kardex.getNotaExtra() != null && !kardex.getNotaExtra().equals("null")) {
									strExtra = kardex.getNotaExtra();
									numExtra = Float.parseFloat(kardex.getNotaExtra());
								} else {
									strExtra = "-";
								}
							}
						%>
							<td class="text-center">
								<div id="extra<%=i%>"><%=strExtra %></div>
								
								<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
								<%if ( !strExtra.equals("") ) {%>
									<div class="editarExtra" style="display:none;">
										<input 
											style="margin-bottom:0;text-align:center;" 
											class="input-mini onlyNumbers" 
											data-max-num="<%=escala %>"
											type="text" 
											tabindex="<%=i+1%>" 
											name="notaExtra<%=i%>"
											id="notaExtra<%=i%>" 
											value="<%=strExtra.equals("-")?"":strExtra %>" 
										/>
									</div>
								<%}%>
							</td>
								<!-- --------- EXTRAORDINARIO 2 --------- -->
							<%
								String strExtra2 = "";
								
								if ( (cicloGrupoCurso.getEstado().equals("3") || cicloGrupoCurso.getEstado().equals("4") || cicloGrupoCurso.getEstado().equals("5")) && numExtra < notaAC && !strExtra.equals("")) {
									if (kardex.getNotaExtra2() != null && !kardex.getNotaExtra2().equals("null")) {
										strExtra2 = kardex.getNotaExtra2();
									} else {
										strExtra2 = "-";
									}
								}
							%>
							<%if(aca.kardex.KrdxCursoAct.getCantidadAlumnosConExtra(conElias, escuelaId, cicloGrupoId, cursoId).equals("0") == false && cicloGrupoCurso.getEstado().equals("3")){ %>
								<td class="text-center">
									<div id="extra<%=i%>"><%=strExtra2 %></div>
									
									<!-- INPUT PARA EDITAR EL EXTRAORDINARIO (ESCONDIDO POR DEFAULT) -->
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
							<%} %>
				</tr>
				<%
						i++;
					} // end for lista de alumnos
				%>
			
			<tr>
				<td colspan="30" style="text-align: center;">
					<i class="icon-ok"></i> <fmt:message key="aca.Cerrado"/>&nbsp;&nbsp; 
					<i class="icon-folder-open"></i> <fmt:message key="aca.Abierto"/>
				</td>
			</tr>
		</table>
						

</div>

<%@ include file="../../cierra_elias.jsp"%>