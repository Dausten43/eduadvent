<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="finRecibo" scope="page" class="aca.fin.FinRecibo"/>
<head>
<% String escuelaId = (String) session.getAttribute("escuela");%>
	<script type="text/javascript" src="../../js/prototype.js"></script>
	<script type="text/javascript">
		function initRequest(){
			if (window.XMLHttpRequest) {
				return new XMLHttpRequest();
			} else if (window.ActiveXObject) {
				isIE = true;
				return new ActiveXObject("Microsoft.XMLHTTP");
			}
		}
	
		function cambiarFolio(){
			var div = $('folio');
			var reciboId = $('reciboId');
			div.innerHTML = '<input type="text" id="newFolio" value='+reciboId.value+' />'+
							'<input type="button" value="Cambiar" onclick="realizaCambio();" />';
			
			//Cancelamos el boton de cobrar
			$('cobrar').style.visibility = "hidden";
		}
		
		function realizaCambio(){
			var div = $('folio');
			var reciboId = $('reciboId');
			reciboId.value = $('newFolio').value;
			div.innerHTML = '<font color="red">'+reciboId.value+'</font>'+
							'<input type="button" value="Cambiar" onclick="cambiarFolio();" />';
			
			//Habilitamos el boton de cobrar
			$('cobrar').style.visibility = "visible";
		}
		
		function cargarBuscarAlumno(){
			var div = $('alumno');
			var url = "cajaAccion.jsp?Accion=1";
			div.innerHTML = '<img src="../../imagenes/cargando.gif" />';
			var req = initRequest();
			req.onreadystatechange = function() {
				if(req.readyState == 4){
					if(req.status==404) {
						alert("Esta pagina no existe. Reportelo a Sistemas");
					}
					if(req.status == 200){
						div.innerHTML = req.responseText;
						div.style.overflow = "auto";
						div.style.height = "100px";
						div.style.border = "solid 1px gray";
					}else if (req.status == 204){
						muestraMensaje("Ocurrió un error al solicitar la informacion");
					}
				}
			};
			req.open("get", url, true);
			req.send(null);
			
			//Cancelamos el boton de cobrar
			$('cobrar').style.visibility = "hidden";
		}
		
		function buscarAlumno(){
			var div = $('alumno');
			var url = "cajaAccion.jsp?Accion=2&nombre="+$('nombre').value+"&paterno="+$('paterno').value+"&materno="+$('materno').value;
			div.innerHTML = '<img src="../../imagenes/cargando.gif" />';
			var req = initRequest();
			req.onreadystatechange = function() {
				if(req.readyState == 4){
					if(req.status==404) {
						alert("Esta pagina no existe. Reportelo a Sistemas");
					}
					if(req.status == 200){
						div.innerHTML = req.responseText;
						div.style.overflow = "auto";
						div.style.height = "100px";
						div.style.border = "solid 1px gray";
					}else if (req.status == 204){
						muestraMensaje("Ocurrió un error al solicitar la informacion");
					}
				}
			};
			req.open("get", url, true);
			req.send(null);
		}
		
		function cargaAlumno(codigoId, nombre){
			var div = $('alumno');
			div.style.height = "";
			div.style.border = "none";
			div.innerHTML = '<input type="text" id="codigoId" name="codigoId" maxlength="8" value="'+codigoId+'" size="8" />'+
							'<input type="button" value="Buscar" onclick="cargarBuscarAlumno();" />&nbsp;&nbsp;'+nombre;
			var url = "cajaAccion.jsp?Accion=3&codigoId="+codigoId;
			var req = initRequest();
			req.onreadystatechange = function() {
				if(req.readyState == 4){
					if(req.status==404) {
						alert("Esta pagina no existe. Reportelo a Sistemas");
					}
					if(req.status == 200){
						eval(req.responseText);
					}else if (req.status == 204){
						muestraMensaje("Ocurrió un error al solicitar la informacion");
					}
				}
			};
			req.open("get", url, true);
			req.send(null);
			
			//Habilitamos el boton de cobrar
			$('cobrar').style.visibility = "visible";
		}
		
		function mensaje(texto){
			$("msg").innerHTML = texto;
			setTimeout("mensaje('&nbsp;');", 10000);
		}
		
		function muestraClientes(){
			var div = $('muestraClientes');
			div.innerHTML = '<img src="../../imagenes/cargando.gif" />';
			var url = "cajaAccion.jsp?Accion=4&codigoId="+$('codigoId').value;
			var req = initRequest();
			req.onreadystatechange = function() {
				if(req.readyState == 4){
					if(req.status==404) {
						alert("Esta pagina no existe. Reportelo a Sistemas");
					}
					if(req.status == 200){
						div.innerHTML = req.responseText;
						div.style.overflow = "auto";
						//div.style.height = "100px";
						div.style.border = "solid 1px gray";
					}else if (req.status == 204){
						muestraMensaje("Ocurrió un error al solicitar la informacion");
					}
				}
			};
			req.open("get", url, true);
			req.send(null);
		}
		
		function cargaCliente(cliente, domicilio, lugar, rfc){
			var div = $('muestraClientes');
			$('cliente').value = cliente;
			$('domicilio').value = domicilio;
			$('lugar').value = lugar;
			$('rfc').value = rfc;
			div.innerHTML = "";
			div.style.height = "";
			div.style.border = "none";
		}
		
		function cancelaClientes(){
			var div = $('muestraClientes');
			div.innerHTML = "";
			div.style.height = "";
			div.style.border = "none";
		}
		
		function cobra(){
			if(document.forma.codigoId.value.length == 7){
				if(parseInt(document.forma.reciboId.value, 10) > 0){
					if(document.forma.cliente.value != ""){
						if(document.forma.concepto.value != ""){
							//alert(parseFloat(document.forma.importe.value));
							if(document.forma.importe.value != ""){
								var url = "cajaAccion.jsp?Accion=5&"+$('forma').serialize();
								var req = initRequest();
								req.onreadystatechange = function() {
									if(req.readyState == 4){
										if(req.status==404) {
											alert("Esta pagina no existe. Reportelo a Sistemas");
										}
										if(req.status == 200){
											eval(req.responseText);
										}else if (req.status == 204){
											muestraMensaje("Ocurrió un error al solicitar la informacion");
										}
									}
								};
								req.open("get", url, true);
								req.send(null);
							}else{
								alert("Necesita especificar el importe para poder guardar");
							}
						}else{
							alert("Debe especificar el concepto para poder guardar");
						}
					}else{
						alert("Debe ingresar un cliente para poder guardar");
					}
				}else{
					alert("El número del recibo debe ser válido");
				}
			}else{
				alert("El codigo del alumno debe ser de 7 dígitos");
			}
		}
	</script>
