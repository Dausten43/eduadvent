<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Grupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="GrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista" />
<jsp:useBean id="GrupoActL" scope="page" class="aca.ciclo.CicloGrupoActividadLista" />
<jsp:useBean id="KrdxActivL" scope="page" class="aca.kardex.KrdxAlumActivLista" />
<jsp:useBean id="KrdxEval" scope="page" class="aca.kardex.KrdxAlumEval" />
<jsp:useBean id="KrdxActiv" scope="page" class="aca.kardex.KrdxAlumActiv" />
<jsp:useBean id="planCursoLista" scope="page" class="aca.plan.PlanCursoLista" />

<script> 
	function Guardar(opcion) {
		if (opcion == "1") {
				document.frmNotas.action += "&Accion=1";
				return true;
			
		} else {
			if (document.frmNotas.NotaEval.value != "") {
				document.frmNotas.action += "&Accion=2";
				return true;
			} else {
				alert("<fmt:message key="js.Completar" />");
			}
		}
		return false;
	}
</script>


<%
	java.text.DecimalFormat frmNum = new java.text.DecimalFormat("###,##0.0;-###,##0.0", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String cicloId = (String) session.getAttribute("cicloId");
	String escuelaId = (String) session.getAttribute("escuela");
	String cicloGrupoId = (String) request.getParameter("CicloGrupoId");
	String cursoId = request.getParameter("materia");
	String evaluacion = request.getParameter("evaluacionId");
	String codigoAlumno = (String) request.getParameter("codigoAlumno");
	
	String redondeo			= aca.ciclo.CicloBloqueLista.getRedondeo(conElias, cicloId, evaluacion);
	String decimales		= aca.ciclo.CicloBloqueLista.getDecimales(conElias, cicloId, evaluacion);

	String calculo = aca.ciclo.CicloGrupoEval.getCalculo(conElias, cicloGrupoId, cursoId, evaluacion);
	int escala = aca.ciclo.Ciclo.getEscala(conElias, cicloId);

	String strAccion = request.getParameter("Accion") == null ? "0" : request.getParameter("Accion");
	int numAccion = Integer.parseInt(strAccion);
	String strTexto = "";
	String opcion = "";
	String Resultado = "";

	double promedio = 0;
	int error = 0;

	Grupo.setCicloGrupoId(cicloGrupoId);
	if (Grupo.existeReg(conElias)) {
		Grupo.mapeaRegId(conElias, cicloGrupoId);
	}

	ArrayList<aca.ciclo.CicloGrupoActividad> listActividades 	= GrupoActL.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacion,"ORDER BY ACTIVIDAD_ID");

	//operaciones a realizar 
	switch (numAccion) {
		case 1: {
			conElias.setAutoCommit(false);
			for (int j = 0; j < listActividades.size(); j++) {
				aca.ciclo.CicloGrupoActividad act = (aca.ciclo.CicloGrupoActividad) listActividades.get(j);

				// Obtiene el valor de la Nota

				String notaA = request.getParameter("NotaAct" + act.getActividadId()) == null ? "0" : request.getParameter("NotaAct" + act.getActividadId());
				if (notaA.equals("") || notaA.equals(" ")){
					notaA = "0";	
				}

				if (notaA != null) {
					KrdxActiv.setActividadId(act.getActividadId());
					KrdxActiv.setCicloGrupoId(cicloGrupoId);
					KrdxActiv.setCodigoId(codigoAlumno);
					KrdxActiv.setCursoId(cursoId);
					KrdxActiv.setEvaluacionId(evaluacion);
					KrdxActiv.setNota(notaA);
					if (KrdxActiv.existeReg(conElias) == false) {
						if (KrdxActiv.insertReg(conElias)) {
							//nice
						} else {
							error++;
						}
					} else {
						if (KrdxActiv.updateReg(conElias)) {
							//nice
						} else {
							error++;
						}
					}
				}
			}
			System.out.println("error:" +error);
			// Si no hay errores al grabar las actividades
			if (error == 0) {

				double prom = 0;
				// Recalcula y graba el promedio de la evaluacion
				KrdxEval.setCicloGrupoId(cicloGrupoId);
				KrdxEval.setCursoId(cursoId);
				KrdxEval.setEvaluacionId(evaluacion);
				KrdxEval.setCodigoId(codigoAlumno);

				if (calculo.equals("V")) {
					promedio = aca.kardex.KrdxAlumEval.calculoPorValor(conElias, cicloGrupoId, cursoId, evaluacion, codigoAlumno, String.valueOf(escala));
					promedio = promedio + .5;
					prom = (int) promedio;
				} else {
					promedio = aca.kardex.KrdxAlumEval.calculoPorPromedio(conElias, cicloGrupoId, cursoId, evaluacion, codigoAlumno, decimales, redondeo);
					//promedio = promedio + .5;
					prom = promedio;
				}
				KrdxEval.setNota(String.valueOf(prom));
				
				if (KrdxEval.existeReg(conElias)) {
					if (KrdxEval.updateReg(conElias)) {
						conElias.commit();
						Resultado = "Modificado";
					} else {
						conElias.rollback();
						Resultado = "NoModifico";
					}
				} else {
					if (KrdxEval.insertReg(conElias)) {
						conElias.commit();
						Resultado = "Guardado";
					} else {
						conElias.rollback();
						Resultado = "NoGuardo";
					}
				}

			}
			
			break;
		}

		case 2: {

			// Obtiene el valor de la Nota
			String notaE = request.getParameter("NotaEval") == null ? "0" : request.getParameter("NotaEval");
			if (notaE.equals("") || notaE.equals(" ")){
				notaE = "0";	
			}

			KrdxEval.setCicloGrupoId(cicloGrupoId);
			KrdxEval.setCursoId(cursoId);
			KrdxEval.setEvaluacionId(evaluacion);
			KrdxEval.setCodigoId(codigoAlumno);
			KrdxEval.setNota(notaE);
			if (KrdxEval.existeReg(conElias)) {
				if (KrdxEval.updateReg(conElias)) {
					conElias.commit();
					Resultado = "Modificado";
				} else {
					conElias.rollback();
					Resultado = "NoModifico";
				}
			} else {
				if (KrdxEval.insertReg(conElias)) {
					conElias.commit();
					Resultado = "Guardado";
				} else {
					conElias.rollback();
					Resultado = "NoGuardo";
				}
			}
			break;
		}

	}
	
	pageContext.setAttribute("resultado", Resultado);
