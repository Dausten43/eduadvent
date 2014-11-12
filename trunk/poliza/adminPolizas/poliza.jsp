<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="FinPolizaLista" scope="page" class="aca.fin.FinPolizaLista"/>
<jsp:useBean id="FinPoliza" scope="page" class="aca.fin.FinPoliza"/>
<jsp:useBean id="FinMovs" scope="page" class="aca.fin.FinMovimientos"/>
	
<%
	
	String escuelaId 	= request.getParameter("escuelaId");
	String usuario 		= (String)session.getAttribute("codigoId");	
	
	ArrayList<aca.fin.FinPoliza> listaPoliza = FinPolizaLista.getPolizasEscuela(conElias, escuelaId, " ORDER BY FECHA DESC");

%>
	
<div id="content">

	<h2>
		<fmt:message key="aca.Polizas" />
	</h2>
	
	<div class="well">
		<a class="btn btn-primary" href="escuela.jsp?AsociacionId=<%=aca.catalogo.CatEscuela.getAsociacionId(conElias, escuelaId) %>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<table class="table table-striped table-bordered">
		<thead>
			<tr>
				<th style="width:5%;"><fmt:message key="aca.Poliza" /></th>			
				<th><fmt:message key="aca.Descripcion" /></th>
				<th><fmt:message key="aca.Usuario" /></th>
				<th><fmt:message key="aca.Fecha" /></th>
				<th><fmt:message key="aca.Tipo" /></th>
				<th><fmt:message key="aca.Reportes" /></th>
				<th><fmt:message key="aca.Estado" /></th>
			</tr>
		</thead>
		<%for(aca.fin.FinPoliza poliza : listaPoliza){%>
			<tr>
				<td><%=poliza.getPolizaId().substring(2) %></td>
				<td><%=poliza.getDescripcion() %></td>
				<td><%=aca.empleado.EmpPersonal.getNombre(conElias, poliza.getUsuario(), "NOMBRE") %></td>
				<td><%=poliza.getFecha() %></td>
				<td>
					<%if(poliza.getTipo().equals("C")){ %>
						<fmt:message key="aca.Caja" />
					<%}else if(poliza.getTipo().equals("I")){ %>
						<fmt:message key="aca.Ingreso" />
					<%}else if(poliza.getTipo().equals("G")){ %>
						<fmt:message key="aca.General" />
					<%} %>
				</td>
				<td>
					<a href="verMovimientos.jsp?polizaId=<%=poliza.getPolizaId() %>" class="btn btn-mini"><fmt:message key="aca.Movimientos" /></a>
				</td>
				<td>
					<%if(poliza.getEstado().equals("A")){%>
						<span class="label label-success"><fmt:message key="aca.Abierta" /></span>
					<%}else if(poliza.getEstado().equals("T")){ %>
						<span class="label label-inverse"><fmt:message key="aca.Cerrada" /></span>
					<%}else{ %>
						<span class="label label-info"><fmt:message key="aca.SunPlus" /></span>
					<%} %>
				</td>
			</tr>
		<%}%>
	</table>	

</div>	
	
<%@ include file= "../../cierra_elias.jsp" %>