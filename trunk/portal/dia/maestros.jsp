<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="CatNivelL" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoId 		= (String)session.getAttribute("codigoId");
	int totMaestros			= aca.ciclo.CicloGrupoCurso.numMaetrosDIA(conElias);
	int totHombres			= aca.empleado.EmpPersonal.numMaestroGenero(conElias, "M");
	int totMujeres			= totMaestros-totHombres;
	
	int row = 0;
	/* Lista de niveles*/
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel = CatNivelL.getListEscuela(conElias, (String) session.getAttribute("escuela"), " ORDER BY NIVEL_ID");
	
	/* Map de maestros por nivel*/
	java.util.HashMap<String,String> mapNivel = aca.ciclo.CicloGrupoCursoLista.mapMaestrosPorNivel(conElias);
%>

<div id="content">
	<h3>Maestros
	&nbsp; <span class="badge badge-info"> Activos: <%=totMaestros%></span>
	&nbsp; <span class="badge badge-info"> Hombres: <%=totHombres%></span>
	&nbsp; <span class="badge badge-info"> Mujeres: <%=totMujeres%></span>
	</h3>
	<hr>
	<h4>Participación en cada nivel</h4>
	<table class="table table-bordered table-striped">
	<tr>
		<th><h5>#</h5></th>
		<th><h5>Nivel</h5></th>		
		<th style="text-align:right"><h5>Total</h5></th>	
	</tr>
<%
	for( aca.catalogo.CatNivelEscuela nivel: lisNivel){
		row++;
		String totNivel = "0";
		if (mapNivel.containsKey(nivel.getNivelId())){
			totNivel = mapNivel.get(nivel.getNivelId()).toString();
		}
		out.print("<tr>");
		out.print("<td>"+row+"</td>");
		out.print("<td>"+nivel.getNivelNombre()+"</td>");
		out.print("<td style='text-align:right'>"+totNivel+"</td>");
		out.print("</tr>");
	}
	out.print("<tr><td colspan='3'>Nota: total es la cantidad de maestros que imparte al menos una clase en el nivel escolar.</td></tr>");
%>	
</div>
<script>
	jQuery('.maestros').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>