<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="BloqueActividad" scope="page" class="aca.ciclo.CicloBloqueActividad"/>
<jsp:useBean id="tipoactLista" scope="page" class="aca.catalogo.CatTipoactLista"/>
<jsp:useBean id="ActEtiquetalista" scope="page" class="aca.catalogo.CatActividadEtiquetaLista"/>
<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela"/>

<script>	
	function Grabar(){
		if(document.forma.BloqueId.value!="" && document.forma.ActividadId.value!="" && document.forma.ActividadNombre.value!="" && document.forma.Fecha.value!="" && document.forma.Valor.value!=""){			
			document.forma.Accion.value="2";
			document.forma.submit();			
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
	
	function Modificar(){
		document.forma.Accion.value="3";
		document.forma.submit();
	}
	
	function Consultar(){
		document.forma.Accion.value="5";
		document.forma.submit();		
	}
</script>

<%
	java.text.DecimalFormat getformato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

	// Declaracion de variables	
	String cicloId 		= session.getAttribute("cicloId").toString();
	String bloqueId 	= request.getParameter("BloqueId");
	String escuelaId	= session.getAttribute("escuela").toString();
	String salto		= "X";
	
	ArrayList<aca.catalogo.CatTipoact> lisTipoact = tipoactLista.getListUnion(conElias, aca.catalogo.CatEscuela.getUnionId(conElias, escuelaId),"ORDER BY TIPOACT_NOMBRE ASC");
	ArrayList<aca.catalogo.CatActividadEtiqueta> etiquetas = ActEtiquetalista.getListAll(conElias, aca.catalogo.CatEscuela.getUnionId(conElias, (String)session.getAttribute("escuela")) , " ORDER BY ORDEN");	
	
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
		
	BloqueActividad.setCicloId(cicloId);
	if ( !accion.equals("1") ){
		BloqueActividad.setBloqueId(request.getParameter("BloqueId"));
		BloqueActividad.setActividadId(request.getParameter("ActividadId"));
	}
			
	// Operaciones a realizar en la pantalla
	String strResultado	= "";
	if( accion.equals("1") ){ // Nuevo
		BloqueActividad.setActividadId(BloqueActividad.maximoReg(conElias,cicloId,bloqueId));
		BloqueActividad.setFecha(aca.util.Fecha.getHoy());
	}		
	
	else if( accion.equals("2") ){ // Grabar
		BloqueActividad.setActividadNombre(request.getParameter("ActividadNombre"));
		BloqueActividad.setFecha(request.getParameter("Fecha"));
		BloqueActividad.setValor(request.getParameter("Valor"));
		BloqueActividad.setTipoactId(request.getParameter("TipoactId"));
		BloqueActividad.setEtiquetaId(request.getParameter("EtiquetaId"));
											
		if (BloqueActividad.existeReg(conElias) == false){
			if (BloqueActividad.insertReg(conElias)){
				strResultado = "Grabado";
				salto = "actividad.jsp?bloqueId="+bloqueId;
			}else{
				strResultado = "NoGrabo";
				accion = "1";
			}
		}else{
			strResultado = "Existe";
			accion = "1";
		}
	}
	
	else if( accion.equals("3") ){ // Modificar
		BloqueActividad.setActividadNombre(request.getParameter("ActividadNombre"));
		BloqueActividad.setFecha(request.getParameter("Fecha"));
		BloqueActividad.setValor(request.getParameter("Valor"));
		BloqueActividad.setTipoactId(request.getParameter("TipoactId"));
		BloqueActividad.setEtiquetaId(request.getParameter("EtiquetaId"));
								
		if (BloqueActividad.existeReg(conElias) == true){
			if (BloqueActividad.updateReg(conElias)){
				strResultado = "Modificado";
				salto = "actividad.jsp?bloqueId="+bloqueId;
			}else{
				strResultado = "Nocambio";
				accion = "5";
			}
		}else{
			strResultado = "NoExiste";
			accion = "5";
		}
	}
	
	else if( accion.equals("4") ){ // Borrar
		if (BloqueActividad.existeReg(conElias) == true){
			if (BloqueActividad.deleteReg(conElias)){
				strResultado = "Eliminado";
				salto = "actividad.jsp?bloqueId="+bloqueId;
			}else{
				strResultado = "NoElimino";
			}	
		}else{
			strResultado = "NoExiste";
		}
	}
	
	else if( accion.equals("5") ){ // Consultar						
		if (BloqueActividad.existeReg(conElias) == true){
			BloqueActividad.mapeaRegId(conElias, cicloId, request.getParameter("BloqueId"), request.getParameter("ActividadId"));
		}	
	}
	
	pageContext.setAttribute("resultado", strResultado);
%>

<div id="content">

	<h2>
		<fmt:message key="aca.Actividad" />
		<small><%=cicloId%> | <%=aca.ciclo.Ciclo.nombreCiclo(conElias, cicloId)%> </small>
	</h2>
	
	<% if (strResultado.equals("Eliminado") || strResultado.equals("Modificado") || strResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!strResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
  	
	<div class="well">
		<a class="btn btn-primary" href="actividad.jsp?bloqueId=<%=bloqueId %>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="catalogo.Listado" /></a>
	</div>
	
	<form action="accionActividad.jsp" method="post" name="forma" target="_self">
		<input type="hidden" name="Accion">
       	<input name="BloqueId" type="hidden" id="BloqueId" maxlength="3" value="<%=bloqueId%>" class="onlyNumbers input-mini">
       	<input name="ActividadId" type="hidden" id="ActividadId" maxlength="3" value="<%=BloqueActividad.getActividadId()%>" class="onlyNumbers input-mini">
 	   
 	   	<fieldset>
	    	<label for="ActividadNombre"><fmt:message key="aca.Nombre" /></label>
	        <input name="ActividadNombre" type="text" id="ActividadNombre" size="40" maxlength="40" value="<%=BloqueActividad.getActividadNombre() %>">  
 	   	</fieldset>
 	   
 	   	<fieldset>
	    	<label for="Fecha"><fmt:message key="aca.Fecha" /></label>
	       <input name="Fecha" type="text" id="Fecha" maxlength="10" value="<%=BloqueActividad.getFecha()%>" class="input-medium"> 
 	   	</fieldset>
		
		<fieldset>
			<label for="Valor"><fmt:message key="aca.Valor" /></label>
			
			<div class="input-append">
				<input name="Valor" type="text" id="Valor" maxlength="6" value="<%=BloqueActividad.getValor().equals("")? "0":BloqueActividad.getValor() %>" class="onlyNumbers input-mini" data-max-num="100">
				<span class="add-on">%</span>
			</div>
		</fieldset>
		
		<fieldset>
			<label for="TipoactId"><fmt:message key="aca.Tipo" /></label>
			<select name="TipoactId" id="TipoactId">
			<%for(aca.catalogo.CatTipoact tipoact : lisTipoact){ %>
			  	<option value="<%=tipoact.getTipoactId() %>" <%if ( tipoact.getTipoactId().equals(BloqueActividad.getTipoactId()) ) out.println("selected"); %> ><%=tipoact.getTipoactNombre() %></option>
			 <%}%>
			 </select>		
		</fieldset>
		
		<%if(etiquetas.size()>0){ %>
			<fieldset>
				<label for="EtiquetaId"><fmt:message key="aca.Etiqueta" /></label>
				<select name="EtiquetaId" id="EtiquetaId">
					<%for(aca.catalogo.CatActividadEtiqueta et : etiquetas){ %>
						<option value="<%=et.getEtiquetaId() %>"><%=et.getEtiquetaNombre() %></option>
					<%} %>
				</select>
			</fieldset>
		<%} %>
		
	</form>
	
   	<div class="well">
   		<%if(accion .equals( "1" )){ %>
   			<a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a>
   		<%} %>
   		<%if(accion .equals( "5" )){ %>
			<a class="btn btn-primary btn-large" href="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
		<%} %> 
   	</div>
	
</div>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#Fecha').datepicker();
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>