<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="aca.kinder.UtilCriterios"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kinder.Criterios"%>
<%@page import="java.util.List"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>

<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	String lenguajeValue =  (String) session.getAttribute("lenguaje")==null?"es": (String) session.getAttribute("lenguaje");
%>

<%if(lenguajeValue.equals("es")){%>
	<fmt:setLocale value="es" scope="session"/>
<%}else if(lenguajeValue.equals("en")){%>
	<fmt:setLocale value="en" scope="session"/>
<%}else{%>
	<fmt:setLocale value="es" scope="session"/>
<%} %>
	
<fmt:setBundle basename="aca.idioma.messages"/>

<script src="https://code.jquery.com/jquery-2.0.3.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>   
<script type="text/javascript"	src="../../js-plugins/bootstrap-select-1.12.2/dist/js/bootstrap-select.js"></script>
<script type="text/javascript"	src="../../js-plugins/bootstrap-select-1.12.2/dist/js/i18n/defaults-es_ES.js"></script>
<link rel="stylesheet"	href="../../js-plugins/bootstrap-select-1.12.2/dist/css/bootstrap-select.css">
<link href="../../js-plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet"/>
<script src="../../js-plugins/bootstrap3-editable/js/bootstrap-editable.js"></script>
<script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
<script src="../../js/moment.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css" />

