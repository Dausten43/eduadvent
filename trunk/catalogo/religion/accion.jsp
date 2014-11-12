<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="religion" scope="page" class="aca.catalogo.CatReligion" />
<head>
<script>
	function Nuevo() {
		document.frmReligion.ReligionId.value = " ";
		document.frmReligion.ReligionNombre.value = " ";
		document.frmReligion.Accion.value = "1";
		document.frmReligion.submit();
	}

	function Grabar() {

		if (document.frmReligion.ReligionId.value != "") {

			document.frmReligion.Accion.value = "2";
			document.frmReligion.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Modificar() {
		document.frmReligion.Accion.value = "3";
		document.frmReligion.submit();
	}

	function Borrar() {

		if (document.frmReligion.ReligionId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmReligion.Accion.value = "4";
				document.frmReligion.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmReligion.ReligionId.focus();
		}
	}

	function Consultar() {
		document.frmReligion.Accion.value = "5";
		document.frmReligion.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		String sResultado = "";
		int i = 0;
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		ArrayList listor = new ArrayList();
		ArrayList lisReligion = new ArrayList();

		if (nAccion == 1)
			religion.setReligionId(religion.maximoReg(conElias));
		else
			religion.setReligionId(request.getParameter("ReligionId"));

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {

		case 2: { // Grabar			
			religion.setReligionId(request.getParameter("ReligionId"));
			religion.setReligionNombre(request
					.getParameter("ReligionNombre"));
			if (religion.existeReg(conElias) == false) {
				if (religion.insertReg(conElias)) {
					sResultado = "Guardado";
					conElias.commit();
				} else {
					sResultado = "NoGuardo";
				}
			} else {
				sResultado = "Existe";
			}

			break;
		}
		case 3: { // Modificar
			religion.setReligionId(request.getParameter("ReligionId"));
			religion.setReligionNombre(request
					.getParameter("ReligionNombre"));
			if (religion.existeReg(conElias) == true) {
				if (religion.updateReg(conElias)) {
					sResultado = "Modificado";
					conElias.commit();
				} else {
					sResultado = "NoExiste";
				}
			} else {
				sResultado = "No existe: " + religion.getReligionId();
			}
			break;
		}
		case 4: { // Borrar			
			if (religion.existeReg(conElias) == true) {
				if (religion.deleteReg(conElias)) {
					sResultado = "Eliminado";
					conElias.commit();
				} else {
					sResultado = "NoElimino";
				}
			} else {
				sResultado = "NoExiste";
			}

			break;
		}
		case 5: { // Consultar						
			if (religion.existeReg(conElias) == true) {
				religion.mapeaRegId(conElias,
						request.getParameter("ReligionId"));
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

		<h2><fmt:message key="catalogo.AnadirReligion" /></h2>
		<%
			if (!sResultado.equals("")) {
		%>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>

		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="religion.jsp"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
		</div>

		<form action="accion.jsp" method="post" name="frmReligion"
			target="_self">
			<input type="hidden" name="Accion"> <input name="Pec"
				type="hidden">

			<fieldset>
				<div class="control-group ">
					<label for="ReligionId"> <fmt:message key="aca.Id" />: </label> <input name="ReligionId"
						type="text" id="ReligionId" size="3" maxlength="3"
						value="<%=religion.getReligionId()%>">
				</div>

				<div class="control-group ">
					<label for="ClasfinNombre"> <fmt:message key="aca.Nombre" />: </label> <input
						name="ReligionNombre" type="text" id="ReligionNombre"
						value="<%=religion.getReligionNombre()%>" size="40" maxlength="40">

				</div>
			</fieldset>

			<div class="well" style="overflow: hidden;">
				<a class="btn btn-primary" href="javascript:Nuevo();"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
				&nbsp;<a class="btn btn-primary" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
				&nbsp; <a class="btn btn-primary" href="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
				&nbsp; <a class="btn btn-primary" href="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
			</div>

			<%
				listor = null;
					listor = null;
			%>

		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
