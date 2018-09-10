<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Cuenta" scope="page" class="aca.fin.FinCuenta"/>

<script>
	
	function Nuevo(){
		document.frmCuenta.CuentaId.value = " ";	
		document.frmCuenta.CuentaNombre.value = " ";
		document.frmCuenta.Beca.value= " ";
		document.frmCuenta.SunPlus.value= " ";
		document.frmCuenta.Accion.value="1";
		document.frmCuenta.Caja.value=" ";
		document.frmCuenta.Alumno.value=" ";
		document.frmCuenta.muestraSaldoRecibo.value="";
		document.frmCuenta.cuentaAislada.value="";
		document.frmCuenta.submit();
	}
	
	function Grabar(){
		if(document.frmCuenta.CuentaId.value	!="" 
			&& document.frmCuenta.CuentaNombre	!="" 
			&& document.frmCuenta.EscuelaId		!=""
			&& document.frmCuenta.Beca			!="" 
			&& document.frmCuenta.Caja			!="" 
			&& document.frmCuenta.Alumno		!="" 
			&& document.frmCuenta.SunPlus		!=""
			&& document.frmCuenta.cuentaAislada !=""  ){
			document.frmCuenta.Accion.value		= "2";
			document.frmCuenta.submit();
		}else{
			alert("¡Complete el formulario! ");
		}
	}
	
	function Borrar( ){	
		if(document.frmCuenta.CuentaId.value!=""){		
			if(confirm("¿Estás seguro de eliminar el registro?")==true){
	  			document.frmCuenta.Accion.value = "4";
				document.frmCuenta.submit();
			}			
		}else{
			alert("¡Escriba la Clave!");
			document.frmCuenta.CuentaId.focus(); 
	  	}
	}
	
	function Consultar(){
		document.frmCuenta.Accion.value = "5";
		document.frmCuenta.submit();		
	}	
	
</script>

