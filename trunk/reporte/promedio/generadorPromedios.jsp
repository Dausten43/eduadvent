<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="aca.fin.FinEdoCtaReporte"%>
<%@page import="aca.fin.FinAlumSaldos"%>
<%@page import="aca.alumno.AlumPersonalLista"%>
<%@page import="java.util.Collections"%>
<%@page import="aca.alumno.AlumPersonal"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="aca.util.Fecha"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.FileNotFoundException"%>
<%@ page import="java.io.FileReader"%>
<%@ page import="java.io.IOException"%>
<jsp:useBean id="AlumnoL" scope="page"
	class="aca.alumno.AlumPersonalLista" />
<jsp:useBean id="AlumPersonal" scope="page"
	class="aca.alumno.AlumPersonal" />
<jsp:useBean id="MovimientoL" scope="page"
	class="aca.fin.FinMovimientoLista" />
<jsp:useBean id="MovimientosL" scope="page"
	class="aca.fin.FinMovimientosLista" />
<jsp:useBean id="MovsSunPlusL" scope="page"
	class="aca.sunplus.AdvASalfldgLista" />
<jsp:useBean id="CatParametro" scope="page"
	class="aca.catalogo.CatParametro" />
<jsp:useBean id="escuela" scope="page" class="aca.catalogo.CatEscuela" />
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista" />
<jsp:useBean id="CicloLista" scope="page"
	class="aca.alumno.AlumCicloLista" />
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<style>
@page {
	margin-top: 0.3cm;
	margin-left: 0.3cm;
	margin-right: 0.3cm;
	margin-bottom: 0.3cm;
}

@media print {
	.encabezado {
		border-bottom: double 0.3em;
	}
	.totalFinal {
		border-top: double 0.3em;
	}
	.headerTabla {
		border-top: solid 0.2em black;
		border-bottom: solid 0.2em black;
	}
	table {
		border-spacing: 0px;
	}
	table tr td {
		border-bottom: 0.1em solid gray;
		padding: 0px;
	}
	table tr th {
		border-bottom: 0.2em solid black;
		border-left: 0em;
		border-right: 0em;
		border-top: 0em;
		overflow: hidden;
	}
	.movimientos {
		font-size: 10px;
	}
}
</style>
<link rel="stylesheet" href="../../js/chosen/chosen.css"  />
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript"
	src="../../bootstrap/datepicker/datepicker.js"></script>
<%
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00", new java.text.DecimalFormatSymbols(java.util.Locale.US));

		String escuelaId = (String) session.getAttribute("escuela");
		String codigoId = (String) session.getAttribute("codigoAlumno");
		String ejercicioId = (String) session.getAttribute("ejercicioId");
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		Calendar cal = Calendar.getInstance();
		
		String accion = request.getParameter("Accion") == null ? "0" : request.getParameter("Accion");
		String resultado = "";
		boolean usaSunPlus = aca.catalogo.CatParametro.esSunPlus(conElias, escuelaId);
		String ciclo = request.getParameter("ciclo") == null
				? aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId)
				: request.getParameter("ciclo");

		String fechaHoy = aca.util.Fecha.getHoy();
		String fechaInicio = request.getParameter("fechaInicio") == null
				? "01-01-" + aca.util.Fecha.getYearNum()
				: request.getParameter("fechaInicio");
		String fechaFinal = request.getParameter("fechaFinal") == null || !request.getParameter("fechaFinal").equals("")  
				? sdf.format(cal.getTime()) 
				: request.getParameter("fechaFinal");
		String txtPersonalizado = "";

		//System.out.println(archivo);

		// Lista de ciclos activos en la escuela
		ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId,
				"ORDER BY CICLO_ID");

		//AlumPersonal.mapeaRegId(conElias, codigoId);

		// Movimientos registrados en EduAdvent
		//ArrayList<aca.fin.FinMovimientos> lisMovimientos = MovimientosL.getListAlumnoAll(conElias, codigoId, fechaInicio, fechaFinal, "'A','R'"," ORDER BY TO_CHAR(FECHA,'YYYY-MM-DD')");

		// Movimientos registrados en SunPlus
		//ArrayList<aca.sunplus.AdvASalfldg> lisMovimientosSunPlus = null;
