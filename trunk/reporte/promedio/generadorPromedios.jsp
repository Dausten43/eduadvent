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
	java.text.DecimalFormat formato = new java.text.DecimalFormat("###,##0.00;-###,##0.00");

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
		<h3>GENERADOR DE ESTADOS DE CUENTA</h3>
			<div id="cicloSelect">
				<label for="cicloid">Ciclo:</label> 
				<select name="ciclo_id" id="cicloid" style="width: 350px;">
					<option value="">Seleccione un ciclo</option>
					<%
						System.out.println("ciclo  " + ciclo);
						Collections.reverse(lisCiclo);
							for (aca.ciclo.Ciclo c : lisCiclo) {
					%>
					<option value="<%=c.getCicloId()%>" <%= c.getCicloId().equals(ciclo) ? " selected " : ""%>><%=c.getCicloNombre()%></option>
					<%
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
				
				</div>
				
				<input type="hidden" name="escuela_id" id="escuela_id" value="<%= escuelaId%>">
				<input type="hidden" name="generar" value="true"> 
				
			
				<div class="control-group">
					<a class="btn btn-success"
						onclick="javascript:document.frmEstado.submit();">Generar</a>

				</div>
				
			</div>
	</form>

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
		var escuelaId = $('#escuela_id').val();
		console.log('Ciclo elegido = ' + cicloSelected);
		if(cicloSelected!=''){
			var datadata = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_combos=true'; 
			var datadatab = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_periodos=true';
			console.log('Revisa ciclos inicial ' + datadata);
			console.log('Revisa ciclos inicial ' + datadatab);
			correAjax(datadata,'#ciclo_gpo_id','#cicloGpoIdSelect');
			correAjax(datadatab,'#periodosId','#periodosDiv');
		}else{
			$('#cicloGpoIdSelect').hide();

		}
		

	});
	
	
$('#cicloid').change(function(e) {
		var cicloSelected = $(this).val();
		var escuelaId = $('#escuela_id').val();
		if(cicloSelected!=''){
			var datadata = 'ciclo_id='+ cicloSelected + '&escuela_id=' + escuelaId + '&genera_combos=true'; 
			//Make AJAX request, using the selected value as the GET
			console.log('Cambio ciclo ' + datadata);
			correAjax(datadata,'#ciclo_gpo_id','#cicloGpoIdSelect');
		}else{
			$('#cicloGpoIdSelect').hide();
		}
		

	});
	

	
$('#nivelid').change(function(e) {
	
	$('#grupoSelect').hide();
	
	var cicloSelected = $('#cicloid').val();
	var nivelSelected = $(this).val();
	
	if(nivelSelected!=''){
		var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected + '&getgrados=true';
		//Make AJAX request, using the selected value as the GET
		console.log(datadata);
        $.ajax({url: 'ajaxCombos.jsp',
            type: "post",
            data: datadata,
            success: function (output) {
                //alert(output);
                $('#gradoid').html(output);
                $('#gradoSelect').show();
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status + " " + thrownError);
            }
        });
	}else{
		//$('#nivelSelect').hide();
		$('#gradoSelect').hide();
		$('#grupoSelect').hide();
	}
	

});


</script>

<%@ include file="../../cierra_elias.jsp"%>