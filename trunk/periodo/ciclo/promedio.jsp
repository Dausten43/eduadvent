<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="promedioL" scope="page" class="aca.ciclo.CicloPromedioLista"/>

<script>
	function Borrar( promedioId, cicloId ){
		if(confirm("<fmt:message key="js.Confirma" />")){
	  		document.location="accionPromedio.jsp?Accion=4&promedioId="+promedioId+"&cicloId="+cicloId;
	  	}
	}	
</script>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String cicloId			= request.getParameter("cicloId")==null?"":request.getParameter("cicloId"); 
	
	ArrayList<aca.ciclo.CicloPromedio>  cicloPromediol	= promedioL.getListCiclo(conElias, cicloId, "");
%>

<div id="content">
	
	<h2><fmt:message key="periodos.ListaCicloAcademico" /></h2>
	
	<div class="well">
		<a class="btn btn-primary" href="ciclo.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a class="btn btn-primary" href="accionPromedio.jsp?Accion=1&cicloId=<%=cicloId%>"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
	</div>
	
	<table class="table table-condensed table-striped table-bordered">
		<thead>
			<tr>
		  		<th><fmt:message key="aca.Accion" /></th>
		  		<th>#</th>
		  		<th><fmt:message key="aca.Ciclo" /></th>
		  		<th><fmt:message key="aca.PromedioId" /></th>
		  		<th><fmt:message key="aca.Nombre" /></th>
		    	<th><fmt:message key="aca.NombreCorto" /></th>
		    	<th><fmt:message key="aca.Calculo" /></th>
		    	<th><fmt:message key="aca.Orden" /></th>
				<th><fmt:message key="aca.Decimal" /></th>
				<th><fmt:message key="aca.Valor" /></th>
			</tr>
		</thead>
		<%int cont = 0; %>
		<%for (aca.ciclo.CicloPromedio promedio : cicloPromediol){%>
			<%cont++; %>				
	  		<tr>
	  			<td>
		  			<a class="icon-pencil" href="accionPromedio.jsp?Accion=5&cicloId=<%=promedio.getCicloId()%>&promedioId=<%=promedio.getPromedioId()%>"></a>
		  			<%if(aca.ciclo.CicloBloque.existeEvaluaciones(conElias, promedio.getPromedioId()) == false ){%>
		  				<a class="icon-remove" href="javascript:Borrar('<%=promedio.getPromedioId()%>','<%=promedio.getCicloId() %>')"></a>
		  			<%}%>
				</td>
	    		<td><%=cont %></td>
	    		<td><%=promedio.getCicloId() %></td>
	    		<td><%=promedio.getPromedioId() %></td>
	    		<td>
					<a href="bloque.jsp?Accion=1&promedioId=<%=promedio.getPromedioId()%>&cicloId=<%=promedio.getCicloId()%>">
		  				<%=promedio.getNombre()%>
		  			</a>
				</td>
				<td><%=promedio.getCorto() %></td>
				<td><%=promedio.getCalculo() %></td>
				<td><%=promedio.getOrden() %></td>
				<td><%=promedio.getDecimales()%></td>
				<td><%=promedio.getValor()%></td>
	  		</tr>  
		<%}%>  
	</table>
	
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>