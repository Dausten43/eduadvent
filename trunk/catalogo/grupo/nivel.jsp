<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="Nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>

<head>
<script>
	function borrar(nivelId){
		if(confirm("Esta seguro que desea eliminar este registro?")){
			location.href="nivel.jsp?Accion=1&nivelId="+nivelId;
		}
	}
</script>
<%
	String escuela = (String)session.getAttribute("escuela");
	String accion  = request.getParameter("Accion")==null?"":request.getParameter("Accion");
	if(accion.equals("1")){
		Nivel.setEscuelaId(escuela);
		Nivel.setNivelId(request.getParameter("nivelId"));
		Nivel.deleteReg(conElias);
	}
	

	ArrayList<aca.catalogo.CatNivelEscuela> niveles = nivelU.getListEscuela(conElias, escuela, "ORDER BY 2");
%>
</head>
<body>
<div id="content">
	<h2><fmt:message key="catalogo.Niveles" /> <small><%=aca.catalogo.CatEscuela.getNombre(conElias, escuela) %></small></h2>

	<hr />

		<table class="table table-condensed table-bordered table-striped table-fontsmall">
			<tr>
				<th><fmt:message key="catalogo.Nivel" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
				<th><fmt:message key="aca.TituloPeriodo" /> </th>
				<th><fmt:message key="aca.Inicial" /></th>
				<th><fmt:message key="aca.Final" /></th>
				<th width="15%"><fmt:message key="aca.NotaMin" /></th>
			</tr>
			<%
	int cont = 0;
	for(aca.catalogo.CatNivelEscuela nivel: niveles){
		cont++;
%>
			<tr>
				<td><%=nivel.getNivelId() %></td>
				<td>
					<a href="grupo.jsp?nivelId=<%=nivel.getNivelId() %>&&titulo=<%=nivel.getTitulo()%>">
						<%=nivel.getNivelNombre()%>
					</a>	
				</td>
				<td><%=nivel.getTitulo() %></td>
				<td><%=nivel.getGradoIni() %></td>
				<td><%=nivel.getGradoFin() %></td>
				<td><%=nivel.getNotaminima() %></td>
			</tr>
			<%
	}
	if(niveles.size()==0){
%>
			<tr>
				<td style="text-align: center;" colspan="8" class="alert">
					<fmt:message key="aca.NoRegistros" />
				</td>
			</tr>
			<%
	}
%>
		</table>
	</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %> 