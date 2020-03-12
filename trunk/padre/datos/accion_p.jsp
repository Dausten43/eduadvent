<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ page import= "java.security.MessageDigest" %>
<%@ page import= "sun.misc.BASE64Encoder"%>
<%@ page import="aca.alumno.AlumPersonal"%>
<%@ page import="aca.alumno.AlumPadres"%>

<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="Clave" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>

<%
	//Declaracion de variables
	String escuela 			= session.getAttribute("escuela").toString();
	String codigoId 		= session.getAttribute("codigoId").toString();
	
	String codigoPadre 		= request.getParameter("CodigoPadre")==null?session.getAttribute("codigoPadre").toString():request.getParameter("CodigoPadre");
	String strAccion 		= request.getParameter("Accion")==null?"5":request.getParameter("Accion");
	String strTipo 			= request.getParameter("tipo");
	String vref				= request.getParameter("ref")==null?"0":request.getParameter("ref");
	String tipo				= "";
	String sResultado		= "";
	
	boolean existePadre 	= aca.empleado.EmpPersonal.existeReg(conElias, codigoPadre);
	boolean padreDeEscuela	= false;
	
	int nAccion				= Integer.parseInt(strAccion);
	int i 					= 0;
		
%>
<head>
<script>		
	function Nuevo(){	
		document.frmPersonal.Accion.value			="1";
		document.frmPersonal.Nombre.value 			= "";
		document.frmPersonal.ApellidoPaterno.value 	= "";
		document.frmPersonal.ApellidoMaterno.value 	= "";	
		document.frmPersonal.Telefono.value			= "";	
		document.frmPersonal.Direccion.value		= "";
		document.frmPersonal.Colonia.value			= "";
		document.frmPersonal.Ocupacion.value		= "";
		document.frmPersonal.Email.value			= "";		
		document.frmPersonal.submit();			
	}
	
	function Grabar(){
		if(document.frmPersonal.Nombre!=""
			&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
			&& document.frmPersonal.Email.value!="" && document.frmPersonal.Telefono.value!="" && document.frmPersonal.Direccion.value!="" && document.frmPersonal.Ocupacion.value!=""){
			document.frmPersonal.Accion.value	="2";
			document.frmPersonal.tipo.value		= "Nuevo";			
			document.frmPersonal.submit();			
		}else{
			alert("<fmt:message key="js.CompletaCamposAsterisco" />");
		}
	}
	
	function Modificar(){
		if(document.frmPersonal.Nombre!=""
			&& document.frmPersonal.ApellidoPaterno.value!="" && document.frmPersonal.ApellidoMaterno.value!=""
			&& document.frmPersonal.Email.value!="" && document.frmPersonal.Telefono.value!="" && document.frmPersonal.Direccion.value!="" && document.frmPersonal.Ocupacion.value!=""){
			document.frmPersonal.Accion.value	="3";
			document.frmPersonal.submit();
		}else{
			alert(" <fmt:message key="js.CompletaCamposAsterisco" />");
		}
	}
	
	function Borrar( ){
		if(document.frmPersonal.CodigoEmpleado.value!=""){
			if(confirm("<fmt:message key="js.Confirma" />")==true){
	  			document.frmPersonal.Accion.value="4";
				document.frmPersonal.submit();
			}			
		}else{
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmPersonal.CodigoEmpleado.focus(); 
	  	}
	}
	
	function Consultar(){
		document.frmPersonal.Accion.value="5";
		document.frmPersonal.submit();		
	}	
	
	function Refresca (e){
		if(e.keyCode == 13){
			e.preventDefault()
			Consultar();
		}
	}
	
	function eliminaHijo(codigoId, tutor, tipo){
		if(confirm("<fmt:message key="js.ConfirmaRelacionHijoTutor" />"))
			document.location.href = "accion_p.jsp?Tipo="+tipo+"&ref=0&Accion=8&CodigoEmpleado="+tutor+"&hijo="+codigoId;
	}
