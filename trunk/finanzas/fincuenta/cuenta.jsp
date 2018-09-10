<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="cuentaLista" scope="page" class="aca.fin.FinCuentaLista"/>
<% 
	String escuelaId 		= (String) session.getAttribute("escuela");
	
	ArrayList<aca.fin.FinCuenta> lisCuenta		= cuentaLista.getListCuentas(conElias,escuelaId, "ORDER BY CUENTA_ID, CUENTA_NOMBRE");
%>

<div id="content">
	<h2><fmt:message key="aca.Cuentas" /><small>( <%=escuelaId%> - <%= aca.catalogo.CatEscuela.getNombre(conElias, escuelaId) %> )</small></h2> 
   
   <div class="well">
      <a class="btn btn-primary" href="accion.jsp?Accion=1"><i class="icon-plus icon-white"></i> <fmt:message key="boton.Anadir" /></a>
   </div>
    
	<form id="forma" name="forma" action="accion.jsp" >
		<table class="table table-condensed table-bordered table-striped">
	  		<tr>
	    		<th><fmt:message key="aca.Accion" /></th>
	    		<th>#</th>
	    		<th><fmt:message key="aca.Nombre" /></th>
	    		<th><fmt:message key="aca.SunPlus" /></th>    
	    		<th><fmt:message key="aca.Beca" /></th>
	    		<th><fmt:message key="aca.Tipo" /></th>
	    		<th>% <fmt:message key="aca.PagoInicial" /></th>
	    		<th> <fmt:message key="aca.MuestraSaldoRecibo" /></th>
	    		<th> <fmt:message key="aca.CuentaAislada" /></th>
	  		</tr>
	  		<%
	  			int cont = 0;
				for (aca.fin.FinCuenta cuenta : lisCuenta){
					cont++;
			%>
	  				<tr> 
	    				<td>
	      					<a class="icon-pencil" href="accion.jsp?Accion=5&CuentaId=<%=cuenta.getCuentaId()%>&CuentaNombre=<%=cuenta.getCuentaNombre()%>"> </a>
	      					<%if(!aca.fin.FinCosto.existeSoloCuenta(conElias, cuenta.getCuentaId()) && !aca.fin.FinMovimientos.existeCuentaId(conElias, cuenta.getCuentaId())){%> 
	      						<a class="icon-remove" id="del" href="javascript:Elimina('<%=cuenta.getCuentaId() %>');" ></a>
	      					<%} %>
	    				</td>
	    				<td><%=cuenta.getCuentaId()%></td>
	    				<td><%=cuenta.getCuentaNombre() %></td>    
	    				<td><%=cuenta.getCuentaSunPlus() %></td>    
					    <td>
					    	<%if(cuenta.getBeca().equals("S")){ %>
					    		<fmt:message key="aca.Si" />
					    	<%}else{ %>
					    		<fmt:message key="aca.Negacion" />
					    	<%}%>
					    </td>
					    <td><%=cuenta.getTipo()%></td>
					    <td class="text-right"><%=cuenta.getPagoInicial()%> %</td>
					    <td> <%=cuenta.getMuestraSaldoRecibo()%> </td>
					    <td> <%=cuenta.getCuentaAislada() %> </td>
					</tr>
	  		<%
				}	
			%>
		</table>
	</form>
</div>

<script>   
	function Elimina(cuentaId ){
		if(confirm("<fmt:message key='js.Confirma' />")){
			document.location = "accion.jsp?Accion=4&CuentaId="+cuentaId;
		}
	}
</script>

<%@ include file= "../../cierra_elias.jsp" %>