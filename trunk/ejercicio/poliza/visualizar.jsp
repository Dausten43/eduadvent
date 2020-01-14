<%@page import="aca.cont.ContMovimiento"%>
<%@page import="aca.usuario.Usuario"%>

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
	String codigoId			= (String) session.getAttribute("codigoId");
	
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
		function abrirPoliza(){
			var url = "movimientoAccion.jsp?Accion=10&ejercicioId=<%=ejercicioId %>&libroId=<%=libroId %>&polizaId=<%=polizaId %>";
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
	</script>
</head>
<body onload="inicio();">
	<table width="100%">
		<tr>
			<td><a href="cabecera.jsp?Ejercicio=<%=ejercicioId %>&ccostoId=<%=contPoliza.getCcostoId() %>">&lsaquo;&lsaquo; Regresar</a></td>
		</tr>
		<tr>
			<td class="titulo">Visualizar P&oacute;liza</td>
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
		<table width="95%" align="center" border="0">
			<tr>
				<td align="center">
					<table>
						<tr>
							<th width="30px">#</th>
							<th width="250px">Cuenta</th>
							<th width="230">Descripcion</th>
							<th width="100px">Referencia</th>
							<th width="80px">Cargo</th>
							<th width="80px">Credito</th>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="left">
					<div>
						<table id="movimientos" align="center">
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
							<tr <%=i%2!=0?strColor:"" %> id="<%=i+1 %>">
								<td width="31px"><%=i+1 %></td>
								<td width="251px"><%=contMovimiento.getMayorId() %> - <%=contRelacion.getNombre() %></td>
								<td width="232px"><%=contMovimiento.getDescripcion() %></td>
								<td width="102px"><%=contMovimiento.getReferencia()==null?"":contMovimiento.getReferencia() %></td>
								<td width="81px" align="right"><%=contMovimiento.getNaturaleza().equals("D")?format.format(Double.parseDouble(contMovimiento.getImporte())):"&nbsp;" %></td>
								<td width="81px" align="right"><%=contMovimiento.getNaturaleza().equals("C")?format.format(Double.parseDouble(contMovimiento.getImporte())):"&nbsp;" %></td>
							</tr>
<%
	}
%>
						</table>
						<table>
							<tr>
								<td width="30px">&nbsp;</td>
								<td width="250px">&nbsp;</td>
								<td width="232px">&nbsp;</td>
								<td width="102px">&nbsp;</td>
								<td width="81px" align="right">&nbsp;</td>
								<td width="81px" align="right">&nbsp;</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<table align="center">
						<tr>
							<td width="524px">&nbsp;</td>
							<td width="100px" align="right"><b>Total</b></td>
							<td width="80px" align="right" id="sumD"><%=format.format(sumD) %></td>
							<td width="80px" align="right" id="sumC"><%=format.format(sumC) %></td>
						</tr>
						<tr>
							<td width="524px">&nbsp;</td>
							<td width="100px" align="right"><b>Diferencia</b></td>
							<td width="80px" align="right" id="difD"><%=sumD>sumC?(format.format(sumD-sumC)):"-" %></td>
							<td width="80px" align="right" id="difC"><%=sumC>sumD?(format.format(sumC-sumD)):"-" %></td>
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
	if(Usuario.esAdministrador(conElias, codigoId)){
%>
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