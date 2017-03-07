<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@ include file="menuPortal.jsp"%>

<jsp:useBean id="Datos" scope="page" class="aca.alumno.AlumDatos" />
<jsp:useBean id="ReligionU" scope="page" class="aca.catalogo.CatReligionLista" />

<%
	String escuelaId		= (String)session.getAttribute("escuela");
	String codigoPersonal 	= (String)session.getAttribute("codigoId");
	String escuelaNombre		  	= (String)session.getAttribute("escuelaNombre");
	String accion 			= request.getParameter("Accion")==null?"0":request.getParameter("Accion");
	int Accion 				= Integer.parseInt(accion);
	String resultado		="";
	
    //operaciones a realizar 
	 switch (Accion){
	     	    
	    case 2: { //Grabar los Datos Familiares
	    	
	    		Datos.setEscuelaId(escuelaId);
		Datos.setCodigoId(codigoPersonal);
	    		Datos.setNombreTutor(request.getParameter("Nombre")==null?"":request.getParameter("Nombre"));
	    		Datos.setParentesco(request.getParameter("Parentesco")==null?"":request.getParameter("Parentesco"));
	    		Datos.setDireccion(request.getParameter("Direccion")==null?"":request.getParameter("Direccion"));
	    		Datos.setTelefono(request.getParameter("Telefono")==null?"":request.getParameter("Telefono"));
	    		Datos.setEmail(request.getParameter("Email")==null?"":request.getParameter("Email"));
	    		Datos.setEstudio(request.getParameter("Estudio")==null?"":request.getParameter("Estudio"));
	    		Datos.setEscuelaAnt(request.getParameter("Escuela")==null?"":request.getParameter("Escuela"));    		
	    		Datos.setDirEscuela(request.getParameter("Domicilio")==null?"":request.getParameter("Domicilio"));
	    		Datos.setTelEscuela(request.getParameter("Tel")==null?"":request.getParameter("Tel"));
	    		Datos.setFax(request.getParameter("Fax")==null?"":request.getParameter("Fax"));
	    		Datos.setEmailEscuela(request.getParameter("Correo")==null?"":request.getParameter("Correo"));
	    		Datos.setNombrePadre(request.getParameter("NombreP")==null?"":request.getParameter("NombreP"));
	    		Datos.setVivePadre(request.getParameter("ViveP")==null?"":request.getParameter("ViveP"));
	    		Datos.setReligionPadre(request.getParameter("ReligionP")==null?"":request.getParameter("ReligionP"));
	    		Datos.setDirPadre(request.getParameter("DirPadre")==null?"":request.getParameter("DirPadre"));
	    		Datos.setTelPadre(request.getParameter("TelPadre")==null?"":request.getParameter("TelPadre"));
	    		Datos.setTelTrabajoP(request.getParameter("TrabajoP")==null?"":request.getParameter("TrabajoP"));
	    		Datos.setCelPadre(request.getParameter("CelPadre")==null?"":request.getParameter("CelPadre"));
	    		Datos.setNombreMadre(request.getParameter("NombreM")==null?"":request.getParameter("NombreM"));
	    		Datos.setViveMadre(request.getParameter("ViveM")==null?"":request.getParameter("ViveM"));
	    		Datos.setReligionMadre(request.getParameter("ReligionM")==null?"":request.getParameter("ReligionM"));
	    		Datos.setDirMadre(request.getParameter("DirMadre")==null?"":request.getParameter("DirMadre"));
	    		Datos.setTelMadre(request.getParameter("TelMadre")==null?"":request.getParameter("TelMadre"));
	    		Datos.setTelTrabajoMadre(request.getParameter("TrabajoM")==null?"":request.getParameter("TrabajoM"));
	    		Datos.setEstadoCivil(request.getParameter("EdoCivil")==null?"":request.getParameter("EdoCivil"));
	    		Datos.setHermanos(request.getParameter("Hermano")==null?"":request.getParameter("Hermano"));
	    		Datos.setPreescolar(request.getParameter("Preescolar")==null?"":request.getParameter("Preescolar"));
	    		Datos.setPrimaria(request.getParameter("Primaria")==null?"":request.getParameter("Primaria"));
	    		Datos.setSecundaria(request.getParameter("Secundaria")==null?"":request.getParameter("Secundaria"));
	    	
	    	if (Datos.existeReg(conElias) == false){
				if (Datos.insertReg(conElias)){
			resultado = "!! Los Datos han sido Guardados Correctamente !!";
				}else{
			resultado = "No Grabó: "+Datos.getCodigoId();
				}
			}else{	
				if (Datos.updateReg(conElias)){ 
			resultado = "!! Los Datos han sido Modificados Correctamente !!";
				}else{
			resultado = "No Cambió: "+Datos.getCodigoId();
				}
			}
	    	break;
	    }//fin del case 2
	  
	 }// fin del switch
	
	 Datos.mapeaRegId(conElias, codigoPersonal, escuelaId);
