<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>


<jsp:useBean id="Curso" scope="page" class="aca.plan.PlanCurso" />
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>
<head>

<script>
	function Nuevo(planId) {
		document.frmPlan.PlanId.value = planId;
		document.frmPlan.CursoId.value = "";
		document.frmPlan.CursoNombre.value = "";
		document.frmPlan.CursoCorto.value = "";
		document.frmPlan.Grado.value = "0";
		document.frmPlan.Creditos.value = "0";
		document.frmPlan.Horas.value = "0";
		document.frmPlan.NotaAC.value = "0";
		document.frmPlan.Tipocurso.value = "";
		document.frmPlan.Accion.value = "1";
		document.frmPlan.submit();
	}

	function Grabar() {
		if (document.frmPlan.CursoId.value != "" && document.frmPlan.CursoNombre.value != "" && document.frmPlan.CursoId.value.length >= 4) {
			document.frmPlan.Accion.value = "2";
			document.frmPlan.submit();
		}else{
			alert("<fmt:message key="js.Completar" />");
		}
	}

	function Borrar() {
		if (document.frmPlan.CursoId.value != "") {
			if (confirm("<fmt:message key="js.Confirma" />") == true) {
				document.frmPlan.Accion.value = "4";
				document.frmPlan.submit();
			}
		} else {
			alert("<fmt:message key="js.EscribaClave" />");
			document.frmPlan.CursoId.focus();
		}
	}

	function Consultar() {
		document.frmPlan.Accion.value = "5";
		document.frmPlan.submit();
	}
</script>
</head>
<%
	// Declaración de variables
		// Declaracion de variables		
		String escuelaId 		= (String) session.getAttribute("escuela");
		String cursoId 			= request.getParameter("CursoId").replaceAll("}", "&");
		String planId			= request.getParameter("PlanId");		

		int n_accion 		= Integer.parseInt(request.getParameter("Accion"));
		String strResultado = "";
		
		nivel.mapeaRegId(conElias, request.getParameter("nivelId"), escuelaId);		
		
		Curso.setCursoId(cursoId.toUpperCase());
		if (Curso.existeReg(conElias)) {
			Curso.mapeaRegId(conElias, cursoId);
		}
		// Operaciones a realizar en la pantalla
		switch (n_accion) {

		case 1: { // Nuevo
			Curso.setGrado("0");
			Curso.setHoras("0");
			Curso.setCreditos("0");
			Curso.setPunto("N");
			Curso.setNotaAc("6");
			
			// Si es de la union de panamá
			if (escuelaId.contains("H")){
				Curso.setNotaAc("3");
				Curso.setPunto("S");	
			}else{
				Curso.setPunto("N");
				Curso.setNotaAc("6");
			}
	
			break;
		}

		case 2: { // Grabar

			Curso.setPlanId(planId);
			Curso.setCursoId(request.getParameter("CursoId").toUpperCase());
			Curso.setCursoNombre(request.getParameter("CursoNombre"));
			Curso.setCursoCorto(request.getParameter("CursoCorto"));
			Curso.setGrado(request.getParameter("Grado"));
			Curso.setNotaAc(request.getParameter("NotaAC"));
			Curso.setTipocursoId(request.getParameter("Tipocurso"));
			Curso.setFalta(request.getParameter("Falta"));
			Curso.setConducta(request.getParameter("Conducta"));
			Curso.setOrden(request.getParameter("Orden"));
			Curso.setPunto(request.getParameter("Punto"));
			Curso.setHoras(request.getParameter("Horas"));
			Curso.setCreditos(request.getParameter("Creditos"));
			Curso.setEstado(request.getParameter("Estado"));
			Curso.setTipoEvaluacion(request.getParameter("TipoEvaluacion"));

			if (Curso.existeReg(conElias)) {

				if (Curso.updateReg(conElias)) {
					strResultado = "Modificado";
					Curso.mapeaRegId(conElias, planId); // mapeamos el registro que actualizamos
				} else {
					strResultado = "NoModifico";
				}
			} else {
				String grado = request.getParameter("Grado");
				if(Integer.parseInt(grado)<10) grado = "0"+grado;
				Curso.setCursoId(planId+request.getParameter("CursoId").toUpperCase()+grado);
				if (Ciclo.existeRegCursoId(conElias)) {
					strResultado = "Existe";
				} else if (Curso.insertReg(conElias)) {
					strResultado = "Guardado";
					cursoId = planId + request.getParameter("CursoId")+grado;
				} else {
						strResultado = "NoGuardo";
						n_accion = 1;
				}
			}
			break;
		}

		case 4: { // Borrar
			conElias.setAutoCommit(false);
			Ciclo.setCursoId(Curso.getCursoId());
			if (!Ciclo.existeRegCursoId(conElias)) {
				if (Curso.existeReg(conElias) == true) {
					if (Curso.deleteReg(conElias)) {
						strResultado = "Eliminado";
						conElias.commit();
					} else {
						strResultado = "NoElimino";
					}
				} else {
					strResultado = "NoExiste";
				}
			} else {
				strResultado = "DependenciaError";
			}
			conElias.setAutoCommit(true);
			break;
		}

		case 5: { // Consultar
			if (Curso.existeReg(conElias) == true) {
				Curso.mapeaRegId(conElias, cursoId);
			}
			break;
		}
		}
		
		pageContext.setAttribute("resultado", strResultado);
