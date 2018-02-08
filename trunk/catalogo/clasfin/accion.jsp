<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="clasificacion" scope="page"
	class="aca.catalogo.CatClasFin" />
<head>
<script>
	function Nuevo() {
		document.frmClas.ClasfinId.value = " ";
		document.frmClas.ClasfinNombre.value = " ";
		document.frmClas.Accion.value = "1";
		document.frmClas.submit();
	}

	function Grabar() {
		if (document.frmClas.ClasfinId.value != ""
				&& document.frmClas.ClasfinNombre.value != "") {
			document.frmClas.Accion.value = "2";
			document.frmClas.submit();
		} else {
			alert("¡Complete el formulario! ");
		}
	}

	function Modificar() {
		document.frmClas.Accion.value = "3";
		document.frmClas.submit();
	}

	function Borrar() {
		if (document.frmClas.ClasfinId.value != "") {
			if (confirm("¿Estas seguro de eliminar el registro?") == true) {
				document.frmClas.Accion.value = "4";
				document.frmClas.submit();
			}
		} else {
			alert("¡Escriba la Clave!");
			document.frmClas.ClasificacionId.focus();
		}
	}

	function Consultar() {
		document.frmClas.Accion.value = "5";
		document.frmClas.submit();
	}
</script>
</head>
<%
	// Declaracion de variables		
	String escuelaId 		= (String) session.getAttribute("escuela");
	int nAccion 			= Integer.parseInt(request.getParameter("Accion"));
	if (nAccion == 1) {
		clasificacion.setClasfinId(clasificacion.maximoReg(conElias, escuelaId));
	} else {
		clasificacion.setEscuelaId(escuelaId);
		clasificacion.setClasfinId(request.getParameter("ClasfinId"));
	}
	
	String salto			= "X";
	String sResultado 		= "";
	int i 					= 0;

	// Operaciones a realizar en la pantalla	
	switch (nAccion) {

		case 2: { // Grabar
			conElias.setAutoCommit(false);			
			clasificacion.setEscuelaId(escuelaId);
			clasificacion.setClasfinId(request.getParameter("ClasfinId"));
			clasificacion.setClasfinNombre(request.getParameter("ClasfinNombre"));	
			clasificacion.setEstado(request.getParameter("Estado"));

			if (clasificacion.existeReg(conElias) == false) {
				if (clasificacion.insertReg(conElias)) {
					sResultado = "Guardado";
					salto = "clasificacion.jsp";
					conElias.commit();
				} else {
					sResultado = "NoGuardo";
				}
			} else {
				if (clasificacion.updateReg(conElias)) {
					sResultado = "Modificado";
					conElias.commit();
				} else {
					sResultado = "NoModifico";
				}
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 4: { // Borrar
			conElias.setAutoCommit(false);
			if (clasificacion.existeReg(conElias) == true) {
				if (clasificacion.deleteReg(conElias)) {
					sResultado = "Eliminado";
					salto = "clasificacion.jsp";
					conElias.commit();
				} else {
					sResultado = "NoElimino";
				}

			} else {
				sResultado = "NoExiste";
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 5: { // Consultar						
			if (clasificacion.existeReg(conElias) == true) {
				clasificacion.mapeaRegId(conElias,escuelaId, request.getParameter("ClasfinId"));
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
		<h2><fmt:message key="catalogo.AnadirClas" /></h2>
		<% if (!sResultado.equals("") && (sResultado.equals("Guardado") || sResultado.equals("Modificado") || sResultado.equals("Eliminado"))){%>
	   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
	  	<% }else if(!sResultado.equals("")){ %>
	  		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
	  	<% }%>

		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="clasificacion.jsp"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
		</div>
		<form action="accion.jsp" method="post" name="frmClas" target="_self">
			<input type="hidden" name="Accion"> <input name="Pec"
				type="hidden">
		<div class="row">
			<div class="span4">

			<fieldset>
					<label for="ClasfinId"> <fmt:message key="aca.Id" />: </label> 
					<input name="ClasfinId" type="text" id="ClasfinId" size="3" maxlength="3" value="<%=clasificacion.getClasfinId()%>">
			</fieldset>
			<fieldset>
					<label for="ClasfinNombre"> <fmt:message key="aca.Clasificacion" />: </label>
					<input name="ClasfinNombre" type="text" id="ClasfinNombre" value="<%=clasificacion.getClasfinNombre()%>" size="40" maxlength="40">
			</fieldset>
			<fieldset>
					<label for="Estado"> <fmt:message key="aca.Estado" />: </label>
					<select name="Estado" id="Estado" tabindex="4">
		            <%	if(clasificacion.getEstado().equals("A")){%>
			        	<option value='A' selected><fmt:message key="aca.Activo"/></option>
			            <option value='I' ><fmt:message key="aca.Inactivo"/></option>
			        <%	}else{%>
			            <option value='A'><fmt:message key="aca.Activo"/></option>
			            <option value='I' selected><fmt:message key="aca.Inactivo"/></option>
			        <%	}%>
			        </select>							
			</fieldset>

			<div class="well" style="overflow: hidden;">
				<a class="btn btn-primary" href="javascript:Nuevo();"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
				&nbsp; &nbsp;<a class="btn btn-primary" href="javascript:Grabar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
				&nbsp; &nbsp; <a class="btn btn-primary" href="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
			</div>
			</div>
			</div>
		</form>
	</div>
</body>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>