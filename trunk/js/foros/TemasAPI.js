class TemasAPI extends API {

    constructor(cursoId, cicloGrupoId){
        super();
        this.DEFAULT_DATA_TEMA = {
            cicloGrupoId,
            cursoId
        };

        this.params = {
            cursoId,
            cicloGrupoId
        };
    }

    async getAllForCurso(cursoId) {
        return await this.call('GET', {uriParams: {cursoId: cursoId, cicloGrupoId: this.params.cicloGrupoId}});
    }
    
    async getOne(id) {
        return await this.call('GET', {path: `/${id}`});
    }

    async getAll() {
		return await this.call('GET', {uriParams: this.params});
    }
    
    async save(tema) {
        return await this.call('POST', {body: {...this.DEFAULT_DATA_TEMA, ...tema}});
    }
    
    async update(tema) {
        return await this.call('PUT', {body: {...this.DEFAULT_DATA_TEMA, ...tema}});
    }
    
    async delete(id) {
        return await this.call('DELETE', {path: `/${id}/`});
    }

    async getAllComentariosFromTema(temaId) {
        return await this.call('GET', {path: `/${temaId}/comentarios/`});
    }
}