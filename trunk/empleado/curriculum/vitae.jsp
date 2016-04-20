<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@page import="aca.catalogo.CatPais"%>
<jsp:useBean id="empCurriculum" class="aca.empleado.EmpCurriculum" scope="page"/>
<jsp:useBean id="catPais" class="aca.catalogo.CatPais" scope="page"/>
<jsp:useBean id="catPaisU" class="aca.catalogo.CatPaisLista" scope="page"/>
<%
	String codigoPersonal 	= (String) session.getAttribute("codigoId");
	String respuesta 		= "";
	int accion 				= Integer.parseInt(request.getParameter("Accion")==null?"0":request.getParameter("Accion"));
	boolean error 			= false;
	
	ArrayList<CatPais> listPais = catPaisU.getListAll(conElias, "ORDER BY PAIS_NOMBRE");
	
	//if(codigoPersonal.trim().equals("9800100"))
		//codigoPersonal = (String) session.getAttribute("codigoEmpleado");
	
	empCurriculum.setIdEmpleado(codigoPersonal);
	if(empCurriculum.existeReg(conElias))
		empCurriculum.mapeaRegId(conElias, codigoPersonal);
	
	switch(accion){
		case 2:{//Guardar
			conElias.setAutoCommit(false);
			empCurriculum.setIdEmpleado(codigoPersonal);
			empCurriculum.setLugarNac(request.getParameter("lugarNac"));
			empCurriculum.setTProfesional(request.getParameter("tProfesional"));
			empCurriculum.setGPosgrado(request.getParameter("gPosgrado"));
			empCurriculum.setTUniversitario(request.getParameter("tUniversitario"));
			empCurriculum.setRespActual(request.getParameter("respActual"));
			empCurriculum.setRespAnterior(request.getParameter("respAnterior"));
			empCurriculum.setExpDocente(request.getParameter("expDocente"));
			empCurriculum.setFNacimiento(request.getParameter("fNacimiento"));
			empCurriculum.setNacionalidad(request.getParameter("nacionalidad"));			
			if(empCurriculum.existeReg(conElias)){
				if(!empCurriculum.updateReg(conElias))
					error = true;
			}else{
				if(!empCurriculum.insertReg(conElias))
					error = true;
			}
			if(error){
				conElias.rollback();
				respuesta = "ErrorAlGrabar";
			}else{
				conElias.commit();
				respuesta = "Datosguardados";
			}
			conElias.setAutoCommit(true);
		}break;
	}
	
	pageContext.setAttribute("respuesta", respuesta);
%>
<head>
	<script type="text/javascript">
		function revisaForma(){
			if(document.forma.fNacimiento.value != "" &&
			   document.forma.tProfesional.value != "" &&
			   document.forma.tUniversitario.value != ""){
				return true;
			}else{
				alert("<fmt:message key="js.CompletaCamposAsterisco" />");
			}
			return false;
		}
	</script>
</head>
<body>
<%
	if(!respuesta.equals("")){
%>
	<table align="center">
		<tr>
<%if(!respuesta.equals("")){
%> 
			<td><fmt:message key="aca.${respuesta}" /></td>
<%	
}

%>		
		</tr>
	</table>
<%
	}
%>
	<table align="center">
		<tr>
			<td><font size="4"><b><fmt:message key="empleados.Curriculum" /></b></font></td>
		</tr>
	</table>
	<form id="forma" name="forma" action="vitae.jsp?Accion=2" method="post">
		<table width="850px" align="center">
			<tr>
				<td><font size="4"><fmt:message key="empleados.DatosPersonales" /></font></td>
			</tr>
			<tr>
				<td style="border: solid 1px black;">
					<table width="100%">
						<tr>
							<td><b><fmt:message key="aca.NombreCompleto" />:</b></td>
						</tr>
						<tr>
							<td><%=aca.empleado.EmpPersonal.getNombre(conElias,codigoPersonal,"NOMBRE") %></td>
						</tr>
						<tr>
							<td><b><fmt:message key="aca.FechaLugarNac" />:</b></td>
						</tr>
						<tr>
							<td>
								<fmt:message key="aca.Fecha" />:<br>
								<input type="text" class="text" id="fNacimiento" name="fNacimiento" value="<%=empCurriculum.getFNacimiento() %>" onfocus="focusFecha(this);" size="10" maxlength="10">
            					 [DD/MM/AAAA]<br>
            					<fmt:message key="aca.Lugar" />:<br><input type="text" class="text" id="lugarNac" name="lugarNac" value="<%=empCurriculum.getLugarNac() %>" size="60" maxlength="95" />
							</td>
						</tr>
						<tr>
							<td><b><fmt:message key="aca.Nacionalidad" />:</b></td>
						</tr>
						<tr>
							<td>
								<select id="nacionalida" name="nacionalidad">
<%
	for(int i = 0; i < listPais.size(); i++){
		catPais = (CatPais) listPais.get(i);
%>
									<option value="<%=catPais.getPaisId() %>"<%=catPais.getPaisId().equals(empCurriculum.getNacionalidad())?" Selected":"" %>><%=catPais.getPaisNombre() %></option>
<%
	}
%>
								</select>
							</td>
						</tr>
						<tr>
							<td><b><fmt:message key="aca.TituloProfesional" />:</b></td>
						</tr>
						<tr>
							<td><input type="text" class="text" id="tProfesional" name="tProfesional" value="<%=empCurriculum.getTProfesional() %>" size="60" maxlength="195" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><font size="4"><fmt:message key="aca.FormacionAcademica" /></font></td>
			</tr>
			<tr>
				<td style="border: solid 1px black;">
					<table width="100%">
						<tr>
							<td><b><fmt:message key="aca.GradoDePosgrado" />:</b></td>
						</tr>
						<tr>
							<td><input type="text" class="text" id="gPosgrado" name="gPosgrado" value="<%=empCurriculum.getGPosgrado() %>" size="60" maxlength="195" /></td>
						</tr>
						<tr>
							<td><b><fmt:message key="aca.TituloUniversitario" />:</b></td>
						</tr>
						<tr>
							<td><input type="text" class="text" id="tUniversitario" name="tUniversitario" value="<%=empCurriculum.getTUniversitario() %>" size="60" maxlength="195" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><font size="4"><fmt:message key="aca.ExperienciaProfesional" /></font></td>
			</tr>
			<tr>
				<td style="border: solid 1px black;">
					<table width="100%">
						<tr>
							<td><b><fmt:message key="aca.ResponsabilidadActual" />:</b></td>
						</tr>
						<tr>
							<td><textarea id="respActual" name="respActual" cols="60" rows="4"><%=empCurriculum.getRespActual() %></textarea></td>
						</tr>
						<tr>
							<td><b><fmt:message key="aca.ResponsabilidadAnterior" /></b></td>
						</tr>
						<tr>
							<td><textarea id="respAnterior" name="respAnterior" cols="60" rows="4"><%=empCurriculum.getRespAnterior() %></textarea></td>
						</tr>
						<tr>
							<td><b><fmt:message key="aca.ExperienciaDocente" />:</b></td>
						</tr>
						<tr>
							<td><textarea id="expDocente" name="expDocente" cols="60" rows="4"><%=empCurriculum.getExpDocente() %></textarea></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="center"><input type="submit" class="button" value="<fmt:message key="boton.Guardar" />" onclick="return revisaForma();" /></td>
			</tr>
		</table>
	</form>
</body>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
	$('#fNacimiento').datepicker();
</script>
<%@ include file= "../../cierra_elias.jsp" %>