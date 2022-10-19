<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<%@ include file= "menuPortal.jsp" %>


<script>
	jQuery('.materias').addClass('active');
</script>

<% 
	String escuelaId	= (String) session.getAttribute("escuela");
	String codigoId		= request.getParameter("codigoAlumno")!=null ? request.getParameter("codigoAlumno") : (String) session.getAttribute("codigoAlumno");
	String codigoPadre	= (String) session.getAttribute("codigoId");
	String cicloGrupoId	= request.getParameter("cicloGrupoId");
	String cursoId	    = request.getParameter("cursoId");
	String maestroId	= request.getParameter("maestroId");
	String ciclo 		= request.getParameter("ciclo")!=null ? request.getParameter("ciclo") : "";
	session.setAttribute("codigoAlumno", codigoId);
	
	String op = request.getParameter("op")==null?"Bandeja":request.getParameter("op");
	
	
	
%>


<style>
	.boxsizingBorder {
	    -webkit-box-sizing: border-box;
	       -moz-box-sizing: border-box;
	            box-sizing: border-box;
	}
	.noLeido td{
		font-weight: bold;
		background: white;
	}
</style>

<div id="content">
	
	<h2>Mensajes</h2>
	
	<div class="well">
		<a href="materias.jsp" class="btn btn-primary"><i class="icon-arrow-left icon-white"></i> <fmt:message key="boton.Regresar" /></a>
		<a data-toggle="modal" data-id="<%= escuelaId %>" data-tipodestino="A" class="open-NuevoMsg btn btn-info" href="#nuevoMsg"><i class="icon-envelope icon-white"></i> Mensaje A la Administración</a>
	</div>
	


	<ul class="nav nav-tabs">
	  <li <% if(op.equals("Bandeja"))out.print("class='active'"); %> id="bandeja">
	    <a href="javascript:msgsRecibidos()"><fmt:message key="aca.Bandeja" /></a>
	  </li>
	  <li <%if(op.equals("Enviados"))out.print("class='active'"); %> id="enviados">
	    <a href="javascript:msgsEnviados()"><fmt:message key="aca.Enviados" /></a>
	  </li>
	</ul>

