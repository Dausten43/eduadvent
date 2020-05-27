document.addEventListener('DOMContentLoaded', DOMFunctions);

function DOMFunctions() {
	const api = new TemasAPI("", CicloGrupoId);
	
	const app = new Vue({
        el: '#foro',
        data: {
            temas: [],
        },
        methods: {
            mapearFecha: (fecha) => utils.parseDate(fecha),
            
            cambiarVistaAComentarios: (temaId, cursoId) => location.assign('comentarios.jsp?' + utils.generateUriParams({id: temaId, CursoId: cursoId, CicloGrupoId})),
            
            obtenerTodos: () => {
            	CursosIds.forEach(cursoId => {
            		api.getAllForCurso(cursoId)
            		.then(temas => app.temas.push(...temas))
            		.catch(console.error);            		
            	});
            },

        }
	});
	
	app.obtenerTodos();
	
}