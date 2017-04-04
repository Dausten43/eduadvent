<%@page import="java.util.ArrayList"%>
<%@page import="aca.preescolar.CicloActividadEvaluacionPromedio"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="aca.preescolar.UtilPreescolar"%>


<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%
	String cicloid = request.getParameter("ciclo_id") != null
				? request.getParameter("ciclo_id")
				: "H981717A";
		String cursoid = request.getParameter("curso_id") != null
				? request.getParameter("curso_id")
				: "H98-03HABI01";
		String ciclogrupoid = request.getParameter("ciclo_grupo_id") != null
				? request.getParameter("ciclo_grupo_id")
				: "H981717A001";

		UtilPreescolar up = new UtilPreescolar();

		List<CicloActividadEvaluacionPromedio> lsCAP = new ArrayList();
		lsCAP.addAll(up.getCAEP(cicloid, cursoid, ciclogrupoid));
		Map<Integer, CicloActividadEvaluacionPromedio> mapCAEP = new LinkedHashMap();
		for (CicloActividadEvaluacionPromedio p : lsCAP) {
			if (!mapCAEP.containsKey(p.getPromedioId())) {
				mapCAEP.put(p.getPromedioId(), p);
			}

		}
		up.close();
%>

<div class="container">
<h2>Crear actividades para el curso</h2>
<div class="well well-sm">
<a class="btn btn-primary stopPropagation" href="metodo_kinder.jsp?CursoId=<%= cursoid %>&CicloGrupoId=<%= ciclogrupoid %>"><i class="icon icon-backward icon-white"></i> <fmt:message key="aca.MetodoEval" /></a>
 &nbsp;&nbsp;<strong>Plan: </strong><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoid))%>
			  &nbsp;&nbsp;<strong>Materia: </strong> <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoid)%>
			  &nbsp;&nbsp;<strong>Grado: </strong><%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, ciclogrupoid)%>
</div>
	<form name="formActividad" method="post">
		<table style="width: 100%;" class="table">
			<tr><td><div class="col-md-2">

						<label for="selectA">Area:</label> 
						<select id="sPromedio" class="form-control">
							<option value="">Seleccione...</option>
							<%
								for (Integer pr : mapCAEP.keySet()) {
							%>
							<option value="<%=pr%>"><%=mapCAEP.get(pr).getNombrePromedio()%></option>
							<%
								}
							%>
						</select>




					</div></td>
				<td><div id="evaluacion" class="form-group "></div></td>
				<td><div id="actividad" class="form-group  "></div></td>
				<td style="width: 10%"></td>
			</tr>
			<tr>
				<td style="width: 30%"><label for="selectA">Actividad:</label>
				<input type="text" id="factividad"></td>
				<td style="width: 30%"><label for="selectA">Observación:</label>
				<input type="text" id="fobservacion"></td>
				<td style="width: 30%; display: table-cell;  vertical-align: middle;">
					<input type="hidden" name="cicloid" id="cicloid" value="<%=cicloid%>">
					<input type="hidden" name="cursoid" id="cursoid" value="<%= cursoid %>"> 
					<input type="hidden" name="ciclogrupoid" id="ciclogrupoid" value="<%=ciclogrupoid%>">
					<input type="submit"
					onclick="guardaFormulario(); return false;" class="btn btn-primary"
					value="Guardar">
				</td>
				<td>
				
				</td>
			</tr>
		</table>
	</form>

	<div id="tablaResultados"></div>

</div>


