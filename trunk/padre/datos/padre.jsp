<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ page import="aca.empleado.EmpPersonal"%>
<%@page import="aca.alumno.AlumPersonal"%>
<%@page import="aca.alumno.AlumPadres"%>
<%@page import="aca.empleado.EmpTipo"%>

<jsp:useBean id="Personal" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="PersonalEmp" scope="page" class="aca.empleado.EmpPersonal"/>
<jsp:useBean id="alumno" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="alumnoLista" scope="page" class="aca.alumno.AlumPersonalLista"/>
<jsp:useBean id="alumPadres" scope="page" class="aca.alumno.AlumPadres"/>
<jsp:useBean id="alumPadresLista" scope="page" class="aca.alumno.AlumPadresLista"/>
<jsp:useBean id="empTipoLista" scope="page" class="aca.empleado.EmpTipoLista"/>
<jsp:useBean id="cicloGrupoCurso" scope="page" class="aca.ciclo.CicloGrupoCurso"/>
<jsp:useBean id="usuario" scope="page" class="aca.usuario.Usuario"/>
<jsp:useBean id="usuarioMenu" scope="page" class="aca.usuario.UsuarioMenu"/>
<jsp:useBean id="paisL" scope="page" class="aca.catalogo.CatPaisLista"/>
<jsp:useBean id="estadoL" scope="page" class="aca.catalogo.CatEstadoLista"/>
<jsp:useBean id="ciudadL" scope="page" class="aca.catalogo.CatCiudadLista"/>


