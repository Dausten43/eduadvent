<%@ include file="../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<jsp:useBean id="empCredencial" scope="page" class="aca.empleado.EmpCredencial"/>
<jsp:useBean id="EspecialidadLista" scope="page" class="aca.catalogo.CatEspecialidadLista"/>
<head>
<head>
	<script src='../../js/jquery-1.7.1.min.js'></script>
	<script>
		
		function Grabar(){
			if(document.forma.Nivel.value!="" 
				&& document.forma.Grado.value!=""
				&& document.forma.Inicial.value!="" 
				&& document.forma.Final.value!="" ){			
				document.forma.Accion.value="2";
				document.forma.submit();			
			}else{
				alert("<fmt:message key="aca.LlenarFormulario" />");
			}
		}
		
	</script>
</head>
<%
	String escuelaId		= (String) session.getAttribute("escuela");
	String empleado			= (String)session.getAttribute("codigoEmpleado");
	String nombre 			=  aca.empleado.EmpPersonal.getNombre(conElias, empleado, "NOMBRE");
	
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	String resultado		= "";
	
	if(accion.equals("2")){
	
		empCredencial.setCodigoId(empleado);
		empCredencial.setEspecialidadId(request.getParameter("Especialidad"));
		empCredencial.setNivel(request.getParameter("Nivel"));
		empCredencial.setVigenciaIni(request.getParameter("Inicial"));
		empCredencial.setVigenciaFin(request.getParameter("Final"));
		empCredencial.setGrado(request.getParameter("Grado"));
		
		
		if (empCredencial.existeReg(conElias) == false){
			if (empCredencial.insertReg(conElias)){
				resultado = "Grabado";
				conElias.commit();
			}else{
				resultado = "NoGrabo";
			}
		}else{
			if (empCredencial.updateReg(conElias)){
				resultado = "Modificado";
				conElias.commit();
			}else{
				resultado = "NoCambio";
			}
		}
	}
%>
<body>
<div id="content">
<h2><fmt:message key="empleados.DatosdeCredencial" /></h2>
<hr />
<% if (!resultado.equals("")){%>
   		<div class='alert alert-error'><%=resultado%></div>
  	<% }%>
  	
<form method="post" action="credencial.jsp" name="forma">
<input type="hidden" name="Accion">

 <fieldset>
		<div class="control-group ">
	    	<label for="Nombre">
	        	<fmt:message key="empleados.NombreDelEmpleado" />:
	         
	        </label>
	        <input value="<%= nombre %>" name="Nombre" id="Nombre" type="text" maxlength="2" class="input-xlarge" readonly/>
	    </div>
	        
	    <div class="control-group ">
	    	<label for="Especialidad">
	        	<fmt:message key="empleados.Especialidad" />:
	        </label>
	       <select name="Especialidad" id="Especialidad" tabindex="15">
		<%	
			empCredencial.mapeaRegId(conElias, empleado);
			ArrayList lisEspecialidad = EspecialidadLista.getListAll(conElias, "ORDER BY ESPECIALIDAD_ID");
			for(int j = 0; j < lisEspecialidad.size(); j++){
				aca.catalogo.CatEspecialidad especialidad = (aca.catalogo.CatEspecialidad) lisEspecialidad.get(j);
					if(especialidad.getEspecialidadId().equals(empCredencial.getEspecialidadId())){%>
						<option value="<%=especialidad.getEspecialidadId()%>" selected="selected"><%= especialidad.getEspecialidadNombre()%></option>
					<%	}else{%>
						<option value="<%=especialidad.getEspecialidadId() %>"><%=especialidad.getEspecialidadNombre()%></option>
					<%	}
			}%>
			</select>
 	   </div>
 	   <div class="control-group ">
	    	<label for="Nivel">
	        	<fmt:message key="aca.Nivel" />:
	        </label>
	        <input value="<%= empCredencial.getNivel() %>" name="Nivel" id="Nivel" type="text" maxlength="40" class="input-medium" />
 	   </div>
 	   <div class="control-group ">
	    	<label for="Grado">
	        	<fmt:message key="aca.Grado" />:
	        </label>
	       <input value="<%= empCredencial.getGrado() %>" name="Grado" id="Grado" type="text" maxlength="30" class="input-medium" />
 	   </div>
 	   <div class="control-group ">
	    	<label for="Inicial">
	        	<fmt:message key="aca.VigenciaInicial" />:
	        </label>
	     	<input name="Inicial" type="text" id="Inicial" size="10" maxlength="20" value="<%= empCredencial.getVigenciaIni() %>" class="input-medium"> 
 	   </div>
 	   <div class="control-group ">
	    	<label for="Final">
	        	<fmt:message key="aca.VigenciaFinal" />:
	        </label>
	     	<input name="Final" type="text" id="Final" size="10" maxlength="20" value="<%= empCredencial.getVigenciaFin() %>" class="input-medium"> 
 	   </div>
	</fieldset>	

	<div class="well" style="overflow:hidden;">
           	<a class="btn btn-primary" href="javascript:Grabar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a>
    </div>
</form>
</div>
</body>
<%@ include file="../../cierra_elias.jsp" %>