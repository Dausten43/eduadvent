<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<jsp:useBean id="Curso" scope="page" class="aca.plan.PlanCurso" />
<jsp:useBean id="PlanCursoLista"  class="aca.plan.PlanCursoLista" scope="page"/>
<jsp:useBean id="Ciclo" scope="page" class="aca.ciclo.CicloGrupoCurso" />
<jsp:useBean id="nivel" scope="page" class="aca.catalogo.CatNivelEscuela"/>

<%@ page import="java.util.HashMap" %>

<script>
	function CheckAccents(curso_id){
		let tmp_accents = [];
		
		tmp_accents.push(curso_id.match(/á/gi));
		tmp_accents.push(curso_id.match(/é/gi));
		tmp_accents.push(curso_id.match(/í/gi));
		tmp_accents.push(curso_id.match(/ó/gi));
		tmp_accents.push(curso_id.match(/ú/gi));
		
		tmp_accents = tmp_accents.filter((el) => el);

		return tmp_accents != false;
	}

	function IsValidCursoId(curso_id){
		let tmp_id = curso_id.replace(/\s+/g, '');
		if (tmp_id === '' || tmp_id.length < 4 || CheckAccents(tmp_id)) {
			alert("<fmt:message key="js.CursoIdErroneo" />");
			return false;
		}
		return true;
	}

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
		document.frmPlan.Falta.value = "S";
		document.frmPlan.Aspectos.value = "N";
		document.frmPlan.Accion.value = "1";
		document.frmPlan.BoletaAparece.value = "S";
		document.frmPlan.submit();
	}

	function Grabar() {
		let curso_id = document.getElementById("CursoId").value;
		
		if (document.frmPlan.CursoNombre.value != "" && IsValidCursoId(curso_id)) {
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

<% 
	// Declaración de variables
		// Declaracion de variables		
		String escuelaId 		= (String) session.getAttribute("escuela");
		String cursoId 			= request.getParameter("CursoId").replaceAll("}", "&");
		String planId			= request.getParameter("PlanId");	
		String cicloId			= (String) session.getAttribute("cicloId");
		String grado 			= request.getParameter("Grado");		
		
		int n_accion 		= Integer.parseInt(request.getParameter("Accion"));
		String strResultado = "";
		String salto			= "X";
		
		String nivelId 			= aca.plan.Plan.getNivel(conElias,planId);
		nivel.mapeaRegId(conElias, nivelId, escuelaId);		
		
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
			Curso.setAspectos(request.getParameter("Aspectos"));
			Curso.setConducta(request.getParameter("Conducta"));
			Curso.setOrden(request.getParameter("Orden"));
			Curso.setPunto(request.getParameter("Punto"));
			Curso.setHoras(request.getParameter("Horas"));
			Curso.setCreditos(request.getParameter("Creditos"));
			Curso.setEstado(request.getParameter("Estado"));
			Curso.setTipoEvaluacion(request.getParameter("TipoEvaluacion"));
			Curso.setCursoBase(request.getParameter("CursoBase"));		
			Curso.setBoleta(request.getParameter("BoletaAparece"));
			
			if(Curso.getCursoBase() == null){
				Curso.setCursoBase("-");
			}

			if (Curso.existeReg(conElias)) {

				if (Curso.updateReg(conElias)) {
					strResultado = "Modificado";
					Curso.mapeaRegId(conElias, planId); // mapeamos el registro que actualizamos
				} else {
					strResultado = "NoModifico";
				} 
			} else {
				if(Integer.parseInt(grado)<10) grado = "0"+grado;
				Curso.setCursoId(planId+request.getParameter("CursoId").toUpperCase()+grado);
				if (Ciclo.existeRegCursoId(conElias)) {
					strResultado = "Existe";
				} else if (Curso.insertReg(conElias)) {
					strResultado = "Guardado";
					cursoId = planId + request.getParameter("CursoId")+grado;
				}else {
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
						salto = "materia.jsp?PlanId="+planId;
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
		
		// Lista de cursos
		ArrayList<aca.plan.PlanCurso> lisCursos	= PlanCursoLista.getCursosPorGrado(conElias, planId, Curso.getGrado(), "ORDER BY CURSO_NOMBRE"); 
		HashMap<String, String> cursos = new HashMap<String, String>();
		
		for(aca.plan.PlanCurso curso:lisCursos){
			cursos.put(curso.getAspectos(),curso.getCursoId());
		}
		
		boolean existeCursoAspectos = false;
		
		for(aca.plan.PlanCurso curso : lisCursos){
			if(curso.getAspectos().contains("S")){
				existeCursoAspectos = true;
			}
		}
	
		pageContext.setAttribute("resultado", strResultado);		
%>		

	<div id="content">
		<h2>Datos de la Materia</h2>
		<% if (strResultado.equals("Eliminado") || strResultado.equals("Modificado") || strResultado.equals("Guardado")){%>
	   		<div class='alert alert-success'><fmt:message key="aca.${resultado}" /></div>
	  	<%} else if(!strResultado.equals("")){%>
			 <div class='alert alert-error'><fmt:message key="aca.${resultado}" /></div>
		<%}%>	
		
		<div class="well" style="overflow: hidden;">
		<a href="materia.jsp?PlanId=<%=planId%>"class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		</div>
	
		<form action="accion.jsp" method="post" name="frmPlan">
			<input type="hidden" name="Accion">
			<input type="hidden" name="PlanId" id="PlanId" value=<%=planId%>>

			<div class="row">
				<div class="span4">
					<fieldset>
						<div class="control-group ">
							<label for="CursoId"> <fmt:message key="aca.Clave" />: </label>
							<%
								if (n_accion != 1) {
							%>
								<input name="CursoId" type="hidden" id="CursoId" value="<%=cursoId%>"><%=cursoId%>
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
							<label for="CursoNombre"> <fmt:message key="aca.NombreMateria" />: </label>
							<input name="CursoNombre" type="text" id="CursoNombre" value="<%=Curso.getCursoNombre()%>" size="30" maxlength="70">
						</div>
						<div class="control-group ">
							<label for="CursoCorto"> <fmt:message key="aca.NombreCorto" />: </label>
							<input name="CursoCorto" type="text" id="CursoCorto" value="<%=Curso.getCursoCorto()%>" size="15" maxlength="20">
						</div>
						<div class="control-group ">
							<label for="Grado"> <fmt:message key="aca.GradoDondeImparte" />: </label>
							<select name="Grado" id="Grado" class="input-mini">
							<%for(int i = 1; i<=Integer.parseInt(nivel.getGradoFin()); i++){ %>
								<option value="<%=i %>" <%if(Curso.getGrado().equals(i+"")){out.print("selected");} %>><%=i %></option>
							<%} %>
							</select>
						</div>
						<div class="control-group ">
							<label for="Horas"> <fmt:message key="aca.HorasSemanales" />: </label>
							<input name="Horas" type="text" id="Horas" value="<%=Curso.getHoras()%>" class="input-mini" maxlength="3">
						</div>
						<div class="control-group ">
							<label for="Créditos"> <fmt:message key="aca.Creditos" />: </label> <input name="Creditos"
								type="text" id="Creditos" value="<%=Curso.getCreditos()%>"
								class="input-mini" maxlength="2">
						</div>						
					</fieldset>
				</div>
				
				<div class="span4">
					<fieldset>												
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
							<label for="Falta"> <fmt:message key="aca.RegistraFalta" />: </label>
							<select name="Falta" id="Falta">
								<option value="S" <%=Curso.getFalta().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>
								<option value="N" <%=Curso.getFalta().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
							</select>
						</div>						
						<div class="control-group ">
							<label for="Conducta"> <fmt:message key="aca.EvaluaConducta" />:</label><select
								name="Conducta" id="Conducta">
								<option value="S" <%=Curso.getConducta().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>
								<option value="N" <%=Curso.getConducta().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
								<option value="P" <%=Curso.getConducta().equals("P")?" Selected":""%>><fmt:message key="aca.Promedio" /></option>
							</select>
						</div>
						<%if(escuelaId.contains("H")){%>
							<div class="control-group ">
								<label for="Aspectos"> <fmt:message key="aca.HabitosyActitudes" />: </label>
								<select name="Aspectos" id="Aspectos">
									<option value="S" <%=Curso.getAspectos().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>
									<option value="N" <%=Curso.getAspectos().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
								</select>
							</div>
							
							<%if(existeCursoAspectos && !cursoId.equals(cursos.get("S"))){ //////*********NO SE DEBE SELECCIONAR SI EN LA CONFIG DE ASPECTOS*********\\\\\%>
								<script>
									document.getElementById("Aspectos").addEventListener('change', (e) => {
										const val = e.target.value;
										if(val === "S") e.target.value = "N";
										alert("Ya existe un curso evaluando este aspecto. Desactive el curso que contenga esta opción activa y vuelva a intentarlo.")
									});
								</script>								
						<%
							}
						}
						%>
						<div class="control-group ">
							<label for="Orden"> <fmt:message key="aca.Orden" />: </label> <input name="Orden"
								type="text" id="orden" value="<%=Curso.getOrden().equals("")?"1":Curso.getOrden()%>" class="input-mini"
								maxlength="2">
						</div>						
					</fieldset>
				</div>
				<div class="span4">
					<fieldset>												
						<div class="control-group ">
							<label for="Punto"><fmt:message key="aca.PuntoDecimal" /> </label>
							<select name="Punto" id="Punto">
								<option value="S" <%=Curso.getPunto().equals("S")?" Selected":""%>><fmt:message key="aca.Si" /></option>
								<option value="N" <%=Curso.getPunto().equals("N")?" Selected":""%>><fmt:message key="aca.Negacion" /></option>
							</select>
						</div>
						<div class="control-group ">
							<label for="Estado"> <fmt:message key="maestros.EstadoMateria" />: </label> <%//System.out.println((String) session.getAttribute("cicloId")+" "+ cursoId) ;%>
<%
					if( aca.plan.PlanCurso.existeReg(conElias, cursoId, cicloId) && aca.ciclo.Ciclo.getCicloActivo(conElias, cicloId)){
%>
							<input type="hidden" name="Estado" id="Estado" value="<%=Curso.getEstado()==null?"A":Curso.getEstado() %>" />
							<select disabled>
<%
					}else{
%>
							<select name="Estado" id="Estado">
<%
					}
%>
								<option value="A" <%if (Curso.getEstado()==null?false:Curso.getEstado().equals("A")) out.print("selected=\"selected\"");%>><fmt:message key="aca.Activo" /></option>
								<option value="I" <%if (Curso.getEstado()==null?false:Curso.getEstado().equals("I")) out.print("selected=\"selected\"");%>><fmt:message key="aca.Inactivo" /></option>
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
						<div class="control-group ">
<%
						if(!cursoId.equals("") && escuelaId.contains("H")){		
%>						
							<label for="CursoBase"> <fmt:message key="aca.CursoBase" />: </label>
							<select name="CursoBase" id="CursoBase">
								<option value="-" >No aplica</option>
							</select>
<%
						}		
%>							
						</div>					
							<%if (escuelaId.contains("H")){%>
							<div class="control-group ">	
								<label for="BoletaAparece"><fmt:message key="aca.BoletínAparece" />: </label>
								<select name="BoletaAparece" id="BoletaAparece">
									<option value="S" <%=Curso.getBoleta().equals("S")?" selected":""%>><fmt:message key="aca.Si" /></option>
									<option value="N" <%=Curso.getBoleta().equals("N")?" selected":""%>><fmt:message key="aca.Negacion" /></option>
								</select>
							</div>
							<%} %>
					</fieldset>
				</div>
			</div>
			<div class="well" style="overflow: hidden;">
			&nbsp; <a class="btn btn-primary"
				href="javascript:Nuevo('<%=planId%>')"><i
				class="icon-file icon-white"></i> <fmt:message key="boton.Nuevo" /></a> &nbsp;
<%		if (!strResultado.equals("Eliminado")){ %>	
				<a class="btn btn-primary" href="javascript:Grabar()"><i class="icon-ok  icon-white"></i> <fmt:message key="boton.Guardar" /></a> &nbsp;			
				<a class="btn btn-primary" href="javascript:Borrar()"><i class="icon-remove  icon-white"></i> <fmt:message key="boton.Eliminar" /></a>
<% 		}%>				
			</div>
		</form>
	</div>

<script>
	updateCursosBases();
	select();

	jQuery("#Grado").change(function(){
		select();
		updateCursosBases();
	})
	
	function select(){
		grado = $("#Grado").val();
		if(grado<10) grado = "0"+grado;
		jQuery(".grado").html(grado);
	}
	
	
	function updateCursosBases(){
		
		let data = {
			planId 		: $('#PlanId').val(),
			cursoBaseId : '<%=Curso.getCursoBase()%>',
			grado 		: $('#Grado').val()
		};
		
		if(data.cursoBaseId){
			$.ajax({
				url : 'ajaxMaterias.jsp',
				type : 'post',
				data : data,
				success : function(output) {
					$('#CursoBase').html("<option value='-' >No aplica</option>");
					$('#CursoBase').append(output);
				},
				error : function(xhr, ajaxOptions, thrownError) {
					console.log("error ");
					alert(xhr.status + " " + thrownError);
				}
			});
		}
	}
	
	
</script>
<% 	if (!salto.equals("X")){%>
		<meta http-equiv="refresh" content="0; url=<%=salto%>" />
<% 	}%>
<%@ include file="../../cierra_elias.jsp"%>