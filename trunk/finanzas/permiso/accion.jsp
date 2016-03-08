<%@page import="com.itextpdf.text.Document"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Permiso" scope="page" class="aca.fin.FinPermiso"/>


<%
	// Declaracion de variables
	String numAccion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");	
	String resultado		= "";
	String codigoId			= request.getParameter("codigoId")==null?"":request.getParameter("codigoId");
	String folio			= request.getParameter("folio")==null?Permiso.maxReg(conElias):request.getParameter("folio");
	String hoy 				= aca.util.Fecha.getHoy();
	Boolean nuevo			= true;
	
	Permiso.setCodigoId(codigoId);
	Permiso.setFolio(folio);
	Permiso.mapeaRegId(conElias);
	
	
	if(numAccion.equals("1")){
		Permiso.setFecha_ini(request.getParameter("FechaIni"));
		Permiso.setFecha_fin(request.getParameter("FechaFin"));
		Permiso.setEstado(request.getParameter("Estado"));
		Permiso.setComentario(request.getParameter("Comentario"));
		
		if(!Permiso.existeReg(conElias)){
			Permiso.insertReg(conElias);
			resultado = "Guardado";
		}else if(Permiso.existeReg(conElias)){
				Permiso.updateReg(conElias);
				resultado = "Modificado";
			}
	}

	
	pageContext.setAttribute("resultado", resultado);
	
%>

<div id="content">
	<h2><fmt:message key="boton.Anadir" /></h2>
	
	<% if (resultado.equals("Eliminado") || resultado.equals("Modificado") || resultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!resultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>

 	<div class="well">
 		<a class="btn btn-primary"href="permiso.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
 	</div>  

	<form action="accion.jsp" method="post" name="frmPermiso" target="_self">
		<input type="hidden" name="Accion" value="1">
		
		
		<fieldset>
	    	<label for="Folio"><fmt:message key="aca.Folio" /></label>
	    	<input class="input-large" name="folio" type="text" id="folio" value="<%=folio%>" maxlength="10" readonly>
	    </fieldset>	   
	    
		<fieldset>
	    	<label for="CodigoId"><fmt:message key="aca.Codigo" /></label>
	    	<input class="input-large" name="codigoId" type="text" id="codigoId" value="<%=Permiso.getCodigoId()%>" <%if(numAccion.equals("3")){out.print("Readonly");} %> maxlength="8">
	    </fieldset>
	    
	    <fieldset>
	    	<label for="Fecha-ini"><fmt:message key="aca.FechaInicio" /></label>
	    	<input class="datepicker" name="FechaIni" type="text" id="FechaIni" value="<%=Permiso.getFecha_ini()%>">
	   </fieldset>
	    
	   <fieldset>
	    	<label for="Fecha-fin"><fmt:message key="aca.FechaFinal" /></label>
	        <input class="datepicker" name="FechaFin" type="text" id="FechaFin" value="<%=Permiso.getFecha_fin()%>" >
	   	</fieldset>
	   
		<fieldset>
	    	<label for="Estado"><fmt:message key="aca.Estado" /></label>
	        <input class="input-large" name="Estado" type="text" id="Estado" value="<%=Permiso.getEstado()%>" maxlength="1">
	   </fieldset>
	   
	   <fieldset>
	    	<label for=">Comentario">
				<fmt:message key="aca.Comentario" />
	        </label>
	        <textarea class="input-large" name="Comentario" type="text" id="Comentario"  size="200" maxlength="200"><%=Permiso.getComentario()%></textarea>
		</fieldset>
	
		<div class="well">
			<button type="submit" class="btn btn-primary btn-large" ><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></button>
		</div>	     
	</form>
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
$('.datepicker').datepicker();

</script>
<%@ include file= "../../cierra_elias.jsp" %>