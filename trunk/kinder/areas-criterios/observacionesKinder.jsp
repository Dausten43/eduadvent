<%@page import="java.util.HashMap"%>
<%@page import="aca.kardex.KrdxAlumObs"%>
<%@page import="java.util.Map"%>
<%@page import="aca.kardex.UtilKrdxAlumObs"%>
<%@page import="java.util.List"%>
<%@page import="aca.kardex.KrdxCursoAct"%>
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>
<jsp:useBean id="krdxCursoActL" scope="page" class="aca.kardex.KrdxCursoActLista" />

<%@page import="java.util.ArrayList"%>
<%
String escuelaId = (String) session.getAttribute("escuela");
String codigoId = (String) session.getAttribute("codigoEmpleado");
String cicloId = (String) session.getAttribute("cicloId");
String cicloGrupoId = request.getParameter("CicloGrupoId");
String cursoId = request.getParameter("CursoId");

List<Integer> lsPeriodos = new ArrayList();
lsPeriodos.add(1);
lsPeriodos.add(2);
lsPeriodos.add(3);

ArrayList<KrdxCursoAct> lisKardexAlumnos = krdxCursoActL.getListAll(conElias, escuelaId," AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId
				+ "' ORDER BY ALUM_APELLIDO(CODIGO_ID)");

UtilKrdxAlumObs uk = new UtilKrdxAlumObs(conElias);
Map<String, KrdxAlumObs> mapObs = new HashMap();
mapObs.putAll(uk.getObservacionesComplexKey(0L, cicloGrupoId, "", 0));
%>
<div class="container">
<table class="table table-bordered">
<thead>
	<tr>
		<th >#</th>
		<th >Codigo</th>
		<th >Nombre</th>
		<th >Trimestre 1</th>
		<th >Trimestre 2</th>
		<th >Trimestre 3</th>
	</tr>

</thead>
<tbody>
	<% 
	int i = 1;
	for(KrdxCursoAct kal : lisKardexAlumnos){ %>
	<tr>
		<td><%= i %></td>
		<td><%= kal.getCodigoId() %></td>
		<td><%= aca.alumno.AlumPersonal.getNombre(conElias, kal.getCodigoId(), "APELLIDO") %></td>
		<% for(Integer pe : lsPeriodos){ 
		String id = "";
		String obs = "";
		String obs2 = "";
		String gly = "icon-plus";
		boolean isErr = false;
			
		if(mapObs.containsKey(kal.getCodigoId()+"-"+pe)){
			id = mapObs.get(kal.getCodigoId()+"-"+pe).getId().toString();
			obs = mapObs.get(kal.getCodigoId()+"-"+pe).getObservacion_1();
			obs2 = mapObs.get(kal.getCodigoId()+"-"+pe).getObservacion_2();
			gly = "icon-pencil";
			isErr = true;
		}
		%>
		<td  id="td-<%= kal.getCodigoId() %>-<%= pe %>" style="text-align: center;">
		<a data-toggle="modal" title="Observacion" data-idobs="<%= id %>" 
		data-obs="<%= obs %>" data-obs2="<%= obs2 %>" 
		data-id="<%= kal.getCodigoId()  %>" data-tipo="O" 
		data-periodo="<%= pe %>" class="open-ObsBox btn btn-default btn-mini" 
		href="#obsBox" id="O-<%= kal.getCodigoId() %>-<%= pe %>"><i class="<%= gly %>"></i></a>
		<% if(isErr){ %>
		&nbsp&nbsp&nbsp&nbsp<a href="#" onclick="borrar(<%= id %>,'<%= kal.getCodigoId() %>',<%= pe %>);" class="btn btn-danger btn-mini"><i class="icon-remove icon-white"></i></a>
		<% } %>
		</td>
		<% } %>
	</tr>
	<% 
	i++;
	} %>
</tbody>
</table>
</div>
<!-- MODAL -->
		<div id="obsBox" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		    <h3 id="myModalLabel">Observaciones</h3>
		  </div>
		  <div class="modal-body ">
		  <table style="width: 100%">
		  <tr>
		  		<td style="width: 50%">
		  		<label for="asunto">Fortalezas</label>
		  		<input type="text" name="observacion" id="observacion" onkeyup="mok(this);">
		  		<br>
		  		<span style="font-size: 8px">La observación tiene que ajustarse a 9 lineas para que pueda aparecer correctamente en el boletín</span>
		  		<input type="hidden" id="codigoid" value="">
		  		<input type="hidden" id="periodo" value="">
		  		<input type="hidden" id="tipo" value="">
		  		<input type="hidden" id="cicloGpoId" value="<%= cicloGrupoId %>">
		  		<input type="hidden" id="idobs" value="">
		  		
		  		</td>
		  		<td>
		  		<div id="divMok" style="width: 72px; font-size: 8px"></div>
		  		</td>
		  <tr>
		  		<td style="width: 50%">
		  		<label for="asunto">Cómo ayudar</label>
		  		<input type="text" name="observacion2" id="observacion2" onkeyup="mok(this);">
		  		<br>
		  		<span style="font-size: 8px">La observación tiene que ajustarse a 9 lineas para que pueda aparecer correctamente en el boletín</span>
		  		</td>
		  		<td>
		  		<div id="divMok" style="width: 72px; font-size: 8px"></div>
		  		</td>
		  </tr>		
		  </table>      
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
		    <a class="btn btn-primary" href="javascript:addObservacion()">Agregar observaciones</a>
		  </div>
		</div>
	<!-- END MODAL -->
		<!-- nuevo modal -->

