<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Pais" scope="page" class="aca.catalogo.CatPais" />
<head>
<script>
	function Nuevo() {
		document.frmPais.PaisId.value = " ";
		document.frmPais.PaisNombre.value = " ";
		document.frmPais.Accion.value = "1";
		document.frmPais.submit();
	}

	function Grabar() {
		if (document.frmPais.PaisId.value != ""
				&& document.frmPais.NombrePais != "") {
			document.frmPais.Accion.value = "2";
			document.frmPais.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Modificar() {
		document.frmPais.Accion.value = "3";
		document.frmPais.submit();
	}

	function Borrar() {
		if (document.frmPais.PaisId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmPais.Accion.value = "4";
				document.frmPais.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmPais.PaisId.focus();
		}
	}

	function Consultar() {
		frmPais.Accion.value = "5";
		frmPais.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		String strResultado = "";

		if (nAccion == 1) {
			Pais.setPaisId(Pais.maximoReg(conElias));
		} else {
			Pais.setPaisId(request.getParameter("PaisId"));
		}

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {
		case 2: { // Grabar
			Pais.setPaisNombre(request.getParameter("PaisNombre"));
			if (Pais.existeReg(conElias) == false) {
				conElias.setAutoCommit(false);
				if (Pais.insertReg(conElias)) {
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
			Pais.setPaisNombre(request.getParameter("PaisNombre"));
			if (Pais.existeReg(conElias) == true) {
				conElias.setAutoCommit(false);
				if (Pais.updateReg(conElias)) {
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
			if (Pais.existeReg(conElias) == true) {
				conElias.setAutoCommit(false);
				if (Pais.deleteReg(conElias)) {
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
			if (Pais.existeReg(conElias) == true) {
				Pais.mapeaRegId(conElias,request.getParameter("PaisId"));
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
		<h2><fmt:message key="catalogo.AnadirPais" /></h2>
		<%
			if (!strResultado.equals("")) {
		%>
		<div class='alert alert-error'><%=strResultado%></div>
		<%
			}
		%>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="pais.jsp"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
		</div>

		<form action="accion_p.jsp" method="post" name="frmPais"
			target="_self">
			<input type="hidden" name="Accion">
			<fieldset>
				<div class="control-group ">
					<label for="ClasfinId"> <fmt:message key="aca.Clave" />: </label> <input name="PaisId"
						type="text" id="PaisId" size="3" maxlength="3"
						value="<%=Pais.getPaisId()%>">
				</div>

				<div class="control-group ">
					<label for="ClasfinNombre"> <fmt:message key="aca.Nombre" />: </label> <input
						name="PaisNombre" type="text" id="PaisNombre"
						value="<%=Pais.getPaisNombre()%>" size="40" maxlength="40">
					</td>


				</div>
			</fieldset>


			<div class="well" style="overflow: hidden;">
				<a class="btn btn-primary" href="javascript:Nuevo()"><i
					class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a> &nbsp;<a
					class="btn btn-primary" href="javascript:Grabar()"><i
					class="icon-ok  icon-white"></i> <fmt:message key="boton.Guardar" /></a> &nbsp; <a
					class="btn btn-primary" href="javascript:Modificar()"><i
					class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a> &nbsp; <a
					class="btn btn-primary" href="javascript:Borrar()"><i
					class="icon-remove  icon-white"></i> <fmt:message key="boton.Eliminar" /></a> &nbsp; <a
					class="btn btn-primary" href="javascript:Consultar()"><i
					class="icon-search icon-white"></i> <fmt:message key="aca.Consulta" /></a>
			</div>

		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
