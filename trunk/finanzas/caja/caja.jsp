<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<jsp:useBean id="ReciboU" scope="page" class="aca.fin.FinReciboLista"/>

<head>
<script type="text/javascript">
		
	function BuscarDoctos( ){
		document.frmRecibo.Accion.value = "1";
		document.frmRecibo.submit();
	}
	
</script>		
</head>
<%
	java.text.DecimalFormat frmNum = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String codigoId 		= (String) session.getAttribute("codigoId");
	String tipo 			= request.getParameter("Tipo")==null?"R":request.getParameter("Tipo");
	String fecha			= request.getParameter("Fecha")==null?aca.util.Fecha.getHoy():request.getParameter("Fecha");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	String tipoNombre		= tipo.equals("R")?"Recibo":"Factura";
	
	double total			= 0;
	// Lista
	ArrayList lisDoctos		= ReciboU.getListRecibos(conElias, codigoId, tipo, fecha, "ORDER BY RECIBO_ID");
%>
<body>
	
	<div id="content">
	<h2>Diario de caja <small><%=aca.empleado.EmpPersonal.getNombre(conElias, codigoId, "NOMBRE") %></small></h2>
		<form id="frmRecibo" name="frmRecibo" action="caja.jsp" method="post">
		<div class="well">
			<div class="row">
				<div class="span4">
					<label>Fecha:</label>
					<input name="Fecha" type="text" id="Fecha" size="8" maxlength="10" value="<%=fecha%>"> DD/MM/AAAA 				
				</div>
				<div class="span4">
					<label>Documentos:</label>
					<select id="Tipo" name="Tipo" onchange="javascript:BuscarDoctos()">
					  <option value="R"<%=tipo.equals("R")?" Selected":""%>>Recibos</option>
					  <option value="F"<%=tipo.equals("F")?" Selected":""%>>Facturas</option>
					</select>
				</div>
				<div class="span4">
					<a class="btn btn-primary" href="javascript:BuscarDoctos()" style="margin-top: 23px;"><i class="icon-search icon-white"></i> Buscar</a>
					<!--  <input type="button" class="btn btn-primary" value="Buscar" id="Buscar" style="margin-top: 23px;" onclick="javascript:BuscarDoctos()">-->
					
				</div>
			</div>
		</div>
		<input type="hidden" name="Accion">
		<div>
			<a class="btn btn-primary pull-left" href="recibo.jsp?Tipo=<%=tipo%>&Accion=1"><i class="icon-plus icon-white"></i> Añadir <%=tipoNombre%></a>
		</div><br>
		</form>
		  <table align="center" class="table table-condensed" width="80%">
		    <tr>
			  <th>Folio</th>
			  <th>Cliente</th>
			  <th>RFC</th>
			  <th>Observaciones</th>
			  <th>Importe</th>
			</tr>
		<%
			for(int i=0; i<lisDoctos.size(); i++){
				aca.fin.FinRecibo recibo = (aca.fin.FinRecibo) lisDoctos.get(i);
				total = total+Double.valueOf(recibo.getImporte());
		%>	
			<tr>
			  <td><a href="recibo.jsp?Tipo=<%=tipo%>&Accion=2&Folio=<%=recibo.getReciboId()%>"><%= recibo.getReciboId() %></a></td>
			  <td><%= recibo.getCliente() %></td>
			  <td><%= recibo.getRfc() %></td>
			  <td><%= recibo.getObservaciones() %></td>
			  <td align="right"><%= frmNum.format(Double.valueOf(recibo.getImporte())) %></td>
			</tr>	
		<%	}
			if (lisDoctos.size()==0){
				out.println("<tr><td colspan='5' align='center'>¡No hay documentos registrados!</td></tr>");
			}else{ %>
			<tr>
			  <td colspan = "4" align="center"><b>T O T A L &nbsp; &nbsp;  D E L &nbsp; &nbsp; D I A R I O</b></td>
			  <td align="right"><%= frmNum.format(total) %></td>
			</tr>
		  </table>  
		  <table align="center" width="80%" class="table table-condensed">
			<tr><td colspan = "5" align="center">&nbsp;</td></td>
			<tr><td colspan = "5" align="center" style="font-size:12pt"><b>Disitriución de Ingresos por Niveles</b></td></td>
			<tr>
			  <th align="center">Preescolar</th>
			  <th align="center">Primaria</th>
			  <th align="center">Secundaria</th>
			  <th align="center">Bachillerato</th>
			  <th align="center">Total</td>
			</tr>
		<%
			double preescolar 	= Double.valueOf(aca.fin.FinRecibo.totalNivel(conElias, fecha, "1", tipo));
			double primaria 	= Double.valueOf(aca.fin.FinRecibo.totalNivel(conElias, fecha, "2", tipo));
			double secundaria 	= Double.valueOf(aca.fin.FinRecibo.totalNivel(conElias, fecha, "3", tipo));
			double bachillerato = Double.valueOf(aca.fin.FinRecibo.totalNivel(conElias, fecha, "4", tipo));
		%>	
			<tr>	  
			  <td align="right"><%= frmNum.format(preescolar)%></td>
			  <td align="right"><%= frmNum.format(primaria) %></td>
			  <td align="right"><%= frmNum.format(secundaria) %></td>
			  <td align="right"><%= frmNum.format(bachillerato) %></td>
			  <td align="right"><%= frmNum.format(total) %></td>
			</tr>	
		<%	} %>
		  </table>
	</div>
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>