<%
	String accion 		= request.getParameter("Accion")==null?"5":request.getParameter("Accion");
	if(accion.equals("5") && request.getParameter("CodigoEmpleado") != null){
		session.setAttribute("codigoEmpleado", request.getParameter("CodigoEmpleado"));
	}
	
	String codigoEmp 	= (String) session.getAttribute("codigoEmpleado");
	String codigoId  	= (String) session.getAttribute("codigoId");
	if ( codigoEmp == null || codigoEmp.equals("x") ){
		codigoEmp = (String) session.getAttribute("escuela")+ "00000";
	}
	
	String nombreEmp 	= aca.empleado.EmpPersonal.getNombre(conElias, codigoEmp, "NOMBRE");
	
	String tipo   		= request.getParameter("Tipo")==null?"":request.getParameter("Tipo");
	if (codigoEmp.substring(3,4).equals("P")) {
		tipo = "Padre";
	}else{
		tipo = "NO PADRE";
	}
	
	String escuela 		= (String)session.getAttribute("escuela");
	String strCodigo 	= request.getParameter("CodigoEmpleado")==null?codigoEmp:request.getParameter("CodigoEmpleado");
	String strTipo 		= request.getParameter("tipo")==null?"":request.getParameter("tipo");
	String vref			= request.getParameter("ref")==null?"0":request.getParameter("ref");
	
	String sResultado	= "";
	String clave 		= "";
	String codPers		= "";
	boolean existe 		= false;
	
	Personal.setCodigoId(strCodigo);
	// Operaciones a realizar en la pantalla
	if(accion.equals("1")){// Nuevo
		 
		if (strCodigo.substring(3,4).equals("E")){ 
			Personal.setCodigoId(Personal.maximoRegEmp(conElias,escuela));
		}
		if (strCodigo.substring(3,4).equals("P")){ 
			Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));
		}
		
		Personal.setEscuelaId(escuela);
		Personal.setNombre(request.getParameter("Nombre"));
		Personal.setApaterno(request.getParameter("ApellidoPaterno"));
		Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
		Personal.setGenero(request.getParameter("Sexo"));
		Personal.setFNacimiento(request.getParameter("FNacimiento"));
		Personal.setPaisId(request.getParameter("PaisId"));
		Personal.setEstadoId(request.getParameter("EstadoId"));
		Personal.setCiudadId(request.getParameter("CiudadId"));
		Personal.setEmail(request.getParameter("Email"));
		Personal.setColonia(request.getParameter("Colonia"));
		Personal.setDireccion(request.getParameter("Direccion"));
		Personal.setTelefono(request.getParameter("Telefono"));
		Personal.setEstado(request.getParameter("Estado"));
		Personal.setTipoId(request.getParameter("tipoId"));
		Personal.setRfc(request.getParameter("Rfc"));
		Personal.setSsocial(request.getParameter("Ssocial"));
		strTipo = "Nuevo";
	
	}else if(accion.equals("2")){// Grabar	
		
		if (strCodigo.substring(3,4).equals("E")){ 
			Personal.setCodigoId(Personal.maximoRegEmp(conElias,escuela));
		}
		if (strCodigo.substring(3,4).equals("P")){ 
			Personal.setCodigoId(Personal.maximoRegPad(conElias,escuela));
		}
		
		Personal.setEscuelaId(escuela);
		Personal.setNombre(request.getParameter("Nombre"));
		Personal.setApaterno(request.getParameter("ApellidoPaterno"));
		Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
		Personal.setGenero(request.getParameter("Sexo"));
		Personal.setFNacimiento(request.getParameter("FNacimiento"));
		Personal.setPaisId(request.getParameter("PaisId"));
		Personal.setEstadoId(request.getParameter("EstadoId"));
		Personal.setCiudadId(request.getParameter("CiudadId"));
		Personal.setEmail(request.getParameter("Email"));
		Personal.setColonia(request.getParameter("Colonia"));
		Personal.setDireccion(request.getParameter("Direccion"));
		Personal.setTelefono(request.getParameter("Telefono"));
		Personal.setTipoId(request.getParameter("tipoId"));
		Personal.setRfc(request.getParameter("Rfc"));
		Personal.setSsocial(request.getParameter("Ssocial"));
		Personal.setEstado(request.getParameter("Estado"));
		
		if (strCodigo.substring(3,4).equals("E")){ 		
			if (Personal.existeReg(conElias) == false){				
				if (Personal.insertReg(conElias)){							
					session.setAttribute("codigoEmpleado", Personal.getCodigoId());
					Personal.mapeaRegId(conElias, strCodigo);
					sResultado = "Grabado";
				}else{
						sResultado = "NoGrabo";
				}
			}else{
				sResultado = "Existe";
			}		
		}
		
		if(strCodigo.substring(3,4).equals("P")){
			if (Personal.existeReg(conElias) == false){							
				if (Personal.insertReg(conElias)){							
					session.setAttribute("codigoPadre", Personal.getCodigoId());
					Personal.mapeaRegId(conElias, strCodigo);
					sResultado = "Grabado";
				}else{
					sResultado = "NoGrabo";
				}
			}else{
				sResultado = "Existe";
			}			
		}
		
	}else if(accion.equals("3")){// Modificar
	
		Personal.setEscuelaId(escuela);
		Personal.setNombre(request.getParameter("Nombre"));
		Personal.setApaterno(request.getParameter("ApellidoPaterno"));
		Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
		Personal.setGenero(request.getParameter("Sexo"));
		Personal.setFNacimiento(request.getParameter("FNacimiento"));
		Personal.setPaisId(request.getParameter("PaisId"));
		Personal.setEstadoId(request.getParameter("EstadoId"));
		Personal.setCiudadId(request.getParameter("CiudadId"));
		Personal.setEmail(request.getParameter("Email"));
		Personal.setColonia(request.getParameter("Colonia"));
		Personal.setDireccion(request.getParameter("Direccion"));
		Personal.setTelefono(request.getParameter("Telefono"));
		Personal.setTipoId(request.getParameter("tipoId"));
		Personal.setRfc(request.getParameter("Rfc"));
		Personal.setSsocial(request.getParameter("Ssocial"));
		//Personal.setEstado("A");
		Personal.setEstado(request.getParameter("Estado"));

		
		if (Personal.existeReg(conElias)){
			if (Personal.updateReg(conElias)){
				Personal.mapeaRegId(conElias, strCodigo);
				sResultado = "Modificado";
			}else{
				sResultado = "NoCambio";
			}
		}else{
			sResultado = "NoExiste";
		}
		
		
	}else if(accion.equals("4")){// Borrar
		
		String nombre 	= aca.vista.Usuarios.getNombreUsuario(conElias, strCodigo);
	
		if (Personal.existeReg(conElias) == true){
			if(!cicloGrupoCurso.existeMaestro(conElias, strCodigo)){ //Si el maestro no tiene materias asignadas puede borrar
				conElias.setAutoCommit(false);
				if (Personal.deleteReg(conElias)){
					usuario.setCodigoId(strCodigo);
					usuario.setCodigoId(strCodigo);
					usuarioMenu.setCodigoId(strCodigo);
					if(	usuario.deleteReg(conElias, strCodigo, nombre, (String) session.getAttribute("user"), aca.vista.Usuarios.getNombreUsuario(conElias, (String)session.getAttribute("user")), aca.util.Fecha.getDateTime(), request.getRemoteAddr()) && 
						usuarioMenu.deleteAllReg(conElias)){
						sResultado = "Eliminado";
						conElias.commit();
					}else{
						conElias.rollback();
						sResultado = "NoBorro";
					}
				}else{
					sResultado = "NoBorro";
				}
				conElias.setAutoCommit(true);
			}else{// Si el maestro si tiene materias solo se despliega el mensaje diciendo esto
				sResultado = "NoBorroMateriasAsignadas";
			}
		}else{
			sResultado = "NoExiste";
		}
		
	}else if(accion.equals("5")){// Consultar
		
		if (Personal.existeReg(conElias) == true){
			Personal.mapeaRegId(conElias, strCodigo);
			strTipo = "Consulta";
		}else{
			strTipo = "Nuevo";
		}
		
	}else if(accion.equals("6")){// Refrescar combos PEC
				
		Personal.setEscuelaId(escuela);
		Personal.setNombre(request.getParameter("Nombre"));
		Personal.setApaterno(request.getParameter("ApellidoPaterno"));
		Personal.setAmaterno(request.getParameter("ApellidoMaterno"));
		Personal.setGenero(request.getParameter("Sexo"));
		Personal.setFNacimiento(request.getParameter("FNacimiento"));
		Personal.setPaisId(request.getParameter("PaisId"));
		Personal.setEstadoId(request.getParameter("EstadoId"));
		Personal.setCiudadId(request.getParameter("CiudadId"));
		Personal.setEmail(request.getParameter("Email"));
		Personal.setColonia(request.getParameter("Colonia"));
		Personal.setDireccion(request.getParameter("Direccion"));
		Personal.setTelefono(request.getParameter("Telefono"));
		Personal.setTipoId(request.getParameter("tipoId"));
		Personal.setEstado("A");
		 
	}else if(accion.equals("7")){// Guardar Hijo
	
		String hijo = request.getParameter("hijo");

		if (Personal.existeReg(conElias) == true){
			Personal.mapeaRegId(conElias, strCodigo);
			sResultado = "Consulta";
			strTipo = "Consulta";
		}else{
			sResultado = "NoExiste";
			strTipo = "Nuevo";
		}
		alumPadres.setCodigoId(hijo);
		if(alumPadres.existeReg(conElias)){
			sResultado = "AlumnoYaTienePadre";
		}else{
			alumPadres.setCodigoPadre(strCodigo);
			if(alumPadres.insertReg(conElias)){
				sResultado = "AlumnoGuardadoCorrectamente";
			}else{
				sResultado = "ErrorGuardadoAlumno";
			}
		}
		
	}else if(accion.equals("*")){//Elimina Hijo
	
		String hijo = request.getParameter("hijo");

		if (Personal.existeReg(conElias) == true){
			Personal.mapeaRegId(conElias, strCodigo);
			sResultado = "Consulta";
			strTipo = "Consulta";
		}else{
			sResultado = "NoExiste";
			strTipo = "Nuevo";
		}
		alumPadres.setCodigoId(hijo);
		if(alumPadres.existeReg(conElias)){
			if(alumPadres.deleteReg(conElias)){
				sResultado = "AlumnoFueBorradoExactamente";
			}else{
				sResultado = "ErrorAlBorrarAlumno";
			}
		}else{
			sResultado = "NoExisteRelacion";
		}
		
	}
	
	session.setAttribute("emp",Personal.getCodigoId());
	pageContext.setAttribute("resultado", sResultado);
	
