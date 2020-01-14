<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Bloque" scope="page" class="aca.ciclo.CicloBloque"/>
<jsp:useBean id="BloqueLista" scope="page" class="aca.ciclo.CicloBloqueLista"/>

<script>
	function Borrar( BloqueId ){
		if(confirm("<fmt:message key="js.Confirma" />")){
	  		document.location="accionBloque.jsp?Accion=4&BloqueId="+BloqueId;
	  	}
	}
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	String cicloId 			= session.getAttribute("cicloId").toString();
	String promedioId		= request.getParameter("promedioId") == null?"vacio":request.getParameter("promedioId");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	if (accion.equals("1")&& !promedioId.equals("vacio")){ 
		session.setAttribute("promedioId", promedioId);
	}else{
		promedioId = session.getAttribute("promedioId").toString();
	}
	
	ArrayList<aca.ciclo.CicloBloque> lisBloque 			= BloqueLista.getBloquePromedioCiclo(conElias, promedioId, cicloId, " ORDER BY ORDEN, BLOQUE_ID");
	java.util.HashMap<String, String> mapAlumnos 		= aca.kardex.KrdxAlumEvalLista.mapAlumnosEvaluadosCiclo(conElias, cicloId);
	java.util.HashMap<String, String> mapActividades 	= aca.ciclo.CicloGrupoActividadLista.getMapActividadesCiclo(conElias, cicloId);
	
	// Cuenta el numero de materias para saber si se puede borrar el ciclo o no.
	int numMaterias				= aca.ciclo.CicloGrupoCurso.numMatCiclo(conElias,cicloId);
	int numModulos 				= aca.ciclo.Ciclo.getModulos(conElias, cicloId); 
%>

<div id="content">
	
	<h2>
		<fmt:message key="aca.Evaluaciones" />&nbsp;
		<small>( <%=cicloId%> | <%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> )</small>
	</h2>
	
	<div class="well">
		<a class="btn btn-primary" href="promedio.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<% /* if (Integer.parseInt(Bloque.maximoReg(conElias, cicloId)) <= numModulos){ */%>
	    <a href="accionBloque.jsp?Accion=1" class="btn btn-primary"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
		<%/*}*/%>      
	</div>

	<table class="table table-condensed table-bordered table-stripped">
		<thead>
			<tr>
	  			<th width="3%"><fmt:message key="aca.Accion" /></th>
	  			<th width="5%"><fmt:message key="aca.Id" /></th>
	  			<th width="30%"><fmt:message key="aca.Nombre" /></th>  
	  			<th width="10%"><fmt:message key="aca.Corto" /></th> 
	  			<th width="13%"><fmt:message key="aca.Inicio" /></th>
	  			<th width="12%"><fmt:message key="aca.Fin" /></th> 
	  			<th width="12%"><fmt:message key="aca.Valor" /></th> 
	  			<th width="10%"><fmt:message key="aca.Decimales" /></th>
	  			<th width="12%"><fmt:message key="aca.Redondeo" /></th>
	  			<th width="12%"><fmt:message key="aca.Orden" /></th> 
	  			<th width="12%"><fmt:message key="aca.Calculo" /></th> 
			</tr>
		</thead>
		<%
			float total = 0;
		%>
		<%for (aca.ciclo.CicloBloque bloque : lisBloque){%>				
			<tr>
  				<td>  
					<% if(!mapAlumnos.containsKey(bloque.getBloqueId())){ %>
						<a class="icon-pencil" href="accionBloque.jsp?Accion=5&BloqueId=<%=bloque.getBloqueId()%>"></a>
					<%} %>
					
					<%if (  !mapAlumnos.containsKey(bloque.getBloqueId()) && 
							!mapActividades.containsKey(bloque.getBloqueId()) &&
							Bloque.getUltimoBloque(conElias, cicloId).equals( bloque.getBloqueId() )  &&
							aca.ciclo.CicloBloqueActividad.existeActividades(conElias, bloque.getCicloId(), bloque.getBloqueId()) == false ){ // Verifica que no existan materias para poder borrar el ciclo. %> 	
						<a class="icon-remove" href="javascript:Borrar('<%=bloque.getBloqueId()%>')"></a>
					<%}%>	
  				</td>    
  				<td><%=bloque.getBloqueId()%></td>
  				<td>
  					<a href="actividad.jsp?bloqueId=<%=bloque.getBloqueId() %>&cicloId=<%=bloque.getCicloId()%>&promedioId=<%=promedioId%>">
  						<%=bloque.getBloqueNombre()%>
  					</a>
  				</td>
  				<td><%=bloque.getCorto()%></td>
  				<td><%=bloque.getFInicio()%></td>
  				<td><%=bloque.getFFinal()%></td>
  				<td><%=bloque.getValor()%>%</td>
  				<td><%=bloque.getDecimales()%></td>
  				<td><%=bloque.getRedondeo()%></td>
  				<td><%=bloque.getOrden()%></td>
  				<td><% 
  					if(bloque.getCalculo().equals("V")){ 
	  				%>
	  				Valor
	  				<%			
  					}else{
  					%>
  					Promedio
  		  			<%		
  					}
  				%></td>
			</tr>  
			<%
				total += Float.parseFloat(bloque.getValor());
			%>
		<%}%>
		<tr>
			<th colspan="6"><fmt:message key="aca.TotalPorcentaje" /></th>
			<th><%=getformato.format( total ) %>%</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
	</table>
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>