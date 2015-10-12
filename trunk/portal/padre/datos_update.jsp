<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="religion" scope="page" class="aca.catalogo.CatReligion"/>
<jsp:useBean id="religionU" scope="page" class="aca.catalogo.CatReligionLista"/>
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivel"/>
<jsp:useBean id="nivelU" scope="page" class="aca.catalogo.CatNivelLista"/>
<jsp:useBean id="pais" scope="page" class="aca.catalogo.CatPais"/>
<jsp:useBean id="paisU" scope="page" class="aca.catalogo.CatPaisLista"/>
<jsp:useBean id="estado" scope="page" class="aca.catalogo.CatEstado"/>
<jsp:useBean id="estadoU" scope="page" class="aca.catalogo.CatEstadoLista"/>
<jsp:useBean id="ciudad" scope="page" class="aca.catalogo.CatCiudad"/>
<jsp:useBean id="ciudadU" scope="page" class="aca.catalogo.CatCiudadLista"/>

<%
	String codigoId 	= (String) session.getAttribute("codigoAlumno");
	String acfe1		= "";
	String sexo1		= "";
	String nivelId		= request.getParameter("nivelId");
	String curp			= request.getParameter("curp");
	String email		= request.getParameter("email");
	String grado		= request.getParameter("grado");
	String grupo		= request.getParameter("grupo");
	String telefono		= request.getParameter("telefono");
	String cotejado		= request.getParameter("cotejado");
	String estado1		= request.getParameter("estado1");
	String nombre		= request.getParameter("nombre");
	String aPaterno		= request.getParameter("aPaterno");
	String aMaterno		= request.getParameter("aMaterno");
	String sexo			= request.getParameter("sexo");
	String transporte	= request.getParameter("transporte");	
	String direccion	= request.getParameter("direccion");
	String fNacimiento	= request.getParameter("FNacimiento");
	String colonia		= request.getParameter("colonia");
	String matricula	= request.getParameter("matricula");
	
	alumPersonal.setCodigoId(codigoId);
	alumPersonal.mapeaRegId(conElias, codigoId);
	
	String Pais			= alumPersonal.getPaisId();
	String Estado		= alumPersonal.getEstadoId();
	String Ciudad		= alumPersonal.getCiudadId();
	String acfe			= alumPersonal.getClasfinId();
	String relig		= alumPersonal.getReligion();
	
	
	ArrayList lisReligion = new ArrayList();
	lisReligion = religionU.getListAll(conElias, "ORDER BY 1");
	
	ArrayList lisNiveles = new ArrayList();
	lisNiveles = nivelU.getListAll(conElias, "ORDER BY 1");
	
	ArrayList lisPais = new ArrayList();
	lisPais = paisU.getListAll(conElias, "ORDER BY 1");
	
%>
<html>
<head>
	<script>
		jQuery('.datos').addClass('active');
	</script>
	<script src="../../js/popcalendar.js"></script>
</head>
<body>	

