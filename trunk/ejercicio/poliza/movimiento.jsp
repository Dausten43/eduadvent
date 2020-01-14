<%@page import="aca.cont.ContMovimiento"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>

<jsp:useBean id="contPoliza" scope="page" class="aca.cont.ContPoliza"/>
<jsp:useBean id="contMovimiento" scope="page" class="aca.cont.ContMovimiento"/>
<jsp:useBean id="contMovimientoL" scope="page" class="aca.cont.ContMovimientoLista"/>
<jsp:useBean id="contEjercicio" scope="page" class="aca.cont.ContEjercicio"/>
<jsp:useBean id="contLibro" scope="page" class="aca.cont.ContLibro"/>
<jsp:useBean id="empPersonal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="contRelacion" scope="page" class="aca.cont.ContRelacion"/>
<%
	String ejercicioId		= request.getParameter("ejercicioId");
	String libroId			= request.getParameter("libroId");
	String polizaId			= request.getParameter("polizaId");
	
	ArrayList lisMovimiento	= null;
	
	contPoliza.mapeaRegId(conElias, ejercicioId, libroId, polizaId);
	contEjercicio.mapeaRegId(conElias, ejercicioId);
	contLibro.mapeaRegId(conElias, libroId);
	empPersonal.mapeaRegId(conElias, contPoliza.getUsAlta());
	
	lisMovimiento = contMovimientoL.getListPoliza(conElias, ejercicioId, libroId, polizaId, "ORDER BY NUM_MOVTO");
