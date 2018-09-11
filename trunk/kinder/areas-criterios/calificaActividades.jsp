<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.kinder.Criterios"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.UtilActividades"%>
<%@page import="aca.kinder.Actividades"%>
<%@page import="java.util.List"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="krdxCursoActL" scope="page"
	class="aca.kardex.KrdxCursoActLista" />
<jsp:useBean id="empPersonal" scope="page"
	class="aca.empleado.EmpPersonal" />
<%
	String escuelaId = (String) session.getAttribute("escuela");
		String codigoId = (String) session.getAttribute("codigoEmpleado");
		String cicloId = (String) session.getAttribute("cicloId");

		String cicloGrupoId = request.getParameter("CicloGrupoId");
		String cursoId = request.getParameter("CursoId");
		String evaluacionId = request.getParameter("EvaluacionId");
		String estado = request.getParameter("estado") == null ? "A" : request.getParameter("estado");
		String accion = request.getParameter("Accion") == null ? "" : request.getParameter("Accion");
		String bloqueId = request.getParameter("bloqueId") == null ? "" : request.getParameter("bloqueId");
		String planId = aca.plan.PlanCurso.getPlanId(conElias, cursoId);
		String trimestre = request.getParameter("trim");

		empPersonal.mapeaRegId(conElias, codigoId);

		UtilActividades uac = new UtilActividades(conElias);

		ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos = krdxCursoActL.getListAll(conElias, escuelaId,
				" AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId
						+ "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");
		Map<Long, Actividades> mapActividades = new HashMap();
		mapActividades.putAll(
				uac.getMapActividades(0L, "", cicloGrupoId, 0L, 0L, codigoId, 1, new Integer(trimestre)));

		UtilCriterios uc = new UtilCriterios(conElias);
		UtilAreas ua = new UtilAreas(conElias);

		Map<Long, Areas> mapAreas = new HashMap();
		mapAreas.putAll(ua.getMapAreas(0L, "", cicloId, 1));
		Map<Long, Criterios> mapCriterios = new HashMap();
		mapCriterios.putAll(uc.getMapCriterios(0L, "", cicloId, 0L, 1));
		List<Long> lsIdArea = new ArrayList(mapAreas.keySet());
		List<Long> lsIdCriterio = new ArrayList(mapCriterios.keySet());
		List<Long> lsIdActividad = new ArrayList(mapActividades.keySet());
		Collections.sort(lsIdArea);
		Collections.sort(lsIdCriterio);
		Collections.sort(lsIdActividad);

		SimpleDateFormat sdfA = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdfB = new SimpleDateFormat("dd-MM-yyyy");
		List<Long> lsActividesOrden = new ArrayList();
%>
<div id="content">
	<input type="hidden" name="Trimestre" value="<%=trimestre%>">
	<h2>
		<fmt:message key="aca.Actividades" />
		<small> ( <%=empPersonal.getNombre() + " " + empPersonal.getApaterno() + " " + empPersonal.getAmaterno()%>
			| <%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%> | <%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%>
			| <%=aca.plan.Plan.getNombrePlan(conElias, planId)%> )
		</small>
	</h2>
	<div class="well">
		<a href="../../portal/maestro/cursos.jsp"
			class="btn btn-primary btn-mobile"><i
			class="icon-arrow-left icon-white"></i> <fmt:message
				key="boton.Regresar" /></a>
	</div>
	<div class="form-group">
		<label for="area">Área</label>
		<select id="area" name="area" class="dropdown form-control" style="width:auto">
			<option value="0">-- Selecciona un área --</option>
			<%
			    List<Areas> lsAreas = new ArrayList<Areas>();
				lsAreas.addAll(ua.getLsAreas(0L, "", cicloId, 1));
					for (Areas area : lsAreas) {
						%>
						<option value="<%=area.getId()%>"><%=area.getArea()%></option>
						<%
					}
			%>
		</select>
	</div>
	<div id="tablaDatos"></div>
		</div>
		<script>
		
$(function(){
	var maestro = '<%=codigoId%>';
    var ciclo_gpo_id = '<%=cicloGrupoId%>';
	llenaCalificaciones(ciclo_gpo_id,maestro);
});

