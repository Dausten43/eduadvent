<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="CatEscuelaL" scope="page" class="aca.catalogo.CatEscuelaLista"/>
<jsp:useBean id="CatUnionL" scope="page" class="aca.catalogo.CatUnionLista"/>
<jsp:useBean id="CatAsociacionL" scope="page" class="aca.catalogo.CatAsociacionLista"/>

<%
	java.text.DecimalFormat getFormato	= new java.text.DecimalFormat("###,##0.00;(###,##0.00)", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String codigoId 		= (String)session.getAttribute("codigoId");
	String nivelId			= request.getParameter("Nivel")==null?"0":request.getParameter("Nivel");
	int row 	= 0;	
	
	/* Lista de escuelas en el nivel */
	ArrayList<aca.catalogo.CatEscuela> lisEscuelas = CatEscuelaL.getListNivel(conElias, nivelId, "ORDER BY UNION_ID, ASOCIACION_ID, ESCUELA_NOMBRE");
	
	/* HashMap de las uniones*/
	java.util.HashMap<String,aca.catalogo.CatUnion> mapUnion			= CatUnionL.getMapAll(conElias, "");
	
	/* HashMap de las asociaciones*/
	java.util.HashMap<String,aca.catalogo.CatAsociacion> mapAsociacion	= CatAsociacionL.getMapAll(conElias, "");	
%>

<div id="content">
	<h3>Escuelas por nivel 
	  <a class="btn btn-info" href="escuelas.jsp"><i class="icon-white icon-arrow-left"></i></a> &nbsp; 
	  <small><%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivelId)%></small>
	</h3>	
	<table class="table table-bordered table-striped">
		<tr>
			<th>#</th>
			<th>Unión</th>
			<th>Asociación</th>
			<th>Clave</th>
			<th>Escuela</th>
			<th>OrgId</th>
			<th>Teléfono</th>
			<th>Fax</th>
		</tr>	
<%
	for( aca.catalogo.CatEscuela escuela: lisEscuelas){
		row++;
		
		// Buscar el nombre de la unión
		String union = "-";
		if ( mapUnion.containsKey(escuela.getUnionId()) ) 
			union = mapUnion.get(escuela.getUnionId()).getUnionNombre();
		
		// Buscar el nombre de la unión
		String asociacion = "-";
		if ( mapAsociacion.containsKey(escuela.getAsociacionId()) ) 
			asociacion = mapAsociacion.get(escuela.getAsociacionId()).getAsociacionNombre();
				
%>
		<tr>
			<td><%= row %></td>
			<td><%=union%></td>
			<td><%=asociacion%></td>
			<td><%=escuela.getEscuelaId()%></td>
			<td><%=escuela.getEscuelaNombre()%></td>
			<td><%=escuela.getOrgId()%></td>
			<td><%=escuela.getTelefono() %></td>
			<td><%=escuela.getFax()%></td>
		</tr>
<%	}%>	
	</table>
	<br>
</div>
<script>
	jQuery('.escuelas').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp" %>