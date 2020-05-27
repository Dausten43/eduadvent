class ComentariosAPI extends API {

    constructor(temaId, codigoId){
        super();

        this._temaId = temaId;

        this.DEFAULT_DATA_COMENTARIO = {
            temaId,
            codigoId
        };
    }

    async getDatosTema() {
        return await this.call('GET', {path: `/${this._temaId}`});
    }

    async getAllFromTema() {
        return await this.call('GET', {path: `/${this._temaId}/comentarios/`});
    }

    async getOne(comentarioId) {
        return await this.call('GET', {path: `/${this._temaId}/comentarios/${comentarioId}`});
    }

    async save(comentario) {
        return await this.call('POST', {path: `/${this._temaId}/comentarios/`, body: {...this.DEFAULT_DATA_COMENTARIO, ...comentario}});
    }
    
    async update(comentario) {
        return await this.call('PUT', {path: `/${this._temaId}/comentarios/${comentario.id}`, body: {...this.DEFAULT_DATA_COMENTARIO, ...comentario}});
    }
    
    async delete(comentarioId) {
        return await this.call('DELETE', {path: `/${this._temaId}/comentarios/${comentarioId}`});
    }
}