%>
<head>
	<script type="text/javascript" src="../../js/prototype.js"></script>
	<script type="text/javascript">
		function inicio(){
			$("divResultado").style.visibility = "hidden";
			Event.observe($("mayorId"), "keyup", checkKey);
			$("foco").focus();
			$("mayorId").focus();
		}
		
		var tMensaje;
		
		function mensaje(frase){
			var msg = $("mensaje");
			msg.innerHTML = frase;
		}
	
		function buscar(obj){
			var divR = $("divResultado");
				
			divR.style.visibility = "visible";
			divR.innerHTML = '<img src="../../imagenes/cargando.gif" />';
			var url;
			if(!isNaN($("mayorId").value))
				url = "movimientoAccion.jsp?Accion=5&ccostoId=<%=contPoliza.getCcostoId() %>&mayorId="+$("mayorId").value;
			else
				url = "movimientoAccion.jsp?Accion=7&ccostoId=<%=contPoliza.getCcostoId() %>&texto="+$("mayorId").value;
			obj = $(obj);
			divR.style.left = Position.cumulativeOffset($(obj))[0] + "px";
			divR.style.top = (Position.cumulativeOffset($(obj))[1] + obj.offsetHeight) + "px";
			new Ajax.Request(url, {
				method: "get",
				onSuccess: function(req){
					divR.innerHTML = req.responseText;
				},
				onFailure: function(req){
					alert("Ocurrió un error al accesar a la página. Inténtelo de nuevo");
				}
			});
		}
		
		function ocultarBusqueda(){
			$("divResultado").innerHTML = "";
			$("divResultado").style.visibility = "hidden";
		}
		
		var currentElement;
		function checkKey(event){
			if(event.keyCode != 8 && event.keyCode != 27){//Si no borra
				if(!isNaN(this.value))
					buscar(this);
				else if(event.keyCode == 13)
					buscar(this);
				if(event.keyCode == 9)
					ocultarBusqueda();
			}else{
				ocultarBusqueda();
			}
		}
		
		function cargarCuenta(mayorId, auxiliarId, nombre, naturaleza){
			$("mayorId").value = mayorId;
			$("auxiliarId").value = auxiliarId;
			$("cuenta").innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+nombre;
			$("descripcion").focus();
			ocultarBusqueda();
			currentElement = null;
		}
		
		var contMovimientos = <%=lisMovimiento.size() %>;
		var contFilas = <%=lisMovimiento.size() %>;
		var sumD;
		var sumC;
		
		function guardar(){
			if(document.forma.mayorId.value != "" && document.forma.descripcion.value != "" && document.forma.importe.value != ""){
				//alert("Acepto los valores"+$("forma").serialize());
				var url = "movimientoAccion.jsp?Accion=6&ejercicioId=<%=ejercicioId %>&libroId=<%=libroId %>&polizaId=<%=polizaId %>&"+$("forma").serialize();
				new Ajax.Request(url,{
					method: 'get',
					onSuccess: function(req){
						eval(req.responseText);
					},
					onFailure: function(req){
						mensaje('<font color="red" size="3"><b>Ocurri&oacute; un error al solicitar la p&aacute;gina. Int&eacute;ntelo de nuevo.<br>Si persiste reportelo</b></font>');
					}
				});
			}else{
				alert("Llene los campos requeridos para poder guardar");
			}
		}
		
		function addCommas(nStr)
		{
			nStr += '';
			x = nStr.split('.');
			x1 = x[0];
			x2 = x.length > 1 ? '.' + x[1] : '';
			var rgx = /(\d+)(\d{3})/;
			while (rgx.test(x1)) {
				x1 = x1.replace(rgx, '$1' + ',' + '$2');
			}
			return x1 + x2;
		}
		
		function limpiaInputs(){
			$("mayorId").value = "";
			$("mayorId").focus();
			$("auxiliarId").value = "";
			$("cuenta").innerHTML = "";
			$("descripcion").value = "";
			$("referencia").value = "";
			$("importe").value = "";
			$("numMovto").value = "";
			document.forma.naturaleza[0].checked = "checked";
		}
		
		function polizaTerminada(){
			if($("sumD").innerHTML == $("sumC").innerHTML){
				var url = "movimientoAccion.jsp?Accion=8&ejercicioId=<%=ejercicioId %>&libroId=<%=libroId %>&polizaId=<%=polizaId %>";
				$("btnTerminaPoliza").disabled = true;
				new Ajax.Request(url,{
					method: 'get',
					onSuccess: function(req){
						eval(req.responseText);
					},
					onFailure: function(req){
						mensaje('<font color="red" size="3"><b>Ocurri&oacute; un error al solicitar la p&aacute;gina. Int&eacute;ntelo de nuevo.<br>Si persiste reportelo</b></font>');
					}
				});
			}else
				alert("La poliza no cuadra y no puede ser cerrada");
		}
		
		function cerrarPoliza(){
			var url = "movimientoAccion.jsp?Accion=9&ejercicioId=<%=ejercicioId %>&libroId=<%=libroId %>&polizaId=<%=polizaId %>";
			$("btnCerrarPoliza").disabled = true;
			$("btnAbrirPoliza").disabled = true;
			new Ajax.Request(url,{
				method: 'get',
				onSuccess: function(req){
					eval(req.responseText);
				},
				onFailure: function(req){
					mensaje('<font color="red" size="3"><b>Ocurri&oacute; un error al solicitar la p&aacute;gina. Int&eacute;ntelo de nuevo.<br>Si persiste reportelo</b></font>');
				}
			});
		}
		
		function abrirPoliza(){
			var url = "movimientoAccion.jsp?Accion=10&ejercicioId=<%=ejercicioId %>&libroId=<%=libroId %>&polizaId=<%=polizaId %>";
			$("btnAbrirPoliza").disabled = true;
			$("btnCerrarPoliza").disabled = true;
			new Ajax.Request(url,{
				method: 'get',
				onSuccess: function(req){
					eval(req.responseText);
				},
				onFailure: function(req){
					mensaje('<font color="red" size="3"><b>Ocurri&oacute; un error al solicitar la p&aacute;gina. Int&eacute;ntelo de nuevo.<br>Si persiste reportelo</b></font>');
				}
			});
		}
		
		function modificarMovimiento(ejercicioId, libroId, polizaId, numMovto){
			var url = "movimientoAccion.jsp?Accion=11"+
					  "&ejercicioId="+ejercicioId+
					  "&libroId="+libroId+
					  "&polizaId="+polizaId+
					  "&numMovto="+numMovto;
			  
			$("btnTerminaPoliza").disabled = true;//Deshabilitamos el boton de "Poliza Terminada"
			
			new Ajax.Request(url,{
				method: 'get',
				onSuccess: function(req){
					eval(req.responseText);
				},
				onFailure: function(req){
					mensaje('<font color="red" size="3"><b>Ocurri&oacute; un error al solicitar la p&aacute;gina. Int&eacute;ntelo de nuevo.<br>Si persiste reportelo</b></font>');
				}
			});
		}

		function borrarMovimiento(ejercicioId, libroId, polizaId, numMovto, contMovto){
			if(confirm("¿Está seguro de querer borrar el movimiento permanentemente?")){
				var url = "movimientoAccion.jsp?Accion=12"+
						  "&ejercicioId="+ejercicioId+
						  "&libroId="+libroId+
						  "&polizaId="+polizaId+
						  "&numMovto="+numMovto+
						  "&contMovto="+contMovto;
				  
				$("btnTerminaPoliza").disabled = true;//Deshabilitamos el boton de "Poliza Terminada"
				
				new Ajax.Request(url,{
					method: 'get',
					onSuccess: function(req){
						eval(req.responseText);
					},
					onFailure: function(req){
						mensaje('<font color="red" size="3"><b>Ocurri&oacute; un error al solicitar la p&aacute;gina. Int&eacute;ntelo de nuevo.<br>Si persiste reportelo</b></font>');
					}
				});
			}
		}
	</script>