%>
<body>
	<div id="content">
		<h2>Datos de la Materia</h2>
		<% if (strResultado.equals("Eliminado") || strResultado.equals("Modificado") || strResultado.equals("Guardado")){%>
	   		<div class='alert alert-info'><fmt:message key="aca.${resultado}" /></div>
	  	<% }else if(!strResultado.equals("")){%>
	  		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
	  	<%} %>

		<div class="well" style="overflow: hidden;">
		<a href="materia.jsp?PlanId=<%=planId%>"class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>

		<form action="accion.jsp" method="post" name="frmPlan">
			<input type="hidden" name="Accion"> 
			<input type="hidden" name="PlanId" value=<%=planId%>>

			<div class="row">
				<div class="span4">
					<fieldset>
						<div class="control-group ">

							<label for="CursoId"> <fmt:message key="aca.Clave" />: </label>
							<%
								if (n_accion != 1) {
							%>
								<input name="CursoId" type="hidden" value="<%=cursoId%>"><%=cursoId%>
							<%
								} else {
							%>
							<div class="input-prepend input-append">
						  		<span class="add-on"><%=planId%></span>
						  		<input class="input-small" id="CursoId" name="CursoId" type="text"value="<%=cursoId%>" maxlength="4">
						  		<span class="add-on grado"></span>
							</div>
							<%
								}
							%>
						</div>
						
						<div class="control-group ">
							<label for="CursoNombre"> <fmt:message key="aca.Nombre" />: </label> <input
								name="CursoNombre" type="text" id="CursoNombre"
								value="<%=Curso.getCursoNombre()%>" size="30" maxlength="70">
						</div>
						<div class="control-group ">
							<label for="CursoCorto"> <fmt:message key="aca.NombreCorto" />: </label> <input
								name="CursoCorto" type="text" id="CursoCorto"
								value="<%=Curso.getCursoCorto()%>" size="15" maxlength="20">
						</div>
						<div class="control-group ">
							<label for="Grado"> <fmt:message key="aca.Grado" />: </label>							
								
								 <select name="Grado" id="Grado" class="input-mini">
							    	<%for(int i = 1; i<=12; i++){ %>
							    		<option value="<%=i %>" <%if(Curso.getGrado().equals(i+"")){out.print("selected");} %>><%=i %></option>
							    	<%} %>
							    </select>
						</div>
						<div class="control-group ">
							<label for="Horas"> <fmt:message key="aca.Horas" />: </label> <input name="Horas"
								type="text" id="Horas" value="<%=Curso.getHoras()%>" class="input-mini"
								maxlength="3">
						</div>
					</fieldset>
				</div>


				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label for="Créditos"> <fmt:message key="aca.Creditos" />: </label> <input name="Creditos"
								type="text" id="Creditos" value="<%=Curso.getCreditos()%>"
								class="input-mini" maxlength="2">
						</div>
						<div class="control-group ">
							<label for="NotaAC"> <fmt:message key="aca.NotaAprobatoria" />: </label> <input
								name="NotaAC" type="text" id="NotaAC"
								value="<%=Curso.getNotaAc()%>" class="input-mini" maxlength="2">
						</div>
						<div class="control-group ">
							<label for="Tipocurso"> <fmt:message key="aca.TipoCurso" />: </label><select
								name="Tipocurso" id="Tipocurso">
								<option value="1"
									<%if (Curso.getTipocursoId().equals("1"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Oficial" /></option>
								<option value="2"
									<%if (Curso.getTipocursoId().equals("2"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.NoOficial" /></option>
								<option value="3"
									<%if (Curso.getTipocursoId().equals("3"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Ingles" /></option>
							</select>
						</div>
						<div class="control-group ">
							<label for="Falta"> <fmt:message key="aca.RegistraFalta" />: </label><select name="Falta"
								id="Falta">
								<option value="S"
									<%if (Curso.getFalta().equals("S"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Si" /></option>
								<option value="N"
									<%if (Curso.getFalta().equals("N"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Negacion" /></option>
							</select>
						</div>
						<div class="control-group ">
							<label for="Conducta"> <fmt:message key="aca.EvaluaConducta" />:</label><select
								name="Conducta" id="Conducta">
								<option value="S"
									<%if (Curso.getConducta().equals("S"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Si" /></option>
								<option value="N"
									<%if (Curso.getConducta().equals("N"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Negacion" /></option>
								<option value="P"
									<%if (Curso.getConducta().equals("P"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Promedio" /></option>
							</select>
						</div>
					</fieldset>
				</div>

				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label for="Orden"> <fmt:message key="aca.Orden" />: </label> <input name="Orden"
								type="text" id="orden" value="<%=Curso.getOrden().equals("")?"1":Curso.getOrden()%>" class="input-mini"
								maxlength="2">
						</div>
						<div class="control-group ">
							<label for="Punto"><fmt:message key="aca.PuntoDecimal" /> </label>
							<select name="Punto" id="Punto">
								<option value="S" <%if (Curso.getPunto().equals("S")) out.print("selected='selected'");%>>
								  <fmt:message key="aca.Si" />
								</option>
								<option value="N" <%if (Curso.getPunto().equals("N")) out.print("selected='selected'");%>>
								  <fmt:message key="aca.Negacion" />
								</option>
							</select>
						</div>
						<div class="control-group ">
							<label for="Estado"> <fmt:message key="aca.Estado" />: </label> <select name="Estado"
								id="Estado">
								<option value="A"
									<%if (Curso.getEstado().equals("A"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Activo" /></option>
								<option value="I"
									<%if (Curso.getEstado().equals("I"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Inactivo" /></option>
							</select>
						</div>
						<div class="control-group ">
							<label for="TipoEvaluacion"> <fmt:message key="aca.TipoEval" />: </label> <select
								name="TipoEvaluacion" id="TipoEvaluacion">
								<option value="C"
									<%if (Curso.getTipoEvaluacion().equals("C"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Calculado" /></option>
								<option value="P"
									<%if (Curso.getTipoEvaluacion().equals("P"))
					out.print("selected=\"selected\"");%>><fmt:message key="aca.Pase" /></option>
							</select>
						</div>
					</fieldset>
				</div>
			</div>
		</form>

		<div class="well" style="overflow: hidden;">
			&nbsp; <a class="btn btn-primary"
				href="javascript:Nuevo('<%=planId%>')"><i
				class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a> &nbsp;
<%		if (!strResultado.equals("Eliminado")){ %>	
				<a class="btn btn-primary" href="javascript:Grabar()"><i class="icon-ok  icon-white"></i> <fmt:message key="boton.Guardar" /></a> &nbsp;			
				<a class="btn btn-primary" href="javascript:Borrar()"><i class="icon-remove  icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
<% 		}%>				
		</div>
	</div>
</body>
<script>
	select();

	jQuery("#Grado").change(function(){
		select();
	})
	
	function select(){
		grado = $("#Grado").val();
		if(grado<10) grado = "0"+grado;
		jQuery(".grado").html(grado);
	}
</script>

<%@ include file="../../cierra_elias.jsp"%>