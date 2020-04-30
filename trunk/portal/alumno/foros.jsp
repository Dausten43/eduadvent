<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="aca.plan.PlanCurso"%>
<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>
<%@ include file= "menuPortal.jsp" %>

<jsp:useBean id="alumPersonal" scope="page" class="aca.alumno.AlumPersonal"/>
<jsp:useBean id="krdxCursoActLista" scope="page" class="aca.kardex.KrdxCursoActLista"/>
<jsp:useBean id="CicloGrupoCursoLista" scope="page" class="aca.ciclo.CicloGrupoCursoLista"/>

<link rel="stylesheet" type="text/css" href="../../css/foro.css">
<%
	boolean notReadyForProduction = false;
	
	String cicloGrupoId = aca.kardex.KrdxCursoAct.getAlumGrupo(conElias, codigoAlumno, cicloId);

	//LISTA DE LOS NOMRBES DE LOS CURSOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKrdx = krdxCursoActLista.getListAll(conElias, escuelaMenu, "AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID),CURSO_NOMBRE(CURSO_ID)");
	ArrayList<String> cursosIds = new ArrayList<>();
	Map<String, String> cursosNombres = new HashMap<>();
	for(aca.kardex.KrdxCursoAct kca: lisKrdx){
		cursosIds.add(kca.getCursoId());
		cursosNombres.put(kca.getCursoId(), PlanCurso.getCursoNombre(conElias, kca.getCursoId()));
	}
	
	//LISTA DE MAESTROS
	ArrayList<aca.ciclo.CicloGrupoCurso> lisGrupoCurso	= CicloGrupoCursoLista.getListMateriasGrupo(conElias, cicloGrupoId, "ORDER BY ORDEN_CURSO_ID(CURSO_ID)");
	HashMap<String, String> cursosMaestrosIds = new HashMap<>();
	for(aca.ciclo.CicloGrupoCurso grupoCurso: lisGrupoCurso){
		cursosMaestrosIds.put(grupoCurso.getCursoId(), grupoCurso.getEmpleadoId());
	}

	String cursosNombresJson = new Gson().toJson(cursosNombres);
	String cursosIdsJson = new Gson().toJson(cursosIds);
	String cursosMaestrosJson = new Gson().toJson(cursosMaestrosIds);
%>
<script>

const cursosIds = <%=cursosIdsJson%>;
const cursosNombres = <%=cursosNombresJson%>
const cursosMaestrosIds = <%=cursosMaestrosJson%>

</script>
<div id=forum>
	<header>
		<h1>Temas</h1>
	</header>
	<section class="list-temas">
		<div v-for="tema in temas" v-if="tema.visible" class="tema" :id="tema.id">
		  <div class="tema-head">
	  	  	<img class="picture" :src="'../../maestro/evaluar/imagen.jsp?mat=' + cursosMaestrosIds[tema.cursoId]" width="300">
		  </div>
		  <div class="tema-body">
		  	<div class="tema-body-title">
		    	<h3 class="tema-title">{{ tema.titulo }}</h3>
		    	<p>{{tema.cursoId}}</p>
		    </div>
		    <p>{{ cursosNombres[tema.cursoId] }}</p>
		    <div>
		    <span class="badge" :class="{'rojo': tema.cerrado, 'verde': !tema.cerrado}">{{ tema.cerrado ? "Cerrado" : "Abierto" }}</span>
		    </div>
		    <p>{{ parseDate(tema.createdAt)}}</p>
		    <%if(notReadyForProduction){ %>
		  		<p v-if="tema.agendado">{{ tema.fechaInicio }} - {{ tema.fechaFinal }}</p>
		  	<%} %>
		    <p class="description-subject">{{ tema.descripcion ? tema.descripcion : "No tiene descripción" }}</p>
		    <button class="btn btn-info" @click="goComments(tema.id)">Entrar</button>
		  </div>
		</div>
	</section>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>
<script>
document.addEventListener("DOMContentLoaded", function(){
	const URL = "/edusystems/foros/temas";
	
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
				let tema = {...app.temas[findIndexOfSubjectOnList(temaId)]};
				let params = {
						id: temaId,
						CicloGrupoId: tema.cicloGrupoId,
					    CursoId: tema.cursoId
					};
				document.location = 'comentarios.jsp?' + generateParams(params);
			}
		}
	});

	(function(){
		cursosIds.forEach(cursoId => getTemas(cursoId));
	})();
	
	function getTemas(cursoId) {
		let params = generateParams({
					cursoId,
					cicloGrupoId:'<%=cicloGrupoId%>'
				});
		
		fetch(URL + '?' + params, {
			method: 'GET'
		})
	    .then( res => res.text())
	    .then(JSON.parse)
	    .then(listaTemas => app.temas.push(...listaTemas));
	}

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

	function findIndexOfSubjectOnList(subjectId) {
		return app.temas.findIndex(subject => subject.id === subjectId);
	}
});
</script>
<%@ include file="../../cierra_elias.jsp" %>