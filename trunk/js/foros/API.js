const utils = new ForoUtils();

class API {

    async call(verb, optionalParams) {
        let { url, options } = this.configureCallOptions(verb, optionalParams);

        const response = await fetch(url, options);

        if(response.ok) {
            let data = await response.json();
            return data;
        }else {
            let responseText = await response.text();
            throw  responseText;
        }
    }

    configureCallOptions(verb, {path = null, uriParams = null, body = null}) {
        let url = "/edusystems/foros/temas";

        if (path)
            url += path;
        
        if (uriParams)
            url += '?' + utils.generateUriParams(uriParams);
        
        let options = {
            method: verb,
            headers: {
                'Content-Type': 'application/json'
            }
        };
        
        if (body)
            options.body = JSON.stringify(body);

        return { url, options };
    }
}