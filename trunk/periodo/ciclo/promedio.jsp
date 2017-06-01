<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="promedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>

<script>
	function Borrar( promedioId ){
		if(confirm("<fmt:message key="js.Confirma" />")){
	  		document.location="accionPromedio.jsp?Accion=4&promedioId="+promedioId;
	  	}
	}	
</script>

<%
	String escuelaId		= session.getAttribute("escuela").toString();
	String cicloId			= request.getParameter("cicloId")==null?"vacio":request.getParameter("cicloId");
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	
	// Subir cicloId a la sesion
	if (accion.equals("1") && !cicloId.equals("vacio")){
		session.setAttribute("cicloId", cicloId);
	}else{
		cicloId = session.getAttribute("cicloId").toString();
	}
	
	ArrayList<aca.ciclo.CicloPromedio>  cicloPromediol	= promedioL.getListCiclo(conElias, cicloId, " ORDER BY ORDEN");
%>

<div id="content">
	
	<h2><fmt:message key="aca.Promedios" />&nbsp;<small>( <%=cicloId%> | <%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> )</small></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="ciclo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a class="btn btn-primary" href="accionPromedio.jsp?Accion=1"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
	</div>
	
	<table class="table table-condensed table-striped table-bordered">
		<thead>
			<tr>
		  		<th><fmt:message key="aca.Accion" /></th>
		  		<th>#</th>
		  		<th><fmt:message key="aca.Ciclo" /></th>
		  		<th><fmt:message key="aca.Clave" /></th>
		  		<th><fmt:message key="aca.Nombre" /></th>
		    	<th><fmt:message key="aca.NombreCorto" /></th>
		    	<th><fmt:message key="aca.Calculo" /></th>
		    	<th><fmt:message key="aca.Orden" /></th>
				<th><fmt:message key="aca.Valor" /></th>
				<th><fmt:message key="aca.Decimal" /></th>
				<th><fmt:message key="aca.Redondeo" /></th>
			</tr>
		</thead>
		<%int cont = 0; %>
		<%for (aca.ciclo.CicloPromedio promedio : cicloPromediol){%>
			<%cont++; %>				
	  		<tr>
	  			<td>
		  			<a class="icon-pencil" href="accionPromedio.jsp?Accion=5&promedioId=<%=promedio.getPromedioId()%>"></a>
		  			<%if(aca.ciclo.CicloBloque.existeEvaluaciones(conElias, promedio.getCicloId(), promedio.getPromedioId()) == false ){%>
		  				<a class="icon-remove" href="javascript:Borrar('<%=promedio.getPromedioId()%>')"></a>
		  			<%}%>
				</td>
	    		<td><%=cont %></td>
	    		<td><%=promedio.getCicloId() %></td>
	    		<td><%=promedio.getPromedioId() %></td>
	    		<td>
					<a href="bloque.jsp?Accion=1&promedioId=<%=promedio.getPromedioId()%>">
		  				<%=promedio.getNombre()%>
		  			</a>
				</td>
				<td><%=promedio.getCorto() %></td>
				<td><%=promedio.getCalculo() %></td>
				<td><%=promedio.getOrden() %></td>
				<td><%=promedio.getValor()%></td>
				<td><%=promedio.getDecimales()%></td>
				<%if(promedio.getRedondeo().equals("A")){%>
				<td>Arriba</td>
				<%}else {%>
				<td>Truncado</td>
				<%}%>
	  		</tr>  
		<%}%>  
	</table>
	

</div>

<%@ include file= "../../cierra_elias.jsp" %>