</script>
</head>
<% 
	
	// Si el padre pertenece a una escuela actual
	if( codigoPadre.substring(0,3).equals(escuela) ){
		Personal.setCodigoId(codigoPadre);
		padreDeEscuela = true;
	}else{
		nAccion = 0;
	}

	// Operaciones a realizar en la pantalla
	switch (nAccion){
		case 1: { // Nuevo
			sResultado = "LlenarFormulario";
			//Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));			
			Personal.setNombre(request.getParameter("Nombre"));
			Personal.setApaterno(request.getParameter("ApellidoPaterno"));
			Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
			Personal.setGenero(request.getParameter("Sexo"));	
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setOcupacion(request.getParameter("Ocupacion"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setRfc(request.getParameter("RFC"));
			
			Clave.setCodigoId(request.getParameter("CodigoEmpleado"));
			Clave.setTipoId("3");
			Clave.setCuenta(request.getParameter("CodigoEmpleado"));
			Clave.setClave(request.getParameter("CodigoEmpleado"));
			strTipo = "Nuevo";
		
%>
	<script type="text/javascript">
		parent.document.getElementById("CodigoEmpleado").value = "<%=Personal.maximoRegEmp(conElias,escuela) %>";
	</script>
<%	
		}break;
		case 2: { // Grabar
			
			Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));
			Personal.setNombre(request.getParameter("Nombre").toUpperCase());
			Personal.setApaterno(request.getParameter("ApellidoPaterno").toUpperCase());
			Personal.setAmaterno(request.getParameter("ApellidoMaterno").toUpperCase());
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setTelefono(request.getParameter("Telefono"));
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setOcupacion(request.getParameter("Ocupacion"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setRfc(request.getParameter("RFC"));
			Personal.setEscuelaId(escuela);
			Personal.setEstado(request.getParameter("estado"));
			Personal.setTipoId("3");
			
			if(Personal.getCodigoId().substring(3,4).equals("P")){
				if (Personal.existeReg(conElias) == false){
					
					if (Personal.insertPadre(conElias)){
						session.setAttribute("codigoReciente", Personal.getCodigoId());
						session.setAttribute("codigoEmpleado", Personal.getCodigoId());
						sResultado = "Grabado";
						
						MessageDigest md5	= MessageDigest.getInstance("MD5");
						md5.update(Personal.getCodigoId().getBytes("UTF-8"));
			   			byte raw[] = md5.digest();
			   	 		String claveDigest	= (new BASE64Encoder()).encode(raw);
						
						Clave.setCodigoId(Personal.getCodigoId());
						Clave.setTipoId("3");
						Clave.setCuenta(Personal.getCodigoId());
						Clave.setClave(claveDigest);
						Clave.setAdministrador("N");
						Clave.setCotejador("N");
						Clave.setContable("N");	
						Clave.setEscuela("-"+escuela+"-");
						Clave.setPlan("x");
						Clave.setAsociacion("-");
						Clave.setIdioma("es");
						
						if(Clave.existeReg(conElias) == false){
							Clave.insertReg(conElias);	
						}						
						
						nAccion = 5;
						strTipo = "Consulta";
						codigoPadre = Personal.getCodigoId();
						sResultado = "Grabado";
					}else{
						sResultado = "NoGrabo";
					}
				}else{
					sResultado = "Existe";
				}				
				
			}			
		}break;
		
		case 3: { // Modificar						
			Personal.setNombre(request.getParameter("Nombre").toUpperCase());
			Personal.setApaterno(request.getParameter("ApellidoPaterno").toUpperCase());
			Personal.setAmaterno(request.getParameter("ApellidoMaterno").toUpperCase());
			Personal.setGenero(request.getParameter("Sexo"));
			Personal.setTelefono(request.getParameter("Telefono"));	
			Personal.setDireccion(request.getParameter("Direccion"));
			Personal.setColonia(request.getParameter("Colonia"));
			Personal.setOcupacion(request.getParameter("Ocupacion"));
			Personal.setEmail(request.getParameter("Email"));
			Personal.setRfc(request.getParameter("RFC"));
			Personal.setEscuelaId(escuela);
			Personal.setEstado(request.getParameter("estado"));
			Personal.setTipoId("3");
				
			if(codigoPadre.substring(3,4).equals("P")){
				if (Personal.existeReg(conElias)){
					if (Personal.updateReg(conElias)){
						Personal.mapeaRegId(conElias, codigoPadre);
						sResultado = "Modificado";						
					}else{
						sResultado = "Nocambio";
					}
				}else{
					sResultado = "NoExiste";
				}
			}			
		}break;

		case 4: { // Borrar
			if (Personal.existeReg(conElias) == true){
				String userBorra 	= (String) session.getAttribute("user");
				String userNombre	= aca.vista.Usuarios.getNombreUsuario(conElias, userBorra);
				String nombrePadre	= aca.vista.Usuarios.getNombreUsuario(conElias, Personal.getCodigoId());
				
				conElias.setAutoCommit(false);
				boolean error = false;
				
				if (Personal.deleteReg(conElias)){
					if(usuario.deleteReg(conElias, Personal.getCodigoId(), nombrePadre, userBorra, userNombre, aca.util.Fecha.getDateTime(), request.getRemoteAddr())){
						if( aca.alumno.AlumPadres.numeroDeHijos(conElias, Personal.getCodigoId()) > 0 && AlumPadres.borraPadre(conElias, Personal.getCodigoId()) == false ){		
							error = true;
						}
					}else{
						error = true;
					}
				}else{
					error = true;
				}
				
				if(error == false){
					sResultado = "Eliminado";
					conElias.commit();
				}else{
					sResultado = "NoBorro";
					conElias.rollback();
				}
				
				conElias.setAutoCommit(true);
			}else{
				sResultado = "NoExiste";
			}
		}break;
		
		case 5: { // Consultar
			if (Personal.existeReg(conElias) == true){
				Personal.mapeaRegId(conElias, codigoPadre);
				session.setAttribute("codigoReciente", codigoPadre);
				session.setAttribute("codigoPadre", codigoPadre);
				sResultado = "Consulta";
				strTipo = "Consulta";
			}else{
				sResultado = "NoExiste";
				strTipo = "No existe";
			}
		}break;		
		
		case 8: { //Elimina Hijo			
			String hijo = request.getParameter("hijo");
			tipo 		= request.getParameter("Tipo");
			
			if (Personal.existeReg(conElias) == true){
				Personal.mapeaRegId(conElias, codigoPadre);
				sResultado = "Consulta";
				strTipo = "Consulta";
			}else{
				sResultado = "NoExiste";
				strTipo = "Nuevo";
			}			
			alumPadres.setCodigoId(hijo);
			if(alumPadres.existeReg(conElias)){
				alumPadres.mapeaRegId(conElias,hijo);
				if (tipo.equals("Padre")){	alumPadres.setCodigoPadre("-");	}
				if (tipo.equals("Madre")){	alumPadres.setCodigoMadre("-");	}
				if (tipo.equals("Tutor")){	alumPadres.setCodigoTutor("-");	}
				
				if(alumPadres.updateReg(conElias)){
					sResultado = "RelacionCancelada";
				}else{
					sResultado = "ErrorAlBorrarAlumno";
				}
			}else{
				sResultado = "NoExisteRelacion";
			}
		}break;	
	} // fin de switch	
	
	session.setAttribute("emp",Personal.getCodigoId());
	if( existePadre && padreDeEscuela && nAccion != 0){
		pageContext.setAttribute("resultado",sResultado);
%>

<body>
<div id="content">
	<h2><fmt:message key="maestros.InformaciondelPadre" /> <%if(nAccion!=1){%><small><%=Personal.getNombre()+" "+Personal.getApaterno()+" "+Personal.getAmaterno()%></small><%}%> </h2>
	
	<form action="accion_p.jsp" method="post" name="frmPersonal" target="_self">
	<input type="hidden" name="Accion">
	<input type="hidden" name="tipo" value="<%=strTipo%> ">
	<input type="hidden" name="estado" value="A">
	<input type="hidden" name="escuela" value="<%=escuela%>">
	
<%		if(!sResultado.equals("")){
%>
		<div class="alert alert-info"><fmt:message key="aca.${resultado}" /></div> 
<%
		} 
%>

	<div class="well">
<%		if(nAccion!=1){%>
		<a class="btn btn-info" href="datosNew.jsp" title="Nuevo padre"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
		<input name="CodigoEmpleado" style="margin:0;" id="CodigoEmpleado" type="text" value="<%=Personal.getCodigoId()%>" readonly>
		<%}else{%>
		<a class="btn btn-info" href="accion_p.jsp" title="Cancelar"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Cancelar" /></a>
<%		}%>
	</div>
		
	<div class="row">	
	
		<div class="span4">
		
			<fieldset>
		       	<div class="control-group ">
		    		<label for="Nombre">
		            	<fmt:message key="aca.Nombre" />
		                <span class="required-indicator">*</span>
		            </label>
		            <input name="Nombre" type="text" id="Nombre" size="20" maxlength="40" value="<%=Personal.getNombre()%>">
				</div>
		            
				<div class="control-group ">
		        	<label for="ApellidoPaterno">
		            	<fmt:message key="aca.APaterno" />
		                <span class="required-indicator">*</span>
					</label>
		            <input name="ApellidoPaterno" type="text" id="ApellidoPaterno" size="20" maxlength="40" value="<%=Personal.getApaterno()%>">
				</div>
		            
		        <div class="control-group ">
		        	<label for="ApellidoMaterno">
		            	<fmt:message key="aca.AMaterno" />
		                <span class="required-indicator">*</span>
		            </label>
		            <input name="ApellidoMaterno" type="text" id="ApellidoMaterno" size="20" maxlength="40" value="<%=Personal.getAmaterno()%>">
		        </div>
		            
		        <div class="control-group ">
		        	<label for="Sexo">
		            	<fmt:message key="aca.Genero" />
		            </label>
		            <select name="Sexo" id="Sexo">
				<%if(Personal.getGenero().equals("M")){%>
			        	<option value='M' selected><fmt:message key="aca.Hombre" /></option>
			       		<option value='F' ><fmt:message key="aca.Mujer" /></option>
			    <%}else{%>
			        	<option value='M'><fmt:message key="aca.Hombre" /></option>
			        	<option value='F' selected><fmt:message key="aca.Mujer" /></option>
		        <%} %>
	              	</select>
		        </div>
		        
		        <div class="control-group ">
		        	<label for="RFC">
		            	<fmt:message key="aca.rfc" />/C&eacute;dula
		            </label>
		            <input name="RFC" type="text" id="RFC" size="20" maxlength="40" value="<%=Personal.getRfc() %>">
		        </div>
		            
			</fieldset>
		
		</div>
		
		<div class="span4">
		
			<fieldset>
				<div class="control-group ">
	                <label for="Telefono">
	                    <fmt:message key="aca.Telefono" />
	                    <span class="required-indicator">*</span>
	                </label>
	                <input name="Telefono" type="text" id="Telefono" size="40" maxlength="50" value="<%=Personal.getTelefono() %>">
	            </div>
	            
	            <div class="control-group ">
	                <label for="Direccion">
	                    <fmt:message key="aca.Direccion" />
	                    <span class="required-indicator">*</span>
	                </label>
	                <input name="Direccion" type="text" id="Direccion" size="40" maxlength="200" value="<%=Personal.getDireccion() %>">
	            </div>
	            
	            <div class="control-group ">
	                <label for="Colonia">
	                    <fmt:message key="aca.Colonia" />
	                </label>
	                <input name="Colonia" type="text" id="Colonia" size="40" maxlength="100" value="<%=Personal.getColonia() %>">
	            </div>
	            
	            <div class="control-group ">
	                <label for="Ocupacion">
	                    <fmt:message key="aca.Ocupacion" />
	                    <span class="required-indicator">*</span>
	                </label>
	                <input name="Ocupacion" type="text" id="Ocupacion" size="40" maxlength="50" value="<%=Personal.getOcupacion() %>">
	            </div>
	            
	            <div class="control-group ">
	                <label for="Email">
	                    <fmt:message key="aca.Email" />
	                    <span class="required-indicator">*</span>
	                </label>
	                <input name="Email" type="text" id="Email" size="40" maxlength="50" value="<%=Personal.getEmail()%>">
	            </div>
			</fieldset>
		
		</div>
		
		<div class="span4">			
		
			<%if(nAccion!=1){%>
			<h5><fmt:message key="padre.AlumnosEnTutoria" /></h5>
			
			<p>
				<%if(Personal.getCodigoId().substring(3,4).equals("P")){ %>
					<a class="btn btn-info" href="buscar.jsp?CodigoEmpleado=<%=Personal.getCodigoId()%>&Paterno=<%=Personal.getApaterno()%>"><i class="icon-plus icon-white"></i> <fmt:message key="boton.AnadirAlumno" /></a>
				<%} %>
			</p>
			<table class="table table-condensed">
			<% 
				ArrayList<aca.alumno.AlumPadres> lisHijos = alumPadresLista.getListTutor(conElias, Personal.getCodigoId(), " ");
				for(i = 0; i < lisHijos.size(); i++){
					alumPadres = (AlumPadres) lisHijos.get(i);
					alumno.mapeaRegId(conElias, alumPadres.getCodigoId());
					if (alumPadres.getCodigoPadre().equals(Personal.getCodigoId())) tipo = "Padre";
					if (alumPadres.getCodigoMadre().equals(Personal.getCodigoId())) tipo = "Madre";
					if (alumPadres.getCodigoTutor().equals(Personal.getCodigoId())) tipo = "Tutor";						
		  	%>
			  	<tr>
			  		<td>&nbsp;</td>
			  		
			  		<td>
			  		  <i class="icon-remove" onclick="eliminaHijo('<%=alumno.getCodigoId() %>','<%= Personal.getCodigoId() %>','<%=tipo%>');" style="cursor:pointer;" ></i>
			  		  &nbsp; <%= alumno.getCodigoId() %> | <%=alumno.getApaterno() %> <%=alumno.getAmaterno() %> <%=alumno.getNombre() %>
			  		</td>
			  	</tr>	
		  <%	}%>
			  </table>
			<%
			}
			%>	  		
		
		</div>
	
	</div>
	
	<div class="well">
<%
		if(nAccion == 1){
%>
              <a onclick="javascript:Grabar()" class="btn btn-primary btn-large"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Grabar" /></a>
<%
		}else if((nAccion >= 5 && !strTipo.equals("No existe")) || nAccion == 3){			
%>
              <a onclick="javascript:Modificar()" class="btn btn-primary btn-large"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
              <a onclick="javascript:Borrar()" class="btn btn-primary btn-large"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
<%
		}
%>
	</div>
</form>

<%
	}else if (existePadre==false){
%>
  <table width="100%">
    <tr><td align="center" width="100%"><font size="3">¡<fmt:message key="aca.EstePadreNoExiste" />!(Código: <%=codigoPadre%>)</font></td></tr>
    <tr>
    	<td align="center" width="100%">
    	<a class="btn btn-info" href="datosNew.jsp" title="Nuevo padre"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
    	</td>
    </tr>
  </table>
<%
	}else if (padreDeEscuela==false){
%>
  <table width="100%">
    <tr><td align="center" width="100%"><font size="3">Este padre (<%=codigoPadre %>) pertenece a otra escuela</font></td></tr>
  </table>
<%		
	}
%>

</div>
</body>

<%@ include file= "../../cierra_elias.jsp" %>
