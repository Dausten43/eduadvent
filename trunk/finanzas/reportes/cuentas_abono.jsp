<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="aca.fin.FinCuenta"%>
<%@page import="java.util.List"%>
<%@page import="aca.fin.FinCuentaLista"%>
<%@page import="aca.fin.FinAlumSaldos"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<%

String escuelaId = session.getAttribute("escuela")!=null ? (String) session.getAttribute("escuela") : "000";

FinCuentaLista fc = new FinCuentaLista();
List<FinCuenta> lsCuentas = fc.getListCuentas(conElias, escuelaId, " and CUENTA_AISLADA='S' ");

Calendar cal = Calendar.getInstance();
cal.set(Calendar.DAY_OF_MONTH,1);
cal.set(Calendar.MONTH,0);



String fecha = "";
SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
fecha = sdf.format(new Date());

if(request.getParameter("fecha")!=null){
	fecha = request.getParameter("fecha");
}
String fechai = sdf.format(cal.getTime());

%>
<link rel="stylesheet" href="../../bootstrap/datepicker/datepicker.css" />
<script type="text/javascript"	src="../../bootstrap/datepicker/datepicker.js"></script>
<div class="well">
<p>
<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
</p>
	<h3>Saldos Cuentas de Abono</h3>
	<form name="frmRptCta" action="" class="form-inline">
	<div>
		<select id="cta">
		<% if(lsCuentas.size()>0){  %>
			<option value="0">Seleccione...</option>
			<%  for(FinCuenta cta : lsCuentas){ %>
			<option value="<%= cta.getCuentaId() %>"><%= cta.getCuentaNombre() %></option>
	 	<% 
				}	
			}else{ %>
	 		<option value="0">No hay Cuentas Para Seleccionar...</option>
	 	<% } %>	
		</select>
		<label>Fecha inicial:</label><input type="text" name="fechaI" id="fechaI" data-date-format="dd-mm-yyyy" value="<%=fechai%>"  class="form-control" style="width: 100px; text-align: center;" >
		<label>Fecha final:</label><input type="text" name="fechaF" id="fechaF" data-date-format="dd-mm-yyyy" value="<%=fecha%>"  class="form-control" style="width: 100px; text-align: center;" >
		<input type="hidden" name="escuela" id="escuela" value="<%= escuelaId  %>">
		<input type="button" name="generar" id="generar" value="Generar" class="btn btn-success">
		</div>
	</form>
</div>

<div id="tablaArea">

</div>
<script>
jQuery('#fechaI').datepicker();
jQuery('#fechaF').datepicker();

	$('#generar').click(function(){
		console.log($('#cta').val());
		if(!$.isNumeric($('#cta').val())){
			var datadata ='cta=' + $('#cta').val()+ '&escuela='+$('#escuela').val() + '&fechai=' + $('#fechaI').val() + '&fechaf=' + $('#fechaF').val();
			$.ajax({url: 'ajaxCuentasAbono.jsp',
                type: "post",
                data: datadata,
                success: function (output) {
                    //alert(output);
                    $('#tablaArea').html(output);
                    
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status + " " + thrownError);
                }
            });
		}else{
			$('#tablaArea').empty();
		}
	});


</script>

<%@ include file="../../cierra_elias.jsp"%>