<div class="modal fade" id="enviadoMsg" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Aviso</h4>
        </div>
        <div class="modal-body">
          <p>La peticion se ejecuto correctamente.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>
  
  <div class="modal fade" id="failMsg" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Aviso</h4>
        </div>
        <div class="modal-body">
          <p>El proceso no esta funcionando o hay problemas.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>

<!-- end nuevo modal -->
<script>
function mok(inp){
	$('#divMok').html($(inp).val());
}

$(document).on("click", ".open-ObsBox", function () {
    var codigoid = $(this).data('id');
    var periodo = $(this).data('periodo');
    var tipo = $(this).data('tipo');
    var observacion = $(this).data('obs');
    var observacion2 = $(this).data('obs2');
    var id = $(this).data('idobs');
    
    $(".modal-body #codigoid").val( codigoid );
    $(".modal-body #periodo").val( periodo );
    $(".modal-body #tipo").val( tipo );
    $(".modal-body #observacion").val( observacion );
    $(".modal-body #observacion2").val( observacion2 );
    $(".modal-body #idobs").val( id );
    // As pointed out in comments, 
    // it is superfluous to have to manually call the modal.
    // $('#addBookDialog').modal('show');
});

function limpiaForma(){
	$('#codigoid').val('');
	$('#periodo').val('');
	$('#observacion').val('');
	$('#observacion2').val('');
	$('#idobs').val('');
	
}

function addObservacion(){
	
	var datadata = 'codigoid='+$('#codigoid').val()
	+'&cicloGpoId='+$('#cicloGpoId').val()
	+'&periodo='+$('#periodo').val()
	+'&tipo='+$('#tipo').val()
	+'&observacion='+$('#observacion').val()
	+'&observacion2='+$('#observacion2').val()
	+'&id='+$('#idobs').val()
	+'&guardar=true';
	
	var idremove = 'td-'+$('#codigoid').val()+'-'+$('#periodo').val();
	
	$.ajax({
		url : 'accionObservaciones.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			var idobs = parseInt(output);
				if(idobs>0){
					var iSelector = $('#'+$('#tipo').val()+'-'+$('#codigoid').val()+'-'+$('#periodo').val()).find('i');
					if(iSelector.hasClass('icon-plus')){
						iSelector.removeClass('icon-plus');
						iSelector.addClass('icon-pencil');
					}
					$('#td-'+$('#codigoid').val()+'-'+$('#periodo').val()).append('&nbsp&nbsp&nbsp&nbsp<a href="#" onclick="borrar('+idobs+',\''+$('#codigoid').val()+'\','+$('#periodo').val()+');" class="btn btn-danger btn-mini"><i class="icon-remove icon-white"></i></a>');
					$('#'+$('#tipo').val()+'-'+$('#codigoid').val()+'-'+$('#periodo').val()).data('idobs',idobs);
					$('#'+$('#tipo').val()+'-'+$('#codigoid').val()+'-'+$('#periodo').val()).data('obs',$('#observacion').val());
					$('#'+$('#tipo').val()+'-'+$('#codigoid').val()+'-'+$('#periodo').val()).data('obs2',$('#observacion2').val());
					$('#obsBox').modal('toggle');
					$('#enviadoMsg').modal('show'); 
					limpiaForma();
				}else{
					$('#obsBox').modal('toggle');
					$('#failMsg').modal('show'); 
				}
						
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
			$('#obsBox').modal('toggle');
			$('#failMsg').modal('show'); 
			
			
		}
	});

}


function borrar(idobs, codigoid, periodo){
	var datadata = 'id='+idobs+'&borrar=true';
	
	$.ajax({
		url : 'accionObservaciones.jsp',
		type : 'post',
		data : datadata,
		success : function(output) {
			$('#enviadoMsg').modal('show');
			$('#td-'+codigoid +'-'+periodo).empty();
			$('#td-'+codigoid +'-'+periodo).append('<a data-toggle="modal" title="Observacion" data-idobs="" data-obs="" data-obs2="" data-id="'+codigoid+'" data-tipo="O" data-periodo="'+periodo+'" class="open-ObsBox btn btn-default btn-mini" href="#obsBox" id="O-'+codigoid+'-'+periodo+'"><i class="icon-plus"></i></a>');
		},
		error : function(xhr, ajaxOptions, thrownError) {
			console.log("error " + datadata);
			alert(xhr.status + " " + thrownError);
			 
			
			
		}
	});
}
</script>	
<%@ include file="../../cierra_elias.jsp"%>