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

<link rel="stylesheet" type="text/css" href="../../css/foros/foros.css">
<%
	String cicloGrupoId = aca.kardex.KrdxCursoAct.getAlumGrupo(conElias, codigoAlumno, cicloId);
	//LISTA DE LOS NOMRBES DE LOS CURSOS
	ArrayList<aca.kardex.KrdxCursoAct> lisKrdx = krdxCursoActLista.getListAll(conElias, escuelaMenu, "AND CODIGO_ID = '"+codigoAlumno+"' AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY ORDEN_CURSO_ID(CURSO_ID),CURSO_NOMBRE(CURSO_ID)");
	System.out.println(lisKrdx.size());
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

const CicloGrupoId = '<%=cicloGrupoId%>';
const CursosIds = <%=cursosIdsJson%>;
const CursosNombres = <%=cursosNombresJson%>
const CursosMaestrosIds = <%=cursosMaestrosJson%>

</script>
<div id="foro">
	<header>
		<h1>Temas</h1>
	</header>
	<section class="lista-temas">
	    <div v-for="tema in temas" v-if="tema.visible" class="tema" :id="tema.id">
	        <div class="maestro" :class="{'bg-blue': true, 'bd-green': !tema.cerrado, 'bd-blue': tema.cerrado}">
	            <img class="foto" :src="'../../maestro/evaluar/imagen.jsp?mat=' + CursosMaestrosIds[tema.cursoId]" width="300">
	        </div>
	        <div class="contenido">
	            <div class="encabezado">
	                <h3 class="titulo">{{ tema.titulo }}</h3>
			    	<p>{{tema.cursoId}}</p>
	            </div>
		    	<p>{{ CursosNombres[tema.cursoId] }}</p>
	            <div>
	                <span class="badge" :class="{'bg-red': tema.cerrado, 'bg-green': !tema.cerrado}">{{ tema.cerrado ? "Cerrado" : "Abierto" }}</span>
	            </div>
	            <p>{{mapearFecha(tema.createdAt)}}</p>
	            <div class="descripcion" v-html="tema.descripcion"></div>
	            <button class="btn btn-info" @click="cambiarVistaAComentarios(tema.id, tema.cursoId)">Entrar</button>
	        </div>
	    </div>
	</section>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>
<script src="../../js/foros/ForoUtils.js"></script>
<script src="../../js/foros/API.js"></script>
<script src="../../js/foros/TemasAPI.js"></script>
<script src="../../js/foros/forosAlum.js"></script>
<%@ include file="../../cierra_elias.jsp" %>