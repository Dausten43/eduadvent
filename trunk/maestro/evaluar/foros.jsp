<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<link rel="stylesheet" href="../../js-plugins/datepicker/datepicker.css" />
<link rel="stylesheet" type="text/css" href="../../css/foro.css">
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>

<%
	String maestroId 	= (String)session.getAttribute("codigoEmpleado");
	String cursoId = request.getParameter("CursoId")==null?"0":request.getParameter("CursoId");
	String cicloGrupoId = request.getParameter("CicloGrupoId")==null?"0":request.getParameter("CicloGrupoId");
	
	boolean notReadyForProduction = false;
%>

<script>
const DEFAULT_TEMA = {
	    cicloGrupoId: '<%=cicloGrupoId%>',
	    cursoId: '<%=cursoId%>',
	    titulo: null
	};
</script>
<div id=forum>
<!-- CREATE MODAL -->
	<div id="addTema" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
	    <h3 id="myModalLabel">Crear nuevo tema</h3>
	  </div>
	  <div class="modal-body ">
	  	<input type="hidden" name="temaId" id="temaId">
	  	<fieldset>
	  		<label for="titulo">Título:</label>
	  		<input type="text" name="titulo" id="titulo" placeholder="Título"></input>
	 		</fieldset>
	 		<fieldset>
	  		<label for="descripcion">Descripción:</label>
	        <textarea name="descripcion" class="boxsizingBorder" id="descripcion" style="width:100%;height:80px;margin:0;" placeholder="Puedes agregar una breve descripción del tema"></textarea>
	       </fieldset>
	        <%if(notReadyForProduction) { %>
	        <fieldset>
		        <div class="checkbox">
		        	<label>
		          		<input type="checkbox" name="agendado" id="agendado"> Agendado
		        	</label>
		      	</div>
	      	</fieldset>
	      	<div id="estaAgendado">
		      	<fieldset>
			      	<label for="fechaInicio">Fecha inicio:</label>
			  		<input type="text" name="fechaInicio" id="fechaInicio" size="10" maxlength="10"></input>
		  		</fieldset>
		  		
		  		<fieldset>
			  		<label for="fechaFinal">Fecha final:</label>
			  		<input type="text" name="fechaFinal" id="fechaFinal" size="10" maxlength="10"></input>
			  	</fieldset>
		  	</div>
	  	<%} %>
	  	<fieldset>
	        <div class="checkbox">
	        	<label>
	          		<input type="checkbox" name="visible" id="visible"> Visible
	        	</label>
	      	</div>
	     	</fieldset>
	     	
	     	<fieldset>
	        <div class="checkbox">
	        	<label>
	          		<input type="checkbox" name="cerrado" id="cerrado"> Cerrado
	        	</label>
	      	</div>
	     	</fieldset>
	  </div>
	  <div class="modal-footer">
	    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
	    <a class="btn btn-primary" data-dismiss="modal" @click="saveSubject()"><fmt:message key="boton.Guardar" /></a>
	  </div>
	</div>
