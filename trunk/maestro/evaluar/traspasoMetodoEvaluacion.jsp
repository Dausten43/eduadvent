
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%@page import="java.text.*"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="aca.ciclo.CicloGrupoActividadLista"%>
<%@page import="aca.ciclo.CicloGrupoActividad"%>
<%@page import="aca.ciclo.CicloGrupoCurso"%>
<%@page import="com.google.gson.Gson"%>

<jsp:useBean id="cicloGrupoActividadLista" scope="page" class="aca.ciclo.CicloGrupoActividadLista" />
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista" />
<%
	String codigoId				= (String) session.getAttribute("codigoEmpleado");
	String escuelaId 			= (String) session.getAttribute("escuela");

	String cursoId 				= request.getParameter("CursoId")==null?"":request.getParameter("CursoId");
	String cicloGrupoId 		= request.getParameter("CicloGrupoId")==null?"":request.getParameter("CicloGrupoId");
	String evaluacionId			= request.getParameter("EvaluacionId")==null?"":request.getParameter("EvaluacionId");
	String cicloId 				= request.getParameter("CicloId")== null?aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId):request.getParameter("CicloId");									
	
	ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID"); //Lista de ciclos activos
	ArrayList<CicloGrupoActividad> lisActEvaluacion	= cicloGrupoActividadLista.getListEvaluacion(conElias, cicloGrupoId, cursoId, evaluacionId, " ORDER BY ACTIVIDAD_ID");//Actividades de la evaluacion

%>
<style>
	select{
		width:auto;
	}
</style>
<div id="content">
	<h2>Traspasar método de evaluación</h2>
	<div class='alert alert-success' id="guardo" ><fmt:message key="aca.Guardado" /></div>
	<div class='alert alert-danger' id="noguardo" ><fmt:message key="aca.NoGuardo" /></div>
	<div class="well"> 
			  <a class="btn btn-primary" href="metodo.jsp?CursoId=<%=cursoId %>&CicloGrupoId=<%=cicloGrupoId%>"><i class="icon icon-th-list icon-white"></i> <fmt:message key="aca.Evaluaciones" /></a>
			  &nbsp;&nbsp;<strong>Plan: </strong><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoId))%>
			  &nbsp;&nbsp;<strong>Materia: </strong> <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%>
			  &nbsp;&nbsp;<strong>Grado: </strong><%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%>
	</div>	
	<table class="table table-condensed table-bordered">
		<tr>
			<th style="width:65px;" >
				<fmt:message key="aca.Elegir" />
				<input type="checkbox" id="choose-all">
			</th>
			<th><fmt:message key="aca.Actividad" /></th>
			<th><fmt:message key="aca.FechaEntrega" /></th>
			<th><fmt:message key="aca.Valor" /> </th> 
			<th><fmt:message key="aca.Mostrar" /> </th>	
		</tr>
		<% 
	for (int i=0; i < lisActEvaluacion.size(); i++){
		aca.ciclo.CicloGrupoActividad act = (aca.ciclo.CicloGrupoActividad) lisActEvaluacion.get(i);		
%>	
		<tr>
			<td> <input type="checkbox" class="actividad-id" value="<%= act.getActividadId()%>"> </td> 
			<td> <%=act.getActividadNombre()%> </td>
			<td> <%=act.getFecha()%> </td>
			<td> <%=act.getValor()%>%</td>
			<td> <%= act.getMostrar().equals("S")?"SI":"NO" %></td>			
		</tr>			 		
<% 	
	}
