<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Ciudad" scope="page" class="aca.catalogo.CatCiudad" />
<head>
<script>
	function Nuevo() {
		document.frmCiudad.CiudadId.value = " ";
		document.frmCiudad.CiudadNombre.value = " ";
		document.frmCiudad.Accion.value = "1";
		document.frmCiudad.submit();
	}

	function Grabar() {
		if (document.frmCiudad.CiudadId.value != ""
				&& document.frmCiudad.CiudadNombre != "") {
			document.frmCiudad.Accion.value = "2";
			document.frmCiudad.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Modificar() {
		document.frmCiudad.Accion.value = "3";
		document.frmCiudad.submit();
	}

	function Borrar() {
		if (document.frmCiudad.CiudadId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmCiudad.Accion.value = "4";
				document.frmCiudad.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmCiudad.CiudadId.focus();
		}
	}

	function Consultar() {
		document.frmCiudad.Accion.value = "5";
		document.frmCiudad.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		String sResultado = "";
		Ciudad.setPaisId(request.getParameter("PaisId"));
		Ciudad.setEstadoId(request.getParameter("EstadoId"));

		if (nAccion == 1)
			Ciudad.setCiudadId(Ciudad.maximoReg(conElias,
					Ciudad.getPaisId(), Ciudad.getEstadoId()));
		else
			Ciudad.setCiudadId(request.getParameter("CiudadId"));

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {
		case 2: { // Grabar
			Ciudad.setCiudadNombre(request.getParameter("CiudadNombre"));
			if (Ciudad.existeReg(conElias) == false) {
				conElias.setAutoCommit(false);
				if (Ciudad.insertReg(conElias)) {
					sResultado = "Guardado";
					conElias.commit();
				} else {
					sResultado = "NoGuardo";
				}
				conElias.setAutoCommit(true);
			} else {
				sResultado = "Existe";
			}
			break;
		}
		case 3: { // Modificar
			Ciudad.setCiudadNombre(request.getParameter("CiudadNombre"));
			if (Ciudad.existeReg(conElias) == true) {
				conElias.setAutoCommit(false);
				if (Ciudad.updateReg(conElias)) {
					sResultado = "Modificado";
					conElias.commit();
				} else {
					sResultado = "NoModifico";
				}
				conElias.setAutoCommit(true);
			} else {
				sResultado = "NoExiste";
			}
			break;
		}
		case 4: { // Borrar
			if (Ciudad.existeReg(conElias) == true) {
				conElias.setAutoCommit(false);
				if (Ciudad.deleteReg(conElias)) {
					sResultado = "Eliminado";
					conElias.commit();
				} else {
					sResultado = "NoElimino";
				}
				conElias.setAutoCommit(true);

			} else {
				sResultado = "NoExiste";
			}

			break;
		}
		case 5: { // Consultar			
			if (Ciudad.existeReg(conElias) == true) {
				Ciudad.mapeaRegId(conElias,
						request.getParameter("PaisId"),
						request.getParameter("EstadoId"),
						Ciudad.getCiudadId());
				sResultado = "Consulta";
			} else {
				sResultado = "NoExiste";
			}
			break;
		}
		}
		
	pageContext.setAttribute("resultado", sResultado);
%>

<body>
	<div id="content">
		<h2><fmt:message key="catalogo.AnadirCiudad" /></h2>
		<%
			if (!sResultado.equals("")) {
		%>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary"
				href="ciudad.jsp?PaisId=<%=Ciudad.getPaisId()%>&EstadoId=<%=Ciudad.getEstadoId()%>"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
		</div>

		<form action="accion_c.jsp" method="post" name="frmCiudad" target="_self">
			
			<input type="hidden" name="Accion">
			<input type="hidden" name="PaisId" value="<%=Ciudad.getPaisId()%>">
			<input type="hidden" name="EstadoId" value="<%=Ciudad.getEstadoId() %>">

			<fieldset>
				<div class="control-group ">
					<label for="CiudadId"> <fmt:message key="aca.Clave" />: </label> <input name="CiudadId"
						type="text" id="CiudadId" size="3" maxlength="3"
						value="<%=Ciudad.getCiudadId()%>">
					</td>
				</div>

				<div class="control-group ">
					<label for="CiudadNombre"> <fmt:message key="aca.Nombre" />: </label> <input
						name="CiudadNombre" type="text" id="CiudadNombre"
						value="<%=Ciudad.getCiudadNombre()%>" size="40" maxlength="40">
				</div>
			</fieldset>
			<div class="well" style="overflow: hidden;">
				<a class="btn btn-primary" href="javascript:Nuevo()"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
				&nbsp;<a class="btn btn-primary" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
				&nbsp; <a class="btn btn-primary" href="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
				&nbsp; <a class="btn btn-primary" href="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
				&nbsp; <a class="btn btn-primary" href="javascript:Consultar()"><i class="icon-search icon-white"></i> <fmt:message key="boton.Consultar" /></a>
			</div>
		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
