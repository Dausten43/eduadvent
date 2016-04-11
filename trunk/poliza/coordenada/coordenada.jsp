<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Coordenada" scope="page" class="aca.fin.FinCoordenada" />
<head>
<script>
	function Grabar() {
		if (document.forma.clienteX.value != ""
				&& document.forma.clienteY.value != ""
				&& document.forma.domicilioX.value != ""
				&& document.forma.domicilioY.value != ""
				&& document.forma.rfcX.value != ""
				&& document.forma.rfcY.value != ""
				&& document.forma.observacionesX.value != ""
				&& document.forma.observacionesY.value != ""
				&& document.forma.letraX.value != ""
				&& document.forma.letraY.value != ""
				&& document.forma.totalX.value != ""
				&& document.forma.totalY.value != ""
				&& document.forma.codigoX.value != ""
				&& document.forma.codigoY.value != ""
				&& document.forma.nombreX.value != ""
				&& document.forma.nombreY.value != ""
				&& document.forma.conceptoX.value != ""
				&& document.forma.conceptoY.value != ""
				&& document.forma.importeX.value != ""
				&& document.forma.importeY.value != ""
				&& document.forma.fechaX.value != ""
				&& document.forma.fechaY.value != "") {
			document.forma.Accion.value = "1";
			document.forma.submit();
		} else {
			alert("Llene todos los campos vacios!");
		}
	}

	function Combo() {
		document.forma.submit();
	}
