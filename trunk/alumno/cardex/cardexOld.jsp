<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="alumPlanLista" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="Curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="CursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="AlumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>

<%
	
	java.text.DecimalFormat frmDecimal	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String planId		= request.getParameter("plan")==null?aca.alumno.AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
	plan.mapeaRegId(conElias, planId);
	String nivel		= aca.plan.Plan.getNivel(conElias, planId);
	
	int grado 					= 0;
	int gradoTemp				= 0;				
	double prom					= 0;		
	
	/* Planes de estudio del alumno */
	ArrayList<aca.alumno.AlumPlan> lisPlan			= alumPlanLista.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");
	
	/* Array de Esquema o calculo de promedio */
	ArrayList<aca.ciclo.CicloPromedio> lisPromedio	= new ArrayList<aca.ciclo.CicloPromedio>();
	
	/* Array de Bloques de la materia */
	ArrayList<aca.ciclo.CicloBloque> lisBloque		= new ArrayList<aca.ciclo.CicloBloque>();
	
	/* Materias o cursos del plan de estudio del alumno */
	ArrayList<aca.plan.PlanCurso> lisCurso 			= CursoLista.getListCurso(conElias, planId," AND (CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_IMP WHERE CODIGO_ID = '"+codigoId+"') OR CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"')) ORDER BY GRADO, TIPOCURSO_ID, ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE");
	
	/* Notas el alumno en las materias */
	ArrayList<aca.vista.AlumnoCurso> lisAlumnoCurso = AlumnoCursoLista.getListAll(conElias, escuelaId, "AND CODIGO_ID = '"+codigoId+"' ORDER BY TIPO_CURSO(CURSO_ID),ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
	
	//TreeMap de los promedios del alumno en la materia
	java.util.TreeMap<String, aca.vista.AlumnoProm> treeProm 	= AlumPromLista.getTreeAlumno(conElias, codigoId,"");
		
	alumPersonal.mapeaRegId(conElias, codigoId);
%>
	
<div id="content">
	
	<%if(codigoId.substring(3,4).equals("P")){%>
		<div class="alert">
			<fmt:message key="aca.NoAlumnoSeleccionado" />
		</div>
	<%}else{ %>
	
		<h2><%=codigoId %> | <%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %></h2>
	
		<div class="well">	
			<select name="plan" id="plan" onchange="location.href='cardex.jsp?plan='+this.options[this.selectedIndex].value;" class="input-xxlarge">
				<%for(aca.alumno.AlumPlan alPlan : lisPlan){%>
					<option value="<%=alPlan.getPlanId() %>" <%if(planId.equals(alPlan.getPlanId())){out.print("selected");} %>><%=aca.plan.Plan.getNombrePlan(conElias, alPlan.getPlanId())%></option>
				<%}%>
			</select>
		</div>		
<%

			float [] sumaPorBimestre 	= {0,0,0,0,0,0,0,0,0,0};
			int [] materiasSinNota 		= {0,0,0,0,0,0,0,0,0,0};
			int cantidadMaterias	 	= 0;
			String oficial 				= "1";
			int cont 					= 1;
			int contGeneral 			= 0;
			
			for(aca.plan.PlanCurso curso : lisCurso){				
				 
				if(curso.getGrado() != null && curso.getGrado() != ""){
					grado = Integer.parseInt(curso.getGrado());			
				}
				
				boolean encontro = false;
				
				for(aca.vista.AlumnoCurso alumnoCurso : lisAlumnoCurso){
			
					if(alumnoCurso.getCursoId().equals(curso.getCursoId())){
						contGeneral++;
						
						encontro = true;										
						
						// Despliega el encabezado por grados 
						if (grado!=gradoTemp){
							gradoTemp = grado;
							cont = 1;
							
							// Trae la lista de bloques o evaluaciones del ciclo academico
							lisBloque = cicloBloqueL.getListCiclo(conElias, alumnoCurso.getCicloId(), "ORDER BY BLOQUE_ID");
							
							if(contGeneral>1){
%>
								<!-- Promedio General -->
			
								<tr class="alert alert-success">
									<td colspan="3">
										<fmt:message key="aca.PromedioGeneral"/></td>
										<%
											for(int l = 0; l < lisBloque.size(); l++){ 
												if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
				    								int cantidadMateriasTmp = cantidadMaterias;
				    								cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
		
					    							sumaPorBimestre[l] = sumaPorBimestre[l]/(cantidadMateriasTmp);
												}
										%>
												<td style="text-align:center" ><%=String.valueOf(sumaPorBimestre[l]).substring(0,String.valueOf(sumaPorBimestre[l]).indexOf(".")+2) %></td>
										<%
											} 
										%>
									<td colspan="20"></td>
								</tr>
						
								<!-- ---------------- -->
<% 
							}
					
		    				for(int i=0; i<sumaPorBimestre.length; i++){
		    					sumaPorBimestre[i] = 0;
		    				}
							
							for(int i=0; i<materiasSinNota.length; i++){
								materiasSinNota[i] = 0;
		    				}
							
							cantidadMaterias = 0;
							oficial = "1";
					
%>
							</table>
					
							<div class="alert alert-info"><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivel) %> - <%=aca.catalogo.CatNivel.getGradoNombre(grado)%> <%= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivel).toUpperCase() %></div>							
					
							<table class="table table-condensed table-bordered">
								<thead>
									<tr>
										<th width="2%">#</th>
									    <th width="6%"><fmt:message key="aca.Materia"/></th>
									    <th width="20%"><fmt:message key="aca.NombreMateria"/></th>
										<%for(aca.ciclo.CicloBloque cicloBloque : lisBloque){%>
												<th class="text-center" width="1%" title="<%=cicloBloque.getBloqueNombre() %>"><%=cicloBloque.getBloqueId() %></th>
										<%} %>
									    <th class="text-center" width="5%"><fmt:message key="aca.Nota"/></th>
									    <th class="text-center" width="5%"><fmt:message key="aca.FechaNota"/></th>
									    <th class="text-center" width="5%"><fmt:message key="aca.Extra"/></th>
									    <th class="text-center" width="5%"><fmt:message key="aca.FechaExtra"/></th>
									</tr>
								</thead>
<%							
						}	
%>

					<!-- Promedio Oficial -->
					
<%
						float promOficial = 0;
				
						if(!curso.getTipocursoId().equals(oficial) && curso.getTipocursoId().equals("2")){
%>
							<tr class="alert">
								<td colspan="3">
									<fmt:message key="aca.PromedioOficial"/>
								</td>
								<%
									for(int l = 0; l < lisBloque.size(); l++){ 
										if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
		    								int cantidadMateriasTmp = cantidadMaterias;
		    								cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
		    						
		    								promOficial = sumaPorBimestre[l]/cantidadMateriasTmp;
										}
								%>
										<td class="text-center"><%=String.valueOf(promOficial).substring(0,String.valueOf(promOficial).indexOf(".")+2) %></td>
								<%
										promOficial=0;
									} 
								%>
								<td colspan="20"></td>
							</tr>	
<%
							oficial = curso.getTipocursoId();
						}
						
						cantidadMaterias++;
%>
					<!-- ---------------- -->
					
					
					
					
					<tr> 
					    <td><%=cont %></td>
					    <td><%=curso.getCursoId()%></td>
					    <td><%=curso.getCursoNombre()%></td>
				<%				
					for(aca.ciclo.CicloBloque cicloBloque : lisBloque){
						switch(Integer.parseInt(cicloBloque.getBloqueId())){
							case 1:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal1() %></td>
				<%			}
							break;
							case 2:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal2() %></td>
				<%			}
							break;
							case 3:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal3() %></td>
				<%			}
							break;
							case 4:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal4() %></td>
				<%			}
							break;
							case 5:{%>
				   				<td style="text-align:center" ><%=alumnoCurso.getCal5() %></td>
				<%			}
							break;
							case 6:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal6() %></td>
				<%			}
							break;
							case 7:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal7() %></td>
				<%			}
							break;
							case 8:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal8() %></td>
				<%			}
							break;
							case 9:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal9() %></td>
				<%			}	
							break;
							case 10:{%>
								<td style="text-align:center" ><%=alumnoCurso.getCal10() %></td>
				<%			}
							break;
						}
					}
								
					if(!alumnoCurso.getCal1().equals("-")){
						sumaPorBimestre[0] += Float.parseFloat(alumnoCurso.getCal1());
					}else{
						materiasSinNota[0] = materiasSinNota[0]+1;
					}
					if(!alumnoCurso.getCal2().equals("-")){
						sumaPorBimestre[1] += Float.parseFloat(alumnoCurso.getCal2());
					}else{
						materiasSinNota[1] = materiasSinNota[1]+1;
					}
					if(!alumnoCurso.getCal3().equals("-")){
						sumaPorBimestre[2] += Float.parseFloat(alumnoCurso.getCal3());
					}else{
						materiasSinNota[2] = materiasSinNota[2]+1;
					}
					if(!alumnoCurso.getCal4().equals("-")){
						sumaPorBimestre[3] += Float.parseFloat(alumnoCurso.getCal4());
					}else{
						materiasSinNota[3] = materiasSinNota[3]+1;
					}
					if(!alumnoCurso.getCal5().equals("-")){
						sumaPorBimestre[4] += Float.parseFloat(alumnoCurso.getCal5());
					}else{
						materiasSinNota[4] = materiasSinNota[4]+1;
					}
					
					if(!alumnoCurso.getCal6().equals("-")){   						
						sumaPorBimestre[5] += Float.parseFloat(alumnoCurso.getCal6());
					}else{
						materiasSinNota[5] = materiasSinNota[5]+1;
					}
					
					if(!alumnoCurso.getCal7().equals("-")){
						sumaPorBimestre[6] += Float.parseFloat(alumnoCurso.getCal7());
					}else{
						materiasSinNota[6] = materiasSinNota[6]+1;
					}
					if(!alumnoCurso.getCal8().equals("-")){
						sumaPorBimestre[7] += Float.parseFloat(alumnoCurso.getCal8());
					}else{
						materiasSinNota[7] = materiasSinNota[7]+1;
					}    					
					if(!alumnoCurso.getCal9().equals("-")){
						sumaPorBimestre[8] += Float.parseFloat(alumnoCurso.getCal9());
					}else{
						materiasSinNota[8] = materiasSinNota[8]+1;
					}    					
					if(!alumnoCurso.getCal10().equals("-")){
						sumaPorBimestre[9] += Float.parseFloat(alumnoCurso.getCal10());
					}else{
						materiasSinNota[9] = materiasSinNota[9]+1;
					}	
					
				
					String nota="";
