<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Promedio" scope="page" class="aca.ciclo.CicloPromedio"/>

<script>
	
	function Grabar(){
		if(document.frmPromedio.corto.value !=""
		&& document.frmPromedio.corto.value !=""
		&& document.frmPromedio.calculo.value !=""
		&& document.frmPromedio.orden.value !=""
		&& document.frmPromedio.corto.value !=""
		&& document.frmPromedio.decimales.value !=""
		&& document.frmPromedio.valor.value !=""){
			document.frmPromedio.Accion.value="2";
			document.frmPromedio.submit();
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}
	
	function Modificar(){
		document.frmcarga.Accion.value="3";
		document.frmcarga.submit();
	}
	
	function Consultar(){
		document.frmcarga.Accion.value="5";
		document.frmcarga.submit();		
	}
	
</script>

<%
	// Declaracion de variables
	
	String cicloId		= request.getParameter("cicloId")==null?"":request.getParameter("cicloId");
	String promedioId	= request.getParameter("promedioId")==null?"":request.getParameter("promedioId");
	String accion		= request.getParameter("Accion")==null?"":request.getParameter("Accion");
	String sResultado	= "";
	
	
	if ( !accion.equals("1") ){
		Promedio.setCicloId(request.getParameter("CicloId"));
	}
	if ( accion.equals("1") ){
		Promedio.setPromedioId(Promedio.maximoReg(conElias, cicloId));
	}
	
	
	if( accion.equals("2") ){ // Grabar
		Promedio.setCicloId(cicloId);
		Promedio.setCalculo(request.getParameter("calculo"));
		Promedio.setCorto(request.getParameter("corto"));
		Promedio.setDecimales(request.getParameter("decimales"));
		Promedio.setNombre(request.getParameter("nombre"));
		Promedio.setOrden(request.getParameter("orden"));
		Promedio.setPromedioId(request.getParameter("promedioId"));
		Promedio.setValor(request.getParameter("valor"));

		if (Promedio.existeReg(conElias) == false){
			if (Promedio.insertReg(conElias)){
				sResultado = "Grabado";
				response.sendRedirect("promedio.jsp?cicloId="+cicloId);
			}else{
				sResultado = "NoGrabó";
				accion = "1";
			}
		}else{
			sResultado = "Existe";
			accion = "1";
		}
		
	}
	
	else if( accion.equals("3") ){ // Modificar
		Promedio.setCicloId(cicloId);
		Promedio.setCalculo(request.getParameter("calculo"));
		Promedio.setCorto(request.getParameter("corto"));
		Promedio.setDecimales(request.getParameter("decimales"));
		Promedio.setNombre(request.getParameter("nombre"));
		Promedio.setOrden(request.getParameter("orden"));
		Promedio.setPromedioId(request.getParameter("promedioId"));
		Promedio.setValor(request.getParameter("valor"));
		if (Promedio.existeReg(conElias) == true){
			if (Promedio.updateReg(conElias)){
				sResultado = "Modificado";
				response.sendRedirect("promedio.jsp?cicloId="+cicloId);
			}else{
				sResultado = "Nocambio";
				accion = "5";
			}
		}else{
			sResultado = "NoExiste";
			accion = "5";
		}
	}
	
	else if( accion.equals("4") ){ // Borrar
		Promedio.setCicloId(cicloId);
		Promedio.setPromedioId(request.getParameter("promedioId"));
		if (Promedio.existeReg(conElias) == true){
			if (Promedio.deleteReg(conElias)){
				sResultado = "Eliminado";
				conElias.commit();
				response.sendRedirect("promedio.jsp?cicloId="+cicloId);
			}else{
				sResultado = "NoElimino";
				accion = "5";
			}	
		}else{
			sResultado = "NoExiste";
			accion = "5";
		}
	}
	
	else if( accion.equals("5") ){ // Consultar			
		if (Promedio.existeReg(conElias) == true){
			Promedio.mapeaRegId(conElias, cicloId, promedioId);
		}else{
			sResultado = "NoExiste";
		}		
	}	
	
	pageContext.setAttribute("resultado", sResultado);
	
%>

<div id="content">
	
	<h2><fmt:message key="catalago.CatalogoCargas" /></h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<div class="well">
		<a class="btn btn-primary" href="promedio.jsp?cicloId=<%=cicloId%>"><i class="icon-arrow-left icon-white" ></i> <fmt:message key="boton.Regresar" /></a>
	</div>
	
	<form action="accionPromedio.jsp" method="post" name="frmPromedio" target="_self">
		<input type="hidden" name="Accion">
		<input type="hidden" name="cicloId" value="<%=cicloId%>">
		<fieldset>
			<label for="promedioId"><fmt:message key="aca.PromedioId" /></label>
			<input name="promedioId" type="text" id="promedioId" value="<%=Promedio.getPromedioId()%>" readonly>
		</fieldset>
		<fieldset>
			<label for="nombre"><fmt:message key="aca.Nombre" /></label>
			<input name="nombre" type="text" id="nombre" value="<%=Promedio.getNombre()%>">
		</fieldset>
		<fieldset>
			<label for="corto"><fmt:message key="aca.NombreCorto" /></label>
			<input name="corto" type="text" id="corto" value="<%=Promedio.getCorto()%>">
		</fieldset>
		<fieldset>
			<label for="calculo"><fmt:message key="aca.Calculo" /></label>
			<select name="calculo" class="input-medium">
           		<option value='V' <%if(Promedio.getDecimales().equals("V")){out.print("selected");}%>>Valores</option>
           		<!--  <option value='P' <%if(Promedio.getDecimales().equals("P")){out.print("selected");}%>>Promedio</option>-->
          	</select>
		</fieldset>
		<fieldset>
			<label for="orden"><fmt:message key="aca.Orden" /></label>
			<input name="orden" type="text" id="orden" value="<%=Promedio.getOrden()%>">
		</fieldset>
		<fieldset>
			<label for="decimales"><fmt:message key="aca.Decimal" /></label>
			<select name="decimales" class="input-medium">
           		<option value='0' <%if(Promedio.getDecimales().equals("0")){out.print("selected");}%>>0</option>
           		<option value='1' <%if(Promedio.getDecimales().equals("1")){out.print("selected");}%>>1</option>
           		<!--  <option value='1' <%if(Promedio.getDecimales().equals("2")){out.print("selected");}%>>2</option>-->
          	</select>
		</fieldset>
		<fieldset>
			<label for="valor"><fmt:message key="aca.Valor" /></label>
			<input name="valor" type="text" id="valor" value="<%=Promedio.getValor()%>">
		</fieldset>
	</form>
	                  
	<%if( accion.equals("1") ){%>				
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></button>
		</div>
	<%}%>
	
	<%if( accion.equals("5") ){%>
		<div class="well">
			<button class="btn btn-primary btn-large" onclick="javascript:Modificar()"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></button>
		</div>
     <%}%>
</div>

<%@ include file= "../../cierra_elias.jsp" %>