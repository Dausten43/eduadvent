<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="BloqueActividadLista" scope="page" class="aca.ciclo.CicloBloqueActividadLista"/>

<script>
	function Borrar( BloqueId, ActividadId ){
		if(confirm("<fmt:message key="js.Confirma" />")){
	  		document.location="accionActividad.jsp?Accion=4&BloqueId="+BloqueId+"&ActividadId="+ActividadId;
	  	}
	}
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String cicloId 			= session.getAttribute("cicloId").toString();
	String bloqueId 		= request.getParameter("bloqueId")==null?"0":request.getParameter("bloqueId");	
	
	ArrayList<aca.ciclo.CicloBloqueActividad> lisAct = BloqueActividadLista.getListBloque(conElias, cicloId, bloqueId, "ORDER BY ACTIVIDAD_ID");	
%>

<div id="content">
	
	<h2>
		<fmt:message key="aca.Actividades" />
		<small>( <%=cicloId%> | <%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> )</small>
	</h2>
	
	<div class="well">
		<a class="btn btn-primary" href="bloque.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a href="accionActividad.jsp?Accion=1&BloqueId=<%=bloqueId%>" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
	</div>

	<table class="table table-condensed table-bordered table-stripped">
		<thead>
			<tr>
	  			<th width="3%"><fmt:message key="aca.Accion" /></th>
	  			<th width="5%"><fmt:message key="aca.Bloque" /></th>
	  			<th width="39%"><fmt:message key="aca.Nombre" /></th>  
	  			<th width="12%"><fmt:message key="aca.Fecha" /></th> 
	  			<th width="12%"><fmt:message key="aca.Valor" /></th> 
	  			<th width="12%"><fmt:message key="aca.Tipo" /></th> 
	  			<th width="12%"><fmt:message key="aca.Etiqueta" /></th>
			</tr>
		</thead>
		<%
			float total = 0;
		%>
		<%
			for (aca.ciclo.CicloBloqueActividad act : lisAct){
				boolean tieneNotas 		= aca.ciclo.CicloGrupoActividad.tieneNotas(conElias, cicloId, act.getBloqueId(), act.getActividadId());
		%>				
			<tr>
  				<td>  
					<a class="icon-pencil" href="accionActividad.jsp?Accion=5&BloqueId=<%=bloqueId%>&ActividadId=<%=act.getActividadId() %>"></a>
					<%if (!tieneNotas){ // Verifica que no existan materias para poder borrar el ciclo. %>
						<a class="icon-remove" href="javascript:Borrar('<%=act.getBloqueId()%>','<%=act.getActividadId() %>')"></a>
					<%}%>
  				</td>    
  				<td><%=act.getActividadId() %></td>
  				<td><%=act.getActividadNombre() %></td>
  				<td><%=act.getFecha() %></td>	
  				<td><%=act.getValor() %>%</td>
  				<td><%=aca.catalogo.CatTipoact.getTipoactNombre(conElias, act.getTipoactId()) %></td>
  				<td><%=aca.catalogo.CatActividadEtiqueta.getNombreEtiqueta(conElias, aca.catalogo.CatEscuela.getUnionId(conElias, (String)session.getAttribute("escuela")), act.getEtiquetaId())  %></td>
			</tr>  
			<%
				total += Float.parseFloat(act.getValor());
			%>
		<%}%>
		<tr>
			<th colspan="5"><fmt:message key="aca.TotalPorcentaje" /></th>
			<th><%=getformato.format( total ) %>%</th>
			<th>&nbsp;</th>
		</tr>
	</table>
</div>

<%@ include file= "../../cierra_elias.jsp" %>