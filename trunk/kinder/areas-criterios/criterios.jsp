<%@page import="java.util.List"%>
<%@page import="aca.kinder.UtilAreas"%>
<%@page import="aca.kinder.Areas"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="CicloLista" scope="page" class="aca.ciclo.CicloLista"/>
<%

UtilAreas ua = new UtilAreas(conElias);

String escuelaId		= (String) session.getAttribute("escuela");	
if(request.getParameter("Ciclo")!=null){
	session.setAttribute("cicloId", request.getParameter("Ciclo"));	
}		
String cicloId			= (String) session.getAttribute("cicloId");
ArrayList<aca.ciclo.Ciclo> lisCiclo		= CicloLista.getListActivos(conElias, escuelaId, "ORDER BY CICLO_ID DESC");	
List<Areas> lsAreas = new ArrayList();
lsAreas.addAll(ua.getLsAreas(0L, "", cicloId, 1));

%>
<div id="content">

	<h2>
		<fmt:message key="kinder.criterios" />
	</h2>

	<form name="frmCiclo" action="criterios.jsp" method="post">
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
	<table style="width: 70%">
		<tr>
			<td>
			<label for="selecArea">Áreas:</label>
			<select name="areaid" id="areaid">
			<option value="">Seleccione un área ...</option>
				<% for(Areas a : lsAreas){ %>
				<option value="<%= a.getId() %>"><%= a.getArea() %></option>
				<% } %>
			</select>
			</td>
			<td style="width: 60%"><label for="criterio" class="control-label">Criterio / Indicador:</label>
			<input type="text" id="criteriotxt" name="criteriotxt" class="form-control" style="width: 95%"></td>
			<td style="text-align: right; padding-top: 17px"><input type="hidden" id="idCriterio" value=""><input type="button" id="guardarCriterio" value="Guardar" class="btn btn-default"></td>
		</tr>
	</table>
	</form>
	
	<div id="tablaAreas"> </div>
</div>
<div id="dialog-confirm" title="Confirmar" style="display:none;">
    <p>Está seguro de eliminar?</p>
</div>
<script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css" />
<script>


	function cargaTabla(datadata){
		$.ajax({
			url : 'ajaxCriterios.jsp',
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
	
	function modificar(idcriterio,criterio){
		$('#idCriterio').val(idcriterio);
		$('#criteriotxt').val(criterio);
		$('#criteriotxt').focus();
	}
	
	function eliminar(idcriterio,estado){
		var ciclo_id = '<%= cicloId %>';
		var area_id = $('#areaid').val();
		var datos = '&idcriterio='+idcriterio+'&estado='+estado+'&ciclo_id='+ciclo_id+'&area_id='+area_id+'&eliminar=true';
		console.log(datos);
		cargaTabla(datos);
	}
	
	$(function() { 
		
		if($('#areaid').val()!=''){
			var datos = 'ciclo_id=<%= cicloId %>&area_id='+$('#areaid').val();
			console.log(datos);
			cargaTabla(datos);
		}
		
	});
	
	$('#areaid').change(function(e){
		if($('#areaid').val()!=''){
			var datos = 'ciclo_id=<%= cicloId %>&area_id='+$('#areaid').val();
			console.log(datos);
			cargaTabla(datos);
		}
	});
	
	let txtIsEmpty = txt => txt.replace(/\s/g,'') === "";
	
	$('#guardarCriterio').click(function(e){
		console.log('si entra a guardar');
		var idcriterio = $("#idCriterio").val();	
		var criteriotxt = $('#criteriotxt').val();
		var areaid = $('#areaid').val();
		var ciclo_id = '<%= cicloId %>';
		var datos = '';
		if(txtIsEmpty(areaid)){
			alert("Debe tener seleccionada un área");
		}
		else if(txtIsEmpty(criteriotxt)){
			alert("Falta nombre del criterio/indicador");
		}
		else{
			if(idcriterio!=''){
				datos = 'idcriterio='+idcriterio+'&criterio='+criteriotxt+'&ciclo_id='+ciclo_id+'&area_id='+areaid+'&modificar=true';
			}else{
				datos = 'criterio='+criteriotxt+'&ciclo_id='+ciclo_id+'&area_id='+areaid+'&guardarCriterio=true';
			}
			console.log(datos);
			cargaTabla(datos);
			$('#idCriterio').val('');
			$('#criteriotxt').val('');
		}
		
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