<div id="content">
	
		<h2><fmt:message key="boton.ModificarDatos" /></h2>
		<div class="well">
			<a href="datos.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>

		<form action="accion.jsp" method="post" name="frmdatos1" target="_self">
		<input type="hidden" name="aPaterno" id="aPaterno" size="50%" value="<%=aPaterno%>">
		<input type="hidden" name="aMaterno" id="aMaterno" size="50%" value="<%=aMaterno%>">
		<input type="hidden" name="cotejado" id="cotejado" size="50%" value="<%=cotejado%>">
		<input type="hidden" name="estado1" id="estado1" size="50%" value="<%=estado1%>">
		
		<fieldset>
		
			<div class="row">
			
				<div class="span6">
					 <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Matricula" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" name="matricula" id="matricula" value="<%=matricula %>" READONLY>
		            </div>
	            </div>
	            
	            <div class="span6">
					 <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Socio" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" value="<%=acfe.equals("1")?"Si":"No"%>" size="1" READONLY>
		            </div>
	            </div>
            
            </div>
            
            <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Apellidos" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" name="appellidos" id="nombre" size="50%" value="<%=aPaterno+" "+aMaterno%>" readonly>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Religion" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <%if(cotejado.equals("S")){%>
							<input type="text" name="religion" id="religion" size="35" value="<%=aca.catalogo.CatReligion.getReligionNombre(conElias, relig) %>" readonly>
						<%}else{ %>
						
							<select name="religion" id="religion"><%
								for (int i=0; i<lisReligion.size(); i++){
									aca.catalogo.CatReligion rel = (aca.catalogo.CatReligion) lisReligion.get(i);%>
									<option value=<%=rel.getReligionId()%> <%if(rel.getReligionId().equals(relig)) out.print("selected");%>><%=rel.getReligionNombre() %></option>
							<%	} %>
							</select>
						
						<%} %>
		            </div>
		       </div>
		       
		    </div>
		    
		    <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Nombre" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" name="nombre" id="nombre" size="50%" value="<%=nombre%>" <%if(cotejado.equals("S"))out.print("readonly");%>>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		               	<label for="username">
		                    <fmt:message key="aca.Telefono" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" name="telefono" id="telefono" size="50%" value="<%=telefono%>">
		            </div>
		       </div>
		       
		    </div>
		    
		    <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Direccion" />
		                    <span class="required-indicator">*</span>
		                </label>
		               	<input type="text" name="direccion" id="direccion" size="30%" value="<%=direccion%>">
						<input type="text" name="colonia" id="colonia" size="10%" value="<%=colonia%>">
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Correo" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" name="email" id="email" size="50%" value="<%=email%>">
		            </div>
		       </div>
		       
		    </div>
		    
		    <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Genero" />
		                    <span class="required-indicator">*</span>
		                </label>
		               	<%if(cotejado.equals("S")){%>
							<input type="text" name="sexo" id="sexo" size="10" value="<%=sexo.equals("M")?"Masculino":"Femenino" %>" readonly>
						<%}else{ %>
							<select name="sexo" id="sexo" >
								<option value="M" <%if(sexo.equals("M")) out.print("selected");%>><fmt:message key="aca.Hombre" /></option>
								<option value="F" <%if(sexo.equals("F")) out.print("selected");%>><fmt:message key="aca.Mujer" /></option>
							</select>
						<%} %>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.CURP" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" name="curp" id="curp" size="50%" value="<%=curp%>"  <%if(cotejado.equals("S"))out.print("readonly");%>>
		            </div>
		       </div>
		       
		    </div>	
		    
		    <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Pais" />
		                    <span class="required-indicator">*</span>
		                </label>
		               	<select name="pais" id="pais">
						<%
						for (int i=0; i<lisPais.size(); i++){
							aca.catalogo.CatPais paiz = (aca.catalogo.CatPais) lisPais.get(i);%>
							<option value="<%=paiz.getPaisId()%>" <%if(paiz.getPaisId().equals(Pais)) out.print("selected");%>><%=paiz.getPaisNombre()%></option>
						<%} %>
						</select>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="catalogo.Nivel" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" value="<%=aca.catalogo.CatNivelEscuela.getNivelNombre(conElias, (String) session.getAttribute("escuela"), nivelId) %>" size="30" READONLY>
		            </div>
		       </div>
		       
		    </div>
		    
		    <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Estado" />
		                    <span class="required-indicator">*</span>
		                </label>
		               	<select name="estado" id="estado">
		               	 <%	
						ArrayList<aca.catalogo.CatEstado> lisEstado = estadoU.getArrayList(conElias, alumPersonal.getPaisId(), "ORDER BY 1,3");
						for(aca.catalogo.CatEstado edo: lisEstado){
						%>
								<option value="<%=edo.getEstadoId() %>" <%if(edo.getEstadoId().equals(alumPersonal.getEstadoId())){out.print("selected");} %>><%=edo.getEstadoNombre() %></option>
						<%							
							}
						%>
						</select>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Transporte" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="text" value="<%=transporte.equals("R")?"Automovil":"Caminando" %>" size="10" READONLY>
		            </div>
		       </div>
		       
		    </div>
		    
		    <div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Ciudad" />
		                    <span class="required-indicator">*</span>
		                </label>
		               	<select name="ciudad" id="ciudad">
		               		<%	
					ArrayList<aca.catalogo.CatCiudad> lisCiudad = ciudadU.getArrayList(conElias, alumPersonal.getPaisId(), alumPersonal.getEstadoId(), "ORDER BY 4");
					for(aca.catalogo.CatCiudad cd: lisCiudad){
				%>	
						<option value="<%=cd.getCiudadId() %>" <%if(cd.getCiudadId().equals(alumPersonal.getCiudadId())){out.print("selected");} %>><%=cd.getCiudadNombre() %></option>
				<%						
					}
				%>
						</select>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Grado" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="hidden" name="grado" id="grado" size="50%" value="<%=grado%>"><%=grado%>º
		            </div>
		       </div>
		       
		    </div>				    		       
			
			<div class="row">
			
				<div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.FechadeNacmiento" />
		                    <span class="required-indicator">*</span>
		                </label>
		               	<input name="Fecha" type="text" id="Fecha" size="10" maxlength="10" value="<%=fNacimiento %>" readonly="YES"> 
				  		<%if(cotejado.equals("N")){%>
				  		<img id="calgif" alt="calendario" src="../../imagenes/calendario.gif" onClick="javascript:showCalendar(this, document.getElementById('Fecha'), 'dd/mm/yyyy',null,1,-1,-1);" style="cursor:pointer">
	            		<%} %>
		            </div>
		       </div>
		       <div class="span6">
		            <div class="control-group ">
		                <label for="username">
		                    <fmt:message key="aca.Grupo" />
		                    <span class="required-indicator">*</span>
		                </label>
		                <input type="hidden" name="grupo" id="grupo" size="50%" value="<%=grupo%>"><%=grupo%>
		            </div>
		       </div>
		       
		    </div>	
		    
		</fieldset>
		
		<div class="well">
			<button class="btn btn-primary btn-large"><i class="icon-edit icon-white"></i> <fmt:message key="boton.Modificar" /></button>
		</div>
		
		</form>

</div>
</body>
</html>


<%@ include file="../../cierra_elias.jsp" %>