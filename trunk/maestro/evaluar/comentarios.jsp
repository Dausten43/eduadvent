<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.plan.PlanCurso"%>
<%@page import="aca.ciclo.CicloGrupoCursoLista"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<link rel="stylesheet" type="text/css" href="../../css/comentarios.css">
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>

<%
	String codigoId 	= (String)session.getAttribute("codigoEmpleado");
	String escuelaId = codigoId.substring(0, 3);
	String temaId = request.getParameter("id")==null?"0":request.getParameter("id");
	String cursoId = request.getParameter("CursoId")==null?"0":request.getParameter("CursoId");
	String cicloGrupoId = request.getParameter("CicloGrupoId")==null?"0":request.getParameter("CicloGrupoId");
	
	//LISTA DE ALUMNOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKardexAlumnos			= new aca.kardex.KrdxCursoActLista().getListAll(conElias, escuelaId, " AND CICLO_GRUPO_ID = '" + cicloGrupoId + "' AND CURSO_ID = '" + cursoId + "' ORDER BY ORDEN, ALUM_APELLIDO(CODIGO_ID)");
	
	HashMap<String, String> alumnosNombres = new HashMap<>();
	for(aca.kardex.KrdxCursoAct alumno: lisKardexAlumnos){
		String nombre = aca.alumno.AlumPersonal.getNombre(conElias, alumno.getCodigoId(), "NOMBRE");
		alumnosNombres.put(alumno.getCodigoId(), nombre);
	}
	
	//LISTA DE MAESTROS
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso	= new CicloGrupoCursoLista().getListMateriasGrupo(conElias, cicloGrupoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	HashMap<String, String> maestrosNombres = new HashMap<>();
	for(aca.ciclo.CicloGrupoCurso grupoCurso: lisGrupoCurso){
		String nombre = aca.empleado.EmpPersonal.getNombre(conElias, grupoCurso.getEmpleadoId(), "NOMBRE");
		maestrosNombres.put(grupoCurso.getEmpleadoId(), nombre);
	}
	
	String cursoNombre = PlanCurso.getCursoNombre(conElias, cursoId);
	String cicloGrupoAlumnosJson = new Gson().toJson(alumnosNombres);
	String cicloGrupoMaestrosJson = new Gson().toJson(maestrosNombres);
	
	boolean notReadyForProduction = false;
%>
<script>
const temaId = '<%=temaId%>';
const alumnos = JSON.parse('<%=cicloGrupoAlumnosJson%>');
const maestros = JSON.parse('<%=cicloGrupoMaestrosJson%>');

const DEFAULT_COMENTARIO = {
		temaId: temaId,
	    codigoId: '<%=codigoId%>',
	    comentario: null,
	    respuestaId: -1
	};
</script>
<div id="forum">
	<div id="editComment" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="editComment" aria-hidden="true">
	  	<div class="modal-header">
	    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
	    	<h3 id="editComment">Editar comentario</h3>
	  	</div>
	  	<div class="modal-body ">
			<fieldset>
				<label for="descripcion">Comentario:</label>
	   			<textarea name="descripcion" class="boxsizingBorder" id="descripcion" style="width:100%;height:80px;margin:0;"></textarea>
	    	</fieldset>
	  	</div>
	  	<div class="modal-footer">
	    	<button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
	    	<a class="btn btn-primary" data-dismiss="modal" id="update-comment"><fmt:message key="boton.Guardar" /></a>
		</div>
	</div>
	<div id="respondComment" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="editComment" aria-hidden="true">
	  	<div class="modal-header">
	    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
	    	<h3>Responder comentario</h3>
	  	</div>
	  	<div class="modal-body ">
	  		<p style="font-weight: bold;">Comentario:</p>
		  	<p id="commentToRespond"></p>
		  	<input type="hidden" id="comentario-respuesta-id"/>
			<fieldset>
				<label for="descripcion" style="font-weight:bold; margin-top: 10px;">Respuesta:</label>
	   			<textarea name="descripcion-respuesta" class="boxsizingBorder" id="descripcion-respuesta" style="width:100%;height:80px;margin:0;" placeholder="Escribe aquí tu respuesta"></textarea>
	    	</fieldset>
	  	</div>
	  	<div class="modal-footer">
	    	<button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
	    	<a class="btn btn-primary" data-dismiss="modal" @click="addRespuesta()"><fmt:message key="boton.Guardar" /></a>
		</div>
	</div>
	<header>
		<h1>{{tema.titulo}}</h1>
	    <p v-if="tema.agendado">{{ parseDate(tema.createdAt) }}</p>
		<span class="badge" :class="{'verde': tema.visible}" >{{ tema.visible ? "Visible" : "No visible" }}</span>
	    <span class="badge" :class="{'rojo': tema.cerrado, 'verde': !tema.cerrado}">{{ tema.cerrado ? "Cerrado" : "Abierto" }}</span>
		<p class="description-subject">{{ tema.descripcion ? tema.descripcion : "No tiene descripción" }}</p>
		<a href="foros.jsp?CursoId=<%=cursoId%>&CicloGrupoId=<%=cicloGrupoId%>" class="btn">Regresar</a>
	</header>
	<section class="list-comentarios">
		<div v-for="comentario in comentarios" class="comentario" :id="comentario.id">
		  <div class="comentario-head">
	  	  	<img class="picture" :src="'imagen.jsp?mat=' + comentario.codigoId" width="300">
		    <p class="name">[{{comentario.codigoId}}]</p>
		    <p class="name">{{ comentario.codigoId.includes("E") ? maestros[comentario.codigoId] : alumnos[comentario.codigoId] }}</p>
		  </div>
		  <div class="comentario-body">
		  	<div class="date-publish">
	      		<p class="">{{ parseDate(comentario.createdAt) }}</p>
	      	</div>
	      	<div class="options">
			    <span class="badge click" id="outstanding" :class="{'outstanding': comentario.destacado}" @click="toogleDestacado(comentario.id, comentario.destacado)"><i class="icon-star icon-white"></i> </span>
			    <span class="badge click" href="#editComment" data-toggle="modal" @click="setInfoModalFromCommentToEdit(comentario.id)">
			    		<i class="icon-pencil icon-white"></i>
			    </span>
			    <span class="badge remove click" @click="deleteComment(comentario.id)">
			    	<i class="icon-remove icon-white"></i>
			    </span>
		    </div>
		    <div class="body">
		    	{{ comentario.comentario }}
		    	<div v-if="comentario.respuestaId !== -1" class="comentario-respuesta">
		    		<span style="font-weight:bold">En respuesta a</span> {{getFrom(comentario.respuestaId)}}:<br>
		    		{{getResponses(comentario)}}
		    	</div>
		    </div>
		    <a v-if="!tema.cerrado" class="respond" href="#respondComment" data-toggle="modal" @click="setInfoModalToRespondComment(comentario.id)">Responder</a>
		  </div>
		</div>
	</section>
	<section v-if="!tema.cerrado" class="escribir-comentario">
		<div class="editor-comentario">
			<textarea id="comentario" placeholder="Escribe tu comentario"></textarea>
			<a @click="addComment()" class="btn btn-info">Enviar comentario</a>
		</div>
	</section>
</div>
<script>
document.addEventListener("DOMContentLoaded", function(){
	const URL = "/edusystems/foros/temas";
	
	const app = new Vue({
		el: "#forum",
		data:{
			comentarios: [],
			tema: {}
		},
		methods: {
			parseDate: function (dateUnparsed){
				const date = new Date(dateUnparsed);
				let day = date.getDate() > 10 ? date.getDate(): "0" + date.getDate();
				let month = date.getMonth() > 9 ? date.getMonth() + 1 : "0" + (date.getMonth() + 1); 
				let hours = date.getHours() > 9 ? date.getHours() : "0" + date.getHours();
				let minutes = date.getMinutes() > 9 ? date.getMinutes() : "0" + date.getMinutes();
				let seconds = date.getSeconds() > 9 ? date.getSeconds() : "0" + date.getSeconds();
				let SSSZ = date.toISOString().split(".");

				const now = day + "/" + month + "/" + date.getFullYear() + " " + hours + ":" + minutes + ":" + seconds;
				return now;
			},

			deleteComment: function(comentarioId) {
				if(confirm("¿Está seguro que desea eliminar el comentario?")){
					fetch(URL+'/'+temaId+'/comentarios/'+comentarioId, {
						method: 'DELETE'
					})
				    .then( res => {
					    if(!res.ok)
				    		throw res.text();
			    		app.comentarios.splice(findIndexOfCommentOnList(comentarioId), 1);
					})
					.catch(async (err) => {
						console.log(await err);
					});
				}
			},

			toogleDestacado: function (comentarioId, destacado) {
				let comentario = app.comentarios[findIndexOfCommentOnList(comentarioId)];
				comentario.destacado = !destacado;
				fetch(URL+'/'+temaId+'/comentarios/'+comentarioId, {
					method: 'PUT',
					body: JSON.stringify({...comentario}),
					headers:{
					    'Content-Type': 'application/json'
					}
				})
			    .then( res => {
				    if(!res.ok)
			    		throw res.text();
				})
				.catch(async (err) => {
					console.log(await err);
					alert("No se pudo destacar");
					comentario.destacado = destacado; 
				});
			},

			setInfoModalFromCommentToEdit: function (comentarioId) {
				let comentario = app.comentarios[findIndexOfCommentOnList(comentarioId)];
				document.getElementById("descripcion").value = comentario.comentario;

				
				let btnEditar = document.getElementById("update-comment");
				btnEditar.addEventListener("click", function() {
					update(comentarioId);
					this.removeEventListener("click", arguments.callee);
				});
			},

			setInfoModalToRespondComment: function (comentarioId) {
				let comentario = app.comentarios[findIndexOfCommentOnList(comentarioId)];

				document.getElementById("commentToRespond").innerHTML = comentario.comentario;
				document.getElementById("comentario-respuesta-id").value = comentarioId;
				document.getElementById("descripcion-respuesta").value = "";
			},

			addRespuesta: () => add(document.getElementById("descripcion-respuesta").value, document.getElementById("comentario-respuesta-id").value),

			addComment: () => add(),

			getResponses: (comentario) => {
				const responseTo = app.comentarios[findIndexOfCommentOnList(comentario.respuestaId)];
				if (responseTo !== undefined)
					return responseTo.comentario;
				else
					return "Comentario eliminado"; 
			},

			getFrom: (respuestaId) => {
				const responseTo = app.comentarios[findIndexOfCommentOnList(respuestaId)];
				if (responseTo !== undefined)
					return responseTo.codigoId.includes("E") ? maestros[responseTo.codigoId] : alumnos[responseTo.codigoId];
			}
		}
	});

	(function(){
		getDetailsTema();
		getComentarios();
	})();

	function getDetailsTema() {
		fetch(URL+'/'+temaId, {
			method: 'GET'
		})
	    .then( res => res.text())
	    .then(JSON.parse)
	    .then(tema => app.tema = tema);
	}

	function getComentarios() {
		fetch(URL+'/'+temaId+'/comentarios', {
			method: 'GET'
		})
	    .then( res => res.text())
	    .then(JSON.parse)
	    .then(comentarios => app.comentarios = comentarios);
	}

	function add(descripcion = document.getElementById("comentario").value, 
				respuestaId = -1) 
	{
		let comentario = {...DEFAULT_COMENTARIO};

		comentario["comentario"] = descripcion;
		comentario["respuestaId"] = respuestaId;

		if(isNotEmpty(comentario)){
			fetch(URL+'/'+temaId+'/comentarios', {
				method: 'POST',
				body: JSON.stringify(comentario),
				headers:{
				    'Content-Type': 'application/json'
				}
			})
		    .then( res => res.text())
		    .then(JSON.parse)
		    .then(comentario => {
			    if(comentario.id) {
			    	app.comentarios.push(comentario);
			    	document.getElementById('comentario').value = "";
			    } else {
					alert("No se pudo añadir el comentario");
				}
			});
		}else {
			alert("No puede dejar en blanco su comentario");
		}
	}

	function update(comentarioId) {
		const comentario = {...app.comentarios[findIndexOfCommentOnList(comentarioId)]};
		
		comentario["comentario"] = document.getElementById("descripcion").value;

		if(isNotEmpty(comentario)){
			fetch(URL+'/'+temaId+'/comentarios/'+comentarioId, {
				method: 'PUT',
				body: JSON.stringify(comentario),
				headers:{
				    'Content-Type': 'application/json'
				}
			})
		    .then( res => res.text())
		    .then(JSON.parse)
		    .then(comentario => {
			    if(comentario.id) {
			    	app.comentarios[findIndexOfCommentOnList(comentarioId)]["comentario"] = comentario["comentario"];
			    } else {
					alert("No se pudo actualizar el comentario");
				}
			});
		}else {
			alert("No puede dejar en blanco el comentario");
		}
	}

	function isNotEmpty(comentario){
		return comentario.comentario.replace(" ", "").length > 0;
	}

	function mapObjectWithForm(){
		const comentario = {...DEFAULT_COMENTARIO};

		return comentario;
	}

	function findIndexOfCommentOnList(commentId) {
		return app.comentarios.findIndex(comment => comment.id === commentId);
	}
});
</script>
<%@ include file= "../../cierra_elias.jsp" %>