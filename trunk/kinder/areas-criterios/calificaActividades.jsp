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

	<table class="table table-condensed table-bordered" style="width: 75%">

		<%
		int cont = 0;
			for (Long idarea : lsIdArea) {

					for (Long idcriterio : lsIdCriterio) {
						boolean isVisible = false;
						for (Long idactividad : lsIdActividad) {
							if (mapActividades.get(idactividad).getArea_id().equals(idarea)
									&& mapActividades.get(idactividad).getCriterio_id().equals(idcriterio)) {
								isVisible = true;
							}
						}

						if (isVisible) {
		%>
		<tr style="background-color: lightgray; font-size: 12px">
			<th style="width: 50%"><%=mapAreas.get(idarea).getArea()%> <br>
				<%=mapCriterios.get(idcriterio).getCriterio()%></th>
			<th style="width: 25%">Fecha</th>
			<th style="width: 25%">Acción</th>
		</tr>
		<%
			for (Long idActividad : lsIdActividad) {
								if (mapActividades.get(idActividad).getCriterio_id().equals(idcriterio)) {
									String fecha = sdfB.format(sdfA.parse(mapActividades.get(idActividad).getFecha()));
									lsActividesOrden.add(idActividad);
									cont++;
		%>
		<tr style="font-size: 12px">
			<td style="width: 50%"><a
				href="javascript:muestraInput('<%=idActividad%>');"><%=cont%>.- 
					<%=mapActividades.get(idActividad).getActividad()%></a></td>
			<td style="width: 25%"><%=fecha%></td>
			<td style="width: 25%"></td>
		</tr>
		<%
			}
							}
						}
					}
				}
		%>
	</table>

	<table class="table table-condensed table-bordered table-striped">
		<thead>
			<tr>
				<td colspan="20" class="text-center alert">Las actividades se
					evalúan de &nbsp;&nbsp;</td>
			</tr>
			<tr>
				<th class="text-center">#</th>
				<th class="text-center"><fmt:message key="aca.Codigo" /></th>
				<th><fmt:message key="aca.Nombre" /></th>
				<%
					cont = 0;
						for (Long idactividad : lsActividesOrden) {
							cont++;
				%>
				<th style="width: 4%;" class="text-center"
					title="<%=mapActividades.get(idactividad).getActividad()%>"><%= cont %></th>
				<%
					}
				%>
				<th class="text-center"
					title="<fmt:message key='aca.MensajePromedioActividades' />">
					<fmt:message key="aca.PA" />
				</th>
				<th class="text-center" title=""><fmt:message
						key="aca.Promedio" /></th>
			</tr>
		</thead>
		<%
			int i = 0;
				for (aca.kardex.KrdxCursoAct kardex : lisKardexAlumnos) {
		%>
		<tr>
			<td class="text-center"><%=i + 1%></td>
			<td class="text-center"><%=kardex.getCodigoId()%></td>
			<td><%=aca.alumno.AlumPersonal.getNombre(conElias, kardex.getCodigoId(), "APELLIDO")%>

				<%
					if (kardex.getTipoCalId().equals("6")) {
				%> <span
				class="label label-important"
				title="<fmt:message key="aca.EsteAlumnoHaSidoDadoDeBajar" />"><fmt:message
						key="aca.Baja" /></span> <%
 	}
 %></td>
			<!-- --------- RECORRE LAS ACTIVIDADES --------- -->
			<%
				for (Long idactividad : lsActividesOrden) {
							String strNota = "-";
			%>

			<td class="text-center">

				<div id="nota-<%=idactividad%>-<%=kardex.getCodigoId()%>" class="nota-<%= idactividad %>"><%=strNota%></div>

				<!-- INPUT PARA EDITAR LAS NOTAS (ESCONDIDO POR DEFAULT) --> <%
 	if (estado.equals("A")) { /* Si el alumno no se ha dado de baja puede editar su nota */
 %>
				<div class="editar<%=idactividad%> editable" style="display: none;">
					<select name="calif-<%=idactividad%>" id="calif-<%=idactividad%>"
						data-alumno="<%=kardex.getCodigoId()%>" data-alumnoactividad="<%=kardex.getCodigoId()%>-<%=idactividad%>">
						<option value="3">LHL</option>
						<option value="2">LEL</option>
						<option value="1">LVL</option>
					</select>
				</div> <%
 	}
 %>

			</td>
			<%
				} //End for evaluaciones
			%>
			<td class="text-center">
				<%
					
				%>
			</td>
			<%
				// obtiene el promedio de la evaluacion que esta en la BD
			%>

			<td class="text-center"><%=0%></td>
		</tr>
		<%
			i++;
				}
		%>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<%
				for (Long idactividad : lsActividesOrden) {
			%>
			<td class="text-center">
				<div class="editar<%=idactividad%> editable"
					style="display: none;">
					<a tabindex="<%=lisKardexAlumnos.size()%>"
						class="btn btn-primary btn-block" type="button"
						href="javascript:guardarCalificaciones( '<%=idactividad%>' );"><fmt:message
							key="boton.Guardar" /></a> <a
						tabindex="<%=lisKardexAlumnos.size() + 1%>"
						class="btn btn-danger btn-block" type="button"
						href="javascript:borrarCalificaciones( '<%=idactividad%>' );"><fmt:message
							key="boton.Eliminar" /></a>
				</div>
			</td>
			<%
				}
			%>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>

		</div>
		<script>
		
		$(function(){
			var maestro = '<%=codigoId%>';
		    var ciclo_gpo_id = '<%=cicloGrupoId%>';
			llenaCalificaciones(ciclo_gpo_id,maestro)
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