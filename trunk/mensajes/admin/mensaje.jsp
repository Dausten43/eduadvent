<%@page import="java.util.Collections"%>
<jsp:useBean id="cicloLista" scope="page" class="aca.ciclo.CicloLista" />
<%@ include file="../../con_elias.jsp"%>
<%@ include file="id.jsp"%>
<%@ include file="../../seguro.jsp"%>
<%@ include file="../../head.jsp"%>
<%@ include file="../../menu.jsp"%>

<%
	String escuelaId = (String) session.getAttribute("escuela");
		String codigoId = request.getParameter("codigoId") != null
				? request.getParameter("codigoId")
				: (String) session.getAttribute("codigoId");;

		String op = request.getParameter("op") == null ? "Bandeja" : request.getParameter("op");

		// Lista de ciclos activos en la escuela
		ArrayList<aca.ciclo.Ciclo> lisCiclo = cicloLista.getListActivos(conElias, escuelaId,
				"ORDER BY CICLO_ID");
		String ciclo = request.getParameter("ciclo") == null
				? aca.ciclo.Ciclo.getCargaActual(conElias, escuelaId)
				: request.getParameter("ciclo");
				
				
%>


<style>
.boxsizingBorder {
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box;
}

.noLeido td {
	font-weight: bold;
	background: white;
}
</style>

<div id="content">

	<h2>Mensajes</h2>

	<div class="well">
		<a href="/escuela/general/inicio/index.jsp" class="btn btn-primary"><i
			class="icon-arrow-left icon-white"></i> <fmt:message
				key="boton.Regresar" /></a> <a data-toggle="modal"
			data-id="<%=escuelaId%>" data-tipodestino="A"
			class="open-NuevoMsg btn btn-info" href="#nuevoMsg"><i
			class="icon-envelope icon-white"></i> Mensaje A Personal</a> 
<!-- 			<a -->
<%-- 			data-toggle="modal" data-id="<%=escuelaId%>" data-tipodestino="I" --%>
<!-- 			class="open-NuevoMsg btn btn-success" href="#nuevoMsg"><i -->
<!-- 			class="icon-envelope icon-white"></i> Mensaje A Padres</a> -->
	</div>
	<div>
		<form class="form-inline">
			<span id="cicloSelect"> <select class="input" name="ciclo_id"
				id="cicloid">
					<option value="<%= escuelaId %>">A todos los padres</option>
					<%
						String nivel_calificacion = "";
							System.out.println("ciclo  " + ciclo);
							Collections.reverse(lisCiclo);
							for (aca.ciclo.Ciclo c : lisCiclo) {
					%>
					<option data-nivel="<%=c.getNivelEval()%>"
						value="<%=c.getCicloId()%>"
						<%=c.getCicloId().equals(ciclo) ? " selected " : ""%>><%=c.getCicloNombre()%>
					</option>
					<%
						if (c.getCicloId().equals(ciclo)) {
									nivel_calificacion = c.getNivelEval();
								}
							}
					%>
			</select>
			</span> <span id="cicloGpoIdSelect"> <select class="input"
				name="ciclo_gpo_id" id="ciclo_gpo_id">
			</select>
			</span> <a			data-toggle="modal" data-id="<%=escuelaId%>" data-tipodestino="I"			class="open-NuevoMsg btn btn-success" href="#nuevoMsg"><i			class="icon-envelope icon-white"></i> Mensaje A Padres</a>
		</form>
	</div>


	<ul class="nav nav-tabs">
		<li <%if (op.equals("Bandeja"))
					out.print("class='active'");%>
			id="bandeja"><a href="javascript:msgsRecibidos()"><fmt:message
					key="aca.Bandeja" /></a></li>
		<li <%if (op.equals("Enviados"))
					out.print("class='active'");%>
			id="enviados"><a href="javascript:msgsEnviados()"><fmt:message
					key="aca.Enviados" /></a></li>
	</ul>

	<%
		if (false) {
	%>
	<div class="alert alert-info">Usted no tiene mensajes.</div>
	<%
		} else {
	%>

	<table class="table table-nohover table-bordered"
		style="background: #F6F6F6;">
		<tr>
			<td id="mensajes" style="width: 45%;"></td>
			<td id="msg" rowspan="2"></td>
		</tr>
		<tr>
			<td id="anteriores"></td>
		</tr>

	</table>
	<%
		}
	%>
