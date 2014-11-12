<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="reporte" scope="page" class="aca.cond.CondTipoReporte" />
<head>
<script language="javascript">
	/*function Nuevo()	{		
		document.frmReporte.TipoId.value 		= " ";
		document.frmReporte.TipoNombre.value 	= " ";
		document.frmReporte.Comentario.value	= "";	
		document.frmReporte.Accion.value="1";
		document.frmReporte.submit();		
	}*/

	function Grabar() {

		if (document.frmReporte.TipoId.value != "") {
			document.frmReporte.Accion.value = "2";
			document.frmReporte.submit();
		} else {
			alert("<fmt:message key="js.Completar"/> ");
		}
	}

	function Modificar() {
		document.frmReporte.Accion.value = "3";
		document.frmReporte.submit();
	}

	function Borrar() {
		if (document.frmReporte.TipoId.value != "") {
			if (confirm("<fmt:message key="aca.EliminarRegistro" />") == true) {
				document.frmReporte.Accion.value = "4";
				document.frmReporte.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmReporte.TipoId.focus();
		}
	}

	/*function Consultar(){
		document.frmReporte.Accion.value="5";
		document.frmReporte.submit();		
	}*/
</script>
</head>
<%
	// Declaracion de variables	
		String sResultado = "";
		String escuelaId = (String) session.getAttribute("escuela");
		int i = 0;
		int nAccion = Integer.parseInt(request.getParameter("Accion"));
		ArrayList listor = new ArrayList();
		ArrayList lisReligion = new ArrayList();

		if (nAccion == 1)
			reporte.setTipoId(reporte.maximoReg(conElias));
		else
			reporte.setTipoId(request.getParameter("TipoId"));

		// Operaciones a realizar en la pantalla	
		switch (nAccion) {
		case 2: { // Grabar			
			reporte.setTipoId(request.getParameter("TipoId"));
			reporte.setTipoNombre(request.getParameter("TipoNombre"));
			reporte.setComentario(request.getParameter("Comentario"));
			reporte.setEscuelaId(escuelaId);
			if (reporte.existeReg(conElias) == false) {
				if (reporte.insertReg(conElias)) {
					sResultado = "Guardado";
					conElias.commit();
				//	response.sendRedirect("tipo.jsp");
				} else {
					sResultado = "NoGuardo";
				}
			} else {
				sResultado = "Existe";
			}

			break;
		}
		case 3: { // Modificar
			reporte.mapeaRegId(conElias, request.getParameter("TipoId"));
			reporte.setTipoId(request.getParameter("TipoId"));
			reporte.setTipoNombre(request.getParameter("TipoNombre"));
			reporte.setComentario(request.getParameter("Comentario"));
			if (reporte.existeReg(conElias) == true) {
				if (reporte.updateReg(conElias)) {
					sResultado = "Modificado";
					conElias.commit();
					/*response.sendRedirect("tipo.jsp");*/
				} else {
					sResultado = "NoModificado";
				}
			} else {
				sResultado = "NoExiste";
			}
			break;
		}
		case 4: { // Borrar			
			if (reporte.existeReg(conElias) == true) {
				if (reporte.deleteReg(conElias)) {
					sResultado = "Eliminado";
					conElias.commit();
					/*response.sendRedirect("tipo.jsp");*/
				} else {
					sResultado = "NoEliminado";
				}
			} else {
				sResultado = "NoExiste: ";
			}

			break;
		}
		case 5: { // Consultar
			if (reporte.existeReg(conElias) == true) {
				reporte.mapeaRegId(conElias,
						request.getParameter("TipoId"));
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
		<h2><fmt:message key="catalogo.CatalogoReportes"/></h2>
		<%
			if (!sResultado.equals("")) {
		%>
		<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%
			}
		%>
		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="tipo.jsp"><i class="icon-list icon-white"></i> <fmt:message key="boton.Listado"/></a>
		</div>
		<form action="accion.jsp" method="post" name="frmReporte" target="_self">
			<input type="hidden" name="Accion"> 
			<input type="hidden" name="TipoId" id="TipoId" value="<%=reporte.getTipoId()%>">

			<fieldset>	

				<div class="control-group ">
					<label for="TipoNombre"> <fmt:message key="aca.Nombre"/>: </label> 
					<input name="TipoNombre" type="text" id="TipoNombre" value="<%=reporte.getTipoNombre()%>" size="40" maxlength="40">
				</div>

				<div class="control-group ">
					<label for="Comentario"> <fmt:message key="aca.Comentario"/>: </label> 
					<input name="Comentario" type="text" id="Comentario" value="<%=reporte.getComentario()%>" size="40" maxlength="40">
				</div>

			
				<div class="well" style="overflow: hidden;">
					<a class="btn btn-primary" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar"/></a>
					<a class="btn btn-primary" href="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar"/></a>
				</div>
			</fieldset>

			<%
				listor = null;
			%>
			</table>
		</form>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>