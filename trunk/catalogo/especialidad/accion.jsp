<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="Especialidad" scope="page" class="aca.catalogo.CatEspecialidad"/>
<head>
	<script>
		
		function Nuevo(){		
			document.frmEspecialidad.Clave.value 	= " ";
			document.frmEspecialidad.Nombre.value 	= " ";
			document.frmEspecialidad.Accion.value	="1";
			document.frmEspecialidad.submit();		
		}
		
		function Grabar(){
			if(document.frmEspecialidad.Clave.value!="" && document.frmEspecialidad.Nombre.value!="" ){			
				document.frmEspecialidad.Accion.value="2";
				document.frmEspecialidad.submit();			
			}else{
				alert("<fmt:message key="js.Completar" />");
			}
		}
		
		function Borrar( ){
			if(document.frmEspecialidad.Clave.value!=""){
				if(confirm("<fmt:message key="js.Confirma" />")==true){
		  			document.frmEspecialidad.Accion.value = "4";
					document.frmEspecialidad.submit();
				}			
			}else{
				alert("<fmt:message key="js.EscribaClave" />");
				document.frmEspecialidad.Clave.focus(); 
		  	}
		}
		
	</script>
</head>
<% 
	String sResultado		= "";
	String accion			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	int nAccion 			= Integer.parseInt(accion);

	if (nAccion == 1){
		Especialidad.setEspecialidadId(Especialidad.maximoReg(conElias));
	}else{
		Especialidad.setEspecialidadId(request.getParameter("Clave"));
	}	

	switch (nAccion){
		case 1: { // Nuevo			
			sResultado = "LlenarFormulario";
			break;
		}		
		case 2: { // Grabar
			
			Especialidad.setEspecialidadId(request.getParameter("Clave"));
			Especialidad.setEspecialidadNombre(request.getParameter("Nombre"));
			if (Especialidad.existeReg(conElias) == false){
				if (Especialidad.insertReg(conElias)){
					sResultado = "Guardado";
					conElias.commit();
				}else{
					sResultado = "NoGuardo";
				}
			}else{
				if (Especialidad.updateReg(conElias)){
					sResultado = "Modificado";
					conElias.commit();
				}else{
					sResultado = "NoModifico";
				}
			}
			
			break;
		}
		
		case 4: { // Borrar
			if (Especialidad.existeReg(conElias) == true){
				if (Especialidad.deleteReg(conElias)){
					sResultado = "Eliminado";
					conElias.commit();
				}else{
					sResultado = "NoElimino";
				}	

			}else{
				sResultado = "NoExiste";
			}
			
			break;
		}
		
		case 5: { // Consultar
			Especialidad.setEspecialidadId(request.getParameter("Clave"));
			if (Especialidad.existeReg(conElias) == true){
				Especialidad.mapeaRegId(conElias, request.getParameter("Clave"));
				sResultado = "Consulta";
			}else{
				sResultado = "NoExiste"; 
			}	
			break;			
		}
		
	}
	
	pageContext.setAttribute("resultado", sResultado);
%>
<body>
<div id="content">
<h2><fmt:message key="catalogo.AnadirEsp" /></h2>
	<%
		if (!sResultado.equals("")) {
	%>
	<div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
	<%
		}
	%>

  <div class="well" style="overflow:hidden;">
  	<a class="btn btn-primary" href="especialidad.jsp"> <i class="icon-list icon-white"></i> <fmt:message key="boton.Listado" /></a>
  </div>
  
	<form action="accion.jsp" method="post" name="frmEspecialidad" target="_self">
	<input type="hidden" name="Accion">
	<input name="Pec" type="hidden">

<fieldset>
		<div class="control-group ">
	    	<label for="Clave">
	        	<fmt:message key="aca.Clave" />:	         
	        </label>
	        <input name="Clave" type="text" id="Clave" size="3" maxlength="3" value="<%= Especialidad.getEspecialidadId()%>">     
	    </div>	        
	    <div class="control-group ">
	    	<label for="AsocNombre">
	        	<fmt:message key="aca.Nombre" />:
	        </label>
	        <input name="Nombre" type="text" id="Nombre" value="<%= Especialidad.getEspecialidadNombre() %>" size="40" maxlength="40">
	    </div>
</fieldset>	 
</form>
	<div class="well" style="overflow:hidden;">
		<a class="btn btn-primary" href="javascript:Nuevo();"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a> 
    	&nbsp;<a class="btn btn-primary" href="javascript:Grabar();"><i class="icon-ok  icon-white"></i> <fmt:message key="boton.Guardar" /></a>  
    	&nbsp; <a class="btn btn-primary"href="javascript:Borrar()"><i class="icon-remove  icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
	</div>
</div>
</body>
<%@ include file= "../../cierra_elias.jsp" %>