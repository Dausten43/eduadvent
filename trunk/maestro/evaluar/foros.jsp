<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ include file= "../../con_elias.jsp" %>
<%@ include file= "id.jsp" %>
<%@ include file= "../../seguro.jsp" %>
<%@ include file= "../../head.jsp" %>
<%@ include file= "../../menu.jsp" %>

<link rel="stylesheet" type="text/css" href="../../css/foros/foros.css">

<%
	String maestroId 	= (String)session.getAttribute("codigoEmpleado");
	String cursoId = request.getParameter("CursoId")==null?"0":request.getParameter("CursoId");
	String cicloGrupoId = request.getParameter("CicloGrupoId")==null?"0":request.getParameter("CicloGrupoId");
%>

<script>
	const CursoId = '<%=cursoId%>';
	const CicloGrupoId = '<%=cicloGrupoId%>';
</script>
<div id="foro">
	<header>
	    <h1>Temas</h1>
	    <a href="cursos.jsp" class="btn">Regresar</a>
	    <a href="#guardarTema" class="btn btn-info" data-toggle="modal" @click="preGuardar()">Nuevo tema</a>
	</header>
	
	<section class="lista-temas">
	    <div v-for="tema in temas" class="tema" :id="tema.id">
	        <div class="maestro" :class="{'bg-blue': tema.visible, 'bg-gray': !tema.visible, 'bd-green': !tema.cerrado, 'bd-gray': tema.cerrado && !tema.visible, 'bd-blue': tema.cerrado && tema.visible}">
	            <img class="foto" src="../../maestro/evaluar/imagen.jsp?mat=<%=maestroId %>" width="300">
	        </div>
	        <div class="contenido">
	            <div class="encabezado">
	                <h3 class="titulo">{{ tema.titulo }}</h3>
	                <div>
	                    <a href="#guardarTema" data-toggle="modal" @click="preActualizar(tema.id)">
	                        <i class="icon-pencil"></i>
	                    </a>
	                    <i class="icon-remove" @click="borrar(tema.id)"></i>
	                </div>
	            </div>
	            <div>
	                <span class="badge" :class="{'bg-blue': tema.visible, 'bg-gray': !tema.visible}" >{{ tema.visible ? "Visible" : "No visible" }}</span>
	                <span class="badge" :class="{'bg-red': tema.cerrado, 'bg-green': !tema.cerrado}">{{ tema.cerrado ? "Cerrado" : "Abierto" }}</span>
	            </div>
	            <p>{{mapearFecha(tema.createdAt)}}</p>
	            <div class="descripcion" v-html="tema.descripcion"></div>
	            <button class="btn btn-info" @click="cambiarVistaAComentarios(tema.id)">Entrar</button>
	        </div>
	    </div>
	</section>
	
	<!-- MODAL -->
    <div id="guardarTema" class="modal hide fade" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                    <h3 id="modal-title">Crear nuevo tema</h3>
                </div>
                <div class="modal-body ">
                    <input type="hidden" name="id" id="id">
                    <fieldset>
                        <label for="titulo">Título:</label>
                        <input type="text" name="titulo" id="titulo" placeholder="Título"></input>
                    </fieldset>
                    <fieldset>
                        <label for="descripcion">Descripción:</label>
                        <div id="descripcion">
                        </div>
                    </fieldset>
                    <fieldset>
                        <div class="switch">
                            <input type="checkbox" name="visible" id="visible">
                            <label for="visible"></label>
                            <p>Visible</p>
                        </div>
                    </fieldset>
                    
                    <fieldset>
                        <div class="switch">
                            <input type="checkbox" name="cerrado" id="cerrado">
                            <label for="cerrado"></label>
                            <p>Cerrado</p>
                        </div>
                    </fieldset>
                </div>
                <div class="modal-footer">
                    <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> Cancelar</button>
                    <a class="btn btn-primary" data-dismiss="modal" @click="btnGuardar()"> Guardar </a>
                </div>
            </div>
        </div>
    </div>
    <!-- END MODAL -->
</div>
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>
<script src="../../js/ckeditor.js"></script>
<script src="../../js/foros/ForoUtils.js"></script>
<script src="../../js/foros/API.js"></script>
<script src="../../js/foros/TemasAPI.js"></script>
<script src="../../js/foros/foros.js"></script>
<%@ include file= "../../cierra_elias.jsp" %>