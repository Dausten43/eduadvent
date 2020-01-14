<%@page import="aca.util.Fecha"%>
<%@ page import= "java.io.BufferedReader" %>
<%@ page import= "java.io.FileNotFoundException"  %>
<%@ page import= "java.io.FileReader" %>
<%@ page import= "java.io.IOException" %>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="AlumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="MovimientoL" scope="page" class="aca.fin.FinMovimientoLista"/>
<jsp:useBean id="MovimientosL" scope="page" class="aca.fin.FinMovimientosLista"/>
<jsp:useBean id="MovsSunPlusL" scope="page" class="aca.sunplus.AdvASalfldgLista"/>
<jsp:useBean id="CatParametro" scope="page"	class="aca.catalogo.CatParametro" />
<jsp:useBean id="escuela" scope="page"	class="aca.catalogo.CatEscuela" />

<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>
<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String ejercicioId	= (String) session.getAttribute("ejercicioId");
	
	String accion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String resultado	= "";
	boolean usaSunPlus	= aca.catalogo.CatParametro.esSunPlus(conElias, escuelaId);

	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaInicio 		= request.getParameter("fechaInicio")==null?"01/01/"+aca.util.Fecha.getYearNum():request.getParameter("fechaInicio");
	String fechaFinal		= request.getParameter("fechaFinal")==null?"31/12/"+aca.util.Fecha.getYearNum():request.getParameter("fechaFinal");
	String txtPersonalizado ="";
	String archivo = "textopersonalizado.txt";
    //System.out.println(archivo);
	FileReader f = new FileReader(getServletContext().getRealPath("/")+"finanzas/cuenta/"+archivo);
    BufferedReader b = new BufferedReader(f);
	escuela.mapeaRegId(conElias, escuelaId.toString());
		
	AlumPersonal.mapeaRegId(conElias, codigoId);
	
	// Movimientos registrados en EduAdvent
	ArrayList<aca.fin.FinMovimientos> lisMovimientos = MovimientosL.getListAlumnoAll(conElias, codigoId, fechaInicio, fechaFinal, "'A','R'"," ORDER BY TO_CHAR(FECHA,'YYYY-MM-DD')");
	
	// Movimientos registrados en SunPlus
	ArrayList<aca.sunplus.AdvASalfldg> lisMovimientosSunPlus = null;
	
	
	// Valida si usa el sunplus y activa la conexión
	if (usaSunPlus){
		CatParametro.mapeaRegId(conElias, escuelaId);
		String sunPlusIpServer		= CatParametro.getIpServer();
		String sunPlusPuerto		= CatParametro.getPuerto();
		String sunPlusBaseDatos 	= CatParametro.getBaseDatos();	
		
		if (aca.conecta.Conectar.conSunPlusPrueba(sunPlusIpServer, sunPlusPuerto, sunPlusBaseDatos, "", "")){			
			conSunPlus = aca.conecta.Conectar.conSunPlusDir(sunPlusIpServer, sunPlusPuerto, sunPlusBaseDatos, "", "");
			lisMovimientosSunPlus = MovsSunPlusL.getListAll(conSunPlus, "");
		}		
	}
%>

<div id="content">
	<center><h3><%=escuela.getEscuelaNombre() %></h3></center>
	<h2>
		<center>Estado de cuenta 
		<small> <%=codigoId %> | <%=AlumPersonal.getApaterno() %> <%=AlumPersonal.getAmaterno() %> <%=AlumPersonal.getNombre() %></small>
		</center>
	</h2>
	<form name="frmEstado" id="frmEstado" method="post" action="estado_cuenta.jsp">
		<div class="well">
			Fecha Inicio: <input type="text" style="width:100px;"  data-date-format="dd/mm/yyyy" id="fechaInicio" name="fechaInicio" value="<%=fechaInicio%>"/>
			Fecha Final: <input type="text"  style="width:100px;" data-date-format="dd/mm/yyyy" id="fechaFinal" name="fechaFinal" value="<%=fechaFinal%>"/>
			<a class="btn btn-success" onclick="javascript:document.frmEstado.submit();">Cargar fecha</a>
		</div>
	</form>
	<hr />