</script>
</head>
<%
	// Declaracion de variables	
		String sResultado = "";
		String usuario = (String) session.getAttribute("codigoAlumno");

		String tipo = request.getParameter("tipo") == null ? "R"
				: request.getParameter("tipo");
		String cliente = request.getParameter("clienteX") + ","
				+ request.getParameter("clienteY");
		String domicilio = request.getParameter("domicilioX") + ","
				+ request.getParameter("domicilioY");
		String rfc = request.getParameter("rfcX") + ","
				+ request.getParameter("rfcY");
		String observaciones = request.getParameter("observacionesX")
				+ "," + request.getParameter("observacionesY");
		String letra = request.getParameter("letraX") + ","
				+ request.getParameter("letraY");
		String total = request.getParameter("totalX") + ","
				+ request.getParameter("totalY");
		String codigo = request.getParameter("codigoX") + ","
				+ request.getParameter("codigoY");
		String nombre = request.getParameter("nombreX") + ","
				+ request.getParameter("nombreY");
		String concepto = request.getParameter("conceptoX") + ","
				+ request.getParameter("conceptoY");
		String importe = request.getParameter("importeX") + ","
				+ request.getParameter("importeY");
		String fecha = request.getParameter("fechaX") + ","
				+ request.getParameter("fechaY");

		String accion = request.getParameter("Accion") == null ? " "
				: request.getParameter("Accion");

		Coordenada.mapeaRegId(conElias, usuario, tipo);

		if (accion.equals("1")) {
			Coordenada.setUsuario(usuario);
			Coordenada.setTipo(tipo);
			Coordenada.setCliente(cliente);
			Coordenada.setDomicilio(domicilio);
			Coordenada.setRfc(rfc);
			Coordenada.setObservaciones(observaciones);
			Coordenada.setLetra(letra);
			Coordenada.setTotal(total);
			Coordenada.setCodigo(codigo);
			Coordenada.setNombre(nombre);
			Coordenada.setConcepto(concepto);
			Coordenada.setImporte(importe);
			Coordenada.setFecha(fecha);

			if (Coordenada.existeReg(conElias) == false) {//Grabar
				if (Coordenada.insertReg(conElias)) {
					sResultado = "Grabado";
				} else {
					sResultado = "No Grabó";
				}
			} else {//Modificar
				if (Coordenada.updateReg(conElias)) {
					sResultado = "Modificado";
				} else {
					sResultado = "No Cambió";
				}
			}
		}

		String temp = "";

		if (tipo.equals("F")) {
			temp = "3.5,12.1";
		} else if (tipo.equals("R")) {
			temp = "2.8,13.4";
		}
		if (Coordenada.getCliente() != null
				&& !Coordenada.getCliente().equals("")) {
			temp = Coordenada.getCliente();
		}
		String[] cl = temp.split(",");
		String ClienteX = cl[0];
		String ClienteY = cl[1];

		if (tipo.equals("F")) {
			temp = "3.5,11.5";
		} else if (tipo.equals("R")) {
			temp = "3.0,12.4";
		}
		if (Coordenada.getDomicilio() != null
				&& !Coordenada.getDomicilio().equals("")) {
			temp = Coordenada.getDomicilio();
		}
		String[] dom = temp.split(",");
		String DomicilioX = dom[0];
		String DomicilioY = dom[1];

		if (tipo.equals("F")) {
			temp = "8.5,10.9";
		} else if (tipo.equals("R")) {
			temp = "0,0";
		}
		if (Coordenada.getRfc() != null
				&& !Coordenada.getRfc().equals("")) {
			temp = Coordenada.getRfc();
		}
		String[] rf = temp.split(",");
		String RFCX = rf[0];
		String RFCY = rf[1];

		if (tipo.equals("F")) {
			temp = "4.5,4.1";
		} else if (tipo.equals("R")) {
			temp = "0,0";
		}
		if (Coordenada.getObservaciones() != null
				&& !Coordenada.getObservaciones().equals("")) {
			temp = Coordenada.getObservaciones();
		}
		String[] obs = temp.split(",");
		String ObservacionesX = obs[0];
		String ObservacionesY = obs[1];

		if (tipo.equals("F")) {
			temp = "1.3,1.5";
		} else if (tipo.equals("R")) {
			temp = "1.3,1.6";
		}
		if (Coordenada.getLetra() != null
				&& !Coordenada.getLetra().equals("")) {
			temp = Coordenada.getLetra();
		}
		String[] let = temp.split(",");
		String LetraX = let[0];
		String LetraY = let[1];

		if (tipo.equals("F")) {
			temp = "19.4,1.2";
		} else if (tipo.equals("R")) {
			temp = "18.0,1.4";
		}
		if (Coordenada.getTotal() != null
				&& !Coordenada.getTotal().equals("")) {
			temp = Coordenada.getTotal();
		}
		String[] tot = temp.split(",");
		String TotalX = tot[0];
		String TotalY = tot[1];

		if (tipo.equals("F")) {
			temp = "1.3,9.2";
		} else if (tipo.equals("R")) {
			temp = "1.5,9.8";
		}
		if (Coordenada.getCodigo() != null
				&& !Coordenada.getCodigo().equals("")) {
			temp = Coordenada.getCodigo();
		}
		String[] cod = temp.split(",");
		String CodigoX = cod[0];
		String CodigoY = cod[1];

		if (tipo.equals("F")) {
			temp = "4.6,9.2";
		} else if (tipo.equals("R")) {
			temp = "5.7,9.8";
		}
		if (Coordenada.getNombre() != null
				&& !Coordenada.getNombre().equals("")) {
			temp = Coordenada.getNombre();
		}
		String[] nom = temp.split(",");
		String NombreX = nom[0];
		String NombreY = nom[1];

		if (tipo.equals("F")) {
			temp = "13.7,9.2";
		} else if (tipo.equals("R")) {
			temp = "0,0";
		}
		if (Coordenada.getConcepto() != null
				&& !Coordenada.getConcepto().equals("")) {
			temp = Coordenada.getConcepto();
		}
		String[] con = temp.split(",");
		String ConceptoX = con[0];
		String ConceptoY = con[1];

		if (tipo.equals("F")) {
			temp = "19.4,9.2";
		} else if (tipo.equals("R")) {
			temp = "17.5,9.8";
		}
		if (Coordenada.getImporte() != null
				&& !Coordenada.getImporte().equals("")) {
			temp = Coordenada.getImporte();
		}
		String[] imp = temp.split(",");
		String ImporteX = imp[0];
		String ImporteY = imp[1];

		if (tipo.equals("F")) {
			temp = "15.1,10.9";
		} else if (tipo.equals("R")) {
			temp = "16.7,12.2";
		}
		if (Coordenada.getFecha() != null
				&& !Coordenada.getFecha().equals("")) {
			temp = Coordenada.getFecha();
		}
		String[] fec = temp.split(",");
		String FechaX = fec[0];
		String FechaY = fec[1];
