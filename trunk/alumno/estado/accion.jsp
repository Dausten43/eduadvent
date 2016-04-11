<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="aca.alumno.AlumCiclo"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.ciclo.Ciclo"%>
<jsp:useBean id="alumCiclo" scope="page" class="aca.alumno.AlumCiclo" />
<jsp:useBean id="alumPlan" scope="page" class="aca.alumno.AlumPlan" />
<jsp:useBean id="PeriodoL" scope="page"
	class="aca.ciclo.CicloPeriodoLista" />

<script>
	function grabar() {
		document.frmciclo.Accion.value = "2";
		document.frmciclo.submit();
	}
</script>

<%
	String codigo_personal = (String) session
				.getAttribute("codigoAlumno");
		String cicloId = request.getParameter("cicloId");
		String periodoId = request.getParameter("periodoId");
		String cicloNombre = aca.ciclo.Ciclo.getCicloNombre(conElias,
				cicloId);
		int nAccion = request.getParameter("Accion") == null ? 0
				: Integer.parseInt(request.getParameter("Accion"));

		String planId = aca.alumno.AlumPlan.getPlanActual(conElias,
				codigo_personal);
		String clasFin = aca.alumno.AlumPersonal.getClasFinId(conElias,
				codigo_personal);
		String nivelId = aca.plan.Plan.getNivel(conElias, planId);

		String resultado = "";

		ArrayList listPeriodos = PeriodoL.getListCiclo(conElias,
				cicloId, "ORDER BY PERIODO_ID");

		switch (nAccion) {
		case 1: {
			resultado = "LlenarFormulario";
			break;
		}

		case 2: { // Grabar
			alumCiclo.mapeaRegId(conElias, codigo_personal, cicloId,
					periodoId);

			if (alumCiclo.existeReg(conElias) == false) {
				alumPlan.mapeaRegActual(conElias, codigo_personal);

				alumCiclo.setCodigoId(codigo_personal);
				alumCiclo.setCicloId(cicloId);
				alumCiclo.setPeriodoId(periodoId);
				alumCiclo.setPlanId(planId);
				alumCiclo.setFecha(aca.util.Fecha.getHoy());
				alumCiclo.setClasfinId(clasFin);
				alumCiclo.setNivel(nivelId);
				alumCiclo.setGrado(alumPlan.getGrado());
				alumCiclo.setGrupo(alumPlan.getGrupo());
				alumCiclo.setEstado(request.getParameter("estado"));

				if (alumCiclo.insertReg(conElias)) {
					resultado = "Grabado: ";					
				} else {
					resultado = "NoGrabo: " ;
				}
			} else {
				alumCiclo.setEstado(request.getParameter("estado"));

				if (alumCiclo.updateReg(conElias)) {
					resultado = "Modificado";					
				} else {
					resultado = "NoGrabo: ";
				}
			}

			break;
		}
		}
		pageContext.setAttribute("resultado", resultado);
%>
<body>
	<div id="content">
		<h2><fmt:message key="alumnos.ElegirCiclo"/></h2>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="estado.jsp"><i
				class="icon-list icon-white"></i> <fmt:message key="boton.Listado"/></a>
		</div>

		<form action="accion.jsp" method="post" name="frmciclo" target="_self">
			<input name="Accion" type="hidden"> <input name="cicloId"
				type="hidden" value="<%=cicloId%>">

			<div class="row">
				<div class="span4">
					<fieldset>
						<div class="control-group ">

							<label for="CursoId"> <fmt:message key="aca.Alumno"/>: </label>
							<%=AlumPersonal.getNombre(conElias, codigo_personal,
						"ORDER BY 1")%>
							-
							<%=codigo_personal%>
						</div>
						<div class="control-group ">
							<label for="CursoNombre"> <fmt:message key="aca.Nombre"/>: </label> <input
								name="cicloNombre" type="text" id="cicloNombre"
								value="<%=Ciclo.nombreCiclo(conElias, cicloId)%>" size="40"
								maxlength="40"> <input type="hidden" id="cicloId "
								name="cicloId" value="<%=cicloId%>">
						</div>
						<div class="control-group ">
							<label for="CursoCorto"> <fmt:message key="aca.Periodo"/>: </label> <select
								name="periodoId">
								<%
									for (int i = 0; i < listPeriodos.size(); i++) {
											aca.ciclo.CicloPeriodo periodo = (aca.ciclo.CicloPeriodo) listPeriodos
													.get(i);
								%>
								<option
									<%if (alumCiclo.getPeriodoId().equals(periodo.getPeriodoId()))
						out.print(" Selected ");%>
									value="<%=periodo.getPeriodoId()%>"><%=periodo.getPeriodoNombre()%></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="control-group ">
							<label for="Grado"> <fmt:message key="aca.Estado"/>: </label> <select name="estado">
								<option value="A"
									<%if (alumCiclo.getEstado().equals("A"))
					out.println("Selected");%>>A</option>
								<option value="M"
									<%if (alumCiclo.getEstado().equals("M"))
					out.println("Selected");%>>M</option>
								<option value="I"
									<%if (alumCiclo.getEstado().equals("I"))
					out.println("Selected");%>>I</option>
								<option value="B"
									<%if (alumCiclo.getEstado().equals("B"))
					out.println("Selected");%>>B</option>
							</select>
						</div>
					</fieldset>
				</div>
			</div>
		</form>

		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="javascript:grabar()"><i
				class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar"/></a>
		</div>

	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>