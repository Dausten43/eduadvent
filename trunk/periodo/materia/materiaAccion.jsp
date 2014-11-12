<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@page import="aca.ciclo.CicloGrupo"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="aca.ciclo.CicloBloque"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="PermisoLista" scope="page" class="aca.ciclo.CicloPermisoLista"/>
<jsp:useBean id="PlanLista" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="grupoLista" scope="page" class="aca.catalogo.CatGrupoLista"/>
<jsp:useBean id="grupo" scope="page" class="aca.catalogo.CatGrupo"/>
<jsp:useBean id="cicloGrupoLista" scope="page" class="aca.ciclo.CicloGrupoLista"/>
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo"/>
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso"/>
<jsp:useBean id="planCursoL" scope="page" class="aca.plan.PlanCursoLista"/>
<jsp:useBean id="plan" scope="page" class="aca.plan.Plan"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="cicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="empPersonalL" scope="page" class="aca.empleado.EmpPersonalLista"/>
<jsp:useBean id="cicloBloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>
<jsp:useBean id="cicloBloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="cicloGrupoEval" scope="page" class="aca.ciclo.CicloGrupoEval"/>
<%
	String strAccion 		= request.getParameter("Accion");
	String cicloId			= (String) session.getAttribute("cicloId");
	String planId			= (String) session.getAttribute("planId");
	String escuelaId		= (String) session.getAttribute("escuela");
	
	ArrayList lisCiclo	 		= new ArrayList();
	
	if (strAccion==null) 	strAccion = "0";
	
	int numAccion 			= Integer.parseInt(strAccion);
	
	if(cicloId == null)
		cicloId = ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
	
	switch (numAccion){
		case 1: { 
			cicloId = request.getParameter("Ciclo");
			session.setAttribute("cicloId",cicloId);
			break;
		}
		case 2: {//Mostrar las materias del grupo por medio de Ajax
			String folio = request.getParameter("folio");
			String despliegue = request.getParameter("despliegue");
			String nivel = request.getParameter("nivel");
			grupo.mapeaRegId(conElias, folio);
			plan.mapeaRegId(conElias, planId);
			ArrayList lisPlanCurso = planCursoL.getListAll(conElias, escuelaId, "AND PLAN_ID = '"+plan.getPlanId()+"' AND GRADO = "+grupo.getGrado()+" ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_ID");
%>
	<table width="100%">
<%
			for(int l = 0; l < lisPlanCurso.size(); l++){
				planCurso = (PlanCurso) lisPlanCurso.get(l);
				if(cicloGrupo.existeReg(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId)){
					cicloGrupo.mapeaRegId(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId);
					cicloGrupoCurso.setCicloGrupoId(cicloGrupo.getCicloGrupoId());
					cicloGrupoCurso.setCursoId(planCurso.getCursoId());
				}
				boolean existe = cicloGrupoCurso.existeReg(conElias);
				cicloGrupoCurso.mapeaRegId(conElias, cicloGrupo.getCicloGrupoId(), planCurso.getCursoId());

				if(!KrdxCursoAct.tieneAlumnos(conElias, cicloGrupo.getCicloGrupoId(), planCurso.getCursoId())){
%>
		<tr>
		  <td><input type="checkbox" id="materia<%=l %>-<%=folio %>" value="<%=planCurso.getCursoId() %>" <%if(existe) out.print("Checked"); %>/></td>
		  <td><%=planCurso.getCursoNombre() %></td>
<%					if(existe){
%>
		  <td><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(), "NOMBRE") %></td>
<%
					}else{
%>
		  <td><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupo.getEmpleadoId(), "NOMBRE") %></td>
<%
					}
%>
		</tr>
<%
				}else{
%>
		<tr>
		  <td><fmt:message key="aca.TieneAlumnos" /></td>
		  <td><font color="#0000FF"><%=planCurso.getCursoNombre() %></font></td>
<%					if(existe){
%>
		  <td><font color="#0000FF"><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(), "NOMBRE") %></font></td>
<%
					}else{
%>
		  <td><font color="#0000FF"><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupo.getEmpleadoId(), "NOMBRE") %>---</font></td>
<%
					}
%>
		</tr>
<%
				}
%>
		  
<%
			}