%>
<body>
	<div id="content">
		<h2>Coordenadas de Recibo</h2>
		<br>
		<div class="well">
			<strong>Tipo:</strong> <select id="tipo" name="tipo">
				<option value="R" <%=tipo.equals("R") ? " Selected" : ""%>>Recibos</option>
				<option value="F" <%=tipo.equals("F") ? " Selected" : ""%>>Facturas</option>
			</select>
		</div>

		<form action="coordenada.jsp" method="post" name="forma">
			<input type="hidden" name="Accion">
			<div class="row">
				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Cliente:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Domicilio:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>RFC:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Observaciones:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Letra:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Total:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Código:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Nombre:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Concepto:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Importe:</strong></label>
						</div>
						<div class="control-group ">
							<label> </label>
						</div>
						<div class="control-group ">
							<label> </label> <br> <label><strong>Fecha:</strong></label>
						</div>
					</fieldset>
				</div>


				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label style="text-align: center;" class="input-medium">
								<strong>X</strong>
							</label>
						</div>
						<div class="control-group ">
							<label for="clienteX"> </label><input name="clienteX" type="text"
								id="clienteX" size="4" maxlength="8" value="<%=ClienteX%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="domicilioX"> </label><input name="domicilioX"
								type="text" id="domicilioX" size="4" maxlength="8"
								value="<%=DomicilioX%>" class="input-medium">
						</div>
						<div class="control-group ">
							<label for="rfcX"> </label><input name="rfcX" type="text"
								id="rfcX" size="4" maxlength="8" value="<%=RFCX%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="observacionesX"> </label><input name="observacionesX"
								type="text" id="observacionesX" size="4" maxlength="8"
								value="<%=ObservacionesX%>" class="input-medium">
						</div>
						<div class="control-group ">
							<label for="letraX"> </label><input name="letraX" type="text"
								id="letraX" size="4" maxlength="8" value="<%=LetraX%>"
								class="input-medium">

						</div>
						<div class="control-group ">
							<label for="totalX"> </label><input name="totalX" type="text"
								id="totalX" size="4" maxlength="8" value="<%=TotalX%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="codigoX"> </label><input name="codigoX" type="text"
								id="codigoX" size="4" maxlength="8" value="<%=CodigoX%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="nombreX"> </label><input name="nombreX" type="text"
								id="nombreX" size="4" maxlength="8" value="<%=NombreX%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="conceptoX"> </label><input name="conceptoX"
								type="text" id="conceptoX" size="4" maxlength="8"
								value="<%=ConceptoX%>" class="input-medium">
						</div>
						<div class="control-group ">
							<label for="importeX"> </label><input name="importeX" type="text"
								id="importeX" size="4" maxlength="8" value="<%=ImporteX%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="fechaX"> </label><input name="fechaX" type="text"
								id="fechaX" size="4" maxlength="8" value="<%=FechaX%>"
								class="input-medium">
						</div>

					</fieldset>
				</div>


				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label style="text-align: center;" class="input-medium">
								<strong>Y</strong>
							</label>
						</div>
						<div class="control-group ">
							<label for="clienteX"> </label><input name="clienteY" type="text"
								id="clienteY" size="4" maxlength="8" value="<%=ClienteY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="domicilioY"> </label><input name="domicilioY"
								type="text" id="domicilioY" size="4" maxlength="8"
								value="<%=DomicilioY%>" class="input-medium">
						</div>
						<div class="control-group ">
							<label for="rfcy"> </label><input name="rfcY" type="text"
								id="rfcY" size="4" maxlength="8" value="<%=RFCY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="observacionesY"> </label><input name="observacionesY"
								type="text" id="observacionesY" size="4" maxlength="8"
								value="<%=ObservacionesY%>" class="input-medium">
						</div>
						<div class="control-group ">
							<label for="letraY"> </label><input name="letraY" type="text"
								id="letraY" size="4" maxlength="8" value="<%=LetraY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="totalY"> </label><input name="totalY" type="text"
								id="totalY" size="4" maxlength="8" value="<%=TotalY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="codigoY"> </label><input name="codigoY" type="text"
								id="codigoY" size="4" maxlength="8" value="<%=CodigoY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="nombreY"> </label><input name="nombreY" type="text"
								id="nombreY" size="4" maxlength="8" value="<%=NombreY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="conceptoY"> </label><input name="conceptoY"
								type="text" id="conceptoY" size="4" maxlength="8"
								value="<%=ConceptoY%>" class="input-medium">
						</div>
						<div class="control-group ">
							<label for="importeY"> </label><input name="importeY" type="text"
								id="importeY" size="4" maxlength="8" value="<%=ImporteY%>"
								class="input-medium">
						</div>
						<div class="control-group ">
							<label for="fechaY"> </label> <input name="fechaY" type="text"
								id="fechaY" size="4" maxlength="8" value="<%=FechaY%>"
								class="input-medium">
						</div>
					</fieldset>
				</div>
			</div>
		</form>

		<div class="well" style="overflow: hidden;">
			<h4><%=sResultado%></h4>
			<button class="btn btn-primary" id="grabar" onclick="Grabar()">
				<i class="icon-ok icon-white"></i> Grabar
			</button>
		</div>
	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>