<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista" />
<%
	String escuelaId = (String) session.getAttribute("escuela");
		if (request.getParameter("Ciclo") != null) {
			session.setAttribute("cicloId", request.getParameter("Ciclo"));
		}
		String cicloId = (String) session.getAttribute("cicloId");
		ArrayList<aca.ciclo.Ciclo> lisCiclo = CicloLista.getListActivos(conElias, escuelaId,
				"ORDER BY CICLO_ID DESC");
%>
<div id="content">

	<h2>Transferencia de Áreas y Criterios / Indicadores para Kinder</h2>

	<form name="frmCiclo" method="post">
		<input type="hidden" name="Accion">
		<div class="well">
			<label>Ciclo Origen</label> 
			<select name="Ciclo" id="ciclo_origen" class="input-xxlarge">
				<%
					for (aca.ciclo.Ciclo ciclo : lisCiclo) {
						String nivel_ciclo = ciclo.getNivelAcademicoSistema()!=null ? ciclo.getNivelAcademicoSistema() : "0";
							if (nivel_ciclo.equals("0") || nivel_ciclo.equals("1")
									|| nivel_ciclo.equals("2")) {
				%>
				<option value="<%=ciclo.getCicloId()%>"
					<%if (ciclo.getCicloId().equals(cicloId)) {
							out.print("selected");
						}%>><%=ciclo.getCicloNombre()%></option>
				<%
					}
						}
				%>
			</select> 
			
			<label>Ciclo Destino</label> 
			<select name="Ciclo" id="ciclo_destino"	class="input-xxlarge">
				<%
					for (aca.ciclo.Ciclo ciclo : lisCiclo) {
						String nivel_ciclo = ciclo.getNivelAcademicoSistema()!=null ? ciclo.getNivelAcademicoSistema() : "0";
							if (nivel_ciclo.equals("0") || nivel_ciclo.equals("1")
									|| nivel_ciclo.equals("2")) {
				%>
				<option value="<%=ciclo.getCicloId()%>"
					<%if (ciclo.getCicloId().equals(cicloId)) {
							out.print("selected");
						}%>><%=ciclo.getCicloNombre()%></option>
				<%
					}
						}
				%>
			</select>
		</div>
	</form>

	
	<input type="text" id="btnIniciaTransferencia" value="Inicia Transferencia" class="btn btn-ready" onclick="transfiere(); return false;"><span style="color: green; font-size: 14px; font-weight: bold;"><i class="icon-ok icon-green" id="simbOK" ></i></span>
	<span style="color: red; font-size: 14px; font-weight: bold;"><i class="icon-remove icon-red"  id="simbNO" ></i></span>
<table class="table table-bordered">
	<tr>
		<td style="width: 50%"><div id="tablaOrigen"></div></td>
		<td style="width: 50%"><div id="tablaDestino"></div></td>
	</tr>
</table>

</div>
<script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css" />
<script>
$(document).ready(function () {
	console.log('trabajando');
	$('#btnIniciaTransferencia').hide();
	$('#tablaOrigen').empty();
	$('#simbNO').hide();
	$('#simbOK').hide();
	getOrigen();
	
});

$('#ciclo_origen, #ciclo_destino').change(function (){
	getOrigen();
	console.log('trabajando2');
	if($('#ciclo_origen').val()!=$('#ciclo_destino').val()){
		$('#btnIniciaTransferencia').show();
		$('#tablaOrigen').empty();
		$('#tablaDestino').empty();
		$('#btnIniciaTransferencia').attr('disabled',false);
		$('#simbNO').hide();
		$('#simbOK').hide();
		
	}else{
		$('#btnIniciaTransferencia').hide();
		
	}
});
function transfiere(){
	$('#btnIniciaTransferencia').attr('disabled',true);
	var ciclo_origen = $('#ciclo_origen').val();
	var ciclo_destino = $('#ciclo_destino').val();
	var textoDestino = $('#ciclo_destino option:selected').text()
	var datadata = 'ciclo_id=' + ciclo_origen + '&ciclo_destino=' + ciclo_destino + '&textoDestino='+ textoDestino + '&transfiere=true';
	console.log('destino ' + datadata);
	$.ajax({url: 'ajaxTransferencia.jsp',
        type: "post",
        data: datadata,
        success: function (output) {
            $('#tablaDestino').html(output);
            verResultado()
            //console.log(output);
        },
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status + " " + thrownError);
        }});
}

function verResultado(){
	if($('#resultado').val()=='false'){
		$('#simbNO').show();
	}else{
		$('#simbOK').show();
	}
}

function getOrigen(){
	var ciclo_origen = $('#ciclo_origen').val();
	var textoCiclo = $('#ciclo_origen option:selected').text()
	var datadata = 'ciclo_id=' + ciclo_origen + '&texto='+ textoCiclo + '&showOrigen=true';
    console.log('origen ' + datadata);
    $.ajax({url: 'ajaxTransferencia.jsp',
        type: "post",
        data: datadata,
        success: function (output) {
            $('#tablaOrigen').html(output);
            //console.log(output);

           
        },
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status + " " + thrownError);
        }});
}

</script>
<%@ include file="../../cierra_elias.jsp"%>