%>
						<td class="text-center">
						<%
							if(alumnoCurso.getNota() == null || alumnoCurso.getNota().equals("")){							
								if (treeProm.containsKey(alumnoCurso.getCicloGrupoId()+alumnoCurso.getCursoId()+codigoId)){
									aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(alumnoCurso.getCicloGrupoId()+alumnoCurso.getCursoId()+codigoId);
									prom = Double.parseDouble(alumProm.getPromedio())+Double.parseDouble(alumProm.getPuntosAjuste());
									out.print( "<strong>"+frmDecimal.format(prom)+"</strong>");
								}else{
									out.print( "-");
								}			
							}else{
						%>
								<strong><%=frmDecimal.format( Double.parseDouble(alumnoCurso.getNota()) ) %></strong>
						<%
							}
						%>
						</td>
				    	<td class="text-center"><%if(alumnoCurso.getFNota() == null) out.print("-"); else out.print(alumnoCurso.getFNota()); %></td>
				    	<td class="text-center"><%if(alumnoCurso.getNotaExtra() == null) out.print("-"); else out.print(alumnoCurso.getNotaExtra()); %></td>
				    	<td class="text-center"><%if(alumnoCurso.getFExtra() == null) out.print("-"); else out.print(alumnoCurso.getFExtra()); %></td>
					</tr>
<%									
			}
		} //for lisAlumno	
		
		cont++;
	} // for lisCurso
%>	
				 	   <!-- Promedio General -->
	
						<tr class="alert alert-success">
							<td colspan="3"><fmt:message key="aca.PromedioGeneral"/></td>
							
								<%  
							for(int l = 0; l < lisBloque.size(); l++){ 
								
								if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){
		    						int cantidadMateriasTmp = cantidadMaterias;
		    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
			    					sumaPorBimestre[l] = sumaPorBimestre[l]/(cantidadMateriasTmp);
								}
							%>
							<td style="text-align:center" ><%=String.valueOf(sumaPorBimestre[l]).substring(0,String.valueOf(sumaPorBimestre[l]).indexOf(".")+2) %></td>
							<%} %>
							<td colspan="20"></td>
						</tr>
				
						<!-- ---------------- -->
				</table>
			
	
	<%} %>
	
</div>

<%@ include file="../../cierra_elias.jsp" %>