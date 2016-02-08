<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cicloL" scope="page" class="aca.ciclo.CicloLista"/>

<script>	
	function Borrar( CicloId ){
		if(confirm("<fmt:message key="js.Confirma" />")){
	  		document.location="accion.jsp?Accion=4&CicloId="+CicloId;
	  	}
	}	
</script>

<%
	String escuelaId		= (String) session.getAttribute("escuela");
	
	// Lista de periodos o ciclos escolares
	ArrayList<String>  lisPeriodos			= cicloL.getListCicloEscolar(conElias, escuelaId, "'A'", "ORDER BY 1 DESC");
	
	// Lista de ciclos
	ArrayList<aca.ciclo.Ciclo>  lisCiclo	= cicloL.getListAll(conElias, escuelaId, " ORDER BY CICLO_ID");
	
	String periodoId		= request.getParameter("Periodo")==null?"0":request.getParameter("Periodo");
	
	// Elegir el primero por default 
	if (periodoId.equals("0") && lisPeriodos.size()>0) periodoId = lisPeriodos.get(0);
%>

<div id="content">
	
	<h2><fmt:message key="periodos.ListaCicloAcademico" /></h2>
	<form name="frmCiclo" action="ciclo.jsp">
	<div class="well">
		<a class="btn btn-primary" href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>

		<select id="Periodo" name="Periodo" onchange="document.frmCiclo.submit();" style="width:360px;margin-bottom:0px;">
			<%for ( String periodo : lisPeriodos ) {%>
				<option value="<%=periodo%>" <%=periodoId.equals(periodo)?"Selected":""%>><%=periodo%></option>
			<%}%>
		</select>
	</div>
	</form>
	<table class="table table-condensed table-striped table-bordered">
		<thead>
			<tr>
		  		<th><fmt:message key="aca.Accion" /></th>
		  		<th>#</th>
		  		<th><fmt:message key="aca.Ciclo" /></th>
		  		<th><fmt:message key="aca.Nombre" /></th>
		    	<th><fmt:message key="aca.Creada" /></th>
		    	<th><fmt:message key="aca.Inicio" /></th>
		    	<th><fmt:message key="aca.Fin" /></th>
				<th><fmt:message key="aca.Estado" /></th>
				<th><fmt:message key="aca.Escala" /></th>
				<th><fmt:message key="aca.NumEval" /></th>
				<th><fmt:message key="aca.CicloEscuela" /></th>
				<th><fmt:message key="aca.Decimal" /></th>
			</tr>
		</thead>
		
<%		int cont = 0; %>
<%		for (aca.ciclo.Ciclo ciclo : lisCiclo){
			
%>
			<%cont++; %>				
	  		<tr>
	  			<td>
		  			<a class="icon-pencil" href="accion.jsp?Accion=5&CicloId=<%=ciclo.getCicloId()%>"></a>
		  			<%if( aca.ciclo.CicloPermiso.existeCiclo(conElias, ciclo.getCicloId()) == false && aca.ciclo.CicloPromedio.existeEvaluaciones(conElias, ciclo.getCicloId()) == false ){%>
		  				<a class="icon-remove" href="javascript:Borrar('<%=ciclo.getCicloId()%>')"></a>
		  			<%}%>
				</td>
	    		<td><%=cont %></td>
	    		<td><%=ciclo.getCicloId() %></td>
	    		<td>
					<a href="promedio.jsp?Accion=1&cicloId=<%=ciclo.getCicloId()%>">
		  				<%=ciclo.getCicloNombre() %>
		  			</a>
				</td>
				<td><%=ciclo.getFCreada() %></td>
				<td><%=ciclo.getFInicial() %></td>
				<td><%=ciclo.getFFinal() %></td>
				<td>
					<%if (ciclo.getEstado().equals("A")){%>
						<fmt:message key="aca.Activa" />
					<%}else{%> 
						<fmt:message key="aca.Cerrada" />
					<%}%>
				</td>
				<td><%=ciclo.getEscala()%></td>
				<td><%=ciclo.getModulos()%></td>
				<td><%=ciclo.getCicloEscolar()%></td>
				<td><%=ciclo.getDecimales()%></td>
	  		</tr>  
		<%
		}%>  
	</table>
	
	
</div>

<%@ include file= "../../cierra_elias.jsp" %>