</head>
<body onload="inicio();">
	<table width="100%">
		<tr>
			<td><a href="cabecera.jsp?Ejercicio=<%=ejercicioId %>&ccostoId=<%=contPoliza.getCcostoId() %>">&lsaquo;&lsaquo; Regresar</a></td>
		</tr>
		<tr>
			<td class="titulo">Captura de P&oacute;liza</td>
		</tr>
		<tr>
			<td align="center" height="23px"><div id="mensaje">&nbsp;</div></td>
		</tr>
	</table>
	<table align="center" width="50%" style="border: solid 1px gray;">
		<tr>
			<td><b>Ejercicio:</b></td>
			<td><%=contEjercicio.getEjercicioNombre() %></td>
			<td><b>Libro:</b></td>
			<td><%=contLibro.getLibroNombre() %></td>
		</tr>
		<tr>
			<td><b>Poliza:</b></td>
			<td><%=contPoliza.getPolizaId() %></td>
			<td><b>Descripci&oacute;n:</b></td>
			<td><%=contPoliza.getDescripcion() %></td>
		</tr>
		<tr>
			<td><b>Fecha Creada:</b></td>
			<td><%=contPoliza.getFecha() %></td>
			<td><b>Usuario</b></td>
			<td><%=empPersonal.getNombre() %> <%=empPersonal.getApaterno() %> <%=empPersonal.getAmaterno() %></td>
		</tr>
	</table>
	<br>
	<form id="forma" name="forma" action="movimiento.jsp" method="post">
		<input type="hidden" id="numMovto" name="numMovto" value="" />
		<table width="95%" align="center" border="0">
			<tr>
				<td style="border: dotted 1px gray;" height="60px">
					<table width="100%">
						<tr>
								<td>
									Cuenta*: <br>
									<input type="text" id="mayorId" name="mayorId" size="40" tabindex="1" /><input type="button" value="Buscar" onclick="buscar(this);" />
									<input type="hidden" id="ccostoId" name="ccostoId" value="<%=contPoliza.getCcostoId() %>" />
									<input type="hidden" id="auxiliarId" name="auxiliarId" />
									<div id="cuenta"></div>
								</td>
								<td>Descripci&oacute;n*: <br><input type="text" id="descripcion" name="descripcion" maxlength="100" tabindex="2" /></td>
								<td>Referencia: <br><input type="text" id="referencia" name="referencia" size="10" maxlength="20" tabindex="3" /></td>
								<td align="center">Importe*: <br><input type="text" id="importe" name="importe" size="10" tabindex="4" /></td>
								<td>
									Cargo&nbsp;&nbsp;&nbsp;<input type="radio" id="naturaleza" name="naturaleza" value="D" checked tabindex="5" /><br />
									Credito&nbsp;<input type="radio" id="naturaleza" name="naturaleza" value="C" tabindex="6" />
								</td>
								<td><input type="button" id="btnGuardar" value="Guardar" onclick="guardar();" tabindex="7" /></td>
							</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="left">
					<table>
						<tr>
							<th width="30px">#</th>
							<th width="250px">Cuenta</th>
							<th width="170">Descripcion</th>
							<th width="100px">Referencia</th>
							<th width="80px">Cargo</th>
							<th width="80px">Credito</th>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="left">
					<div style="border: inset 1px gray; height: 200px; overflow: auto; background-color: white;">
						<table id="movimientos" cellspacing="0" cellpadding="0">
