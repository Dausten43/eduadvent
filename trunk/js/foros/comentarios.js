document.addEventListener('DOMContentLoaded', DOMFunctions);

function DOMFunctions() {

    const api = new ComentariosAPI(TemaId, CodigoId);

    const app = new Vue({
        el: '#foro',
        data: {
            tema: {},
            maestros: {},
            alumnos: {},
            comentarios: [],
            permitido: true,
            esMaestro: false
        },
        methods: {
            mapearFecha: (fecha) => {if(fecha) return utils.parseDate(fecha)},
            
            regresarATemas: () => location.assign('foros.jsp?' + utils.generateUriParams({ CursoId, CicloGrupoId })),

            obtenerIndexDelComentario: (id) => app.comentarios.findIndex(comentario => comentario.id === id),

            obtenerNombreComentador: (codigoId) => codigoId.includes("E") ? app.maestros[codigoId] : app.alumnos[codigoId],

            validarCamposRequeridos: (comentario) => {
                if(utils.noEmptyField({ comentario: comentario.comentario })){
                    return true;
                }else {
                    alert('Ingrese un título para el comentario');
                    return false;
                }
            },

            obtenerTodo: () => {
                 api.getDatosTema()
                .then(tema => app.tema = tema)
                .catch(console.error)
				.finally(() => {
					app.permitido = app.tema &&
									app.tema.visible &&
				                    (
				                        app.tema.cicloGrupoId === CicloGrupoId &&
				                        app.tema.cursoId === CursoId
				                    );
				    app.esMaestro = CodigoId.includes('E');
				    if(app.permitido || app.esMaestro)
				    	 app.obtenerComentarios();
				});
            },
            
            obtenerComentarios: () => {
                api.getAllFromTema()
                .then(comentarios => app.comentarios = comentarios)
                .catch(console.error);
            },

            guardar: (comentario) => {
                if(app.validarCamposRequeridos(comentario)){
                    api.save(comentario)
                    .then(comentario_nuevo => app.comentarios.push(comentario_nuevo))
                    .catch(console.error);
                }
            },

            actualizar: (comentario) => {
                if(app.validarCamposRequeridos(comentario)){
                    api.update(comentario)
                    .then(comentario_actualizado => {
                        let comentario_local = app.comentarios[app.obtenerIndexDelComentario(parseInt(comentario.id))];
                        for(let llave_atributo in comentario_actualizado){
                            comentario_local[llave_atributo] = comentario_actualizado[llave_atributo];
                        }
                    })
                    .catch(console.error);
                }
            },

            borrar: (id) => {
                if(confirm('¿Está seguro que desea eliminar el comentario?')) {
                    api.delete(id)
                    .then(() => app.comentarios.splice(app.obtenerIndexDelComentario(id), 1))
                    .catch(console.error);
                }
            },

            destacar: (id) => {
                let comentario = app.comentarios[app.obtenerIndexDelComentario(parseInt(id))];
                comentario.destacado = !comentario.destacado;
                app.actualizar(comentario);
            },

            btnGuardar: () => {
            	let inputs = [
                    document.getElementById('id'),
                    document.getElementById('respuestaId'),
                ];

                let datosFormComentario = utils.fromInputsToObj(inputs);
                datosFormComentario.comentario = editor.getData();
                
                if(datosFormComentario.id)
                    app.actualizar(datosFormComentario);
                else
                    app.guardar(datosFormComentario);
            },

            preAgregar: () => {
            	document.getElementById('modal-title').textContent = 'Agregar nuevo comentario';
                document.getElementById('modal-responder').innerHTML = '';
                
                let inputs = [
                    document.getElementById('id'),
                    document.getElementById('respuestaId'),
                ];
                
                utils.resetInputs(inputs);
                editor.setData('');
                document.getElementById('respuestaId').value = -1;
            },

            preEditar: (comentarioId) => {
            	document.getElementById('modal-title').textContent = 'Editar comentario';
                document.getElementById('modal-responder').innerHTML = '';

                let inputs = [
                    document.getElementById('id'),
                    document.getElementById('respuestaId'),
                ];

                utils.resetInputs(inputs);
                
                let comentario = app.comentarios[app.obtenerIndexDelComentario(comentarioId)];
                utils.setInputs(inputs, comentario);
                editor.setData(comentario.comentario);
            },

            preResponder: (comentarioId) => {
            	document.getElementById('modal-title').textContent = 'Responder comentario';

                let inputs = [
                    document.getElementById('id'),
                    document.getElementById('respuestaId'),
                ];

                utils.resetInputs(inputs);
                editor.setData('');

                let comentario = app.comentarios[app.obtenerIndexDelComentario(comentarioId)];
                document.getElementById('modal-responder').innerHTML = `<div id="respuesta">${comentario.comentario}</div>`;
                document.getElementById('respuestaId').value = comentario.id;
            },

            obtenerComentarioAResponder: (respuestaId) => {
				const comentarioRespondido = app.comentarios[app.obtenerIndexDelComentario(respuestaId)];
				if (comentarioRespondido !== undefined)
					return comentarioRespondido.comentario;
				else if(respuestaId !== -1)
                    return '~~ Comentario eliminado';
			},

            obtenerUsuarioAResponder: (respuestaId) => {
				const comentarioRespondido = app.comentarios[app.obtenerIndexDelComentario(respuestaId)];
				if (comentarioRespondido !== undefined)
					return comentarioRespondido.codigoId.includes('E') ? app.maestros[comentarioRespondido.codigoId] : app.alumnos[comentarioRespondido.codigoId];
			}
        }
    });

    app.maestros = Maestros;
    app.alumnos = Alumnos;
    app.obtenerTodo();
    
    var editor;

    InlineEditor
    .create(document.querySelector('#comentario'), {
        toolbar: [ 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', '|', 'mediaEmbed', '|', 'undo', 'redo'],
        mediaEmbed: {
            previewsInData: true
        },
        placeholder: 'Escribe aquí la descripción del tema'
    })
    .then(newEditor => editor = newEditor)
    .catch(error => {
        console.error(error);
    });
}