<%
	// Declaracion de variables
	String escuelaId 		= (String) session.getAttribute("escuela");

	int numAccion			= Integer.parseInt(request.getParameter("Accion")==null?"1":request.getParameter("Accion"));
	String tipoCaja 		= request.getParameter("TipoCaja")==null?"":request.getParameter("TipoCaja");
	String tipoAlumno		= request.getParameter("TipoAlumno")==null?"":request.getParameter("TipoAlumno");
	
	String resultado		= "";
	String salto			= "X";
	
	if ( numAccion == 1 ){		
		Cuenta.setCuentaId(Cuenta.maxReg(conElias, escuelaId));		
	}else{
		Cuenta.mapeaRegId(conElias, request.getParameter("CuentaId"));
		Cuenta.setCuentaId(request.getParameter("CuentaId"));
	}
	
	// Operaciones a realizar en la pantalla	
	switch (numAccion){
		case 2: { // Grabar
			String tipo = (tipoCaja+tipoAlumno).equals("")?"-":(tipoCaja+tipoAlumno);
			Cuenta.setCuentaNombre(request.getParameter("CuentaNombre"));
			Cuenta.setEscuelaId(escuelaId);
			Cuenta.setBeca(request.getParameter("Beca"));
			Cuenta.setTipo(tipo);
			Cuenta.setCuentaSunPlus(request.getParameter("SunPlus"));
			Cuenta.setPagoInicial(request.getParameter("PagoInicial"));	
			String muestraSaldo = request.getParameter("muestraSaldoRecibo")!=null ? request.getParameter("muestraSaldoRecibo") : "N" ;
			Cuenta.setMuestraSaldoRecibo(muestraSaldo); 
			Cuenta.setCuentaAislada(request.getParameter("cuentaAislada")!=null ? request.getParameter("cuentaAislada") : "N");
			conElias.setAutoCommit(false);
			if (Cuenta.existeReg(conElias) == false){
				if (Cuenta.insertReg(conElias)){
					resultado = "Guardado";
					conElias.commit();
				}else{
					resultado = "NoGuardo";
				}
			}else{				
				if (Cuenta.updateReg(conElias)){
					resultado = "Modificado";
					conElias.commit();
				}else{
					resultado = "NoModifico";
				}
			}
			conElias.setAutoCommit(true);
			break;
		}
		case 4: { // Borrar		
			conElias.setAutoCommit(false);
			if (Cuenta.existeReg(conElias) == true){				
				if(!aca.fin.FinCosto.existeSoloCuenta(conElias, Cuenta.getCuentaId()) && !aca.fin.FinMovimientos.existeCuentaId(conElias, Cuenta.getCuentaId())){					
					if (Cuenta.deleteReg(conElias)){						
						resultado = "Eliminado";
						salto = "cuenta.jsp";
					}else{
						resultado = "NoElimino";
					}
				}else{
					resultado = "NoElimino";
				}
			}else{
				resultado = "NoElimino";
			}
			conElias.setAutoCommit(true);
			break;
			
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
 		<a class="btn btn-primary"href="cuenta.jsp"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
 	</div>  

	<form action="accion.jsp" method="post" name="frmCuenta" target="_self">
		<input type="hidden" name="Accion">

		<fieldset>
	    	<label for="CuentaId"><fmt:message key="aca.Id" /></label>
	        <input class="input-small" name="CuentaId" type="text" id="CuentaId" size="3" maxlength="4" value="<%=Cuenta.getCuentaId()%>" readonly> 
	    </fieldset>	        
	    
	    <fieldset>
	    	<label for="CuentaNombre"><fmt:message key="aca.Nombre" /></label>
	        <input name="CuentaNombre" type="text" id="CuentaNombre" value="<%=Cuenta.getCuentaNombre()%>" size="40" maxlength="40">
	   </fieldset>
	    
	   <fieldset>
	    	<label for="SunPlus"><fmt:message key="aca.SunPlus" /></label>
	        <select name="SunPlus" id="SunPlus">
	        	<option value="-"> - </option>
	        	<option value="621110" <%if(Cuenta.getCuentaSunPlus().equals("621110"))out.print("selected"); %>>621110 | <fmt:message key="aca.Ensenanza" /></option>
	        	<option value="622110" <%if(Cuenta.getCuentaSunPlus().equals("622110"))out.print("selected"); %>>622110 | <fmt:message key="aca.IngresosInscripcion" /></option>
	        	<option value="601110" <%if(Cuenta.getCuentaSunPlus().equals("601110"))out.print("selected"); %>>601110 | <fmt:message key="aca.TiendaEscolar" /></option>
	        	<option value="601120" <%if(Cuenta.getCuentaSunPlus().equals("601120"))out.print("selected"); %>>601120 | <fmt:message key="aca.UniformesEstudiantes" /></option>
	        	<option value="671140" <%if(Cuenta.getCuentaSunPlus().equals("671140"))out.print("selected"); %>>671140 | <fmt:message key="aca.IngresosOtrosServicios" /></option>
	        	<option value="622120" <%if(Cuenta.getCuentaSunPlus().equals("622120"))out.print("selected"); %>>622120 | <fmt:message key="aca.DerechoExamen" /></option>
	        	<option value="622140" <%if(Cuenta.getCuentaSunPlus().equals("622140"))out.print("selected"); %>>622140 | <fmt:message key="aca.SalaTareas" /></option>
	        	<option value="622150" <%if(Cuenta.getCuentaSunPlus().equals("622150"))out.print("selected"); %>>622150 | <fmt:message key="aca.IngresosClinicaNacionales" /></option>
	        	<option value="671120" <%if(Cuenta.getCuentaSunPlus().equals("671120"))out.print("selected"); %>>671120 | <fmt:message key="aca.RecargoEstudiantil" /></option>
	        </select>
	   	</fieldset>
	   
		<fieldset>
	    	<label for="CuentaNombre"><fmt:message key="aca.Beca" /></label>
	        <select  id="Beca" name="Beca">										
				<option value="S" <%if(Cuenta.getBeca().equals("S"))out.print("selected"); %>><fmt:message key="aca.Si" /></option>
				<option value="N" <%if(Cuenta.getBeca().equals("N"))out.print("selected"); %>><fmt:message key="aca.Negacion" /></option>
			</select>	
	   </fieldset>
	   
	   <fieldset>
	   		<p>
	        	<input type="checkbox" class="tipo" id="TipoCaja" name="TipoCaja" value="-CAJA" <%if(Cuenta.getTipo().contains("CAJA")) out.print("Checked");%> /> <fmt:message key="aca.Caja" /> 
	        </p>
	        <p>
	        	<input type="checkbox" class="tipo" id="TipoAlumno" name="TipoAlumno" value="-ALUMNO" <%if(Cuenta.getTipo().contains("ALUMNO")) out.print("Checked");%> /> <fmt:message key="aca.Alumno" />
	        </p>	
	   </fiedset>
	   
	   <fieldset>
	    	<label for="Tipo">
	        	% <fmt:message key="aca.PagoInicial" />
	        </label>
	        <input class="input-small" name="PagoInicial" type="text" id="PagoInicial" value="<%=Cuenta.getPagoInicial()%>" size="5" maxlength="5">
		</fieldset>
	
		<fieldset>
	    	<input type="checkbox" class="tipo" id="muestraSaldoRecibo" name="muestraSaldoRecibo" value="S" <%if(Cuenta.getMuestraSaldoRecibo()!=null && Cuenta.getMuestraSaldoRecibo().contains("S")) out.print("Checked");%> /> <fmt:message key="aca.MuestraSaldoRecibo" />
		</fieldset>
		
		<fieldset>
	    	<input type="checkbox" class="tipo" id="cuentaAislada" name="cuentaAislada" value="S" <%if(Cuenta.getCuentaAislada()!=null && Cuenta.getCuentaAislada().contains("S")) out.print("Checked");%> /> <fmt:message key="aca.CuentaAislada" />
		</fieldset>
	
		<div class="well">
	    	<a class="btn btn-primary btn-large" href="javascript:Grabar()"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
		</div>	     
	</form>
</div>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file= "../../cierra_elias.jsp" %>