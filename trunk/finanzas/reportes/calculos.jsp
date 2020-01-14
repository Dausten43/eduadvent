<%@page import="java.util.HashMap"%>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista"/>
<jsp:useBean id="planL" scope="page" class="aca.plan.PlanLista"/>
<jsp:useBean id="FinCalculoL" scope="page" class="aca.fin.FinCalculoLista"/>
<jsp:useBean id="AlumPersonalL" scope="page" class="aca.alumno.AlumPersonalLista"/>

<html>
<script type="text/javascript">
	function Mostrar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>
<%
	java.text.DecimalFormat formato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String escuelaId 		= (String) session.getAttribute("escuela");
	String ejercicioId 		= (String) session.getAttribute("ejercicioId");

	String cicloId			= request.getParameter("ciclo")		== null ? (String) session.getAttribute("cicloId") : request.getParameter("ciclo");
	String periodoId		= request.getParameter("periodo")	== null ? "0" : request.getParameter("periodo");
	String planId			= request.getParameter("plan")		== null ? "0" : request.getParameter("plan");	
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
		
	// Trae los ciclos escolares
	ArrayList<aca.ciclo.Ciclo> lisCiclo 	= cicloL.getListAll(conElias, escuelaId, "ORDER BY CICLO_ID");
		
	// Verifica que tenga un ciclo valido en session.
	if (cicloId.equals("XXXXXXX")){
		if (lisCiclo.size()>0){
			cicloId =  ((aca.ciclo.Ciclo)lisCiclo.get(0)).getCicloId();
			session.setAttribute("cicloId",cicloId);
		}	
	}	
	
	// Trae los ciclos escolares
	ArrayList<aca.fin.FinCalculo> lisCalculos 	= FinCalculoL.getListCalculos(conElias, cicloId, periodoId, " ORDER BY PLAN_ID, CODIGO_ID");
	
	/*Nombre de Alumnos*/
	java.util.HashMap<String, String> mapAlumnos 		= AlumPersonalL.mapNombreLargo(conElias, escuelaId, "NOMBRE");
%>
<body>
<div id="content">
	<h2>Lista de cálculos</h2>
	<form name="forma" id="forma" method="post" action="calculos.jsp">
	<input type="hidden" name="Accion" />
	<div class="well">
		<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
		<fmt:message key="aca.Ciclo" />:&nbsp;
		<select class="input-xlarge" id="ciclo" name="ciclo" onchange="document.forma.submit();" class="input-xlarge">
			<%for(aca.ciclo.Ciclo ciclo : lisCiclo){%>
				<option value="<%=ciclo.getCicloId() %>" <%if(cicloId.equals(ciclo.getCicloId())){out.print("selected");} %>><%=ciclo.getCicloNombre() %></option>	
			<%}%>
		</select>
		&nbsp;&nbsp;<fmt:message key="aca.Periodo" />:&nbsp;			
		<select id="periodo" name="periodo" onchange="document.forma.submit();" class="input-xlarge">
			<% 
				ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo = cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY F_INICIO");
				if(periodoId.equals("0")){
					if(lisCicloPeriodo.size() > 0) periodoId = lisCicloPeriodo.get(0).getPeriodoId();					
				}
				for(aca.ciclo.CicloPeriodo cicloPeriodo : lisCicloPeriodo){
			%>
					<option value="<%=cicloPeriodo.getPeriodoId() %>" <%if(periodoId.equals(cicloPeriodo.getPeriodoId())){out.print("selected");} %>><%=cicloPeriodo.getPeriodoNombre() %></option>			
			<%
				}
			%>
		</select>
		&nbsp;&nbsp;
		<a href="javascript:Mostrar();" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Mostrar</a>
	</div>
	</form>
	
	<table class="table table-striped">
		<tr>
			<th>#</th>
			<th>Plan</th>
			<th>Código</th>
			<th>Alumno</th>
			<th>Clasificación</th>
			<th>Fecha</th>
			<th>Inicial</th>
			<th>Pagos</th>
			<th>Importe</th>			
		</tr>
<%	
	int cont = 1;
	for(aca.fin.FinCalculo calculoAlumno : lisCalculos){
		
		String nombreAlumno = "-";
		if(mapAlumnos.containsKey(calculoAlumno.getCodigoId())){
				nombreAlumno = mapAlumnos.get(calculoAlumno.getCodigoId());
		}
%>
	<tr>
		<td><%=cont %></td>
		<td><%= aca.plan.Plan.getNombrePlan(conElias, calculoAlumno.getPlanId()) %></td>
		<td><%=calculoAlumno.getCodigoId() %></td>
		<td><%=nombreAlumno %></td>
		<td><%= aca.catalogo.CatClasFin.getClasFinNombre(conElias, escuelaId, calculoAlumno.getClasFinId())%></td>
		<td><%=calculoAlumno.getFecha() %></td>
		<td><%=calculoAlumno.getPagoInicial() %></td>
		<td><%=Double.parseDouble(calculoAlumno.getImporte())-Double.parseDouble(calculoAlumno.getPagoInicial())%></td>
		<td><%=calculoAlumno.getImporte() %></td>
	</tr>
<%		cont++;
	} 
%>
	</table>
</div>
</body>
</html>
<%@ include file= "../../cierra_elias.jsp" %>