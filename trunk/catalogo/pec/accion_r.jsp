<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="Region" scope="page" class="aca.catalogo.CatRegion" />
<head>
<script>
	function Nuevo() {
		document.frmRegion.RegionId.value = " ";
		document.frmRegion.RegionNombre.value = " ";
		document.frmRegion.Accion.value = "1";
		document.frmRegion.submit();
	}

	function Grabar() {
		if (document.frmRegion.RegionId.value != ""
				&& document.frmRegion.RegionNombre.value != "") {
			document.frmRegion.Accion.value = "2";
			document.frmRegion.submit();
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Modificar() {
		document.frmRegion.Accion.value = "3";
		document.frmRegion.submit();
	}

	function Borrar() {
		if (document.frmRegion.RegionId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmRegion.Accion.value = "4";
				document.frmRegion.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmRegion.RegionId.focus();
		}
	}

	function Consultar() {
		document.frmRegion.Accion.value = "5";
		document.frmRegion.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		String strResultado = "";
		String pais = request.getParameter("PaisId")==null?"0":request.getParameter("PaisId");
		String regionId = request.getParameter("regionId")==null?"0":request.getParameter("regionId");
		Region.setPaisId(pais);

		if (nAccion == 1){
			Region.setRegionId(Region.maximoReg(conElias,
					Region.getPaisId()));
		}else{
			Region.setRegionId(regionId);
			Region.setPaisId(pais);
		}
		
		// Operaciones a realizar en la pantalla	
		switch (nAccion) {
		case 2: { // Grabar
			Region.setRegionNombre(request.getParameter("RegionNombre"));
			Region.setRegionId(request.getParameter("RegionId"));
			Region.setPaisId(pais);
			if (Region.existeReg(conElias) == false) {
				if (Region.insertReg(conElias)) {
					strResultado = "Guardado";
					conElias.commit();
				} else {
					strResultado = "NoGuardo";
				}
			} else {
				strResultado = "Existe";
			}

			break;
		}
		case 3: { // Modificar
			Region.setRegionNombre(request.getParameter("RegionNombre"));
			Region.setRegionId(request.getParameter("RegionId"));
			Region.setPaisId(pais);
			if (Region.existeReg(conElias) == true) {
				if (Region.updateReg(conElias)) {
					strResultado = "Modificado";
					conElias.commit();
				} else {
					strResultado = "NoModifico";
				}
			} else {
				strResultado = "NoExiste";
			}
			break;
		}
		case 4: { // Borrar
			Region.setRegionId(request.getParameter("RegionId"));
			if (Region.existeReg(conElias) == true) {
				if (Region.deleteReg(conElias)) {
					strResultado = "Eliminado";
					conElias.commit();
				} else {
					strResultado = "NoElimino";
				}

			} else {
				strResultado = "NoExiste";
			}

			break;
		}
		case 5: { // Consultar		
			Region.setRegionNombre(request.getParameter("RegionNombre"));
			Region.setRegionId(regionId);
			Region.setPaisId(pais);
			if (Region.existeReg(conElias) == true) {
				Region.mapeaRegId(conElias, pais);
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
		<h2>Añadir Region</h2>
		<%
			if (!strResultado.equals("")) {
		%>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="region.jsp?PaisId=<%=Region.getPaisId()%>"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
		</div>
		<form action="accion_r.jsp" method="post" name="frmRegion"
			target="_self">
			<input type="hidden" name="Accion">
			<input type="hidden" name="PaisId" value="<%=pais%>">

			<fieldset>
				<div class="control-group ">
					<label for="RegionId"> RegionId: </label> <input name="RegionId"
						type="text" id="RegionId" size="3" maxlength="3"
						value="<%=Region.getRegionId()%>">
				</div>

				<div class="control-group ">
					<label for="RegionNombre"> <fmt:message key="aca.Nombre" />: </label> <input
						name="RegionNombre" type="text" id="RegionNombre"
						value="<%=Region.getRegionNombre()%>" size="40" maxlength="40">
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