%>
<%
//LISTA CURSOS DERIVADOS
	ArrayList<aca.plan.PlanCurso> listaMateriasDerivadas		= planCursoLista.getMateriasHijas(conElias, cursoId);
%>

<div id="content">
	<h2>
		<fmt:message key="maestros.CambiodeCalificacion" />
	</h2>
	
	<div class="alert alert-info">
		<h4><%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupoEval.getNombreEstrategia( conElias, cicloGrupoId, cursoId, evaluacion)%></h4>
		<strong><fmt:message key="aca.Alumno" />:</strong> <%=aca.alumno.AlumPersonal.getNombre(conElias,codigoAlumno, "NOMBRE")%> 
		<br> 
		<strong><fmt:message key="aca.Maestro" />:</strong> <%=aca.empleado.EmpPersonal.getNombre(conElias,Grupo.getEmpleadoId(), "NOMBRE")%> 
	</div>
	
	<% if (Resultado.equals("Eliminado") || Resultado.equals("Modificado") || Resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!Resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
		
	<div class="well">
		<a class="btn btn-primary" href="notasMetodo.jsp?CicloGrupoId=<%=cicloGrupoId%>&CodigoAlumno=<%=codigoAlumno%>">
			<i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" />
		</a>
	</div>
	
	<form name="frmNotas" action="evalEstrategias.jsp?CicloGrupoId=<%=cicloGrupoId%>&codigoAlumno=<%=codigoAlumno%>&cursoId=<%=cursoId%>&materia=<%=cursoId%>&evaluacionId=<%=evaluacion%>" method="post">
		<input type="hidden" name="Accion">
	
		<table class="table table-bordered">
			<tr>
				<%
					if (listActividades.size() < 0) {
				%>
					<td colspan="<%=listActividades.size()%>"><fmt:message key="aca.Actividades" /></td>
				<%
					}
				%>
			</tr>
			<tr>
				<th><fmt:message key="aca.Nombre" /></th>
				<%
					for (aca.ciclo.CicloGrupoActividad actividad: listActividades) {
				%>
					<th style="width:2%;"><%=actividad.getActividadId()%></th>
				<%
					}
				%>
				<th><fmt:message key="aca.Nota" /></th>
			</tr>
			<tr>
				<td>
					<%=aca.ciclo.CicloGrupoEval.getNombreEstrategia(conElias, cicloGrupoId, cursoId, evaluacion)%></td>
				<%
					for (aca.ciclo.CicloGrupoActividad act: listActividades) {
						KrdxActiv.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, cursoId, evaluacion, act.getActividadId());
				%>
						<td>
							<input class="input-mini" required type="text" id="NotaAct" name="NotaAct<%=act.getActividadId()%>" value="<%=KrdxActiv.getNota()%>" maxlength="3" size="3" />
						</td>
				<%
					}

					KrdxEval.mapeaRegId(conElias, codigoAlumno, cicloGrupoId, cursoId, evaluacion);
					if (aca.ciclo.CicloGrupoActividad.tieneActividades(conElias, cicloGrupoId, cursoId, evaluacion) == true) {
						strTexto = "readonly";
						opcion = "1";
					} else {
						opcion = "2";
					}
				%>
				<td>
					<input <%if (listaMateriasDerivadas.size() > 0){
						out.print("disabled");%>
						class="input-mini" type="text" id="NotaEval" name="NotaEval" value="<%=frmNum.format(Double.parseDouble(KrdxEval.getNota().equals("") ? "0" : KrdxEval.getNota())) %>" maxlength="3" size="3" <%=strTexto%> />
						 <p> No se puede editar porque es materia Madre</p>
						<%}else{%>
						class="input-mini" type="text" id="NotaEval" name="NotaEval" value="<%=frmNum.format(Double.parseDouble(KrdxEval.getNota().equals("") ? "0" : KrdxEval.getNota())) %>" maxlength="3" size="3" <%=strTexto%> />
						<%}%>
					 
				</td>
			</tr>
		</table>
			
		<div class="well">
				<button class="btn btn-primary btn-large" type="submit" onclick="return Guardar('<%=opcion%>');">
					<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" />
				</button>
		</div>
	</form>
</div>

<%@ include file="../../cierra_elias.jsp"%>