%>

<div id="content">
	
	<h2><fmt:message key="empleados.DatosPersonalesMin" /></h2>
	
	<% if (sResultado.equals("Eliminado") || sResultado.equals("Modificado") || sResultado.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!sResultado.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>
	
	<form action="padre.jsp" method="post" name="frmEmpleado">
		<input name="Accion" type="hidden" value="1" />	
	
		<div class="well" style="overflow:hidden;">
			<a href="datosNew.jsp" class="btn btn-primary"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
		</div>
		
		<%if(tipo.equals("NO EMPLEADO")){%>
			<!-- NO ES EMPLEADO -->
		<%}else{%>
		
			<%if(Personal.existeReg(conElias) || accion.equals("1") || accion.equals("2") || accion.equals("3")){%>					
				
				<input type="hidden" name="Pec" />
				<input type="hidden" name="tipo" value="<%=strTipo%>" />
				
				<div class="row">
					<div class="span3">
												
						<img src="imagen.jsp?id=<%=new java.util.Date().getTime()%>" width="300">
						
						<br /><br />
						
						<div class="well" style="text-align:center;">
							<a href="javascript:camara()" class="btn btn-info btn-mini"><i class="icon-camera icon-white"></i></a>
					        <a href="subir.jsp" class="btn btn-info btn-mini"><i class="icon-arrow-up icon-white"></i></a>
						</div>
						
						<div class="well text-center">
							<%if(Personal.existeReg(conElias)== false){ %> 
			              		<a class="btn btn-primary" id="grabar" onclick="javascript:Grabar()" style="cursor:pointer"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a> 
			              	<%}else{%>
			              		<a class="btn btn-primary" id="modificar" onclick="javascript:Modificar()" style="cursor:pointer"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></a>
			              		<%if(!cicloGrupoCurso.existeMaestro(conElias, strCodigo)){ //Si el maestro no tiene materias asignadas puede borrar %>
			              			<a class="btn btn-danger" id="borrar" onclick="javascript:Borrar()" style="cursor:pointer"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
			              		<%} %>
			              	<%}%>
						</div>				              	
						
					</div>
					<div class="span3">
					
						<p>
							<label><fmt:message key="aca.Clave"/></label>
							<input name="CodigoEmpleado" type="text" value="<%=Personal.getCodigoId()%>" readonly>
						</p>
						
						<p>
							<label><fmt:message key="aca.Nombre"/></label>
							<input name="Nombre" type="text" id="Nombre" maxlength="40" value="<%=Personal.getNombre()%>">
						</p>
												
						<p>
							<label><fmt:message key="aca.ApellidoPat"/></label>
							<input name="ApellidoPaterno" type="text" id="ApellidoPaterno" maxlength="40" value="<%=Personal.getApaterno()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.ApellidoMat"/></label>
							<input name="ApellidoMaterno" type="text" id="ApellidoMaterno" maxlength="40" value="<%=Personal.getAmaterno()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.Genero"/></label>
							<select name="Sexo" id="Sexo">
		                		<option value="M" <%if(Personal.getGenero().equals("M")){out.print("selected");} %>><fmt:message key="aca.Hombre" /></option>
		                		<option value="F" <%if(Personal.getGenero().equals("F")){out.print("selected");} %>><fmt:message key="aca.Mujer" /></option>
		              		</select> 
						</p>
						
						<p>
							<label><fmt:message key="aca.FechadeNacimiento"/></label>
							<input name="FNacimiento" type="text" id="FNacimiento" size="10" maxlength="10" value="<%=Personal.getFNacimiento()%>">
						</p>
				
					</div>
					<div class="span3">		
						
						<p>
							<label><fmt:message key="aca.Pais"/></label>
							<select name="PaisId" id="PaisId" onchange = "PEC('1','<%=strTipo%>')">
							<%			 
								String PAIS = Personal.getPaisId()==null?"":Personal.getPaisId();
								ArrayList<aca.catalogo.CatPais> lisPais = paisL.getListAll(conElias,"ORDER BY 2");
								for(aca.catalogo.CatPais pais : lisPais){
									if(PAIS.equals(""))PAIS = pais.getPaisId(); 
							%>
									<option value="<%=pais.getPaisId() %>" <%if(pais.getPaisId().equals(PAIS)){out.print("selected");} %>><%=pais.getPaisNombre() %></option>
							<%
								}
							%>
				            </select> 
						</p>
						
						<p>	
							<label><fmt:message key="aca.Estado"/></label>
							<select name="EstadoId" id="EstadoId"  onChange= "javascript:PEC('2','<%=strTipo%>')">
							<%
								String EDO = Personal.getEstadoId()==null?"":Personal.getEstadoId();
								ArrayList<aca.catalogo.CatEstado> lisEdo = estadoL.getArrayList(conElias, PAIS, "ORDER BY 1,3");
								for(aca.catalogo.CatEstado estado : lisEdo){
									if(EDO.equals(""))EDO = estado.getEstadoId();
							%>
									<option value="<%=estado.getEstadoId() %>" <%if(estado.getEstadoId().equals(EDO)){out.print("selected");} %>><%=estado.getEstadoNombre() %></option>
							<%
								}	
							 %>
				             </select>
						</p>
						
						<p>
							<label><fmt:message key="aca.Ciudad"/></label>
							<select name="CiudadId" id="CiudadId">
							<%
								ArrayList<aca.catalogo.CatCiudad> lisCiudad = ciudadL.getArrayList(conElias, Personal.getPaisId(), EDO, "ORDER BY 4");
								for(aca.catalogo.CatCiudad ciudad : lisCiudad){
							%>
									<option value="<%=ciudad.getCiudadId() %>" <%if(ciudad.getCiudadId().equals(Personal.getCiudadId())){out.print("selected");} %>><%=ciudad.getCiudadNombre() %></option>
							<%									
								} 
							 %>
				             </select>							
						</p>
						
						<p>
							<label><fmt:message key="aca.Colonia"/></label>
							<input type="text" name="Colonia" id="Colonia" maxlength="20" value="<%=Personal.getColonia()==null?"":Personal.getColonia()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.Direccion"/></label>
							<input name="Direccion" type="text" id="Direccion" maxlength="50" value="<%=Personal.getDireccion()==null?"":Personal.getDireccion()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.Telefono"/></label>
							<input name="Telefono" type="text" id="Telefono" maxlength="30" value="<%=Personal.getTelefono()==null?"":Personal.getTelefono()%>">
						</p>
						
					</div>
					<div class="span3">
					
						<p>
							<label><fmt:message key="aca.Email"/></label>
							<input name="Email" type="text" id="Email" maxlength="50" value="<%=Personal.getEmail()==null?"":Personal.getEmail()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.Estado"/></label>
							<select name="Estado" id="Estado">
			                	<option value="A" <% if(Personal.getEstado().equals("A")){out.print("selected");}%>><fmt:message key="aca.Activo" /></option>
			                	<option value="I" <% if(Personal.getEstado().equals("I")){out.print("selected");}%>><fmt:message key="aca.Inactivo" /></option>
				            </select>
						</p>
						
						<p>
							<label><fmt:message key="aca.rfc"/></label>
							<input name="Rfc" type="text" id="Rfc" maxlength="40" value="<%= Personal.getRfc()==null?"":Personal.getRfc()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.SeguroSocial"/></label>
							<input name="Ssocial" type="text" id="Ssocial" maxlength="20" value="<%=Personal.getSsocial()==null?"":Personal.getSsocial()%>">
						</p>
						
						<p>
							<label><fmt:message key="aca.Tipo"/></label>
							<%if(!Personal.getApaterno().equals("") && Personal.getCodigoId().substring(3,4).equals("P")){%>
								<input type="hidden" id="tipoId" name="tipoId" value="7">Padre
							<%}else{%>
								<select id="tipoId" name="tipoId">
								<%
									ArrayList<aca.empleado.EmpTipo> lisTipo = empTipoLista.getListSinEsteTipo(conElias, "7","ORDER BY TIPO_ID");
									for(aca.empleado.EmpTipo empTipo : lisTipo){
								%>
										<option value="<%=empTipo.getTipoId() %>" <%if(Personal.getTipoId().equals(empTipo.getTipoId())) out.print("Selected"); %>><%=empTipo.getTipoNombre() %></option>
								<%
									}
								%>
								</select>
							<%}%>
						</p>
						
						
					</div>
				</div>
				


			<%}%>
		<%} %>
	</form>
</div>
	

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#FNacimiento').datepicker();
</script>

<script>
	function Consultar(){				
		document.frmEmpleado.Accion.value="5";
		document.frmEmpleado.submit();
	}
	
	function Refresca (e){
		if(e.keyCode == 13){
			e.preventDefault()
			Consultar();
		}
	}

	function Grabar(){
		if( document.frmEmpleado.CodigoEmpleado.value !="" && 
			document.frmEmpleado.Nombre.value !="" && 
			document.frmEmpleado.ApellidoPaterno.value !="" && 
			document.frmEmpleado.ApellidoMaterno.value !="" && 
			document.frmEmpleado.FNacimiento.value !="" && 
			document.frmEmpleado.Sexo.value !="" && 
			document.frmEmpleado.Rfc.value !="" && 
			document.frmEmpleado.Ssocial.value !="" ){
			
			document.frmEmpleado.Accion.value	="2";
			document.frmEmpleado.tipo.value		= "Nuevo";			
			document.frmEmpleado.submit();
			
		}else{
			alert("<fmt:message key="js.CompletaCamposAsterisco" />");
		}
	}
	
	function Modificar(){
		document.frmEmpleado.Accion.value="3";
		document.frmEmpleado.submit();
	}
	
	function Borrar( ){
		if(jQuery(document.frmEmpleado.CodigoEmpleado[0]).val()!=""){
			if(confirm("<fmt:message key="aca.EliminarRegistro" />")){
	  			document.frmEmpleado.Accion.value="4";
				document.frmEmpleado.submit();
			}
		}else{
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmEmpleado.CodigoEmpleado.focus();
	  	}
	}
	
	function PEC( Pec, tipo){		
		document.frmEmpleado.Accion.value="6";
		document.frmEmpleado.tipo.value = tipo;
		document.frmEmpleado.Pec.value 	= Pec;
		if (document.frmEmpleado.Pec.value=="1"){
			document.frmEmpleado.EstadoId.value = "1";
		}
		document.frmEmpleado.submit();			
	}
	
	function camara(){
		location.href="tomarfoto.jsp";		
	}
</script>

<%@ include file="../../cierra_elias.jsp"%>