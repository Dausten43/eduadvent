<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.ciclo.Ciclo"%>
<%@page import="aca.ciclo.CicloPeriodo"%>

<jsp:useBean id="CatSeguro" scope="page" class="aca.catalogo.CatSeguro"/>

<%

	String tipoGuardado = "";
	
	String escuelaId 	= (String) session.getAttribute("escuela");
	String accion		= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String msj 			= "";
	String cicloId 		= request.getParameter("ciclo")==null?"":request.getParameter("ciclo");	
	String oportunidad 	= request.getParameter("oportunidad")==null?"0":request.getParameter("oportunidad");
	System.out.println(request.getParameter("Accion"));
%>
<script>
	function Grabar(){
		alert(<%=request.getParameter("year")%> +" "+document.forma.Year.value);
		document.forma.Accion.value="1";
		document.forma.submit();
	}
</script>
<%
	if(accion.equals("1")){
		CatSeguro.setEscuela(escuelaId);
		CatSeguro.setYear(request.getParameter("Year"));
		CatSeguro.setPoliza(request.getParameter("Poliza"));

			if(!CatSeguro.existeReg(conElias)){
				if(CatSeguro.insertReg(conElias)){
					msj = "Guardado";
				}else{
					msj = "NoGuardado";
				}
			}else{
				if(CatSeguro.updateReg(conElias)){
					msj = "Modificado";
				}else{
					msj = "NoModificado";
				}
			}
			
			
		}

		if(accion.equals("2")){
			CatSeguro.setEscuela(escuelaId);
			CatSeguro.setYear(request.getParameter("year"));
			CatSeguro.mapeaRegId(conElias);
		}
	
	pageContext.setAttribute("resultado", msj);
	
	
%>



<div id=content>

	<h2><fmt:message key="aca.Seguro" /></h2>
	
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary btn-mobile" href="poliza.jsp?ciclo=<%=cicloId %>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form name="forma" action="accion.jsp" method="post">
		<fieldset>
			<label for="ciclo"><fmt:message key="aca.Escuela" /></label>
			<input type="text" id="escuelaId" name="escuelaId" value="<%=escuelaId%>" size="8" maxlength="10" readonly>
		</fieldset>
		
		<fieldset>
			<label for="oportunidad"><fmt:message key="aca.Ano" /></label>
			<input type="text" id="Year" name="Year" value="<%if(accion.equals("2")){out.print(CatSeguro.getYear());}else{out.print(java.util.Calendar.getInstance().get(java.util.Calendar.YEAR));}%>" size="8" maxlength="10" <%if(accion.equals("2")){out.print("readonly ");}%>required >
		</fieldset>
				
		<fieldset>
				<label for="ValorAnterior"><fmt:message key="aca.Poliza"/></label>
	        	<input type="text" id="Poliza" name="Poliza" value="<%=CatSeguro.getPoliza() %>" size="8" maxlength="30" required/>
		</fieldset>
		<input type="hidden" name="Accion" id="Accion" value="1"/>
		<div class="well">
			<button type="submit" class="btn btn-primary btn-large" ><i class="icon-ok icon-white"></i> <fmt:message key='boton.Guardar' /></button>
		</div>
	</form>
		
</div>


<%@ include file= "../../cierra_elias.jsp" %>