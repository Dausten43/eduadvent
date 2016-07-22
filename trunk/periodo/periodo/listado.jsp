<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo" />
<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="cicloPeriodo" scope="page" class="aca.ciclo.CicloPeriodo" />
<jsp:useBean id="cicloPeriodoL" scope="page" class="aca.ciclo.CicloPeriodoLista" />
<jsp:useBean id="AlumCicloLista" scope="page" class="aca.alumno.AlumCicloLista" />


<script>
	function eliminar(ciclo, periodo) {
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			location = "listado.jsp?Accion=1&ciclo=" + ciclo + "&periodo=" + periodo;
		}
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId 		= request.getParameter("ciclo");

	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloL.getListAll(conElias, escuelaId, "AND ESTADO NOT IN ('I') ORDER BY F_INICIAL");

	if (cicloId == null) {
		cicloId = (String) session.getAttribute("cicloId");
		if (!cicloId.substring(0, 3).equals(escuelaId)) { // Esto es por si en sesion hay cargado un ciclo que pertenece a otra escuela
			ciclo = (aca.ciclo.Ciclo) lisCiclo.get(0);
			cicloId = ciclo.getCicloId();
			session.setAttribute("cicloId", cicloId);
		}
	} else{
		session.setAttribute("cicloId", cicloId);	
	}
			
	String accion 		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj 			= "";

	if (accion.equals("1")) {
		cicloPeriodo.mapeaRegId(conElias, cicloId, request.getParameter("periodo"));
			
		if (cicloPeriodo.deleteReg(conElias)) {
			msj = "Eliminado";
		} else {
			msj = "NoElimino";
		}
	}
	
	pageContext.setAttribute("resultado", msj);
%>

<div id="content">
	<h2><fmt:message key="aca.Periodos" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  

	<form id="forma" name="forma" action="listado.jsp" method="post">
		
		<div class="well">
			<a class="btn btn-primary btn-mobile" href="edita_periodo.jsp?ciclo=<%=cicloId%>"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
			<select id="ciclo" name="ciclo" onchange="document.forma.submit();" class="input-xxlarge pull-right">
				<%for ( aca.ciclo.Ciclo Ciclo : lisCiclo ) {%>
					<option value="<%=Ciclo.getCicloId()%>" <%=cicloId.equals(Ciclo.getCicloId())?"selected":""%>><%=Ciclo.getCicloNombre()%></option>
				<%}%>
			</select>
		</div>
	</form>

	<table class="table table-condensed table-bordered"">
	<%
		ArrayList<aca.ciclo.CicloPeriodo> lisCicloPeriodo = cicloPeriodoL.getListCiclo(conElias, cicloId, "ORDER BY F_INICIO");
		
		if (lisCicloPeriodo.size() > 0) {
	%>
			<tr>
				<th><fmt:message key="aca.Operacion" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
				<th><fmt:message key="aca.FechaInicio" /></th>
				<th><fmt:message key="aca.FechaFinal" /></th>
			</tr>
			<%
				for (aca.ciclo.CicloPeriodo CicloPeriodo : lisCicloPeriodo) {
					int cantAlumnos = AlumCicloLista.getListAll(conElias, escuelaId, " AND CICLO_ID='" + cicloId + "' AND PERIODO_ID='" + CicloPeriodo.getPeriodoId() + "' ").size();
			%>
					<tr>
						<td>
							<a onclick="location='edita_periodo.jsp?ciclo=<%=cicloId%>&periodo=<%=CicloPeriodo.getPeriodoId()%>'"><i class="icon-pencil"></i></a>
				 			<%if (!aca.ciclo.CicloPeriodo.tieneDatos(conElias, cicloId, CicloPeriodo.getPeriodoId()) && cantAlumnos<=0) {%>
								<a onclick="eliminar('<%=cicloId%>', '<%=CicloPeriodo.getPeriodoId()%>');"><i class="icon-remove"></i></a>
					 		<%}%>
					 	</td>
						<td><%=CicloPeriodo.getPeriodoNombre()%></td>
						<td><%=CicloPeriodo.getFInicio()%></td>
						<td><%=CicloPeriodo.getFFinal()%></td>
					</tr>
	<%
				} 
		
		} else {
	%>
			<tr>
				<td><fmt:message key="aca.NoExistenPeriodosDeInscripcion" /></td>
			</tr>
	<%
		}
	%>
	</table>
	
</div>

<%@ include file="../../cierra_elias.jsp"%>