function enviaDatos(datadata){
	console.log(datadata);
	$.ajax({
		url : 'ajaxCalifica.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});
}

function cambiarArea(datadata){
	var maestro = '<%=codigoId%>';
	var ciclo_gpo_id = '<%=cicloGrupoId%>'; 
	$.ajax({
		url : 'ajaxEvalActividades.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			$('#tablaDatos').html(output);
			llenaCalificaciones(ciclo_gpo_id,maestro);
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});
}

function llenaCalificaciones(ciclo_gpo_id,maestro){
	
	
	$.getJSON('jsonAlumCalif.jsp?tipo=grupo&ciclo_gpo_id='+ciclo_gpo_id+'&maestro_id='+maestro, function (data) {
	    $.each(data, function(i,item){
	    	
	    	//console.log('crea item' + '#nota-'+item.actividad + '-' +item.codigopersonal +' ' + item.calificacion);	
	    	$('#nota-'+item.actividad + '-' +item.codigopersonal).show();
	    	$('#nota-'+item.actividad + '-' +item.codigopersonal).html(item.calificacion);
	    	//$('[data-alumnoactividad="'+item.codigopersonal+'-'+item.actividad+'"] option[value="'+item.nota+'"]').prop('selected', true);
	    
	    });
	  })
}

function guardarCalificaciones(idactividad){
	$('.editable').hide();
	var maestro = '<%=codigoId%>';
    var ciclo_gpo_id = '<%=cicloGrupoId%>';
    var evaluacion_id= '<%=trimestre%>';
		
	$.when(
			$('[name="calif-'+idactividad+'"]').each(function(){
		//console.log($(this).val() + ' ' + $(this).data('alumno') + ' ' + idactividad);
		var datadata = 'ciclo_gpo_id='+ciclo_gpo_id+'&maestro_id='+maestro+'&calificacion='+$(this).val()+'&actividad_id='+idactividad+'&alumno_id='+$(this).data('alumno')+'&evaluacion_id='+evaluacion_id+'&guardar=true';
		enviaDatos(datadata);
	})
	).done(
			window.setTimeout( function(){ llenaCalificaciones(ciclo_gpo_id,maestro) }, 2000)
	);
}

function elimina(maestro, ciclo_gpo_id, idactividad){
	 var datadata = 'eliminar=true&ciclo_gpo_id='+ciclo_gpo_id+'&maestro_id='+maestro+'&actividad_id='+idactividad;
	 enviaDatos(datadata);
}

$('#area').change(function(){
	var idArea = $('#area').val();
	if(idArea!=0){
		var ciclo_gpo_id = '<%=cicloGrupoId%>'; 
		var trimestre = '<%=trimestre%>';
		var cursoId = '<%=cursoId%>';
		var datadata='cicloGrupoId='+ciclo_gpo_id+'&area='+idArea+'&trimestre='+trimestre+'&CursoId='+cursoId;
		cambiarArea(datadata);
	}
});


function borrarCalificaciones(idactividad){
	$('.editable').hide();
	$('.nota-'+idactividad).each(function(){
		$(this).html('-');
		$(this).show();
	});
	var maestro = '<%=codigoId%>';
    var ciclo_gpo_id = '<%=cicloGrupoId%>';
    
    $.when(
    	elimina(maestro,ciclo_gpo_id,idactividad)
    ).done(
    		window.setTimeout( function(){llenaCalificaciones(ciclo_gpo_id,maestro) }, 2000)		
    
    );
}


function muestraInput(actividadId){
	
	$('.editable').hide();
	//Busca los inputs
	
	var maestro = '<%=codigoId%>';
	var ciclo_gpo_id = '<%=cicloGrupoId%>';
				var editar = $('.editar' + actividadId);

				editar.each(function() {
					var $this = $(this);

					//Esconde la calificación
					$this.siblings('div').hide();

					//Muestra el input con la calificación
					$this.fadeIn(300);
				})
				$.getJSON('jsonAlumCalif.jsp?tipo=grupo&ciclo_gpo_id='
						+ ciclo_gpo_id + '&maestro_id=' + maestro, function(
						data) {

					//console.log(data);
					$.each(data, function(i, item) {
						//console.log($('[data-alumnoactividad="'+item.codigopersonal+'-'+item.actividad+'"] option[value="'+item.nota+'"]').val());
						$('[data-alumnoactividad="'+item.codigopersonal+'-'+item.actividad+'"] option[value="'+item.nota+'"]').prop('selected', true);
						if (item.actividad != actividadId) {
							$('#nota-' + item.actividad + '-'+ item.codigopersonal).show();
							$('#nota-' + item.actividad + '-'+ item.codigopersonal).html(item.calificacion);
							
						}
					});
				});

			}
		</script>
		<%@ include file="../../cierra_elias.jsp"%>