<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script>

	$('#sPromedio').change(function(e) {
		
		
		var selectValue = $(this).val();
		var cicloid ='<%=cicloid%>';
		var cursoid = '<%=cursoid%>';
		var ciclogrupoid = '<%=ciclogrupoid%>';
		
		
		$('#evaluacion').empty();
		$('#actividad').empty();
		$('#formTarea').empty();
		$('#tablaResultados').empty();
		var datadata = 'ciclo_id='+cicloid+'&curso_id='+cursoid+'&ciclo_grupo_id='+ciclogrupoid+'&promedioid='+ selectValue +'&selectEvaluacion=true';
		if(selectValue!=''){
		$.ajax({
			url : 'ajaxActividadesKinder.jsp',
			type : 'post',
			data : datadata,
			success : function(output){
				$('#evaluacion').html(output);
			},
			error: function(xhr, ajaxOptions, thrownError){
				alert(xhr.status + " " + thrownError);
			}
		});
	}
	});
	
	
	$('#evaluacion').change(function(e) {
		//console.log("entro a sevaluacion");
		
		var selectValue = $('#sEvaluacion').val();
		var cicloid ='<%=cicloid%>';
		var cursoid = '<%=cursoid%>';
		var ciclogrupoid = '<%=ciclogrupoid%>';
				var promedioid = $('#sPromedio').val();
				$('#actividad').empty();
				$('#formTarea').empty();
				$('#tablaResultados').empty();

				var datadata = 'ciclo_id=' + cicloid + '&curso_id=' + cursoid
						+ '&ciclo_grupo_id=' + ciclogrupoid + '&evaluacionid='
						+ selectValue + '&promedioid=' + promedioid
						+ '&selectActividad=true';
				if (selectValue != '') {
					$.ajax({
						url : 'ajaxActividadesKinder.jsp',
						type : 'post',
						data : datadata,
						success : function(output) {
							$('#actividad').html(output);
						},
						error : function(xhr, ajaxOptions, thrownError) {
							console.log("error " + datadata);
							alert(xhr.status + " " + thrownError);
						}
					});
				}
			});
	
	$('#actividad').change(function(e) {
		//console.log("cambio periodo");
		
		var selectValue = $('#sActividad').val();
		var cicloid ='<%=cicloid%>';
		var cursoid = '<%=cursoid%>';
		var ciclogrupoid = '<%=ciclogrupoid%>';
					var promedioid = $('#sPromedio').val();
					var evaluacionid = $('#sEvaluacion').val();

					var datadata = 'cicloid=' + cicloid + '&cursoid=' + cursoid
							+ '&ciclogrupoid=' + ciclogrupoid + '&actividadid='
							+ selectValue + '&promedioid=' + promedioid
							+ '&evaluacionid=' + evaluacionid;
					+'&selectActividad=true';
					//console.log(datadata);
					
					$('#tablaResultados').empty();
					if(selectValue!=''){
// 					$.ajax({
// 						url : 'ajaxFormKinder.jsp',
// 						type : 'post',
// 						data : datadata,
// 						success : function(output) {
// 							$('#formTarea').html(output);
// 						},
// 						error : function(xhr, ajaxOptions, thrownError) {
// 							console.log("error " + datadata);
// 							alert(xhr.status + " " + thrownError);
// 						}
// 					});
					$.ajax({
						url : 'ajaxTableTareas.jsp',
						type : 'post',
						data : datadata,
						success : function(output) {
							$('#tablaResultados').html(output);
						},
						error : function(xhr, ajaxOptions, thrownError) {
							console.log("error " + datadata);
							alert(xhr.status + " " + thrownError);
						}
					});
					}
				});
	
	function guardaFormulario(){
		
		var actividadid = $('#sActividad').val();
		var cicloid =$('#cicloid').val();
		var cursoid = $('#cursoid').val();
		var ciclogrupoid = $('#ciclogrupoid').val();
		var promedioid = $('#sPromedio').val();
		var evaluacionid = $('#sEvaluacion').val();
		var actividad = $('#factividad').val();
		var observacion = $('#fobservacion').val();
		$('#tablaResultados').empty();
					var datadata = 'cicloid=' + cicloid + '&cursoid=' + cursoid
							+ '&ciclogrupoid=' + ciclogrupoid + '&actividadid='
							+ actividadid + '&promedioid=' + promedioid
							+ '&evaluacionid=' + evaluacionid 
							+ '&actividad='+actividad
							+ '&observacion=' +observacion 
					+'&guardar=true';
					if(actividad!=''){
					//console.log("entra a agregar " + datadata);
					$.ajax({
						url : 'ajaxTableTareas.jsp',
						type : 'post',
						data : datadata,
						success : function(output) {
							$('#tablaResultados').html(output);
							
							
						},
						error : function(xhr, ajaxOptions, thrownError) {
							console.log("error " + datadata);
							alert(xhr.status + " " + thrownError);
							
						}
						
						
					});
// 					$.ajax({
// 						url : 'ajaxFormKinder.jsp',
// 						type : 'post',
// 						data : datadata,
// 						success : function(output) {
// 							$('#formTarea').html(output);
// 						},
// 						error : function(xhr, ajaxOptions, thrownError) {
// 							console.log("error " + datadata);
// 							alert(xhr.status + " " + thrownError);
// 						}
// 					});
					}else{
						alert('El campo de \"actividad\" es requerido');
						$('#actividad').trigger("change");
					}
					
	}
	
	function quitar( idtarea ){
		
		var tarea = idtarea;
		
		var datadata= 'id_kinder_tarea='+tarea+'&quitar=true';
		if(confirm("Confirma eliminar el dato")){
		$.ajax({
			url : 'ajaxTableTareas.jsp',
			type : 'post',
			data : datadata,
			success : function(output) {
				$('#actividad').trigger("change");
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
		}
	}

</script>
<%@ include file="../../cierra_elias.jsp"%>