<!-- END MODAL -->
	<header>
		<h1>Temas</h1>
		<a href="cursos.jsp" class="btn">Regresar</a>
		<a href="#addTema" class="btn btn-info" data-toggle="modal">Nuevo tema</a>
	</header>
	<section class="list-temas">
		<div v-for="tema in temas" class="tema" :id="tema.id">
		  <div class="tema-head">
		  	<img class="picture" src="../../empleado/personal/foto.jsp" width="300">
		  </div>
		  <div class="tema-body">
		  	<div class="tema-body-title">
		    	<h3 class="tema-title">{{ tema.titulo }}</h3>
		    	<div class="options">
		    		<a :href="'#editTema' + tema.id" data-toggle="modal">
						<i class="icon-pencil"></i>
					</a>
					<i class="icon-remove" @click="deleteSubject(tema.id)"></i>
				</div>
		    </div>
		    <div>
		    <span class="badge" :class="{'verde': tema.visible}" >{{ tema.visible ? "Visible" : "No visible" }}</span>
		    <span class="badge" :class="{'rojo': tema.cerrado, 'verde': !tema.cerrado}">{{ tema.cerrado ? "Cerrado" : "Abierto" }}</span>
		    </div>
		    <p>{{parseDate(tema.createdAt)}}</p>
		    <%if(notReadyForProduction){ %>
		  		<p v-if="tema.agendado">{{ tema.fechaInicio }} - {{ tema.fechaFinal }}</p>
		  	<%} %>
		    <p class="description-subject">{{ tema.descripcion ? tema.descripcion : "No tiene descripción" }}</p>
		    <button class="btn btn-info" @click="goComments(tema.id)">Entrar</button>
		  </div>
		  <!-- EDIT MODAL -->
			<div :id="'editTema' + tema.id" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="editModal" aria-hidden="true">
			  <div class="modal-header">
			    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
			    <h3 id="editModal">Editar tema</h3>
			  </div>
			  <div class="modal-body ">
			  	<input type="hidden" name="temaId" :id="'temaId-edit' + tema.id" :value="tema.id">
			  	<fieldset>
			  		<label for="titulo">Título:</label>
			  		<input type="text" name="titulo" :id="'titulo-edit' + tema.id" placeholder="Título" :value="tema.titulo"></input>
			 		</fieldset>
			 		<fieldset>
			  		<label for="descripcion">Descripción:</label>
			        <textarea name="descripcion" :id="'descripcion-edit' + tema.id" class="boxsizingBorder" :value="tema.descripcion" style="width:100%;height:80px;margin:0;" placeholder="Puedes agregar una breve descripción del tema"></textarea>
			       </fieldset>
			        <%if(notReadyForProduction) { %>
			        <fieldset>
				        <div class="checkbox">
				        	<label>
				          		<input type="checkbox" name="agendado" :id="'agendado-edit' + tema.id" :value="tema.agendado"> Agendado
				        	</label>
				      	</div>
			      	</fieldset>
			      	<div id="estaAgendado">
				      	<fieldset>
					      	<label for="fechaInicio">Fecha inicio:</label>
					  		<input type="text" name="fechaInicio" :id="'fechaInicio-edit' + tema.id" size="10" maxlength="10" :value="tema.fechaInicio"></input>
				  		</fieldset>
				  		
				  		<fieldset>
					  		<label for="fechaFinal">Fecha final:</label>
					  		<input type="text" name="fechaFinal" :id="'fechaFinal-edit' + tema.id" size="10" maxlength="10" :value="tema.fechaFinal"></input>
					  	</fieldset>
				  	</div>
			  	<%} %>
			  	<fieldset>
			        <div class="checkbox">
			        	<label>
			          		<input type="checkbox" name="visible" :id="'visible-edit' + tema.id" :value="tema.visible"> Visible
			        	</label>
			      	</div>
			     	</fieldset>
			     	
			     	<fieldset>
			        <div class="checkbox">
			        	<label>
			          		<input type="checkbox" name="cerrado" :id="'cerrado-edit' + tema.id" :value="tema.cerrado"> Cerrado
			        	</label>
			      	</div>
			     	</fieldset>
			  </div>
			  <div class="modal-footer">
			    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> <fmt:message key="boton.Cancelar" /></button>
			    <a class="btn btn-primary" data-dismiss="modal" @click="udpateSubject(tema.id)"><fmt:message key="boton.Guardar" /></a>
			  </div>
			</div>
			<!-- END MODAL -->
		</div>
	</section>
