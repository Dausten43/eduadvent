<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="Union" scope="page" class="aca.catalogo.CatUnion" />
<jsp:useBean id="AsocL" scope="page" class="aca.catalogo.CatAsociacionLista" />
<jsp:useBean id="PaisL" scope="page" class="aca.catalogo.CatPaisLista" />
<jsp:useBean id="EstadoL" scope="page" class="aca.catalogo.CatEstadoLista" />
<jsp:useBean id="CiudadL" scope="page" class="aca.catalogo.CatCiudadLista" />
<jsp:useBean id="BarrioL" scope="page" class="aca.catalogo.CatBarrioLista" />
<jsp:useBean id="RegionL" scope="page" class="aca.catalogo.CatRegionLista" />

<script>
	function Grabar() {
		if (document.frmEscuela.EscuelaId.value != "" && document.frmEscuela.EscuelaNombre.value != "") {
			if(document.frmEscuela.EscuelaId.value.length == 2 || document.frmEscuela.EscuelaId.attributes['readonly'] != undefined ){
				document.frmEscuela.Accion.value = "2";
				document.frmEscuela.submit();				
			}else{
				alert("La escuela Id debe tener 2 caracteres");
			}
		} else {
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Borrar() {
		if (document.frmEscuela.EscuelaId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmEscuela.Accion.value = "4";
				document.frmEscuela.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmEscuela.EscuelaId.focus();
		}
	}

	function Consultar() {
		document.frmEscuela.Accion.value = "5";
		document.frmEscuela.submit();
	}

	function PEC(Pec) {
		document.frmEscuela.Accion.value = "6";
		document.frmEscuela.Pec.value = Pec;
		document.frmEscuela.submit();
	}
</script>

<%
	String unionId	= request.getParameter("unionId");
	Union.mapeaRegId(conElias, unionId);
	String editar 	= request.getParameter("editar")==null?"N":request.getParameter("editar");
	String salto	= "X";

	//Declaracion de variables	
	String accion = request.getParameter("Accion");
	
	if (accion.equals("1")) {
		String escuela = Escuela.maximoReg(conElias, unionId);
		if (escuela.length() ==1 ) escuela = "0"+escuela;
		Escuela.setEscuelaId(escuela);		
		Escuela.setPaisId("135");
	} else {
		Escuela.setEscuelaId(request.getParameter("EscuelaId"));
	}

	if (accion.equals("2") || accion.equals("6")) {
		Escuela.setEscuelaNombre(request.getParameter("EscuelaNombre"));
		Escuela.setNombreCorto(request.getParameter("NombreCorto"));
		Escuela.setDireccion(request.getParameter("Direccion"));
		Escuela.setColonia(request.getParameter("Colonia"));
		Escuela.setTelefono(request.getParameter("Telefono"));
		Escuela.setFax(request.getParameter("Fax"));
		Escuela.setPaisId(request.getParameter("PaisId"));
		Escuela.setAsociacionId(request.getParameter("AsocId"));
		Escuela.setLogo(request.getParameter("Logo"));
		Escuela.setFirma(request.getParameter("Firma"));
		Escuela.setEstado(request.getParameter("Estado"));
		Escuela.setSeccionId(request.getParameter("SeccionId"));
		Escuela.setUnionId(unionId);			
		Escuela.setOrgId(request.getParameter("OrgId"));
		Escuela.setDistrito(request.getParameter("Distrito"));
		Escuela.setRegionId(request.getParameter("RegionId"));
		Escuela.setEslogan(request.getParameter("Eslogan"));
		Escuela.setSector(request.getParameter("Sector"));
		Escuela.setZona(request.getParameter("Zona"));
		Escuela.setBarrioId(request.getParameter("BarrioId"));
		Escuela.setWww(request.getParameter("Www"));
		Escuela.setRegistro(request.getParameter("registro"));
	}
	
	String msj = "";
	
	
	if( accion.equals("2") ){ // Grabar

		Escuela.setEstadoId(request.getParameter("EstadoId"));
		Escuela.setCiudadId(request.getParameter("CiudadId"));
		Escuela.setBarrioId(request.getParameter("BarrioId"));

		if (Escuela.existeReg(conElias) == false) {
			Escuela.setEscuelaId(Union.getLetra()+request.getParameter("EscuelaId"));
			
			if (Escuela.insertReg(conElias)) {
				msj = "Guardado";
				accion = "5";
				editar  = "S";
			} else {
				msj = "NoGuardo";
			}
		} else if( editar.equals("S") ){
			if (Escuela.updateReg(conElias)) {
				msj = "Modificado";
			} else {
				msj = "NoModifico";
			}
		}else{
			msj = "Existe";
			Escuela.setEscuelaId(request.getParameter("EscuelaId"));
		}
	}
	if( accion.equals("4") ){ // Borrar
		if (Escuela.existeReg(conElias) == true) {
			if (Escuela.deleteReg(conElias)) {
				msj = "Eliminado";
				salto = "escuela.jsp?unionId="+unionId;
			} else {
				msj = "NoElimino";
			}

		} else {
			msj = "NoExiste";
		}
	}
	if( accion.equals("5") ){ // Consultar
		Escuela.setCiudadId(request.getParameter("CiudadId"));
		if (Escuela.existeReg(conElias) == true) {
			Escuela.mapeaRegId(conElias,request.getParameter("EscuelaId"));
		}
	}
	if( accion.equals("6") ){ // Refrescar combos PEC
		if (request.getParameter("Pec").equals("2")) {
			Escuela.setEstadoId(request.getParameter("EstadoId"));
		} else {
			Escuela.setEstadoId("");
			Escuela.setCiudadId("");
		}
	}

	if (Escuela.getPaisId().equals("")){
		Escuela.setPaisId("135");
	}
	if (Escuela.getEstadoId().equals("")){
		Escuela.setEstadoId("1");	
	}
	if (Escuela.getCiudadId().equals("")){
		Escuela.setCiudadId("1");	
	}
	
	pageContext.setAttribute("resultado", msj);

	ArrayList<aca.catalogo.CatPais> lisPais 	= PaisL.getListAll(conElias, " ORDER BY PAIS_NOMBRE");
	ArrayList<aca.catalogo.CatEstado> lisEstado	= EstadoL.getArrayList(conElias, Escuela.getPaisId(), " ORDER BY PAIS_ID,ESTADO_NOMBRE");
	ArrayList<aca.catalogo.CatCiudad> lisCiudad = CiudadL.getArrayList(conElias, Escuela.getPaisId(), Escuela.getEstadoId(), "ORDER BY CIUDAD_NOMBRE");
	ArrayList<aca.catalogo.CatBarrio> lisBarrio = BarrioL.getArrayList(conElias, Escuela.getPaisId(), Escuela.getEstadoId(), Escuela.getCiudadId(), "ORDER BY BARRIO_NOMBRE");
	ArrayList<aca.catalogo.CatRegion> lisRegion = RegionL.getListAll(conElias, Escuela.getPaisId(), "ORDER BY REGION_NOMBRE");
	
	ArrayList<aca.catalogo.CatAsociacion> asoc = AsocL.getListAll(conElias, "WHERE UNION_ID = "+unionId+" ORDER BY ASOCIACION_NOMBRE ");
%>

<div id="content">
	<h2><fmt:message key="catalogo.AnadirEsc" /></h2>
	<% if (msj.equals("Eliminado") || msj.equals("Modificado") || msj.equals("Guardado")){%>
   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
  	<% }else if(!msj.equals("")){%>
  		<div class='alert alert-danger'><fmt:message key="aca.${resultado}" /></div>
  	<%} %>


	<div class="well" style="overflow: hidden;">
		<a class="btn btn-primary" href="escuela.jsp?unionId=<%=unionId%>"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
	</div>

	<form action="accion.jsp" method="post" name="frmEscuela" target="_self">
		<input type="hidden" name="Accion"> 
		<input name="Pec" type="hidden">
		<input type="hidden" name="editar" value="<%=editar%>" />
		<input type="hidden" name="unionId" value="<%=unionId%>" />
			
		<div class="row">
			<div class="span3">
			
				<fieldset>
					<label for="EscuelaId"> <fmt:message key="aca.Clave" /></label> 
					<%if(editar.equals("N")){%>
						<%=Union.getLetra() %>
					<%}%>
					<input name="EscuelaId" type="text" id="EscuelaId" size="3" maxlength="2" value="<%=Escuela.getEscuelaId()%>" <%if(editar.equals("S")){out.print("readonly");} %> >
				</fieldset>
				
				<fieldset>
					<label for="EscuelaNombre"> <fmt:message key="aca.Nombre" /></label> 
					<input name="EscuelaNombre" type="text" id="EscuelaNombre" value="<%=Escuela.getEscuelaNombre()%>" size="40" maxlength="70">
				</fieldset>
				
				<fieldset>
					<label for="NombreCorto"> <fmt:message key="aca.NombreCorto" /></label>
					 <input name="NombreCorto" type="text" id="NombreCorto" value="<%=Escuela.getNombreCorto()%>" size="25" maxlength="25">
				</fieldset>
				
				<fieldset>
					<label for="Direccion"> <fmt:message key="aca.Direccion" /></label>
					<input name="Direccion" type="text" id="Direccion" value="<%=Escuela.getDireccion()%>" size="40" maxlength="80">
				</fieldset>
				
				<fieldset>
					<label for="Colonia"> <fmt:message key="aca.Colonia" /></label> 
					<input name="Colonia"type="text" id="Colonia" value="<%=Escuela.getColonia()%>" size="40" maxlength="80">
				</fieldset>
				
				<fieldset>
					<label for="Telefono"> <fmt:message key="aca.Telefono" /></label> 
					<input name="Telefono" type="text" id="Telefono" value="<%=Escuela.getTelefono()%>" size="40" maxlength="80">
				</fieldset>
				
				<fieldset>
					<label for="Fax"><fmt:message key="aca.Fax" /></label>
					<input name="Fax" type="text" id="Fax" value="<%=Escuela.getFax()%>" size="40" maxlength="80">
				</fieldset>
				
			</div>

			<div class="span3">
				
				<fieldset>
					<label for="PaisId"><fmt:message key="aca.Pais" /></label> 
					<select name="PaisId" id="PaisId" onchange="PEC('1')">
						<%for (aca.catalogo.CatPais pais : lisPais) {%>
							<option value="<%=pais.getPaisId() %>" <%if (pais.getPaisId().equals(Escuela.getPaisId())){out.print("selected");} %>><%=pais.getPaisNombre() %></option>
						<%}%>
					</select>
				</fieldset>
					
				<fieldset>
					<label for="EstadoId"><fmt:message key="aca.Estado" /></label> 
					<select name="EstadoId" id="EstadoId" onChange="javascript:PEC('2')">
						<%for(aca.catalogo.CatEstado estado : lisEstado ){%>
							<option value="<%=estado.getEstadoId() %>" <%if (estado.getEstadoId().equals(Escuela.getEstadoId())){out.print("selected");} %>><%=estado.getEstadoNombre() %></option>
						<%}%>
					</select>
				</fieldset>
					
				<fieldset>
					<label for="CiudadId"> <fmt:message key="aca.Ciudad" /></label> 
						<select name="CiudadId" id="CiudadId">
							<%for (aca.catalogo.CatCiudad ciudad : lisCiudad) {%>
								<option value="<%=ciudad.getCiudadId() %>" <%if (ciudad.getCiudadId().equals(Escuela.getCiudadId())){out.print("selected");} %>><%=ciudad.getCiudadNombre() %></option>
							<%} %>										
						</select>
				</fieldset>
				
				<fieldset>
					<label for="BarrioId"> <fmt:message key="aca.Barrio" /></label> 
						<select name="BarrioId" id="BarrioId">
							<%for (aca.catalogo.CatBarrio barrio : lisBarrio) {%>
								<option value="<%=barrio.getBarrioId() %>" <%if (barrio.getBarrioId().equals(Escuela.getBarrioId())){out.print("selected");} %>><%=barrio.getBarrioNombre() %></option>
							<%} %>										
						</select>
				</fieldset>
				
				<fieldset>						
					<label for="AsocId"> <fmt:message key="catalogo.Asoc" /></label> 
					<select name="AsocId" id="AsocId" onchange="distritosAsoc()">
						<%for (aca.catalogo.CatAsociacion asociacion : asoc) {%>
							<option value="<%=asociacion.getAsociacionId() %>" <%if (asociacion.getAsociacionId().equals(Escuela.getAsociacionId())){out.print("selected");} %>><%=asociacion.getAsociacionNombre() %></option>"
						<%} %>											
					</select>
				</fieldset>
					
				<fieldset>
					<label for="Distrito"><fmt:message key="aca.Distrito" /></label> 
					<input name="Distrito" type="text" id="Distrito" value="<%=Escuela.getDistrito()==null?"":Escuela.getDistrito() %>" maxlength="10">
				</fieldset>
				
				<fieldset>	
					<label for="RegionId"> <fmt:message key="aca.Region" /></label>
					<select name="RegionId" id="RegionId">
						<option value="0"><fmt:message key="aca.NoAplica" /></option>
						<%for(aca.catalogo.CatRegion region : lisRegion){ %>
							<option value="<%=region.getRegionId() %>" <%if(region.getRegionId().equals(Escuela.getRegionId())){out.print("selected");} %>><%=region.getRegionNombre() %></option>
						<%} %>
					</select>
				</fieldset>
				
			</div>

			<div class="span3">
			
				<fieldset>
					<label for="Sector"><fmt:message key="aca.Sector" /></label>
					<input name="Sector" type="text" id="Sector" value="<%=Escuela.getSector()==null?"":Escuela.getSector() %>" maxlength="40">
				</fieldset>
				
				<fieldset>
					<label for="Zona"><fmt:message key="aca.Zona" /></label>
					<input name="Zona" type="text" id="Zona" value="<%=Escuela.getZona()==null?"":Escuela.getZona() %>" maxlength="40">
				</fieldset>
			
				<fieldset>
					<label for="Logo"><fmt:message key="aca.Logo" /></label>
					<input name="Logo" type="text" id="Logo" value="<%=Escuela.getLogo()==null?"":Escuela.getLogo() %>" maxlength="15">
				</fieldset>
				
				<fieldset>
					<label for="Firma"> <fmt:message key="aca.Firma" /></label>
					<input name="Firma" type="text" id="Firma" value="<%=Escuela.getFirma()==null?"":Escuela.getFirma()%>" maxlength="15">
				</fieldset>
											
				<fieldset>
					<label for="Estado"> <fmt:message key="aca.Estado" /></label> 
					<select name="Estado"id="Estado">
						<option value="A" <%if (Escuela.getEstado().equals("A"))out.print("Selected");%>><fmt:message key="aca.Activo" /></option>
						<option value="I" <%if (Escuela.getEstado().equals("I"))out.print("Selected");%>><fmt:message key="aca.Inactivo" /></option>					
					</select>
				</fieldset>	
				
				<fieldset>	
					<label for="OrgId"> <fmt:message key="aca.OrgId" /></label>
					<input name="OrgId" type="text" id="OrgId" value="<%=Escuela.getOrgId()==null?"0":Escuela.getOrgId()%>" size="10" maxlength="10">
				</fieldset>
				
				<fieldset>	
					<label for="Eslogan"> <fmt:message key="aca.Eslogan" /></label>
					<input name="Eslogan" type="text" id="Eslogan" value="<%=Escuela.getEslogan()==null?"":Escuela.getEslogan()%>" maxlength="100">
				</fieldset>
				
			</div>
			
			<div class="span3">
				<fieldset>	
					<label for="Www"> <fmt:message key="aca.Www" /></label>
					<input name="Www" type="text" id="Www" value="<%=Escuela.getWww()==null?"":Escuela.getWww()%>" maxlength="30">
				</fieldset>
				<fieldset>	
					<label for="registro"> <fmt:message key="aca.Registro" /></label>
					<input name="registro" type="text" id="registro" value="<%=Escuela.getRegistro()==null?"":Escuela.getRegistro()%>" maxlength="30">
				</fieldset>
				
			</div>
		</div>

		<div class="well">
			<a class="btn btn-primary btn-large" href="accion.jsp?Accion=1&unionId=<%=unionId %>"><i class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a>
			<a class="btn btn-primary btn-large" href="javascript:Grabar();"><i class="icon-ok icon-white"></i> <fmt:message key="boton.Guardar" /></a>
			<%if(editar.equals("S")){%>
				<a class="btn btn-danger btn-large" href="javascript:Borrar()"><i class="icon-remove icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
			<%} %>
		</div>

	</form>
</div>

<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>