</div>
<!-- MODAL -->
<div id="respuestaBox" class="modal hide fade" tabindex="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">x</button>
		<h3 id="myModalLabel">Responder mensaje</h3>
	</div>
	<div class="modal-body ">
	<form id="formRespMsg" method="post" >
		<label for="asunto">Asunto</label> <input type="text" name="asunto"
			id="asunto" value="RE " readonly="readonly">
		<textarea name="Comentario" class="boxsizingBorder" id="Comentario"
			style="width: 100%; height: 80px; margin: 0;"
			placeholder="Escribe tu Mensaje Aqui"></textarea>
		<input type="hidden" id="destino" value=""> <input
			type="hidden" id="complemento" value=""> <input type="hidden"
			id="envia" value="<%=codigoId%>"> <input type="hidden"
			id="idmsg" value="">
			<input type="file" name="adjunto" id="adjunto">
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">
			<i class="icon-remove"></i>
			<fmt:message key="boton.Cancelar" />
		</button>
		<a class="btn btn-primary" href="javascript:enviaMsg()"><i
			class="icon-envelope icon-white"></i> <fmt:message
				key="boton.EnviarMensaje" /></a>
				
	</div>
</div>
<!-- END MODAL -->

<!-- MODAL -->
<div id="nuevoMsg" class="modal hide fade" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">x</button>
		<h3 id="myModalLabel">Redactar Mensaje</h3>
	</div>
	<div class="modal-body ">
	<form id="formSendMsg" method="post" >
		<label for="asunto">Asunto</label> <input type="text" name="asunto"
			id="asunto" value="">
		<textarea name="Comentario" class="boxsizingBorder" id="Comentario"
			style="width: 100%; height: 80px; margin: 0;"
			placeholder="Escribe tu Mensaje Aqui"></textarea>
		<input type="hidden" id="destino" value=""> <input
			type="hidden" id="tipodestino" value=""> <input type="hidden"
			id="envia" value="<%=codigoId%>">
		<input type="hidden" id="envia_mensaje" name="envia_mensaje" value="true">	
		<input type="file" name="adjunto" id="adjunto">
	</form>		
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">
			<i class="icon-remove"></i>
			<fmt:message key="boton.Cancelar" />
		</button>
		<a class="btn btn-primary" href="javascript:enviaMsgN()"><i
			class="icon-envelope icon-white"></i> <fmt:message
				key="boton.EnviarMensaje" /></a>
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
				<p>El proceso se realizo correctamente.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>
		</div>
	</div>
</div>

<!-- end nuevo modal -->

<!-- MODAL -->
<div id="removeBox" class="modal hide fade" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">x</button>
		<h3 id="myModalLabel">¿Eliminar mensaje?</h3>
	</div>
	<div class="modal-body ">
		<strong>¿Está completamente seguro de eliminar el mensaje?<br>La
			operacion no es reversible
		</strong> <input type="hidden" id="idmsg" value="">
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">
			<i class="icon-remove"></i>
			<fmt:message key="boton.Cancelar" />
		</button>
		<a class="btn btn-danger" href="javascript:enviaMsg()"><i
			class="icon-trash icon-white"></i> Eliminar Mensaje</a>
	</div>