</div>
<script src="../../js-plugins/datepicker/datepicker.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function(){
	//dd/mm/YYYY
	var date;
	var today;
	
	const app = new Vue({
		el: "#forum",
		data:{
			temas: []
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
			
			goComments: temaId => {
				let params = {
						id: temaId,
						CicloGrupoId: '<%=cicloGrupoId%>',
					    CursoId: '<%=cursoId%>'
					};
				document.location = 'comentarios.jsp?' + generateParams(params);
			},

			deleteSubject: function(temaId) {
				if(confirm("¿Está seguro que desea eliminar el tema?")){
					fetch('http://localhost:8089/temas/'+temaId, {
						method: 'DELETE'
					})
				    .then( res => {
					    if(!res.ok)
				    		throw res.text();
			    		app.temas.splice(findIndexOfSubjectOnList(temaId), 1);
			    		return res.text();
					})
					.then(JSON.parse)
					.catch(async (err) => {
						console.log(await err);
					});
				}
			},

			saveSubject: function () {
				validateAnd(save);
			},

			udpateSubject: function (temaId) {
				validateAnd(update, temaId);
			}
		}
	});

	(function(){
		getTemas();

		<%if(notReadyForProduction) { %>
			// Set date formated for today
			date = new Date();
			let day = date.getDate() > 10 ? date.getDate(): "0" + date.getDate();
			let month = date.getMonth() > 9 ? date.getMonth() + 1 : "0" + (date.getMonth() + 1); 
			today = day + "/" + month + "/" + date.getFullYear();
			
			document.getElementById("fechaInicio").value = today;
			document.getElementById("fechaFinal").value = today;
	
			// Init datepicker
			$('#fechaInicio').datepicker();
			$('#fechaFinal').datepicker();
		
			// Hide and show date fields when schedule
			$("#estaAgendado").hide();
		
			let agendado = document.getElementById("agendado");
			
			agendado.addEventListener("change", () => $("#estaAgendado").toggle());
		 <%} %>
	})();
	
	function generateParams(objParams){
	    let params = "";
	    let size = Object.keys(objParams).length;
	    for(let key in objParams){
	        params += key + "=" + objParams[key];
	        if(--size > 0)
	            params += "&";
	    }
	    return params;
	}

	function validateAnd(action, temaId) {
		let actualTema = {...app.temas[findIndexOfSubjectOnList(temaId)]};
		let tema = mapObjectfromPrototypeForAction(actualTema ?? DEFAULT_TEMA);
		
		if(validateFields(tema)){
			action(tema);
		}
	}

	function validateFields(TEMA){
		let tituloElement;
		if(TEMA.id === undefined){
			tituloElement = document.getElementById("titulo");
			
			if(tituloElement.value.replace(" ", "").length <= 0) {
				alert("Ingrese un título para el tema");
				return false;
			}
			else
				return true;
		}
		else if(TEMA.id !== undefined) {
			tituloElement = document.getElementById("titulo-edit" + TEMA.id);
			
			if(tituloElement.value.replace(" ", "").length <= 0) {
				alert("Ingrese un título para el tema");
				return false;
			}
			else
				return true;
		}
	}

	function mapObjectfromPrototypeForAction(temaPrototype){
		const Tema = {...temaPrototype};

		if(Tema.id === undefined){
			Tema["titulo"] = document.getElementById("titulo").value;
			Tema["descripcion"] = document.getElementById("descripcion").value;
			<%if(notReadyForProduction) { %>
				Tema["agendado"] = document.getElementById("agendado").checked;
				Tema["fechaInicio"] = document.getElementById("fechaInicio").checked ? new Date(fechaInicioElement.value).toISOString() : null;
				Tema["fechaFinal"] = document.getElementById("fechaFinal").checked ? new Date(fechaFinalElement.value).toISOString() : null;
			 <%} %>
			Tema["visible"] = document.getElementById("visible").checked;
			Tema["cerrado"] = document.getElementById("cerrado").checked;
		}
		else if(Tema.id !== undefined){
			Tema["titulo"] = document.getElementById("titulo-edit" + Tema.id).value;
			Tema["descripcion"] = document.getElementById("descripcion-edit" + Tema.id).value;
			<%if(notReadyForProduction) { %>
				Tema["agendado"] = document.getElementById("agendado-edit" + Tema.id).checked;
				Tema["fechaInicio"] = document.getElementById("fechaInicio-edit" + Tema.id).checked ? new Date(fechaInicioElement.value).toISOString() : null;
				Tema["fechaFinal"] = document.getElementById("fechaFinal-edit" + Tema.id).checked ? new Date(fechaFinalElement.value).toISOString() : null;
			 <%} %>
			Tema["visible"] = document.getElementById("visible-edit" + Tema.id).checked;
			Tema["cerrado"] = document.getElementById("cerrado-edit" + Tema.id).checked;
		}

		return Tema;
	}

	function getTemas() {
		let params = generateParams({
			codigoId:'<%=maestroId%>',
			cursoId:'<%=cursoId%>',
			cicloGrupoId:'<%=cicloGrupoId%>'
		});
		
		fetch('http://localhost:8089/temas?' + params, {
			method: 'GET'
		})
	    .then( res => res.text())
	    .then(listaTemas => app.temas = JSON.parse(listaTemas));
	}
	
	function save(){
		let tema = mapObjectfromPrototypeForAction(DEFAULT_TEMA);
		fetch('http://localhost:8089/temas', {
			method: 'POST',
			body: JSON.stringify(tema),
			headers:{
			    'Content-Type': 'application/json'
			}
		})
	    .then( res => res.text())
	    .then(JSON.parse)
	    .then(tema => {
		    app.temas.unshift(tema);
		    return tema.id;
	    })
	    .finally(resetFieldsModalForm);
	}

	function update(tema) {
		
		fetch('http://localhost:8089/temas', {
			method: 'PUT',
			body: JSON.stringify(tema),
			headers:{
			    'Content-Type': 'application/json'
			}
		})
	    .then( res => res.text())
	    .then(JSON.parse)
	    .then(tema => {
		    let localTema = app.temas[findIndexOfSubjectOnList(tema.id)];
		    localTema.titulo = tema.titulo;
		    localTema.descripcion = tema.descripcion;
		    localTema.agendado = tema.agendado;
		    localTema.fechaInicial = tema.fechaInicial;
		    localTema.fechaFinal = tema.fechaFinal;
		    localTema.visible = tema.visible;
		    localTema.cerrado = tema.cerrado;
	    })
	    .finally(resetFieldsModalForm);
	}

	function resetFieldsModalForm() {
		document.getElementById("temaId").value = "";
		document.getElementById("titulo").value = "";
		document.getElementById("descripcion").value = "";
		<%if(notReadyForProduction) { %>
			document.getElementById("agendado").checked = false;
			document.getElementById("fechaInicio");
			document.getElementById("fechaFinal");
		<%} %>
		document.getElementById("visible").checked = false;
		document.getElementById("cerrado").checked = false;
	}

	function findIndexOfSubjectOnList(subjectId) {
		return app.temas.findIndex(subject => subject.id === subjectId);
	}
});
</script>
<%@ include file= "../../cierra_elias.jsp" %>