<%
	String codigoId = session.getAttribute("codigoId").toString();
		String escuelaId = session.getAttribute("escuela").toString();
		String cicloId = session.getAttribute("cicloId").toString();
		if (request.getParameter("CicloGrupoId") != null) {
			session.setAttribute("cicloGrupoId", request.getParameter("CicloGrupoId"));
			session.setAttribute("cursoId", request.getParameter("CursoId"));
		}

		String cicloGrupoId = (String) session.getAttribute("cicloGrupoId");
		String cursoId = (String) session.getAttribute("cursoId");

		UtilAreas ua = new UtilAreas(conElias);
		UtilCriterios uc = new UtilCriterios(conElias);

		List<Criterios> lsCr = new ArrayList();
		List<Areas> lsAr = new ArrayList();

		Map<Areas, List<Criterios>> mapSelect = new LinkedHashMap();
		lsAr.addAll(ua.getLsAreas(0L, "", cicloId, 1));
		lsCr.addAll(uc.getLsCriterios(0L, "", cicloId, 0L, 1));

		for (Areas ar : lsAr) {
			List<Criterios> lsCriterios = new ArrayList();
			for (Criterios cr : lsCr) {
				if (cr.getArea_id().equals(ar.getId())) {
					lsCriterios.add(cr);
				}
			}
			if (lsCriterios.size() > 0)
				mapSelect.put(ar, lsCriterios);
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
%>


<!-- ENCABEZADO -->
<div class="container">
	<h2>
		<fmt:message key="kinder.actividades" />

		<small><%=aca.empleado.EmpPersonal.getNombre(conElias, codigoId, "NOMBRE")%></small>
	</h2>
	<div class="well">
		<a class="btn btn-primary" href="../../portal/maestro/cursos.jsp"><i class="icon icon-th-list icon-white"></i> Cursos</a>
		
		<%-- 			  <a class="btn btn-primary" href="cursos.jsp?Ciclo=<%= cicloId %>"><i class="icon icon-th-list icon-white"></i> <fmt:message key="maestros.Cursos" /></a> --%>
		<%-- 			  <a class="btn btn-primary" href="altaTareasK.jsp?ciclo_id=<%= cicloId %>&curso_id=<%= cursoId %>&ciclo_grupo_id=<%= cicloGrupoId %>"><i class="icon icon-pencil icon-white"></i> <fmt:message key="kinder.actividades" /></a> --%>
		&nbsp;&nbsp;<strong>Plan: </strong><%=aca.plan.Plan.getNombrePlan(conElias, aca.plan.PlanCurso.getPlanId(conElias, cursoId))%>
		&nbsp;&nbsp;<strong>Materia: </strong>
		<%=aca.plan.PlanCurso.getCursoNombre(conElias, cursoId)%>
		&nbsp;&nbsp;<strong>Grado: </strong><%=aca.ciclo.CicloGrupo.getGrupoNombre(conElias, cicloGrupoId)%>
	</div>
	<form class="form-inline">
		<div class="row">
			<div class="col-md-3">
			<label for="selectCriterios">Areas-Criterios</label>
				<select id="selectCriterios"
					class="selectpicker show-menu-arrow form-control" multiple
					data-actions-box="true" data-language="es_ES" style="width: 200px">
					<%
						List<Areas> lsAreas = new ArrayList(mapSelect.keySet());
							for (Areas area : lsAreas) {
					%>
					<optgroup label="<%=area.getArea()%>">
						<%
							for (Criterios criterio : mapSelect.get(area)) {
						%>
						<option value="<%=criterio.getId()%>"><%=criterio.getCriterio()%></option>
						<%
							}
						%>
					</optgroup>
					<%
						}
					%>
				</select>
				<input type="hidden" id="ciclo_gpo_id" value="<%= cicloGrupoId %>">
				<input type="hidden" id="maestro_id" value="<%= codigoId %>">
			</div>
		
		
			<div  class="col-md-4">
			<label for="exampleInputEmail3">Actividad:</label>
				<input type="text" name="actividadtxt" id="actividadtxt" class="form-control" style="height: 35px; width: 95%" >
			</div>
		
		
			<div class="col-md-2">
			<label for="exampleInputEmail3">Fecha:</label>
				<input type="text" name="fecha" id="fecha" class="form-control"  style="height: 35px; width: 95%" data-date-format="dd-mm-yyyy" data-date="<%= sdf.format(new Date()) %>" value="<%= sdf.format(new Date()) %>">
				
			</div>
			<div class="col-md-1">
				<label for="trimestre">Trimestre</label>
				<select id="evaluacion" name="evaluacion" class="form-control">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
				</select>
			</div>
			<div class="col-md-1"  style="padding-top: 24px">
				<input type="button" class="btn btn-default" name="btnGuardar" id="btnGuardad" value="Guardar" onclick="leeSelect(); return false;">
			</div>
		</div>
	</form>
	<br>
	<div id="tablaDatos"> </div>
</div>

<div id="dialog-confirm" title="Confirmar" style="display:none;">
    <p>¿Está seguro de eliminar?</p>
</div>
<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<script src="../../js-plugins/datepicker/datepicker.js"></script>

<script>
$('#fecha').datepicker();

function cargaTabla(datadata){
	
	$.ajax({
		url : 'ajaxActividades.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			$('#tablaDatos').html(output);
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
		}
	});
}

	$(document).ready(function() {
		$('#selectCriterios').selectpicker();
		var evaluacion = $('#evaluacion').val();
		var datadata='evaluacion='+evaluacion;
		cargaTabla(datadata);
		
		
	})
	
	$('#evaluacion').change(function(){
		var evaluacion = $('#evaluacion').val();
		var datadata='evaluacion='+evaluacion;
		cargaTabla(datadata);
	});
	
	
	function eliminar(idactividad,estado){
		var evaluacion = $('#evaluacion').val();
		var datadata='idactividad='+idactividad+'&estado='+estado+'&eliminar=true&evaluacion='+evaluacion;
		cargaTabla(datadata);
	}
	
	function leeSelect(){
		var ciclogpoid = $('#ciclo_gpo_id').val();
		var maestroid = $('#maestro_id').val();
		var fecha = $('#fecha').val();
		var actividad = $('#actividadtxt').val();
		var evaluacion = $('#evaluacion').val();
		var datadata = 'ciclo_gpo_id='+ciclogpoid+'&maestro_id='+maestroid+'&fecha='+fecha+'&actividad='+actividad+'&guardar=true&evaluacion='+evaluacion; 
		if(actividad!='' && fecha!=''){
			var contador = 0;
			$('#selectCriterios option:selected').each(function(e){
				contador++;
				datadata+='&criterio_id_'+contador+'='+$(this).val();
			});
			console.log(datadata)
			cargaTabla(datadata);
		}
	}
	
	function confirm(callback){
	    $( "#dialog-confirm" ).dialog({
	        resizable: false,
	        height:160,
	        modal: false,
	        buttons: {
	            "Si": function() {
	                $( this ).dialog( "close" );
	                eval(callback)
	            },
	            Cancel: function() {
	                $( this ).dialog( "close" );
	                return false;
	            }
	        }
	    });
	}
</script>
<%@ include file="../../cierra_elias.jsp"%>