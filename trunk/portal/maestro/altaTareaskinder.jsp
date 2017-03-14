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
<div class="container">


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
	<table class="table">
		<tr>
			<td style="width: 30%;">
				<div class="col-md-4">
					<form>
						<label for="selectA">Area:</label> <select id="sPromedio"
							class="form-control">
							<option></option>
							<%
								for (Integer pr : mapCAEP.keySet()) {
							%>
							<option value="<%=pr%>"><%=mapCAEP.get(pr).getNombrePromedio()%></option>
							<%
								}
							%>
						</select>

						<div id="evaluacion" class="form-group "></div>
						<div id="actividad" class="form-group  "></div>
					</form>
				</div>
			</td>
			<td>
				<div id="formTarea"></div>
				<div id="tablaResultados"></div>
			</td>
		</tr>
	</table>






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
	});
	
$('#evaluacion').change(function(e) {
		console.log("entro a sevaluacion");
		
		var selectValue = $('#sEvaluacion').val();
		var cicloid ='<%=cicloid%>';
		var cursoid = '<%=cursoid%>';
		var ciclogrupoid = '<%=ciclogrupoid%>'; 
		var promedioid = $('#sPromedio').val();
		
		$('#formTarea').empty();
		$('#tablaResultados').empty();

							var datadata = 'ciclo_id=' + cicloid + '&curso_id='
									+ cursoid + '&ciclo_grupo_id='
									+ ciclogrupoid + '&evaluacionid='
									+ selectValue + '&promedioid=' + promedioid
									+ '&selectActividad=true';
							$.ajax({
										url : 'ajaxActividadesKinder.jsp',
										type : 'post',
										data : datadata,
										success : function(output) {
											$('#actividad').html(output);
										},
										error : function(xhr, ajaxOptions,
												thrownError) {
											console.log("error " + datadata);
											alert(xhr.status + " "
													+ thrownError);
										}
									});
						});


$('#actividad').change(function(e) {
	console.log("entro a sevaluacion");
	
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
				$.ajax({
					url : 'ajaxFormKinder.jsp',
					type : 'post',
					data : datadata,
					success : function(output) {
						$('#formTarea').html(output);
					},
					error : function(xhr, ajaxOptions, thrownError) {
						console.log("error " + datadata);
						alert(xhr.status + " " + thrownError);
					}
				});
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
			});

function guardaFormulario(){
	
	var actividadid = $('#formactividadid').val();
	var cicloid =$('#formcicloid').val();
	var cursoid = $('#formcursoid').val();
	var ciclogrupoid = $('#formciclogrupoid').val();
	var promedioid = $('#formpromedioid').val();
	var evaluacionid = $('#formevaluacionid').val();
	var actividad = $('#formactividad').val();
	var observacion = $('#formobservacion').val();
	$('#formTarea').empty();
	$('#tablaResultados').empty();
				var datadata = 'cicloid=' + cicloid + '&cursoid=' + cursoid
						+ '&ciclogrupoid=' + ciclogrupoid + '&actividadid='
						+ actividadid + '&promedioid=' + promedioid
						+ '&evaluacionid=' + evaluacionid 
						+ '&actividad='+actividad
						+ '&observacion=' +observacion 
				+'&guardar=true';
				
				console.log("entra a agregar " + datadata);
				$.ajax({
					url : 'ajaxTableTareas.jsp',
					type : 'post',
					data : datadata,
					success : function(output) {
						$('#formTarea').html(output);
						
						
					},
					error : function(xhr, ajaxOptions, thrownError) {
						console.log("error " + datadata);
						alert(xhr.status + " " + thrownError);
						
					}
					
					
				});
				$.ajax({
					url : 'ajaxFormKinder.jsp',
					type : 'post',
					data : datadata,
					success : function(output) {
						$('#formTarea').html(output);
					},
					error : function(xhr, ajaxOptions, thrownError) {
						console.log("error " + datadata);
						alert(xhr.status + " " + thrownError);
					}
				});
				
}
			
			
			
// $('#guardaformulario').click(function(e) {
// 	console.log("entra a agregar");
// 	var actividadid = $('#formactividadid').val();
// 	var cicloid =$('#formcicloid').val();
// 	var cursoid = $('#formcursoid').val();
// 	var ciclogrupoid = $('#formcicloid').val();
// 	var promedioid = $('#formpromedioid').val();
// 	var evaluacionid = $('#formevaluacionid').val();
// 	var actividad = $('#formactividad').val();
// 	var observacion = $('#formobservacion').val();
// 	$('#formTarea').empty();
// 				var datadata = 'cicloid=' + cicloid + '&cursoid=' + cursoid
// 						+ '&ciclo_grupoid=' + ciclogrupoid + '&actividadid='
// 						+ selectValue + '&promedioid=' + promedioid
// 						+ '&evaluacionid=' + evaluacionid 
// 						+ '&actividad='+actividad
// 						+ '&observacion=' +observacion 
// 				+'&guardar=true';
// 				$.ajax({
// 					url : 'ajaxTableTareas.jsp',
// 					type : 'post',
// 					data : datadata,
// 					success : function(output) {
// 						$('#formTarea').html(output);
						
						
// 					},
// 					error : function(xhr, ajaxOptions, thrownError) {
// 						console.log("error " + datadata);
// 						alert(xhr.status + " " + thrownError);
						
// 					}
					
					
// 				});
				
// 		});


</script>
<%@ include file="../../cierra_elias.jsp"%>