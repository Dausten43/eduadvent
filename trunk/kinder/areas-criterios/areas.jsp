<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<%
String escuelaId		= (String) session.getAttribute("escuela");	
if(request.getParameter("Ciclo")!=null){
	session.setAttribute("cicloId", request.getParameter("Ciclo"));	
}		
String cicloId			= (String) session.getAttribute("cicloId");
ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");	
%>
<div id="content">

	<h2>
		<fmt:message key="kinder.areas" />
	</h2>

	<form name="frmCiclo" action="areas.jsp" method="post">
		<input type="hidden" name="Accion">
		<div class="well">
			<select name="Ciclo" id="Ciclo"
				onchange="document.frmCiclo.submit();" class="input-xxlarge">
				<option>Seleccione....</option>
				<%
					for (aca.ciclo.Ciclo ciclo : lisCiclo) {
						int nivel;
						try{
							nivel = Integer.parseInt(ciclo.getNivelAcademicoSistema());
							if(0 <= nivel && nivel <= 2){
								%>
									<option value="<%=ciclo.getCicloId()%>"
									<%if (ciclo.getCicloId().equals(cicloId)) {
										out.print("selected");
									}%>><%=ciclo.getCicloNombre()%></option>
								<%
							}
						}catch(Exception e){
							System.out.println("Probable formato erroneo en la base de datos en el ciclo "+ciclo.getCicloNombre()+". ERROR => "+e);
						}
					}
				%>
			</select>
		</div>
	</form>
	<form>
	<table style="width: 50%">
		<tr>
			<td style="width: 80% ;vertical-align: bottom;"><label for="areatxt" class="control-label">Área:</label><input type="text" id="areatxt" name="area" class="form-control" style="width: 100%"><input type="hidden" id="idArea" value=""></td>
			<td style="text-align: right; padding-top: 17px"><input type="button" id="guardarArea" value="Guardar" class="btn btn-default"></td>
		</tr>
	</table>
	</form>
	
	<div id="tablaAreas"> </div>
</div>
<div id="dialog-confirm" title="Confirmar" style="display:none;">
    <p>¿Está seguro de eliminar?</p>
</div>
<script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css" />
<script>
	function cargaTabla(datadata){
		$.ajax({
			url : 'ajaxAreas.jsp',
			type : 'post',
			data : datadata,
			success : function(output) {
				$('#tablaAreas').html(output);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	}
	
	function modificar(idarea,area){
		$('#idArea').val(idarea);
		$('#areatxt').val(area);
		$('#areatxt').focus();
	}
	
	function eliminar(idarea,estado){
		var ciclo_id = '<%= cicloId %>';
		var datos = '&idarea='+idarea+'&estado='+estado+'&ciclo_id='+ciclo_id+'&eliminar=true';
		console.log(datos);
		cargaTabla(datos);
	}
	
	$(function() { 
		var datos = 'ciclo_id=<%= cicloId %>';
		cargaTabla(datos);
		
	});
	
		
		$('#guardarArea').click(function(e){
		console.log('si entra a guardar');
		var idarea = $("#idArea").val();	
		var areatxt = $('#areatxt').val();
		var ciclo_id = '<%= cicloId %>';
		var datos = '';
		if(idarea!=''){
			datos = '&idarea='+idarea+'&area='+areatxt+'&ciclo_id='+ciclo_id+'&modificar=true';
		}else{
			datos = 'area='+areatxt+'&ciclo_id='+ciclo_id+'&guardarArea=true';
		}
		console.log(datos);
		cargaTabla(datos);
		$('#idArea').val('');
		$('#areatxt').val('');
		return false;
	});
		
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
