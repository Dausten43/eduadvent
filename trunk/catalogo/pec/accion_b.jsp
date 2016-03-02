<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Barrio" scope="page" class="aca.catalogo.CatBarrio" />
<head>
<script>
	function Nuevo() {
		document.frmBarrio.BarrioId.value = " ";
		document.frmBarrio.CiudadId.value = " ";
		document.frmBarrio.BarrioNombre.value = " ";
		document.frmBarrio.Accion.value = "1";
		document.frmBarrio.submit();
	}

	function Grabar() {
		if (document.frmBarrio.BarrioId.value != ""
				&& document.frmBarrio.BarrioNombre != "") {
			document.frmBarrio.Accion.value = "2";
			document.frmBarrio.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Modificar() {
		document.frmBarrio.Accion.value = "3";
		document.frmBarrio.submit();
	}

	function Borrar() {
		if (document.frmBarrio.CiudadId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmBarrio.Accion.value = "4";
				document.frmBarrio.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmBarrio.CiudadId.focus();
		}
	}

	function Consultar() {
		document.frmBarrio.Accion.value = "5";
		document.frmBarrio.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		String sResultado = "";
		Barrio.setPaisId(request.getParameter("PaisId"));
		Barrio.setEstadoId(request.getParameter("EstadoId"));
		Barrio.setCiudadId(request.getParameter("CiudadId"));

		if (nAccion == 1)
			Barrio.setBarrioId(Barrio.maximoReg(conElias, Barrio.getPaisId(), Barrio.getEstadoId(), Barrio.getCiudadId()));
		else
			Barrio.setBarrioId(request.getParameter("BarrioId"));

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {
		case 2: { // Grabar
			Barrio.setBarrioId(Barrio.maximoReg(conElias, Barrio.getPaisId(), Barrio.getEstadoId(), Barrio.getCiudadId()));
			Barrio.setBarrioNombre(request.getParameter("BarrioNombre"));
		System.out.println("Datos:"+Barrio.getCiudadId()+":"+Barrio.getBarrioId());
			if (Barrio.existeReg(conElias) == false) {
				if (Barrio.insertReg(conElias)) {
					sResultado = "Guardado";					
				} else {
					sResultado = "NoGuardo";
				}
			} else {
				sResultado = "Existe";
			}
			break;
		}
		case 3: { // Modificar
			Barrio.setBarrioNombre(request.getParameter("BarrioNombre"));
			if (Barrio.existeReg(conElias) == true) {
				if (Barrio.updateReg(conElias)) {
					sResultado = "Modificado";					
				} else {
					sResultado = "NoModifico";
				}
			} else {
				sResultado = "NoExiste";
			}
			break;
		}
		case 4: { // Borrar
			if (Barrio.existeReg(conElias) == true) {
				if (Barrio.deleteReg(conElias)) {
					sResultado = "Eliminado";					
				} else {
					sResultado = "NoElimino";
				}

			} else {
				sResultado = "NoExiste";
			}

			break;
		}
		case 5: { // Consultar			
			if (Barrio.existeReg(conElias) == true) {
				Barrio.mapeaRegId(conElias,
						request.getParameter("PaisId"),
						request.getParameter("EstadoId"),
						request.getParameter("CiudadId"),
						Barrio.getBarrioId());
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
			href="ciudad.jsp?PaisId=<%=Barrio.getPaisId()%>&EstadoId=<%=Barrio.getEstadoId()%>"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
	</div>

	<form action="accion_b.jsp" method="post" name="frmBarrio" target="_self">
		
		<input type="hidden" name="Accion">
		<input type="hidden" name="PaisId" value="<%=Barrio.getPaisId()%>">
		<input type="hidden" name="EstadoId" value="<%=Barrio.getEstadoId() %>">
		<input type="hidden" name="CiudadId" value="<%=Barrio.getCiudadId() %>">

		<fieldset>
			<div class="control-group ">
				<label for="BarrioId"> <fmt:message key="aca.Clave" />: </label>
				<input name="BarrioId" type="text" id="BarrioId" size="3" maxlength="3" value="<%=Barrio.getBarrioId()%>">					
			</div>
			<div class="control-group ">
				<label for="BarrioNombre"> <fmt:message key="aca.Nombre" />: </label>
				<input name="BarrioNombre" type="text" id="BarrioNombre"
					value="<%=Barrio.getBarrioNombre()%>" size="40" maxlength="40">
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
