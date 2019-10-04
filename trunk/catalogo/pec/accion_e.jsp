<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="Estado" scope="page" class="aca.catalogo.CatEstado" />
<head>
<script>
	function Nuevo() {
		document.frmEstado.EstadoId.value = " ";
		document.frmEstado.EstadoNombre.value = " ";
		document.frmEstado.Accion.value = "1";
		document.frmEstado.submit();
	}

	function Grabar() {
		if (document.frmEstado.EstadoId.value != ""
				&& document.frmEstado.EstadoNombre.value != "") {
			document.frmEstado.Accion.value = "2";
			document.frmEstado.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Modificar() {
		document.frmEstado.Accion.value = "3";
		document.frmEstado.submit();
	}

	function Borrar() {
		if (document.frmEstado.EstadoId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmEstado.Accion.value = "4";
				document.frmEstado.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmEstado.EstadoId.focus();
		}
	}

	function Consultar() {
		document.frmEstado.Accion.value = "5";
		document.frmEstado.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		String strResultado = "";
		Estado.setPaisId(request.getParameter("PaisId"));

		if (nAccion == 1)
			Estado.setEstadoId(Estado.maximoReg(conElias,
					Estado.getPaisId()));
		else
			Estado.setEstadoId(request.getParameter("EstadoId"));
		Estado.setPaisId(request.getParameter("PaisId"));

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {
		case 2: { // Grabar
			Estado.setEstadoNombre(request.getParameter("EstadoNombre"));
			Estado.setClave(request.getParameter("Clave"));
			if (Estado.existeReg(conElias) == false) {
				conElias.setAutoCommit(false);
				if (Estado.insertReg(conElias)) {
					strResultado = "Guardado";
					conElias.commit();
				} else {
					strResultado = "NoGuardo";
				}
				conElias.setAutoCommit(true);
			} else {
				strResultado = "Existe";
			}

			break;
		}
		case 3: { // Modificar
			Estado.setEstadoNombre(request.getParameter("EstadoNombre"));
			Estado.setClave(request.getParameter("Clave"));
			if (Estado.existeReg(conElias) == true) {
				conElias.setAutoCommit(false);
				if (Estado.updateReg(conElias)) {
					strResultado = "Modificado";
					conElias.commit();
				} else {
					strResultado = "NoModifico";
				}
				conElias.setAutoCommit(true);
			} else {
				strResultado = "NoExiste";
			}
			break;
		}
		case 4: { // Borrar
			if (Estado.existeReg(conElias) == true) {
				conElias.setAutoCommit(false);
				if (Estado.deleteReg(conElias)) {
					strResultado = "Eliminado";
					conElias.commit();
				} else {
					strResultado = "NoElimino";
				}
				conElias.setAutoCommit(true);

			} else {
				strResultado = "NoExiste";
			}

			break;
		}
		case 5: { // Consultar			
			if (Estado.existeReg(conElias) == true) {
				Estado.mapeaRegId(conElias, Estado.getPaisId(),
						request.getParameter("EstadoId"));
				strResultado = "Consulta";
			} else {
				strResultado = "NoExiste";
			}
			break;
		}
		}
		
		pageContext.setAttribute("resultado", strResultado);
%>

<body>
	<div id="content">
		<h2><fmt:message key="catalogo.AnadirEdo" /></h2>
		<%
			if (!strResultado.equals("")) {
		%>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary"
				href="estado.jsp?PaisId=<%=Estado.getPaisId()%>"><i
				class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
		</div>
		<form action="accion_e.jsp" method="post" name="frmEstado"
			target="_self">
			<input type="hidden" name="Accion">
			<input type="hidden" name="PaisId" value="<%=Estado.getPaisId()%>">

			<fieldset>
				<div class="control-group ">
					<label for="EstadoId"> <fmt:message key="aca.Clave" />: </label> <input name="EstadoId"
						type="text" id="EstadoId" size="3" maxlength="3"
						value="<%=Estado.getEstadoId()%>">
				</div>

				<div class="control-group ">
					<label for="EstadoNombre"> <fmt:message key="aca.Nombre" />: </label> <input
						name="EstadoNombre" type="text" id="EstadoNombre"
						value="<%=Estado.getEstadoNombre()%>" size="40" maxlength="40">
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
