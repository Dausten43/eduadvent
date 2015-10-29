<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinCalculoLista" scope="page" class="aca.fin.FinCalculoLista"/>

<script>	
	
	function cambiaCiclo(){
		document.forma.submit();
	}	

</script>

<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00");

	String escuelaId 	= (String) session.getAttribute("escuela");
	String ejercicioId 	= (String)session.getAttribute("EjercicioId");
	String usuario 		= (String)session.getAttribute("codigoId");				
	String cicloId		= request.getParameter("cicloId")==null?"":request.getParameter("cicloId");
	String periodoId	= request.getParameter("periodoId")==null?"":request.getParameter("periodoId");
	String pagoId		= request.getParameter("pagoId")==null?"":request.getParameter("pagoId");
	
	String view			= request.getParameter("View")==null?"3":request.getParameter("View");
	String opcion 		= "'A', 'C'";
	
	if(view.equals("1")){
		opcion="'A'";
	}else if(view.equals("2")){
		opcion="'C'";		
	}else{
		opcion="'A', 'C'";
	}	
	// Lista de alumnos en el pago
	java.util.ArrayList<String> lisAlumnos = FinCalculoLista.listAlumnosEnPago(conElias, cicloId, periodoId, pagoId, opcion, " ORDER BY 1");

	// Map de importes del pago por cada alumno
	java.util.HashMap<String, String> mapPago = FinCalculoLista.mapAlumnosEnPago(conElias, cicloId, periodoId, pagoId, opcion);	
%>

<div id="content">
	
	<h2><fmt:message key="aca.Movimiento" /><small>( Ciclo: <%=cicloId%>&nbsp Periodo: <%=periodoId%>&nbsp Pago: <%=pagoId%>&nbsp)</small></h2>	
	
		<div class="well">
			<a href="importarMovimientos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		
		<form name="forma" action="pagoAlumnos.jsp?cicloId=<%=cicloId%>&periodoId=<%=periodoId%>&pagoId=<%=pagoId%>" method="post" style="display:inline;">
			<select name="View" id="View" onchange="this.form.submit();">
				<option value="1" <%if(view.equals("1")){out.print("selected");}%>>Pendientes</option>
				<option value="2" <%if(view.equals("2")){out.print("selected");}%>>Contabilizados</option>
				<option value="3" <%if(view.equals("3")){out.print("selected");}%>>Total</option>	
			</select>
		</form>
		</div>
		
	<table class="table table-striped">
	
	<tr>
		<th>#</th>
		<th>Matricula</th>
		<th>Nombre</th>		
		<th style="text-align:right">Importe</th>
		
	</tr>

<% 	
	int numero = 0;
	for(String alumno:lisAlumnos){
		numero ++;
		double importe = 0.0;
		if (mapPago.containsKey(alumno)){
			importe = Double.parseDouble(mapPago.get(alumno));
		}
		 String nombreAlumno = aca.alumno.AlumPersonal.getNombre(conElias, alumno, "NOMBRE");
		%>		
			<tr>
				<td><%=numero%></td>
				<td><%=alumno%></td>
				<td><%=nombreAlumno%></td>				
				<td style="text-align:right"><%=formato.format(importe)%></td>
			</tr>
		<%	
	}

%>		
	</table>		
</div>

<%@ include file= "../../cierra_elias.jsp" %>