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

<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
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
		String fechaFinal = request.getParameter("fechaFinal") == null
				? "31-12-" + aca.util.Fecha.getYearNum()
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
	<form name="frmEstado" id="frmEstado" method="post"
		action="/EdoCta/PrintEstadoCuenta" class="hidden-print form-inline" target="_new">
		<div class="well">
		<h3>GENERADOR DE ESTADOS DE CUENTA</h3>
			<div class="control-group">
				<label for="codigoid">Código(s) Alumno:</label> 
				<select multiple="multiple" name="codigo_id" id="codigoid" class="chosen" >
				<%
				AlumPersonalLista ap = new AlumPersonalLista();
				
					Map<String, AlumPersonal> mapAlumEscuela = new HashMap();
					mapAlumEscuela.putAll(ap.getLsAlumEscuela(conElias, escuelaId));
					for(String codigo : mapAlumEscuela.keySet()){
				%>
					<option value="<%= codigo%>"><%= mapAlumEscuela.get(codigo).getCodigoId() %> <%= mapAlumEscuela.get(codigo).getNombre() + " " + mapAlumEscuela.get(codigo).getApaterno() + " " + mapAlumEscuela.get(codigo).getAmaterno() %></option>
				<% } %>
				</select>
		<!-- 		<input type="text"
					name="codigo_id" id="codigoid" class="control-label input-xlarge"
					size="40" value="" placeholder="código o código 1,...,codigo N" style="width: 500px;">  -->
			</div>
			<div class="control-group">
				<label for=fechai>Fecha Inicio:</label> <input type="text"
					style="width: 100px;" data-date-format="dd-mm-yyyy"
					id="fechaInicio" name="fechaInicio" value="<%=fechaInicio%>" /> <label
					for=fechaf>Fecha Final:</label> <input type="text"
					style="width: 100px;" data-date-format="dd-mm-yyyy" id="fechaFinal"
					name="fechaFinal" value="<%=fechaFinal%>" />
			</div>
			
			<div class="control-group" id="cicloSelect">
				<label for="cicloid">Ciclo:</label> <select name="ciclo_id"
					id="cicloid" style="width: 350px;">
					<option value="">Seleccione un ciclo</option>
					<%
						Collections.reverse(lisCiclo);
							for (aca.ciclo.Ciclo c : lisCiclo) {
					%>
					<option value="<%=c.getCicloId()%>"
						<%=c.getCicloId().equals(ciclo) ? " Selected" : ""%>><%=c.getCicloNombre()%></option>
					<%
						}
					%>
				</select>
				</div>
				<div class="form-inline">
				<div id="nivelSelect" class="control-group">
					<label for="nivel_id">Nivel:</label> <select name="nivel_id"
						id="nivelid">
						<option value=""></option>
					</select>
				</div><!-- 477 -- 74  -->

				<div id="gradoSelect" class="control-group col-md-2">
					<label for="gradoid">Grado:</label> <select name="grado_id"
						id="gradoid">
						<option></option>
					</select>
				</div>
				<div id="grupoSelect" class="control-group">
					<label for="grupoid">Grupo:</label> <select name="grupo_id"
						id="grupoid">
						<option></option>
					</select>
				</div>
				</div>
				<div class="control-group">
				<label for="codigoid">Texto Adicional:</label> 
				<textarea rows="4" cols="100" name="mensaje" id="mensaje" class="control-labe"></textarea>
				<input type="hidden" name="escuela_id" value="<%= escuelaId%>"> 
				<!--  <input type="text"
					name="mensaje" id="mensaje" class="control-label"
					size="40" value="" placeholder="texto para el pie de pagina del estado de cuenta" style="width: 500px;"> --> 
			</div>
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

	jQuery('#fechaInicio').datepicker();
	jQuery('#fechaFinal').datepicker();

		$('#nivelSelect').hide();
		$('#gradoSelect').hide();
		$('#grupoSelect').hide();

	$('#codigoid').keyup(function(e){
		
		var codigoid = $(this).val();
		console.log(codigoid);
		if(codigoid!=''){
			
			$('#cicloSelect').hide();
			$('#nivelSelect').hide();
			$('#gradoSelect').hide();
			$('#grupoSelect').hide();
		}else{
			$('#cicloSelect').show();
		}
	});	
		
	$('#cicloid').each(function(e) {
		
		var cicloSelected = $(this).val();
		
		if(cicloSelected!=''){
			var datadata = 'ciclo_id='+ cicloSelected + '&getniveles=true';
			console.log(datadata);
			//Make AJAX request, using the selected value as the GET
            $.ajax({url: 'ajaxCombos.jsp',
                type: "post",
                data: datadata,
                success: function (output) {
                    //alert(output);
                    $('#nivelid').html(output);
                    $('#nivelSelect').show();
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status + " " + thrownError);
                }
            });
		}else{
			$('#nivelSelect').hide();
			$('#gradoSelect').hide();
			$('#grupoSelect').hide();
		}
		

	});
	
$('#cicloid').change(function(e) {
	
	$('#gradoSelect').hide();
	$('#grupoSelect').hide();
	
		var cicloSelected = $(this).val();
		
		if(cicloSelected!=''){
			var datadata = 'ciclo_id='+ cicloSelected + '&getniveles=true';
			//Make AJAX request, using the selected value as the GET
			console.log(datadata);
            $.ajax({url: 'ajaxCombos.jsp',
                type: "post",
                data: datadata,
                success: function (output) {
                    //alert(output);
                    $('#nivelid').html(output);
                    $('#nivelSelect').show();
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status + " " + thrownError);
                }
            });
		}else{
			$('#nivelSelect').hide();
			$('#gradoSelect').hide();
			$('#grupoSelect').hide();
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

$('#gradoid').change(function(e) {
	
	var cicloSelected = $('#cicloid').val();
	var nivelSelected = $('#nivelid').val();
	var gradoSelected = $(this).val();
	
	if(gradoSelected!=''){
		var datadata = 'nivel_id='+ nivelSelected + '&ciclo_id=' + cicloSelected + '&grado_id=' + gradoSelected + '&getgrupos=true';
		//Make AJAX request, using the selected value as the GET
		console.log(datadata);
        $.ajax({url: 'ajaxCombos.jsp',
            type: "post",
            data: datadata,
            success: function (output) {
                //alert(output);
                $('#grupoid').html(output);
                $('#grupoSelect').show();
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status + " " + thrownError);
            }
        });
	}else{
		//$('#nivelSelect').hide();
		//$('#gradoSelect').hide();
		$('#grupoSelect').hide();
	}
	

});

</script>

<%@ include file="../../cierra_elias.jsp"%>