</div>
<script>
	$(function(){
		var codigoid= '\'<%=codigoId%>\'';
		
		var escuela = '\'<%=escuelaId%>\'';
		var tipodestino = '\'P\',\'D\',\'G\'';
		 console.log(codigoid);
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : 'lista-mensajes=true&destino='+codigoid+','+escuela+'&tipodestino='+tipodestino,
			cache : false,
			success : function(output) {
				$('#mensajes').html(output);
				//console.log(output);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	});
	
	
	function msgsEnviados(){
		var codigoid= '<%=codigoId%>';
		var escuela = '\'<%=escuelaId%>\'';
		var tipodestino = '\'P\',\'A\',\'G\',\'I\'';
		 console.log(codigoid);
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : 'lista-mensajes=true&envia='+codigoid+'&tipodestino='+tipodestino+'&enviados=true',
			cache : false,
			success : function(output) {
				$('#enviados').addClass('active');
				$('#bandeja').removeClass('active');
				$('#mensajes').html(output);
				$('#msg').html('');
				//console.log(output);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	}
	
	function msgsRecibidos(){
		var codigoid= '\'<%=codigoId%>\'';
		
		var escuela = '\'<%=escuelaId%>\'';
		var tipodestino = '\'P\',\'D\',\'G\'';
		console.log(codigoid);
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : 'lista-mensajes=true&destino=' + codigoid + ',' + escuela
					+ '&tipodestino=' + tipodestino,
			cache : false,
			success : function(output) {
				$('#enviados').removeClass('active');
				$('#bandeja').addClass('active');
				$('#mensajes').html(output);
				$('#msg').html('');
				//console.log(output);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	}

	function showMsg(idmsg, enviados) {
		console.log('lo que viene en enviados ' + enviados)
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : 'show-msg=true&idmsg=' + idmsg + enviados,
			cache : false,
			success : function(output) {
				$('#msg').html(output);
				$('#msg-' + idmsg).css('font-weight', 'normal');
				$('.listmsg').css('background-color', 'transparent ');
				$('#msg-' + idmsg).css('background-color', 'lightblue');
				//console.log(output);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	}

	function enviaMsg() {

		var datadata = 'envia_mensaje=true&envia=' + $('#formRespMsg #envia').val()
				+ '&tipo_destino=P&destino=' + $('#formRespMsg #destino').val() + '&asunto='
				+ $('#formRespMsg #asunto').val() + '&mensaje=' + $('#formRespMsg #Comentario').val()
				+ '&mensaje_original=' + $('#formRespMsg #idmsg').val()
				+ '&es_respuesta=true';
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : datadata,
			cache : false,
			success : function(output) {
			var idmsg = parseInt(output)
				
				if ($('#formRespMsg #adjunto').get(0).files.length === 0) {
					console.log(output + ' no tiene adjunto ' + idmsg );
				}else{
					console.log(output + ' tiene adjunto ' + idmsg );
					if(idmsg>=0)
						enviaMsgNFile(idmsg,'formRespMsg');
				}
				
				$('#respuestaBox').modal('toggle');
				$('#enviadoMsg').modal('show');
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});

	}
	
	function enviaMsgFile() {
		
		var datadata = new FormData(document.getElementById("formSendMsg"));

// 		var datadata = 'envia_mensaje=true&envia=' + $('#envia').val()
// 				+ '&tipo_destino=P&destino=' + $('#destino').val() + '&asunto='
// 				+ $('#asunto').val() + '&mensaje=' + $('#Comentario').val()
// 				+ '&mensaje_original=' + $('#idmsg').val()
// 				+ '&es_respuesta=true';
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : datadata,
			cache : false,
			success : function(output) {
				$('#respuestaBox').modal('toggle');
				$('#enviadoMsg').modal('show');
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});

	}

	function enviaMsgN() {
		
		var datadata = 'envia_mensaje=true&envia='
				+ $('#nuevoMsg #envia').val() + '&tipo_destino='
				+ $('#nuevoMsg #tipodestino').val() + '&destino='
				+ $('#nuevoMsg #destino').val() + '&asunto='
				+ $('#nuevoMsg #asunto').val() + '&mensaje='
				+ $('#nuevoMsg #Comentario').val() + '';
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : datadata,
			cache : false,
			success : function(output) {
				var idmsg = parseInt(output)
				
				if ($('#formSendMsg #adjunto').get(0).files.length === 0) {
					console.log(output + ' no tiene adjunto ' + idmsg );
				}else{
					console.log(output + ' tiene adjunto ' + idmsg );
					if(idmsg>=0)
						enviaMsgNFile(idmsg, 'formSendMsg');
				}
					
				
				$('#nuevoMsg').modal('toggle');
				$('#enviadoMsg').modal('show');
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});

	}
	
	function enviaMsgNFile(idmsg, formaId) {
		console.log(formaId);
		var formData = new FormData(document.getElementById(formaId));
        formData.append("dato", "valor");
        formData.append("idmsg", idmsg);
        //formData.append(f.attr("name"), $(this)[0].files[0]);
        $.ajax({
            url: "../uploadFile.jsp",
            type: "post",
            dataType: false,
            data: formData,
            cache: false,
            contentType: false,
     		processData: false
        })
            .done(function(res){
                $("#mensaje").html("Respuesta: " + res);
            });

	}

	function eliminaMsg() {

		var datadata = 'elimina_mensaje=true&idmsg=' + $('#idmsg').val();
		$.ajax({
			url : '../accionMensajes.jsp',
			type : 'post',
			data : datadata,
			cache : false,
			success : function(output) {
				$('#removeBox').modal('toggle');
				$('#enviadoMsg').modal('show');
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});

	}

	<!--
	$(document).on("click", ".open-NuevoMsg", function() {
		var destinatario = $(this).data('id');
		if($(this).data('tipodestino')=='I'){
			if($('#ciclo_gpo_id').val()==''){
				destinatario = $('#cicloid').val();
			}else{
				destinatario = $('#ciclo_gpo_id').val();
			}
		}
		var tipodestino = $(this).data('tipodestino');
		$(".modal-body #destino").val(destinatario);
		$(".modal-body #tipodestino").val(tipodestino);

		// As pointed out in comments, 
		// it is superfluous to have to manually call the modal.
		// $('#addBookDialog').modal('show');
	});

	$(document).on("click", ".open-RespuestaBox", function() {
		var destinatario = $(this).data('id');
		var asunto = $(this).data('asunto');
		var idmsg = $(this).data('idmsg');

		$(".modal-body #destino").val(destinatario);
		$(".modal-body #asunto").val(asunto);
		$(".modal-body #idmsg").val(idmsg);
		// As pointed out in comments, 
		// it is superfluous to have to manually call the modal.
		// $('#addBookDialog').modal('show');
	});

	$(document).on("click", ".open-RemoveBox", function() {
		var idmsg = $(this).data('idmsg');

		$(".modal-body #idmsg").val(idmsg);
		// As pointed out in comments, 
		// it is superfluous to have to manually call the modal.
		// $('#addBookDialog').modal('show');
	});
	//-->

	function correAjax(datadata, idSelect, idDiv) {
		$.ajax({
			url : '../../reporte/promedio/ajaxPromediosCombos.jsp',
			type : "post",
			data : datadata,
			cache : false,
			success : function(output) {
				//alert(output);
				$(idSelect).html(output);
				$(idDiv).show();
			},
			error : function(xhr, ajaxOptions, thrownError) {
				alert(xhr.status + " " + thrownError);
			}
		});
	}

	$('#cicloid').each(
			function(e) {

				var cicloSelected = $(this).val();

				console.log('data-nivel '
						+ $(this).find(':selected').data('nivel'));
				$('#nivel_calificacion').val(
						$(this).find(':selected').data('nivel'));
				var escuelaId = $('#escuela_id').val();
				console.log('Ciclo elegido = ' + cicloSelected);
				if (cicloSelected != '') {
					var datadata = 'ciclo_id=' + cicloSelected + '&escuela_id=<%= escuelaId %>'
							+ '&genera_combos=true&genera_grupos=true';
					var datadatab = 'ciclo_id=' + cicloSelected
							+ '&escuela_id=<%= escuelaId %>'
							+ '&genera_periodos=true';
					console.log('Revisa ciclos inicial ' + datadata);
					console.log('Revisa ciclos inicial ' + datadatab);
					correAjax(datadata, '#ciclo_gpo_id', '#cicloGpoIdSelect');
					//correAjax(datadatab,'#periodosId','#periodosDiv');
				} else {

					$('#materiasDiv').hide();
				}

			});

	$('#cicloid').change(
			function(e) {
				console.log("ciclo fue cambiado");
				var cicloSelected = $(this).val();
				var escuelaId = $('#escuela_id').val();
				console.log('data-nivel '
						+ $(this).find(':selected').data('nivel'));
				$('#nivel_calificacion').val(
						$(this).find(':selected').data('nivel'));
				if (cicloSelected != '') {
					var datadata = 'ciclo_id=' + cicloSelected + '&escuela_id=<%= escuelaId %>'
							+ '&genera_combos=true&genera_grupos=true';
					var datadatab = 'ciclo_id=' + cicloSelected
							+ '&escuela_id=<%= escuelaId %>'
							+ '&genera_periodos=true';
					//Make AJAX request, using the selected value as the GET
					console.log('Cambio ciclo ' + datadata);
					//$('#cicloGpoIdSelect').empty();
					correAjax(datadata, '#ciclo_gpo_id', '#cicloGpoIdSelect');
					//correAjax(datadatab,'#periodosId','#periodosDiv');
				} else {
					$('#materiasDiv').hide();
				}

			});
</script>

<%@ include file="../../cierra_elias.jsp"%>
