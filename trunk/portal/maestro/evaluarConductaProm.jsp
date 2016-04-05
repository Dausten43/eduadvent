<%@ page import="java.text.*"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="empPersonal" scope="page"
	class="aca.empleado.EmpPersonal" />
<jsp:useBean id="cicloGrupoEvalLista" scope="page"
	class="aca.ciclo.CicloGrupoEvalLista" />
<jsp:useBean id="cicloGrupo" scope="page" class="aca.ciclo.CicloGrupo" />
<jsp:useBean id="kardexLista" scope="page"
	class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="kardexConducta" scope="page"
	class="aca.kardex.KrdxAlumConducta" />
<jsp:useBean id="kardexConductaLista" scope="page"
	class="aca.kardex.KrdxAlumConductaLista" />
<jsp:useBean id="cicloGrupoCurso" scope="page"
	class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="planCurso" scope="page" class="aca.plan.PlanCurso" />
<jsp:useBean id="CicloPromedioL" scope="page"
	class="aca.ciclo.CicloPromedioLista" />

<script>
	/*
	 * ABRIR INPUTS PARA EDITAR LAS NOTAS
	 */
	function muestraInput(evaluacionId) {
		var editar = $('.editar' + evaluacionId);//Busca los inputs

		editar.each(function() {
			var $this = $(this);

			$this.siblings('div').hide();//Esconde la calificacion
			$this.fadeIn(300);//Muestra el input con la calificacion
		});
	}

	/*
	 * GUARDA LAS NOTAS QUE SE MODIFICARON
	 */
	function guardarCalificaciones(promedio) {
		document.forma.Promedio.value = promedio;
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%
	//FORMATOS ---------------------------->
		java.text.DecimalFormat frmEntero = new java.text.DecimalFormat("##0;-##0");
		java.text.DecimalFormat frmDecimal = new java.text.DecimalFormat("##0.0;-##0.0");

		String escuelaId = (String) session.getAttribute("escuela");
		String codigoId = (String) session.getAttribute("codigoEmpleado");

		String cicloGrupoId = request.getParameter("CicloGrupoId");
		String cursoId = request.getParameter("CursoId");
		String cicloId = (String) session.getAttribute("cicloId");
		String planId = aca.plan.PlanCurso.getPlanId(conElias, cursoId);

		String evaluaConPunto = aca.plan.PlanCurso.getPunto(conElias,
				cursoId); /* Evalua con punto decimal el cursoId */
		int escala = aca.ciclo.Ciclo.getEscala(conElias,
				cicloId); /* La escala de evaluacion del ciclo (10 o 100) */

		empPersonal.mapeaRegId(conElias, codigoId);
		cicloGrupoCurso.mapeaRegId(conElias, cicloGrupoId, cursoId);

		ArrayList<aca.ciclo.CicloPromedio> lisPromedio = CicloPromedioL.getListCiclo(conElias, cicloId,
				" ORDER BY PROMEDIO_ID");
		ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos = kardexLista.getListAll(conElias, escuelaId,
				"AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId
						+ "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");

		String accion = request.getParameter("Accion") == null ? "" : request.getParameter("Accion");
		String msj = "";

		if (accion.equals("1")) { //Guardar Conducta
			String promedio = request.getParameter("Promedio");

			conElias.setAutoCommit(false);//** BEGIN TRANSACTION **
			boolean error = false;

			int cont = 0;
			for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {

				kardexConducta.setCodigoId(kardex.getCodigoId());
				kardexConducta.setCicloGrupoId(cicloGrupoId);
				kardexConducta.setCursoId(cursoId);
				kardexConducta.setPromedioId(promedio);
				kardexConducta.setEvaluacionId("0");

				String conducta = request.getParameter("conducta" + cont + "-" + promedio);

				if (conducta != null) {
					if (conducta.equals("")) {//Si no tiene nota entonces eliminala si es que existe, si no pues ignora esa nota

						if (kardexConducta.existeReg(conElias)) {
							if (kardexConducta.deleteReg(conElias)) {
								//Elimino correctamente
							} else {
								error = true;
								break;
							}
						}

					} else {//Si tiene nota entonces guardarla

						kardexConducta.setConducta(conducta);

						if (kardexConducta.existeReg(conElias)) {
							if (kardexConducta.updateReg(conElias)) {
								//Modificado correctamente
							} else {
								error = true;
								break;
							}
						} else {
							if (kardexConducta.insertReg(conElias)) {
								//Guardado correctamente
							} else {
								error = true;
								break;
							}
						}

					}
				}

				cont++;
			}

			//COMMIT OR ROLLBACK TO DB
			if (error) {
				conElias.rollback();
				msj = "NoGuardo";
			} else {
				conElias.commit();
				msj = "Guardado";
			}

			conElias.setAutoCommit(true);//** END TRANSACTION **

		}

		pageContext.setAttribute("resultado", msj);

		ArrayList<aca.kardex.KrdxAlumConducta> lisKardexConducta = kardexConductaLista.getListAll(conElias,
				"WHERE CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId
						+ "' ORDER BY ALUM_APELLIDO(CODIGO_ID), EVALUACION_ID");

		planCurso.mapeaRegId(conElias, cursoId);

		java.util.HashMap<String, aca.ciclo.CicloGrupoEval> mapConducta = aca.ciclo.CicloGrupoEvalLista
				.getMapConducta(conElias, cicloGrupoId, cursoId, planId);
%>

<div id="content">
	<h3>
		<fmt:message key="maestros.RegistroConducta" />
		<small>(&nbsp; <%=empPersonal.getNombre() + " " + empPersonal.getApaterno() + " " + empPersonal.getAmaterno()%>
			| <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%>
			| <%=aca.plan.Plan.getNombrePlan(conElias, planId)%> )&nbsp;
		</small>
	</h3>
	<%
		if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")) {
	%>
	<div class='alert alert-success'>
		<fmt:message key="aca.${resultado}" />
	</div>
	<%
		} else if (!msj.equals("")) {
	%>
	<div class='alert alert-danger'>
		<fmt:message key="aca.${resultado}" />
	</div>
	<%
		}
	%>
	<%
		cicloGrupo.mapeaRegId(conElias, cicloGrupoCurso.getCicloGrupoId());
			String url = "evaluar.jsp";
			if (aca.catalogo.CatEsquemaLista.getEsquemaEvaluacion(conElias,
					(String) session.getAttribute("escuela"), cicloGrupo.getGrado(), cicloGrupoCurso.getCursoId())
					.equals("C")) {/* SI EVALUA POR COMPETENCIA */
				url = "evaluarCompetencias.jsp";
			}
	%>
	<div class="well">
		<a
			href="<%=url%>?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>"
			class="btn btn-primary btn-mobile"><i
			class="icon-arrow-left icon-white"></i>
		<fmt:message key="boton.Regresar" /></a>
	</div>

	<!--  -------------------- TABLA DE EVALUACIONES -------------------- -->

	<table class="table table-condensed table-bordered table-striped">
		<tr>
			<th class="text-center">#</th>
			<th><fmt:message key="aca.Descripcion" /></th>
		</tr>
		<%
			int cont = 0;
				for (aca.ciclo.CicloPromedio prom : lisPromedio) {
					cont++;
		%>

		<tr>
			<td class="text-center"><%=cont%></td>
			<td><a
				href="javascript:muestraInput('<%=prom.getPromedioId()%>');"> <%=prom.getNombre()%>
			</a></td>
		</tr>
		<%
			}
		%>
	</table>

	<!--  -------------------- TABLA DE ALUMNOS -------------------- -->

	<form
		action="evaluarConductaProm.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>"
		name="forma" method="post">
		<input type="hidden" name="Accion" /> <input type="hidden"
			name="Promedio" />

		<table class="table table-condensed table-bordered table-striped">

			<thead>
				<tr>
					<th class="text-center">#</th>
					<th class="text-center"><fmt:message key="aca.Codigo" /></th>
					<th><fmt:message key="aca.NombreDelAlumno" /></th>
					<%
						cont = 0;
							for (aca.ciclo.CicloPromedio prom : lisPromedio) {
								cont++;
					%>
					<th style="width: 3%;" class="text-center"
						title="<%=prom.getNombre()%>"><%=cont%></th>
					<%
						}
					%>
					<th class="text-center"><fmt:message key="aca.Total" /></th>
				</tr>
			</thead>

			<%
				int i = 0;
					for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
			%>
			<tr>
				<td class="text-center"><%=i + 1%></td>
				<td class="text-center"><%=kardex.getCodigoId()%></td>
				<td><%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>

					<%
						if (kardex.getTipoCalId().equals("6")) {
					%> <span
					class="label label-important"
					title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />"><fmt:message
							key="aca.Baja" /></span> <%
 	}
 %></td>
				<%
					float sumaConducta = 0;
							int cantidadEvaluaciones = 0;
							for (aca.ciclo.CicloPromedio prom : lisPromedio) {

								String conducta = "-";

								for (aca.kardex.KrdxAlumConducta kardexConductaAlumno : lisKardexConducta) {
									
									if (kardexConductaAlumno.getCodigoId().equals(kardex.getCodigoId())&& 
											prom.getPromedioId().equals(kardexConductaAlumno.getPromedioId()) &&
											kardexConductaAlumno.getEvaluacionId().equals("0")) {
										
										// Verifica si la materia evalua con decimales
										if (evaluaConPunto.equals("S")) {
											conducta = frmDecimal.format(Double.parseDouble(kardexConductaAlumno.getConducta()))
													.replaceAll(",", ".");
										} else {
											conducta = frmEntero.format(Double.parseDouble(kardexConductaAlumno.getConducta()))
													.replaceAll(",", ".");
										}

										sumaConducta += Float.parseFloat(kardexConductaAlumno.getConducta());
										cantidadEvaluaciones++;
									}
								}
				%>
				<td class="text-center">
					<div><%=conducta%></div> <%
 	if (!kardex.getTipoCalId()
 						.equals("6")) { /* Si el alumno no se ha dado de baja puede editar su nota */
 %>
					<div class="editar<%=prom.getPromedioId()%>"
						style="display: none;">
						<input style="margin-bottom: 0; text-align: center;"
							class="input-mini onlyNumbers"
							data-allow-decimal="<%=evaluaConPunto.equals("S") ? "si" : "no"%>"
							data-max-num="<%=escala%>" type="text" tabindex="<%=i + 1%>"
							name="conducta<%=i%>-<%=prom.getPromedioId()%>"
							id="conducta<%=i%>-<%=prom.getPromedioId()%>"
							value="<%=conducta.equals("-") ? "" : conducta%>" />
					</div> <%
 	}
 %>
				</td>
				<%
					}

							String total = "-";
							if (sumaConducta != 0) {
								total = frmDecimal.format((double) sumaConducta / (double) cantidadEvaluaciones).replace(',',
										'.');
							}
				%>

				<td class="text-center"><%=total%></td>
			</tr>
			<%
				i++;
					}
			%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<%
					for (aca.ciclo.CicloPromedio prom : lisPromedio) {
				%>
				<td class="text-center">
					<div class="editar<%=prom.getPromedioId()%>"
						style="display: none;">
						<a tabindex="<%=lisKardexAlumnos.size()%>"
							class="btn btn-primary btn-block" type="button"
							href="javascript:guardarCalificaciones( '<%=prom.getPromedioId()%>' );"><fmt:message
								key="boton.Guardar" /></a>
					</div>
				</td>

				<%
					}
				%>
				<td>&nbsp;</td>
			</tr>

		</table>
	</form>
</div>


<%@ include file="../../cierra_elias.jsp"%>