%>				
	</table>
	
	<div id="form_grid" class="container-fluid">
	<section class="busqueda_grupo">
		<form class="form-inline">
				<select name="ciclo_id" id="cicloid" class="form-control" style="width:auto;">
					<option value="" disabled selected>Seleccione un ciclo</option>
					
					<%
					Collections.reverse(lisCiclo);
					for (aca.ciclo.Ciclo c : lisCiclo) {
						int x = CicloGrupoCurso.numCursosMaestro(conElias, c.getCicloId() , codigoId);
						if (x > 0){
					%>
						<option value="<%=c.getCicloId()%>"><%=c.getCicloNombre()%></option>
					<%
						}
					}
					%>
					
				</select>
			
				<select name="curso_id" id="cursoid" class="form-control">
					<option	>Antes seleccione un ciclo</option>
				</select>
				<select name="promedio_id" id="promedioid" class="form-control">
					<option>Antes seleccione un curso</option>
				</select>
				<select name="evaluacion_id" id="evaluacionid" class="form-control">
					<option>Antes seleccione un promedio</option>
				</select>
			
				<input type="button" id="btnConfirm" value="Traspasar" class="btn btn-primary">
		</form>
	</section>
	</div>
</div>
<script>
	resetMessage();
	$('#btnConfirm').attr("disabled", true);
	
	$('#cicloid').change(function(e){
		updateInfo('curso');
	});

	$('#cursoid').change(function(e){
		updateInfo('promedio');
	});

	$('#promedioid').change(function(e){
		updateInfo('evaluacion');
	});

	$('#evaluacionid').change(function(e){
		$('#btnConfirm').attr("disabled", false);
	});

	$('#btnConfirm').click(function(e){
		if(confirm("¿Estás seguro que deseas traspasar las actividades?")){
			save();
		}
	});

	document.getElementById('btnConfirm');

	function updateInfo(tipo){
		resetMessage();
		
		let data = {
			tipo,
			codigoId		: '<%=codigoId%>',
			cicloGrupoId	: $('#cursoid').find(':selected').data("ciclo-grupo-id"),
			cicloId			: $('#cicloid').val(),
			cursoId 		: $('#cursoid').val(),
			promedioId 		: $('#promedioid').val(),
			evaluacionId	: $('#evaluacionid').val()
		};

		$.ajax({
			url : 'ajaxEvaluaciones.jsp',
			type : 'post',
			data : data,
			success : function (output){
				$('#'+tipo+'id').show();
				$('#'+tipo+'id').html("<option value='' disabled selected > Seleccione " + tipo + "</option>");
				$('#'+tipo+'id').append(output);
				$('#btnConfirm').attr("disabled", true);
			},
			error : function (xhr, ajaxOptions, thrownError) {
				console.log("error ");
				alert(xhr.status + " " + thrownError);
			}
		});
	}
	function save(){
		resetMessage();
		
		let data = {
			tipo			: 'guardar',
			codigoId		: '<%=codigoId%>',
			cicloGrupoId	: $('#cursoid').find(':selected').data("ciclo-grupo-id"),
			cicloId			: $('#cicloid').val(),
			cursoId 		: $('#cursoid').val(),
			promedioId 		: $('#promedioid').val(),
			evaluacionId	: $('#evaluacionid').val(),
			listaActividades: '<%= new Gson().toJson(lisActEvaluacion) %>',
			listaid			: $( "input.actividad-id:checked" ).map((index, input) => input.value).get()
		}
		
		$.ajax({
			url : 'ajaxEvaluaciones.jsp',
			type : 'post',
			data : data,
			success : function (output){
				if(output.isOk){
					updateInfo('evaluacion');
					$('#guardo').show();
				}else {
					$('#noguardo').show();
				}
			},
			error : function (xhr, ajaxOptions, thrownError) {
				resetMessage();
				console.log("error ");
				alert(xhr.status + " " + thrownError);
			},
			complete : function () {
				$('#btnConfirm').attr("disabled", false);
			}
		});
	}

	$('#choose-all').on('change', function() {
		$('input').each((_, checkbox) => {
			checkbox.checked = this.checked;
		});
	});

	function resetMessage(){
		$('#guardo').hide();
		$('#noguardo').hide();
	}
</script>
<%@ include file="../../cierra_elias.jsp"%>