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

<link rel="stylesheet" type="text/css" href="../../css/foros/comentarios.css">

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
%>
<script>
	const CursoId = '<%=cursoId%>';
	const CicloGrupoId = '<%=cicloGrupoId%>';
	const CodigoId = '<%=codigoId%>';
	const TemaId = '<%=temaId%>';
	const Alumnos = JSON.parse('<%=cicloGrupoAlumnosJson%>');
	const Maestros = JSON.parse('<%=cicloGrupoMaestrosJson%>');
</script>
<div id="foro">

	<header>
	    <h1>{{tema.titulo}}</h1>
	    <p>{{ mapearFecha(tema.createdAt) }}</p>
	    <p><%=cursoNombre%> - [{{tema.cursoId}}]</p>
	    <span class="badge" :class="{'bg-red': tema.cerrado, 'bg-green': !tema.cerrado}">{{ tema.cerrado ? "Cerrado" : "Abierto" }}</span>
	    <div class="descripcion-tema" v-html="tema.descripcion ?? '<p>No tiene descripción</p>'"></div>
	    <a class="btn" @click="regresarATemas()">Regresar</a>
	    <a v-if="(permitido || esMaestro) && !tema.cerrado" class="btn btn-info" href="#guardarComentario" data-toggle="modal" @click="preAgregar()">COMENTAR</a>
	</header>
	
	<section v-if="permitido || esMaestro" class="lista-comentarios">
	    <div v-for="comentario in comentarios" class="comentario" :id="comentario.id">
	        <div class="comentador">
	            <picture>
	                <source :srcset="'../../maestro/evaluar/imagen.jsp?mat=' + comentario.codigoId" media="(min-width: 444px)">
	                <img class="foto" srcset="" alt="">
	            </picture>
	            <p class="nombre">{{ obtenerNombreComentador(comentario.codigoId) }}</p>
	        </div>
	        <div class="contenido">
	            <div class="encabezado">
	                <p>{{ mapearFecha(comentario.createdAt) }}</p>
	                <div>
	                	<span class="badge" :class="{'bg-gray': comentario.fijo}" :title="comentario.fijo ? 'Liberar' : 'Fijar'" @click="fijar(comentario.id)">
	                        <i class="icon-magnet icon-white"></i>
	                    </span>
	                    <span class="badge" :class="{'bg-yellow': comentario.destacado}" :title="comentario.destacado ? 'Quitar destacado' : 'Destacar'" @click="destacar(comentario.id)">
	                        <i class="icon-white" :class="{'icon-star': comentario.destacado, 'icon-star-empty': !comentario.destacado}"></i>
	                    </span>
	                    <span class="badge" href="#guardarComentario" data-toggle="modal" :title="'Editar'" @click="preEditar(comentario.id)">
	                        <i class="icon-pencil icon-white"></i>
	                    </span>
	                    <span class="badge bg-red" :title="'Borrar'" @click="borrar(comentario.id)">
	                        <i class="icon-remove icon-white"></i>
	                    </span>
	                </div>
	            </div>
	            <div class="cuerpo">
                    <div class="respuesta" v-if="comentario.respuestaId !== -1">
                        <span class="prefijo">En respuesta a</span> {{ obtenerUsuarioAResponder(comentario.respuestaId) }}:
                        <div v-html="obtenerComentarioAResponder(comentario.respuestaId)"></div>
                        <a v-if="obtenerIndexDelComentario(comentario.respuestaId) !== -1" :href="'#'+comentario.respuestaId">Ver original</a>
                    </div>
                    <div v-html="comentario.comentario"></div>
                </div>
	            <div class="responder" v-if="!tema.cerrado">
	                <a href="#guardarComentario" data-toggle="modal" @click="preResponder(comentario.id)">Responder</a>
	            </div>
	    	</div>
	    </div>
	</section>
	
	<section v-if="(permitido || esMaestro) && !tema.cerrado" class="contenedor-editor">
	    <a class="btn btn-info" href="#guardarComentario" data-toggle="modal" @click="preAgregar()">Comentar</a>
	</section>
	
	<!-- MODAL -->
    <div id="guardarComentario" class="modal hide fade" role="dialog" aria-labelledby="editComment" aria-hidden="true">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
            <h3 id="modal-title">Editar comentario</h3>
        </div>
        <div class="modal-body">
            <input type="hidden" name="id" id="id">
            <input type="hidden" name="respuestaId" id="respuestaId">
            <div id="modal-responder"></div>
            <fieldset>
                <label for="comentario">Comentario:</label>
                <div id="comentario">
                </div>
            </fieldset>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Cancelar</button>
            <a class="btn btn-primary" data-dismiss="modal" @click="btnGuardar()">Guardar</a>
      </div>
  </div>
  <!-- END MODAL -->
</div>
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>
<script src="../../js/ckeditor.js"></script>
<script src="../../js/foros/ForoUtils.js"></script>
<script src="../../js/foros/API.js"></script>
<script src="../../js/foros/ComentariosAPI.js"></script>
<script src="../../js/foros/comentarios.js"></script>
<%@ include file= "../../cierra_elias.jsp" %>