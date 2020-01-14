<%@page import="aca.fin.FinCuenta"%>
<%@page import="java.util.Map"%>
<%@page import="aca.fin.FinCuentaLista"%>
<%@page import="java.util.Calendar"%>
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

<jsp:useBean id="escuela" scope="page"	class="aca.catalogo.CatEscuela" />
<style>
@page {
	margin-top: 0.3cm;
	margin-left: 0.3cm;
	margin-right: 0.3cm;
	margin-bottom: 0.3cm;
}

@media print  {
	.encabezado {
		border-bottom: double 0.3em;
	}
	.totalFinal {
		border-top: double 0.3em;
	}
	.headerTabla {
		border-top: solid 0.2em black;
		border-bottom: solid 0.2em black;
	}
	table{
		border-spacing: 0px;
	}
	
	table tr td{
		border-bottom: 0.1em solid gray;
		padding: 0px;
		
	}
	table tr th{
		border-bottom: 0.2em solid black;
		border-left: 0em;
		border-right: 0em;
		border-top:  0em;
		overflow: hidden;
	}
	
	.movimientos{
		font-size: 10px;
		
	}
	
}



</style>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript" src="../../bootstrap/datepicker/datepicker.js"></script>

<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	Calendar cal = Calendar.getInstance();
	
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String ejercicioId	= (String) session.getAttribute("ejercicioId");
	
	String accion 		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String resultado	= "";
	

	String fechaHoy 		= aca.util.Fecha.getHoy();
	String fechaInicio 		= request.getParameter("fechaInicio")==null?"01/01/"+cal.get(Calendar.YEAR):request.getParameter("fechaInicio");
	String fechaFinal		= request.getParameter("fechaFinal")==null?"31/12/"+cal.get(Calendar.YEAR):request.getParameter("fechaFinal");
	String txtPersonalizado ="";
	String archivo = "textopersonalizado.txt";
    //System.out.println(archivo);
	FileReader f = new FileReader(getServletContext().getRealPath("/")+"finanzas/cuenta/"+archivo);
    BufferedReader b = new BufferedReader(f);
	escuela.mapeaRegId(conElias, escuelaId.toString());
		
	AlumPersonal.mapeaRegId(conElias, codigoId);
	
	// Movimientos registrados en EduAdvent
	ArrayList<aca.fin.FinMovimientos> lisMovimientos = MovimientosL.getListAlumnoAll(conElias, codigoId, fechaInicio, fechaFinal, "'A','R'"," ORDER BY TO_CHAR(FECHA,'YYYY-MM-DD')");
 	FinCuentaLista finCuenta = new FinCuentaLista();
 	Map<String, FinCuenta> mapCuentas = finCuenta.mapCuentasEscuela(conElias, escuelaId);
	
%>
<%@ include file= "menuPortal.jsp" %>
<div id="content">
	<center><h3><%=escuela.getEscuelaNombre() %></h3></center>
	<h2>
		<center>Estado de cuenta 
		<small> <%=codigoId %> | <%=AlumPersonal.getApaterno() %> <%=AlumPersonal.getAmaterno() %> <%=AlumPersonal.getNombre() %></small>
		</center>
	</h2>
	
	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr class="headerTabla">
				<th>Poliza</th>
				<th>Fecha</th>
				
				
				<th>Descripción</th>
					
				<th class="text-right">Débito</th>
				<th class="text-right">Crédito</th>
				<th class="text-right">Saldo</th>
				<th class="text-right">Estado</th>
			</tr>
		</thead>
	<%
		// Consulta el saldo anterior del alumno
		String saldoStr 	= aca.fin.FinMovimientos.getSaldoAnterior(conElias, codigoId, fechaInicio);
		double saldoNum		= Double.valueOf(saldoStr)*-1;
		String signoSaldo	= saldoNum>=0?"Acreedor":"Deudor"; 
		
		//System.out.println("Datos:"+saldoStr+":"+saldoNum);
		
		// Línea del saldo anterior
		if(lisMovimientos.size() > 0){
			out.print("<tr class=\"movimientos\">");
			out.print("<td align='center'>-</td>");
			
			
			
			out.print("<td align='center'>-</td>");
			out.print("<td align='center'><b>Saldo Anterior</b></td>");
			
			if (saldoNum>0){
				out.print("<td>&nbsp;</td>");
				out.print("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
			}else{
				out.print("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
				out.print("<td>&nbsp;</td>");
			}
			out.println("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
			out.println("<td class='text-right' ");
			if(saldoNum<0){
				out.println("style='color:red;'");
			}else{
				out.println("style='color:green;'");
				
			}
			out.println(">"+signoSaldo+"</td>");
			out.println("</tr>");
		}else{
			out.print("<tr class=\"movimientos\">");
			out.print("<td align='center'>-</td>");
			
			
			
			out.print("<td align='center'>-</td>");
			out.print("<td align='center'><b>Saldo Anterior</b></td>");
			
			if (saldoNum>0){
				out.print("<td>&nbsp;</td>");
				out.print("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
			}else{
				out.print("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
				out.print("<td>&nbsp;</td>");
			}
			out.println("<td class='text-right'>"+formato.format(saldoNum)+"</td>");
			out.println("<td class='text-right' ");
			if(saldoNum<0){
				out.println("style='color:red;'");
			}else{
				out.println("style='color:green;'");
				
			}
			out.println(">"+signoSaldo+"</td>");
			out.println("</tr>");
		}
		float total = (float)saldoNum;			
		for(int i = 0; i < lisMovimientos.size(); i++){
			aca.fin.FinMovimientos movto = (aca.fin.FinMovimientos) lisMovimientos.get(i);
			if(mapCuentas.containsKey(movto.getCuentaId()) && mapCuentas.get(movto.getCuentaId()).getCuentaAislada().equals("N")){
			if((movto.getImporte()==null)&&(movto.getNaturaleza()==null)){
				movto.setImporte("0");
				movto.setNaturaleza("");					
			}
			
			if(movto.getNaturaleza().equals("D")){
				total -= Float.parseFloat(movto.getImporte());
			}else{
				total += Float.parseFloat(movto.getImporte());
			}
			signoSaldo	= total<0?"Deudor":"Acreedor"; 
	%>
		<tr class="movimientos">
			<td><%=movto.getPolizaId() %></td>
			<td><%=movto.getFecha() %></td>
			
			<td><%=movto.getDescripcion() %></td>
				
			<td class="text-right"><%=movto.getNaturaleza().equals("D")?formato.format(Float.parseFloat(movto.getImporte())):"" %></td>
			<td class="text-right"><%=movto.getNaturaleza().equals("C")?formato.format(Float.parseFloat(movto.getImporte())):"" %></td>
			<td class="text-right"><%=formato.format(total) %></td>
			<td class="text-right" <%=total<0?"style='color:red;'":"style='color:green;'"%>><%=signoSaldo%></td>
		</tr>
	<%
			}
		}			
		if(lisMovimientos.size() == 0){
			out.println("<tr><td colspan='9' align='center'>No existen movimientos del alumno en este ejercicio</td></tr>");
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
<script>
	jQuery('.finanzas').addClass('active');
</script>
<%@ include file= "../../cierra_elias.jsp" %>