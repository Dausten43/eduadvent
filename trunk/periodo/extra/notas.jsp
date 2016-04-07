<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="ciclo" scope="page" class="aca.ciclo.Ciclo" />
<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="cicloExtra" scope="page" class="aca.ciclo.CicloExtra" />
<jsp:useBean id="cicloExtraL" scope="page" class="aca.ciclo.CicloExtraLista" />


<script>
	function eliminar(ciclo, oportunidad) {
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			location = "notas.jsp?Accion=1&ciclo=" + ciclo + "&oportunidad=" + oportunidad;
		}
	}
</script>

<%
	String escuelaId 	= (String) session.getAttribute("escuela");
	String cicloId 		= request.getParameter("ciclo")==null?(String) session.getAttribute("cicloId"):request.getParameter("ciclo");
	String salto		= "X";

	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloL.getListActivos(conElias, escuelaId, "ORDER BY F_INICIAL");
	ArrayList<aca.ciclo.CicloExtra> lisextras = cicloExtraL.getListCiclo(conElias, cicloId, "ORDER BY OPORTUNIDAD");

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
		cicloExtra.mapeaRegId(conElias, cicloId, request.getParameter("oportunidad"));
			
		if (cicloExtra.deleteReg(conElias)) {
			msj = "Eliminado";
			salto = "notas.jsp";
		} else {
			msj = "NoElimino";
			salto = "notas.jsp";
		}
	}
	
	pageContext.setAttribute("resultado", msj);
%>

<div id="content">
	<h2><fmt:message key="aca.Periodos" /></h2>
	

	<form id="forma" name="forma" action="notas.jsp" method="post">
		
		<div class="well">
			<a class="btn btn-primary btn-mobile" href="accion.jsp?ciclo=<%=cicloId%>"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
			<select id="ciclo" name="ciclo" onchange="document.forma.submit();" class="input-xxlarge pull-right">
				<%for ( aca.ciclo.Ciclo Ciclo : lisCiclo ) {%>
					<option value="<%=Ciclo.getCicloId()%>" <%=cicloId.equals(Ciclo.getCicloId())?"selected":""%>><%=Ciclo.getCicloId()+" - "+Ciclo.getCicloNombre()%></option>
				<%}%>
			</select>
		</div>
	</form>
	<table class="table table-bordered">
		<tr>
			<th>#</th>
			<th><fmt:message key="aca.Op" /></th>
			<th><fmt:message key="aca.OportunidadId" /></th>
			<th><fmt:message key="aca.ValorAnterior" /></th>
			<th><fmt:message key="aca.ValorExtra" /></th>
			<th><fmt:message key="aca.OportunidadNombre" /></th>
		</tr>
<%
			int cont = 1;
			for(aca.ciclo.CicloExtra extras : lisextras){
%>
		<tr>
			<td><%=cont %></td>
			<td>
				<a href="accion.jsp?ciclo=<%=extras.getCicloId()%>&oportunidad=<%=extras.getOportunidad()%>"><i class="icon-pencil"></i></a>
				<a onclick="eliminar('<%=extras.getCicloId()%>', '<%=extras.getOportunidad()%>');"><i class="icon-remove"></i></a>
			</td>
			<td><%=extras.getOportunidad() %></td>
			<td><%=extras.getValorAnterior() %></td>
			<td><%=extras.getValorExtra() %></td>
			<td><%=extras.getOportunidadNombre() %></td>
		</tr>
<%	
				cont++;
			}
%>
	</table>
	

	
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>