<%	if (usaSunPlus){  %>	
	<h4>SunPlus</h4>
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<th>Cuenta</th>
			</tr>
		</thead>
	<%	for(aca.sunplus.AdvASalfldg mov : lisMovimientosSunPlus){ %>
			<tr>
				<td><%=mov.getAccntCode() %></td>
			</tr>
	<%	}
		if( lisMovimientosSunPlus.size() == 0 ){%>
			<tr>
				<td>No existen movimientos para este alumno</td>
			</tr>
	<%	} %>	
	</table>
<%	}%>
	
	<h4>eduAdvent</h4>
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<th>Poliza</th>
				<th>#</th>				
				<th>Fecha</th>
				<th>Cuenta</th>
				<th>Recibo</th>
				<th>Descripción</th>
				<th>Referencia</th>						
				<th class="text-right">Débito</th>
				<th class="text-right">Crédito</th>
				<th class="text-right">Saldo</th>
				<th class="text-right">Estado</th>
			</tr>
		</thead>
	<%
		// Consulta el saldo anterior del alumno
		String saldoStr 	= aca.fin.FinMovimientos.getSaldoAnterior(conElias, codigoId, fechaInicio);
		double saldoNum		= Double.valueOf(saldoStr);
		String signoSaldo	= saldoNum>=0?"Crédito":"Débito"; 
		
		//System.out.println("Datos:"+saldoStr+":"+saldoNum);
		
		// Línea del saldo anterior
		if(lisMovimientos.size() > 0){
			out.print("<tr>");
			out.print("<td align='center'>-</td>");
			out.print("<td align='center'>0</td>");
			out.print("<td align='center'>-</td>");			
			out.print("<td align='center'>-</td>");
			out.print("<td align='center'>-</td>");
			out.print("<td align='center'><b>Saldo Anterior</b></td>");
			out.print("<td align='center'>-</td>");
			if (saldoNum>0){
				out.print("<td>&nbsp;</td>");
				out.print("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
			}else{
				out.print("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
				out.print("<td>&nbsp;</td>");
			}
			out.println("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
			out.println("<td class='text-right'>"+signoSaldo+"</td>");
			out.println("</tr>");
		}
		float total = (float)saldoNum;			
		for(int i = 0; i < lisMovimientos.size(); i++){
			aca.fin.FinMovimientos movto = (aca.fin.FinMovimientos) lisMovimientos.get(i);
			
			if((movto.getImporte()==null)&&(movto.getNaturaleza()==null)){
				movto.setImporte("0");
				movto.setNaturaleza("");					
			}
			
			if(movto.getNaturaleza().equals("D")){
				total -= Float.parseFloat(movto.getImporte());
			}else{
				total += Float.parseFloat(movto.getImporte());
			}
			signoSaldo	= total>=0?"Crédito":"Débito"; 
	%>
		<tr>
			<td><%=movto.getPolizaId() %></td>
			<td><%=i+1 %></td>
			<td><%=movto.getFecha() %></td>
			<td><%=movto.getCuentaId() %>
			<td><%=movto.getReciboId() %>
			<td><%=movto.getDescripcion() %></td>
			<td><%=movto.getReferencia() %></td>						
			<td class="text-right"><%=movto.getNaturaleza().equals("D")?formato.format(Float.parseFloat(movto.getImporte())):"" %></td>
			<td class="text-right"><%=movto.getNaturaleza().equals("C")?formato.format(Float.parseFloat(movto.getImporte())):"" %></td>
			<td class="text-right"><%=formato.format(total) %></td>
			<td class="text-right" <%=total<0?"style='color:red;'":"style='color:green;'"%>><%=signoSaldo%> <%=formato.format(total)%></td>
		</tr>
	<%
		}			
		if(lisMovimientos.size() == 0){
			out.println("<tr><td colspan='9' align='center'>No existen movimientos para éste alumno</td></tr>");
		} 
	%>
		
	</table>
	
	<%
	String cadena="";
    while((cadena = b.readLine())!=null) {
        txtPersonalizado = txtPersonalizado+cadena;
    }
    b.close();	
	
	if (total< 0 && escuelaId.toString().contains("H") && txtPersonalizado.substring(0,2).equalsIgnoreCase("SI")) { %><table class="table table-condensed table-bordered"><tr><td><%=txtPersonalizado.substring(3) %></td></tr></table><% } %>
</div>
<script>
	jQuery('#fechaInicio').datepicker();
	jQuery('#fechaFinal').datepicker();
</script>

<%@ include file= "../../cierra_elias.jsp" %>