%>
<form name="frmFam" method="post" action="familiares.jsp?Accion=2">
<div id="content">
<h2><fmt:message key="boton.DatosFam" /></h2>
	<div class="well" style="overflow: hidden;">
		<a href="datos.jsp" class="btn btn-primary"><i
			class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<div class="alert alert-info">
		<h4><fmt:message key="portal.Mensaje1" /></h4>
	</div>
		<div class="row">
			<div class="span4">
				<fieldset>
					<div class="control-group ">

						<label for="Nombre"> <fmt:message key="aca.Nombre" /> (<fmt:message key="portal.PersonaVivir" />): </label> 
							<input type="text" name="Nombre" id="Nombre" value="<%=Datos.getNombreTutor()%>" maxlength="150" size="30" />
					</div>
					<div class="control-group ">
						<label for="Parentesco"> <fmt:message key="aca.Parentesco" />: </label><input type="text" name="Parentesco" id="Parentesco" value="<%=Datos.getParentesco()%>" maxlength="30" />
					</div>
					<div class="control-group ">
						<label for="Telefono"> <fmt:message key="aca.Telefono" />: </label> <input type="text"
							name="Telefono" id="Telefono" value="<%=Datos.getTelefono()%>"
							maxlength="30" />
					</div>

				</fieldset>
			</div>
			<div class="span4">
				<fieldset>
					<div class="control-group ">
						<label for="Direccion"> <fmt:message key="aca.Direccion" />: </label> <input type="text"
							name="Direccion" id="Direccion" value="<%=Datos.getDireccion()%>"
							maxlength="50" />
					</div>
					<div class="control-group ">
						<label for="Email"> <fmt:message key="aca.Email" />: </label> <input
							type="text" name="Email" id="Email" value="<%=Datos.getEmail()%>"
							maxlength="50" />
					</div>
				</fieldset>
			</div>
		</div>

	<div class="alert alert-info">
		<h4><fmt:message key="portal.Mensaje2" /></h4>
	</div>
	
		<div class="row">
			<div class="span4">
				<fieldset>
					<div class="control-group ">

						<label for="Estudio"> <fmt:message key="portal.EstudioAlgunaVez" /> <%=escuelaNombre%>?
						</label><input type="radio" id="Estudio" name="Estudio" value="S" Checked />
						<fmt:message key="aca.Si" /> <input type="radio" id="Estudio" name="Estudio" value="N"
							<%=Datos.getEstudio().equals("N")?" Checked":""%> /> <fmt:message key="aca.Negacion" />
					</div>
					<div class="control-group ">
						<label for="Escuela"> <fmt:message key="portal.EscuelaAnterior" />: </label><input
							type="text" id="Escuela" name="Escuela"
							value="<%=Datos.getEscuelaAnt()%>" maxlength="50" size="40" />
					</div>
					<div class="control-group ">
						<label for="Domicilio"> <fmt:message key="aca.Domicilio" />: </label> <input type="text"
							id="Domicilio" name="Domicilio"
							value="<%=Datos.getDirEscuela()%>" maxlength="50" />
					</div>

				</fieldset>
			</div>
			<div class="span4">
				<fieldset>
					<div class="control-group ">
						<label for="Correo"> <fmt:message key="aca.Email" />: </label> <input
							type="text" id="Correo" name="Correo"
							value="<%=Datos.getEmailEscuela()%>" maxlength="50" />
					</div>
					<div class="control-group ">
						<label for="Tel"> <fmt:message key="aca.Telefono" />: </label> <input type="text" id="Tel"
							name="Tel" value="<%=Datos.getTelEscuela()%>" maxlength="30" />
					</div>
					<div class="control-group ">
						<label for="Fax"> <fmt:message key="aca.Fax" />: </label> <input type="text" id="Fax"
							name="Fax" value="<%=Datos.getFax()%>" maxlength="30" />
					</div>
				</fieldset>
			</div>
		</div>

	<div class="alert alert-info">
		<h4><fmt:message key="boton.DatosFam" /></h4>
	</div>
		<div class="row">
			<div class="span4">
				<fieldset>
					<div class="control-group ">

						<label for="NombreP"> <fmt:message key="aca.NombrePadre" />: </label> <input
							type="text" id="NombreP" name="NombreP"
							value="<%=Datos.getNombrePadre()%>" maxlength="150" />
					</div>
					<div class="control-group ">
						<label for="DirPadre"> <fmt:message key="aca.Domicilio" />: </label> <input type="text"
							id="DirPadre" name="DirPadre" value="<%=Datos.getDirPadre()%>"
							maxlength="50" />
					</div>
					<div class="control-group ">
						<label for="CelPadre"> <fmt:message key="aca.Celular" />: </label> <input type="text"
							id="CelPadre" name="CelPadre" value="<%=Datos.getCelPadre()%>"
							maxlength="30" />
					</div>
					<div class="control-group ">
						<label for="ReligionP"> <fmt:message key="aca.Religion" />: </label> <select id="ReligionP"
							name="ReligionP" onchange="javascript:cambia()">
							<option value="0" SELECTED>Selecciona la Religión</option>
							<%
								String religionId = "0";
													if(Datos.getReligionPadre()!=null)
														religionId = Datos.getReligionPadre();
													ArrayList lisReligion	  =	ReligionU.getListAll(conElias, "ORDER BY RELIGION_ID");
													for(int i = 0; i < lisReligion.size(); i++){
														aca.catalogo.CatReligion religion = (aca.catalogo.CatReligion) lisReligion.get(i);
							%>
							<option value="<%=religion.getReligionId()%>"
								<%=religion.getReligionId().equals(religionId)?"Selected":""%>><%=religion.getReligionNombre()%></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="control-group ">
						<label for="TrabajoP"> <fmt:message key="aca.TelefonoTrabajo" />: </label> <input type="text"
							id="TrabajoP" name="TrabajoP" value="<%=Datos.getTelTrabajoP()%>"
							maxlength="30" />
					</div>
				</fieldset>
			</div>

			<div class="span4">
				<fieldset>
					<div class="control-group ">
						<label for="ViveP"> <fmt:message key="aca.Vive" />: </label> <input type="radio"
							id="ViveP" name="ViveP" value="S" Checked /> <fmt:message key="aca.Si" /> <input
							type="radio" id="ViveP" name="ViveP" value="N"
							<%=Datos.getVivePadre().equals("N")?" Checked":""%> /> <fmt:message key="aca.Negacion" />
					</div>
					<div class="control-group ">
						<label for="TelPadre"> <fmt:message key="aca.Telefono" />: </label> <input type="text"
							id="TelPadre" name="TelPadre" value="<%=Datos.getTelPadre()%>"
							maxlength="30" />
					</div>
					<div class="control-group ">
						<label for="NombreM"> <fmt:message key="aca.NombreMadre" />: </label><input
							type="text" id="NombreM" name="NombreM"
							value="<%=Datos.getNombreMadre()%>" maxlength="150" />
					</div>
					<div class="control-group ">
						<label for="DirMadre"> <fmt:message key="aca.Domicilio" />: </label><input type="text"
							id="DirMadre" name="DirMadre" value="<%=Datos.getDirMadre()%>"
							maxlength="50" />
					</div>
					<div class="control-group ">
						<label for="CelM"> <fmt:message key="aca.Celular" />:</label><input type="text" id="CelM"
							name="CelM" value="<%=Datos.getEscuelaAnt()%>" maxlength="30" />
					</div>
				</fieldset>
			</div>

			<div class="span4">
				<fieldset>
					<div class="control-group ">
						<label for="ReligionM"> <fmt:message key="aca.Religion" />: </label> <select id="ReligionM"
							name="ReligionM" onchange="javascript:cambia()">
							<option value="0" SELECTED>Selecciona la Religión</option>
							<%
								religionId="0";
										if(Datos.getReligionMadre()!=null)
											religionId = Datos.getReligionMadre();
										lisReligion	  =	ReligionU.getListAll(conElias, "ORDER BY RELIGION_ID");
										for(int i = 0; i < lisReligion.size(); i++){
											aca.catalogo.CatReligion religion = (aca.catalogo.CatReligion) lisReligion.get(i);
							%>
							<option value="<%=religion.getReligionId()%>"
								<%=religion.getReligionId().equals(religionId)?"Selected":""%>><%=religion.getReligionNombre()%></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="control-group ">
						<label for="TrabajoM"><fmt:message key="aca.TelefonoTrabajo" />: </label><input type="text"
							id="TrabajoM" name="TrabajoM"
							value="<%=Datos.getTelTrabajoMadre()%>" maxlength="30" />
					</div>
					<div class="control-group ">
						<label for="ViveM"> <fmt:message key="aca.Vive" />: </label> <input type="radio"
							id="ViveM" name="ViveM" value="S" Checked /> <fmt:message key="aca.Si" /> <input
							type="radio" id="ViveM" name="ViveM" value="N"
							<%=Datos.getViveMadre().equals("N")?" Checked":""%> /> <fmt:message key="aca.Negacion" />
					</div>
					<div class="control-group ">
						<label for="TelMadre"> <fmt:message key="aca.Telefono" />: </label><input type="text"
							id="TelMadre" name="TelMadre" value="<%=Datos.getTelMadre()%>"
							maxlength="30" />
					</div>
					<div class="control-group ">
						<label for="ECivildo"> <fmt:message key="aca.EstadoCivil" />: </label><select id="EdoCivil"
							name="EdoCivil">
							<option value="0" SELECTED>Selecciona el Estado Civil</option>
							<%
								String estadoCivil = Datos.getEstadoCivil()==null?"":Datos.getEstadoCivil();
							%>
							<option value="C" <%=estadoCivil.equals("C")?"Selected":""%>><fmt:message key="aca.Casado" /></option>
							<option value="S" <%=estadoCivil.equals("D")?"Selected":""%>><fmt:message key="aca.Divorciado" /></option>
							<option value="V" <%=estadoCivil.equals("U")?"Selected":""%>><fmt:message key="aca.UnionLibre" /></option>
							<option value="D" <%=estadoCivil.equals("S")?"Selected":""%>><fmt:message key="aca.Separados" /></option>
						</select>
					</div>
				</fieldset>
			</div>
		</div>

		<div class="alert alert-info" style="background: white;">
			<h4>
				<fmt:message key="portal.Mensaje3" />&nbsp;&nbsp;&nbsp;<small><input
					type="radio" id="Hermano" name="Hermano" value="S" Checked />
					<fmt:message key="aca.Si" />&nbsp; <input type="radio" id="Hermano" name="Hermano" value="N"
					<%=Datos.getViveMadre().equals("N")?" Checked":""%> /> <fmt:message key="aca.Negacion" /></small>
			</h4>
			<br>


			<div class="row">
				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label for="Preescolar"> <fmt:message key="aca.Preescolar" />: </label> <input
								type="number" id="Preescolar" name="Preescolar"
								value="<%=Datos.getPreescolar()%>" maxlength="2" size="3" />
						</div>
					</fieldset>
				</div>
				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label for="Primaria"> <fmt:message key="aca.Primaria" />: </label><input type="number"
								id="Primaria" name="Primaria" value="<%=Datos.getPrimaria()%>"
								maxlength="2" size="3" />
						</div>
					</fieldset>
				</div>
				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label for="Secundaria"> <fmt:message key="aca.Secundaria" />: </label> <input
								type="number" id="Secundaria" name="Secundaria"
								value="<%=Datos.getSecundaria()%>" maxlength="2" size="3" />
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	
	<div class="well" style="overflow: hidden;">
		<button class="btn btn-primary" class="button">
			<i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" />
		</button>
	</div>
	
</div>
</form>
<script>
	jQuery('.datos').addClass('active');
</script>
<%@ include file="../../cierra_elias.jsp"%>