</head>
<body>
<form id="forma" name="forma" action="caja.jsp" method="post">
	<table align="center" width="80%">
		<tr align="center"><td class="titulo" colspan="2">Escuela: <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId)%></td></tr>
    <tr> 
		<tr>
			<td class="titulo">Caja</td>
		</tr>
		<tr>
			<td id="msg" align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" style="border: dotted 1px gray;">
				<table width="100%">
					<tr>
						<td><b>Recibo A</b></td>
						<td>
							<div id="folio">
								<font color="red"><%=finRecibo.maximoReg(conElias) %></font>
								<input type="button" value="Cambiar" onclick="cambiarFolio();" />
							</div>
							<input type="hidden" id="reciboId" name="reciboId" value="<%=finRecibo.maximoReg(conElias) %>" />
						</td>
						<td><b>Fecha</b></td>
						<td><%=aca.util.Fecha.getHoy() %></td>
					</tr>
					<tr>
						<td>Alumno*</td>
						<td colspan="3">
							<div id="alumno">
								<input type="text" id="codigoId" name="codigoId" maxlength="8" size="8" />
								<input type="button" value="Buscar" onclick="cargarBuscarAlumno();" />
							</div>
						</td>
					</tr>
					<tr>
						<td>Recibimos de*</td>
						<td colspan="3">
							<input type="text" id="cliente" name="cliente" maxlength="100" size="40" onfocus="muestraClientes();" />
							<div id="muestraClientes"></div>
						</td>
					</tr>
					<tr>
						<td>Domicilio</td>
						<td colspan="3"><input type="text" id="domicilio" name="domicilio" maxlength="100" size="40" /></td>
					</tr>
					<tr>
						<td>Lugar</td>
						<td><input type="text" id="lugar" name="lugar" /></td>
						<td>R.F.C.</td>
						<td><input type="text" id="rfc" name="rfc" maxlength="12" size="12" /></td>
					</tr>
					<tr>
						<td>Concepto*</td>
						<td colspan="3"><input type="text" id="concepto" name="concepto" maxlength="70" size="40" /></td>
					</tr>
					<tr>
						<td>Si es cheque anotar No.</td>
						<td><input id="cheque" name="cheque" maxlength="20" size="20" /></td>
						<td>Banco</td>
						<td><input id="banco" name="banco" maxlength="20" size="20" /></td>
					</tr>
					<tr>
						<td>Observaciones</td>
						<td colspan="3"><input id="observaciones" name="observaciones" maxlength="500" size="70" /></td>
					</tr>
					<tr>
						<td>Importe*</td>
						<td colspan="3">$ <input id="importe" name="importe" maxlength="8" size="8" /></td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td align="center" colspan="4"><input type="button" value="Cobrar" id="cobrar" onclick="cobra();" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 