document.addEventListener('DOMContentLoaded', DOMFunctions);

function DOMFunctions() {

    const api = new TemasAPI(CursoId, CicloGrupoId);

    const app = new Vue({
        el: '#foro',
        data: {
            temas: [],
        },
        methods: {
            mapearFecha: (fecha) => utils.parseDate(fecha),
            
            cambiarVistaAComentarios: (temaId) => location.assign('comentarios.jsp?' + utils.generateUriParams({id: temaId,  CursoId, CicloGrupoId})),

            obtenerIndexDelTema: (id) => app.temas.findIndex(tema => tema.id === id),

            validarCamposRequeridos: (tema) => {
                if(utils.noEmptyField({ titulo: tema.titulo })){
                    return true;
                }else {
                    alert('Ingrese un título para el tema');
                    return false;
                }
            },
            
            obtenerTodos: () => {
                api.getAll()
                .then(temas => app.temas = temas)
                .catch(console.error);
            },

            guardar: (tema) => {
                if(app.validarCamposRequeridos(tema)){
                    api.save(tema)
                    .then(tema_nuevo => app.temas.unshift(tema_nuevo))
                    .catch(console.error);
                }
            },

            actualizar: (tema) => {
                if(app.validarCamposRequeridos(tema)){
                    api.update(tema)
                    .then(tema_actualizado => {
                        let tema_local = app.temas[app.obtenerIndexDelTema(parseInt(tema.id))];
                        for(let llave_atributo in tema_actualizado){
                            tema_local[llave_atributo] = tema_actualizado[llave_atributo];
                        }
                    })
                    .catch(console.error);
                }
            },

            borrar: (id) => {
                if(confirm('¿Está seguro que desea eliminar el tema?')) {
                    api.delete(id)
                    .then(() => app.temas.splice(app.obtenerIndexDelTema(id), 1))
                    .catch(console.error);
                }
            },

            btnGuardar: () => {
                let inputs = [
                    document.getElementById('id'),
                    document.getElementById('titulo'),
                    document.getElementById('visible'),
                    document.getElementById('cerrado')
                ];

                let datosFormTema = utils.fromInputsToObj(inputs);
                datosFormTema.descripcion = editor.getData();

                if(datosFormTema.id)
                    app.actualizar(datosFormTema);
                else
                    app.guardar(datosFormTema);
                    
            },

            preActualizar: (temaId) => {
                document.getElementById('modal-title').textContent = 'Actualizar tema';

                let inputs = [
                    document.getElementById('id'),
                    document.getElementById('titulo'),
                    document.getElementById('visible'),
                    document.getElementById('cerrado')
                ];

                utils.resetInputs(inputs);
                
                let tema = app.temas[app.obtenerIndexDelTema(temaId)];
                utils.setInputs(inputs, tema);

                editor.setData(`${tema.descripcion ?? ''}`);
            },

            preGuardar: () => {
                document.getElementById('modal-title').textContent = 'Crear nuevo tema';

                let inputs = [
                    document.getElementById('id'),
                    document.getElementById('titulo'),
                    document.getElementById('visible'),
                    document.getElementById('cerrado')
                ];

                utils.resetInputs(inputs);
            }
        }
    });
    
    app.obtenerTodos();

    var editor;

    ClassicEditor
	.create( document.querySelector( '#descripcion' ), {
		toolbar: {
			items: [
				'fontColor',
				'fontBackgroundColor',
				'|',
				'bold',
				'italic',
				'underline',
				'strikethrough',
				'|',
				'bulletedList',
				'numberedList',
				'|',
				'link',
				'imageUpload',
				'mediaEmbed',
				'|',
				'undo',
				'redo'
			]
		},
		link: {
			addTargetToExternalLinks: true,
		},
		mediaEmbed: {
			previewsInData: true
		},
		simpleUpload: {
			uploadUrl: '/edusystems/api/imagenes'
		},
		language: 'es',
		licenseKey: '',
		placeholder: 'Aquí puedes agregar una breve descripción'
	})
	.then( newEditor => {
		editor = newEditor;	
	})
	.catch( error => {
		console.error( 'Oops, something gone wrong with CKEditor!' );
		console.error(error);
	});  
    
}