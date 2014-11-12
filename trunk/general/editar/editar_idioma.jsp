<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>


<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>

<script>
	function guardar(){
		document.forma.Accion.value = "1";
		document.forma.submit();
	}
</script>

<%
	String codigoId	= (String) session.getAttribute("codigoId");
	
	String accion 	= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String msj      = "";
	
	if(accion.equals("1")){
		
		usuario.setIdioma(request.getParameter("Lenguaje"));
		usuario.setCodigoId(codigoId);
		if(usuario.updateIdioma(conElias)){
			msj = "Guardado";
			session.setAttribute("lenguaje", usuario.getIdioma());	
		}else{
			msj = "NoGuardo";	
		}
		
	}
	
	pageContext.setAttribute("resultado", msj);
	
	usuario.mapeaRegId(conElias, codigoId);
%>

<div id="content">

	<h2><fmt:message key="aca.CambiaLenguaje" /></h2>
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<hr />

	<form id="forma" name="forma" method="post">
		<input type="hidden" name="Accion" />
	
		<fieldset>
			<label for="Lenguaje"><fmt:message key="aca.Lenguaje" /></label>
		    <select name="Lenguaje" id="Lenguaje">
		    	<option value="es" <%if(usuario.getIdioma().equals("es")){out.print("selected");} %>><fmt:message key="aca.Espanol" /></option>
		    	<option value="en" <%if(usuario.getIdioma().equals("en")){out.print("selected");} %>><fmt:message key="aca.Ingles" /></option>
		    </select>
		</fieldset>
	</form>
	
	<div class="well">
		<a class="btn btn-primary btn-large" href="javascript:guardar();" ><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		<a class="btn btn-large" href="../../general/inicio/index.jsp"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></a>	
	</div>

</div>

<%@ include file= "../../cierra_elias.jsp" %>