%>

<div id="content">
	<center>
		<h3><%=escuela.getEscuelaNombre()%></h3>
	</center>
	<form name="frmEstado" id="frmEstado" method="post" action="" class="hidden-print form-inline">
		<div class="well">
		<h3>REPORTEADOR DE PROMEDIOS</h3>
			<div id="cicloSelect">
				<label for="cicloid">Ciclo:</label> 
				<select name="ciclo_id" id="cicloid" style="width: 350px;">
					<option value="">Seleccione un ciclo</option>
					<%
					String nivel_calificacion = "";
						System.out.println("ciclo  " + ciclo);
						Collections.reverse(lisCiclo);
							for (aca.ciclo.Ciclo c : lisCiclo) {
					%>
					<option data-nivel="<%= c.getNivelEval() %>" value="<%=c.getCicloId()%>" <%= c.getCicloId().equals(ciclo) ? " selected " : ""%>><%=c.getCicloNombre()%> </option>
					<%
						if(c.getCicloId().equals(ciclo)){
							nivel_calificacion = c.getNivelEval();
						}
						}
					%>
				</select>
				</div>
				
				<div id="cicloGpoIdSelect" >
					<label for="nivel_id">Grupo :</label> 
					<select name="ciclo_gpo_id" id="ciclo_gpo_id" style="width: 350px;">
						<option value=""></option>
					</select>
				</div><!-- 477 -- 74  -->
				<div id="periodosDiv">
					<label for="periodos">Periodos :</label> 
					<select name="periodosId" id="periodosId" multiple size="4">
						<option value=""></option>
					</select>
				</div>
				
				<div id="materiasDiv">
					<label for="periodos">Materias :</label> 
					<select name="curso_id" id="curso_id" >
						<option value=""></option>
					</select>
				</div>
				
				<div id="limitesDiv">
					<label for="periodos">Limite (menor igual a-mayor igual a, max precisión 6 decimales, ejemplo : 1.0-5.0) :</label> 
					<input type="text" name="limite" id="limite" >
				</div>
				
				<input type="hidden" name="escuela_id" id="escuela_id" value="<%= escuelaId%>">
				<input type="hidden" name="generar" value="true"> 
				<input type="hidden" name="nivel_calificacion" id="nivel_calificacion" value=""> 
				
			
				<div class="control-group">
					<a class="btn btn-success"
						onclick="javascript:generaPromedios();">Generar Promedios</a>
					<a class="btn btn-danger"
						onclick="javascript:generaPromediosRep();">Generar Promedios con Materias</a>
				</div>
				
			</div>
	</form>
<div id="reporteOut"></div>
</div>
<script src="../../js/chosen/chosen.jquery.js" type="text/javascript"></script>
<script>
	jQuery(".chosen").chosen({width: "50%"});
	
	
	
	function correAjax(datadata, idSelect, idDiv){
		$.ajax({url: 'ajaxPromediosCombos.jsp',
            type: "post",
            data: datadata,
            success: function (output) {
                //alert(output);
                $(idSelect).html(output);
                $(idDiv).show();
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status + " " + thrownError);
            }
        });
	}

	$('#cicloid').each(function(e) {
		
		var cicloSelected = $(this).val();
		
		console.log('data-nivel ' + $(this).find(':selected').data('nivel'));
		$('#nivel_calificacion').val($(this).find(':selected').data('nivel'));
		var escuelaId = $('#escuela_id').val();
		console.log('Ciclo elegido = ' + cicloSelected);
		if(cicloSelected!=''){
			var datadata = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_combos=true&genera_grupos=true'; 
			var datadatab = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_periodos=true';
			console.log('Revisa ciclos inicial ' + datadata);
			console.log('Revisa ciclos inicial ' + datadatab);
			correAjax(datadata,'#ciclo_gpo_id','#cicloGpoIdSelect');
			correAjax(datadatab,'#periodosId','#periodosDiv');
		}else{
			
			$('#materiasDiv').hide();
		}
		

	});
	
	