<%
	if(false){
%>
		<div class="alert alert-info">Usted no tiene mensajes.</div>
<%
	}else{
%>

		<table class="table table-nohover table-bordered"  style="background:#F6F6F6;">
			<tr >
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
		<div id="respuestaBox" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		    <h3 id="myModalLabel">Responder mensaje</h3>
		  </div>
		  <div class="modal-body ">
		  <form id="formRespdMsg" method="post" >
		  		<label for="asunto">Asunto</label>
		  		<input type="text" name="asunto" id="asunto" value="RE " readonly="readonly">
		        <textarea name="Comentario"  class="boxsizingBorder" id="Comentario" style="width:100%;height:80px;margin:0;" placeholder="Escribe tu Mensaje Aqui"></textarea>
		        <input type="file" name="adjunto" id="adjunto">
		        <input type="hidden" id="destino" value="">
		        <input type="hidden" id="complemento" value="">
		        <input type="hidden" id="envia" value="<%= codigoId %>">
		        <input type="hidden" id="idmsg" value="">
		        </form>
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
		    <a class="btn btn-primary" href="javascript:enviaMsg()"><i class="icon-envelope icon-white"></i> <fmt:message key="boton.EnviarMensaje" /></a>
		  </div>
		</div>
	<!-- END MODAL -->
	
	<!-- MODAL -->
		<div id="nuevoMsg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		    <h3 id="myModalLabel">Responder mensaje</h3>
		  </div>
		  <div class="modal-body ">
		  <form id="formSendMsg" method="post" >
		  		<label for="asunto">Asunto</label>
		  		<input type="text" name="asunto" id="asunto" value="">
		        <textarea name="Comentario"  class="boxsizingBorder" id="Comentario" style="width:100%;height:80px;margin:0;" placeholder="Escribe tu Mensaje Aqui"></textarea>
		        <input type="hidden" id="destino" value="">
		        <input type="hidden" id="tipodestino" value="D">
		        <input type="hidden" id="envia" value="<%= codigoId %>">
		        <input type="file" name="adjunto" id="adjunto">
		        </form>
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
		    <a class="btn btn-primary" href="javascript:enviaMsgN()"><i class="icon-envelope icon-white"></i> <fmt:message key="boton.EnviarMensaje" /></a>
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
		<div id="removeBox" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		    <h3 id="myModalLabel">¿Eliminar mensaje?</h3>
		  </div>
		  <div class="modal-body ">
		  		<strong>¿Está completamente seguro de eliminar el mensaje?<br>La operacion no es reversible</strong>
		  		<input type="hidden" id="idmsg" value="">
		  </div>
		  <div class="modal-footer">
		    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
		    <a class="btn btn-danger" href="javascript:enviaMsg()"><i class="icon-trash icon-white"></i> Eliminar Mensaje</a>
		  </div>
		</div>
<script>
	$(function(){
		var usuarioid = '<%= codigoId %>';
		var codigoid= '\'<%= codigoId %>\'';
		var ciclogpoid = '\'<%= cicloGrupoId %>\'';
		var escuela = '\'<%= escuelaId %>\'';
		var ciclo = '\'<%= ciclo %>\'';
		var tipodestino = '\'P\',\'I\',\'G\'';
		 console.log(codigoid);
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
			type : 'post',
			data : 'lista-mensajes=true&destino='+codigoid+','+ciclogpoid + ','+escuela+','+ ciclo +'&tipodestino='+tipodestino+'&usuario='+usuarioid,
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
		var codigoid= '<%= codigoId %>';
		var ciclogpoid = '\'<%= cicloGrupoId %>\'';
		var ciclo = '\'<%= ciclo %>\'';
		var escuela = '\'<%= escuelaId %>\'';
		var tipodestino = '\'P\',\'I\',\'G\'';
		 console.log(codigoid);
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
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
		var usuarioid = '<%= codigoId %>';
		var codigoid= '\'<%= codigoId %>\'';
		var ciclogpoid = '\'<%= cicloGrupoId %>\'';
		var ciclo = '\'<%= ciclo %>\'';
		var escuela = '\'<%= escuelaId %>\'';
		var tipodestino = '\'P\',\'I\',\'G\'';
		 console.log(codigoid);
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
			type : 'post',
			data : 'lista-mensajes=true&destino='+codigoid+','+ciclogpoid + ','+escuela+','+ ciclo +'&tipodestino='+tipodestino+'&usuario='+usuarioid,
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
	
	function showMsg(idmsg, enviados){
		var usuarioid = '<%= codigoId %>';
		console.log('lo que viene en enviados ' +  enviados)
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
			type : 'post',
			data : 'show-msg=true&idmsg='+idmsg+enviados+'&usuario='+usuarioid,
			cache : false,
			success : function(output) {
				$('#msg').html(output);
				$('#msg-'+idmsg).css('font-weight','normal');
				$('.listmsg').css('background-color','transparent ');
				$('#msg-'+idmsg).css('background-color','lightblue');
				//console.log(output);
			},
			error : function(xhr, ajaxOptions, thrownError) {
				console.log("error " + datadata);
				alert(xhr.status + " " + thrownError);
			}
		});
	}
	
	function enviaMsgN(){
		
		var datadata = 'envia_mensaje=true&envia='+$('#nuevoMsg #envia').val()
		+'&tipo_destino='+$('#nuevoMsg #tipodestino').val()+'&destino='+$('#nuevoMsg #destino').val()
		+'&asunto='+$('#nuevoMsg #asunto').val()+'&mensaje='
		+$('#nuevoMsg #Comentario').val();
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
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
	
function enviaMsgNFile(idmsg, formularioId) {
		
		var formData = new FormData(document.getElementById(formularioId));
        formData.append("dato", "valor");
        formData.append("idmsg", idmsg);
        //formData.append(f.attr("name"), $(this)[0].files[0]);
        $.ajax({
            url: "../../mensajes/uploadFile.jsp",
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

	
	function enviaMsg(){
		
			var datadata = 'envia_mensaje=true&envia='+$('#envia').val()
			+'&tipo_destino=P&destino='+$('#destino').val()
			+'&asunto='+$('#asunto').val()+'&mensaje='
			+$('#Comentario').val()+'&mensaje_original='+$('#idmsg').val()+'&es_respuesta=true';
			$.ajax({
				url : '../../mensajes/accionMensajes.jsp',
				type : 'post',
				data : datadata,
				cache : false,
				success : function(output) {
					var idmsg = parseInt(output)
					
					if ($('#formRespdMsg #adjunto').get(0).files.length === 0) {
						console.log(output + ' no tiene adjunto ' + idmsg );
					}else{
						console.log(output + ' tiene adjunto ' + idmsg );
						if(idmsg>=0)
							enviaMsgNFile(idmsg, 'formRespdMsg');
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
	
	function eliminaMsg(){

		var datadata = 'elimina_mensaje=true&idmsg='+$('#idmsg').val();
		$.ajax({
			url : '../../mensajes/accionMensajes.jsp',
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
	$(document).on("click", ".open-RespuestaBox", function () {
	    var destinatario = $(this).data('id');
	    var asunto = $(this).data('asunto');
	    var idmsg = $(this).data('idmsg');
	    
	    $(".modal-body #destino").val( destinatario );
	    $(".modal-body #asunto").val( asunto );
	    $(".modal-body #idmsg").val( idmsg );
	    // As pointed out in comments, 
	    // it is superfluous to have to manually call the modal.
	    // $('#addBookDialog').modal('show');
	});
	
	$(document).on("click", ".open-NuevoMsg", function () {
	    var destinatario = $(this).data('id');
	    $(".modal-body #destino").val( destinatario );
	    // As pointed out in comments, 
	    // it is superfluous to have to manually call the modal.
	    // $('#addBookDialog').modal('show');
	});
	
	
	$(document).on("click", ".open-RemoveBox", function () {
	    var idmsg = $(this).data('idmsg');
	    
	    $(".modal-body #idmsg").val( idmsg );
	    // As pointed out in comments, 
	    // it is superfluous to have to manually call the modal.
	    // $('#addBookDialog').modal('show');
	});
	//-->
</script>

<%@ include file= "../../cierra_elias.jsp" %>
