<%@page import="aca.fin.FinCuenta"%>
<%@page import="java.util.List"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="cuentaLista" scope="page"
	class="aca.fin.FinCuentaLista" />

<%

String escuelaId = session.getAttribute("escuela")!=null ? (String) session.getAttribute("escuela") : "000"; 

List<FinCuenta> lsCuentasA = cuentaLista.getListCuentas(conElias, escuelaId, " and CUENTA_AISLADA='S' ");
List<FinCuenta> lsCuentasC = cuentaLista.getListCuentas(conElias, escuelaId, " and CUENTA_AISLADA='N' ");

%>

<h2>Traspaso de saldos de cuentas de abono a cuenta corriente </h2>

<div class="well">
	<form name="frmRptCta" action="" class="form-inline">
		<div>
		<label>Cuenta de abono</label>
			<select id="ctaO">
				<% if(lsCuentasA.size()>0){  %>
				<option value="0">Seleccione...</option>
				<%  for(FinCuenta cta : lsCuentasA){ %>
				<option value="<%= cta.getCuentaId() %>"><%= cta.getCuentaId() %> <%= cta.getCuentaNombre() %></option>
				<% 
				}	
			}else{ %>
				<option value="0">No hay Cuentas Para Seleccionar...</option>
				<% } %>
			</select>
			
			&nbsp;&nbsp;&nbsp;&nbsp;
			
			<label>Cuenta Corriente</label>
			<select id="ctaD">
				<% if(lsCuentasC.size()>0){  %>
				<option value="0">Seleccione...</option>
				<%  for(FinCuenta cta : lsCuentasC){ %>
				<option value="<%= cta.getCuentaId() %>"><%= cta.getCuentaId() %> <%= cta.getCuentaNombre() %></option>
				<% 
				}	
			}else{ %>
				<option value="0">No hay Cuentas Para Seleccionar...</option>
				<% } %>
			</select>
			<input type="button" name="generar" id="generar" value="Iniciar Traspaso" class="btn btn-success hidden-print">
		</div>
	</form>
</div>
<div class="container">
<div id="tablaArea"></div>
</div>
<script>

	$('#generar').click(function(){
		$(this).attr("disabled", true);
		if(!$.isNumeric($('#ctaO').val()) && !$.isNumeric($('#ctaD').val())){
			var datadata ='ctaO=' + $('#ctaO').val()+'&ctaD=' + $('#ctaD').val()+ '&traspaso=true';
			$.ajax({url: 'ajaxTraspaso.jsp',
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