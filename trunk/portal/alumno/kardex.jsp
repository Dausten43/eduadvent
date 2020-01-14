<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<%@page import="java.util.TreeMap"%>
<%@page import="aca.alumno.AlumPlan"%>
<%@page import="aca.plan.Plan"%>
<%@page import="aca.vista.AlumnoCurso"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.ciclo.CicloBloque"%>

<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan"/>
<jsp:useBean id="alumPlanLista" scope="page" class="aca.alumno.AlumPlanLista"/>
<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="Curso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="CursoLista" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="alumnoCurso" scope="page" class="aca.vista.AlumnoCurso"/>
<jsp:useBean id="alumnoCursoLista" scope="page" class="aca.vista.AlumnoCursoLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloBloqueL" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="AlumPromLista" scope="page" class="aca.vista.AlumnoPromLista"/>

<%

	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String planId		= request.getParameter("plan")==null?AlumPlan.getPlanActual(conElias, codigoId):request.getParameter("plan");
	String nivel		= aca.plan.Plan.getNivel(conElias, planId);
	
	//java.text.DecimalFormat frmEntero	= new java.text.DecimalFormat("##0;-##0");
		java.text.DecimalFormat frmDecimal	= new java.text.DecimalFormat("##0.0;-##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));
		
		//float[] sumaPorBimestre 	= new float[10];
		int grado 					= 0;
		int gradoTemp				= 0;				
		double prom					= 0;		
		int numBloques				= 0;
		
		/* Planes de estudio del alumno */
		ArrayList<AlumPlan> lisPlan			= alumPlanLista.getArrayList(conElias, codigoId, "ORDER BY F_INICIO");
		
		/* Array de Bloques de la materia */
		ArrayList<CicloBloque> lisBloque	= null;
		
		/* Materias o cursos del plan de estudio del alumno */
		ArrayList<PlanCurso> lisCurso 			= CursoLista.getListCurso(conElias, planId," AND (CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_IMP WHERE CODIGO_ID = '"+codigoId+"') OR CURSO_ID IN (SELECT CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"')) ORDER BY GRADO, TIPOCURSO_ID, ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE");
		
		/* Notas el alumno en las materias */
		ArrayList<AlumnoCurso> lisAlumnoCurso 	= alumnoCursoLista.getListAll(conElias, escuelaId, "AND CODIGO_ID = '"+codigoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_NOMBRE(CURSO_ID)");
		
		//TreeMap de los promedios del alumno en la materia
		TreeMap treeProm 	= AlumPromLista.getTreeAlumno(conElias, codigoId,"");	
			
		alumPersonal.mapeaRegId(conElias, codigoId);
%>
<body>
	<div id="content">
		<h2><fmt:message key="aca.Kardex"/></h2>
		<div class="well">
			<fmt:message key="aca.Matricula"/>: <small><%=alumPersonal.getMatricula() %></small><br>
			<fmt:message key="aca.CURP"/>: <small><%=alumPersonal.getCurp() %></small><br>
			<fmt:message key="aca.NombreDelAlumno"/>: <small><%=alumPersonal.getNombre() %> <%=alumPersonal.getApaterno() %> <%=alumPersonal.getAmaterno() %></small><br>
			<fmt:message key="aca.FechadeNacimiento"/>: <small><%=alumPersonal.getFNacimiento() %></small><br>
			<fmt:message key="aca.Colonia"/>: <small><%=alumPersonal.getColonia() %></small><br>
			<fmt:message key="aca.Direccion"/>: <small><%=alumPersonal.getDireccion() %></small><br>
			<fmt:message key="aca.Genero"/>: <small><%=alumPersonal.getGenero() %></small><br>
			<fmt:message key="aca.Tutor"/>: <small><%=alumPersonal.getTutor() %></small>
		</div>
		
<%
		
	float [] sumaPorBimestre = {0,0,0,0,0,0,0,0,0,0};
	int [] materiasSinNota = {0,0,0,0,0,0,0,0,0,0};
	int cantidadMaterias = 0;
	String oficial = "1";
	int cont = 1;
	
	for(int i=0; i<lisCurso.size(); i++){
		PlanCurso curso = (aca.plan.PlanCurso) lisCurso.get(i);
			
		if(curso.getGrado() != null && curso.getGrado() != "") grado = Integer.parseInt(curso.getGrado());			
		boolean encontro = false;
				
		for(int j=0; j<lisAlumnoCurso.size(); j++){
			alumnoCurso = (AlumnoCurso) lisAlumnoCurso.get(j);
			if(alumnoCurso.getCursoId().equals(curso.getCursoId())){
				encontro = true;										
				
				// Despliega el encabezado por grados 
				if (grado!=gradoTemp){
					gradoTemp = grado;
					cont = 1;
					
					// Trae el numero de bloques del ciclo
					lisBloque = cicloBloqueL.getListCiclo(conElias, alumnoCurso.getCicloId(), "ORDER BY BLOQUE_ID");
					numBloques = lisBloque.size();
					
					if(i!=0){
					%>
						<!-- Promedio General -->
	
						<tr class="alert">
							<td colspan="3" align="right"><fmt:message key="aca.PromedioGeneral"/>:&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<%for(int l = 0; l < lisBloque.size(); l++){ 
								
								if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
		    						int cantidadMateriasTmp = cantidadMaterias;
		    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];

			    					sumaPorBimestre[l] = sumaPorBimestre[l]/(cantidadMateriasTmp);
								}
							%>
							<td align="center"><%=String.valueOf(sumaPorBimestre[l]).substring(0,String.valueOf(sumaPorBimestre[l]).indexOf(".")+2) %></td>
							<%} %>
							<td colspan="20"></td>
						</tr>
				
						<!-- ---------------- -->
					<% 
					}
    				sumaPorBimestre[0] = 0;
					sumaPorBimestre[1] = 0;
					sumaPorBimestre[2] = 0;
					sumaPorBimestre[3] = 0;
					sumaPorBimestre[4] = 0;
					sumaPorBimestre[5] = 0;
					sumaPorBimestre[6] = 0;
					sumaPorBimestre[7] = 0;
					sumaPorBimestre[8] = 0;
					sumaPorBimestre[9] = 0;

					materiasSinNota[0] = 0;
					materiasSinNota[1] = 0;
					materiasSinNota[2] = 0;
					materiasSinNota[3] = 0;
					materiasSinNota[4] = 0;
					materiasSinNota[5] = 0;
					materiasSinNota[6] = 0;
					materiasSinNota[7] = 0;
					materiasSinNota[8] = 0;
					materiasSinNota[9] = 0;
					
					cantidadMaterias = 0;
					oficial = "1";
						
%>
					</table>
					<div class="alert alert-info"><b>
					   <%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, escuelaId, nivel) %> - <%=aca.catalogo.CatNivel.getGradoNombre(grado)%> <%= aca.catalogo.CatNivelEscuela.getTitulo(conElias, escuelaId, nivel).toUpperCase() %></b>
					</div>
					<table class="table table-bordered">
					<tr>
						<th align="center" width="2%" >#</th>
					    <th align="center" width="6%" ><fmt:message key="aca.Materia"/></th>
					    <th align="left" width="25%" ><fmt:message key="aca.NombreMateria"/></th>
<%
					for(int k = 0; k < numBloques; k++){
						cicloBloque = (CicloBloque) lisBloque.get(k);
%>
							<th align="center" width="5%"  title="<%=cicloBloque.getBloqueNombre() %>"><%=k+1%></th>
<%					} %>
					    <th align="center" width="5%" ><fmt:message key="aca.Nota"/></th>
					    <th align="center" width="5%" ><fmt:message key="aca.FNota"/></th>
					    <th align="center" width="5%" ><fmt:message key="aca.Extra"/></th>
					    <th align="center" width="5%" ><fmt:message key="aca.FExtra"/></th>
					</tr>
<%				}	%>

					<!-- Promedio Oficial -->
					
					
				<%
				float promOficial = 0;
				
				if(!curso.getTipocursoId().equals(oficial) && curso.getTipocursoId().equals("2")){%>
					<tr class="alert">
						<td colspan="3" align="right"><fmt:message key="aca.PromedioOficial"/>:&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<%for(int l = 0; l < lisBloque.size(); l++){ 
							
							if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
	    						int cantidadMateriasTmp = cantidadMaterias;
	    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
	    						
	    						promOficial = sumaPorBimestre[l]/cantidadMateriasTmp;
							}
						%>
						<td align="center"><%=String.valueOf(promOficial).substring(0,String.valueOf(promOficial).indexOf(".")+2) %></td>
						<%
							promOficial=0;
						} %>
						<td colspan="20"></td>
					</tr>	
				<%
				oficial = curso.getTipocursoId();
				}
				cantidadMaterias++;
				%>
					<!-- ---------------- -->
					<tr> 
					    <td align="center"><%=cont %></td>
					    <td align="center"><%=curso.getCursoId()%></td>
					    <td align="left"><%=curso.getCursoNombre()%></td>
<%				
				for(int k=0; k<numBloques; k++){
					switch(k+1){
						case 1:{%>
						<td align="center"><%=alumnoCurso.getCal1().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal1() ) ) %></td>
				<%		}
						break;
						case 2:{%>
						<td align="center"><%=alumnoCurso.getCal2().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal2() ) ) %></td>
				<%		}
						break;
						case 3:{%>
						<td align="center"><%=alumnoCurso.getCal3().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal3() ) ) %></td>
				<%		}
						break;
						case 4:{%>
						<td align="center"><%=alumnoCurso.getCal4().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal4() ) ) %></td>
				<%		}
						break;
						case 5:{%>
				   		<td align="center"><%=alumnoCurso.getCal5().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal5() ) ) %></td>
				<%		}
						break;
						case 6:{%>
						<td align="center"><%=alumnoCurso.getCal6().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal6() ) ) %></td>
				<%		}
						break;
						case 7:{%>
						<td align="center"><%=alumnoCurso.getCal7().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal7() ) ) %></td>
				<%		}
						break;
						case 8:{%>
						<td align="center"><%=alumnoCurso.getCal8().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal8() ) ) %></td>
				<%		}
						break;
						case 9:{%>
						<td align="center"><%=alumnoCurso.getCal9().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal9() ) ) %></td>
				<%		}
						break;
						case 10:{%>
						<td align="center"><%=alumnoCurso.getCal10().equals("-")?"-":frmDecimal.format( Double.parseDouble( alumnoCurso.getCal10() ) ) %></td>
				<%		}
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
					
				
				String nota="";%>
						<td align="center">
			<%	if(alumnoCurso.getNota() == null || alumnoCurso.getNota().equals("")){							
					//nota = String.valueOf(sumaBimestres/cantidadBimestres);
					if (treeProm.containsKey(alumnoCurso.getCicloGrupoId()+alumnoCurso.getCursoId()+codigoId)){
						aca.vista.AlumnoProm alumProm = (aca.vista.AlumnoProm) treeProm.get(alumnoCurso.getCicloGrupoId()+alumnoCurso.getCursoId()+codigoId);
						prom = Double.parseDouble(alumProm.getPromedio())+Double.parseDouble(alumProm.getPuntosAjuste());
						out.print( "<b>"+frmDecimal.format(prom)+"</b>");
					}else{
						out.print( "-");
					}										 
				}else{
					out.print(alumnoCurso.getNota());
				}%>
						</td>
				    	<td align="center"><%if(alumnoCurso.getFNota() == null) out.print("-"); else out.print(alumnoCurso.getFNota()); %></td>
				    	<td align="center"><%if(alumnoCurso.getNotaExtra() == null) out.print("-"); else out.print(alumnoCurso.getNotaExtra()); %></td>
				    	<td align="center"><%if(alumnoCurso.getFExtra() == null) out.print("-"); else out.print(alumnoCurso.getFExtra()); %></td>
					</tr>
<%				j = lisAlumnoCurso.size();					
			}
		} //for lisAlumno		
		cont++;
	} // for lisCurso
%>	
	
				 	   <!-- Promedio General -->
	
						<tr class="alert">
							<td colspan="3" align="right"><fmt:message key="aca.PromedioGeneral"/>:&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<%
							if(lisBloque!=null){	
								for(int l = 0; l < lisBloque.size(); l++){ 
									
									if(sumaPorBimestre[l] > 0 && cantidadMaterias > 0){ 
			    						int cantidadMateriasTmp = cantidadMaterias;
			    						cantidadMateriasTmp = cantidadMateriasTmp-materiasSinNota[l];
			    						
				    					sumaPorBimestre[l] = sumaPorBimestre[l]/(cantidadMateriasTmp);
									}
									
								%>
								<td align="center"><%=String.valueOf(sumaPorBimestre[l]).substring(0,String.valueOf(sumaPorBimestre[l]).indexOf(".")+2) %></td>
							<%	
								}
							}
							%>
							<td colspan="20"></td>
						</tr>
				
						<!-- ---------------- -->
						<tr><td>&nbsp;</td></tr>
				</table>
		
	</div>
</body>
<%@ include file="../../cierra_elias.jsp" %>