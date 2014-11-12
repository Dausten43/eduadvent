<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivel" />

</head>
<%
	// Declaracion de variables	
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		String sResultado = "";

		if (nAccion == 1)
			Nivel.setNivelId(Nivel.maximoReg(conElias));
		else
			Nivel.setNivelId(request.getParameter("NivelId"));

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {

		case 2: { // Grabar
			Nivel.setNivelNombre(request.getParameter("NivelNombre"));
			Nivel.setGradoIni(request.getParameter("GradoIni"));
			Nivel.setGradoFin(request.getParameter("GradoFin"));
			Nivel.setMetodo(request.getParameter("Metodo"));
			Nivel.setTitulo(request.getParameter("Titulo"));

			if (Nivel.existeReg(conElias) == false) {
				if (Nivel.insertReg(conElias)) {
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
			Nivel.setNivelNombre(request.getParameter("NivelNombre"));
			Nivel.setGradoIni(request.getParameter("GradoIni"));
			Nivel.setGradoFin(request.getParameter("GradoFin"));
			Nivel.setMetodo(request.getParameter("Metodo"));
			Nivel.setTitulo(request.getParameter("Titulo"));

			if (Nivel.existeReg(conElias) == true) {
				if (Nivel.updateReg(conElias)) {
					sResultado = "Modificado";
					conElias.commit();
				} else {
					sResultado = "NoModifico";
				}
			} else {
				sResultado = "NoExiste";
			}
			break;
		}
		case 4: { // Borrar
			if (Nivel.existeReg(conElias) == true) {
				if (Nivel.deleteReg(conElias)) {
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
			if (Nivel.existeReg(conElias) == true) {
				Nivel.mapeaRegId(conElias,
						request.getParameter("NivelId"));
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
		<h2><fmt:message key="catalogo.AnadirNivel" /></h2>
		<%
			if (!sResultado.equals("")) {
		%>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>

		<form action="accion.jsp" method="post" name="frmNivel" target="_self">
			<input type="hidden" name="Accion">

			<div class="well" style="overflow: hidden;">
				<a class="btn btn-primary" href="nivel.jsp"><i
					class="icon-list icon-white"></i>&nbsp;<fmt:message key="boton.Listado" /></a>
			</div>
			<fieldset>
				<div class="control-group ">
					<label for="NivelId"> <fmt:message key="aca.Clave" />: </label> <input name="NivelId"
						type="text" id="NivelId" size="3" maxlength="3"
						value="<%=Nivel.getNivelId()%>">
				</div>

				<div class="control-group ">
					<label for="NivelNombre"> <fmt:message key="aca.Descripcion" />: </label> <input
						name="NivelNombre" type="text" id="NivelNombre"
						value="<%=Nivel.getNivelNombre()%>" size="40" maxlength="20">
				</div>
				<div class="control-group ">
					<label for="Rango"> <fmt:message key="aca.RangoCiclos" />: </label> <fmt:message key="aca.RangoDe" /> <input
						name="GradoIni" class="input input-mini" type="text" id="GradoIni"
						value="<%=Nivel.getGradoIni()%>" size="3" maxlength="3"> <fmt:message key="aca.RangoA" />
					<input name="GradoFin" class="input input-mini" type="text"
						id="GradoFin" value="<%=Nivel.getGradoFin()%>" size="3"
						maxlength="3">
				</div>
				<div class="control-group ">
					<label for="Titulo"> <fmt:message key="aca.Titulo" />: </label> <input name="Titulo"
						type="text" id="Titulo" value="<%=Nivel.getTitulo()%>" size="40"
						maxlength="20">
				</div>
				<div class="control-group ">
					<label for="Metodo"><fmt:message key="aca.Metodo" />: </label> <select name="Metodo"
						id="Metodo">
						<%
							if (Nivel.getMetodo().equals("S")) {
						%>
						<option value="S" selected><fmt:message key="aca.Si" /></option>
						<%
							} else {
						%>
						<option value="S"><fmt:message key="aca.Si" /></option>
						<%
							}
						%>
						<%
							if (Nivel.getMetodo().equals("N")) {
						%>
						<option value="N" selected><fmt:message key="aca.Negacion" /></option>
						<%
							} else {
						%>
						<option value="N"><fmt:message key="aca.Negacion" /></option>
						<%
							}
						%>
					</select>
				</div>
			</fieldset>
		</form>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="javascript:Nuevo()"><i
				class="icon-file icon-white"></i>&nbsp;<fmt:message key="boton.Nuevo" /></a> &nbsp;<a
				class="btn btn-primary" href="javascript:Grabar()"><i
				class="icon-ok icon-white"></i>&nbsp;<fmt:message key="boton.Guardar" /></a> &nbsp; <a
				class="btn btn-primary" href="javascript:Modificar()"><i
				class="icon-edit icon-white"></i>&nbsp;<fmt:message key="boton.Modificar" /></a> &nbsp; <a
				class="btn btn-primary" href="javascript:Borrar()"><i
				class="icon-remove icon-white"></i>&nbsp;<fmt:message key="boton.Eliminar" /></a> &nbsp;
		</div>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
