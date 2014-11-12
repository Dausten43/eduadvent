<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="clasLista" scope="page" class="aca.catalogo.CatClasFinLista" />
<head>
<script>
	function Borrar(ClasfinId) {
		if (confirm("<fmt:message key="js.Confirma" />") == true) {
			document.location = "accion.jsp?Accion=4&ClasfinId=" + ClasfinId;
		}
	}
</script>
</head>
<%
	String escuelaId = (String) session.getAttribute("escuela");
	ArrayList lisClasfin = clasLista.getListEscuela(conElias, escuelaId, "ORDER BY 1");
		
%>
<body>
	<div id="content">

		<h2><fmt:message key="catalogo.ListadoDeClas" /></h2>

		<div class="well" style="overflow: hidden;">
			<a class="btn btn-primary" href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
		</div>

		<table width="40%" class="table table-nohover" align="center">
			<tr>
				<th width="5%"><fmt:message key="aca.Operacion" /></th>
				<th width="5%">#</th>
				<th width="25%"><fmt:message key="aca.Nombre" /></th>
				<th width="10%"><fmt:message key="aca.Estado" /></th>
				
			</tr>
			<%
				for (int i = 0; i < lisClasfin.size(); i++) {
						aca.catalogo.CatClasFin clasif = (aca.catalogo.CatClasFin) lisClasfin.get(i);						
			%>			
			<tr>
				<td align="center"><a
					href="accion.jsp?Accion=5&ClasfinId=<%=clasif.getClasfinId()%>&ClasfinNombre=<%=clasif.getClasfinNombre()%>"										
					class="icon-pencil"></a> <a
					href="javascript:Borrar('<%=clasif.getClasfinId()%>')"
					class="icon-remove"></a></td>
					
				<td align="center"><%=clasif.getClasfinId()%></td>
				<td><%=clasif.getClasfinNombre()%></td>
				<td><%=clasif.getEstado()%></td>
				
			</tr>
			<%
				}
			%>
		</table>

	</div>
</body>
<%@ include file="../../cierra_elias.jsp"%>