$('#cicloid').change(function(e) {
		var cicloSelected = $(this).val();
		var escuelaId = $('#escuela_id').val();
		console.log('data-nivel ' + $(this).find(':selected').data('nivel'));
		$('#nivel_calificacion').val($(this).find(':selected').data('nivel'));
		if(cicloSelected!=''){
			var datadata = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_combos=true&genera_grupos=true'; 
			var datadatab = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_periodos=true';
			//Make AJAX request, using the selected value as the GET
			console.log('Cambio ciclo ' + datadata);
			//$('#cicloGpoIdSelect').empty();
			correAjax(datadata,'#ciclo_gpo_id','#cicloGpoIdSelect');
			correAjax(datadatab,'#periodosId','#periodosDiv');
		}else{
			$('#materiasDiv').hide();
		}
		

	});
	
$('#ciclo_gpo_id').change(function(e) {
	var cicloSelected = $(this).val();
	
	var escuelaId = $('#escuela_id').val();
	if(cicloSelected!=''){
		var datadata = 'ciclo_gpo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_combos=true&genera_materias=true'; 
		//Make AJAX request, using the selected value as the GET
		console.log('Cambio ciclo ' + datadata);
		correAjax(datadata,'#curso_id','#materiasDiv');
	}else{
		
		$('#materiasDiv').hide();
	}
});

function generaPromedios(){
	console.log('entrando a datos' + $('#periodosId').val());
	var nivecal = $('#nivel_calificacion').val();
	if($('#cicloid').val()!=''){
		if($('#periodosId').val()!==null){
			if($('#ciclo_gpo_id').val()==''){
				var datadata = 'cicloId='+$('#cicloid').val()+'&periodos='+$('#periodosId').val()+'&genera_reporte=true&cicloGpoId=&materias=n&limite='+$('#limite').val()+'&nivel='+nivecal;
				console.log(datadata);
				correAjax(datadata,'#reporteOut','#reporteOut');
			}else{
				var datadata = 'cicloGpoId='+$('#ciclo_gpo_id').val()+'&periodos='+$('#periodosId').val()+'&genera_reporte=true&cicloGpoId=&materias=n&limite='+$('#limite').val()+'&nivel='+nivecal;
				if($('#curso_id').val()!=''){
					datadata+='&materia='+$('#curso_id').val();
				}
				console.log(datadata);
				correAjax(datadata,'#reporteOut','#reporteOut');
			}
		}else{
			alert('Es necesario elegir por lo menos un periodo para generar el reporte');
		}
	}else{
		alert('Es necesario elegir un ciclo para generar el reporte');
	}
	
	
}

function generaPromediosRep(){
	console.log('entrando a datos' + $('#periodosId').val());
	var nivecal = $('#nivel_calificacion').val();
	if($('#cicloid').val()!=''){
		if($('#periodosId').val()!==null){
			if($('#ciclo_gpo_id').val()==''){
				var datadata = 'cicloId='+$('#cicloid').val()+'&periodos='+$('#periodosId').val()+'&reporte_materias=true&cicloGpoId=&materias=n&limite='+$('#limite').val()+'&nivel='+nivecal+'&orden= order by codigo_id';
				correAjax(datadata,'#reporteOut','#reporteOut');
			}else{
				var datadata = 'cicloGpoId='+$('#ciclo_gpo_id').val()+'&periodos='+$('#periodosId').val()+'&reporte_materias=true&cicloGpoId=&materias=n&limite='+$('#limite').val()+'&nivel='+nivecal+'&orden= order by codigo_id';
				if($('#curso_id').val()!=''){
					datadata+='&materia='+$('#curso_id').val();
				}
				correAjax(datadata,'#reporteOut','#reporteOut');
			}
		}else{
			alert('Es necesario elegir por lo menos un periodo para generar el reporte');
		}
	}else{
		alert('Es necesario elegir un ciclo para generar el reporte');
	}
	
	
}



</script>

<%@ include file="../../cierra_elias.jsp"%>