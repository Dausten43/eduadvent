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


%>
<div class="well">
<p>
<a href="menu.jsp" class="btn btn-primary"><i class="icon-white icon-arrow-left"></i> Regresar</a>&nbsp;&nbsp;
</p>
	<h3>Saldos Cuentas de Abono</h3>
	<p>
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
	</p>
</div>

<div id="tablaArea">

</div>
<script>

	$('#cta').change(function(){
		console.log($(this).val());
		if(!$.isNumeric($(this).val())){
			var datadata ='cta=' + $(this).val();
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