%>
		<tr>
			<td>
				<input type="button" value="<fmt:message key="boton.Grabar" />" onclick="grabarMaterias(<%=lisPlanCurso.size() %>, <%=folio %>,<%=despliegue %>, <%=nivel %>,event);" />
			</td>
		</tr>
	</table>
<%
			break;
		}
		case 3: {//Grabar materias que se llevaran en el grado y en el grupo
			conElias.setAutoCommit(false);
			String folio = request.getParameter("folio");
			String posicion = request.getParameter("posicion");
			String despliegue = request.getParameter("despliegue");
			grupo.mapeaRegId(conElias, folio);
			
			if(!cicloGrupo.existeReg(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId)){
				
				cicloGrupo.setCicloGrupoId(cicloId+CicloGrupo.getSecuencial(conElias, cicloId));
				cicloGrupo.setCicloId(cicloId);
				
				cicloGrupo.setGrupoNombre(aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))+" "+grupo.getGrupo());
				cicloGrupo.setEmpleadoId("Agregar");
				cicloGrupo.setHorarioId("0");
				cicloGrupo.setSalonId("0");
				cicloGrupo.setNivelId(grupo.getNivelId());
				cicloGrupo.setGrado(grupo.getGrado());
				cicloGrupo.setGrupo(grupo.getGrupo());
				cicloGrupo.setPlanId(planId);
				
				if(!cicloGrupo.insertReg(conElias)){
					out.print("<fmt:message key='aca.ErrorAlGrabar' />");
					break;
				}
			}else{
				cicloGrupo.mapeaRegId(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId);
			}
			String materia = "";
			boolean grabo = true;
			//cicloGrupoCurso.deleteAllReg(conElias, cicloGrupo.getCicloGrupoId());
			
			ArrayList lisCicloBloque = cicloBloqueLista.getListCiclo(conElias, cicloId, "ORDER BY BLOQUE_ID");
			
			for(int l = 0; l < Integer.parseInt(posicion); l++){
				materia = request.getParameter("materia"+l+"-"+Integer.parseInt(folio));
				cicloGrupoCurso.setCicloGrupoId(cicloGrupo.getCicloGrupoId());				
				if(materia != null){
					for(int m = 0; m < lisCicloBloque.size(); m++){
						cicloBloque = (CicloBloque) lisCicloBloque.get(m);
						cicloGrupoEval.setCicloGrupoId(cicloGrupo.getCicloGrupoId());
						cicloGrupoEval.setCursoId(materia);
						cicloGrupoEval.setEvaluacionId(cicloBloque.getBloqueId());
						cicloGrupoEval.setEvaluacionNombre(cicloBloque.getBloqueNombre());						
						cicloGrupoEval.setFecha(cicloBloque.getFFinal());
						cicloGrupoEval.setValor("10");
						cicloGrupoEval.setTipo("P");
						cicloGrupoEval.setEstado("A");
						cicloGrupoEval.setCalculo("V");
						cicloGrupoEval.setOrden(String.valueOf( (m+1) ));
						if(!cicloGrupoEval.existeReg(conElias)){
							cicloGrupoEval.insertReg(conElias);
						}
					}
					cicloGrupoCurso.setCursoId(materia);
					cicloGrupoCurso.setEmpleadoId(cicloGrupo.getEmpleadoId());
					cicloGrupoCurso.setHorario("--");
					cicloGrupoCurso.setSalonId("0");
					if(!cicloGrupoCurso.existeReg(conElias)){
						if(cicloGrupoCurso.insertReg(conElias)){
							grabo &= true;
						}else{
							grabo &= false;
							out.print("<fmt:message key='aca.ErrorGrabarCorto' />"+cicloGrupo.getCicloGrupoId()+"----"+materia+"\n");
						}
					}
				}else{
					materia = request.getParameter("noMateria"+l+"-"+Integer.parseInt(folio));
					if(materia != null){
						cicloGrupoCurso.setCursoId(materia);
						if(cicloGrupoCurso.existeReg(conElias))
							if(!cicloGrupoCurso.deleteReg(conElias)){
								grabo &= false;
								out.print("<fmt:message key='aca.ErrorBorrarCorto' />"+cicloGrupo.getCicloGrupoId()+"----"+materia+"\n");
							}
					}
				}
			}
			
			// si no tiene materias - Borrar el grupo 
			
			if(grabo){
				conElias.commit();
				ArrayList lisCGC = cicloGrupoCursoLista.getListAll(conElias, "WHERE CICLO_GRUPO_ID = '"+cicloGrupo.getCicloGrupoId()+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID), CURSO_ID");
%>
				<table width="100%">
			<%
						for(int l = 0; l < lisCGC.size(); l++){
							cicloGrupoCurso = (CicloGrupoCurso) lisCGC.get(l);
			%>
					<tr>
					  <td><%=l+1 %></td>
					  <td><%=aca.plan.PlanCurso.getCursoNombre(conElias, cicloGrupoCurso.getCursoId()) %></td>
					  <td onclick="muestraBuscar(this, event, '<%=cicloGrupo.getCicloGrupoId() %>', '<%=cicloGrupoCurso.getCursoId() %>', 'curso', 0);" style="cursor:pointer" onmouseover="this.style.backgroundColor='#CCE8FF'" onmouseout="this.style.backgroundColor=''"><%=aca.empleado.EmpPersonal.getNombre(conElias, cicloGrupoCurso.getEmpleadoId(), "NOMBRE") %></td>
					</tr>
			<%
						}
			%>
				</table>
			<%
			}else{
				conElias.rollback();
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 4: { // Cambia maestro curso
			String cicloGrupoId = request.getParameter("cicloGrupoId");
			String cursoId = request.getParameter("cursoId");
			String empleadoId = request.getParameter("empleadoId");

			cicloGrupoCurso.setCicloGrupoId(cicloGrupoId);
			cicloGrupoCurso.setCursoId(cursoId);
			
			if(cicloGrupoCurso.existeReg(conElias)){
				cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);
				cicloGrupoCurso.setEmpleadoId(empleadoId);
				if(cicloGrupoCurso.updateReg(conElias)){
					out.print("<fmt:message key='aca.Si' />");
				}else{
					out.print("<fmt:message key='aca.No' />");
				}
			}else{
				out.print("<fmt:message key='aca.No' />");
			}
			break;
		}
		case 5: { // Cambia maestro grupo
			String cicloGrupoId = request.getParameter("cicloGrupoId");
			String empleadoId = request.getParameter("empleadoId");
			String folio = request.getParameter("folio");
			
			cicloGrupo.setCicloGrupoId(cicloGrupoId);
			
			if(cicloGrupoId.equals("")){
				grupo.mapeaRegId(conElias, folio);
				if(cicloGrupo.existeReg(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId)){
					cicloGrupo.mapeaRegId(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId);
				}
			}
			if(cicloGrupo.existeReg(conElias)){
				cicloGrupo.mapeaRegId(conElias, cicloGrupoId);
				cicloGrupo.setEmpleadoId(empleadoId);
				if(cicloGrupo.updateReg(conElias)){
					out.print("<fmt:message key='aca.Si' />");
				}else{
					out.print("<fmt:message key='aca.No' />");
				}
			}else{
				grupo.mapeaRegId(conElias, folio);
				if(!cicloGrupo.existeReg(conElias, grupo.getNivelId(), grupo.getGrado(), grupo.getGrupo(), cicloId, planId)){
					cicloGrupo.setCicloGrupoId(cicloId+CicloGrupo.getSecuencial(conElias, cicloId));
					cicloGrupo.setCicloId(cicloId);
					cicloGrupo.setGrupoNombre(aca.catalogo.CatNivel.getGradoNombre(Integer.parseInt(grupo.getGrado()))+" "+grupo.getGrupo());
					cicloGrupo.setEmpleadoId(empleadoId);
					cicloGrupo.setHorarioId("0");
					cicloGrupo.setSalonId("0");
					cicloGrupo.setNivelId(grupo.getNivelId());
					cicloGrupo.setGrado(grupo.getGrado());
					cicloGrupo.setGrupo(grupo.getGrupo());
					cicloGrupo.setPlanId(planId);
					if(cicloGrupo.insertReg(conElias)){
						out.print("<fmt:message key='aca.Si' />");
					}else{
						out.print("<fmt:message key='aca.No' />");
					}
				}else{
					out.print("<fmt:message key='aca.No' />");
				}
			}
			break;
		}
	}
%>
<%@ include file= "../../cierra_elias.jsp" %>