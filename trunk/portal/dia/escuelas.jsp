<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="CatNivelEscuelaLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="CatNivelLista" scope="page" class="aca.catalogo.CatNivelEscuelaLista"/>
<jsp:useBean id="CatEscuela" scope="page" class="aca.catalogo.CatEscuela"/>
<jsp:useBean id="CatPaisLista" scope="page" class="aca.catalogo.CatPaisLista"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoId 		= (String)session.getAttribute("codigoId");
	int row 	= 0;
	int cont 	= 0;
	
	ArrayList<aca.catalogo.CatNivelEscuela> lisNivel = CatNivelLista.getListEscuela(conElias, (String) session.getAttribute("escuela"), "ORDER BY NIVEL_ID");
	
	/* HashMap que obtiene el numero de escuelas por nivel*/
	java.util.HashMap<String,String> mapNivel	= CatNivelEscuelaLista.mapaNiveles(conElias);
	
	ArrayList<aca.catalogo.CatPais> lisPais = CatPaisLista.getListAll(conElias, "ORDER BY PAIS_ID");
	
	/* HashMap que obtiene el numero de escuelas por pais*/
	java.util.HashMap<String,String> mapPais	= CatPaisLista.getMapPaisTotEsc(conElias);
%>

<div id="content">
	<h3>Escuelas Registradas &nbsp; <span class="badge badge-info"><%=CatEscuela.getTotalEscuelas(conElias)%></span></h3>
	<hr>
	<h4>Participación en cada nivel</span></h4>
	<table class="table table-bordered table-striped">
		<tr>
			<th>#</th>
			<th>Nivel</th>
			<th style="text-align:right">Total</th>
		</tr>	
<%
	for( aca.catalogo.CatNivelEscuela nivel: lisNivel){
		row++;
		
		// Buscar el numero de asociacione en la union
		String niveles = "0";
		if ( mapNivel.containsKey(nivel.getNivelId()) ) niveles = mapNivel.get(nivel.getNivelId());
%>
		<tr>
			<td><%= row %></td>
			<td><a href="escuelas_nivel.jsp?Nivel=<%=nivel.getNivelId()%>"><%= nivel.getNivelNombre()%></a></td>
			<td style="text-align:right"><%= niveles%></td>
		</tr>
<%	}%>	
	</table>
	<br>
</div>	
<div id="content">
	<h4>Distribución por pais</span></h4>
		
	<table class="table table-bordered table-striped">
		<tr>
			<th>#</th>
			<th>Pais</th>
			<th style="text-align:right">Total</th>
		</tr>	
<%
	for( aca.catalogo.CatPais pais: lisPais){
		// Buscar el numero de asociacione en la union
		String paises = "0";
		if ( mapPais.containsKey(pais.getPaisId()) ){
			paises = mapPais.get(pais.getPaisId());
			cont++;
%>	
		<tr>
			<td><%= cont %></td>
			<td><a href="paises.jsp?paisId=<%=pais.getPaisId()%>"> <%= pais.getPaisNombre()%></a></td>
			<td style="text-align:right"><%= paises%></td>
		</tr>
<%	
		}
	}
%>	
	</table>
</div>	
<script>
	jQuery('.escuelas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>