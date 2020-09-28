<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.Ciclo" />
<jsp:useBean id="Reporte" scope="page" class="aca.cond.CondReporte" />
<jsp:useBean id="ReporteL" scope="page" class="aca.cond.CondTipoReporteLista" />
<jsp:useBean id="EmpleadoL" scope="page" class="aca.empleado.EmpPersonalLista" />

<head>

<script>
	function Nuevo() {
		document.frmReporte.TipoId.value = "";
		document.frmReporte.Fecha.value = "";
		document.frmReporte.Comentario.value = "";
		document.frmReporte.Estado.value = "";
		document.frmReporte.Compromiso.value = "";
		document.frmReporte.Folio.value = "";
		document.frmReporte.Accion.value = "1";
		document.frmReporte.submit();
	}

	function Grabar() {
		if (document.frmReporte.CodigoId.value != ""
				&& document.frmReporte.CicloId.value != "") {
			document.frmReporte.Accion.value = "2";
			document.frmReporte.submit();
		} else {
			alert("<fmt:message key="aca.LlenarFormulario" />");
		}
	}

	function Modificar() {
		document.frmReporte.Accion.value = "3";
		document.frmReporte.submit();
	}

	function Borrar() {
		if (document.frmReporte.CodigoId.value != "") {
			if (confirm("<fmt:message key="aca.EliminarRegistro" />") == true) {
				document.frmReporte.Accion.value = "4";
				document.frmReporte.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmReporte.CodigoId.focus();
		}
	}

	function Consultar() {
		document.frmReporte.Accion.value = "5";
		document.frmReporte.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		String escuelaId 		= (String) session.getAttribute("escuela");
		String codigoAlumno 	= (String) session.getAttribute("codigoAlumno");
		String codigoEmpleado 	= (String) session.getAttribute("codigoEmpleado");
		String cicloId			= request.getParameter("CicloId");

		String accion 			= request.getParameter("Accion") == null ? "1":request.getParameter("Accion");
		int nAccion 			= Integer.parseInt(accion);
		String TipoId 			= request.getParameter("TipoId");
		String sResultado 		= "";
		String salto			= "X";
		
		ArrayList lisRep = ReporteL.getListEscuela(conElias, escuelaId,	"ORDER BY 1");
		ArrayList lisEmp = EmpleadoL.getListEmp(conElias, escuelaId, "AND ESTADO = 'A' ORDER BY APATERNO, AMATERNO, NOMBRE");

		int i = 0;
		int y = 0;

		if (nAccion == 1)
			Reporte.setFolio(Reporte.maximoReg(conElias));
		else
			Reporte.setFolio(request.getParameter("Folio"));

		// Operaciones a realizar en la pantalla
		switch (nAccion) {
			case 1: { // Nuevo			
				sResultado = "LlenarFormulario";
				Reporte.setFecha(aca.util.Fecha.getHoy());
				break;
			}
			case 2: { // Grabar			
				Reporte.setCodigoId(request.getParameter("CodigoId"));
				Reporte.setTipoId(request.getParameter("TipoId"));
				Reporte.setFecha(request.getParameter("Fecha"));
				Reporte.setComentario(request.getParameter("Comentario"));
				Reporte.setEstado(request.getParameter("Estado"));
				Reporte.setFolio(request.getParameter("Folio"));
				Reporte.setCicloId(request.getParameter("CicloId"));
				Reporte.setCompromiso(request.getParameter("Compromiso"));
				Reporte.setEmpleadoId(request.getParameter("Reporto"));
				conElias.setAutoCommit(false);
	
				if (Reporte.existeReg(conElias) == false) {
					if (Reporte.insertReg(conElias)) {
						sResultado = "Grabado";
						conElias.commit();
						salto = "repalumno.jsp";
					} else {
						sResultado = "NoGrabo";
					}
				} else {
					if (Reporte.updateReg(conElias)) {
						sResultado = "Modificado";
						conElias.commit();
						salto = "repalumno.jsp";
					} else {
						sResultado = "NoCambio";
					}
				}
				conElias.setAutoCommit(true);
			
				break;
			}
			case 4: { // Borrar		
				Reporte.setCodigoId(request.getParameter("CodigoId"));
				Reporte.setFolio(request.getParameter("Folio"));
				Reporte.setCicloId(request.getParameter("CicloId"));
				conElias.setAutoCommit(false);
				if (Reporte.existeReg(conElias) == true) {
					if (Reporte.deleteReg(conElias)) {
						sResultado = "Eliminado";
						conElias.commit();
						salto = "repalumno.jsp";
					} else {
						sResultado = "NoBorro";
					}
				} else {
					sResultado = "NoExiste";
				}
				conElias.setAutoCommit(true);
	
				break;
			}
			case 5: { // Consultar
	
				Reporte.setCicloId(request.getParameter("CicloId"));
				Reporte.setFolio(request.getParameter("Folio"));
				if (Reporte.existeReg(conElias) == true) {
					Reporte.mapeaRegId(conElias);
					sResultado = "Consulta";
				} else {
					sResultado = "NoExiste";
				}
				break;
			}
		}
%>
<body>
	<div id="content">
		<h2><fmt:message key="disciplina.AgregarReporte" /></h2>
		<div class="well">
			<a class="btn btn-primary" href="repalumno.jsp"><i class="icon-list icon-white"></i><fmt:message key="boton.Listado" /></a>
		</div>

		<form action="accion.jsp" method="post" name="frmReporte" target="_self">
			<input type="hidden" name="Accion"> <input name="Pec" type="hidden">

			<div class="row">

				<div class="span4">

					<fieldset>
						<div class="control-group ">
							<label for="Folio"> <fmt:message key="aca.Folio" />: </label>
							<%=Reporte.getFolio()%>
							<input type="hidden" name="Folio" value="<%=Reporte.getFolio()%>">
						</div>

						<div class="control-group ">
							<label for="CodigoId"> <fmt:message key="aca.Matricula" />: </label>
							<%=codigoAlumno%>
							<input type="hidden" name="CodigoId" value="<%=codigoAlumno%>">
						</div>

						<div class="control-group ">
							<label for="Reporto"> <fmt:message key="aca.Reporto" />: </label> <select name="Reporto" id="Reporto">
								<%
									for (i = 0; i < lisEmp.size(); i++) {
											aca.empleado.EmpPersonal empleado = (aca.empleado.EmpPersonal) lisEmp
													.get(i);
								%>
								<option value="<%=empleado.getCodigoId()%>"
									<%if (empleado.getCodigoId().equals(Reporte.getEmpleadoId())) out.print("selected");%>>
									[<%=empleado.getCodigoId()%>]
									<%=empleado.getApaterno()%>
									<%=empleado.getAmaterno()%>
									<%=empleado.getNombre()%></option>
								<%
									}
								%>
							</select>
						</div>

						<div class="control-group ">
							<label for="Fecha"> 
								<fmt:message key="aca.Fecha" />: </label> 
								<input name="Fecha" type="text" id="Fecha" size="10" maxlength="10" value="<%=Reporte.getFecha()%>" readonly="YES"> 
						</div>

					</fieldset>

				</div>

				<div class="span4">

					<fieldset>
						<div class="control-group ">
							<label for="CicloId"> <fmt:message key="aca.Ciclo" />: </label>
							<%=cicloId%>
							<input type="hidden" name="CicloId" id="CicloId" value="<%=cicloId%>">
						</div>

						<div class="control-group ">
							<label for="TipoId"> <fmt:message key="aca.Tipo" />: </label> <select name="TipoId" id="TipoId">
								<%
									for (i = 0; i < lisRep.size(); i++) {
										aca.cond.CondTipoReporte repor = (aca.cond.CondTipoReporte) lisRep.get(i);
								%>
								<option value="<%=repor.getTipoId()%>"
									<%if (repor.getTipoId().equals(TipoId)) out.print("selected");%>><%=repor.getTipoNombre()%>
								</option>
								<%
									}
								%>
							</select>
						</div>

						<div class="control-group ">
							<label for="Estado"> <fmt:message key="aca.Estado" />: </label> <select name="Estado" id="Estado");">

								<option value="A" <%if (Reporte.getEstado().equals("A")) out.print("selected");%>><fmt:message key="aca.Activo" /></option>
								<option value="I" <%if (Reporte.getEstado().equals("I")) out.print("selected");%>><fmt:message key="aca.Inactivo" /></option>

							</select>
						</div>

						<div class="control-group ">
							<label for="Comentario"> <fmt:message key="aca.Comentario" />: </label>
							<textarea id="Comentario" name="Comentario" cols="50" rows="3"><%=Reporte.getComentario()%></textarea>
						</div>
						<div class="control-group ">
							<label for="Compromiso"> <fmt:message key="aca.Compromiso" />: </label>
							<textarea id="Compromiso" name="Compromiso" cols="50" rows="3"><%=Reporte.getCompromiso()%></textarea>
						</div>
					</fieldset>

				</div>
			</div>
			<div class="well">
				<a class="btn btn-primary" href="javascript:Nuevo();"><i
					class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a> &nbsp; <a
					class="btn btn-primary" href="javascript:Grabar()"><i
					class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a> &nbsp; <a
					class="btn btn-primary" href="javascript:Borrar()"><i
					class="icon-remove icon-white"></i> <fmt:message key="boton.Borrar" /></a> &nbsp; <a
					class="btn btn-primary" href="javascript:Consultar()"><i
					class="icon-search icon-white"></i> <fmt:message key="boton.Consultar" /></a>
			</div>
		</form>
	</div>
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>