<%
	double sumD = 0;
	double sumC = 0;
	java.text.DecimalFormat format = new java.text.DecimalFormat("###,###,##0.00;-###,###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	for(int i = 0; i < lisMovimiento.size(); i++){
		contMovimiento = (ContMovimiento) lisMovimiento.get(i);
		contRelacion.mapeaRegMayorId(conElias, contMovimiento.getMayorId(), contMovimiento.getCcostoId(), contMovimiento.getAuxiliarId());
		if(contMovimiento.getNaturaleza().equals("D"))
			sumD += Double.parseDouble(contMovimiento.getImporte());
		else
			sumC += Double.parseDouble(contMovimiento.getImporte());
%>
							<tr <%=i%2!=0?strColor:"" %> id="<%=i+1 %>" height="24px">
								<td width="40px" align="center"><%=i+1 %></td>
								<td width="255px"><%=contMovimiento.getMayorId() %> - <%=contRelacion.getNombre() %></td>
								<td width="178px"><%=contMovimiento.getDescripcion() %></td>
								<td width="105px"><%=contMovimiento.getReferencia()==null?"":contMovimiento.getReferencia() %>&nbsp;</td>
								<td width="80px" align="right"><%=contMovimiento.getNaturaleza().equals("D")?format.format(Double.parseDouble(contMovimiento.getImporte())):"&nbsp;" %></td>
								<td width="80px" align="right"><%=contMovimiento.getNaturaleza().equals("C")?format.format(Double.parseDouble(contMovimiento.getImporte())):"&nbsp;" %></td>
								<td width="50px" align="right" id="opciones">
									
									<img src="../../imagenes/edit.gif" onclick="modificarMovimiento('<%=contMovimiento.getEjercicioId() %>', '<%=contMovimiento.getLibroId() %>', '<%=contMovimiento.getPolizaId() %>', '<%=contMovimiento.getNumMovto() %>');" title="Modificar" class="button" />&nbsp;
									<img src="../../imagenes/no.gif" onclick="borrarMovimiento('<%=contMovimiento.getEjercicioId() %>', '<%=contMovimiento.getLibroId() %>', '<%=contMovimiento.getPolizaId() %>', '<%=contMovimiento.getNumMovto() %>', <%=i+1 %>);" title="eliminar" class="button" />
								</td>
							</tr>
<%
	}
%>
						</table>
						<table>
							<tr>
								<td width="40px">&nbsp;</td>
								<td width="255px"><input type="text" id="foco" style="border: solid 1px white;" /></td>
								<td width="178px">&nbsp;</td>
								<td width="105px">&nbsp;</td>
								<td width="80px" align="right">&nbsp;</td>
								<td width="80px" align="right">&nbsp;</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td width="469px">&nbsp;</td>
							<td width="100px" align="right"><b>Total</b></td>
							<td width="80px" align="right" id="sumD"><%=format.format(sumD) %></td>
							<td width="77px" align="right" id="sumC"><%=format.format(sumC) %></td>
						</tr>
						<tr>
							<td width="469px">&nbsp;</td>
							<td width="100px" align="right"><b>Diferencia</b></td>
							<td width="80px" align="right" id="difD"><%=sumD>sumC?(format.format(sumD-sumC)):"-" %></td>
							<td width="77px" align="right" id="difC"><%=sumC>sumD?(format.format(sumC-sumD)):"-" %></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center">&nbsp;</td>
			</tr>
			<tr>
				<td align="center">
<%
	if(contPoliza.getEstado().equals("A")){
%>
					<input type="button" id="btnTerminaPoliza" value="Poliza Terminada" onclick="polizaTerminada();" />
<%
	}else{
%>
					<input type="button" id="btnCerrarPoliza" value="Cerrar Poliza" onclick="cerrarPoliza();" />
					<input type="button" id="btnAbrirPoliza" value="Abrir Poliza" onclick="abrirPoliza();" />
<%
	}
%>
				</td>
			</tr>
		</table>
		<div id="divResultado" style="border: solid 1px gray; background-color: #FFFFFF; position: absolute;">
		</div>
	</form>
	<script type="text/javascript">
		sumD = <%=sumD %>;
		sumC = <%=sumC %>;
	</script>
</body>

<%@ include file= "../../cierra_elias.jsp" %>